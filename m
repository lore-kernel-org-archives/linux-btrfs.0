Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17101 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdHRTDx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 15:03:53 -0400
Date: Fri, 18 Aug 2017 11:59:40 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: submit superblock io with REQ_META
Message-ID: <20170818185940.GB25986@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170818162153.22389-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818162153.22389-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 06:21:53PM +0200, David Sterba wrote:
> The superblock is also metadata of the filesystem so the relevant IO
> should be tagged as such.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 90b967ae46d0..21b55e8caf33 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3433,9 +3433,11 @@ static int write_dev_supers(struct btrfs_device *device,
>  		 */
>  		if (i == 0) {
>  			ret = btrfsic_submit_bh(REQ_OP_WRITE,
> -						REQ_SYNC | REQ_FUA, bh);
> +						REQ_SYNC | REQ_FUA | REQ_META,
> +						bh);
>  		} else {
> -			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> +			ret = btrfsic_submit_bh(REQ_OP_WRITE,
> +						REQ_SYNC | REQ_META, bh);
>  		}
>  		if (ret)
>  			errors++;
> -- 
> 2.14.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
