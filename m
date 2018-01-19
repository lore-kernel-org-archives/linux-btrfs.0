Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14281 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750785AbeASHf0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 02:35:26 -0500
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <9fe43408-dfcd-efa3-7195-87fcdba033ab@cn.fujitsu.com>
Date: Fri, 19 Jan 2018 15:39:40 +0800
MIME-Version: 1.0
In-Reply-To: <20180119072536.22286-3-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/19/2018 03:25 PM, Qu Wenruo wrote:
> btrfs_match_dir_item_name() will check if its filetype is valid before
> doing search, this makes btrfs-progs unable to locate and remove invalid
> dir_index for btrfs_unlink().
> 
> This function only affects btrfs_link() and btrfs_unlink() in upper
> layer, and normal check can find invalid filetype by itself.
> 
Lowmem mode can't handles wrong filetype well now.
I'm working on it. And this change is okay for me.

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> So remove the filetype check is completely safe in this case, and will
> enhance btrfs_unlink() to remove invalid dir_index/dir_item for repair.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   dir-item.c | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/dir-item.c b/dir-item.c
> index 462546c0eaf4..e0a0ab4d7a5d 100644
> --- a/dir-item.c
> +++ b/dir-item.c
> @@ -294,12 +294,6 @@ static int verify_dir_item(struct btrfs_root *root,
>   	u16 namelen = BTRFS_NAME_LEN;
>   	u8 type = btrfs_dir_type(leaf, dir_item);
>   
> -	if (type >= BTRFS_FT_MAX) {
> -		fprintf(stderr, "invalid dir item type: %d\n",
> -		       (int)type);
> -		return 1;
> -	}
> -
>   	if (type == BTRFS_FT_XATTR)
>   		namelen = XATTR_NAME_MAX;
>   
> 


