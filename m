Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757097AbeEJN44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 09:56:56 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26240AB3D
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 13:56:55 +0000 (UTC)
Subject: Re: [PATCH v2 5/8] btrfs: Open-code add_delayed_data_ref
References: <1524579504-30304-1-git-send-email-nborisov@suse.com>
 <1524579504-30304-6-git-send-email-nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
To: David Sterba <dsterba@suse.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <354d74a1-e7cb-a233-a6b8-64022b61e067@suse.com>
Date: Thu, 10 May 2018 16:56:54 +0300
MIME-Version: 1.0
In-Reply-To: <1524579504-30304-6-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.04.2018 17:18, Nikolay Borisov wrote:
> Now that the initialization part and the critical section code have
> been split it's a lot easier to open code add_delayed_data_ref. Do
> so in the following manner:
> 
> 1. The common init function is put immediately after memory-to-be-init
> is allocated, followed by the specific data ref initialization.
> 
> 2. The only piece of code that remains in the critical section is
> insert_delayed_ref call.
> 
> 3. Tracing and memory freeing code is moved outside of the critical
> section.
> 
> No functional changes, just an overall shorter critical section.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/delayed-ref.c | 63 ++++++++++++++++++--------------------------------
>  1 file changed, 22 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 827ca01cf5af..2d1375739b3d 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -696,45 +696,6 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
>  }
>  
>  /*
> - * helper to insert a delayed data ref into the rbtree.
> - */
> -static noinline void
> -add_delayed_data_ref(struct btrfs_trans_handle *trans,
> -		     struct btrfs_delayed_ref_head *head_ref,
> -		     struct btrfs_delayed_ref_node *ref, u64 bytenr,
> -		     u64 num_bytes, u64 parent, u64 ref_root, u64 owner,
> -		     u64 offset, int action)
> -{
> -	struct btrfs_delayed_data_ref *full_ref;
> -	struct btrfs_delayed_ref_root *delayed_refs;
> -	u8 ref_type;
> -	int ret;
> -
> -
> -	delayed_refs = &trans->transaction->delayed_refs;
> -	full_ref = btrfs_delayed_node_to_data_ref(ref);
> -	if (parent)
> -	        ref_type = BTRFS_SHARED_DATA_REF_KEY;
> -	else
> -	        ref_type = BTRFS_EXTENT_DATA_REF_KEY;
> -
> -	init_delayed_ref_common(trans->fs_info, ref, bytenr, num_bytes,
> -				ref_root, action, ref_type);
> -	full_ref->root = ref_root;
> -	full_ref->parent = parent;
> -	full_ref->objectid = owner;
> -	full_ref->offset = offset;
> -
> -	trace_add_delayed_data_ref(trans->fs_info, ref, full_ref,
> -				   action == BTRFS_ADD_DELAYED_EXTENT ?
> -				   BTRFS_ADD_DELAYED_REF : action);
> -
> -	ret = insert_delayed_ref(trans, delayed_refs, head_ref, ref);
> -	if (ret > 0)
> -		kmem_cache_free(btrfs_delayed_data_ref_cachep, full_ref);
> -}
> -
> -/*
>   * add a delayed tree ref.  This does all of the accounting required
>   * to make sure the delayed ref is eventually processed before this
>   * transaction commits.
> @@ -834,11 +795,25 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  	struct btrfs_qgroup_extent_record *record = NULL;
>  	int qrecord_inserted;
> +	int ret;
> +	u8 ref_type;
>  
>  	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
>  	if (!ref)
>  		return -ENOMEM;
>  
> +	if (parent)
> +	        ref_type = BTRFS_SHARED_DATA_REF_KEY;
> +	else
> +	        ref_type = BTRFS_EXTENT_DATA_REF_KEY;

Argh, here the check style is different than in add_delayed_tree_ref...
I guess in the previous patch it makes sense to delete the check at the
definition of ref_type.
> +	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
> +				ref_root, action, ref_type);
> +	ref->root = ref_root;
> +	ref->parent = parent;
> +	ref->objectid = owner;
> +	ref->offset = offset;
> +
> +
>  	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
>  	if (!head_ref) {
>  		kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
> @@ -870,10 +845,16 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  					action, 1, 0, &qrecord_inserted,
>  					old_ref_mod, new_ref_mod);
>  
> -	add_delayed_data_ref(trans, head_ref, &ref->node, bytenr, num_bytes,
> -			     parent, ref_root, owner, offset, action);
> +	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
>  	spin_unlock(&delayed_refs->lock);
>  
> +	trace_add_delayed_data_ref(trans->fs_info, &ref->node, ref,
> +				   action == BTRFS_ADD_DELAYED_EXTENT ?
> +				   BTRFS_ADD_DELAYED_REF : action);
> +	if (ret > 0)
> +		kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
> +
> +
>  	if (qrecord_inserted)
>  		return btrfs_qgroup_trace_extent_post(fs_info, record);
>  	return 0;
> 
