Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:36539 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753750AbeFKEsA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 00:48:00 -0400
Subject: Re: [PATCH 03/15] btrfs-progs: Add functions to modify the used space
 by a root
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-4-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6708d279-2257-8164-6ec6-05061fcc2e06@gmx.com>
Date: Mon, 11 Jun 2018 12:47:46 +0800
MIME-Version: 1.0
In-Reply-To: <1528462078-24490-4-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月08日 20:47, Nikolay Borisov wrote:
> Pull the necessary function, excluding locking. Required to enable
> integration of delayed refs.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  ctree.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/ctree.c b/ctree.c
> index 2c51580fec65..7b74716bf92f 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -76,6 +76,18 @@ void add_root_to_dirty_list(struct btrfs_root *root)
>  	}
>  }
>  
> +static void root_add_used(struct btrfs_root *root, u32 size)
> +{
> +        btrfs_set_root_used(&root->root_item,
> +                            btrfs_root_used(&root->root_item) + size);
> +}
> +
> +static void root_sub_used(struct btrfs_root *root, u32 size)
> +{
> +        btrfs_set_root_used(&root->root_item,
> +                            btrfs_root_used(&root->root_item) - size);
> +}
> +

So small that it can be included into the patch which uses this.

BTW, it would be better to do some basic underflow check here.
No need to return int, but some WARN_ON() would definitely help.

Thanks,
Qu

>  int btrfs_copy_root(struct btrfs_trans_handle *trans,
>  		      struct btrfs_root *root,
>  		      struct extent_buffer *buf,
> 
