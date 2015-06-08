Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50539 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751319AbbFHBEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jun 2015 21:04:31 -0400
Message-ID: <5574EA1B.2070404@cn.fujitsu.com>
Date: Mon, 8 Jun 2015 09:04:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <jmaggard10@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Fix inverted no_quota logic
References: <1433545649-6134-1-git-send-email-jmaggard10@gmail.com>
In-Reply-To: <1433545649-6134-1-git-send-email-jmaggard10@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, thanks for your patch.

But Fujitsu may push a huge quota related rework patchset and makes it
no longer need to account quota at delayed-ref time.

So I'm afraid this patch with the next patch is not needed.

Thanks,
Qu

-------- Original Message  --------
Subject: [PATCH] Btrfs: Fix inverted no_quota logic
From: <jmaggard10@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年06月06日 07:07

> From: Justin Maggard <jmaggard10@gmail.com>
>
> Both btrfs_add_delayed_tree_ref() and
> btrfs_add_delayed_data_ref() have inverted logic when
> setting the no_quota value for delayed refs.  This is
> eventually double-checked in __btrfs_inc_extent_ref() and
> __btrfs_free_extent(), but not alloc_reserved_tree_block(),
> so it can throw off qgroup accounting.
>
> Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
> ---
>   fs/btrfs/delayed-ref.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 8f8ed7d..b0ff795 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -792,7 +792,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>   	struct btrfs_delayed_ref_root *delayed_refs;
>
>   	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
> -		no_quota = 0;
> +		no_quota = 1;
>
>   	BUG_ON(extent_op && extent_op->is_data);
>   	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
> @@ -841,7 +841,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>   	struct btrfs_delayed_ref_root *delayed_refs;
>
>   	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
> -		no_quota = 0;
> +		no_quota = 1;
>
>   	BUG_ON(extent_op && !extent_op->is_data);
>   	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
>
