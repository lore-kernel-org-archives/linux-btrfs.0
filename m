Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E703F39FE;
	Mon, 15 Jun 2026 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529511; cv=none; b=FBZ2ay5pkDKKw2yliiVmd1sDla17JK+FYOASQR0qmCM8ngwwTPNjZmXmrxLcz//QiUoNfia9+HHg9hthlLRT8tU+qZIdGuQap+MX1YdJBpUXuwtAyIFMVtaRCjDGN/+gwIUBf1H1Mf1DoHiwj1d7OYamt/5eeEXgbLHrJtMseJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529511; c=relaxed/simple;
	bh=ncTlKqhq6LFbB9s+8du20e1HLjbFeM8/5nsVsUP9G34=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ulxmht528P2Yz8WInu9c0jOrMvnppmPBKy0p35XYMTulNHFKYQFJ9WM4ORu2fBHiwP6GvgeBUOX5OwhiKIM13GWBTO3FrPd3uTsinxIuOZzGeOa0MDYMrTFQA9oJEvtHZktogOMbLqY0e1b6IHKrGWvyyqP4UCd9PRSQljrFkgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wp7/UU8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wp7/UU8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9EC1F000E9;
	Mon, 15 Jun 2026 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529509;
	bh=D9F6c9yz2lj9J2favQl1zmbONWvPmqk9UC4ikuLbLL8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Wp7/UU8L9P/JFzHi6J0BQjKY+tsjm4SrRyJRSIbJlmiTAUt1LViE4K7sKYVG3b+vl
	 CPKYD87clUHIBt5QvQAS6xFVN6NkzFnmpu5sIxpacM2c1kOgVMQyhHT3yyog0GsC1Y
	 FT7TFjqaqd/IejRaLJJ6+z4ojrgz8PzG3kbNMz4alfIh4QtWdPjhV1+aAXSJiXkMce
	 4b/fuNr2sGteAMrAn/sKQEo7N77AJ1JuhP2bZboKnMGflN8smf5xirFkA/ASINERj5
	 o0P9rbgFAzQErvHjV1mkxJDgZHpXtV8Bz0Nub0zFLmHwMXuM14/FKVIuPpu3KSPLfH
	 CJsdzxz7BYAuw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:18:07 +0200
Subject: [PATCH RFC 4/6] btrfs: deny freezing a device while it is being
 removed
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-super-freeze_deny_upstream-v1-4-a6c72b840e7d@kernel.org>
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=5180; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ncTlKqhq6LFbB9s+8du20e1HLjbFeM8/5nsVsUP9G34=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/57OO8PiwQ5DTaP3FVtv+GkEBU+b8mXxMp+nprOj4
 tmdUuu/d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEN4rhv8c/nrl/SpPlPh3O
 cr02L8L13IrpeZPlmO0W32FW/zQ/cz0jQ5OWz4yXO0S+dm/tVPhyeGWQboEEY8Ss/1tu9j6TMz/
 UzgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

btrfs_rm_device() runs under mnt_want_write_file(), but the claim on the
removed device is released by the ioctl after mnt_drop_write_file(), so a
bdev_freeze() racing that window could freeze the filesystem through the
device just as its claim is torn down, leaving nothing for bdev_thaw() to
rebalance.

The window cannot be closed by reordering the teardown.  btrfs_rm_device()
hands the final bdev_fput() back to the ioctl, run only after
mnt_drop_write_file(), because bdev_release() takes the disk ->open_mutex and
its dependency chain, which must not nest under the superblock's freeze/write
protection -- freeze_super() drops s_umount before draining writers precisely
to keep sb_start_write ordered above s_umount.  Holding mnt_want_write across
bdev_fput() would reintroduce that inversion, so the holder teardown is forced
outside the write-protected section.  A freeze landing in the resulting gap
resolves the still-live holder, rides in, and strands when the claim is
released; no ordering of the close against the drop removes the gap.  The
device itself therefore has to refuse freezing for the whole removal.

Deny freezing the device for the duration of the removal: bdev_deny_freeze()
at the start of btrfs_rm_device() (it cannot be frozen yet, the ioctl holds
the write count), and release it through btrfs_release_device_allow_freeze()
in the ioctls on success, or bdev_allow_freeze() on the error paths that keep
the device a member.  A device frozen before the removal begins is refused
with -EBUSY.

btrfs_release_device_allow_freeze() yields the holder, re-allows freezing,
then closes the device, so the re-allow neither strands the filesystem on a
racing freeze nor touches the block device after the final fput.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/ioctl.c   |  4 ++--
 fs/btrfs/volumes.c | 20 ++++++++++++++++++++
 fs/btrfs/volumes.h |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b2e447f5005c..fc3e06445211 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2579,7 +2579,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 err_drop:
 	mnt_drop_write_file(file);
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		btrfs_release_device_allow_freeze(bdev_file);
 out:
 	btrfs_put_dev_args_from_path(&args);
 	kfree(vol_args);
@@ -2630,7 +2630,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 
 	mnt_drop_write_file(file);
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		btrfs_release_device_allow_freeze(bdev_file);
 out:
 	btrfs_put_dev_args_from_path(&args);
 out_free:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a88e68f90564..36f9835f65e3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1119,6 +1119,15 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices)
 	mutex_unlock(&uuid_mutex);
 }
 
+/* Release a device that was made unfreezable for a membership change. */
+void btrfs_release_device_allow_freeze(struct file *bdev_file)
+{
+	/* Yield before allow (strand-safe); file still open for the allow (UAF-safe). */
+	bdev_yield_claim(bdev_file);
+	bdev_allow_freeze(file_bdev(bdev_file));
+	bdev_fput(bdev_file);
+}
+
 static void btrfs_close_bdev(struct btrfs_device *device)
 {
 	if (!device->bdev)
@@ -2336,6 +2345,13 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 	    fs_info->fs_devices->rw_devices == 1)
 		return BTRFS_ERROR_DEV_ONLY_WRITABLE;
 
+	/* Removal and freezing are mutually exclusive; refuse if frozen now. */
+	if (device->bdev) {
+		ret = bdev_deny_freeze(device->bdev);
+		if (ret)
+			return ret;
+	}
+
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		mutex_lock(&fs_info->chunk_mutex);
 		list_del_init(&device->dev_alloc_list);
@@ -2362,6 +2378,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 			   device->devid, ret);
 		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
+		if (device->bdev)
+			bdev_allow_freeze(device->bdev);
 		return ret;
 	}
 
@@ -2447,6 +2465,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 	return btrfs_commit_transaction(trans);
 
 error_undo:
+	if (device->bdev)
+		bdev_allow_freeze(device->bdev);
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		mutex_lock(&fs_info->chunk_mutex);
 		list_add(&device->dev_alloc_list,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0082c166af91..60e82c15881a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -744,6 +744,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 struct btrfs_device *btrfs_scan_one_device(const char *path, bool mount_arg_dev);
 int btrfs_forget_devices(dev_t devt);
 void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
+void btrfs_release_device_allow_freeze(struct file *bdev_file);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices);
 void btrfs_assign_next_active_device(struct btrfs_device *device,
 				     struct btrfs_device *this_dev);

-- 
2.47.3

