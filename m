Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8636943CEF7;
	Tue, 16 Jun 2026 11:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611113; cv=none; b=LNlG2eTTNKRFRHXIwP6wy8JIWfoE2FGlWAjeUcGYnfTfy80RAr/H0SOuC/ViuyH2keeQH0YiLzcqx2GxJRzJvyQwoj+Murlw8V3PzWAeUX20WnYqIgAePA4s+EH/EaEPj9WIcnbi6Caj2xDIFYswqMuPAG9AOq+Yw3uczEq9yGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611113; c=relaxed/simple;
	bh=Ixzv6yAi5S9Stc1OOoEORXM1J8ggs5ooEZV04a1LyKo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Md0kLOTOk7X4zzgVAiT46xY5GnD2OiTZl3B+dm/ksEgpWLIsvF1I+i8J2kM2ZOy6lbslFCNZXwsKoDGfa/Xki1Cepcajo/9woui5OoVYZqIQY+jGqZaLJmQ6czu0Zd8kfsZutx93v4C1XR6NjgFpzzu05W3hNGbmNDgxso4wE/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i82RHw5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i82RHw5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7511F000E9;
	Tue, 16 Jun 2026 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781611112;
	bh=3PLiy9WiJPPZXBWXNTUTvDVFuBQH9W/qreDaX4RfTqA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i82RHw5XFH5Hb5JbvgDYdwK1nNAw/Y2wMELMi4U/ZoMlKyTd2KTVJPd1NaR9gd3QS
	 JqRqwakNjeQ4wqM8wyXbdQnO7rj9NJozqszVSt1nLk1rj+NsrZKdkj3TlYOx7qB+bn
	 a+yt/fnC71Gq3H9PDTLDbXnKnARnh/JhlKvx20EA1/8q1sT5MNymp2GFgU/cj8kkAE
	 K+N3focEsIRx2kcUTahEiUMOauiMD4CwL0eOM6ZgYJI/0hpYRjW+sAnYZnP8Isk6vj
	 IrtVCIreMQEcwHWhYZkUGQ4An6I7p4KmxGFd3mQxRDLNAtwuCyZ0/LymVDGDRuvcOd
	 7qY3EcjA6HBvQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 13:58:15 +0200
Subject: [PATCH v2 2/5] block: split bdev_yield_claim() out of bdev_fput()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-freeze_deny_upstream-v2-2-b3567c7f994b@kernel.org>
References: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
In-Reply-To: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3644; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Ixzv6yAi5S9Stc1OOoEORXM1J8ggs5ooEZV04a1LyKo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZWiUkJ3bz/DIrW1l8226T7535pQlM+1WndKT17HwyW
 +pgieOljlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInsnsPwP8/9OI/Hk1eTmPvv
 GK4rbbzYcrLm35SVH/5zRO66/lr31VeGP9y8aoI5+91keOJYDWYyxaXsbxfM+Xpz8T/e92wGdyb
 eZAcA
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
 block/bdev.c           | 50 ++++++++++++++++++++++++++++++++++----------------
 include/linux/blkdev.h |  1 +
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index a83a3809380c..54b35a084c36 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1200,6 +1200,39 @@ void bdev_release(struct file *bdev_file)
 	blkdev_put_no_open(bdev);
 }
 
+/**
+ * bdev_yield_claim - give up the holder claim on an open block device
+ * @bdev_file: open block device
+ *
+ * Yield the holder and any write access for @bdev_file without closing it, so
+ * the caller can still act on the device - e.g. bdev_allow_freeze() it - before
+ * the final bdev_fput().  bdev_fput() yields too, so calling it afterwards is
+ * safe.
+ */
+void bdev_yield_claim(struct file *bdev_file)
+{
+	struct block_device *bdev;
+	struct gendisk *disk;
+
+	if (!bdev_file->private_data)
+		return;
+
+	bdev = file_bdev(bdev_file);
+	disk = bdev->bd_disk;
+
+	mutex_lock(&disk->open_mutex);
+	bdev_yield_write_access(bdev_file);
+	bd_yield_claim(bdev_file);
+	/*
+	 * Tell release we already gave up our hold on the
+	 * device and if write restrictions are available that
+	 * we already gave up write access to the device.
+	 */
+	bdev_file->private_data = BDEV_I(bdev_file->f_mapping->host);
+	mutex_unlock(&disk->open_mutex);
+}
+EXPORT_SYMBOL_GPL(bdev_yield_claim);
+
 /**
  * bdev_fput - yield claim to the block device and put the file
  * @bdev_file: open block device
@@ -1213,22 +1246,7 @@ void bdev_fput(struct file *bdev_file)
 	if (WARN_ON_ONCE(bdev_file->f_op != &def_blk_fops))
 		return;
 
-	if (bdev_file->private_data) {
-		struct block_device *bdev = file_bdev(bdev_file);
-		struct gendisk *disk = bdev->bd_disk;
-
-		mutex_lock(&disk->open_mutex);
-		bdev_yield_write_access(bdev_file);
-		bd_yield_claim(bdev_file);
-		/*
-		 * Tell release we already gave up our hold on the
-		 * device and if write restrictions are available that
-		 * we already gave up write access to the device.
-		 */
-		bdev_file->private_data = BDEV_I(bdev_file->f_mapping->host);
-		mutex_unlock(&disk->open_mutex);
-	}
-
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

