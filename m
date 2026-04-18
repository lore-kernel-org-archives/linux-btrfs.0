Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB0E389472
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776523113; cv=none; b=D+CXPd95vh1pgU1HmcOC7pyff+sU4kUO4AAjzkDxGdJPHMJP65EzGySNttebmh66qHCM6G050+ggFdYykZO8N7w23Tedn6Bc5J49e/l7rQguEUJYt9fu7PxOXHySv0brzxbRYcGzsv/D+rO27NF6DO4NAiUH7ZNS0DkbLNeOOQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776523113; c=relaxed/simple;
	bh=IdhZ3WUdx7zB10tyOdU4bio8EUpROdHL2ZfqaQJ0wIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYx7/338m6O7EcA+fsOOhXAUSoTm9P+ciHyh8c2mgvoj23YdFaXiirS0nAoGxytgZ4H/YctuueruOc/LyZJuPn1eV9vfQkp7AlPI6sd3mv1ZkL+NVCVYK96eKKxDsAECjxj1PezLgvmRJWZQXucNxyBJPUJNAytw208Cvef0S2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAxazqe3; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAxazqe3"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43d7650202fso1323590f8f.2
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 07:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776523110; x=1777127910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTlPDEPoP9ADf2eYN17rIW7H9UqxS19maP7pfEfukes=;
        b=RAxazqe32pR+hcGyyrU1Lk/rXuPsCVDKni2nFYbiqJKm7ME+gHLJF3RyD7TrxY/FlL
         UAdSTI2TYMYFovz+Fw7nC+JOfl+uxP6IrCE5EhAaAIC4T1evSElcpDsV8oRNi6uyloMC
         25EdBAh2QbSngUb/hLUf6XrZVe8BzLQziQhnC21WkfVm8WDx1DLT+O4DyGWCnBqxnkAi
         Fi4X5yeu5xCverHKeMlcpR+toSnybIthhezCfHTulS7bavHsQXcZHq6Hy+GIqMTNNJFz
         mN3yZWiwj8SzBRInhkRGvE2SeBg4OsBfrixnbCdlPsOz3vw9rMxsLRrUkzpeM2LXfoFd
         8j7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776523110; x=1777127910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RTlPDEPoP9ADf2eYN17rIW7H9UqxS19maP7pfEfukes=;
        b=mF+2ykJyDPshIsNcZNnq8fK0raEZgWamB2QsXmWenyCVPwY+L88FEyIyjpnvN/rknw
         B26140NY0TtrHN3bvqsZZ9/cl2AgxfWPtY5SYywP3tdrbefEeWNlFrDRfKcbmLoTYVLh
         uNWqEMj/uiDAt9RA9MOn7o3ePQPkXFBsVuiaV1XBYdKj9qvQPV/7OF7d+3jvt7sbRqWB
         rOnpOzwq/t9CDlJ4kp648Olulj5Kn5eME5s5I1EICmwXaVT+fm44d0PwDb9VgqUq4LkB
         05WuCxELJk/oWxpgP/a6nuM4XQAI6PbJarWGp6XpFfezOTd09MrW4/rIhDy17KK1BJbu
         0YVA==
X-Gm-Message-State: AOJu0YxOlpA7VvwEofDY53xtrci7WbxRheCd7CYN6cxmwc7w5CXXbuvn
	pgOxSneqqEa0HTJWy6qAO5TNMaKaVsr0R0R1PfC2JRHVqW9rs6bHuK8+ptrc9/zP
X-Gm-Gg: AeBDievggs+YTh4/frcy8GpCqK3ctuFVNcex6GutqLIPDRJg6GI2ry4nzP9ypHMSOCa
	Mtohy9fovQs1TwEoEiCkuaQ+E+pYeaNjicTPXeE/6QLPYYxVtxS25v65lB2vHba2ez7iFreYAF8
	ZCci8yCUsntwPWoZVoPYfUj1I75IG6gf732dXjO4cKUo86mUq3zi66UJssO3L9R5aenIeC35sSZ
	facfDdbLLoiIDdGtjGvcZ5cuWD5POvtr5r+rFy7UzFrg0z3RflWt49iJY0GL9ikKAWTDWoz2IqX
	Z3ZFEqemR43U6Ttn/ZndbQ2vy/ne04VlmvkJhlUP7cdl6gnrphUD2LcMpksdvaatSPRtzxANYIl
	h3RLxSYOs6LaXrFTJZ18JUQtJD5oSNo8id30PkyY0sWj1mThZhAWHb83nLEZ0n3f3TGEGYHWzV3
	QGUrhYpQAzx4XC+sARS2fEIXk5VudxeuS8KnGYfO1MoyWyo4EAuStJ2LUvc9fI/t0jzt/XoRe2i
	3KBaZFifrkPDhphLovG5EXJeqYj3ZscTyonC14=
