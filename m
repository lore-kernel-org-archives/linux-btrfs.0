From: Josef Bacik <josef@redhat.com>
Subject: Re: disk space caching generation missmatch
Date: Thu, 2 Dec 2010 15:34:10 -0500
Message-ID: <20101202203410.GC8805@dhcp231-156.rdu.redhat.com>
References: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de> <20101201200312.GF7021@localhost.localdomain> <201012012222.45471.johannes.hirte@fem.tu-ilmenau.de> <201012012240.29525.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012012240.29525.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 10:40:29PM +0100, Johannes Hirte wrote:
> On Wednesday 01 December 2010 22:22:45 Johannes Hirte wrote:
> > On Wednesday 01 December 2010 21:03:13 Josef Bacik wrote:
> > > On Wed, Dec 01, 2010 at 08:56:14PM +0100, Johannes Hirte wrote:
> > > > On Wednesday 01 December 2010 18:40:18 Josef Bacik wrote:
> > > > > On Wed, Dec 01, 2010 at 05:46:14PM +0100, Johannes Hirte wrote:
> > > > > > After enabling disk space caching I've observed several log entries like this:
> > > > > > 
> > > > > > btrfs: free space inode generation (0) did not match free space cache generation (169594) for block group 15464398848
> > > > > > 
> > > > > > I'm not sure, but it seems this happens on every reboot. Is this something to
> > > > > > worry about?
> > > > > > 
> > > > > 
> > > > > So that usually means 1 of a couple of things
> > > > > 
> > > > > 1) You didn't have space for us to save the free space cache
> > > > > 2) When trying to write out the cache we hit one of those cases where we would
> > > > > deadlock so we couldn't write the cache out
> > > > > 
> > > > > It's nothing to worry about, it's doing what it is supposed to.  However I'd
> > > > > like to know why we're not able to write out the cache.  Are you running close
> > > > > to full?  Thanks,
> > > > > 
> > > > > Josef
> > > > >
> > > > 
> > > > I think there should be enough free space:
> > > > 
> > > 

Ok it doesn't look like theres an actual problem, we're just being sub-optimal.
Take out the other patch and apply this one, boot into that kernel and then
reboot and then give me the dmesg.  The thing is we are marking non-cached block
groups as being setup, but they really aren't, so we error out when we try to
write out the block group.  This isn't wrong, it's just crappy since we know we
wont be able to write the things out anyway.  So just mark the thing as written
so we dont even try.  The other cases appear to be where the block group is
empty, so we dont need to write anything out, but because of where I have the
check it makes it seem like an error, so I just moved the check up to make it
simpler.  I also thing the "free space inode generation did not match" messages
should only happen once, but are getting kicked out everytime something gets
removed, which is because the block group is not marked as cleared, so we just
need to go to free_cache so it gets marked to be cleared so we don't get the
same message over and over again.  Let me know how this works out for you,
thanks,

Josef


diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 87aae66..5ee883b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2794,13 +2794,19 @@ again:
 	if (i_size_read(inode) > 0) {
 		ret = btrfs_truncate_free_space_cache(root, trans, path,
 						      inode);
-		if (ret)
+		if (ret) {
+			printk(KERN_ERR "truncate free space cache failed for %llu, %d\n",
+			       block_group->key.objectid, ret);
 			goto out_put;
+		}
 	}
 
 	spin_lock(&block_group->lock);
 	if (block_group->cached != BTRFS_CACHE_FINISHED) {
+		/* Not cached, don't bother trying to write something out */
+		block_group->disk_cache_state = BTRFS_DC_WRITTEN;
 		spin_unlock(&block_group->lock);
+		printk(KERN_ERR "block group %llu not cached\n", block_group->key.objectid);
 		goto out_put;
 	}
 	spin_unlock(&block_group->lock);
@@ -2820,13 +2826,20 @@ again:
 	num_pages *= PAGE_CACHE_SIZE;
 
 	ret = btrfs_check_data_free_space(inode, num_pages);
-	if (ret)
+	if (ret) {
+		printk(KERN_ERR "not enough free space for cache %llu\n", block_group->key.objectid);
 		goto out_put;
+	}
 
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, num_pages,
 					      num_pages, num_pages,
 					      &alloc_hint);
 	btrfs_free_reserved_data_space(inode, num_pages);
+	if (!ret) {
+		spin_lock(&block_gruop->lock);
+		block_group->disk_cache_state = BTRFS_DC_SETUP;
+		spin_unlock(&block_group->lock);
+	}
 out_put:
 	iput(inode);
 out_free:
@@ -2835,8 +2848,6 @@ out:
 	spin_lock(&block_group->lock);
 	if (ret)
 		block_group->disk_cache_state = BTRFS_DC_ERROR;
-	else
-		block_group->disk_cache_state = BTRFS_DC_SETUP;
 	spin_unlock(&block_group->lock);
 
 	return ret;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 22ee0dc..029cc42 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -290,7 +290,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 		       (unsigned long long)BTRFS_I(inode)->generation,
 		       (unsigned long long)generation,
 		       (unsigned long long)block_group->key.objectid);
-		goto out;
+		goto free_cache;
 	}
 
 	if (!num_entries)
@@ -511,6 +511,8 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	spin_lock(&block_group->lock);
 	if (block_group->disk_cache_state < BTRFS_DC_SETUP) {
 		spin_unlock(&block_group->lock);
+		printk(KERN_ERR "block group %llu, wrong dcs %d\n", block_group->key.objectid,
+		       block_group->disk_cache_state);
 		return 0;
 	}
 	spin_unlock(&block_group->lock);
@@ -520,6 +522,13 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		return 0;
 
 	if (!i_size_read(inode)) {
+		printk(KERN_ERR "no allocated space for block group %llu\n", block_group->key.objectid);
+		iput(inode);
+		return 0;
+	}
+
+	node = rb_first(&block_group->free_space_offset);
+	if (!node) {
 		iput(inode);
 		return 0;
 	}
@@ -543,10 +552,6 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	 */
 	first_page_offset = (sizeof(u32) * num_checksums) + sizeof(u64);
 
-	node = rb_first(&block_group->free_space_offset);
-	if (!node)
-		goto out_free;
-
 	/*
 	 * Lock all pages first so we can lock the extent safely.
 	 *
@@ -771,6 +776,7 @@ out_free:
 		block_group->disk_cache_state = BTRFS_DC_ERROR;
 		spin_unlock(&block_group->lock);
 		BTRFS_I(inode)->generation = 0;
+		printk(KERN_ERR "problem writing out block group cache for %llu\n", block_group->key.objectid);
 	}
 	kfree(checksums);
 	btrfs_update_inode(trans, root, inode);
