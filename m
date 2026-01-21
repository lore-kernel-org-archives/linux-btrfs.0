Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944F24218A8
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013060; cv=none; b=kmf5ZM+erxap39ZCiYCrB6n1OhRm9asQ6ogibwNa3fhE6KvUcEWwL4Rc5M5kqsnXrDWFo7hpUEB9MmyLuemrjUaX+h3cYY0g0OmkE5vkQ1AWWdwHnT7Ab+G87HLC+0UYTMxA1/OEcxlTiHPwk51Xt8DO0+lRGssU7Zg039PxihM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013060; c=relaxed/simple;
	bh=fqg+D9PceXDTkAQibhXYCBJxcdCyKQdtYF8gTEoVwMc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koKgVsx34fnTkEla88uRtxNfffio/TM0hOvOOOOMUlwNsSIWyETurWsssd/8HUma3+Q07UR+tR/OB08YKa8g4dN7OqGQM+ZjEZ4sXUJW34XlYmEcC8ZJ77LjqA7nCVQnhSGe8ihEGjlRHyoXwMfNOZAN7Ame7A4oqbnF0ysBAsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0aPtn5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0aPtn5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C98C4CEF1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013060;
	bh=fqg+D9PceXDTkAQibhXYCBJxcdCyKQdtYF8gTEoVwMc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=t0aPtn5rZXUZ3WMOZRZGUrhztL1S7pioVQUV+CzqUAQHrgdnsnFci+wMw35xnvWbZ
	 0wghikiKNZlk5UTHtjkA0YdfiXw+icLWnFQM9ZOU2kVn3iV+5GXmdCgs67pAvpFj6D
	 w4fdIhvmjtnY/gEB0c7/ZJW+e4ieIRCq+Rl2fBN93LhTpcwlXtr8sgheCVzkGtyHCP
	 httfBqChHXY6qrQyFjlaXk06FZ5eP116wVzIWgPAezhv0lrlhAr7DN+INe6Z4PMAvY
	 O3CnQEaRaURmeQ14Vb0nUkFdrCkPxy2x6G0yJ7ZNiTn4N48v/CWHJQnDF1UYpECRb3
	 GgUS0SbuWl/hw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 13/19] btrfs: remove out label in btrfs_mark_extent_written()
Date: Wed, 21 Jan 2026 16:30:39 +0000
Message-ID: <caf261a36800f9d85008208c9ebab7470a759904.1769012877.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1769012876.git.fdmanana@suse.com>
References: <cover.1769012876.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no point in having the label since all it does is return the
value in the 'ret' variable. Instead make every goto return directly
and remove the label.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1759776d2d57..56ece1109832 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -565,7 +565,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	int del_nr = 0;
 	int del_slot = 0;
 	int recow;
-	int ret = 0;
+	int ret;
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
@@ -580,7 +580,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret < 0)
-		goto out;
+		return ret;
 	if (ret > 0 && path->slots[0] > 0)
 		path->slots[0]--;
 
@@ -589,20 +589,20 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	if (unlikely(key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY)) {
 		ret = -EINVAL;
 		btrfs_abort_transaction(trans, ret);
-		goto out;
+		return ret;
 	}
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 	if (unlikely(btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_PREALLOC)) {
 		ret = -EINVAL;
 		btrfs_abort_transaction(trans, ret);
-		goto out;
+		return ret;
 	}
 	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
 	if (unlikely(key.offset > start || extent_end < end)) {
 		ret = -EINVAL;
 		btrfs_abort_transaction(trans, ret);
-		goto out;
+		return ret;
 	}
 
 	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
@@ -632,7 +632,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 							 trans->transid);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							end - other_start);
-			goto out;
+			return 0;
 		}
 	}
 
@@ -660,7 +660,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 							other_end - start);
 			btrfs_set_file_extent_offset(leaf, fi,
 						     start - orig_offset);
-			goto out;
+			return 0;
 		}
 	}
 
@@ -676,7 +676,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		}
 		if (unlikely(ret < 0)) {
 			btrfs_abort_transaction(trans, ret);
-			goto out;
+			return ret;
 		}
 
 		leaf = path->nodes[0];
@@ -704,7 +704,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
-			goto out;
+			return ret;
 		}
 
 		if (split == start) {
@@ -713,7 +713,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			if (unlikely(start != key.offset)) {
 				ret = -EINVAL;
 				btrfs_abort_transaction(trans, ret);
-				goto out;
+				return ret;
 			}
 			path->slots[0]--;
 			extent_end = end;
@@ -744,7 +744,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		ret = btrfs_free_extent(trans, &ref);
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
-			goto out;
+			return ret;
 		}
 	}
 	other_start = 0;
@@ -762,7 +762,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		ret = btrfs_free_extent(trans, &ref);
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
-			goto out;
+			return ret;
 		}
 	}
 	if (del_nr == 0) {
@@ -783,11 +783,11 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
 		if (unlikely(ret < 0)) {
 			btrfs_abort_transaction(trans, ret);
-			goto out;
+			return ret;
 		}
 	}
-out:
-	return ret;
+
+	return 0;
 }
 
 /*
-- 
2.47.2

