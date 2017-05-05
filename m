Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48841 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750796AbdEERlx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 13:41:53 -0400
Date: Fri, 5 May 2017 19:41:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
Message-ID: <20170505174145.GK10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170412150535.GM4781@twin.jikos.cz>
 <f7edd49d-8955-2e4e-1122-8b5026f14eb6@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f7edd49d-8955-2e4e-1122-8b5026f14eb6@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 13, 2017 at 08:36:24AM +0800, Qu Wenruo wrote:
> 
> 
> At 04/12/2017 11:05 PM, David Sterba wrote:
> > On Fri, Apr 07, 2017 at 10:43:15AM +0800, Qu Wenruo wrote:
> >> [BUG]
> >> Cycle mount btrfs can cause fiemap to return different result.
> >> Like:
> >>   # mount /dev/vdb5 /mnt/btrfs
> >>   # dd if=/dev/zero bs=16K count=4 oflag=dsync of=/mnt/btrfs/file
> >>   # xfs_io -c "fiemap -v" /mnt/btrfs/file
> >>   /mnt/test/file:
> >>   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
> >>     0: [0..127]:        25088..25215       128   0x1
> >>   # umount /mnt/btrfs
> >>   # mount /dev/vdb5 /mnt/btrfs
> >>   # xfs_io -c "fiemap -v" /mnt/btrfs/file
> >>   /mnt/test/file:
> >>   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
> >>     0: [0..31]:         25088..25119        32   0x0
> >>     1: [32..63]:        25120..25151        32   0x0
> >>     2: [64..95]:        25152..25183        32   0x0
> >>     3: [96..127]:       25184..25215        32   0x1
> >> But after above fiemap, we get correct merged result if we call fiemap
> >> again.
> >>   # xfs_io -c "fiemap -v" /mnt/btrfs/file
> >>   /mnt/test/file:
> >>   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
> >>     0: [0..127]:        25088..25215       128   0x1
> >>
> >> [REASON]
> >> Btrfs will try to merge extent map when inserting new extent map.
> >>
> >> btrfs_fiemap(start=0 len=(u64)-1)
> >> |- extent_fiemap(start=0 len=(u64)-1)
> >>     |- get_extent_skip_holes(start=0 len=64k)
> >>     |  |- btrfs_get_extent_fiemap(start=0 len=64k)
> >>     |     |- btrfs_get_extent(start=0 len=64k)
> >>     |        |  Found on-disk (ino, EXTENT_DATA, 0)
> >>     |        |- add_extent_mapping()
> >>     |        |- Return (em->start=0, len=16k)
> >>     |
> >>     |- fiemap_fill_next_extent(logic=0 phys=X len=16k)
> >>     |
> >>     |- get_extent_skip_holes(start=0 len=64k)
> >>     |  |- btrfs_get_extent_fiemap(start=0 len=64k)
> >>     |     |- btrfs_get_extent(start=16k len=48k)
> >>     |        |  Found on-disk (ino, EXTENT_DATA, 16k)
> >>     |        |- add_extent_mapping()
> >>     |        |  |- try_merge_map()
> >>     |        |     Merge with previous em start=0 len=16k
> >>     |        |     resulting em start=0 len=32k
> >>     |        |- Return (em->start=0, len=32K)    << Merged result
> >>     |- Stripe off the unrelated range (0~16K) of return em
> >>     |- fiemap_fill_next_extent(logic=16K phys=X+16K len=16K)
> >>        ^^^ Causing split fiemap extent.
> >>
> >> And since in add_extent_mapping(), em is already merged, in next
> >> fiemap() call, we will get merged result.
> >>
> >> [FIX]
> >> Here we introduce a new structure, fiemap_cache, which records previous
> >> fiemap extent.
> >>
> >> And will always try to merge current fiemap_cache result before calling
> >> fiemap_fill_next_extent().
> >> Only when we failed to merge current fiemap extent with cached one, we
> >> will call fiemap_fill_next_extent() to submit cached one.
> >>
> >> So by this method, we can merge all fiemap extents.
> > 
> > The cache gets reset on each call to extent_fiemap, so if fi_extents_max
> > is 1, the cache will be always unset and we'll never merge anything. The
> > same can happen if the number of extents reaches the limit
> > (FIEMAP_MAX_EXTENTS or any other depending on the ioctl caller). And
> > this leads to the unmerged extents.
> 
> Nope, extents will still be merged, as long as they can be merged.
> 
> The fiemap extent is only submitted if we found an unmergeable extent.
> 
> Even fi_extents_max is 1, it still possible for us to merge extents.
> 
> File A:
> Extent 1: offset=0 len=4k phys=X
> Extent 2: offset=4k len=4k phys=X+4
> Extent 3: offset=8k len=4k phys=Y
> 
> 1) Found Extent 1
>     Cache it, not submitted yet.
> 2) Found Extent 2
>     Merge it with cached one, not submitted yet.
> 3) Found Extent 3
>     Can't merge, submit cached first.
>     Submitted one reach fi_extents_max, exit current extent_fiemap.
> 
> 4) Next fiemap call starts from offset 8K,
>     Extent 3 is the last extent, no need to cache just submit.
> 
> So we still got merged fiemap extent, without anything wrong.
> 
> The point is, fi_extents_max or other limit can only be merged when we 
> submit fiemap_extent, in that case either we found unmergable extent, or 
> we already hit the last extent.

