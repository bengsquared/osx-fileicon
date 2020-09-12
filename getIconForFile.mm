#include <AppKit/AppKit.h>
#include <nan.h>
#include <string>
#include <Cocoa/Cocoa.h>
#include <QuickLook/QuickLook.h>

void RunCallback(const Nan::FunctionCallbackInfo<v8::Value>& info) {

	v8::Isolate* isolate = info.GetIsolate();

	v8::String::Utf8Value value(isolate, info[0]);
	const char* path = *value;
	NSString* filePath = [NSString stringWithUTF8String: path];
	NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:true] forKey:(NSString *)kQLThumbnailOptionIconModeKey];
	CGImageRef ref = QLThumbnailImageCreate(kCFAllocatorDefault, (CFURLRef)fileURL, CGSizeMake(500, 500), (CFDictionaryRef)dict);

	NSImage* sourceImage = nil;

	if (ref != NULL) {
		NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
		if (bitmapImageRep) {
			sourceImage = [[NSImage alloc] initWithSize:[bitmapImageRep size]];
			[sourceImage addRepresentation:bitmapImageRep];
			[bitmapImageRep release];
		}
		CFRelease(ref);
	}

	if (!sourceImage) sourceImage = [[NSWorkspace sharedWorkspace] iconForFile:filePath];

	NSData* tiffData = [sourceImage TIFFRepresentation];
	NSBitmapImageRep* bitmapRep = [NSBitmapImageRep imageRepWithData:tiffData];
	NSData* pngData = [bitmapRep representationUsingType:NSPNGFileType properties:[NSDictionary dictionary]];

	v8::Local<v8::Function> cb = info[1].As<v8::Function>();
	const char* rawBytes = reinterpret_cast<const char*>([pngData bytes]);
  v8::Local<v8::Value> argv[1] = {
		Nan::CopyBuffer(rawBytes, [pngData length]).ToLocalChecked()
	};
  Nan::AsyncResource resource("nan:makeCallback");
  resource.runInAsyncScope(Nan::GetCurrentContext()->Global(), cb, 1, argv);
}

void Init(v8::Local<v8::Object> exports, v8::Local<v8::Object> module) {
  Nan::SetMethod(module, "exports", RunCallback);
}

NODE_MODULE(getIconForFile, Init)
