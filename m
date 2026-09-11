Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2733B4EAC
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789105137; cv=none; b=ISCromWgshgD1T+WaYacZBBa7faS9BseIvVPmZYwQYrfvqSnN/8b8FMusYLhYSNH5t7aUcBye3ycbSCjhy3B/Ni7Mu0bQtvd/hj9VVW3r9t03g3EjH0kCcncG1ZWpy33jZRu8oKvfjjKU0tg4sdwko+69daeiA2cnNU6SXHrOVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789105137; c=relaxed/simple;
	bh=HXYE4MLtQs97LrHQPZRz2pqnWDWRh6gLcY9DDqDLqCw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCSqCtx42mKGSYzRAQAhmrpTXF99rU7yq/Rfzh97h56Cly3Y8Ryc6vwQyWiavm6XAGYApDBzmLntmBfkR0IMyk+eiPXeYPAvk8f08YiqXRw3cBXNbJmC0ry3OFeyFqAbPHKVnpNd+9jDIeucS+zRyIgEcEeOf8yxgp/nqE2fDho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rmAz8n/4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=M7fxa8AL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rmAz8n/4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="M7fxa8AL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5286821D5A
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789105129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BAtHY/+P6XOz648Mo0/9gbvClQquMG6tTmPTqgF/PKI=;
	b=rmAz8n/4NrFY5FYXyg3rlxj5qne9EsVPvUK855qjPiLw18vEcr18Lq78VRultlJFmE5mph
	rkJoHhHQA2AgrsRSinAhksnGAyZX476u5ag9rfYDWSB53UXO54GaqsbHJqXvh4UTuSnyUW
	d1qXhutUgyncfB4bil8YH/NQB8Runyg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789105125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BAtHY/+P6XOz648Mo0/9gbvClQquMG6tTmPTqgF/PKI=;
	b=M7fxa8ALpQave40nmk2a6DsO1BT9qq3zLTqLamgnKyXmlnmcz/y1aoDLvWs1NmL55zesuz
	Hu5xFoZSXQMu9v3XtoqH9UQCJQ5sCNm3mRq0NH4kr/LmLvykFdKBuD5WXibC2XYSlB+m38
	mmVZgDEw9q+D1OYBmjhYiLTazhKrpjc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 143FB137CA
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IEhqLeOTo2rPWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: introduce a new ioctl to force updating the device name
Date: Fri, 11 Sep 2026 15:08:17 +0930
Message-ID: <964a5af1c677732f67bca2ffe76ad9eec248dafb.1789104905.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789104905.git.wqu@suse.com>
References: <cover.1789104905.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Btrfs has a very long history fighting to determine what is the proper
name to show in btrfs_show_devname().

The long history includes:

- 7e06de7c83a7 ("btrfs: canonicalize the device path before adding it")
  To address a report that a very weird path can be utilized to do the
  mount, and btrfs saves that weird path as the device name.
  But such a name cannot be accessed outside of a certain pid, so the end
  result is that the device shown in btrfs is completely meaningless.

  That commit tries to canonicalize the path, but it is not good enough.

- 2e8b6bc0ab41 ("btrfs: avoid unnecessary device path update for the same device")
  This is to address a lot of unnecessary device path updates caused by
  different soft links of the same block device.

- 8fb1dcbbcc1f ("Revert "btrfs: canonicalize the device path before adding it"")
  This reverts the first patch.

  The reason is that the "/dev/" directory is not guaranteed to be a
  devfs, it can be a regular directory with manually populated special
  files, and it can even be in a different name space, which means other
  namespaces may not see the same special file at all.

- 108cc8733989 ("btrfs: fix a lockdep caused by path resolution during device scan")
  This one completely gets rid of the path based device check, to avoid
  deadlock.

  Since the "/dev/" is not ensured to be a devfs, one can put "/dev/"
  into a btrfs, and path resolution will lock the involved inode,
  meanwhile device scan also needs to lock that inode, which can lead to
  deadlock.

