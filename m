Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D108399372
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780999346; cv=none; b=TmYYixPTM7VW3n8v5TSVR8yvUmXqvdMX9DcbYWjNwoeCmWco1ICyM+xMAFn2fEqroxfwUTwgTUSopmg+KfH9tOIiJmp0EASmErtK3WvJPlMUI9Sx3P9bSvbAEYCrQ6+Z+N+UFLP3apIdnnbc5ZdILWFoIxnWpqxNe5GLi/LA0v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780999346; c=relaxed/simple;
	bh=sZ0y1SdGZPNHhasYpj6UtgNATKW6sMFHJ95aKZmQAXg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qadvycFALJp1tZv6M+ZT5ek+ZDZIpf6QLL3nTdNiZitfGZ9lSTEJnsylFyaWDEcUuEiEH4J05gQoniTn54w9SlnSq52v9lMNtvgYf3YHplPL6rZF4068OsZwC3ohaR/YCmcCx8eWOkqK0hzaSVqsKLtGlwJkbijmuD2ppmLqfBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QN7EitBm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QN7EitBm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QN7EitBm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QN7EitBm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 863AB75952
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 10:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780999343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=APuB4hKlDtvoNFt14oKStZZBS887UsxgHXFUXkCFKDs=;
	b=QN7EitBmMqSTDDRywQZUon08a6w5mCzP6K8PxPkYQLfdFiWGMsn9ReLuIf2Xj0IMA7x02i
	3xnx3DwmMqQrFOBj4aEOJFFJtdWaXlsKmBiAA/6mi27YHRg429k4AVQ/9mErQBlYP/5Mf5
	s8dDIGLBgwcN7gWSFupDg5/8IZR5EDc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780999343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=APuB4hKlDtvoNFt14oKStZZBS887UsxgHXFUXkCFKDs=;
	b=QN7EitBmMqSTDDRywQZUon08a6w5mCzP6K8PxPkYQLfdFiWGMsn9ReLuIf2Xj0IMA7x02i
	3xnx3DwmMqQrFOBj4aEOJFFJtdWaXlsKmBiAA/6mi27YHRg429k4AVQ/9mErQBlYP/5Mf5
	s8dDIGLBgwcN7gWSFupDg5/8IZR5EDc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8809A779A7
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 10:02:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wsIjBa7kJ2rmQgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 10:02:22 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: disable v1 space cache
Date: Tue,  9 Jun 2026 19:31:44 +0930
Message-ID: <0884d7707a725ce5a41ea3931d65dabc76a5c864.1780999298.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Level: 