X-Received: by 2002:a5d:5f47:0:b0:43b:998c:9bbe with SMTP id ffacd0b85a97d-43fe3dd3963mr10951108f8f.13.1776523110177;
        Sat, 18 Apr 2026 07:38:30 -0700 (PDT)
Received: from len.tail8322.ts.net (sgyl-44-b2-v4wan-166595-cust701.vm6.cable.virginm.net. [77.97.226.190])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a397sm14509303f8f.23.2026.04.18.07.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 07:38:29 -0700 (PDT)
From: Paul Richards <paul.richards@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	Paul Richards <paul.richards@gmail.com>
Subject: [PATCH 2/3] btrfs: support for FALLOC_FL_COLLAPSE_RANGE in btrfs_fallocate()
Date: Sat, 18 Apr 2026 15:38:07 +0100
Message-ID: <20260418143808.199603-3-paul.richards@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418143808.199603-1-paul.richards@gmail.com>
References: <20260418143808.199603-1-paul.richards@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assisted-by: Amazon Q Developer:auto/unknown
Signed-off-by: Paul Richards <paul.richards@gmail.com>
---
 fs/btrfs/file.c | 300 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 300 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0b5cc3cec675..99d24bef5f88 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -39,6 +39,13 @@
 #include "super.h"
 #include "print-tree.h"
 
+/*
+ * When we shift extents as part of fallocate insert or collapse we commit
+ * and cycle the transaction every BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL
+ * extents to avoid accumulating too many changes in one transaction.
+ */
+#define BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL (32)
+
 /*
  * Unlock folio after btrfs_file_write() is done with it.
  */
@@ -2648,6 +2655,296 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 	return ret;
 }
 
