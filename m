Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A66ABA21
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 02:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776393002; cv=none; b=Cgsz7gvN9RIUatNdYrrFHpPObwh/HuCfnHteR2YCzESl4iHFUtls2idPW35ySqKRS5WRJ2aP3lvsV4vxjNR1AMGPqzncnRR2SekR0HL8gCrKSvf5h9Z+Ji+cbnc7FEAzdv/WSZnOoth2rEUPbxqzardjVC8eMo6W5HzbMtGxknA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776393002; c=relaxed/simple;
	bh=/MvRwTyeBsRuDu2dau/FBdUz2mKvIAo6AXUPI5pPYf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R334SGMKrh8nfVljxO6Af6GWl4YxNMjKIXSGUnbCG9kD/4kCP4R/0haRV4dALvN0+i/J9Srt4PUxSox8nQYnFrVqb8eZGBytabJmg1MNbKCYxog0wuhE5YSi5wOdafv6cIqmKpxAbD3gAOscnDlzcrB0rnk1Vbs8T4VsGYTJJL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O7QUjbl8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OPPD7TWm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O7QUjbl8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OPPD7TWm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF5EB5BCF4;
	Fri, 17 Apr 2026 02:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776392998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MZH5wqkGyODMhSK46mhH6+1ieNoerttapH1zsh55AY0=;
	b=O7QUjbl8Rt0nEF3xVT5qXOxb0py8esL3veYqBtmMgnFAMT6FAyQbmwLqtiQuSnsW9fDXAr
	x2Kh4x6QdpBLnHuhmr+H+03tZtHoXo6VLeq+A6Bn646tfokHK/QZw61J6Ck2aWnGXjyyqB
	XUFSBffB+Ue4quld1OAr8TxHaSd6Uqo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776392994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MZH5wqkGyODMhSK46mhH6+1ieNoerttapH1zsh55AY0=;
	b=OPPD7TWmrxX6kSV0b+myTxC71m+7+jFhjwfVu1I/7NnQ2zrKmRMmZEFnxRqUIrMDj56Rrh
	5ODnGPIIL7AUBHzr6dZg1ib+lxhsdJmud1x8tLet3SO6vliXvG7xlTF4sv5zrNIYv7M7Li
	OAlCJXlwy8sX1EfdQ9XUQ6ZcR4sX4eA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8A46593AE;
	Fri, 17 Apr 2026 02:29:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vYwOLSKb4WncZQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Fri, 17 Apr 2026 02:29:54 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: make more ASSERTs verbose, part 3
Date: Fri, 17 Apr 2026 04:29:52 +0200
Message-ID: <20260417022952.16673-1-dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

We have support for optional string to be printed in ASSERT() (added in
19468a623a9109 ("btrfs: enhance ASSERT() to take optional format
string")), it's not yet everywhere it could be so add a few more files.

Try to finish what was left after 1c094e6ccead7a ("btrfs: make a few
more ASSERTs verbose").

Signed-off-by: David Sterba <dsterba@suse.com>
---

v2:

- add bytenr, in btrfs_cross_ref_exist()
- drop string, in btrfs_insert_replace_extent()

- refresh on for-next, drop assertion that was changed to error handling
  in "btrfs: replace ASSERT with proper error handling in stripe lookup
  fallback"

 fs/btrfs/backref.c          |  4 ++--
 fs/btrfs/extent-tree.c      | 15 ++++++++++-----
 fs/btrfs/extent_map.c       |  6 +++---
 fs/btrfs/fiemap.c           |  2 +-
 fs/btrfs/file-item.c        |  4 +++-
 fs/btrfs/file.c             |  7 +++++--
 fs/btrfs/ioctl.c            |  3 ++-
 fs/btrfs/ordered-data.c     | 12 +++++++-----
 fs/btrfs/raid-stripe-tree.c |  4 +++-
 fs/btrfs/reflink.c          |  5 +++--
 10 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 273924ca912c..2c25e5d86f3e 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2367,7 +2367,7 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
 		info = (struct btrfs_tree_block_info *)(ei + 1);
 		*out_level = btrfs_tree_block_level(eb, info);
 	} else {
-		ASSERT(key->type == BTRFS_METADATA_ITEM_KEY);
+		ASSERT(key->type == BTRFS_METADATA_ITEM_KEY, "key->type=%hhu", key->type);
 		*out_level = (u8)key->offset;
 	}
 
@@ -3199,7 +3199,7 @@ static int handle_direct_tree_backref(struct btrfs_backref_cache *cache,
 	struct btrfs_backref_node *upper;
 	struct rb_node *rb_node;
 
-	ASSERT(ref_key->type == BTRFS_SHARED_BLOCK_REF_KEY);
+	ASSERT(ref_key->type == BTRFS_SHARED_BLOCK_REF_KEY, "ref_key->type=%hhu", ref_key->type);
 
 	/* Only reloc root uses backref pointing to itself */
 	if (ref_key->objectid == ref_key->offset) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5d5b42ea4ade..420d52b097d9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -385,7 +385,7 @@ int btrfs_get_extent_inline_ref_type(const struct extent_buffer *eb,
 					return type;
 			}
 		} else {
-			ASSERT(is_data == BTRFS_REF_TYPE_ANY);
+			ASSERT(is_data == BTRFS_REF_TYPE_ANY, "is_data=%d", is_data);
 			return type;
 		}
 	}
@@ -2531,8 +2531,11 @@ int btrfs_cross_ref_exist(struct btrfs_inode *inode, u64 offset,
 				struct btrfs_key key;
 
 				btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-				ASSERT(key.objectid == bytenr);
-				ASSERT(key.type == BTRFS_EXTENT_ITEM_KEY);
+				ASSERT(key.objectid == bytenr,
+				       "key.objectid=%llu bytenr=%llu",
+				       key.objectid, bytenr);
+				ASSERT(key.type == BTRFS_EXTENT_ITEM_KEY, "key.type=%u",
+				       key.type);
 			}
 		}
 