Thanks for the explanation.

> >> It can also be done in fs/ioctl.c, however the problem is if
> >> fieinfo->fi_extents_max == 0, we have no space to cache previous fiemap
> >> extent.
> > 
> > I don't see why, it's the same code path, no?
> 
> My original design in VFS is to check if we can merge current fiemap 
> extent with the last one in fiemap_info.
> 
> But for fi_extents_max == 0 case, fiemap_info doesn't store any extent 
> so that's not possible.
> 
> 
> So for fi_extents_max == 0 case, either do it in each fs like what we 
> are doing, or introduce a new function like fiemap_cache_next_extent() 
> with reference to cached structure.
> 
> > 
> >> So I choose to merge it in btrfs.
> > 
> > Lifting that to the vfs interface is probably not the right approach.
> > The ioctl has never done any postprocessing of the data returned by
> > filesystems, it's really up to the filesystem to prepare the data.
> 
> OK, let's keep it in btrfs.
> 
> > 
> >> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >> ---
> >> v2:
> >>    Since fiemap_extent_info has a limit for number of fiemap_extent, it's possible
> >>    that fiemap_fill_next_extent() return 1 halfway. Remove the WARN_ON() which can
> >>    cause kernel warning if we fiemap is called on large compressed file.
> >> v3:
> >>    Rename finish_fiemap_extent() to check_fiemap_extent(), as in v3 we ensured
> >>    submit_fiemap_extent() to submit fiemap cache, so it just acts as a
> >>    sanity check.
> >>    Remove BTRFS_MAX_EXTENT_SIZE limit in submit_fiemap_extent(), as
> >>    extent map can be larger than BTRFS_MAX_EXTENT_SIZE.
> >>    Don't do backward jump, suggested by David.
> >>    Better sanity check and recoverable fix.
> >>
> >> To David:
> >>    What about adding a btrfs_debug_warn(), which will only call WARN_ON(1) if
> >>    BTRFS_CONFIG_DEBUG is specified for recoverable bug?
> >>
> >>    And modify ASSERT() to always WARN_ON() and exit error code?
> > 
> > That's for a separate discussion.
> > 
> >> ---
> >>   fs/btrfs/extent_io.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++-
> >>   1 file changed, 122 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> >> index 28e8192..c4cb65d 100644
> >> --- a/fs/btrfs/extent_io.c
> >> +++ b/fs/btrfs/extent_io.c
> >> @@ -4353,6 +4353,123 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
> >>   	return NULL;
> >>   }
> >>   
> >> +/*
> >> + * To cache previous fiemap extent
> >> + *
> >> + * Will be used for merging fiemap extent
> >> + */
> >> +struct fiemap_cache {
> >> +	u64 offset;
> >> +	u64 phys;
> >> +	u64 len;
> >> +	u32 flags;
> >> +	bool cached;
> >> +};
> >> +
> >> +/*
> >> + * Helper to submit fiemap extent.
> >> + *
> >> + * Will try to merge current fiemap extent specified by @offset, @phys,
> >> + * @len and @flags with cached one.
> >> + * And only when we fails to merge, cached one will be submitted as
> >> + * fiemap extent.
> >> + *
> >> + * Return value is the same as fiemap_fill_next_extent().
> >> + */
> >> +static int submit_fiemap_extent(struct fiemap_extent_info *fieinfo,
> > 
> > I'd suggest to rename it to emmit_fiemap_extent
> 
> I'm OK to change it in next version.

As we agree on the patch, I'll rename the varaible and you don't need to
send a new version. I made a typo, the intended name was emit_fiemap_extent.
