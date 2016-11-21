Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46176 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752136AbcKUA5d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Nov 2016 19:57:33 -0500
Subject: Re: [PATCH] btrfs: Ensure proper sector alignment for
 btrfs_free_reserved_data_space
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <af6462e2-abaf-746a-6f69-1c83e549c059@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <761de6ff-20ad-cf53-84b7-53ed3335173d@cn.fujitsu.com>
Date: Mon, 21 Nov 2016 08:57:30 +0800
MIME-Version: 1.0
In-Reply-To: <af6462e2-abaf-746a-6f69-1c83e549c059@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/19/2016 10:52 AM, Jeff Mahoney wrote:
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
> byte in the qgroup reservation.

Good catch.

 > That caused an iotree state split, which
> increased the number of outstanding extents, in turn disallowing releasing
> the metadata reservation.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

What about adding more assert/warn_on to reservation/qgroup freeing and 
allocation functions?

It would help much more to detect similar problems.

Thanks,
Qu

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
>  }
>
>


