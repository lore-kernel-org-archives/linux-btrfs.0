Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753918AbeAKIOT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 03:14:19 -0500
Subject: Re: [PATCH v3 2/2] btrfs: use enum instead of constant value
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <69b34781-2275-ba9b-0df8-50f3c2752e45@suse.com>
 <1515658338-6781-1-git-send-email-gujx@cn.fujitsu.com>
 <1515658338-6781-2-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d12f8795-63dd-6d91-4a61-fb84bf1d7e77@suse.com>
Date: Thu, 11 Jan 2018 10:14:18 +0200
MIME-Version: 1.0
In-Reply-To: <1515658338-6781-2-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.01.2018 10:12, Gu Jinxiang wrote:
> From: Gu JinXiang <gujx@cn.fujitsu.com>
> 
> load_free_space_tree calls either function load_free_space_bitmaps or
> load_free_space_extents. And either of those two will lead to call
> btrfs_next_item.
> So in function load_free_space_tree, use READA_FORWARD to read forward
> ahead.
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
> index d7b6c0017143..af36a6a971fe 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1573,7 +1573,7 @@ int load_free_space_tree(struct btrfs_caching_control *caching_ctl)
>  	 */
>  	path->skip_locking = 1;
>  	path->search_commit_root = 1;
> -	path->reada = 1;
> +	path->reada = READA_FORWARD;
>  
>  	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
>  	if (IS_ERR(info)) {
> 
