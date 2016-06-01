Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbcFAWIw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 18:08:52 -0400
Date: Wed, 1 Jun 2016 15:08:50 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v10 09/21] btrfs: dedupe: Inband in-memory only
 de-duplication implement
Message-ID: <20160601220850.GO7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-10-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459492512-31435-10-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:35:00PM +0800, Qu Wenruo wrote:
> Core implement for inband de-duplication.
> It reuse the async_cow_start() facility to do the calculate dedupe hash.
> And use dedupe hash to do inband de-duplication at extent level.
> 
> The work flow is as below:
> 1) Run delalloc range for an inode
> 2) Calculate hash for the delalloc range at the unit of dedupe_bs
> 3) For hash match(duplicated) case, just increase source extent ref
>    and insert file extent.
>    For hash mismatch case, go through the normal cow_file_range()
>    fallback, and add hash into dedupe_tree.
>    Compress for hash miss case is not supported yet.
> 
> Current implement restore all dedupe hash in memory rb-tree, with LRU
> behavior to control the limit.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c |  18 ++++
>  fs/btrfs/inode.c       | 235 ++++++++++++++++++++++++++++++++++++++++++-------
>  fs/btrfs/relocation.c  |  16 ++++
>  3 files changed, 236 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 53e1297..dabd721 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -37,6 +37,7 @@
>  #include "math.h"
>  #include "sysfs.h"
>  #include "qgroup.h"
> +#include "dedupe.h"
>  
>  #undef SCRAMBLE_DELAYED_REFS
>  
> @@ -2399,6 +2400,8 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>  
>  	if (btrfs_delayed_ref_is_head(node)) {
>  		struct btrfs_delayed_ref_head *head;
> +		struct btrfs_fs_info *fs_info = root->fs_info;
> +
>  		/*
>  		 * we've hit the end of the chain and we were supposed
>  		 * to insert this extent into the tree.  But, it got
> @@ -2413,6 +2416,15 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>  			btrfs_pin_extent(root, node->bytenr,
>  					 node->num_bytes, 1);
>  			if (head->is_data) {
> +				/*
> +				 * If insert_reserved is given, it means
> +				 * a new extent is revered, then deleted
> +				 * in one tran, and inc/dec get merged to 0.
> +				 *
> +				 * In this case, we need to remove its dedup
> +				 * hash.
> +				 */
> +				btrfs_dedupe_del(trans, fs_info, node->bytenr);
>  				ret = btrfs_del_csums(trans, root,
>  						      node->bytenr,
>  						      node->num_bytes);
> @@ -6713,6 +6725,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		btrfs_release_path(path);
>  
>  		if (is_data) {
> +			ret = btrfs_dedupe_del(trans, info, bytenr);
> +			if (ret < 0) {
> +				btrfs_abort_transaction(trans, extent_root,
> +							ret);

I don't see why an error here should lead to a readonly fs.
	--Mark

--
Mark Fasheh
