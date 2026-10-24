Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792880317;
	b=NEqdmYBJDxBBeGj8rpelIMYELBqvYpqx3kil4WS7zlTYd4A7J3zgdidK7ilIr/rdIeJQ
	 KFFqq7+gL0wXFHey/Ws/FyQ6evJPEH/NM/rp5SuTMc0AV5JOJiiBvU90WcBsQkAy0YUmG
	 K9XL9/zkTKgRKvCH6a8Iz540/aSARvCB7pAQ13dg1O5fYCDycJ0KPIvRa7GjbizaVuK8e
	 XCL7D9VEz5yjlVq2V2z5hYiOqWwWl5aAxyJt6qml+Iqmd4SICSOFc76RuTsH2AxK93O3g
	 5TpgRusCPio62D9nZOuBL/lPM2ejCiCrjYrSsjRlljQIcGUhsKrdB33dt6xHkbuzyHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792880317;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=z5fCehIQjtJeJSTf/LQjeXvKM10m/o8XHbzbujSckNM=;
	b=qKKn4bWx2Q3JTM4EAuPEMWZiHwm/H/jwNJ+Ak/dnGR7VyA5jXbrSC8m4cxn8Zzl+w4DK
	 z9OiRo/p78tQgtfnUs3mRwaUBX/ecM330NN71Nh/qHTy87S//qxTfjgC9lobQ4lScWKvk
	 WCX7etHdHjCX79s4jSbCSVnCc3b0QrScAMXtguaIJfIBKusTElkV+L3cCV+T/wUBzPJjl
	 39vqa8FZnslN/U/2rQhysyZYOzT9ZP6K7ncxmEYMjdSGDDwvfUd3yc+YxwUZY4fIj652f
	 CLsweYp+OCX3vy81iD4VpbC45AXaDYZ1FDqpzHNePILhmVULdmc/XcW7m+ZoCYfyLbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZxP29xXt;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZxP29xXt;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D2B606A31A
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Oct 2026 22:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86D2B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZxP29xXt;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZxP29xXt
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76B951F801;
	Sat, 24 Oct 2026 22:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792880308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=z5fCehIQjtJeJSTf/LQjeXvKM10m/o8XHbzbujSckNM=;
	b=ZxP29xXtSltVvSOs4NBmBS6z3NIRVIZmcNQdZyXlClq7n9Pn8KQz8Eim27DC0uQNEHvtM4
	zCNtjSRM9FRCvuDsnx+EXuezmxI8fslEHvKGudr1xyjoAtQQFfpJZ40k7TR5ZOr0vIHPYa
	J9w9I6FgG1cmWCxD9ONdjVNN15L4cGM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792880308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=z5fCehIQjtJeJSTf/LQjeXvKM10m/o8XHbzbujSckNM=;
	b=ZxP29xXtSltVvSOs4NBmBS6z3NIRVIZmcNQdZyXlClq7n9Pn8KQz8Eim27DC0uQNEHvtM4
	zCNtjSRM9FRCvuDsnx+EXuezmxI8fslEHvKGudr1xyjoAtQQFfpJZ40k7TR5ZOr0vIHPYa
	J9w9I6FgG1cmWCxD9ONdjVNN15L4cGM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA3D3133F3;
	Sat, 24 Oct 2026 22:18:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d336DLIu3WrwKAAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 24 Oct 2026 22:18:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com
Subject: [PATCH] btrfs: validate but do not set bdev blocksize
Date: Sun, 25 Oct 2026 08:48:08 +1030
Message-ID: <3960faa4b91ff80bc20efa9e1eb90fde2a953628.1792880281.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[5c01398781fb51df783a];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,appspotmail.com:email,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

