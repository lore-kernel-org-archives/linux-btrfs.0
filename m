Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433251;
	b=Ok/1h7mHPPbhyGNAo98qUWSbSus0b0GfS8Yzqtnt8koNnLK+gCIscpuEwegx9asc+ibN
	 GQnl/N7iqVyIG8yeNEfOwX10MtKJreYcvmGtnNmqz4j8v6t+v2ZAgn+WpN9uZu+ddt7NA
	 VXnUJjEbf+8fX4ePDzMVC1X8gLlfT18xR1CjWsiompWZ+YqTqvrKGnrspE0bXaSYVnSX6
	 N6CqKwRSBP59AY1WgaL1oFIRIlh5JUV5sxax7jEjSe1y5yGNpojh+kJMmWxCH1JlNLXD2
	 TWEd/AMk6HpEmRd/pCY6W48Xo83cIqwkPgAOO8f5t7JhUOBBsbudUlkyX74hpzV2MUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433251;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Y2jwJ2NTvmtm+WBZepBJfO5bOCBEg5jfeoiK+7/9EH8=;
	b=OedRRN/kq9+8kt829JpnCkFUjU9v6eRP68cSOl28eepzme8GOQe4pcyXdbkM6IW5n6f0
	 3PYfwYye+Z/x01GYn5vj6UyhP/XsjMR6kwP2/MCcEZmEBbLpnY+BJ6th7n4XmhImwIhNR
	 C3e2zZIPyO38ihh0Lqjhr+U+Al1r+l/rrFpaUseehDis1zi09xQcK0+tnVJi9MG9PJJBz
	 jn7wmAs15D4yCb1glH8L1DAsoOCyt7rEhmWGyl5uEjvl+9fHQHAroRFWLC0SJHmhV2kdU
	 Vt6uN21Oj8RdfRt8LGteVXwEnjarNXBltgDF0oR3y8Ty8582x1CuYeeYmZadreD67fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQOzzKpu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A024606A332
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQOzzKpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B18E1F000C4
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795433250;
	bh=Y2jwJ2NTvmtm+WBZepBJfO5bOCBEg5jfeoiK+7/9EH8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=eQOzzKpuhsTwKDPNZq0NV8+377myVBi7eZ5tda+Tn7bXPGwR4+7ain5owFAz+zWlw
	 nzcHuEkOUjpE21mU3kZfslRQlqpq5jW66rP43mP4ST0+ow+46h2j1+3SiW5e3txjd2
	 tNreb8mgg4+x7Pwe/tncp2urG6yhlZUFDlIJZLj2H+qFaYBDsGzGMdz87sI3++t/U0
	 lomRxuPL5E/qZfIOl2HY3BjHSZIjn7DHrv/CSSlYfuuznbc1dJr8bXmTStd4+8uuEH
	 bmRKtAcZn6Hq5Joi8P5M8iYRqvqE5Bg7Cobj7OTozBmvVDIyYfbxAqX+X4QYOkjic1
	 czLeejpd8IGeQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: use boolean types in struct btrfs_dev_replace
Date: Mon, 23 Nov 2026 11:27:25 +0000
Message-ID: <1a7049ace4e3c55d278bf28b8b3f4e30093af892.1795433118.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795433118.git.fdmanana@suse.com>
References: <cover.1795433118.git.fdmanana@suse.com>
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

From: Filipe Manana <fdmanana@suse.com>

The members "is_valid" and "item_needs_writeback" are defined as integers
but are used as booleans, so change their type from int to bool for better
readability.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/dev-replace.c | 20 ++++++++++----------
 fs/btrfs/fs.h          |  4 ++--
 fs/btrfs/scrub.c       |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6f04d0a49d86..9fc0c15a5343 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -117,8 +117,8 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		dev_replace->cursor_right = 0;
 		dev_replace->srcdev = NULL;
 		dev_replace->tgtdev = NULL;
