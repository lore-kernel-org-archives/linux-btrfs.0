Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753918AbeAKIOK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 03:14:10 -0500
Subject: Re: [PATCH v3 1/2] btrfs: use enum instead of constant value
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <69b34781-2275-ba9b-0df8-50f3c2752e45@suse.com>
 <1515658338-6781-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f2d833a9-5e6a-9b59-7c34-ffceae21857d@suse.com>
Date: Thu, 11 Jan 2018 10:14:08 +0200
MIME-Version: 1.0
In-Reply-To: <1515658338-6781-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.01.2018 10:12, Gu Jinxiang wrote:
> populate_free_space_tree calls function btrfs_search_slot_for_read with
> parameter int find_higher = 1, it means that, if no exact match is found,
> then use the next higher item.
> So in function populate_free_space_tree, use READA_FORWARD to read
> forward ahead.
> 
> Changelog:
> v2->v1: change enum from READA_BACK to READA_FORWARD, since according
> to the logic of the source, it should reada_for_search forward, not
> backward.
> And, Reference:
> commit e4058b54d1e4 ("btrfs: cleanup, use enum values for btrfs_path reada")
> 
> v3->v2: add commit message to make it easy to understand. And split it
> to two patch.
> 
> Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/free-space-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index fe5e0324dca9..d7b6c0017143 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1071,7 +1071,7 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
> -	path->reada = 1;
> +	path->reada = READA_FORWARD;
>  
>  	path2 = btrfs_alloc_path();
>  	if (!path2) {
> 
