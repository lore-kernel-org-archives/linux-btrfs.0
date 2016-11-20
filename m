Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28365 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbcKTPvx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Nov 2016 10:51:53 -0500
Date: Sun, 20 Nov 2016 07:50:44 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Ensure proper sector alignment for
 btrfs_free_reserved_data_space
Message-ID: <20161120155044.GA16057@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <af6462e2-abaf-746a-6f69-1c83e549c059@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <af6462e2-abaf-746a-6f69-1c83e549c059@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2016 at 09:52:40PM -0500, Jeff Mahoney wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> Subject: btrfs: Ensure proper sector alignment for
>  btrfs_free_reserved_data_space
> References: bsc#1005666
> Patch-mainline: Submitted 18 Nov 2016, linux-btrfs
> 
> This fixes the WARN_ON on BTRFS_I(inode)->reserved_extents in
> btrfs_destroy_inode and the WARN_ON on nonzero delalloc bytes on umount
> with qgroups enabled.
> 
> I was able to reproduce this by setting up a small (~500kb) quota limit
> and writing a file one byte at a time until I hit the limit.  The warnings
> would all hit on umount.
> 
> The root cause is that we would reserve a block-sized range in both
> the reservation and the quota in btrfs_check_data_free_space, but if we
> encountered a problem (like e.g. EDQUOT), we would only release the single
> byte in the qgroup reservation.  That caused an iotree state split, which
> increased the number of outstanding extents, in turn disallowing releasing
> the metadata reservation.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3822,6 +3822,13 @@ void btrfs_free_reserved_data_space_noqu
>   */
>  void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len)
>  {
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +
> +	/* Make sure the range is aligned to sectorsize */
> +	len = round_up(start + len, root->sectorsize) -
> +	      round_down(start, root->sectorsize);
> +	start = round_down(start, root->sectorsize);
> +
>  	btrfs_free_reserved_data_space_noquota(inode, start, len);
>  	btrfs_qgroup_free_data(inode, start, len);

The patch looks reasonable, but I'm afraid btrfs_fallocate can be
affected since in btrfs_fallocate(), btrfs_qgroup_reserve_data() takes
'cur_offset' and 'last_byte - cur_offset' which are possible unaligned
to root->sectorsize, but if any errors occur during allocation,
btrfs_qgroup_free_data() in btrfs_free_reserved_data_space() is gonna
free aligned range and it ends up a negative qgroup value.

Thanks,

-liubo

>  }
> 
> 
> -- 
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
