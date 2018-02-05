Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38000 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbeBFARy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Feb 2018 19:17:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w160Gn3b143314
        for <linux-btrfs@vger.kernel.org>; Tue, 6 Feb 2018 00:17:53 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fy1ekr1ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Feb 2018 00:17:53 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w160Hndv001278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 6 Feb 2018 00:17:50 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w160Hn7j006450
        for <linux-btrfs@vger.kernel.org>; Tue, 6 Feb 2018 00:17:49 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] Btrfs: expose bad chunks in sysfs
Date: Mon,  5 Feb 2018 16:15:02 -0700
Message-Id: <20180205231502.12900-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs tries its best to tolerate write errors, but kind of silently
(except some messages in kernel log).

For raid1 and raid10, this is usually not a problem because there is a
copy as backup, while for parity based raid setup, i.e. raid5 and
raid6, the problem is that, if a write error occurs due to some bad
sectors, one horizonal stripe becomes degraded and the number of write
errors it can tolerate gets reduced by one, now if two disk fails,
data may be lost forever.

One way to mitigate the data loss pain is to expose 'bad chunks',
i.e. degraded chunks, to users, so that they can use 'btrfs balance'
to relocate the whole chunk and get the full raid6 protection again
(if the relocation works).

This introduces 'bad_chunks' in btrfs's per-fs sysfs directory.  Once
a chunk of raid5 or raid6 becomes degraded, it will appear in
'bad_chunks'.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
- In this patch, 'bad chunks' is not persistent on disk, but it can be
  added if it's thought to be a good idea.
- This is lightly tested, comments are very welcome.

 fs/btrfs/ctree.h       |  8 +++++++
 fs/btrfs/disk-io.c     |  2 ++
 fs/btrfs/extent-tree.c | 13 +++++++++++
 fs/btrfs/raid56.c      | 59 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/sysfs.c       | 26 ++++++++++++++++++++++
 fs/btrfs/volumes.c     | 15 +++++++++++--
 fs/btrfs/volumes.h     |  2 ++
 7 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 13c260b..08aad65 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1101,6 +1101,9 @@ struct btrfs_fs_info {
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
 #endif
+
+	struct list_head bad_chunks;
+	seqlock_t bc_lock;
 };
 
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
@@ -2568,6 +2571,11 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 
 /* extent-tree.c */
 
+struct btrfs_bad_chunk {
+	u64 chunk_offset;
+	struct list_head list;
+};
+
 enum btrfs_inline_ref_type {
 	BTRFS_REF_TYPE_INVALID =	 0,
 	BTRFS_REF_TYPE_BLOCK =		 1,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a8ecccf..061e7f94 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2568,6 +2568,8 @@ int open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->async_submit_wait);
 
 	INIT_LIST_HEAD(&fs_info->pinned_chunks);
+	INIT_LIST_HEAD(&fs_info->bad_chunks);
+	seqlock_init(&fs_info->bc_lock);
 
 	/* Usable values until the real ones are cached from the superblock */
 	fs_info->nodesize = 4096;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2f43285..3ca7cb4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9903,6 +9903,19 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		kobject_del(&space_info->kobj);
 		kobject_put(&space_info->kobj);
 	}
+
+	/* Clean up bad chunks. */
+	write_seqlock_irq(&info->bc_lock);
+	while (!list_empty(&info->bad_chunks)) {
+		struct btrfs_bad_chunk *bc;
+
+		bc = list_first_entry(&info->bad_chunks,
+				      struct btrfs_bad_chunk, list);
+		list_del_init(&bc->list);
+		kfree(bc);
+	}
+	write_sequnlock_irq(&info->bc_lock);
+
 	return 0;
 }
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a7f7925..e960247 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -888,14 +888,19 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
 }
 
 /*
- * end io function used by finish_rmw.  When we finally
- * get here, we've written a full stripe
+ * end io function used by finish_rmw.  When we finally get here, we've written
+ * a full stripe.
+ *
+ * Note that this is not under interrupt context as we queued endio to workers.
  */
 static void raid_write_end_io(struct bio *bio)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 	blk_status_t err = bio->bi_status;
 	int max_errors;
+	u64 stripe_start = rbio->bbio->raid_map[0];
+	struct btrfs_fs_info *fs_info = rbio->fs_info;
+	int err_cnt;
 
 	if (err)
 		fail_bio_stripe(rbio, bio);
@@ -908,12 +913,58 @@ static void raid_write_end_io(struct bio *bio)
 	err = BLK_STS_OK;
 
 	/* OK, we have read all the stripes we need to. */
