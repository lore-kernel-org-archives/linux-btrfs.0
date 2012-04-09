From: Josef Bacik <josef@redhat.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Mon, 9 Apr 2012 16:54:30 -0400
Message-ID: <20120409205429.GB6958@localhost.localdomain>
References: <1333986823.2928.6.camel@ayu>
 <1333991404.2817.6.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333991404.2817.6.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wrote:
> On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> > Hi,
> > 
> > I have a system that's using a dracut-generated initramfs to mount a
> > btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> > noticed that the process of mounting the root filesystem takes much
> > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!
> > 
> > Does anyone have any ideas? I'm going to try bisecting the issue to see
> > if I can narrow down the cause. I've included excerpts from dmesg of the
> > bad and good kernels here, and attached the complete dmesg from the bad
> > kernel, in case it has anything interesting that I've trimmed out here.
> 
> And the bisect results are in:
> 285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad commit
> commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
> Author: Josef Bacik <josef@redhat.com>
> Date:   Fri Jan 13 15:27:45 2012 -0500
> 
>     Btrfs: remove the ideal caching code
>    
>     This is a relic from before we had the disk space cache and it was to make
>     bootup times when you had btrfs as root not be so damned slow.  Now that we have
>     the disk space cache this isn't a problem anymore and really having this code
>     casues uneeded fragmentation and complexity, so just remove it.  Thanks,
>     
>     Signed-off-by: Josef Bacik <josef@redhat.com>
> 
> The commit doesn't revert cleanly on top of 3.4.0-rc2, so I haven't
> tested that; but it looks like that caching code is in fact still useful
> to make "btrfs as root not be so damned slow."
> 

Ok can you give this a whirl?  You are going to have to boot/reboot a few times
to let the cache get re-generated again to make sure it's taken effect, but
hopefully this will help out.  Thanks,

Josef

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..7a703d2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -530,8 +530,8 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	 * we likely hold important locks.
 	 */
 	if (trans && (!trans->transaction->in_commit) &&
-	    (root && root != root->fs_info->tree_root) &&
-	    btrfs_test_opt(root, SPACE_CACHE)) {
+	    root != fs_info->tree_root &&
+	    fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
 		ret = load_free_space_cache(fs_info, cache);
 
 		spin_lock(&cache->lock);
