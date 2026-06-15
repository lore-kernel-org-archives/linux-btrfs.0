Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579D835B657;
	Mon, 15 Jun 2026 13:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529505; cv=none; b=V5bqwKi1/KVX3eRGFaY2igNZZfjuSFVNh50tD3saTDNSpq/bg+jaw/vMjZ8VwmCdgI4A8eWSBXgXvyr8JdNJzfRUzqgM9UbIlyoCfY8ApM/POWT0DxoQXBv6kSF3Z53yuZjFwn4oJgXUR7Y0iM0UE3okXWUwupO4SeCv58keTUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529505; c=relaxed/simple;
	bh=jPLoyJ0UAgzI0eP7oDGsQyBT0xevBX5+VIB+e7HSFrU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=awaeGIRURcNj1NnBhf1LcjEnScHHHaQBo1s4jt148azRZM/VUR6giRdJDlbMnZ1dX5Pwy3gO7veZ9PMLJ2zqPyAG+2X79I0qx2CbT3gtfFh7W3E4FzfRVU71d7FY3L+M6OvOQukwmeiKjcGl+oo5UZlE8cbzqnIB4pJUDTXA8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXsxeF7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXsxeF7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD521F000E9;
	Mon, 15 Jun 2026 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529503;
	bh=eBIZ3Vtvq+ucsuyFL7Jgib4zcgQuUXBafaT3gEA6U80=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VXsxeF7pioMq25yZfN9YDhmok4JgquMnqNtXIw7CTR23gplQ6jUqrdXu5j35OpTkG
	 R+RVsMmUHp0d3p/O+/SicnK0DL62Ri2lt+SY4KytV7AKQUEBY1N+x0JFVRcDpj72F1
	 VPC1k66px8SWhezns9YURy5Gzvjmn2+GMLa3GR33XW963xSPBqUBQYAdwAf6c2evtP
	 C2Pc8W38hVsFVWjsPUMf+QtGdzjjMvkvgUru1aNlqqXdyN/Tn2MVPPxaR0QpgekGof
	 HA5+TfVeLsMHmS+M6xCSLBkuJdlgS3jqmgnYTAt46b1Wl3ujuCxeFZ7F9DJ6SMeNYr
	 POwMvZWwy9uFg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:18:05 +0200
Subject: [PATCH RFC 2/6] block: allow making a block device unfreezable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-super-freeze_deny_upstream-v1-2-a6c72b840e7d@kernel.org>
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=4247; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jPLoyJ0UAgzI0eP7oDGsQyBT0xevBX5+VIB+e7HSFrU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/56ezDJzaZDZ8nDbf8+NSzbE2XVf0FYw+x393yFrc
 3Zp13X9jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkEmTP80zLuK74a9mzLhFlx
 GtUbntmnbUzZvPu22tmbphOePjp+oYfhf9RVsf9fbjZ/2PZJeM9J71Xr5F7vOrD9u9C7ZLvDCzg
 lJbgA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add bdev_deny_freeze() and bdev_allow_freeze(), modeled on
deny_write_access()/allow_write_access().  bd_fsfreeze_count becomes a
signed counter: > 0 counts active freezes, < 0 counts deniers, and the
two regimes are mutually exclusive.  bdev_freeze() refuses with -EBUSY
while a deny is held, and bdev_deny_freeze() refuses while the device is
frozen.

A filesystem that mutates a device's membership (a btrfs device add,
remove or replace) denies freezing on the device for the duration, so a
claim a freeze walk might act on is never added or torn down behind the
freezer's back.

The deny/allow helpers are a single atomic on bd_fsfreeze_count and take
no lock, so they can be called while holding s_umount without inverting
against bdev_freeze()'s bd_fsfreeze_mutex -> s_umount order.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 block/bdev.c              | 43 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blk_types.h |  2 +-
 include/linux/blkdev.h    |  2 ++
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index bb0ffa3bb4df..939dec351772 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -304,7 +304,12 @@ int bdev_freeze(struct block_device *bdev)
 
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 
-	if (atomic_inc_return(&bdev->bd_fsfreeze_count) > 1) {
+	/* A device being removed from its filesystem refuses freezes. */
+	if (!atomic_inc_unless_negative(&bdev->bd_fsfreeze_count)) {
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return -EBUSY;
+	}
+	if (atomic_read(&bdev->bd_fsfreeze_count) > 1) {
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		return 0;
 	}
@@ -368,6 +373,42 @@ int bdev_thaw(struct block_device *bdev)
 }
 EXPORT_SYMBOL(bdev_thaw);
 
+/**
+ * bdev_deny_freeze - make a block device unfreezable
+ * @bdev: block device
+ *
+ * Reserve @bdev against bdev_freeze() the way deny_write_access() reserves a
+ * file against writers.  bd_fsfreeze_count is sign-encoded: > 0 counts active
+ * freezes, < 0 counts deniers, so a deny succeeds only while no freeze is in
+ * progress.  While held, bdev_freeze() returns -EBUSY.  Pair with
+ * bdev_allow_freeze().
+ *
+ * A filesystem removing, adding or replacing a member device denies freezes on
+ * it for the duration, so a claim a freeze walk might act on is never torn down
+ * behind the freezer's back.  The deny is device-scoped, not (device,
+ * superblock)-scoped: a device shared by several superblocks is refused for all
+ * of them.  No in-tree filesystem removes a shared claim from a live superblock.
+ *
+ * Return: 0, or -EBUSY if the device is currently frozen.
+ */
+int bdev_deny_freeze(struct block_device *bdev)
+{
+	return atomic_dec_unless_positive(&bdev->bd_fsfreeze_count) ? 0 : -EBUSY;
+}
+EXPORT_SYMBOL_GPL(bdev_deny_freeze);
+
+/**
+ * bdev_allow_freeze - allow freezing a block device again
+ * @bdev: block device
+ *
+ * Undo one bdev_deny_freeze().
+ */
+void bdev_allow_freeze(struct block_device *bdev)
+{
+	atomic_inc(&bdev->bd_fsfreeze_count);
+}
+EXPORT_SYMBOL_GPL(bdev_allow_freeze);
+
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..5a725a0cd35f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -66,7 +66,7 @@ struct block_device {
 	int			bd_holders;
 	struct kobject		*bd_holder_dir;
 
-	atomic_t		bd_fsfreeze_count; /* number of freeze requests */
+	atomic_t		bd_fsfreeze_count; /* >0 freeze requests, <0 freeze deniers */
 	struct mutex		bd_fsfreeze_mutex; /* serialize freeze/thaw */
 
 	struct partition_meta_info *bd_meta_info;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 890128cdea1c..cf1951caadb2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1829,6 +1829,8 @@ static inline int early_lookup_bdev(const char *pathname, dev_t *dev)
 
 int bdev_freeze(struct block_device *bdev);
 int bdev_thaw(struct block_device *bdev);
+int bdev_deny_freeze(struct block_device *bdev);
+void bdev_allow_freeze(struct block_device *bdev);
 void bdev_fput(struct file *bdev_file);
 
 struct io_comp_batch {

-- 
2.47.3

