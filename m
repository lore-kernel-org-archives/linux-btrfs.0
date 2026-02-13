Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC18B27EFE3
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2026 18:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771009015; cv=none; b=AAo5nTW6OUxByDiyhwSdeemYR5NLe87UvtyLr6tBtMTV9S1Yrdrw04n5odyKHCxhZEYeSjQUituwVMxzgXwPU2l4Bltj+xszQHU1bp8JGbc+BnVOnj09WL3OdjbrHmm3r/mCS3acRLZ9Qq1R5BI/cH5GMoKXREaK7ma/6lRRuc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771009015; c=relaxed/simple;
	bh=1ceCPA+3Uwk0RtxejDx0wMp4s6v5xuD5+5UxgJp4thg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EYz3QCz7SNO4uRr6yUntC5SepGaa0NeCrV3zUe/ekwruxWarm9nMe0KIGxdfFqBSJBvIzvXidlwPWx0/vTwjOxqxSzzhgfUyzuFCKNSPe+WLXSYuJkv6WStfCyCovzQj47E2Z2Kov6p0zfZWpd2e2wCJxVq05eyjUb0AkCChJRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Nx77Y2cN; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Nx77Y2cN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Nx77Y2cN";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Nx77Y2cN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 23BC35BCDE
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2026 18:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771009012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MU4yHQ7iRCRO+6uZM449HSJfM6rkjocSYZpaqoONl0Q=;
	b=Nx77Y2cNmisOkFBJo9jsqumLfy/1idZYQ13qXsq56N6tMYBBenp6pVWuYNrU70XzbM36ot
	319gdKD5MJDsovAwAIQjDV7a8koRxKTNRxMgeZIZMtx9E8grZvnWAGrZNNTdY1jmNiYaon
	acdUqIwhtLxLIdO2J8delY2yTOWv0vI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771009012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MU4yHQ7iRCRO+6uZM449HSJfM6rkjocSYZpaqoONl0Q=;
	b=Nx77Y2cNmisOkFBJo9jsqumLfy/1idZYQ13qXsq56N6tMYBBenp6pVWuYNrU70XzbM36ot
	319gdKD5MJDsovAwAIQjDV7a8koRxKTNRxMgeZIZMtx9E8grZvnWAGrZNNTdY1jmNiYaon
	acdUqIwhtLxLIdO2J8delY2yTOWv0vI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 123063EA62
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2026 18:56:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /SpvBPRzj2m2SQAAD6G6ig
	(envelope-from <dsterba@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2026 18:56:52 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 6.19
Date: Fri, 13 Feb 2026 19:56:46 +0100
Message-ID: <20260213185647.21966-1-dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

Hi,

btrfs-progs version 6.19 have been released (ther version 6.18 has been skipped).

There's change in mkfs.btrfs defaults, the block group tree is now enabled. A
note is printed (which was a last minute change and the release was redone, the
top commit is 9ac9a97ee3ebcc71).

Changelog:

* mkfs:
  * make block-group-tree default (support since linux 6.1), use -O ^bgt to
    unset it for backward compatibility
  * speed up initial device discard by procesing the ranges in order
  * disable block-grooup-tree feature if a dependent feature is explicitly
    unselected (like disabling no-holes), instead of erroring out
* check:
  * add ability to detect and fix missing orphan items in deleted subvolumes
  * add ability to fix inode refs from directory items
  * enhance detection on unknown inode keys
* libbtrfsutil:
  * minor version update to 1.4.0
  * add missing aliases for API updates done in 0.1.3, C and python
* libbtrfs:
  * patchlevel version update 0.1.5
  * error handling updates
* fixes:
  * with DUP profile and mixed sequential and conventional zoned make sure
    to track the right write pointers
  * scrub: fix ETA wraparound calculations, when many files get deleted
    during the operation bytes_scrubbed and bytes_total get too much out of
    sync, the ETA will be 0
* corrupt-block: add ability to specify key value when corrupting item keys
* experimental features:
  * initial remap tree support (new logical-to-logical mapping layer),
    coming in linux 7.0
* other:
  * documentation updates
  * CI updates, new and updated tests
  * code cleanups and refactoring

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
Release: https://github.com/kdave/btrfs-progs/releases/tag/v6.19
Python: https://pypi.org/project/btrfsutil/
