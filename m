From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [patch] btrfs: make code reachable in btrfs_insert_some_items()
Date: Tue, 29 Jun 2010 08:57:54 +0800
Message-ID: <4C294512.8070302@cn.fujitsu.com>
References: <20100628111726.GI19184@bicker>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Dan Carpenter <error27@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org,
	linux-kerne
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100628111726.GI19184@bicker>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

on 2010-6-28 19:17, Dan Carpenter wrote:
> The break was in front of the "nr = i" assignment so that was never hit.

This bug has been fixed a month ago, and the patch has been merged into the
btrfs-unstable tree.

  http://marc.info/?l=linux-btrfs&m=127434036913484&w=2

Thanks
Miao
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 0d1d966..ceb8ad2 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3453,8 +3453,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
>  	for (i = 0; i < nr; i++) {
>  		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
>  		    BTRFS_LEAF_DATA_SIZE(root)) {
> -			break;
>  			nr = i;
> +			break;
>  		}
>  		total_data += data_size[i];
>  		total_size += data_size[i] + sizeof(struct btrfs_item);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
