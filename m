Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51511 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751042AbeAKHYI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:24:08 -0500
Subject: Re: [PATCH v2] btrfs: use enum instead of constant value
To: Gu Jinxiang <gujx@cn.fujitsu.com>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <20171205173546.GL3553@twin.jikos.cz>
 <1515653941-6378-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <69b34781-2275-ba9b-0df8-50f3c2752e45@suse.com>
Date: Thu, 11 Jan 2018 09:24:06 +0200
MIME-Version: 1.0
In-Reply-To: <1515653941-6378-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.01.2018 08:59, Gu Jinxiang wrote:
> Use enum READA_FORWARD instead of integers value to keep source robust.
> 
> Changelog:
> v2->v1: change enum from READA_BACK to READA_FORWARD, since according
> to the logic of the source, it should reada_for_search forward, not
> backward.
> And, Reference:
> commit e4058b54d1e4 ("btrfs: cleanup, use enum values for btrfs_path reada")
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

> ---
>  fs/btrfs/free-space-tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index fe5e0324dca9..af36a6a971fe 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1071,7 +1071,7 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
> -	path->reada = 1;
> +	path->reada = READA_FORWARD;


So in  btrfs_search_slot_for_read we can go either backwards to forward
based on the penultimate parameter (find_higher). We always pass that to
1 meaning we will be going iterating the leaves forward. In that regard
we do want READA_FORWARD. Perhaps you might want to put this explanation
in your commit message.


>  
>  	path2 = btrfs_alloc_path();
>  	if (!path2) {
> @@ -1573,7 +1573,7 @@ int load_free_space_tree(struct btrfs_caching_control *caching_ctl)
>  	 */
>  	path->skip_locking = 1;
>  	path->search_commit_root = 1;
> -	path->reada = 1;
> +	path->reada = READA_FORWARD;

Similar thing here. When we call load_free_space_bitmaps or
load_free_space_extents we would be calling btrfs_next_item so reading
forward makes sense.

>  
>  	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
>  	if (IS_ERR(info)) {
> 
