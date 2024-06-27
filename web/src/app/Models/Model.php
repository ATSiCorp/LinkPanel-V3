<?php

declare(strict_types=1);

namespace LinkPanel\Models;

class Model {
	public function __construct() {
	}

	public static function all() {
	}
}

/**
 * Minimal list of models required
 *
 * User
 *
 * WebDomain
 *
 * MailDomain
 * `-MailAccount
 *
 * DNSDomain
 * `-DNSRecord
 *
 * Database
 *
 */
