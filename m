Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21234 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752101AbbHSHeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 03:34:07 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7J7Y04i022803
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 15:34:00 +0800
Subject: Re: [PATCH] Btrfs: cleanup: remove unnecessary check before
 btrfs_free_path is called
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <201508190555.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55D43169.3030008@cn.fujitsu.com>
Date: Wed, 19 Aug 2015 15:34:01 +0800
MIME-Version: 1.0
In-Reply-To: <201508190555.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Tsutomu Itoh wrote on 2015/08/19 14:55 +0900:
> We need not check path before btrfs_free_path() is called because
> path is checked in btrfs_free_path().
>
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

BTW, did you check btrfs-progs for the such cleanup?

Thanks,
Qu

> ---
>   fs/btrfs/dev-replace.c | 3 +--
>   fs/btrfs/inode.c       | 3 +--
>   fs/btrfs/tree-defrag.c | 3 +--
>   3 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 564a7de..e54dd59 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -183,8 +183,7 @@ no_valid_dev_replace_entry_found:
>   	}
>
>   out:
> -	if (path)
> -		btrfs_free_path(path);
> +	btrfs_free_path(path);
>   	return ret;
>   }
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e33dff3..21ba036 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6876,8 +6876,7 @@ out:
>
>   	trace_btrfs_get_extent(root, em);
>
> -	if (path)
> -		btrfs_free_path(path);
> +	btrfs_free_path(path);
>   	if (trans) {
>   		ret = btrfs_end_transaction(trans, root);
>   		if (!err)
> diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
> index a4b9c8b..f31db43 100644
> --- a/fs/btrfs/tree-defrag.c
> +++ b/fs/btrfs/tree-defrag.c
> @@ -115,8 +115,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
>   		ret = -EAGAIN;
>   	}
>   out:
> -	if (path)
> -		btrfs_free_path(path);
> +	btrfs_free_path(path);
>   	if (ret == -EAGAIN) {
>   		if (root->defrag_max.objectid > root->defrag_progress.objectid)
>   			goto done;
>