V2 space cache is already the default mkfs option since btrfs-progs
v5.15, and commit 1e7bec1f7d65 ("btrfs: emit a warning about space cache
v1 being deprecated") has already added a warning to show v1 space cache
is already deprecated.

It has been long enough that we should remove v1 space cache completely.

As the first step, disable v1 space cache by:

- Make "space_cache" mount option fallback to "nospace_cache"
- Make "space_cache=v1" to fallback to "nospace_cache"
  Which is the safer than forcing "space_cache=v2", as forcing v2 cache
  will require removal of v1 cache and regenerate v2 cache.
  Such operation can be slow, and will take extra metadata space, thus
  it is not always safe for existing filesystems.

With this done, v1 cache mount will always fallback to nospace cache,
and mount option will not be able to force v1 space cache usage.

For example, even for a fs with v1 cache:

 # btrfs ins dump-super test.img
 superblock: bytenr=65536, device=test.img
 ---------------------------------------------------------
 csum_type		0 (crc32c)
 csum_size		4
 csum			0xdce44b2c [match]
 bytenr			65536
 flags			0x1
 			( WRITTEN )
 magic			_BHRfS_M [match]
 fsid			7d7c3bba-8211-4206-868d-10eedd5703f8
 metadata_uuid		00000000-0000-0000-0000-000000000000
 label
 generation		9
 root			30605312
 [...]
 compat_ro_flags		0x0 << No FST feature
 incompat_flags		0x361
 			( MIXED_BACKREF |
 			  BIG_METADATA |
 			  EXTENDED_IREF |
 			  SKINNY_METADATA |
 			  NO_HOLES )
 cache_generation	9 <<< Matches generation
 uuid_tree_generation	9

Mounting it will lead to no space cache other than v1 space cache:

 # mount test.img /mnt/btrfs
 # dmesg -t | tail -n 5
 BTRFS: device fsid 7d7c3bba-8211-4206-868d-10eedd5703f8 devid 1 transid 9 /dev/loop0 (7:0) scanned by mount (1264)
 BTRFS info (device loop0): first mount of filesystem 7d7c3bba-8211-4206-868d-10eedd5703f8
 BTRFS info (device loop0): using crc32c checksum algorithm
 BTRFS info (device loop0): turning on async discard
 BTRFS info (device loop0): last unmount of filesystem 7d7c3bba-8211-4206-868d-10eedd5703f8

Even forcing v1 cache will not work, but fallback to the usual
nospace_cache:

 # mount test.img -o space_cache=v1 /mnt/btrfs
 # dmesg -t | tail -n 6
 BTRFS warning: v1 space cache is deprecated, fallback to no space cache
 BTRFS: device fsid 7d7c3bba-8211-4206-868d-10eedd5703f8 devid 1 transid 9 /dev/loop0 (7:0) scanned by mount (1264)
 BTRFS info (device loop0): first mount of filesystem 7d7c3bba-8211-4206-868d-10eedd5703f8
 BTRFS info (device loop0): using crc32c checksum algorithm
 BTRFS info (device loop0): turning on async discard
 BTRFS info (device loop0): last unmount of filesystem 7d7c3bba-8211-4206-868d-10eedd5703f8

And there will be no way to force converting a v2 cache back to v1, such
attempt will only clear free space tree and fallback to no space cache.

 # mkfs.btrfs -f -O fst,^bgt test.img
 # mount -o clear_cache,space_cache=v1 test.img /mnt/btrfs
 # dmesg -t | tail -n 11
 BTRFS warning: v1 space cache is deprecated, fallback to no space cache
 BTRFS: device fsid f59daad2-3ab5-4f33-b752-a36cfb09b674 devid 1 transid 8 /dev/loop0 (7:0) scanned by mount (1419)
 BTRFS info (device loop0): first mount of filesystem f59daad2-3ab5-4f33-b752-a36cfb09b674
 BTRFS info (device loop0): using crc32c checksum algorithm
 BTRFS info (device loop0): rebuilding free space tree
 BTRFS info (device loop0): disabling free space tree
 BTRFS info (device loop0): clearing compat-ro feature flag for FREE_SPACE_TREE (0x1)
 BTRFS info (device loop0): clearing compat-ro feature flag for FREE_SPACE_TREE_VALID (0x2)
 BTRFS info (device loop0): checking UUID tree
 BTRFS info (device loop0): turning on async discard
 BTRFS info (device loop0): force clearing of disk cache
 # mount | grep /mnt/btrfs
 /home/adam/test.img on /mnt/btrfs type btrfs (rw,relatime,discard=async,nospace_cache,subvolid=5,subvol=/)

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9de67276a8ed..577e945c8214 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -513,19 +513,20 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		btrfs_clear_opt(ctx->mount_opt, NODISCARD);
 		break;
 	case Opt_space_cache:
-		if (result.negated) {
-			btrfs_set_opt(ctx->mount_opt, NOSPACECACHE);
-			btrfs_clear_opt(ctx->mount_opt, SPACE_CACHE);
-			btrfs_clear_opt(ctx->mount_opt, FREE_SPACE_TREE);
-		} else {
-			btrfs_clear_opt(ctx->mount_opt, FREE_SPACE_TREE);
-			btrfs_set_opt(ctx->mount_opt, SPACE_CACHE);
-		}
+		if (!result.negated)
+			btrfs_warn(NULL,
+				   "v1 space cache is deprecated, falling back to no space cache");
+		btrfs_set_opt(ctx->mount_opt, NOSPACECACHE);
+		btrfs_clear_opt(ctx->mount_opt, SPACE_CACHE);
+		btrfs_clear_opt(ctx->mount_opt, FREE_SPACE_TREE);
 		break;
 	case Opt_space_cache_version:
 		switch (result.uint_32) {
 		case Opt_space_cache_v1:
-			btrfs_set_opt(ctx->mount_opt, SPACE_CACHE);
+			btrfs_warn(NULL,
+				   "v1 space cache is deprecated, falling back to no space cache");
+			btrfs_set_opt(ctx->mount_opt, NOSPACECACHE);
+			btrfs_clear_opt(ctx->mount_opt, SPACE_CACHE);
 			btrfs_clear_opt(ctx->mount_opt, FREE_SPACE_TREE);
 			break;
 		case Opt_space_cache_v2:
-- 
2.54.0

