Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45380 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaLQJOJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 04:14:09 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 776913EE190
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 18:14:07 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 7C4FEAC06F8
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 18:14:06 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 29800E08005
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 18:14:06 +0900 (JST)
Message-ID: <54914953.7000508@jp.fujitsu.com>
Date: Wed, 17 Dec 2014 18:13:55 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: cleanup unused run_most
References: <1418804049-11323-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1418804049-11323-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/12/17 17:14), Liu Bo wrote:
> "run_most" is not used anymore.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> ---
>   fs/btrfs/extent-tree.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 222d6ae..4f54c30 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2768,7 +2768,6 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>   	struct btrfs_delayed_ref_head *head;
>   	int ret;
>   	int run_all = count == (unsigned long)-1;
> -	int run_most = 0;
>   
>   	/* We'll clean this up in btrfs_cleanup_transaction */
>   	if (trans->aborted)
> @@ -2778,10 +2777,8 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>   		root = root->fs_info->tree_root;
>   
>   	delayed_refs = &trans->transaction->delayed_refs;
> -	if (count == 0) {
> +	if (count == 0)
>   		count = atomic_read(&delayed_refs->num_entries) * 2;
> -		run_most = 1;
> -	}
>   
>   again:
>   #ifdef SCRAMBLE_DELAYED_REFS
> 

