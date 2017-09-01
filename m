Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61315 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbdIALcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 07:32:50 -0400
Subject: Re: [PATCH 2/2] btrfs: finish ordered extent cleaning if no progress
 is found
To: Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com, clm@fb.com, dsterba@suse.com, jbacik@fb.com
References: <150425632766.4737.133868215044509089.stgit@naota.dhcp.fujisawa.hgst.com>
 <150425634736.4737.8343712690392096633.stgit@naota.dhcp.fujisawa.hgst.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <741949a9-32e6-ce18-0e7c-ca259edf909b@gmx.com>
Date: Fri, 1 Sep 2017 19:31:58 +0800
MIME-Version: 1.0
In-Reply-To: <150425634736.4737.8343712690392096633.stgit@naota.dhcp.fujisawa.hgst.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月01日 16:59, Naohiro Aota wrote:
> __endio_write_update_ordered() repeats the search until it reaches the end
> of the specified range. This works well with direct IO path, because before
> the function is called, it's ensured that there are ordered extents filling
> whole the range. It's not the case, however, when it's called from
> run_delalloc_range(): it is possible to have error in the midle of the loop
> in e.g. run_delalloc_nocow(), so that there exisits the range not covered
> by any ordered extents. By cleaning such "uncomplete" range,
> __endio_write_update_ordered() stucks at offset where there're no ordered
> extents.
> 
> Since the ordered extents are created from head to tail, we can stop the
> search if there are no offset progress.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> Fixes: 524272607e88 ("btrfs: Handle delalloc error correctly to avoid ordered extent hang")
> Cc: <stable@vger.kernel.org> # 4.12
> ---
>   fs/btrfs/inode.c |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ae4c0a1bef38..fd5934121b4b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8309,6 +8309,7 @@ static void __endio_write_update_ordered(struct inode *inode,
>   	btrfs_work_func_t func;
>   	u64 ordered_offset = offset;
>   	u64 ordered_bytes = bytes;
> +	u64 last_offset;
>   	int ret;
>   
>   	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
> @@ -8320,6 +8321,7 @@ static void __endio_write_update_ordered(struct inode *inode,
>   	}
>   
>   again:
> +	last_offset = ordered_offset;
>   	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
>   						   &ordered_offset,
>   						   ordered_bytes,
> @@ -8330,6 +8332,8 @@ static void __endio_write_update_ordered(struct inode *inode,
>   	btrfs_init_work(&ordered->work, func, finish_ordered_fn, NULL, NULL);
>   	btrfs_queue_work(wq, &ordered->work);
>   out_test:
> +	if (ordered_offset == last_offset)
> +		return;

Such check seems strange to me.

For ordered_offset == last_offset case, it means 
btrfs_dec_test_ordered_pending() doesn't find any ordered extent in that 
range, so we can exit.
This takes me a while to dig into btrfs_dec_test_first_ordered_pending().

Extra comment will help here, or to modify 
btrfs_dev_test_ordered_pending() to explicitly info caller there is no 
extra pending ordered extent.

Thanks,
Qu

>   	/*
>   	 * our bio might span multiple ordered extents.  If we haven't
>   	 * completed the accounting for the whole dio, go back and try again
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
