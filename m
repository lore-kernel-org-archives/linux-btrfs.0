Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3882B35B657;
	Mon, 15 Jun 2026 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529514; cv=none; b=GFDtqavdzMpDiRHh7yeIhpM4lUC00BW1mH/VhisPFvRqDfeDam0J0MkWEqp3H36Z6XbuKvmlleqO9rRWPXRJTkdVk20NMlcG9FwrRzAVdnG1QFgsTfB3SaeDIBPdj1cPZvO8ZX70UNuiieml29ZnJZzkc6eRNNN/u21wPldqHlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529514; c=relaxed/simple;
	bh=dnYtp3w8R4ZuAPPlVlST9huJJwigYkgZyrwaY9wRbzg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HW9f7XiEccp4ZVd9P/FV6PPSS7V3VaPzWOi1LougXcU2lJ/UuQn8ZtraK/Ub6qBKqdv0+F0O7dmp3R+esoz+feg+qs366msbpTNzivN/SlD4Pk9JOSmJcoF8Rn9m8We8cKjmE+ThgSvst7+CeyxDcGrA09xBE3GXxWlVr99JpTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhNLxHjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhNLxHjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD0F1F00A3A;
	Mon, 15 Jun 2026 13:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529512;
	bh=YibHUGekBPe5PwOM7dWJY/pL1yAK6G9qBzTXIdohQuU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RhNLxHjGdoz6yu/qQjmedKVaFtZv0Je4PcqpOVPnTmBswOYG6NaUwtz4UNUaQwt4b
	 sXAyjWi5O6t/UfL5JTGe0de+oAwoy4XO4Fzc76QNgq09qHYqX0C9vKGsKb/kuT1Ycv
	 i2vhyLeGCRvFpqHwXc3Sm3l+UpfpBvVuKKXGvFO5LA2V6EwJ7m2FeaOEHhnYOdK7Ep
	 rbo6IUFQLmx5WOyXyKnU4pXJTzLa2SonR11PpJDU81vACtOtnnmlv77vNQWp0IGEW/
	 dKABb/ktfXgwqeOdiTyE5kfcQw/x6lYbxNrCRbp+uFAqS1q+eIXWtdnpwfpXwrGU60
	 vmo2UPEXWOOhQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:18:08 +0200
Subject: [PATCH RFC 5/6] btrfs: deny freezing a device while it is being
 added
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-super-freeze_deny_upstream-v1-5-a6c72b840e7d@kernel.org>
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=5136; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dnYtp3w8R4ZuAPPlVlST9huJJwigYkgZyrwaY9wRbzg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/56+KbH77s3J0/vmxT/YzmFmdF5whey/jbIMO3c1v
 3m37VuBRUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEbu9lZNi+9Lt00RvnlYdf
 L/Tm8VP3K9rnnDDV9qDbUSvT5KoVc4QZ/uleZtFcV36Xd5N7y2WPp1wPrP/c1vk018DSzGTvxjD
 xLRwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

btrfs_init_new_device() opens and claims the new device on a live
superblock without holding the write count, so a bdev_freeze() racing the
window between the claim being published and the device becoming a member
could freeze the filesystem through a claim the add may still abort and tear
down.

Add btrfs_open_device_deny_freeze(): it opens the device once
non-exclusively to take the freeze deny, then claims it by the same dev_t,
so the holder is only ever published while the device is already
unfreezable.  Keep it denied until the add is durable: bdev_allow_freeze()
on each success return (the device is now a committed member),
btrfs_release_device_allow_freeze() on the error unwind.  The deny spans the
whole add, including the seeding tail whose late failures still release the
device.  A device already frozen when the add starts is refused with -EBUSY.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/volumes.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.h |  2 ++
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 36f9835f65e3..4558e018b53b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2822,6 +2822,36 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 	return 0;
 }
 
+/*
+ * Open @path for @sb with freezing denied before the holder claim is published,
+ * so a racing bdev_freeze() can never reach a claim a device add or replace may
+ * still abort.  The deny is taken on a throwaway non-holder probe open, then the
+ * holder is opened by the probe's dev_t.  Balanced by the caller.
+ */
+struct file *btrfs_open_device_deny_freeze(const char *path,
+					   struct super_block *sb)
+{
+	struct file *probe_file, *bdev_file;
+	int ret;
+
+	probe_file = bdev_file_open_by_path(path, BLK_OPEN_READ, NULL, NULL);
+	if (IS_ERR(probe_file))
+		return probe_file;
+
+	ret = bdev_deny_freeze(file_bdev(probe_file));
+	if (ret) {
+		bdev_fput(probe_file);
+		return ERR_PTR(ret);
+	}
+
+	bdev_file = bdev_file_open_by_dev(file_bdev(probe_file)->bd_dev,
+					  BLK_OPEN_WRITE, sb, &fs_holder_ops);
+	if (IS_ERR(bdev_file))
+		bdev_allow_freeze(file_bdev(probe_file));
+	bdev_fput(probe_file);
+	return bdev_file;
+}
+
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path)
 {
 	struct btrfs_root *root = fs_info->dev_root;
@@ -2840,8 +2870,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (sb_rdonly(sb) && !fs_devices->seeding)
 		return -EROFS;
 
-	bdev_file = bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
-					   fs_info->sb, &fs_holder_ops);
+	/* Forbid freezing until the device is a committed member (or unwound). */
+	bdev_file = btrfs_open_device_deny_freeze(device_path, fs_info->sb);
 	if (IS_ERR(bdev_file))
 		return PTR_ERR(bdev_file);
 
@@ -3006,8 +3036,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		up_write(&sb->s_umount);
 		locked = false;
 
-		if (ret) /* transaction commit */
+		if (ret) { /* transaction commit */
+			bdev_allow_freeze(file_bdev(bdev_file));
 			return ret;
+		}
 
 		ret = btrfs_relocate_sys_chunks(fs_info);
 		if (ret < 0)
@@ -3015,8 +3047,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 				    "Failed to relocate sys chunks after device initialization. This can be fixed using the \"btrfs balance\" command.");
 		trans = btrfs_attach_transaction(root);
 		if (IS_ERR(trans)) {
-			if (PTR_ERR(trans) == -ENOENT)
+			if (PTR_ERR(trans) == -ENOENT) {
+				bdev_allow_freeze(file_bdev(bdev_file));
 				return 0;
+			}
 			ret = PTR_ERR(trans);
 			trans = NULL;
 			goto error_sysfs;
@@ -3036,6 +3070,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	/* Update ctime/mtime for blkid or udev */
 	update_dev_time(device_path);
 
+	bdev_allow_freeze(file_bdev(bdev_file));
 	return ret;
 
 error_sysfs:
@@ -3065,7 +3100,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 error_free_device:
 	btrfs_free_device(device);
 error:
-	bdev_fput(bdev_file);
+	btrfs_release_device_allow_freeze(bdev_file);
 	if (locked) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 60e82c15881a..75c7963f5d4c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -769,6 +769,8 @@ struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices
 				       const struct btrfs_dev_lookup_args *args);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
+struct file *btrfs_open_device_deny_freeze(const char *path,
+					   struct super_block *sb);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
 		  struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);

-- 
2.47.3

