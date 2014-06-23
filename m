Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbaFWOtP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 10:49:15 -0400
Date: Mon, 23 Jun 2014 16:49:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: Re: btrfs: qgroup: account shared subtrees during snapshot delete
Message-ID: <20140623144913.GI1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403214567-3137-1-git-send-email-mfasheh@suse.de>
 <1403214567-3137-3-git-send-email-mfasheh@suse.de>
 <53A36348.4010106@fb.com>
 <20140619231626.GQ5484@wotan.suse.de>
 <53A36F85.60607@fb.com>
 <20140620112534.GB1553@twin.jikos.cz>
 <20140620152958.GR5484@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140620152958.GR5484@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 20, 2014 at 08:29:58AM -0700, Mark Fasheh wrote:
> +static int account_shared_subtree(struct btrfs_trans_handle *trans,
> +				  struct btrfs_root *root,
> +				  struct extent_buffer *root_eb,
> +				  u64 root_gen,
> +				  int root_level)
> +{
> +	int ret;
> +	int level;
> +	struct extent_buffer *eb = root_eb;
> +	struct btrfs_path *path = NULL;
> +
> +	BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);
> +	BUG_ON(root_eb == NULL);

The caller is ready for errors, can you please turn these to ane EIO?
(Separate patch is fine)

> +static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
> +				     struct btrfs_fs_info *fs_info,
> +				     struct btrfs_qgroup_operation *oper)
> +{
> +	struct ulist *roots = NULL;
> +	struct ulist_node *unode;
> +	struct ulist_iterator uiter;
> +	struct btrfs_qgroup_list *glist;
> +	struct ulist *parents;
> +	int ret = 0;
> +	struct btrfs_qgroup *qg;
> +	u64 root_obj = 0;
> +	struct seq_list elem = {};
> +
> +	parents = ulist_alloc(GFP_NOFS);
> +	if (!parents)
> +		return -ENOMEM;
> +
> +	btrfs_get_tree_mod_seq(fs_info, &elem);
> +	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr,
> +				   elem.seq, &roots);
> +	btrfs_put_tree_mod_seq(fs_info, &elem);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (roots->nnodes != 1)
> +		goto out;
> +
> +	ULIST_ITER_INIT(&uiter);
> +	unode = ulist_next(roots, &uiter); /* Only want 1 so no need to loop */
> +	/*
> +	 * If we find our ref root then that means all refs
> +	 * this extent has to the root have not yet been
> +	 * deleted. In that case, we do nothing and let the
> +	 * last ref for this bytenr drive our update.
> +	 *
> +	 * This can happen for example if an extent is
> +	 * referenced multiple times in a snapshot (clone,
> +	 * etc). If we are in the middle of snapshot removal,
> +	 * queued updates for such an extent will find the
> +	 * root if we have not yet finished removing the
> +	 * snapshot.
> +	 */
> +	if (unode->val == oper->ref_root)
> +		goto out;
> +
> +	root_obj = unode->val;
> +	BUG_ON(!root_obj);

Same here, although when called through btrfs_qgroup_account, the error
code is not properly checked in btrfs_delayed_qgroup_accounting, line 1944:

1933 int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
1934                                     struct btrfs_fs_info *fs_info)
1935 {
1936         struct btrfs_qgroup_operation *oper;
1937         int ret = 0;
1938
1939         while (!list_empty(&trans->qgroup_ref_list)) {
1940                 oper = list_first_entry(&trans->qgroup_ref_list,
1941                                         struct btrfs_qgroup_operation, list);
1942                 list_del_init(&oper->list);
1943                 if (!ret || !trans->aborted)
1944                         ret = btrfs_qgroup_account(trans, fs_info, oper);
1945                 spin_lock(&fs_info->qgroup_op_lock);
1946                 rb_erase(&oper->n, &fs_info->qgroup_op_tree);
1947                 spin_unlock(&fs_info->qgroup_op_lock);
1948                 btrfs_put_tree_mod_seq(fs_info, &oper->elem);
1949                 kfree(oper);
1950         }
1951         return ret;
1952 }