-		dev_replace->is_valid = 0;
-		dev_replace->item_needs_writeback = 0;
+		dev_replace->is_valid = false;
+		dev_replace->item_needs_writeback = false;
 		return 0;
 	}
 	slot = path->slots[0];
@@ -147,9 +147,9 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 	dev_replace->committed_cursor_left = dev_replace->cursor_left;
 	dev_replace->cursor_left_last_write_of_item = dev_replace->cursor_left;
 	dev_replace->cursor_right = btrfs_dev_replace_cursor_right(eb, ptr);
-	dev_replace->is_valid = 1;
+	dev_replace->is_valid = true;
 
-	dev_replace->item_needs_writeback = 0;
+	dev_replace->item_needs_writeback = false;
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
@@ -435,7 +435,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans)
 		dev_replace->cursor_left_last_write_of_item);
 	btrfs_set_dev_replace_cursor_right(eb, ptr,
 		dev_replace->cursor_right);
-	dev_replace->item_needs_writeback = 0;
+	dev_replace->item_needs_writeback = false;
 	up_write(&dev_replace->rwsem);
 
 	return ret;
@@ -677,8 +677,8 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->committed_cursor_left = 0;
 	dev_replace->cursor_left_last_write_of_item = 0;
 	dev_replace->cursor_right = 0;
-	dev_replace->is_valid = 1;
-	dev_replace->item_needs_writeback = 1;
+	dev_replace->is_valid = true;
+	dev_replace->item_needs_writeback = true;
 	atomic64_set(&dev_replace->num_write_errors, 0);
 	atomic64_set(&dev_replace->num_uncorrectable_read_errors, 0);
 	up_write(&dev_replace->rwsem);
@@ -946,7 +946,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	dev_replace->tgtdev = NULL;
 	dev_replace->srcdev = NULL;
 	dev_replace->time_stopped = ktime_get_real_seconds();
-	dev_replace->item_needs_writeback = 1;
+	dev_replace->item_needs_writeback = true;
 
 	/*
 	 * Update allocation state in the new device and replace the old device
@@ -1158,7 +1158,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		dev_replace->replace_state =
 				BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
 		dev_replace->time_stopped = ktime_get_real_seconds();
-		dev_replace->item_needs_writeback = 1;
+		dev_replace->item_needs_writeback = true;
 
 		up_write(&dev_replace->rwsem);
 
@@ -1208,7 +1208,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 		dev_replace->replace_state =
 			BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
 		dev_replace->time_stopped = ktime_get_real_seconds();
-		dev_replace->item_needs_writeback = 1;
+		dev_replace->item_needs_writeback = true;
 		btrfs_info(fs_info, "suspending dev_replace for unmount");
 		/* Reopened freezable next mount; resume re-denies. */
 		if (dev_replace->srcdev && dev_replace->srcdev->bdev)
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..cdb78c8e1b4b 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -378,8 +378,8 @@ struct btrfs_dev_replace {
 	/* See #define above */
 	u64 cont_reading_from_srcdev_mode;
 
-	int is_valid;
-	int item_needs_writeback;
+	bool is_valid;
+	bool item_needs_writeback;
 	struct btrfs_device *srcdev;
 	struct btrfs_device *tgtdev;
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a8c62a3aea0c..c8da03e14094 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2928,7 +2928,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		down_write(&dev_replace->rwsem);
 		dev_replace->cursor_right = found_key.offset + dev_extent_len;
 		dev_replace->cursor_left = found_key.offset;
-		dev_replace->item_needs_writeback = 1;
+		dev_replace->item_needs_writeback = true;
 		up_write(&dev_replace->rwsem);
 
 		ret = scrub_chunk(sctx, cache, scrub_dev, found_key.offset,
@@ -2940,7 +2940,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		down_write(&dev_replace->rwsem);
 		dev_replace->cursor_left = dev_replace->cursor_right;
-		dev_replace->item_needs_writeback = 1;
+		dev_replace->item_needs_writeback = true;
 		up_write(&dev_replace->rwsem);
 
 		if (ro_set)
-- 
2.53.0