[BACKGROUND]
In the very early days, commit 325cd4bafeb6 ("Btrfs: properly set
blocksize when adding new device.") set the bdev blocksize as at that
time btrfs is using __bread() for super block IO, which went through
buffer heads thus requires the strict block size limit.

Then btrfs super block IO moved away from buffered heads, by commit
8f32380d3f29 ("btrfs: use the page cache for super block reading") and
commit 314b6dd0eebf ("btrfs: use bios instead of buffer_heads from super
block writeout").

So after that there is already no strict blocksize requirement for
btrfs, except the bdev's block size should not exceed 4K, which is also
the super block size of btrfs.

Btrfs data read/writes all follow sectorsize, which can be larger than
4K.
Btrfs metadata read/writes all follow nodesize, which is already 16K by
default.

Furthermore, there is already a bug report that set_blocksize() can
trigger a lockdep warning from btrfs, as set_blocksize() will acquire
inode lock, and under certain races can lead to lockdep warnings.

[ENHANCEMENT]
Remove the set_blocksize() calls, instead call bdev_validate_blocksize()
inside btrfs_open_device_deny_freeze() and btrfs_get_bdev_and_sb().

Btrfs doesn't use buffer heads, thus no strict set_blocksize()
requirement. But we still want to call bdev_validate_blocksize(), just in
case where a future block device with larger blocksize (e.g. 16K) shows
up.

For such devices btrfs super block bios will be rejected, so we want to call
bdev_validate_blocksize() early to reject such devices.

Furthermore, the bdev_validate_blocksize() itself is lockless, thus it
should resolve the lockdep report from syzbot.

Reported-by: syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6adcb3be.4ce6c07b.2dfc0c.0005.GAE@google.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dev-replace.c |  3 +--
 fs/btrfs/disk-io.h     |  3 +--
 fs/btrfs/volumes.c     | 27 +++++++++++++++++----------
 fs/btrfs/volumes.h     |  4 ++--
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index cdfe093e5c5c..3c48cc714fef 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -249,7 +249,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Unfreezable for the whole replace; see btrfs_dev_replace_start(). */
-	bdev_file = btrfs_open_device_deny_freeze(device_path, fs_info->sb);
+	bdev_file = btrfs_open_device_deny_freeze(fs_info, device_path);
 	if (IS_ERR(bdev_file)) {
 		btrfs_err(fs_info, "target device %s is invalid!", device_path);
 		return PTR_ERR(bdev_file);
@@ -312,7 +312,6 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	/* Check the comment in btrfs_init_new_device() for the reason. */
 	atomic_inc(&device->dev_stats_ccnt);
 	device->dev_stats_valid = 1;
-	set_blocksize(bdev_file, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_devices;
 
 	ret = btrfs_get_dev_zone_info(device, false);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 290508894f7c..d721e58a69f3 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -28,8 +28,7 @@ struct btrfs_transaction;
 #define BTRFS_SUPER_MIRROR_SHIFT 12
 
 /*
- * Fixed blocksize for all devices, applies to specific ways of reading
- * metadata like superblock. Must meet the set_blocksize requirements.
+ * Fixed blocksize for all devices, applies to super block writes only.
  *
  * Do not change.
  */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ce78a9441c64..010509e841cd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -499,8 +499,10 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	if (flush)
 		sync_blockdev(bdev);
 	if (holder) {
-		ret = set_blocksize(*bdev_file, BTRFS_BDEV_BLOCKSIZE);
+		ret = bdev_validate_blocksize(bdev, BTRFS_BDEV_BLOCKSIZE);
 		if (ret) {
+			btrfs_err(NULL, "device %s doesn't support blocksize %u",
+				  device_path, BTRFS_BDEV_BLOCKSIZE);
 			fs_bdev_file_release(*bdev_file, holder);
 			goto error;
 		}
@@ -1468,9 +1470,7 @@ static bool btrfs_skip_registration(struct btrfs_super_block *disk_super,
 }
 
 /*
- * Look for a btrfs signature on a device. This may be called out of the mount path
- * and we are not allowed to call set_blocksize during the scan. The superblock
- * is read via pagecache.
+ * Look for a btrfs signature on a device. The superblock is read via pagecache.
  *
  * With @mount_arg_dev it's a scan during mount time that will always register
  * the device or return an error. Multi-device and seeding devices are registered
@@ -2919,13 +2919,13 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 }
 
 /*
- * Open @path for @sb with freezing denied before the holder claim is published,
+ * Open @path for @fs_info->sb with freezing denied before the holder claim is published,
  * so a racing bdev_freeze() can never reach a claim a device add or replace may
  * still abort.  The deny is taken on a throwaway non-holder probe open, then the
  * holder is opened by the probe's dev_t.  Balanced by the caller.
  */
-struct file *btrfs_open_device_deny_freeze(const char *path,
-					   struct super_block *sb)
+struct file *btrfs_open_device_deny_freeze(struct btrfs_fs_info *fs_info,
+					   const char *path)
 {
 	struct file *probe_file, *bdev_file;
 	int ret;
@@ -2935,6 +2935,14 @@ struct file *btrfs_open_device_deny_freeze(const char *path,
 	if (IS_ERR(probe_file))
 		return probe_file;
 
+	ret = bdev_validate_blocksize(file_bdev(probe_file), BTRFS_BDEV_BLOCKSIZE);
+	if (ret < 0) {
+		btrfs_err(fs_info, "device %s doesn't support blocksize %u",
+			  path, BTRFS_BDEV_BLOCKSIZE);
+		bdev_fput(probe_file);
+		return ERR_PTR(ret);
+	}
+
 	ret = bdev_deny_freeze(file_bdev(probe_file));
 	if (ret) {
 		bdev_fput(probe_file);
@@ -2942,7 +2950,7 @@ struct file *btrfs_open_device_deny_freeze(const char *path,
 	}
 
 	bdev_file = fs_bdev_file_open_by_dev(file_bdev(probe_file)->bd_dev,
-					     BLK_OPEN_WRITE, sb, sb);
+					     BLK_OPEN_WRITE, fs_info->sb, fs_info->sb);
 	if (IS_ERR(bdev_file))
 		bdev_allow_freeze(file_bdev(probe_file));
 	bdev_fput(probe_file);
@@ -2968,7 +2976,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		return -EROFS;
 
 	/* Forbid freezing until the device is a committed member (or unwound). */
-	bdev_file = btrfs_open_device_deny_freeze(device_path, fs_info->sb);
+	bdev_file = btrfs_open_device_deny_freeze(fs_info, device_path);
 	if (IS_ERR(bdev_file))
 		return PTR_ERR(bdev_file);
 
@@ -3043,7 +3051,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	 */
 	atomic_inc(&device->dev_stats_ccnt);
 	device->dev_stats_valid = 1;
-	set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
 
 	if (seeding_dev) {
 		/* GFP_KERNEL allocation must not be under device_list_mutex */
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 75b1179776c8..d5fe5cba0c35 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -776,8 +776,8 @@ struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices
 				       const struct btrfs_dev_lookup_args *args);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
-struct file *btrfs_open_device_deny_freeze(const char *path,
-					   struct super_block *sb);
+struct file *btrfs_open_device_deny_freeze(struct btrfs_fs_info *fs_info,
+					   const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
 		  struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
-- 
2.56.0

