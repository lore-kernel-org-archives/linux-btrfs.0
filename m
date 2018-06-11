Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52283 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753750AbeFKEmL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 00:42:11 -0400
Subject: Re: [PATCH 01/15] btrfs-progs: Remove root argument from
 pin_down_bytes
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-2-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d497b2e5-a7ed-b4f9-051e-6ce775dc9831@gmx.com>
Date: Mon, 11 Jun 2018 12:41:56 +0800
MIME-Version: 1.0
In-Reply-To: <1528462078-24490-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月08日 20:47, Nikolay Borisov wrote:
> This argument is used to obtain a reference to fs_info, which can
> already be done from the passed trans handle, so use that instead.
> This is in preparation for delayed refs support.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  extent-tree.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/extent-tree.c b/extent-tree.c
> index 0643815bd41c..cbc022f6cef6 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -2098,9 +2098,8 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
>  	return 0;
>  }
>  
> -static int pin_down_bytes(struct btrfs_trans_handle *trans,
> -			  struct btrfs_root *root,
> -			  u64 bytenr, u64 num_bytes, int is_data)
> +static int pin_down_bytes(struct btrfs_trans_handle *trans, u64 bytenr,
> +			  u64 num_bytes, int is_data)
>  {
>  	int err = 0;
>  	struct extent_buffer *buf;
> @@ -2108,7 +2107,7 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
>  	if (is_data)
>  		goto pinit;
>  
> -	buf = btrfs_find_tree_block(root->fs_info, bytenr, num_bytes);
> +	buf = btrfs_find_tree_block(trans->fs_info, bytenr, num_bytes);
>  	if (!buf)
>  		goto pinit;
>  
> @@ -2360,7 +2359,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>  		}
>  
>  		if (pin) {
> -			ret = pin_down_bytes(trans, root, bytenr, num_bytes,
> +			ret = pin_down_bytes(trans, bytenr, num_bytes,
>  					     is_data);
>  			if (ret > 0)
>  				mark_free = 1;
> 
