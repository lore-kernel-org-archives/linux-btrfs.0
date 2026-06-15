Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BAD33C507;
	Mon, 15 Jun 2026 13:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529508; cv=none; b=JhOIjG52A43606GEP3MFRrWbJcHZfemnG/+BYL4u78IrN2/gqsdg6hXOfOoGtM1BuUtsMZeifz2bxedKwCXkByR+IJr+V0o9syB5RniNXABwhFl2TQxwV6wx5Os1Vv6Dks09WK26x59kvLrAARCPRB+/VQjJZAylPs/u6AY0OvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529508; c=relaxed/simple;
	bh=YqbB84jnjfb0A9YsqvAbfsm/p9faP/pOM5kARKDMUdE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l2ijsMBT+o7dsC1MMaqXyotm8znwmvWINilRDUQFuoSsDQLid44s2eAftPKOWv6d+s5CsDxD2tHYvZ4919kWjCqAp8Zpo9OaioMKLWaPh4kJRY969yu2eE5E14KmGKTYLWjiHQpKRSSBGK2iD4QPLHlPg67zaq7baB5CJVPxWKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzMm9iiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzMm9iiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDFB1F00A3A;
	Mon, 15 Jun 2026 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529506;
	bh=Te7oxd2fdwALEzGLTt5eNhcHNuxdLVA1fp1wxZzrxUw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fzMm9iiEbCUDPeF86gq/0nbAHDB7GLHyyiKjH+cADBpg4kNAqkqROwdhw2RhqcZgF
	 Z1WHdHlRMzriZ2CVCoCZ5DcLAvyMvzAPCdr4fksTnJw1PBhs9FPwENvCfsdV375CP+
	 qQnaqvMQrVB+gIHePO8JzGJqnxj12BKtKSbadkg+4eFrXhJWXWbUiG6MGHIWUfQo+I
	 RCIzCSUqreOvksbJ0nED+ijqst7Q/ZA6oF7j+T6tykCgf6kHueLIOC/JfnfyZ5leKc
	 +UvnNqmmPU72DFh8oXTYv8sLOJ4T6TQPm88GjOvAJBJ/xQdIHXg0nu04CKvuS33UiU
	 aawifOvanwlFw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:18:06 +0200
Subject: [PATCH RFC 3/6] block: split bdev_yield_claim() out of bdev_fput()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-super-freeze_deny_upstream-v1-3-a6c72b840e7d@kernel.org>
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=3321; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YqbB84jnjfb0A9YsqvAbfsm/p9faP/pOM5kARKDMUdE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/57ec2anXc4bI44L8ambUxO1Ft2afYHp/ulMjW1+H
 gc5T7c+7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIv20M/ywYwi5OXvnGjCvJ
 4eyiSVs/JzHcX1YVqFt79MjBbCuh7S0M/101lQorDD6Jhq9I/pjSk+cf+Zx5v+a7/enPwnMZDOZ
 ksgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

bdev_fput() yields the holder claim and then closes the file, which is a
deferred operation.  Split the yield half into bdev_yield_claim() so a caller
can give up the holder while the file - and therefore the block device - is
still open, act on the device, and only then bdev_fput().

A filesystem that made a device unfreezable for a membership change with
bdev_deny_freeze() undoes the deny on release with

	bdev_yield_claim(bdev_file);
	bdev_allow_freeze(file_bdev(bdev_file));
	bdev_fput(bdev_file);

Re-allowing only after the holder is yielded avoids stranding the filesystem
on a racing freeze, and doing it while the file is still open avoids touching
the block device after bdev_fput().  bdev_fput() yields again, which is a
no-op once the claim has already been given up.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 block/bdev.c           | 30 ++++++++++++++++++++++--------
 include/linux/blkdev.h |  1 +
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 939dec351772..e59052c2a081 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1199,18 +1199,16 @@ void bdev_release(struct file *bdev_file)
 }
 
 /**
- * bdev_fput - yield claim to the block device and put the file
+ * bdev_yield_claim - give up the holder claim on an open block device
  * @bdev_file: open block device
  *
- * Yield claim on the block device and put the file. Ensure that the
- * block device can be reclaimed before the file is closed which is a
- * deferred operation.
+ * Yield the holder and any write access for @bdev_file without closing it, so
+ * the caller can still act on the device - e.g. bdev_allow_freeze() it - before
+ * the final bdev_fput().  bdev_fput() yields too, so calling it afterwards is
+ * safe.
  */
-void bdev_fput(struct file *bdev_file)
+void bdev_yield_claim(struct file *bdev_file)
 {
-	if (WARN_ON_ONCE(bdev_file->f_op != &def_blk_fops))
-		return;
-
 	if (bdev_file->private_data) {
 		struct block_device *bdev = file_bdev(bdev_file);
 		struct gendisk *disk = bdev->bd_disk;
@@ -1226,7 +1224,23 @@ void bdev_fput(struct file *bdev_file)
 		bdev_file->private_data = BDEV_I(bdev_file->f_mapping->host);
 		mutex_unlock(&disk->open_mutex);
 	}
+}
+EXPORT_SYMBOL_GPL(bdev_yield_claim);
+
+/**
+ * bdev_fput - yield claim to the block device and put the file
+ * @bdev_file: open block device
+ *
+ * Yield claim on the block device and put the file. Ensure that the
+ * block device can be reclaimed before the file is closed which is a
+ * deferred operation.
+ */
+void bdev_fput(struct file *bdev_file)
+{
+	if (WARN_ON_ONCE(bdev_file->f_op != &def_blk_fops))
+		return;
 
+	bdev_yield_claim(bdev_file);
 	fput(bdev_file);
 }
 EXPORT_SYMBOL(bdev_fput);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cf1951caadb2..9fc16e3c8075 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1832,6 +1832,7 @@ int bdev_thaw(struct block_device *bdev);
 int bdev_deny_freeze(struct block_device *bdev);
 void bdev_allow_freeze(struct block_device *bdev);
 void bdev_fput(struct file *bdev_file);
+void bdev_yield_claim(struct file *bdev_file);
 
 struct io_comp_batch {
 	struct rq_list req_list;

-- 
2.47.3