+/*
+ * Update the extent back-reference in the extent tree when a
+ * BTRFS_EXTENT_DATA_KEY item is shifted to a new logical file offset.
+ * Drops the back-reference at old_file_offset and adds one at new_file_offset.
+ * Holes (disk_bytenr == 0) and inline extents have no back-references and
+ * must not be passed to this function.
+ */
+static int btrfs_shift_extent_backref(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root, u64 ino,
+				      u64 disk_bytenr, u64 num_bytes,
+				      u64 old_file_offset, u64 new_file_offset)
+{
+	struct btrfs_ref ref = {
+		.bytenr = disk_bytenr,
+		.num_bytes = num_bytes,
+		.parent = 0,
+		.owning_root = btrfs_root_id(root),
+		.ref_root = btrfs_root_id(root),
+	};
+	int ret;
+
+	ref.action = BTRFS_DROP_DELAYED_REF;
+	btrfs_init_data_ref(&ref, ino, old_file_offset, 0, false);
+	ret = btrfs_free_extent(trans, &ref);
+	if (unlikely(ret)) {
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
+
+	ref.action = BTRFS_ADD_DELAYED_REF;
+	btrfs_init_data_ref(&ref, ino, new_file_offset, 0, false);
+	ret = btrfs_inc_extent_ref(trans, &ref);
+	if (unlikely(ret))
+		btrfs_abort_transaction(trans, ret);
+
+	return ret;
+}
+
+static int btrfs_collapse_range(struct inode *inode, loff_t offset, loff_t len)
+{
+	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u64 end = offset + len;
+	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans = NULL;
+	struct extent_state *cached_state = NULL;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	struct btrfs_key new_key;
+	u64 ino = btrfs_ino(BTRFS_I(inode));
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL))
+		return -EOPNOTSUPP;
+
+	/* offset and len must be sector-aligned */
+	if (!IS_ALIGNED(offset | len, fs_info->sectorsize))
+		return -EINVAL;
+
+	/* collapse range must not reach or pass EOF - use ftruncate instead */
+	if (end >= inode->i_size)
+		return -EINVAL;
+
+	btrfs_info(fs_info,
+		   "btrfs_collapse_range: ino=%llu offset=%lld len=%lld i_size=%lld",
+		   btrfs_ino(BTRFS_I(inode)), offset, len, inode->i_size);
+
+	/* wait for any ordered extents in [offset, i_size) to complete */
+	ret = btrfs_wait_ordered_range(BTRFS_I(inode), offset,
+				       inode->i_size - offset);
+	if (ret)
+		return ret;
+
+	/*
+	 * Flush dirty pages and invalidate the page cache for [offset, i_size)
+	 * before any extent manipulation, following the ext4/xfs pattern.
+	 * We hold BTRFS_ILOCK_MMAP so no new dirty pages can appear during
+	 * the operation. The page cache must be empty before we shift extent
+	 * keys so that stale pages at the old offsets cannot be read back
+	 * after the collapse.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	if (ret)
+		return ret;
+	btrfs_info(fs_info,
+		   "btrfs_collapse_range: nrpages before upfront invalidate=%lu (pages before offset=%llu not invalidated)",
+		   inode->i_mapping->nrpages, offset >> PAGE_SHIFT);
+	truncate_pagecache_range(inode, offset, LLONG_MAX);
+	btrfs_info(fs_info,
+		   "btrfs_collapse_range: nrpages after upfront invalidate=%lu (expected %llu)",
+		   inode->i_mapping->nrpages, offset >> PAGE_SHIFT);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/*
+	 * Lock the range [offset, end) and invalidate the page cache within
+	 * it. btrfs_punch_hole_lock_range() calls truncate_pagecache_range()
+	 * internally in a retry loop.
+	 */
+	btrfs_punch_hole_lock_range(inode, offset, end - 1, &cached_state);
+
+	/*
+	 * Remove all extents in [offset, end). Passing NULL for extent_info
+	 * means we are punching a hole. btrfs_replace_file_extents() splits
+	 * any extent straddling the boundaries, drops extent refs, and
+	 * returns a transaction handle for us to reuse.
+	 */
+	ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
+					 offset, end - 1, NULL, &trans);
+	btrfs_info(fs_info,
+		   "btrfs_collapse_range: btrfs_replace_file_extents ret=%d nrpages=%lu",
+		   ret, inode->i_mapping->nrpages);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Shift all BTRFS_EXTENT_DATA_KEY items with key.offset >= end
+	 * leftward by len bytes.
+	 *
+	 * We iterate forward (lowest offset first) which is safe for a
+	 * left-shift because the new key is always less than the old one,
+	 * so we never collide with a key we haven't visited yet.
+	 */
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = end;
+
+	int nr_shifted = 0;
+	while (1) {
+		struct btrfs_file_extent_item *fi;
+		u64 disk_bytenr;
+		u64 num_bytes;
+		u64 extent_offset;
+		int extent_type;
+
+		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+		if (ret < 0)
+			goto out_trans;
+
+		/* If no exact match, slot points at the next item - that's fine */
+
+		leaf = path->nodes[0];
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out_trans;
+			if (ret > 0) {
+				/* No more items - we are done shifting */
+				ret = 0;
+				break;
+			}
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+		/* Stop if we've moved past this inode's extent data items */
+		if (key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY) {
+			ret = 0;
+			break;
+		}
+
+		btrfs_info(fs_info,
+			   "btrfs_collapse_range: shifting key offset %llu -> %llu",
+			   key.offset, key.offset - len);
+
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		extent_type = btrfs_file_extent_type(leaf, fi);
+		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		extent_offset = btrfs_file_extent_offset(leaf, fi);
+
+		memcpy(&new_key, &key, sizeof(new_key));
+		new_key.offset -= len;
+		btrfs_set_item_key_safe(trans, path, &new_key);
+
+		/*
+		 * Update the back-reference in the extent tree to reflect the
+		 * new logical file offset. Holes (disk_bytenr == 0) and inline
+		 * extents have no back-references to update.
+		 */
+		if (extent_type != BTRFS_FILE_EXTENT_INLINE && disk_bytenr > 0) {
+			ret = btrfs_shift_extent_backref(trans, root, ino,
+					disk_bytenr, num_bytes,
+					key.offset - extent_offset,
+					new_key.offset - extent_offset);
+			if (unlikely(ret))
+				goto out_trans;
+		}
+
+		/* Advance to the next item on the next iteration */
+		key.offset = new_key.offset + 1;
+		nr_shifted++;
+
+		/*
+		 * Cycle the transaction every N items to avoid holding a
+		 * single transaction open across a large number of extent
+		 * items. btrfs_set_item_key_safe() modifies leaves in-place
+		 * so we won't hit -ENOSPC; we use a simple counter instead.
+		 * Update the inode at each cycle point so it is consistent
+		 * on disk if a crash occurs mid-loop.
+		 */
+		if (nr_shifted % BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL == 0) {
+			btrfs_info(fs_info,
+			   "btrfs_collapse_range: cycling transaction, nr_shifted=%d", nr_shifted);
+			inode_inc_iversion(inode);
+			inode_set_mtime_to_ts(inode,
+					      inode_set_ctime_current(inode));
+			ret = btrfs_update_inode(trans, BTRFS_I(inode));
+			if (ret) {
+				btrfs_release_path(path);
+				goto out_trans;
+			}
+			btrfs_end_transaction(trans);
+			btrfs_btree_balance_dirty(fs_info);
+			trans = btrfs_start_transaction(root, 1);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				trans = NULL;
+				btrfs_release_path(path);
+				goto out_unlock;
+			}
+		}
+
+		btrfs_release_path(path);
+	}
+
+	if (ret)
+		goto out_trans;
+
+	/* Update i_size and the on-disk inode */
+	btrfs_info(fs_info,
+		   "btrfs_collapse_range: updating i_size %lld -> %lld nrpages=%lu",
+		   inode->i_size, inode->i_size - len, inode->i_mapping->nrpages);
+	/*
+	 * Drop the extent map cache for [offset, i_size) so that subsequent
+	 * reads re-load the correct mappings from the btree. The key-shift
+	 * loop updated the btree but the in-memory extent map cache still
+	 * has entries at the old logical offsets.
+	 */
+	btrfs_drop_extent_map_range(BTRFS_I(inode), offset, (u64)-1, false);
+	inode_inc_iversion(inode);
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	i_size_write(inode, inode->i_size - len);
+	btrfs_inode_safe_disk_i_size_write(BTRFS_I(inode), 0);
+	ret = btrfs_update_inode(trans, BTRFS_I(inode));
+
+out_trans:
+	if (trans) {
+		if (ret)
+			btrfs_end_transaction(trans);
+		else
+			ret = btrfs_end_transaction(trans);
+	}
+out_unlock:
+	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, offset, end - 1,
+			    &cached_state);
+	btrfs_info(fs_info,
+		   "btrfs_collapse_range: post-unlock ret=%d i_size=%lld, invalidating page cache from %lld",
+		   ret, inode->i_size, offset);
+	if (IS_ENABLED(CONFIG_BTRFS_DEBUG) && !ret) {
+		/*
+		 * These are expected to be no-ops: ordered extents were drained
+		 * at the start of this function and BTRFS_ILOCK_MMAP has been
+		 * held throughout, so no new writes could have been submitted.
+		 * The page cache was emptied from offset onwards upfront and
+		 * nrpages in that region stayed 0 throughout the operation.
+		 * Pages before offset are unaffected and may still be cached.
+		 */
+		int wait_ret = btrfs_wait_ordered_range(BTRFS_I(inode), offset,
+						    inode->i_size);
+		btrfs_info(fs_info,
+			   "btrfs_collapse_range: post-shift wait_ordered ret=%d",
+			   wait_ret);
+		ASSERT(wait_ret == 0);
+		ASSERT(filemap_range_has_page(inode->i_mapping, offset,
+					      LLONG_MAX) == false);
+		truncate_pagecache_range(inode, offset, LLONG_MAX);
+		btrfs_info(fs_info,
+			   "btrfs_collapse_range: truncate_pagecache_range done");
+		ASSERT(filemap_range_has_page(inode->i_mapping, offset,
+					      LLONG_MAX) == false);
+	}
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
@@ -3296,6 +3593,9 @@ static long btrfs_fallocate(struct file *file, int mode,
 	case FALLOC_FL_PUNCH_HOLE:
 		ret = btrfs_punch_hole(file, offset, len);
 		break;
+	case FALLOC_FL_COLLAPSE_RANGE:
+		ret = btrfs_collapse_range(inode, offset, len);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 	}
-- 
2.53.0

