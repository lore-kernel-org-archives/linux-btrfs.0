Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:32793 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbeINEpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 00:45:12 -0400
Subject: Re: [PATCH v2 3/7] btrfs-progs: lowmem check: find dir_item by di_key
 in check_dir_item()
To: damenly.su@gmail.com, linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
References: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
 <20180912204924.10089-4-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f9af6185-00ea-5736-a758-f6a0a61d8610@gmx.com>
Date: Fri, 14 Sep 2018 07:33:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180912204924.10089-4-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/13 上午4:49, damenly.su@gmail.com wrote:
> From: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> In check_dir_item, we are going to search corresponding
> dir_item/index.
> 
> Commit 564901eac7a4 ("btrfs-progs: check: introduce
> print_dir_item_err()") Changed argument name from key to di_key but
> forgot to change the key name for dir_item search.
> So @key shouldn't be used here. It should be @di_key.
> 
> Fixes: 564901eac7a4 ("btrfs-progs: check: introduce print_dir_item_err()")

Which also forgot to modify comment about parameters.

> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/mode-lowmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 1bce44f5658a..89a304bbdd69 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1658,7 +1658,7 @@ begin:
>  
>  		/* check relative INDEX/ITEM */
>  		key.objectid = di_key->objectid;
> -		if (key.type == BTRFS_DIR_ITEM_KEY) {
> +		if (di_key->type == BTRFS_DIR_ITEM_KEY) {

To avoid such problem, I recommend to rename @key to @search_key, and
move the declaration inside the while loop.

Thanks,
Qu

>  			key.type = BTRFS_DIR_INDEX_KEY;
>  			key.offset = index;
>  		} else {
> 
