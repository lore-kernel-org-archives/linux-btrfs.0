Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FDC345CC0
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263898; cv=none; b=ulibsJJ6wX20bvEOOxhuF78TcKpWcKT18wOi3uAiHJrBCtXnqLl4o6XdqnNn7dgpgX/UOfUe3oSY9OeSdNzQWWdQnyHoX+mIe+IkBYM7rUMFkdOXUOhqIpc5hO2CxfXvSO1yxiDYvMLfpbzEY+e/pMpyDbsNLSi6NtZlULZXQEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263898; c=relaxed/simple;
	bh=RroO7f7bC37H5qylmgaCpKIjHXwfi3s80kisRhj5kZQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ym2mPDl+5G17P35LJ/AaulO8b3VEeN+HlAzLgvy3I1c+fCoCSG1iJhuF3wtuteWP5TWuZ9KtPigDi/QbI9MWw7yl20KHi6pLj6uFuxq3/NaJUSNmHzxEzHZbLTsV7D1njzCVLb3qrWiyRCpKBs9UFGOlFqaVhHXxgFFrctY5ZoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUd7/mrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUd7/mrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759AAC19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263898;
	bh=RroO7f7bC37H5qylmgaCpKIjHXwfi3s80kisRhj5kZQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AUd7/mrv3oXTLJrD/vgDy5ZwXiIB9G8W7Fulnq7/KJD2FesxLTBD/lB1TDeQstc8y
	 +CVQx81Y3CBwkk09mM36qkQAq+jJmi41IaLy0PqZddXBWJYRmS6gLkxiC8YA4+TP/C
	 pt+vV/Xtr1IDfddGqbTtJq7WUSCynWDP6cFsQbgCSNafwN1XMZ49EIdMJ5RJOnbnLJ
	 JxQ2LASUJ0F2LJznjZAuM3yGnKAPuwWhil2JGY9OvwLZqDXTH06y+/HAedlVmMnYRJ
	 1EAQj0OMqH9ROf2WgKP27nv+K/qUkKQfwuA2Ai0iD6HVTg1BgWX8uxUHtP/WzAeroW
	 yi3o3JxjoRC+g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] btrfs: reduce size of struct btrfs_block_group
