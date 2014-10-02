Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaJBQx5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:53:57 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 37273AB1D
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:53:56 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs: remove unlikely from data-dependent branches and slow paths
Date: Thu,  2 Oct 2014 18:53:55 +0200
Message-Id: <ee39b432b4ac083acdafd7b4f156283722e3bf14.1412265734.git.dsterba@suse.cz>
In-Reply-To: <cover.1412265734.git.dsterba@suse.cz>
References: <cover.1412265734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are the branch hints that obviously depend on the data being
processed, the CPU predictor will do better job according to the actual
load. It also does not make sense to use the hints in slow paths that do
a lot of other operations like locking, waiting or IO.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/file.c        | 4 ++--
 fs/btrfs/inode.c       | 8 ++++----
 fs/btrfs/ioctl.c       | 2 +-
 fs/btrfs/transaction.c | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 44d04979f071..ede740bfaac0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9694,7 +9694,7 @@ void btrfs_end_nocow_write(struct btrfs_root *root)
 
 int btrfs_start_nocow_write(struct btrfs_root *root)
 {
-	if (unlikely(atomic_read(&root->will_be_snapshoted)))
+	if (atomic_read(&root->will_be_snapshoted))
 		return 0;
 
 	percpu_counter_inc(&root->subv_writers->counter);
@@ -9702,7 +9702,7 @@ int btrfs_start_nocow_write(struct btrfs_root *root)
 	 * Make sure counter is updated before we check for snapshot creation.
 	 */
 	smp_mb();
-	if (unlikely(atomic_read(&root->will_be_snapshoted))) {
+	if (atomic_read(&root->will_be_snapshoted)) {
 		btrfs_end_nocow_write(root);
 		return 0;
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 29b147d46b0a..a18ceabd99a8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -452,7 +452,7 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 		if (unlikely(copied == 0))
 			break;
 
-		if (unlikely(copied < PAGE_CACHE_SIZE - offset)) {
+		if (copied < PAGE_CACHE_SIZE - offset) {
 			offset += copied;
 		} else {
 			pg++;
@@ -1792,7 +1792,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	if (sync)
 		atomic_inc(&BTRFS_I(inode)->sync_writers);
 
-	if (unlikely(file->f_flags & O_DIRECT)) {
+	if (file->f_flags & O_DIRECT) {
 		num_written = __btrfs_direct_write(iocb, from, pos);
 	} else {
 		num_written = __btrfs_buffered_write(file, from, pos);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 998e67fdf2f6..47d214560831 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7802,9 +7802,9 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	atomic_inc(&dip->pending_bios);
 
 	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
-		if (unlikely(map_length < submit_len + bvec->bv_len ||
+		if (map_length < submit_len + bvec->bv_len ||
 		    bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len)) {
+				 bvec->bv_offset) < bvec->bv_len) {
 			/*
 			 * inc the count before we submit the bio so
 			 * we know the end IO handler won't happen before
@@ -8017,8 +8017,8 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		ret = btrfs_delalloc_reserve_space(inode, count);
 		if (ret)
 			goto out;
-	} else if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
-				     &BTRFS_I(inode)->runtime_flags))) {
+	} else if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
+				     &BTRFS_I(inode)->runtime_flags)) {
 		inode_dio_done(inode);
 		flags = DIO_LOCKING | DIO_SKIP_HOLES;
 		wakeup = false;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ff212757b95..f2c60cd70e63 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3167,7 +3167,7 @@ static void clone_update_extent_map(struct inode *inode,
 					em->start + em->len - 1, 0);
 	}
 
-	if (unlikely(ret))
+	if (ret)
 		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 			&BTRFS_I(inode)->runtime_flags);
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 16d0c1b62b3e..8eded14e8c5c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -418,7 +418,7 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 		/*
 		 * Do the reservation for the relocation root creation
 		 */
-		if (unlikely(need_reserve_reloc_root(root))) {
+		if (need_reserve_reloc_root(root)) {
 			num_bytes += root->nodesize;
 			reloc_reserved = true;
 		}
-- 
1.8.4.5

