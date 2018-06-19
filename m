Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30701 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S937146AbeFSBQu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 21:16:50 -0400
Subject: Re: [PATCH] btrfs-progs: check: Fix wrong root parameter of
 btrfs_next_leaf call
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1529320239-23033-1-git-send-email-nborisov@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <370d9d94-7fe9-76c1-ac01-0a9d280e2f4c@cn.fujitsu.com>
Date: Tue, 19 Jun 2018 09:23:03 +0800
MIME-Version: 1.0
In-Reply-To: <1529320239-23033-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/18/2018 07:10 PM, Nikolay Borisov wrote:
> The first thing that check_chunks_and_extents does is to iterate all
> the root items in the root tree and link them to either the "normal_list"
> or "dropping_trees" list. If a leaf has to be crossed during this
> operation btrfs_next_leaf is called to do that. However, currently it's
> called with a wrong argument for its 'root' parameter. Since we are
> iterating the root tree the passed root should be fs_info->tree_rot,
> whereas right now we are passing the local variable 'root' which is
> assigned to the fs_tree. As it stands, this bug is actually benign since
> the passed root is only passed to reada_for_search, where it's used to
> reference the fs_info. Nevertheless the code is wrong and at the very least
> misleading, so fix it by passing the correct root.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   check/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 68da994f7ae0..a4d6855dccbf 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -8157,7 +8157,7 @@ static int check_chunks_and_extents(struct btrfs_fs_info *fs_info)
>   		leaf = path.nodes[0];
>   		slot = path.slots[0];
>   		if (slot >= btrfs_header_nritems(path.nodes[0])) {
> -			ret = btrfs_next_leaf(root, &path);
> +			ret = btrfs_next_leaf(fs_info->tree_root, &path);
>   			if (ret != 0)
>   				break;
>   			leaf = path.nodes[0];
> 


