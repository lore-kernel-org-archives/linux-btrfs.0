Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52330 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750991AbdCNItn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:49:43 -0400
Subject: Re: [PATCH 2/4] btrfs: Communicate back ENOMEM when it occurs
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20170313074214.24123-1-anand.jain@oracle.com>
 <20170313074214.24123-3-anand.jain@oracle.com>
CC: <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <dc23dd00-fe39-dd9c-cc06-0ee6639728ec@cn.fujitsu.com>
Date: Tue, 14 Mar 2017 16:49:38 +0800
MIME-Version: 1.0
In-Reply-To: <20170313074214.24123-3-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/13/2017 03:42 PM, Anand Jain wrote:
> The only error that write dev flush (send) will fail is due
> to the ENOMEM then, as its not a device specific error and
> rather a system wide issue, we should rather stop further
> iterations and perpetuate the -ENOMEM error to the caller.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Looks good.

Although it would be better to add one line comment for the reason.
It's obvious when reading your commit message, but not so when reading 
the code itself.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> ---
>  fs/btrfs/disk-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 08b74daf35d0..ee3e601da511 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3592,7 +3592,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>
>  		ret = write_dev_flush(dev, 0);
>  		if (ret)
> -			errors_send++;
> +			return ret;
>  	}
>
>  	/* wait for all the barriers */
>