+	err_cnt = atomic_read(&rbio->error);
 	max_errors = (rbio->operation == BTRFS_RBIO_PARITY_SCRUB) ?
 		     0 : rbio->bbio->max_errors;
 	if (atomic_read(&rbio->error) > max_errors)
 		err = BLK_STS_IOERR;
 
 	rbio_orig_end_io(rbio, err);
+
+	/*
+	 * If there is any error, this stripe is a degraded one, so is the whole
+	 * chunk, expose this chunk info to sysfs.
+	 */
+	if (unlikely(err_cnt)) {
+		struct btrfs_bad_chunk *bc;
+		struct btrfs_bad_chunk *tmp;
+		struct extent_map *em;
+		unsigned long flags;
+
+		em = get_chunk_map(fs_info, stripe_start, 1);
+		if (IS_ERR(em))
+			return;
+
+		bc = kzalloc(sizeof(*bc), GFP_NOFS);
+		/* If allocation fails, it's OK. */
+		if (!bc) {
+			free_extent_map(em);
+			return;
+		}
+
+		write_seqlock_irqsave(&fs_info->bc_lock, flags);
+		list_for_each_entry(tmp, &fs_info->bad_chunks, list) {
+			if (tmp->chunk_offset != em->start)
+				continue;
+
+			/*
+			 * Don't bother if this chunk has already been recorded.
+			 */
+			write_sequnlock_irqrestore(&fs_info->bc_lock, flags);
+			kfree(bc);
+			free_extent_map(em);
+			return;
+		}
+
+		/* Add new bad chunk to list. */
+		bc->chunk_offset = em->start;
+		free_extent_map(em);
+
+		INIT_LIST_HEAD(&bc->list);
+		list_add(&bc->list, &fs_info->bad_chunks);
+
+		write_sequnlock_irqrestore(&fs_info->bc_lock, flags);
+	}
 }
 
 /*
@@ -1320,6 +1371,8 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		bio->bi_end_io = raid_write_end_io;
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
+		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
+
 		submit_bio(bio);
 	}
 	return;
@@ -2465,6 +2518,8 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 		bio->bi_end_io = raid_write_end_io;
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
+		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
+
 		submit_bio(bio);
 	}
 	return;
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a28bba8..0baaa33 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -490,12 +490,38 @@ static ssize_t quota_override_store(struct kobject *kobj,
 
 BTRFS_ATTR_RW(, quota_override, quota_override_show, quota_override_store);
 
+static ssize_t btrfs_bad_chunks_show(struct kobject *kobj,
+				     struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	struct btrfs_bad_chunk *bc;
+	int len = 0;
+	unsigned int seq;
+
+	/* read lock please */
+	do {
+		seq = read_seqbegin(&fs_info->bc_lock);
+		list_for_each_entry(bc, &fs_info->bad_chunks, list) {
+			len += snprintf(buf + len, PAGE_SIZE - len, "%llu\n",
+					bc->chunk_offset);
+			/* chunk offset is u64 */
+			if (len >= PAGE_SIZE)
+				break;
+		}
+	} while (read_seqretry(&fs_info->bc_lock, seq));
+
+	return len;
+}
+
+BTRFS_ATTR(, bad_chunks, btrfs_bad_chunks_show);
+
 static const struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(, label),
 	BTRFS_ATTR_PTR(, nodesize),
 	BTRFS_ATTR_PTR(, sectorsize),
 	BTRFS_ATTR_PTR(, clone_alignment),
 	BTRFS_ATTR_PTR(, quota_override),
+	BTRFS_ATTR_PTR(, bad_chunks),
 	NULL,
 };
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a256842..d71f11a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2803,8 +2803,8 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	return ret;
 }
 
-static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
-					u64 logical, u64 length)
+struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
+				 u64 logical, u64 length)
 {
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
@@ -2840,6 +2840,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	u64 dev_extent_len = 0;
 	int i, ret = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_bad_chunk *bc;
 
 	em = get_chunk_map(fs_info, chunk_offset, 1);
 	if (IS_ERR(em)) {
@@ -2916,6 +2917,16 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	}
 
 out:
+	write_seqlock_irq(&fs_info->bc_lock);
+	list_for_each_entry(bc, &fs_info->bad_chunks, list) {
+		if (bc->chunk_offset == chunk_offset) {
+			list_del_init(&bc->list);
+			kfree(bc);
+			break;
+		}
+	}
+	write_sequnlock_irq(&fs_info->bc_lock);
+
 	/* once for us */
 	free_extent_map(em);
 	return ret;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ff15208..4e846ba 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -396,6 +396,8 @@ static inline enum btrfs_map_op btrfs_op(struct bio *bio)
 	}
 }
 
+struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
+				 u64 logical, u64 length);
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 void btrfs_get_bbio(struct btrfs_bio *bbio);
-- 
2.9.4

