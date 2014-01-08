Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880AbaAHOd3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 09:33:29 -0500
Date: Wed, 8 Jan 2014 15:33:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: rework qgroup accounting
Message-ID: <20140108143327.GG6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1387400849-7274-1-git-send-email-jbacik@fb.com>
 <1387400849-7274-3-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387400849-7274-3-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 18, 2013 at 04:07:28PM -0500, Josef Bacik wrote:
>  /*
> - * btrfs_qgroup_record_ref is called when the ref is added or deleted. it puts
> - * the modification into a list that's later used by btrfs_end_transaction to
> - * pass the recorded modifications on to btrfs_qgroup_account_ref.
> + * Record a quota operation for processing later on.
> + * @trans: the transaction we are adding the delayed op to.
> + * @fs_info: the fs_info for this fs.
> + * @ref_root: the root of the reference we are acting on,
> + * @num_bytes: the number of bytes in the reference.
> + * @parent: if we are removing a shared ref then this will be set.
> + * @type: the type of operation this is.
> + *
> + * We just add it to our trans qgroup_ref_list and carry on and process these
> + * operations in order at some later point.  If the reference root isn't a fs
> + * root then we don't bother with doing anything.
> + *
> + * MUST BE HOLDING THE REF LOCK.
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

>   */
>  int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
> -			    struct btrfs_delayed_ref_node *node,
> -			    struct btrfs_delayed_extent_op *extent_op)
> +			    struct btrfs_fs_info *fs_info, u64 ref_root,
> +			    u64 bytenr, u64 num_bytes, u64 parent,
> +			    enum btrfs_qgroup_operation_type type)
>  {
> -	struct qgroup_update *u;
> +	struct btrfs_qgroup_operation *oper;
> +	int ret;
>  
> -	BUG_ON(!trans->delayed_ref_elem.seq);
> -	u = kmalloc(sizeof(*u), GFP_NOFS);
> -	if (!u)
> +	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
> +		return 0;
> +
> +	oper = kmalloc(sizeof(*oper), GFP_NOFS);

Must use GFP_ATOMIC then, ohterwise spits some warnings:

BUG: sleeping function called from invalid context at mm/slab.c:2923
[ 5845.017803]  [<ffffffff819ce6c3>] dump_stack+0x51/0x6e
[ 5845.017811]  [<ffffffff8108285a>] __might_sleep+0xda/0x100
[ 5845.017816]  [<ffffffff81159699>] kmem_cache_alloc_trace+0xd9/0x1f0
[ 5845.017854]  [<ffffffffa01a6f89>] btrfs_qgroup_record_ref+0x89/0x310 [btrfs]
[ 5845.017872]  [<ffffffffa0125a98>] __btrfs_inc_extent_ref+0x328/0x570 [btrfs]
...

> +/*
> + * Record a shared ref in the most recent qgroup operation added.
> + * @trans: the trans handle for this operation.
> + * @ref_root: the ref_root this operation was for, this is to make sure we
> + * actually need to do anything at all.  Use the same ref_root we called
> + * btrfs_qgroup_record_ref with.
> + * @parent: the parent of the shared ref.
> + *
> + * This is meant to be called directly after calling btrfs_qgroup_record_ref
> + * for the ref we care about, it does no searching to make sure we're on the
> + * right qgroup operation.
> + *
> + * MUST BE HOLDING THE REF LOCK.
> + */
> +int btrfs_qgroup_add_shared_ref(struct btrfs_trans_handle *trans, u64 ref_root,
> +				u64 parent)
> +{
> +	struct qgroup_shared_ref *ref;
> +	struct btrfs_qgroup_operation *oper;
> +	int ret = 0;
> +
> +	if (!is_fstree(ref_root))
> +		return 0;
> +	ref = kmalloc(sizeof(*ref), GFP_NOFS);

same here

> +	if (!ref)
> +		return -ENOMEM;
> +	ref->parent = parent;
> +	ref->ref_root = 0;
> +	ASSERT(!list_empty(&trans->qgroup_ref_list));
> +	oper = list_entry(trans->qgroup_ref_list.prev,
> +			  struct btrfs_qgroup_operation, list);
> +	list_add_tail(&ref->list, &oper->shared_refs);
> +	return ret;
> +}
