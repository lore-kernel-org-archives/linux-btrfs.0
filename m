Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44034 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946405AbdDTTyT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 15:54:19 -0400
Date: Thu, 20 Apr 2017 12:52:55 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
Message-ID: <20170420195255.GA32370@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170420012509.GB15096@lim.localdomain>
 <98ab28d8-7ab6-0d2d-92d6-38b78e572d39@cn.fujitsu.com>
 <20170420015844.GC15096@lim.localdomain>
 <bc1d9076-1dba-babf-1703-af88c000b5be@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bc1d9076-1dba-babf-1703-af88c000b5be@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 20, 2017 at 10:09:39AM +0800, Qu Wenruo wrote:
> 
> 
> At 04/20/2017 09:58 AM, Liu Bo wrote:
> > On Thu, Apr 20, 2017 at 09:52:00AM +0800, Qu Wenruo wrote:
> > > 
> > > 
[...]
> > > > 
> > > > If I understand it correctly, what it's missing currently is 'merge', a
> > > > straightfoward idea is to make use of the 'merge' ability of btrfs_get_extent. >
> > > > Since btrfs_get_extent_fiemap is a wrapper of btrfs_get_extent, does it make
> > > > sense if we make btrfs_get_extent_fiemap iterate all extent maps within the
> > > > range passing to it or just one more extent map to check if btrfs_get_extent
> > > > could return a merged extent map before returning?
> > > 
> > > So your idea to to do the merging inside btrfs_get_extent(), instead of
> > > merging it in extent_fiemap()?
> > > 
> > 
> > No, merge ems inside the wrapper, ie. btrfs_get_extent_fiemap().
> 
> Then llseek() with SEEK_HOLE/SEEK_DATA also get affected.
> 
> So limiting the extra time to merging extent maps in fiemap is still valid.
>

Per my test, the v3 patch doesn't make big difference on the side of
performance.  The numbers proves that the bottleneck is something else instead
of btrfs_get_extent_fiemap, probably it's copy_to_user() in
fiemap_fill_next_extent().

* The numbers,

[1] vanilla 4.11-rc5

real    0m18.477s
user    0m0.109s
sys     0m18.309s

[2]: vanilla + the v3 patch

real    0m18.220s
user    0m0.001s
sys     0m18.165s

[3]: vanilla + merging ems in btrfs_get_extent_fiemap()

real    0m1.803s
user    0m0.001s
sys     0m1.744s

* The simple test I used is as follows,

mkfs.btrfs -f /dev/sdf
mount /dev/sdf /mnt
xfs_io -f -d -c "pwrite -b 4K 0 512M" /mnt/foobar
umount /mnt
mount /dev/sdf /mnt
time (xfs_io -c "fiemap -v" /mnt/foobar > /dev/null)

* The patch in [3] I came up with,

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a18510b..db59557 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7045,9 +7045,27 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 		 * there might actually be delalloc bytes behind it.
 		 */
 		if (em->block_start != EXTENT_MAP_HOLE &&
-		    !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+		    !test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
+			u64 merge_start = start;
+			u64 merge_len = len;
+			struct extent_map *tmp = em;
+
+			while ((start + len) > extent_map_end(tmp)) {
+				merge_start = extent_map_end(tmp);
+				merge_len = (start + len) - extent_map_end(tmp);
+				tmp = btrfs_get_extent(inode, page, pg_offset, merge_start, merge_len, create);
+				if (IS_ERR(tmp))
+					break;
+				if (tmp->start != start) {
+					free_extent_map(tmp);
+					break;
+				}
+				/* now tmp is the merged one */
+				free_extent_map(em);
+				em = tmp;
+			}
 			return em;
-		else
+		} else
 			hole_em = em;
 	}
 

Thanks,

-liubo


