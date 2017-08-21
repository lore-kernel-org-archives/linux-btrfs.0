Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23679 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753628AbdHUTEu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 15:04:50 -0400
Date: Mon, 21 Aug 2017 12:00:33 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: submit superblock io with REQ_META and REQ_PRIO
Message-ID: <20170821190033.GA26279@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170821154227.13644-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821154227.13644-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 05:42:27PM +0200, David Sterba wrote:
> The superblock is also metadata of the filesystem so the relevant IO
> should be tagged as such. We also tag it as high priority, as it's the
> last block committed for metadata from a given transaction. Any delays
> would effectively block the whole transaction, also blocking any other
> operation holding the device_list_mutex.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 90b967ae46d0..27d458640536 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3433,9 +3433,10 @@ static int write_dev_supers(struct btrfs_device *device,
>  		 */
>  		if (i == 0) {
>  			ret = btrfsic_submit_bh(REQ_OP_WRITE,
> -						REQ_SYNC | REQ_FUA, bh);
> +				REQ_SYNC | REQ_FUA | REQ_META | REQ_PRIO, bh);
>  		} else {
> -			ret = btrfsic_submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> +			ret = btrfsic_submit_bh(REQ_OP_WRITE,
> +				REQ_SYNC | REQ_META | REQ_PRIO, bh);
>  		}
>  		if (ret)
>  			errors++;
> -- 
> 2.14.0
> 
