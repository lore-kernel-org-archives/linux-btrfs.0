Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636C26AC3
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774854604; cv=none; b=JBFYLcJ6wgRu2fTOoTnc6iQCfESY7GwI7jC6t7o77cSl+nirjTJC5IglWMr7NTmOJ9xJ2b/tZXjOFfV0AnoqSMj6H78KeQKvyaBiTaqFfT+SnzRLYxL8JtB4ucrJiIC/rQ01Zk+mzTUFvcD4KqZ3Zr+P5vXiyl3JLb6KVXPkZMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774854604; c=relaxed/simple;
	bh=aVIyA0G92Y81+qm3NIjA+FesQsEjYUOgU0kqRRXU+uM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rxpGgOvhvjs9wnw5PnS3dY5pFjP1NuCpiC/ShiHRL1BwuU/Lx3zo9aipHpBgdBXmxEVvTqszi2rQMDsBhnsv3up/vgj6fICmx1iyRErbq9i9IHx0BVyrpYxZMMOt9OQlQl9joTLZ0LQ1GpLawUW5IisS22yGMK/DANBdcuKoy3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=plwI5shU; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=plwI5shU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="plwI5shU";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="plwI5shU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 480754D1F1
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2S4PkrzZZekfd2iLw4cIcUm7nz88U4jlNcvCK6/Sdm0=;
	b=plwI5shUpWen6I4Q23mbYYg1CWO2oQYpy9dIxwy1gxHvhH167+EtJ9jf1eeTDKhxTuploG
	T7DbhkB2UXVjkesDpqP08nneiYP1QV9rhrDaWGtcomKeJC0SKbmE7pYC7Q6BQjakC4matf
	dTc1YXraC2doXROlw5yTPmGlKoc+gCw=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=plwI5shU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2S4PkrzZZekfd2iLw4cIcUm7nz88U4jlNcvCK6/Sdm0=;
	b=plwI5shUpWen6I4Q23mbYYg1CWO2oQYpy9dIxwy1gxHvhH167+EtJ9jf1eeTDKhxTuploG
	T7DbhkB2UXVjkesDpqP08nneiYP1QV9rhrDaWGtcomKeJC0SKbmE7pYC7Q6BQjakC4matf
	dTc1YXraC2doXROlw5yTPmGlKoc+gCw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8079A4A0A2
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yExZEMghymk8DgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:00 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs-progs: mkfs/rootdir: cleanup and new fiemap based prealloc detection
Date: Mon, 30 Mar 2026 17:39:34 +1030
Message-ID: <cover.1774854459.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 480754D1F1
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The PR can be found here:

  https://github.com/kdave/btrfs-progs/pull/1103

Although previously I added a SEEK_DATA/SEEK_HOLE based hole detection,
it doesn't distinguish holes from preallocated ranges.
Thus if a rootdir contains some preallocated extents and the end user
also expects such preallocated space in the target fs, they will be
replaced by holes.

The 3rd patch adds such detection using fiemap, which can also detect
holes.
For preallocated space we now can create reserved data extent without
data checksum.

The first two patches are mostly cleanups, to disentangle the complex
add_file_item_extent() function, so that compressed fall back is more
straightforward.

The last patch is a simple functional test for the new fiemap feature.

Qu Wenruo (4):
  btrfs-progs: mkfs/rootdir: use a helper to read from source fs
  btrfs-progs: mkfs/rootdir: extract compressed write path
  btrfs-progs: mkfs/rootdir: use fiemap to do prealloc detection
  btrfs-progs: mkfs-tests: add a new test case for fiemap based
    detection

 kernel-shared/file-item.h                     |   3 -
 mkfs/rootdir.c                                | 400 ++++++++++++------
 tests/mkfs-tests/042-fiemap-detection/test.sh |  76 ++++
 3 files changed, 348 insertions(+), 131 deletions(-)
 create mode 100755 tests/mkfs-tests/042-fiemap-detection/test.sh

--
2.53.0

