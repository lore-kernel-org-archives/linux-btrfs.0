Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD4389472
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776523117; cv=none; b=Ujn0HRgEmmsdjSnB31jWJ9YQBtiUaJUiZAlkKwNWbR8GbMcB359Px2zWztm3yRsRmkA1Sdl/vxK6mbZFVResB3khFbG5/Q0HoxuXSzMDvHpEjX1mY6L1X9STIZicZ6iw5hrrvVp8xf+RqW87zHC7UGgUZgwr4xXm/F6h7c1rc/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776523117; c=relaxed/simple;
	bh=qSMrIYbPB05ge12X+y3Av09OzKgQ5IdeBH0L6iKMnnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIKQ391S0AATABzmRPPx89PhMkJxZ7kIo8ZYMf3xNxqlhJJPns4YvsgafZbPaVKOSmUapOlmCX1INSs1Hy8U5HN8fRUm3y6JEe7E+qve06zG9kF3Bm3lWBm7EtIAFYnJ3DcDluW0AMse+OGIlK/q2k5F38nlvuRsHRsAsdjRbvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTOWrwz5; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTOWrwz5"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d7645adbdso920648f8f.1
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 07:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776523113; x=1777127913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnJNlFPESeWmEBJ8xNZADIHMqM23M0DOcweTPG/45EM=;
        b=FTOWrwz5Uc7WFtIMLNMS/UFhAr8cHaYCA4e3BX6qZiKmICTZlnOFWJeKIJCoYnYqH2
         CICsin3Ctwt4Ur2tfoq6uikLpcM8u3Ux5u0f3UyttV0mPKhVFFoYgAm+98UWvPxMGlpc
         dT5v8KwnBF3b88i7fEfxH+E4zgYvbsb3ZczHjpmjfJlzjxE2s4OuH4MyZ2kWaoHmGAca
         aAPsCFRqCwWoD559M5KFz5sDgiocdxhbZnH0BygclmRnOcxbnmNnkYUHFxdI+d2wE1EL
         2lr5Fgky4wl98Bk0m5/GXsoLO7bP6CzgjtTcBnQaxPho1Zpx2iSWaw0bffNnvP5NaR9P
         xUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776523113; x=1777127913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WnJNlFPESeWmEBJ8xNZADIHMqM23M0DOcweTPG/45EM=;
        b=mr3wdZ392sE6bRorKxb9gCuJJUcYuOet4/xuVXA+ocORviYI2mQEuUVBN1dY5QuzY3
         paxQqqvXWjqae+cSIeCMDGg1ehZhaa49+BxIan/OSfVn6GScz8sfvkMKBplL+fvNIgt6
         eqm7GcDmRS86ZIVUFiydgc1Eq8U8kmoctcSVGzJ0hMgVta8eVupDVsu/FVaZBIjvu9lg
         4f7DFG9i3yxM1tgMSOmbOeOeHEILFilmhFLd2bubEwuUX3J9pMUJd3z/LMqixdnl/jiR
         rN1Z5mrisWw88C4lwTt2s+4N9+q3HX204x9ypAuZhvGPfSnU4BC/UTQ/+8j1+T+3wS2D
         OZxg==
X-Gm-Message-State: AOJu0YwkksZYCMEpjeFzlPQF4PLM+YjUSAq+Ce5l67lz3kRMp/0ZoOvN
	/xaV+rueFdYuW4UYGNW29MgV8oCc7mwmXkzJn+8VkCjuTTgydoUNdHjCnhoVpMzV