Date: Wed, 15 Apr 2026 15:38:05 +0100
Message-ID: <ef130a3bd2f994d615e9b7dc8b17132b6c3a7fc1.1776263553.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776263553.git.fdmanana@suse.com>
References: <cover.1776263553.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We currently have several holes in the structure:

  struct btrfs_block_group {
        struct btrfs_fs_info *     fs_info;              /*     0     8 */
        struct btrfs_inode *       inode;                /*     8     8 */
        spinlock_t                 lock __attribute__((__aligned__(4))); /*    16     4 */

        /* XXX 4 bytes hole, try to pack */

        u64                        start;                /*    24     8 */
        u64                        length;               /*    32     8 */
        u64                        pinned;               /*    40     8 */
        u64                        reserved;             /*    48     8 */
        u64                        used;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u64                        delalloc_bytes;       /*    64     8 */
        u64                        bytes_super;          /*    72     8 */
        u64                        flags;                /*    80     8 */
        u64                        cache_generation;     /*    88     8 */
        u64                        global_root_id;       /*    96     8 */
        u64                        remap_bytes;          /*   104     8 */
        u32                        identity_remap_count; /*   112     4 */

        /* XXX 4 bytes hole, try to pack */

        u64                        last_used;            /*   120     8 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        u64                        last_remap_bytes;     /*   128     8 */
        u32                        last_identity_remap_count; /*   136     4 */

        /* XXX 4 bytes hole, try to pack */

        u64                        last_flags;           /*   144     8 */
        u32                        bitmap_high_thresh;   /*   152     4 */
        u32                        bitmap_low_thresh;    /*   156     4 */
        struct rw_semaphore        data_rwsem __attribute__((__aligned__(8))); /*   160    40 */
        /* --- cacheline 3 boundary (192 bytes) was 8 bytes ago --- */
        long unsigned int          full_stripe_len;      /*   200     8 */
        long unsigned int          runtime_flags;        /*   208     8 */
        unsigned int               ro;                   /*   216     4 */
        int                        disk_cache_state;     /*   220     4 */
        int                        cached;               /*   224     4 */

        /* XXX 4 bytes hole, try to pack */

       struct btrfs_caching_control * caching_ctl;      /*   232     8 */
        struct btrfs_space_info *  space_info;           /*   240     8 */
        struct btrfs_free_space_ctl * free_space_ctl;    /*   248     8 */
        /* --- cacheline 4 boundary (256 bytes) --- */
        struct rb_node             cache_node __attribute__((__aligned__(8))); /*   256    24 */
        struct list_head           list;                 /*   280    16 */
        refcount_t                 refs __attribute__((__aligned__(4))); /*   296     4 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           cluster_list;         /*   304    16 */
        /* --- cacheline 5 boundary (320 bytes) --- */
        struct list_head           bg_list;              /*   320    16 */
        struct list_head           ro_list;              /*   336    16 */
        atomic_t                   frozen __attribute__((__aligned__(4))); /*   352     4 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           discard_list;         /*   360    16 */
        int                        discard_index;        /*   376     4 */

        /* XXX 4 bytes hole, try to pack */

        /* --- cacheline 6 boundary (384 bytes) --- */
        u64                        discard_eligible_time; /*   384     8 */
        u64                        discard_cursor;       /*   392     8 */
        enum btrfs_discard_state   discard_state;        /*   400     4 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           dirty_list;           /*   408    16 */
        struct list_head           io_list;              /*   424    16 */
        struct btrfs_io_ctl        io_ctl;               /*   440    72 */
        /* --- cacheline 8 boundary (512 bytes) --- */
        atomic_t                   reservations __attribute__((__aligned__(4))); /*   512     4 */
        atomic_t                   nocow_writers __attribute__((__aligned__(4))); /*   516     4 */
        struct mutex               free_space_lock __attribute__((__aligned__(8))); /*   520    32 */
        bool                       using_free_space_bitmaps; /*   552     1 */
        bool                       using_free_space_bitmaps_cached; /*   553     1 */

       /* XXX 2 bytes hole, try to pack */

        int                        swap_extents;         /*   556     4 */
        u64                        alloc_offset;         /*   560     8 */
        u64                        zone_unusable;        /*   568     8 */
        /* --- cacheline 9 boundary (576 bytes) --- */
        u64                        zone_capacity;        /*   576     8 */
        u64                        meta_write_pointer;   /*   584     8 */
        struct btrfs_chunk_map *   physical_map;         /*   592     8 */
        struct list_head           active_bg_list;       /*   600    16 */
        struct work_struct         zone_finish_work;     /*   616    32 */
        /* --- cacheline 10 boundary (640 bytes) was 8 bytes ago --- */
        struct extent_buffer *     last_eb;              /*   648     8 */
        enum btrfs_block_group_size_class size_class;    /*   656     4 */

        /* XXX 4 bytes hole, try to pack */

        u64                        reclaim_mark;         /*   664     8 */

        /* size: 672, cachelines: 11, members: 61 */
        /* sum members: 634, holes: 10, sum holes: 38 */
        /* forced alignments: 8 */
        /* last cacheline: 32 bytes */
  } __attribute__((__aligned__(8)));

