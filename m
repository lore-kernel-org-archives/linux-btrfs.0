Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39757 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933375AbcGLPGF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 11:06:05 -0400
Subject: Re: [PATCH] Btrfs: fix panic in balance due to EIO
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1468283820-25471-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <855a29a1-1b46-c1be-418c-de08cb484bd7@fb.com>
Date: Tue, 12 Jul 2016 11:05:48 -0400
MIME-Version: 1.0
In-Reply-To: <1468283820-25471-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2016 08:37 PM, Liu Bo wrote:
> During build_backref_tree(), if we fail to read a btree node,
> we can eventually run into BUG_ON(cache->nr_nodes) that we put
> in backref_cache_cleanup(), meaning we have at least one
> memory leak.
>
> This frees the backref_node that we allocate at the very beginning of build_backref_tree().
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/relocation.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 0477dca..f00267a 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1135,6 +1135,8 @@ out:
>  	btrfs_free_path(path1);
>  	btrfs_free_path(path2);
>  	if (err) {
> +		int orig_free = 0;
> +
>  		while (!list_empty(&useless)) {
>  			lower = list_entry(useless.next,
>  					   struct backref_node, list);
> @@ -1171,8 +1173,13 @@ out:
>  			lower = list_entry(useless.next,
>  					   struct backref_node, list);
>  			list_del_init(&lower->list);
> +			if (lower == node)
> +				orig_free = 1;
>  			free_backref_node(cache, lower);
>  		}
> +
> +		if (!orig_free)
> +			free_backref_node(cache, node);
>  		return ERR_PTR(err);
>  	}
>  	ASSERT(!node || !node->detached);

Instead of doing the orig_free set and test

	...
	if (lower == node)
		node = NULL
	free_backref_node(cache, lower)
}
free_backref_node(cache, node);
return ERR_PTR(err);

Your patch isn't wrong, but having node NULL after it was free'd makes 
us less likely to make mistakes as the code changes.

-chris
