Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46655 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965232AbeEIQSO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 12:18:14 -0400
Subject: Re: [PATCH v2 1/2] Btrfs: fiemap: pass correct bytenr when
 fm_extent_count is zero
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <1525682525-1424-1-git-send-email-robbieko@synology.com>
 <1525682525-1424-2-git-send-email-robbieko@synology.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <88269188-96e7-8891-698b-f757f56f5635@suse.com>
Date: Wed, 9 May 2018 19:18:09 +0300
MIME-Version: 1.0
In-Reply-To: <1525682525-1424-2-git-send-email-robbieko@synology.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.05.2018 11:42, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> [BUG]
> fm_mapped_extents is not correct when fm_extent_count is 0
> Like:
>    # mount /dev/vdb5 /mnt/btrfs
>    # dd if=/dev/zero bs=16K count=4 oflag=dsync of=/mnt/btrfs/file
>    # xfs_io -c "fiemap -v" /mnt/btrfs/file
>    /mnt/btrfs/file:
>    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>      0: [0..127]:        25088..25215       128   0x1
> 
> When user space wants to get the number of file extents,
> set fm_extent_count to 0 to run fiemap and then read fm_mapped_extents.
 "it sets fm_extent_count to 0.... and then reads fm_mapped_extents"

> 
> In the above example, fiemap will return with fm_mapped_extents set to 4,
> but it should be 1 since there's only one entry in the output.
> 
> [REASON]
> The problem seems to be that disko is only set if
> fieinfo->fi_extents_max is set. And this member is initialized, in the
> generic ioctl_fiemap function, to the value of used-passed
                                                  ^^^^
                                                  user-passed
> fm_extent_count. So when the user passes 0 then fi_extent_max is also
> set to zero and this causes btrfs to not initialize disko at all.
> Eventually this leads emit_fiemap_extent being called with a bogus
> 'phys' argument preventing proper fiemap entries merging.
> 
> [FIX]
> Move the disko initialization earlier in extent_fiemap making it
> independent of user-passed arguments, allowing emit_fiemap_extent to
> properly handle consecutive extent entries.
> 
> Signed-off-by: Robbie Ko <robbieko@synology.com>
Only a couple of minor nits w.r.t the changelog but I guess David can
fix this on the go. In any case :

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> V2:
> fix comments.
> 
>  fs/btrfs/extent_io.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 012d638..066b6df 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4567,7 +4567,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  			offset_in_extent = em_start - em->start;
>  		em_end = extent_map_end(em);
>  		em_len = em_end - em_start;
> -		disko = 0;
> +		disko = em->block_start + offset_in_extent;
>  		flags = 0;
>  
>  		/*
> @@ -4590,8 +4590,6 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  			u64 bytenr = em->block_start -
>  				(em->start - em->orig_start);
>  
> -			disko = em->block_start + offset_in_extent;
> -
>  			/*
>  			 * As btrfs supports shared space, this information
>  			 * can be exported to userspace tools via
> 