Reorder some fields to eliminate the holes while keeping closely related
or frequently accessed fields together. After the reordering the size of
the structure is reduced down to 632 bytes and the number of cache lines
decreases from 11 to 10. We can still only pack 6 block groups per 4K page
but on a 64K page system we will now be able to pack 103 block groups
instead of 97. The new structure layout, on a release kernel, is the
following:

  struct btrfs_block_group {
        struct btrfs_fs_info *     fs_info;              /*     0     8 */
        struct btrfs_inode *       inode;                /*     8     8 */
        spinlock_t                 lock __attribute__((__aligned__(4))); /*    16     4 */
        unsigned int               ro;                   /*    20     4 */
        u64                        start;                /*    24     8 */
        u64                        length;               /*    32     8 */
        u64                        pinned;               /*    40     8 */
        u64                        reserved;             /*    48     8 */
        u64                        used;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u64                        delalloc_bytes;       /*    64     8 */
        u64                        bytes_super;          /*    72     8 */
        u64                        flags;                /*    80     8 */
        u64                        cache_generation;     /*    88     8 */
        u64                        global_root_id;       /*    96     8 */
        u64                        remap_bytes;          /*   104     8 */
        u32                        identity_remap_count; /*   112     4 */
        u32                        last_identity_remap_count; /*   116     4 */
        u64                        last_used;            /*   120     8 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        u64                        last_remap_bytes;     /*   128     8 */
        u64                        last_flags;           /*   136     8 */
        u32                        bitmap_high_thresh;   /*   144     4 */
        u32                        bitmap_low_thresh;    /*   148     4 */
        struct rw_semaphore        data_rwsem __attribute__((__aligned__(8))); /*   152    40 */
        /* --- cacheline 3 boundary (192 bytes) --- */
        long unsigned int          full_stripe_len;      /*   192     8 */
        long unsigned int          runtime_flags;        /*   200     8 */
        int                        disk_cache_state;     /*   208     4 */
        int                        cached;               /*   212     4 */
        struct btrfs_caching_control * caching_ctl;      /*   216     8 */
        struct btrfs_space_info *  space_info;           /*   224     8 */
        struct btrfs_free_space_ctl * free_space_ctl;    /*   232     8 */
        struct rb_node             cache_node __attribute__((__aligned__(8))); /*   240    24 */
        /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
        struct list_head           list;                 /*   264    16 */
        refcount_t                 refs __attribute__((__aligned__(4))); /*   280     4 */
        atomic_t                   frozen __attribute__((__aligned__(4))); /*   284     4 */
        struct list_head           cluster_list;         /*   288    16 */
        struct list_head           bg_list;              /*   304    16 */
        /* --- cacheline 5 boundary (320 bytes) --- */
        struct list_head           ro_list;              /*   320    16 */
        struct list_head           discard_list;         /*   336    16 */
        int                        discard_index;        /*   352     4 */
        enum btrfs_discard_state   discard_state;        /*   356     4 */
        u64                        discard_eligible_time; /*   360     8 */
        u64                        discard_cursor;       /*   368     8 */
        struct list_head           dirty_list;           /*   376    16 */
        /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
        struct list_head           io_list;              /*   392    16 */
        struct btrfs_io_ctl        io_ctl;               /*   408    72 */
        /* --- cacheline 7 boundary (448 bytes) was 32 bytes ago --- */
        atomic_t                   reservations __attribute__((__aligned__(4))); /*   480     4 */
        atomic_t                   nocow_writers __attribute__((__aligned__(4))); /*   484     4 */
        struct mutex               free_space_lock __attribute__((__aligned__(8))); /*   488    32 */
        /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
        bool                       using_free_space_bitmaps; /*   520     1 */
        bool                       using_free_space_bitmaps_cached; /*   521     1 */

        /* XXX 2 bytes hole, try to pack */
        /* Bitfield combined with previous fields */

        static enum btrfs_block_group_size_class size_class; /*     0: 0  0 */
        int                        swap_extents;         /*   524     4 */
        u64                        alloc_offset;         /*   528     8 */
        u64                        zone_unusable;        /*   536     8 */
        u64                        zone_capacity;        /*   544     8 */
        u64                        meta_write_pointer;   /*   552     8 */
        struct btrfs_chunk_map *   physical_map;         /*   560     8 */
        struct list_head           active_bg_list;       /*   568    16 */
        /* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
        struct work_struct         zone_finish_work;     /*   584    32 */
        struct extent_buffer *     last_eb;              /*   616     8 */
        u64                        reclaim_mark;         /*   624     8 */

        /* size: 632, cachelines: 10, members: 60, static members: 1 */
        /* sum members: 630, holes: 1, sum holes: 2 */
        /* sum bitfield members: 8 bits (1 bytes) */
        /* forced alignments: 8 */
        /* last cacheline: 56 bytes */

        /* BRAIN FART ALERT! 632 bytes != 630 (member bytes) + 8 (member bits) + 2 (byte holes) + 0 (bit holes), diff = -8 bits */
  } __attribute__((__aligned__(8)));

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.h | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index b414f4268d2d..60a3b1c0a8ab 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -122,6 +122,7 @@ struct btrfs_block_group {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_inode *inode;
 	spinlock_t lock;
+	unsigned int ro;
 	u64 start;
 	u64 length;
 	u64 pinned;
@@ -134,7 +135,8 @@ struct btrfs_block_group {
 	u64 global_root_id;
 	u64 remap_bytes;
 	u32 identity_remap_count;
-
+	/* The last commited identity_remap_count value of this block group. */
+	u32 last_identity_remap_count;
 	/*
 	 * The last committed used bytes of this block group, if the above @used
 	 * is still the same as @last_used, we don't need to update block
@@ -143,8 +145,6 @@ struct btrfs_block_group {
 	u64 last_used;
 	/* The last committed remap_bytes value of this block group. */
 	u64 last_remap_bytes;
-	/* The last commited identity_remap_count value of this block group. */
-	u32 last_identity_remap_count;
 	/* The last committed flags value for this block group. */
 	u64 last_flags;
 
@@ -171,8 +171,6 @@ struct btrfs_block_group {
 	unsigned long full_stripe_len;
 	unsigned long runtime_flags;
 
-	unsigned int ro;
-
 	int disk_cache_state;
 
 	/* Cache tracking stuff */
@@ -192,6 +190,16 @@ struct btrfs_block_group {
 
 	refcount_t refs;
 
+	/*
+	 * When non-zero it means the block group's logical address and its
+	 * device extents can not be reused for future block group allocations
+	 * until the counter goes down to 0. This is to prevent them from being
+	 * reused while some task is still using the block group after it was
+	 * deleted - we want to make sure they can only be reused for new block
+	 * groups after that task is done with the deleted block group.
+	 */
+	atomic_t frozen;
+
 	/*
 	 * List of struct btrfs_free_clusters for this block group.
 	 * Today it will only have one thing on it, but that may change
@@ -211,22 +219,12 @@ struct btrfs_block_group {
 	/* For read-only block groups */
 	struct list_head ro_list;
 
-	/*
-	 * When non-zero it means the block group's logical address and its
-	 * device extents can not be reused for future block group allocations
-	 * until the counter goes down to 0. This is to prevent them from being
-	 * reused while some task is still using the block group after it was
-	 * deleted - we want to make sure they can only be reused for new block
-	 * groups after that task is done with the deleted block group.
-	 */
-	atomic_t frozen;
-
 	/* For discard operations */
 	struct list_head discard_list;
 	int discard_index;
+	enum btrfs_discard_state discard_state;
 	u64 discard_eligible_time;
 	u64 discard_cursor;
-	enum btrfs_discard_state discard_state;
 
 	/* For dirty block groups */
 	struct list_head dirty_list;
@@ -263,6 +261,8 @@ struct btrfs_block_group {
 	/* Protected by @free_space_lock. */
 	bool using_free_space_bitmaps_cached;
 
+	enum btrfs_block_group_size_class size_class:8;
+
 	/*
 	 * Number of extents in this block group used for swap files.
 	 * All accesses protected by the spinlock 'lock'.
@@ -281,7 +281,6 @@ struct btrfs_block_group {
 	struct list_head active_bg_list;
 	struct work_struct zone_finish_work;
 	struct extent_buffer *last_eb;
-	enum btrfs_block_group_size_class size_class;
 	u64 reclaim_mark;
 };
 
-- 
2.47.2