> Thanks,
> Qu
> > 
> > Thanks,
> > 
> > -liubo
> > > In theory, they have the same effect for fiemap.
> > > And that's my original idea.
> > > 
> > > But the problem is, btrfs_get_extent() is called almost everywhere, more
> > > frequently than extent_fiemap(), the extra time used to merging extent map
> > > may cause performance problem.
> > > 
> > > For the worst case, if a file is made up by 262144 4K extent (takes up 1G),
> > > btrfs_get_extent() call on the file will iterate all these extents,
> > > which will iterate more than 500 16K tree blocks.
> > > 
> > > If only fiemap takes such longer time, it's still acceptable. But if
> > > btrfs_get_extent() takes such longer time, I think it will be a problem
> > > then.
> > > 
> > > Thanks,
> > > Qu
> > > 
> > > 
> > > > 
> > > > If no extent map could be merged, which is the worst case, the first
> > > > btrfs_get_extent_fiemap will read file metadata into memory from disk and the
> > > > following btrfs_get_extent_fiemap will read the rest of file metadata from
> > > > the in-memory extent map tree directly.
> > > > 
> > > > Thanks,
> > > > 
> > > > -liubo
> > > > 
> > > > > It can also be done in fs/ioctl.c, however the problem is if
> > > > > fieinfo->fi_extents_max == 0, we have no space to cache previous fiemap
> > > > > extent.
> > > > > So I choose to merge it in btrfs.
> > > > > 
> > > > > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > > > > ---
> > > > > v2:
> > > > >     Since fiemap_extent_info has a limit for number of fiemap_extent, it's possible
> > > > >     that fiemap_fill_next_extent() return 1 halfway. Remove the WARN_ON() which can
> > > > >     cause kernel warning if we fiemap is called on large compressed file.
> > > > > v3:
> > > > >     Rename finish_fiemap_extent() to check_fiemap_extent(), as in v3 we ensured
> > > > >     submit_fiemap_extent() to submit fiemap cache, so it just acts as a
> > > > >     sanity check.
> > > > >     Remove BTRFS_MAX_EXTENT_SIZE limit in submit_fiemap_extent(), as
> > > > >     extent map can be larger than BTRFS_MAX_EXTENT_SIZE.
> > > > >     Don't do backward jump, suggested by David.
> > > > >     Better sanity check and recoverable fix.
> > > > > 
> > > > > To David:
> > > > >     What about adding a btrfs_debug_warn(), which will only call WARN_ON(1) if
> > > > >     BTRFS_CONFIG_DEBUG is specified for recoverable bug?
> > > > > 
> > > > >     And modify ASSERT() to always WARN_ON() and exit error code?
> > > > > ---
> > > > >    fs/btrfs/extent_io.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++-
> > > > >    1 file changed, 122 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > > > index 28e8192..c4cb65d 100644
> > > > > --- a/fs/btrfs/extent_io.c
> > > > > +++ b/fs/btrfs/extent_io.c
> > > > > @@ -4353,6 +4353,123 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
> > > > >    	return NULL;
> > > > >    }
> > > > > +/*
> > > > > + * To cache previous fiemap extent
> > > > > + *
> > > > > + * Will be used for merging fiemap extent
> > > > > + */
> > > > > +struct fiemap_cache {
> > > > > +	u64 offset;
> > > > > +	u64 phys;
> > > > > +	u64 len;
> > > > > +	u32 flags;
> > > > > +	bool cached;
> > > > > +};
> > > > > +
> > > > > +/*
> > > > > + * Helper to submit fiemap extent.
> > > > > + *
> > > > > + * Will try to merge current fiemap extent specified by @offset, @phys,
> > > > > + * @len and @flags with cached one.
> > > > > + * And only when we fails to merge, cached one will be submitted as
> > > > > + * fiemap extent.
> > > > > + *
> > > > > + * Return value is the same as fiemap_fill_next_extent().
> > > > > + */
> > > > > +static int submit_fiemap_extent(struct fiemap_extent_info *fieinfo,
> > > > > +				struct fiemap_cache *cache,
> > > > > +				u64 offset, u64 phys, u64 len, u32 flags)
> > > > > +{
> > > > > +	int ret = 0;
> > > > > +
> > > > > +	if (!cache->cached)
> > > > > +		goto assign;
> > > > > +
> > > > > +	/*
> > > > > +	 * Sanity check, extent_fiemap() should have ensured that new
> > > > > +	 * fiemap extent won't overlap with cahced one.
> > > > > +	 * Not recoverable.
> > > > > +	 *
> > > > > +	 * NOTE: Physical address can overlap, due to compression
> > > > > +	 */
> > > > > +	if (cache->offset + cache->len > offset) {
> > > > > +		WARN_ON(1);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > > +	/*
> > > > > +	 * Only merges fiemap extents if
> > > > > +	 * 1) Their logical addresses are continuous
> > > > > +	 *
> > > > > +	 * 2) Their physical addresses are continuous
> > > > > +	 *    So truly compressed (physical size smaller than logical size)
> > > > > +	 *    extents won't get merged with each other
> > > > > +	 *
> > > > > +	 * 3) Share same flags except FIEMAP_EXTENT_LAST
> > > > > +	 *    So regular extent won't get merged with prealloc extent
> > > > > +	 */
> > > > > +	if (cache->offset + cache->len  == offset &&
> > > > > +	    cache->phys + cache->len == phys  &&
> > > > > +	    (cache->flags & ~FIEMAP_EXTENT_LAST) ==
> > > > > +			(flags & ~FIEMAP_EXTENT_LAST)) {
> > > > > +		cache->len += len;
> > > > > +		cache->flags |= flags;
> > > > > +		goto try_submit_last;
> > > > > +	}
> > > > > +
> > > > > +	/* Not mergeable, need to submit cached one */
> > > > > +	ret = fiemap_fill_next_extent(fieinfo, cache->offset, cache->phys,
> > > > > +				      cache->len, cache->flags);
> > > > > +	cache->cached = false;
> > > > > +	if (ret)
> > > > > +		return ret;
> > > > > +assign:
> > > > > +	cache->cached = true;
> > > > > +	cache->offset = offset;
> > > > > +	cache->phys = phys;
> > > > > +	cache->len = len;
> > > > > +	cache->flags = flags;
> > > > > +try_submit_last:
> > > > > +	if (cache->flags & FIEMAP_EXTENT_LAST) {
> > > > > +		ret = fiemap_fill_next_extent(fieinfo, cache->offset,
> > > > > +				cache->phys, cache->len, cache->flags);
> > > > > +		cache->cached = false;
> > > > > +	}
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Sanity check for fiemap cache
> > > > > + *
> > > > > + * All fiemap cache should be submitted by submit_fiemap_extent()
> > > > > + * Iteration should be terminated either by last fiemap extent or
> > > > > + * fieinfo->fi_extents_max.
> > > > > + * So no cached fiemap should exist.
> > > > > + */
> > > > > +static int check_fiemap_cache(struct btrfs_fs_info *fs_info,
> > > > > +			       struct fiemap_extent_info *fieinfo,
> > > > > +			       struct fiemap_cache *cache)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	if (!cache->cached)
> > > > > +		return 0;
> > > > > +
> > > > > +	/* Small and recoverbale problem, only to info developer */
> > > > > +#ifdef CONFIG_BTRFS_DEBUG
> > > > > +	WARN_ON(1);
> > > > > +#endif
> > > > > +	btrfs_warn(fs_info,
> > > > > +		   "unhandled fiemap cache detected: offset=%llu phys=%llu len=%llu flags=0x%x",
> > > > > +		   cache->offset, cache->phys, cache->len, cache->flags);
> > > > > +	ret = fiemap_fill_next_extent(fieinfo, cache->offset, cache->phys,
> > > > > +				      cache->len, cache->flags);
> > > > > +	cache->cached = false;
> > > > > +	if (ret > 0)
> > > > > +		ret = 0;
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > >    int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > > > >    		__u64 start, __u64 len, get_extent_t *get_extent)
> > > > >    {
> > > > > @@ -4370,6 +4487,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > > > >    	struct extent_state *cached_state = NULL;
> > > > >    	struct btrfs_path *path;
> > > > >    	struct btrfs_root *root = BTRFS_I(inode)->root;
> > > > > +	struct fiemap_cache cache = { 0 };
> > > > >    	int end = 0;
> > > > >    	u64 em_start = 0;
> > > > >    	u64 em_len = 0;
> > > > > @@ -4549,8 +4667,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > > > >    			flags |= FIEMAP_EXTENT_LAST;
> > > > >    			end = 1;
> > > > >    		}
> > > > > -		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
> > > > > -					      em_len, flags);
> > > > > +		ret = submit_fiemap_extent(fieinfo, &cache, em_start, disko,
> > > > > +					   em_len, flags);
> > > > >    		if (ret) {
> > > > >    			if (ret == 1)
> > > > >    				ret = 0;
> > > > > @@ -4558,6 +4676,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > > > >    		}
> > > > >    	}
> > > > >    out_free:
> > > > > +	if (!ret)
> > > > > +		ret = check_fiemap_cache(root->fs_info, fieinfo, &cache);
> > > > >    	free_extent_map(em);
> > > > >    out:
> > > > >    	btrfs_free_path(path);
> > > > > -- 
> > > > > 2.9.3
> > > > > 
> > > > > 
> > > > > 
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > > 
> > > 
> > > 
> > 
> > 
> 
> 
