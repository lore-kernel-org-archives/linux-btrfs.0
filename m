From: Josef Bacik <josef@redhat.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Tue, 10 Apr 2012 11:16:45 -0400
Message-ID: <20120410151645.GC2296@localhost.localdomain>
References: <1333986823.2928.6.camel@ayu>
 <1333991404.2817.6.camel@ayu>
 <20120409205429.GB6958@localhost.localdomain>
 <1334006446.2678.0.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334006446.2678.0.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 05:20:46PM -0400, Calvin Walton wrote:
> On Mon, 2012-04-09 at 16:54 -0400, Josef Bacik wrote:
> > On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wrote:
> > > On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> > > > Hi,
> > > > 
> > > > I have a system that's using a dracut-generated initramfs to mount a
> > > > btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> > > > noticed that the process of mounting the root filesystem takes much
> > > > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!
> 
> > > And the bisect results are in:
> > > 285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad commit
> > > commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
> > > Author: Josef Bacik <josef@redhat.com>
> > > Date:   Fri Jan 13 15:27:45 2012 -0500
> > > 
> > >     Btrfs: remove the ideal caching code> 
> > 
> > Ok can you give this a whirl?  You are going to have to boot/reboot a few times
> > to let the cache get re-generated again to make sure it's taken effect, but
> > hopefully this will help out.  Thanks,
> 
> Unfortunately, it doesn't seem to help. Even after 3 or 4 reboots with
> this patch applied I'm still seeing the same delay.
> 

Ok drop that previous patch and give this one a whirl, it helped on my laptop.
This is only  half of the problem AFAICS, but it's the easier half to fix, in
the meantime I need to lock down why we're not writing out cache for a bunch of
block groups, but thats trickier since the messages I need are spit out while
I'm shutting down, so I need to get creative.  Let me know if/how much this
helps.  Thanks,

Josef


diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..4a871f0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -529,9 +529,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	 * allocate blocks for the tree root we can't do the fast caching since
 	 * we likely hold important locks.
 	 */
-	if (trans && (!trans->transaction->in_commit) &&
-	    (root && root != root->fs_info->tree_root) &&
-	    btrfs_test_opt(root, SPACE_CACHE)) {
+	if (fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
 		ret = load_free_space_cache(fs_info, cache);
 
 		spin_lock(&cache->lock);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 054707e..baaa518 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -748,13 +748,6 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	u64 used = btrfs_block_group_used(&block_group->item);
 
 	/*
-	 * If we're unmounting then just return, since this does a search on the
-	 * normal root and not the commit root and we could deadlock.
-	 */
-	if (btrfs_fs_closing(fs_info))
-		return 0;
-
-	/*
 	 * If this block group has been marked to be cleared for one reason or
 	 * another then we can't trust the on disk cache, so just return.
 	 */
@@ -768,6 +761,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	path = btrfs_alloc_path();
 	if (!path)
 		return 0;
+	path->search_commit_root = 1;
+	path->skip_locking = 1;
 
 	inode = lookup_free_space_inode(root, block_group, path);
 	if (IS_ERR(inode)) {
