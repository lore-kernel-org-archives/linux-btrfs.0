Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C1B43D501;
	Tue, 16 Jun 2026 11:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611110; cv=none; b=sUn/JQXPqwwd5+MZIRp9UCN1KhipWAXgqVTNOsvB4vGWodK7OS60Oa1MVmyIPaE/HjvHDOE2MxepI0uWjsRO+hzfSz/LDWsQIFwZTbpM75uOvYINdbQccB7XOXjnhpFgP/oVOEnZ1c3d8Mx58PdAAIauMm47zTqJ0yQGuxv1EL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611110; c=relaxed/simple;
	bh=VRS1IC7cloCBcNKR7T/hW4BzxK3OAgKL9JMIFYcGYeU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dUAxXAWZeTIJyFdeO4tlYNNj5sJKkQYqzn4d9XJUB/IcH1sH/cR6Rp0ge50bvVCDIafyVs5MqorRWT8hZjDFK6B585lZ7Zjd3KLcTOkuZaT1TXJK2OfmBKKBjoOvDcWoeSK9c6kOen8Le2utCca2UuIHHzcCtPIvArBAsdNohTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VaAQiLiK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VaAQiLiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449AB1F00A3A;
	Tue, 16 Jun 2026 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781611109;
	bh=BOhhyL1mqQEWBjA/K3i3T7B0lYLg5wWaApcO1mPYSRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VaAQiLiK1T3Wy1TA/lSI0r4yggYnrlNSViyjO7gM/2aEHEoWuWV8Id9Yhg0ksbaAc
	 1Bhlj2Xqhsg90wy2mPWDVlJsC3uI0Uxruto/byUgBuTvbBboys3GOBUZs2pmux8PCo
	 9eNuo0zY8OyCs7u0eKfreR504BtKyPNXexN9q4L00jOYhTPifzwSy2axD6pwz9D0cV
	 MZCB7zc8TNkDZY6LESA7SXpkuqOTGod1Li7eJjTfshTKYjfnJ+eLXppSQxAf5GG8SF
	 nq+p2MTFt+WVDdGMZ4GOn2Qb4Te1a6YdEpdicEdyz9MeXXdY6AjHBiswp/ym04LLKZ
	 Eh6i1RiZEVb/Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 13:58:14 +0200
Subject: [PATCH v2 1/5] block: allow making a block device unfreezable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-freeze_deny_upstream-v2-1-b3567c7f994b@kernel.org>
References: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
In-Reply-To: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5469; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VRS1IC7cloCBcNKR7T/hW4BzxK3OAgKL9JMIFYcGYeU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZWiWYOiR8qNx/5tTZT13f1j3Mjz88e+ffZS9u/KtQc
 j44pZTZq6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi524yMtwpdtR1WXBic1ug
 t73Fwu5fd/xiZV+/muCzjuFPa1cBiyUjw5PGcI2rqbVucX9nBp+ta1VjlTO7HTunM1ztuFB0orw
 vAwA=
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

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 block/bdev.c              | 63 +++++++++++++++++++++++++++++++++++++++--------
 include/linux/blk_types.h |  2 +-
 include/linux/blkdev.h    |  2 ++
 3 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index bb0ffa3bb4df..a83a3809380c 100644
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
@@ -340,18 +345,18 @@ int bdev_thaw(struct block_device *bdev)
 
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 
-	/*
-	 * If this returns < 0 it means that @bd_fsfreeze_count was
-	 * already 0 and no decrement was performed.
-	 */
-	nr_freeze = atomic_dec_if_positive(&bdev->bd_fsfreeze_count);
-	if (nr_freeze < 0)
+	/* <= 0: not frozen (0) or a freeze deny is held (< 0); leave it. */
+	nr_freeze = atomic_read(&bdev->bd_fsfreeze_count);
+	if (nr_freeze <= 0)
 		goto out;
 
 	error = 0;
-	if (nr_freeze > 0)
+	if (nr_freeze > 1) {
+		atomic_dec(&bdev->bd_fsfreeze_count);
 		goto out;
+	}
 
+	/* Keep the count positive across the thaw so a deny is refused. */
 	mutex_lock(&bdev->bd_holder_lock);
 	if (bdev->bd_holder_ops && bdev->bd_holder_ops->thaw) {
 		error = bdev->bd_holder_ops->thaw(bdev);
@@ -360,14 +365,52 @@ int bdev_thaw(struct block_device *bdev)
 		mutex_unlock(&bdev->bd_holder_lock);
 	}
 
-	if (error)
-		atomic_inc(&bdev->bd_fsfreeze_count);
+	if (!error)
+		atomic_dec(&bdev->bd_fsfreeze_count);
 out:
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	return error;
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
+	/* A deny must be held, i.e. the count must be negative. */
+	WARN_ON_ONCE(atomic_read(&bdev->bd_fsfreeze_count) >= 0);
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

