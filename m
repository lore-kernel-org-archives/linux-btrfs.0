Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47822 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbeEOIVt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 04:21:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3F2FAD79
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 08:21:47 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs: inode: Don't compress if NODATASUM or
 NODATACOW set
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180515073622.18732-1-wqu@suse.com>
 <20180515073622.18732-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9c4e5071-d83b-01db-2c2f-518ee1650713@suse.com>
Date: Tue, 15 May 2018 11:21:47 +0300
MIME-Version: 1.0
In-Reply-To: <20180515073622.18732-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.05.2018 10:36, Qu Wenruo wrote:
> As btrfs(5) specified:
> 
> 	Note
> 	If nodatacow or nodatasum are enabled, compression is disabled.
> 
> If NODATASUM or NODATACOW set, we should not compress the extent.
> 
> Normally NODATACOW is detected properly in run_delalloc_range() so
> compression won't happen for NODATACOW.
> 
> However for NODATASUM we don't have any check, and it can cause
> compressed extent without csum pretty easily, just by:
> ------
> mkfs.btrfs -f $dev
> mount $dev $mnt -o nodatasum
> touch $mnt/foobar
> mount -o remount,datasum,compress $mnt
> xfs_io -f -c "pwrite 0 128K" $mnt/foobar
> ------
> 
> And in fact, we have bug report about corrupted compressed extent
> without proper data checksum so even RAID1 can't recover the corruption.
> (https://bugzilla.kernel.org/show_bug.cgi?id=199707)
> 
> Running compression without proper checksum could cause more damage when
> corruption happens, so there is no need to allow compression for
> NODATACSUM.
> 
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d241285a0d2a..dbef3f404559 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -396,6 +396,14 @@ static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  
> +	/*
> +	 * Btrfs doesn't support compression without csum or CoW.
> +	 * This should have the highest priority.
> +	 */
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
> +	    BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
> +		return 0;
> +

How is this not buggy, given that if inode_need_compress as called from 
compress_file_range will return zero, meaning we jump to cont: label. 
Then in the case of an inline extent we can execute : 

ret = cow_file_range_inline(inode, start, end,          
                           total_compressed,           
                           compress_type, pages);   

where compress_type would have been set at the beginning of the 
function unconditionally to fs_info->compress_type. 

For non-inline extents I guess we are ok, given that will_compress 
will not be set. However, this code is rather messy and I'm not sure 
it's well defined what's going to happen in this case with inline extents. 

OTOH, I think there is something fundamentally wrong in calling 
inode_need_compress in compress_file_range. I.e they work at different 
abstractions. IMO compress_file_range should only be called if we know 
we have to compress the range. 

So looking around the code in run_delalloc_range (the only function 
which calls cow_file_range_async) we already have : 

 } else if (!inode_need_compress(inode, start, end)) {                   
                ret = cow_file_range(inode, locked_page, start, end, end,       
                                      page_started, nr_written, 1, NULL);   

and in the else branch we have the cow_file_range_async. So the code 
is sort of half-way there to actually decoupling compression checking from 
performing the actual compression. 


>  	/* force compress */
>  	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
>  		return 1;

One more thing, in inode_need_compress shouldn't the inode specific
checks come first something like : 


static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)  
{                                                                               
        struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);                  
                                                                                
        /* defrag ioctl */                                                      
        if (BTRFS_I(inode)->defrag_compress)                                    
                return 1;                                                       
        /* bad compression ratios */                                            
        if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)                     
                return 0;                                                       
        /* force compress */                                                    
        if (btrfs_test_opt(fs_info, FORCE_COMPRESS))                            
                return 1;                                                       
        if (btrfs_test_opt(fs_info, COMPRESS) ||                                
            BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||                     
            BTRFS_I(inode)->prop_compress)                                      
                return btrfs_compress_heuristic(inode, start, end);             
        return 0;                                                               
}             

> 