- A recent report that the device name shown in mountinfo is incorrect
  This is another corner case where the end user is booting the kernel
  without an initramfs.
  So that at rootfs mount time, a special path "/dev/root" is passed as
  the device for rootfs.

  And a later btrfs device rescan won't update the device name since the
  newer name points to the same devt.

In short, unlike LVM which uses device-mapper and has a dedicated dm-*
device, btrfs has to directly manage the device names during mount/rescan
and all kinds of corner cases inside btrfs itself.

Instead of handling all those hassles inside btrfs, push the
responsibility to end users, and provide a new ioctl to force updating
the btrfs device path.

Now all the decisions are made by end users, they have every right to do
stupid things (including namespace related hassles) or to replace
outdated device paths with a correct one.

With this new ioctl and corresponding btrfs-progs changes, end users
finally have the proper way to update the weird names shown in
btrfs_show_devname():

 # cd /dev
 # mknod weird b 253 3
 # mount /dev/weird /mnt/btrfs
 # mount | grep weird
 /dev/weird on /mnt/btrfs type btrfs (rw,relatime,discard=async,space_cache=v2,subvolid=5,subvol=/)
 ^^^^^^^^^^ The weird name is still utilized here.
 # btrfs dev scan -r /dev/test/scratch1
 # dmesg -t | tail -n1
 BTRFS info: devid 1 device path /dev/weird changed to /dev/mapper/test-scratch1 scanned by btrfs (4068)
 # mount | tail -n1
 /dev/mapper/test-scratch1 on /mnt/btrfs type btrfs (rw,relatime,discard=async,space_cache=v2,subvolid=5,subvol=/)

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c           | 16 +++++++++++-----
 fs/btrfs/volumes.c         | 24 +++++++++++++++++-------
 fs/btrfs/volumes.h         |  6 +++++-
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..76c58a2e6d40 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -374,7 +374,7 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		struct btrfs_device *device;
 
 		mutex_lock(&uuid_mutex);
-		device = btrfs_scan_one_device(param->string, false);
+		device = btrfs_scan_one_device(param->string, 0);
 		mutex_unlock(&uuid_mutex);
 		if (IS_ERR(device))
 			return PTR_ERR(device);
@@ -1872,10 +1872,10 @@ static int btrfs_get_tree_super(struct fs_context *fc)
 	mutex_lock(&uuid_mutex);
 
 	/*
-	 * With 'true' passed to btrfs_scan_one_device() (mount time) we expect
+	 * With BTRFS_SCAN_DEV_MOUNT passed to btrfs_scan_one_device() we expect
 	 * either a valid device or an error.
 	 */
-	device = btrfs_scan_one_device(fc->source, true);
+	device = btrfs_scan_one_device(fc->source, BTRFS_SCAN_DEV_MOUNT);
 	ASSERT(device != NULL);
 	if (IS_ERR(device)) {
 		mutex_unlock(&uuid_mutex);
@@ -2270,7 +2270,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		 * Scanning outside of mount can return NULL which would turn
 		 * into 0 error code.
 		 */
-		device = btrfs_scan_one_device(vol->name, false);
+		device = btrfs_scan_one_device(vol->name, 0);
 		ret = PTR_ERR_OR_ZERO(device);
 		mutex_unlock(&uuid_mutex);
 		break;
@@ -2288,7 +2288,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		 * Scanning outside of mount can return NULL which would turn
 		 * into 0 error code.
 		 */
-		device = btrfs_scan_one_device(vol->name, false);
+		device = btrfs_scan_one_device(vol->name, 0);
 		if (IS_ERR_OR_NULL(device)) {
 			mutex_unlock(&uuid_mutex);
 			ret = PTR_ERR_OR_ZERO(device);
@@ -2298,6 +2298,12 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 			device->fs_devices->total_devices);
 		mutex_unlock(&uuid_mutex);
 		break;
+	case BTRFS_IOC_RENAME_DEV:
+		mutex_lock(&uuid_mutex);
+		device = btrfs_scan_one_device(vol->name, BTRFS_SCAN_DEV_RENAME);
+		ret = PTR_ERR_OR_ZERO(device);
+		mutex_unlock(&uuid_mutex);
+		break;
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		ret = btrfs_ioctl_get_supported_features((void __user*)arg);
 		break;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4ddabadc9188..268bf10ab181 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -758,7 +758,7 @@ const u8 *btrfs_sb_fsid_ptr(const struct btrfs_super_block *sb)
  */
 static noinline struct btrfs_device *device_list_add(const char *path,
 			   struct btrfs_super_block *disk_super,
-			   bool *new_device_added)
+			   bool *new_device_added, bool force_rename)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices = NULL;
@@ -869,7 +869,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 				MAJOR(path_devt), MINOR(path_devt),
 				current->comm, task_pid_nr(current));
 