X-Gm-Gg: AeBDieuZxL8oHjU7xizXkFvxmTTrHGyXQW+ZURvVS+xMjkDqRCX53AxoODniec3emM3
	5Ih4pGeiRRA7jncOTNpyvxseJapd1okZHp0okNRjMtdrBKHMV0ZeKp+ZBcKriN+G3zD7V0ygsju
	5aLQKRtiblLw5FY+CAonYCYY2ViRm2Q3mm/hXQfJzKyBS7e8VXeHk3QPGBupys7LrBMfvn9KPKH
	wz3kAq+7pAxJYlgfCm3VXxjLkIFBSNAYoJCOYPiTMVckAEbbex6eyA69vKEK81SzOjJ5U7Uc0sf
	WQluMMedXhJ0Cv4MDvYrpiS1oRedcqwssv1Zw/HHarjdk7hnjDWJ7pX+iolo8yNenOkeilVEryX
	gU8RuHrFSo7is8quCH23UeQT1IrDEjtj3v4an0WHTnyLfidFA+0lRB1KntsplLTfrsD3VpcFfW8
	xdZlQwgc/JA68RVgOz5VZAtoDeVJWx3s77k1M3dqudRtSdcSwpRaOg95LMcHpmgUQuU7pfslIdj
	Qn3JhR0bNOOvO+auXnE94Fni9ELpLi+o2Vcrd4=
X-Received: by 2002:a05:6000:1a8c:b0:43e:b0f8:66f1 with SMTP id ffacd0b85a97d-43fe3e0b86emr10325629f8f.43.1776523113395;
        Sat, 18 Apr 2026 07:38:33 -0700 (PDT)
Received: from len.tail8322.ts.net (sgyl-44-b2-v4wan-166595-cust701.vm6.cable.virginm.net. [77.97.226.190])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a397sm14509303f8f.23.2026.04.18.07.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 07:38:32 -0700 (PDT)
From: Paul Richards <paul.richards@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	Paul Richards <paul.richards@gmail.com>
Subject: [PATCH 3/3] btrfs: support for FALLOC_FL_INSERT_RANGE in btrfs_fallocate()
Date: Sat, 18 Apr 2026 15:38:08 +0100
Message-ID: <20260418143808.199603-4-paul.richards@gmail.com>
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
 fs/btrfs/file.c | 238 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 238 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 99d24bef5f88..b708bb6a1082 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2945,6 +2945,241 @@ static int btrfs_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	return ret;
 }
 