@@ -4598,10 +4601,12 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		/* Use dedicated sub-space_info for dedicated block group users. */
 		if (ffe_ctl->for_data_reloc) {
 			space_info = space_info->sub_group[0];
-			ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC);
+			ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_DATA_RELOC,
+			       "space_info->subgroup_id=%d", space_info->subgroup_id);
 		} else if (ffe_ctl->for_treelog) {
 			space_info = space_info->sub_group[0];
-			ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_TREELOG);
+			ASSERT(space_info->subgroup_id == BTRFS_SUB_GROUP_TREELOG,
+			       "space_info->subgroup_id=%d", space_info->subgroup_id);
 		}
 	}
 	if (!space_info) {
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 095a561d733f..93a0950293a3 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -717,7 +717,7 @@ int btrfs_add_extent_mapping(struct btrfs_inode *inode,
 	 * file offset. Here just do a sanity check.
 	 */
 	if (em->disk_bytenr == EXTENT_MAP_INLINE)
-		ASSERT(em->start == 0);
+		ASSERT(em->start == 0, "em->start=%llu", em->start);
 
 	ret = add_extent_mapping(inode, em, false);
 	/* it is possible that someone inserted the extent into the tree
@@ -761,7 +761,7 @@ int btrfs_add_extent_mapping(struct btrfs_inode *inode,
 		}
 	}
 
-	ASSERT(ret == 0 || ret == -EEXIST);
+	ASSERT(ret == 0 || ret == -EEXIST, "ret=%d", ret);
 	return ret;
 }
 
@@ -943,7 +943,7 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 
 				ret = add_extent_mapping(inode, split, modified);
 				/* Logic error, shouldn't happen. */
-				ASSERT(ret == 0);
+				ASSERT(ret == 0, "ret=%d", ret);
 				if (WARN_ON(ret != 0) && modified)
 					btrfs_set_inode_full_sync(inode);
 			}
diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index 27d361c7adc4..6263e837093e 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -112,7 +112,7 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
 	u64 cache_end;
 
 	/* Set at the end of extent_fiemap(). */
-	ASSERT((flags & FIEMAP_EXTENT_LAST) == 0);
+	ASSERT((flags & FIEMAP_EXTENT_LAST) == 0, "flags=0x%u", flags);
 
 	if (!cache->cached)
 		goto assign;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index d72249390030..82ae4a2afd34 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -325,7 +325,9 @@ static int search_csum_tree(struct btrfs_fs_info *fs_info,
 
 	csum_start = key.offset;
 	csum_len = (itemsize / csum_size) * sectorsize;
-	ASSERT(in_range(disk_bytenr, csum_start, csum_len));
+	ASSERT(in_range(disk_bytenr, csum_start, csum_len),
+	       "disk_bytenr=%llu csum_start=%llu csum_len=%llu",
+	       disk_bytenr, csum_start, csum_len);
 
 found:
 	ret = (min(csum_start + csum_len, disk_bytenr + len) -
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a6f641a41d99..f007f1f2fd84 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1218,8 +1218,11 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 		return ret;
 	reserved_len = ret;
 	/* Write range must be inside the reserved range. */
-	ASSERT(reserved_start <= start);
-	ASSERT(start + write_bytes <= reserved_start + reserved_len);
+	ASSERT(reserved_start <= start, "reserved_start=%llu start=%llu",
+	       reserved_start, start);
+	ASSERT(start + write_bytes <= reserved_start + reserved_len,
+	       "start=%llu write_bytes=%zu reserved_start=%llu reserved_len=%llu",
+	       start, write_bytes, reserved_start, reserved_len);
 
 again:
 	ret = balance_dirty_pages_ratelimited_flags(inode->vfs_inode.i_mapping,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index db7ffabbd3a4..e60b13b27a6d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5011,7 +5011,8 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_fs_info *fs_info, void __user *a
 			return -ENOENT;
 
 		wait_for_deletion = true;
-		ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD);
+		ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, "root_flags=0x%llx",
+		       root_flags);
 		sched_ret = schedule_timeout_interruptible(HZ);
 		/* Early wake up or error. */
 		if (sched_ret != 0)
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 96ee8ebfdb92..439f9aa9721a 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -157,7 +157,8 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	       ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)));
 
 	/* Only one type flag can be set. */
