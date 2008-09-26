From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix deadlock between alloc_mutex/chunk_mutex
Date: Fri, 26 Sep 2008 11:21:24 -0400
Message-ID: <20080926152123.GA23335@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This fixes a deadlock that happens between the alloc_mutex and chunk_mutex.
Process A comes in, decides to do a do_chunk_alloc, which takes the chunk_mutex,
and is holding the alloc_mutex because the only way you get to do_chunk_alloc is
by holding the alloc_mutex.  btrfs_alloc_chunk does its thing and goes to insert
a new item, which results in a cow of the block.  We get into
del_pending_extents from there, where if we need to be rescheduled we drop the
alloc_mutex and schedule.  At this point process B comes in to do an allocation
and gets the alloc_mutex, and because process A did not do the chunk allocation
completely it thinks its a good time to do a chunk allocation as well, and hangs
on the chunk_mutex.  Process A wakes up and tries to take the alloc_mutex and
cannot.  The way to fix this is do a mutex_trylock() on chunk_mutex.  If we
return 0 we didn't get the lock, and if this is just a "hey it may be a good
time to allocate a chunk" type of thing then we just exit.  If we are trying to
force an allocation then we reschedule and keep trying to acquire the
chunk_mutex.  If once we acquire it the space is already full then we can just
exit, otherwise we can continue with the cunk allocation.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: root/btrfs-unstable/fs/btrfs/extent-tree.c
===================================================================
--- root.orig/btrfs-unstable/fs/btrfs/extent-tree.c
+++ root/btrfs-unstable/fs/btrfs/extent-tree.c
@@ -1518,7 +1518,7 @@ static int do_chunk_alloc(struct btrfs_t
 	u64 thresh;
 	u64 start;
 	u64 num_bytes;
-	int ret = 0;
+	int ret = 0, waited = 0;
 
 	flags = reduce_alloc_profile(extent_root, flags);
 
@@ -1543,7 +1543,18 @@ static int do_chunk_alloc(struct btrfs_t
 	    thresh)
 		goto out;
 
-	mutex_lock(&extent_root->fs_info->chunk_mutex);
+	while (!mutex_trylock(&extent_root->fs_info->chunk_mutex)) {
+		if (!force)
+			goto out;
+		mutex_unlock(&extent_root->fs_info->alloc_mutex);
+		cond_resched();
+		mutex_lock(&extent_root->fs_info->alloc_mutex);
+		waited = 1;
+	}
+
+	if (waited && space_info->full)
+		goto out_unlock;
+
 	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
 	if (ret == -ENOSPC) {
 printk("space info full %Lu\n", flags);
