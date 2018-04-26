Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49129 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750760AbeDZE5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 00:57:19 -0400
Subject: Re: [PATCH v2] Btrfs: set keep_lock when necessary in
 btrfs_defrag_leaves
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9c537604-700c-1419-e113-1d4de6617f07@suse.com>
Date: Thu, 26 Apr 2018 07:57:16 +0300
MIME-Version: 1.0
In-Reply-To: <1524706063-93210-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1524706063-93210-1-git-send-email-bo.liu@linux.alibaba.com>



On 26.04.2018 04:27, Liu Bo wrote:
> path->keep_lock may force to lock tree root and higher nodes, and make
> lock contention worse, thus it needs to be avoided as much as
> possible.
> 
> In btrfs_degrag_leaves, path->keep_lock is set but @path immediatley
> gets released, which is not necessary at all.
> 

This is still very terse and still doesn't explain why keep_locks should
be set right before btrfs_search_slot and not the beginning of the
function. "when necessary" is perhaps the second most uninformative
reason of doing something, right after "because of reasons"
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
> v2: update commit log with more details.
> 
>  fs/btrfs/tree-defrag.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
> index 3c0987ab587d..c12747904d4c 100644
> --- a/fs/btrfs/tree-defrag.c
> +++ b/fs/btrfs/tree-defrag.c
> @@ -65,8 +65,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
>  		memcpy(&key, &root->defrag_progress, sizeof(key));
>  	}
>  
> -	path->keep_locks = 1;
> -
>  	ret = btrfs_search_forward(root, &key, path, BTRFS_OLDEST_GENERATION);
>  	if (ret < 0)
>  		goto out;
> @@ -81,6 +79,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
>  	 * a deadlock (attempting to write lock an already write locked leaf).
>  	 */
>  	path->lowest_level = 1;
> +	path->keep_locks = 1;
>  	wret = btrfs_search_slot(trans, root, &key, path, 0, 1);
>  
>  	if (wret < 0) {
> 
