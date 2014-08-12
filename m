Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44987 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087AbaHLSWm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 14:22:42 -0400
Message-ID: <53EA5B67.7040109@fb.com>
Date: Tue, 12 Aug 2014 14:22:31 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>, <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/5] btrfs: qgroup: account shared subtrees during snapshot
 delete
References: <1405625944-4883-1-git-send-email-mfasheh@suse.de> <1405625944-4883-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1405625944-4883-3-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/17/2014 03:39 PM, Mark Fasheh wrote:
> During its tree walk, btrfs_drop_snapshot() will skip any shared
> subtrees it encounters. This is incorrect when we have qgroups
> turned on as those subtrees need to have their contents
> accounted. In particular, the case we're concerned with is when
> removing our snapshot root leaves the subtree with only one root
> reference.
> 
> In those cases we need to find the last remaining root and add
> each extent in the subtree to the corresponding qgroup exclusive
> counts.
> 
> This patch implements the shared subtree walk and a new qgroup
> operation, BTRFS_QGROUP_OPER_SUB_SUBTREE. When an operation of
> this type is encountered during qgroup accounting, we search for
> any root references to that extent and in the case that we find
> only one reference left, we go ahead and do the math on it's
> exclusive counts.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 813537f..1aa4325 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8078,6 +8331,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>  	}
>  	root_dropped = true;
>  out_end_trans:
> +	ret = btrfs_delayed_qgroup_accounting(trans, root->fs_info);
                                                     ^^^^^^^^^^^

CONFIG_DEBUG_PAGEALLOC noticed that root is already free at this point.
 I switched it to tree_root instead ;)

-chris