-	ASSERT(has_single_bit_set(flags & BTRFS_ORDERED_EXCLUSIVE_FLAGS));
+	ASSERT(has_single_bit_set(flags & BTRFS_ORDERED_EXCLUSIVE_FLAGS),
+	       "flags=0x%lx", flags);
 
 	/* DIRECT cannot be set with COMPRESSED nor ENCODED. */
 	if (test_bit(BTRFS_ORDERED_DIRECT, &flags)) {
@@ -302,7 +303,7 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 {
 	struct btrfs_ordered_extent *entry;
 
-	ASSERT((flags & ~BTRFS_ORDERED_TYPE_FLAGS) == 0);
+	ASSERT((flags & ~BTRFS_ORDERED_TYPE_FLAGS) == 0, "flags=0x%lx", flags);
 
 	/*
 	 * For regular writes, we just use the members in @file_extent.
@@ -1238,7 +1239,7 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 
 	trace_btrfs_ordered_extent_split(inode, ordered);
 
-	ASSERT(!(flags & (1U << BTRFS_ORDERED_COMPRESSED)));
+	ASSERT(!(flags & (1U << BTRFS_ORDERED_COMPRESSED)), "flags=0x%lx", flags);
 
 	/*
 	 * The entire bio must be covered by the ordered extent, but we can't
@@ -1260,7 +1261,7 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 	}
 	/* We cannot split partially completed ordered extents. */
 	if (ordered->bytes_left) {
-		ASSERT(!(flags & ~BTRFS_ORDERED_TYPE_FLAGS));
+		ASSERT(!(flags & ~BTRFS_ORDERED_TYPE_FLAGS), "flags=0x%lx", flags);
 		if (WARN_ON_ONCE(ordered->bytes_left != ordered->disk_num_bytes))
 			return ERR_PTR(-EINVAL);
 	}
@@ -1307,7 +1308,8 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 	ordered->ram_bytes -= len;
 
 	if (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags)) {
-		ASSERT(ordered->bytes_left == 0);
+		ASSERT(ordered->bytes_left == 0, "ordered->bytes_left=%llu",
+		       ordered->bytes_left);
 		new->bytes_left = 0;
 	} else {
 		ordered->bytes_left -= len;
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 4b0186c83ad1..454a95bf542a 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -272,7 +272,9 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 								 &key,
 								 key.offset - length,
 								 length);
-			ASSERT(key.offset - diff_end == length);
+			ASSERT(key.offset - diff_end == length,
+			       "key.offset=%llu diff_end=%llu length=%llu",
+			       key.offset, diff_end, length);
 			break;
 		}
 
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 14742abe0f92..86fa8d92e15b 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -69,7 +69,8 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
 	struct address_space *mapping = inode->vfs_inode.i_mapping;
 	int ret;
 
-	ASSERT(IS_ALIGNED(file_offset, block_size));
+	ASSERT(IS_ALIGNED(file_offset, block_size), "file_offset=%llu block_size=%u",
+	       file_offset, block_size);
 
 	/*
 	 * We have flushed and locked the ranges of the source and destination
@@ -458,7 +459,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		    key.objectid != btrfs_ino(BTRFS_I(src)))
 			break;
 
-		ASSERT(key.type == BTRFS_EXTENT_DATA_KEY);
+		ASSERT(key.type == BTRFS_EXTENT_DATA_KEY, "key.type=%u", key.type);
 
 		extent = btrfs_item_ptr(leaf, slot,
 					struct btrfs_file_extent_item);
-- 
2.51.0

