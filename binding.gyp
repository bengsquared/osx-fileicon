{
	"targets": [{
		"target_name": "getIconForFile",
		"include_dirs": ["<!(node -e \"require('nan')\")"],
		"conditions": [[
			'OS=="mac"',
			{
				"sources": ["getIconForFile.mm"],
				"link_settings": {
					"libraries": ["-framework AppKit -framework QuickLook"]
				}
			}
		]
		]
	}]
}
