From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: disk space caching generation missmatch
Date: Wed, 1 Dec 2010 22:22:45 +0100
Message-ID: <201012012222.45471.johannes.hirte@fem.tu-ilmenau.de>
References: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de> <201012012056.14517.johannes.hirte@fem.tu-ilmenau.de> <20101201200312.GF7021@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201200312.GF7021@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 01 December 2010 21:03:13 Josef Bacik wrote:
> On Wed, Dec 01, 2010 at 08:56:14PM +0100, Johannes Hirte wrote:
> > On Wednesday 01 December 2010 18:40:18 Josef Bacik wrote:
> > > On Wed, Dec 01, 2010 at 05:46:14PM +0100, Johannes Hirte wrote:
> > > > After enabling disk space caching I've observed several log entries like this:
> > > > 
> > > > btrfs: free space inode generation (0) did not match free space cache generation (169594) for block group 15464398848
> > > > 
> > > > I'm not sure, but it seems this happens on every reboot. Is this something to
> > > > worry about?
> > > > 
> > > 
> > > So that usually means 1 of a couple of things
> > > 
> > > 1) You didn't have space for us to save the free space cache
> > > 2) When trying to write out the cache we hit one of those cases where we would
> > > deadlock so we couldn't write the cache out
> > > 
> > > It's nothing to worry about, it's doing what it is supposed to.  However I'd
> > > like to know why we're not able to write out the cache.  Are you running close
> > > to full?  Thanks,
> > > 
> > > Josef
> > >
> > 
> > I think there should be enough free space:
> > 
> 
> Hmm well then we're hitting one of the other corner cases.  Can you run with
> this debug thread and reboot.  Hopefully it will tell me why we're not saving
> the free space cache. Thanks,
> 
> Josef
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 87aae66..4fd5659 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2794,13 +2794,17 @@ again:
>  	if (i_size_read(inode) > 0) {
>  		ret = btrfs_truncate_free_space_cache(root, trans, path,
>  						      inode);
> -		if (ret)
> +		if (ret) {
> +			printk(KERN_ERR "truncate free space cache failed for %llu, %d\n",
> +			       block_group->key.objectid, ret);
>  			goto out_put;
> +		}
>  	}
>  
>  	spin_lock(&block_group->lock);
>  	if (block_group->cached != BTRFS_CACHE_FINISHED) {
>  		spin_unlock(&block_group->lock);
> +		printk(KERN_ERR "block group %llu not cached\n", block_group->key.objectid);
>  		goto out_put;
>  	}
>  	spin_unlock(&block_group->lock);
> @@ -2820,8 +2824,10 @@ again:
>  	num_pages *= PAGE_CACHE_SIZE;
>  
>  	ret = btrfs_check_data_free_space(inode, num_pages);
> -	if (ret)
> +	if (ret) {
> +		printk(KERN_ERR "not enough free space for cache %llu\n", block_group->key.objectid);
>  		goto out_put;
> +	}
>  
>  	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, num_pages,
>  					      num_pages, num_pages,
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 22ee0dc..0078172 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -511,6 +511,8 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  	spin_lock(&block_group->lock);
>  	if (block_group->disk_cache_state < BTRFS_DC_SETUP) {
>  		spin_unlock(&block_group->lock);
> +		printk(KERN_ERR "block group %llu, wrong dcs %d\n", block_group->key.objectid,
> +		       block_group->disk_cache_state);
>  		return 0;
>  	}
>  	spin_unlock(&block_group->lock);
> @@ -520,6 +522,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  		return 0;
>  
>  	if (!i_size_read(inode)) {
> +		printk(KERN_ERR "no allocated space for block group %llu\n", block_group->key.objectid);
>  		iput(inode);
>  		return 0;
>  	}
> @@ -771,6 +774,7 @@ out_free:
>  		block_group->disk_cache_state = BTRFS_DC_ERROR;
>  		spin_unlock(&block_group->lock);
>  		BTRFS_I(inode)->generation = 0;
> +		printk(KERN_ERR "problem writing out block group cache for %llu\n", block_group->key.objectid);
>  	}
>  	kfree(checksums);
>  	btrfs_update_inode(trans, root, inode);
> 

This is from dmesg shortly after reboot with the debug patch:

btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (177986) for block group 5398069248
btrfs: free space inode generation (0) did not match free space cache generation (177986) for block group 5398069248
block group 5398069248 not cached
block group 19893583872 not cached
no allocated space for block group 5398069248
no allocated space for block group 19893583872
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (116974) for block group 14256439296
block group 14256439296 not cached
no allocated space for block group 14256439296
btrfs: free space inode generation (0) did not match free space cache generation (169594) for block group 15464398848
block group 19893583872 not cached
no allocated space for block group 19893583872
block group 14256439296 not cached
block group 37341888512 not cached
no allocated space for block group 14256439296
no allocated space for block group 37341888512
block group 14256439296 not cached
no allocated space for block group 14256439296
block group 5398069248 not cached
block group 19893583872 not cached
block group 88881496064 not cached
no allocated space for block group 5398069248
no allocated space for block group 19893583872
no allocated space for block group 88881496064
