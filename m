Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4798E397E9F
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554482; cv=none; b=RWYDS932zVgUqykqSozt5yqz6fahiP1eB5WTpAHmJ2dhC3CdYEfJvNtYwomMO4ERFnYSZHF0XC0cDrE76LTFy6BzyTUY5JX4qJObAQlmCP2I/yNrs7SxjB3t/2KkimibNhcoZhq461H53a/ViMMxhoeBpAddPdARta6ERd6gSKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554482; c=relaxed/simple;
	bh=Oux+U21/EX7fmdmiRPlujAP8lWHl+xlTtNzCpPYx49g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGe9cezEOJ4hDyRV4AkJFYBZj8yKd2jL4/Gl5hEwTkoe+B2bgTXF42jQ4KTNxsUHO6ir2MaPAGlpSPDw2uaeboRuYqwPpDlGIJmNCWCFA2/p1QSEqXrFNYNB9OAnL+LacdEMwpt00kNuffN4+RWIbh2G1k2HvuHruQvUCaMTH4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ijhbYEC2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ijhbYEC2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ijhbYEC2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ijhbYEC2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6FC774E3AD
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qw7Ggo1WGdVoMTlgyGb5ZkflfVVI1Lb1IYjDtnVJ4tA=;
	b=ijhbYEC2gt7mpjyYKeZbbZbmnf9SFDKNzL9Nd5I1TRIKaw90S6N1RrrDq8YyBvOfrVe0b8
	NqXq1APf8+Qv0OrdXwrro+E1ZFtt07ISoX5YsN9afs9MavX1k8bZKg2OW0LkiYtFQtitKK
	sUegFZUOzDdWzWqNTAHOxTKM2CDanLI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qw7Ggo1WGdVoMTlgyGb5ZkflfVVI1Lb1IYjDtnVJ4tA=;
	b=ijhbYEC2gt7mpjyYKeZbbZbmnf9SFDKNzL9Nd5I1TRIKaw90S6N1RrrDq8YyBvOfrVe0b8
	NqXq1APf8+Qv0OrdXwrro+E1ZFtt07ISoX5YsN9afs9MavX1k8bZKg2OW0LkiYtFQtitKK
	sUegFZUOzDdWzWqNTAHOxTKM2CDanLI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 622EC4A0B0
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qP1LBKHP1GkOYAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2026 09:34:25 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: always update/create the dev stats item when adding a new device
Date: Tue,  7 Apr 2026 19:04:00 +0930
Message-ID: <c91b7c64bcb331b03831c9d8018f6791ca70c82e.1775553952.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775553952.git.wqu@suse.com>
References: <cover.1775553952.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

[MINOR PROBLEM]
When adding a new btrfs device, the corresponding DEV_STATS item creation
can only triggered by a mount cycle if there is no other error
triggered:

 # mkfs.btrfs -f $dev1 $mnt
 # mount $dev1 $mnt
 # btrfs dev add $dev2 $mnt
 # sync
 # btrfs ins dump-tree -t dev $dev1
 device tree key (DEV_TREE ROOT_ITEM 0)
 leaf 30588928 items 6 free space 15853 generation 9 owner DEV_TREE
	item 0 key (DEV_STATS PERSISTENT_ITEM 1) itemoff 16243 itemsize 40 <<<
		persistent item objectid DEV_STATS offset 1
		device stats
		write_errs 0 read_errs 0 flush_errs 0 corruption_errs 0 generation 0
	item 1 key (1 DEV_EXTENT 13631488) itemoff 16195 itemsize 48

Only after a mount cycle and a new transaction, the DEV_STATS for devid
2 can show up:

 # umount $mnt
 # mount $dev1 $mnt
 # touch $mnt
 # sync
 # btrfs ins dump-tree -t dev $dev1
 device tree key (DEV_TREE ROOT_ITEM 0)
 leaf 30605312 items 7 free space 15788 generation 10 owner DEV_TREE
	item 0 key (DEV_STATS PERSISTENT_ITEM 1) itemoff 16243 itemsize 40
		persistent item objectid DEV_STATS offset 1
		device stats
		write_errs 0 read_errs 0 flush_errs 0 corruption_errs 0 generation 0
	item 1 key (DEV_STATS PERSISTENT_ITEM 2) itemoff 16203 itemsize 40
		persistent item objectid DEV_STATS offset 2
		device stats
		write_errs 0 read_errs 0 flush_errs 0 corruption_errs 0 generation 0

[CAUSE]
Btrfs only updates the DEV_STATS item when the device->dev_stats_ccnt
counter is not 0.

This is to reduce COW for the device tree. However that dev_stats_ccnt is
only increased at the following call sites:

- btrfs_dev_stat_inc()
  This happens when some IO error happened.

- btrfs_dev_stat_read_and_reset()
  This happens for GET_DEV_STATS ioctl with BTRFS_DEV_STATS_RESET flag.

- btrfs_dev_stat_set()
  This happens inside btrfs_device_init_dev_stats().

So when a new device is added, its dev_stats_ccnt is just initialized to
0, and btrfs won't create nor update the corresponding DEV_STATS item at
all.

[ENHANCEMENT]
When a new device is added, also increase the dev_stats_ccnt by one.
This includes both device add ioctl and dev-replace.

This will force btrfs to create a new DEV_STATS item or update the
existing one with the correct values.

This not only makes the DEV_STATS creation early, but also prevents
old DEV_STATS left from older kernels to cause false alerts for the
newly added device.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dev-replace.c | 2 ++
 fs/btrfs/volumes.c     | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 5ea14d74824d..5bcc26b4022d 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -307,6 +307,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	device->bdev_file = bdev_file;
 	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	set_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
+	/* Check the comment in btrfs_init_new_device() for the reason. */
+	atomic_inc(&device->dev_stats_ccnt);
 	device->dev_stats_valid = 1;
 	set_blocksize(bdev_file, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_devices;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5e47157fa86d..09d6382beda5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2927,6 +2927,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->commit_total_bytes = device->total_bytes;
 	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	clear_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
+
+	/*
+	 * Increase dev_stats_ccnt so that corresponding DEV_STATS item
+	 * can be created at the next transaction commit.
+	 */
+	atomic_inc(&device->dev_stats_ccnt);
 	device->dev_stats_valid = 1;
 	set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
 
-- 
2.53.0

