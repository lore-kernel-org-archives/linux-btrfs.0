Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27714 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753451AbcLWDPB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 22:15:01 -0500
Subject: Re: [PATCH] Btrfs: adjust outstanding_extents counter properly when
 dio write is split
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1482455634-9185-1-git-send-email-bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, Anand.Jain.anand.jain@oracle.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <46602de5-32b2-6d76-e7b1-24acbe41f6f9@oracle.com>
Date: Fri, 23 Dec 2016 11:18:19 +0800
MIME-Version: 1.0
In-Reply-To: <1482455634-9185-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/23/16 09:13, Liu Bo wrote:
> Currently how btrfs dio deals with split dio write is not good
> enough if dio write is split into several segments due to the
> lack of contiguous space, a large dio write like 'dd bs=1G count=1'
> can end up with incorrect outstanding_extents counter and endio
> would complain loudly with an assertion.
>
> This fixes the problem by compensating the outstanding_extents
> counter in inode if a large dio write gets split.

  Fix works. Thanks Liu bo for working on this.

  Tested-by: Anand Jain <anand.jain@oracle.com>

> Reported-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a4c8796..4175987 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7641,11 +7641,18 @@ static void adjust_dio_outstanding_extents(struct inode *inode,
>  	 * within our reservation, otherwise we need to adjust our inode
>  	 * counter appropriately.
>  	 */
> -	if (dio_data->outstanding_extents) {
> +	if (dio_data->outstanding_extents >= num_extents) {
>  		dio_data->outstanding_extents -= num_extents;
>  	} else {
> +		/*
> +		 * If dio write length has been split due to no large enough
> +		 * contiguous space, we need to compensate our inode counter
> +		 * appropriately.
> +		 */
> +		u64 num_needed = num_extents - dio_data->outstanding_extents;
> +
>  		spin_lock(&BTRFS_I(inode)->lock);
> -		BTRFS_I(inode)->outstanding_extents += num_extents;
> +		BTRFS_I(inode)->outstanding_extents += num_needed;
>  		spin_unlock(&BTRFS_I(inode)->lock);
>  	}
>  }
>
