<?php

namespace LinkPanel\WebApp\Installers\Resources;

use LinkPanel\System\LinkPanelApp;

class ComposerResource {
	private $project;
	private $folder;
	private $appcontext;

	public function __construct(LinkPanelApp $appcontext, $data, $destination) {
		$this->folder = dirname($destination);
		$this->project = basename($destination);
		$this->appcontext = $appcontext;
		if (empty($data["version"])) {
			$data["version"] = 2;
		}

		$this->appcontext->runComposer(
			[
				"create-project",
				"--no-progress",
				"--prefer-dist",
				$data["src"],
				"-d " . $this->folder,
				$this->project,
			],
			$status,
			$data,
		);

		if ($status->code !== 0) {
			throw new \Exception("Error fetching Composer resource: " . $status->text);
		}
	}
}