+static int btrfs_insert_range(struct inode *inode, loff_t offset, loff_t len)
+{
+	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans = NULL;
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
+	/* offset must be within the file - use ftruncate to extend */
+	if (offset >= inode->i_size)
+		return -EINVAL;
+
+	/* result must not exceed the maximum file size */
+	if (len > inode->i_sb->s_maxbytes - inode->i_size)
+		return -EFBIG;
+
+	btrfs_info(fs_info,
+		   "btrfs_insert_range: ino=%llu offset=%lld len=%lld i_size=%lld",
+		   btrfs_ino(BTRFS_I(inode)), offset, len, inode->i_size);
+
+	/* wait for any ordered extents in [offset, i_size) to complete */
+	ret = btrfs_wait_ordered_range(BTRFS_I(inode), offset,
+				       inode->i_size - offset);
+	if (ret)
+		return ret;
+
+	/*
+	 * Flush and invalidate the page cache for [offset, i_size) upfront,
+	 * following the same pattern as btrfs_collapse_range().
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	if (ret)
+		return ret;
+	truncate_pagecache_range(inode, offset, LLONG_MAX);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		goto out_path;
+	}
+
+	/*
+	 * Shift all BTRFS_EXTENT_DATA_KEY items with key.offset >= offset
+	 * rightward by len bytes.
+	 *
+	 * We must iterate in reverse order (highest offset first) to avoid
+	 * colliding with a key we haven't shifted yet - shifting forward
+	 * would overwrite the next item's key before we process it.
+	 *
+	 * No pre-splitting of straddling extents is needed. If an extent
+	 * straddles offset, the left portion (key.offset < offset) stays
+	 * in place and the right portion is shifted. Both reference the
+	 * same physical extent via their existing extent_offset fields,
+	 * which remain correct after the key shift.
+	 */
+
+	int nr_shifted = 0;
+
+	/* Find the last extent item for this inode */
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = (u64)-1;
+
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
+		/*
+		 * Search for (ino, EXTENT_DATA, -1) will never find an exact
+		 * match, so ret == 1 and slot points one past the last item.
+		 * Step back one slot to land on the last extent item.
+		 */
+		if (path->slots[0] == 0) {
+			/* No items at all - nothing to shift */
+			ret = 0;
+			break;
+		}
+		path->slots[0]--;
+
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+		/* If we've gone past this inode's items, we are done */
+		if (key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY) {
+			ret = 0;
+			break;
+		}
+
+		/* If this item is before the insertion point, we are done */
+		if (key.offset < offset) {
+			ret = 0;
+			break;
+		}
+
+		btrfs_info(fs_info,
+			   "btrfs_insert_range: shifting key offset %llu -> %llu",
+			   key.offset, key.offset + len);
+
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		extent_type = btrfs_file_extent_type(leaf, fi);
+		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		extent_offset = btrfs_file_extent_offset(leaf, fi);
+
+		/*
+		 * Inline extents must have key.offset == 0 and cannot be
+		 * shifted to a non-zero offset - the tree checker enforces
+		 * this invariant. Reject with -EOPNOTSUPP.
+		 *
+		 * An inline extent can only exist if the file's entire content
+		 * fits within a single sector, meaning it is the only extent
+		 * item for this inode. It will therefore always be the first
+		 * item we encounter in the reverse iteration, before any keys
+		 * have been shifted, so bailing here leaves the file in a
+		 * consistent state.
+		 *
+		 * TODO: support this case by converting the inline extent to
+		 * a regular extent first, then shifting it. This would allow
+		 * INSERT_RANGE on small files, which xfs supports.
+		 */
+		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+			ret = -EOPNOTSUPP;
+			btrfs_release_path(path);
+			goto out_trans;
+		}
+
+		memcpy(&new_key, &key, sizeof(new_key));
+		new_key.offset += len;
+		btrfs_set_item_key_safe(trans, path, &new_key);
+
+		/* Update back-reference: drop old offset, add new offset */
+		if (extent_type != BTRFS_FILE_EXTENT_INLINE && disk_bytenr > 0) {
+			ret = btrfs_shift_extent_backref(trans, root, ino,
+					disk_bytenr, num_bytes,
+					key.offset - extent_offset,
+					new_key.offset - extent_offset);
+			if (unlikely(ret))
+				goto out_trans;
+		}
+
+		/*
+		 * Step back to the previous item for the next iteration.
+		 * If we've reached slot 0 we need to move to the previous leaf.
+		 */
+		nr_shifted++;
+		if (nr_shifted % BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL == 0) {
+			btrfs_info(fs_info,
+			   "btrfs_insert_range: cycling transaction, nr_shifted=%d", nr_shifted);
+
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
+				goto out_path;
+			}
+		}
+
+		/*
+		 * Set key.offset to one below the current item so the next
+		 * btrfs_search_slot lands on the item before it.
+		 */
+		if (key.offset == 0) {
+			ret = 0;
+			break;
+		}
+		key.offset--;
+		btrfs_release_path(path);
+	}
+
+	if (ret)
+		goto out_trans;
+
+	/*
+	 * Drop stale extent map entries so subsequent reads re-load correct
+	 * mappings from the btree.
+	 */
+	btrfs_drop_extent_map_range(BTRFS_I(inode), offset, (u64)-1, false);
+
+	btrfs_info(fs_info,
+		   "btrfs_insert_range: updating i_size %lld -> %lld",
+		   inode->i_size, inode->i_size + len);
+	inode_inc_iversion(inode);
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	i_size_write(inode, inode->i_size + len);
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
+out_path:
+	btrfs_free_path(path);
+	btrfs_info(fs_info, "btrfs_insert_range: returning %d", ret);
+	return ret;
+}
+
 static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
@@ -3596,6 +3831,9 @@ static long btrfs_fallocate(struct file *file, int mode,
 	case FALLOC_FL_COLLAPSE_RANGE:
 		ret = btrfs_collapse_range(inode, offset, len);
 		break;
+	case FALLOC_FL_INSERT_RANGE:
+		ret = btrfs_insert_range(inode, offset, len);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 	}
-- 
2.53.0