-	} else if (!device->name || device->devt != path_devt) {
+	} else if (!device->name || device->devt != path_devt || force_rename) {
 		const char *old_name;
 
 		/*
@@ -882,9 +882,14 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		 *         different name. or
 		 *      b. The missing-disk-which-was-replaced, has
 		 *         reappeared now.
+		 *      c. A device scan is triggered on different soft links
+		 *         of the block device.
 		 *
-		 * We must allow 1 and 2a above. But 2b would be a spurious
-		 * and unintentional.
+		 * We must allow 1 and 2a above.
+		 * For 2c, we should only allow it when it's triggered from
+		 * BTRFS_IOC_RENAME_DEV.
+		 *
+		 * But 2b would be a spurious and unintentional.
 		 *
 		 * Further in case of 1 and 2a above, the disk at 'path'
 		 * would have missed some transaction when it was away and
@@ -1443,14 +1448,19 @@ static bool btrfs_skip_registration(struct btrfs_super_block *disk_super,
  * and we are not allowed to call set_blocksize during the scan. The superblock
  * is read via pagecache.
  *
- * With @mount_arg_dev it's a scan during mount time that will always register
+ * With BTRFS_SCAN_DEV_MOUNT it's a scan during mount time that will always register
  * the device or return an error. Multi-device and seeding devices are registered
  * in both cases.
+ *
+ * With BTRFS_SCAN_DEV_RENAME it's to force a device name update for a mounted
+ * device.
  */
 struct btrfs_device *btrfs_scan_one_device(const char *path,
-					   bool mount_arg_dev)
+					   unsigned int flags)
 {
 	struct btrfs_super_block *disk_super;
+	bool mount_arg_dev = flags & BTRFS_SCAN_DEV_MOUNT;
+	bool force_rename = flags & BTRFS_SCAN_DEV_RENAME;
 	bool new_device_added = false;
 	struct btrfs_device *device = NULL;
 	struct file *bdev_file;
@@ -1489,7 +1499,7 @@ struct btrfs_device *btrfs_scan_one_device(const char *path,
 		goto free_disk_super;
 	}
 
-	device = device_list_add(path, disk_super, &new_device_added);
+	device = device_list_add(path, disk_super, &new_device_added, force_rename);
 	if (!IS_ERR(device) && new_device_added)
 		btrfs_free_stale_devices(device->devt, device);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 337d7007d9e2..509e1c0ef67c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -747,7 +747,11 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 void btrfs_mapping_tree_free(struct btrfs_fs_info *fs_info);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       blk_mode_t flags, void *holder);
-struct btrfs_device *btrfs_scan_one_device(const char *path, bool mount_arg_dev);
+
+#define BTRFS_SCAN_DEV_MOUNT	(1U << 0)
+#define BTRFS_SCAN_DEV_RENAME	(1U << 1)
+struct btrfs_device *btrfs_scan_one_device(const char *path, unsigned int flags);
+
 int btrfs_forget_devices(dev_t devt);
 void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_release_device_allow_freeze(struct file *bdev_file);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b5e488a5cf75..7a03b44d925c 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -1226,6 +1226,8 @@ struct btrfs_ioctl_get_csums_args {
 #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
 			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
+#define BTRFS_IOC_RENAME_DEV _IOW(BTRFS_IOCTL_MAGIC, 47, \
+				  struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_GET_FSLABEL 	FS_IOC_GETFSLABEL
 #define BTRFS_IOC_SET_FSLABEL	FS_IOC_SETFSLABEL
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
-- 
2.55.0

