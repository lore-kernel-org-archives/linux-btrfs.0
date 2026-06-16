Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D91743CED9;
	Tue, 16 Jun 2026 11:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611118; cv=none; b=SN214wakJeR2HwhdJ6aB5mFEINV66RZm26ipevbvMOOgYc3CUahQwwa11u++u3i2iP2+Dw2YUW4sfaEaexPZw/Rhp7yPjgzV95BhecWZljqWUR5u5oEos0CdJr4HmE0b45Rcv1bZAboS9PdAEX9hD33ihdjXA+wB7VfnJn1uvbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611118; c=relaxed/simple;
	bh=Qu4mEGy1rmlrXkNpfKmKtO9rGG4Y9Zw6OipCXF8ImUU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CLC07IqGHrutK1AcJJ5YYWqugMN4UeE4eoNNUbU645nGyG0gmJrCkT73jduIcAF0AE4cHYwVujoZGAWPC3tS6onSxaDYOe+x2urQXHdAQQkUUUwfDdif309QU90gYkN6EqbbYrDKNgaNcFrA9lgCEHvMgF+dma+rdzDU45xUxmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bl8kRy2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bl8kRy2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472F81F000E9;
	Tue, 16 Jun 2026 11:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781611117;
	bh=Q7m4hEodcTRnWOp4HxOFKTjI034pMYhe0V7QRpsYorU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bl8kRy2eqtEsOnNJ6BJhmKD1gJutaJ3sKJ6Qbjxy8PAQOcXW/SfPiNAondvlbgdFS
	 dlrdCyssz5v4qI2K5WwrD49pTW7znOYg4E1f4EXlTrMqycUKMzyHeETx447B9r7HAS
	 kre4rzyNG35GZWRGFAqv5yP3L8HPn47XbMlnFAWH06IkUdRp0vLi4Am2STfJG6GmHL
	 O0Ia1WAw0lzOm6B/U+X4L7xFZsIPKHq8vMPmwki+yvlvNUnolFyZunxuU+3wQ5tAbj
	 nqWQQH3pdsfd8eoC06IJmCmCCcvteGPE74S9N2Hw/KDKbabNR14RkKaSVthwa1nvc9
	 FjeHE5XQ1x9og==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 13:58:17 +0200
Subject: [PATCH v2 4/5] btrfs: deny freezing a device while it is being
 added
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-freeze_deny_upstream-v2-4-b3567c7f994b@kernel.org>
References: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
In-Reply-To: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5209; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Qu4mEGy1rmlrXkNpfKmKtO9rGG4Y9Zw6OipCXF8ImUU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZWiXw//ZfoeS+7MyMLzeVRZS5As1s2spi11Z3LFE7c
 GObRQVrRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQs5Rj+WSvHfJvNVuC0aoaC
 kl3SzVcMU9fpb/t2c83S+f7T3jY842BkmLBCQ2hd7HzJkzWzKh7dCFY8FrJskwXvgVetPnOvfQx
 qYQcA
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
 fs/btrfs/volumes.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.h |  2 ++
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 36f9835f65e3..167a1c3d0fca 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2822,6 +2822,37 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
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
+	/* WRITE so bdev_file_open_by_path() rejects a read-only device. */
+	probe_file = bdev_file_open_by_path(path, BLK_OPEN_WRITE, NULL, NULL);
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
@@ -2840,8 +2871,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (sb_rdonly(sb) && !fs_devices->seeding)
 		return -EROFS;
 
-	bdev_file = bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
-					   fs_info->sb, &fs_holder_ops);
+	/* Forbid freezing until the device is a committed member (or unwound). */
+	bdev_file = btrfs_open_device_deny_freeze(device_path, fs_info->sb);
 	if (IS_ERR(bdev_file))
 		return PTR_ERR(bdev_file);
 
@@ -3006,8 +3037,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		up_write(&sb->s_umount);
 		locked = false;
 
-		if (ret) /* transaction commit */
+		if (ret) { /* transaction commit */
+			bdev_allow_freeze(file_bdev(bdev_file));
 			return ret;
+		}
 
 		ret = btrfs_relocate_sys_chunks(fs_info);
 		if (ret < 0)
@@ -3015,8 +3048,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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
@@ -3036,6 +3071,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	/* Update ctime/mtime for blkid or udev */
 	update_dev_time(device_path);
 
+	bdev_allow_freeze(file_bdev(bdev_file));
 	return ret;
 
 error_sysfs:
@@ -3065,7 +3101,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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

