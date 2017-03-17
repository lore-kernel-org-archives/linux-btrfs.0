Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42365 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753522AbdCQA4M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 20:56:12 -0400
Subject: Re: [PATCH v2 2/2] btrfs: replace hardcoded value with SEQ_LAST macro
To: <ednadolski@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Edmund Nadolski <enadolski@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <08ff8cd1-d463-635c-19f3-731af9b83684@cn.fujitsu.com>
Date: Fri, 17 Mar 2017 08:56:02 +0800
MIME-Version: 1.0
In-Reply-To: <20170316160434.8126-3-enadolski@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170316160434.8126-1-enadolski@suse.com>
 <20170316160434.8126-3-enadolski@suse.com>



At 03/17/2017 12:04 AM, ednadolski@gmail.com wrote:
> From: Edmund Nadolski <enadolski@suse.com>
>
> Define the SEQ_LAST macro to replace (u64)-1 in places where said
> value triggers a special-case ref search behavior.
>
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> Reviewed-by: Jeff Mahoney <jeffm@suse.com>

Looks good to me.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> ---
>  fs/btrfs/backref.c | 16 ++++++++--------
>  fs/btrfs/ctree.h   |  2 ++
>  fs/btrfs/qgroup.c  |  4 ++--
>  3 files changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 6ce7281..24865da 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -538,7 +538,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
>  	 * slot==nritems. In that case, go to the next leaf before we continue.
>  	 */
>  	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
> -		if (time_seq == (u64)-1)
> +		if (time_seq == SEQ_LAST)
>  			ret = btrfs_next_leaf(root, path);
>  		else
>  			ret = btrfs_next_old_leaf(root, path, time_seq);
> @@ -582,7 +582,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
>  			eie = NULL;
>  		}
>  next:
> -		if (time_seq == (u64)-1)
> +		if (time_seq == SEQ_LAST)
>  			ret = btrfs_next_item(root, path);
>  		else
>  			ret = btrfs_next_old_item(root, path, time_seq);
> @@ -634,7 +634,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
>
>  	if (path->search_commit_root)
>  		root_level = btrfs_header_level(root->commit_root);
> -	else if (time_seq == (u64)-1)
> +	else if (time_seq == SEQ_LAST)
>  		root_level = btrfs_header_level(root->node);
>  	else
>  		root_level = btrfs_old_root_level(root, time_seq);
> @@ -645,7 +645,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
>  	}
>
>  	path->lowest_level = level;
> -	if (time_seq == (u64)-1)
> +	if (time_seq == SEQ_LAST)
>  		ret = btrfs_search_slot(NULL, root, &ref->key_for_search, path,
>  					0, 0);
>  	else
> @@ -1199,7 +1199,7 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
>   *
>   * NOTE: This can return values > 0
>   *
> - * If time_seq is set to (u64)-1, it will not search delayed_refs, and behave
> + * If time_seq is set to SEQ_LAST, it will not search delayed_refs, and behave
>   * much like trans == NULL case, the difference only lies in it will not
>   * commit root.
>   * The special case is for qgroup to search roots in commit_transaction().
> @@ -1246,7 +1246,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
>  		path->skip_locking = 1;
>  	}
>
> -	if (time_seq == (u64)-1)
> +	if (time_seq == SEQ_LAST)
>  		path->skip_locking = 1;
>
>  	/*
> @@ -1276,9 +1276,9 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
>
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>  	if (trans && likely(trans->type != __TRANS_DUMMY) &&
> -	    time_seq != (u64)-1) {
> +	    time_seq != SEQ_LAST) {
>  #else
> -	if (trans && time_seq != (u64)-1) {
> +	if (trans && time_seq != SEQ_LAST) {
>  #endif
>  		/*
>  		 * look if there are updates for this ref queued and lock the
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 5da1385..19f6316 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -659,6 +659,8 @@ struct seq_list {
>
>  #define SEQ_LIST_INIT(name)	{ .list = LIST_HEAD_INIT((name).list), .seq = 0 }
>
> +#define SEQ_LAST	((u64)-1)
> +
>  enum btrfs_orphan_cleanup_state {
>  	ORPHAN_CLEANUP_STARTED	= 1,
>  	ORPHAN_CLEANUP_DONE	= 2,
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index b1b691e..2ced786 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2031,12 +2031,12 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
>  					goto cleanup;
>  			}
>  			/*
> -			 * Use (u64)-1 as time_seq to do special search, which
> +			 * Use SEQ_LAST as time_seq to do special search, which
>  			 * doesn't lock tree or delayed_refs and search current
>  			 * root. It's safe inside commit_transaction().
>  			 */
>  			ret = btrfs_find_all_roots(trans, fs_info,
> -					record->bytenr, (u64)-1, &new_roots);
> +					record->bytenr, SEQ_LAST, &new_roots);
>  			if (ret < 0)
>  				goto cleanup;
>  			if (qgroup_to_skip) {
>


