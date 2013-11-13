Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22937 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab3KMUBp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 15:01:45 -0500
Date: Wed, 13 Nov 2013 23:01:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: btrfs: add tracing for failed reservations
Message-ID: <20131113200130.GA6261@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jeff Mahoney,

This is a semi-automatic email about new static checker warnings.

The patch cab45e22da48: "btrfs: add tracing for failed reservations" 
from Oct 16, 2013, leads to the following Smatch complaint:

fs/btrfs/extent-tree.c:3710 btrfs_check_data_free_space()
	 error: we previously assumed 'data_sinfo' could be null (see line 3629)

fs/btrfs/extent-tree.c
  3628		data_sinfo = fs_info->data_sinfo;
  3629		if (!data_sinfo)
                    ^^^^^^^^^^^
Existing check.

  3630			goto alloc;
  3631	
  3632	again:
  3633		/* make sure we have enough space to handle the data first */
  3634		spin_lock(&data_sinfo->lock);
  3635		used = data_sinfo->bytes_used + data_sinfo->bytes_reserved +
  3636			data_sinfo->bytes_pinned + data_sinfo->bytes_readonly +
  3637			data_sinfo->bytes_may_use;
  3638	
  3639		if (used + bytes > data_sinfo->total_bytes) {
  3640			struct btrfs_trans_handle *trans;
  3641	
  3642			/*
  3643			 * if we don't have enough free bytes in this space then we need
  3644			 * to alloc a new chunk.
  3645			 */
  3646			if (!data_sinfo->full && alloc_chunk) {
  3647				u64 alloc_target;
  3648	
  3649				data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
  3650				spin_unlock(&data_sinfo->lock);
  3651	alloc:
  3652				alloc_target = btrfs_get_alloc_profile(root, 1);
  3653				/*
  3654				 * It is ugly that we don't call nolock join
  3655				 * transaction for the free space inode case here.
  3656				 * But it is safe because we only do the data space
  3657				 * reservation for the free space cache in the
  3658				 * transaction context, the common join transaction
  3659				 * just increase the counter of the current transaction
  3660				 * handler, doesn't try to acquire the trans_lock of
  3661				 * the fs.
  3662				 */
  3663				trans = btrfs_join_transaction(root);
  3664				if (IS_ERR(trans))
  3665					return PTR_ERR(trans);
  3666	
  3667				ret = do_chunk_alloc(trans, root->fs_info->extent_root,
  3668						     alloc_target,
  3669						     CHUNK_ALLOC_NO_FORCE);
  3670				btrfs_end_transaction(trans, root);
  3671				if (ret < 0) {
  3672					if (ret != -ENOSPC)
  3673						return ret;
  3674					else
  3675						goto commit_trans;
                                                ^^^^^^^^^^^^^^^^^
Imagine we hit this goto and data_sinfo is NULL.

  3676				}
  3677	
  3678				if (!data_sinfo)
  3679					data_sinfo = fs_info->data_sinfo;
  3680	
  3681				goto again;
  3682			}
  3683	
  3684			/*
  3685			 * If we don't have enough pinned space to deal with this
  3686			 * allocation don't bother committing the transaction.
  3687			 */
  3688			if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
  3689						   bytes) < 0)
  3690				committed = 1;
  3691			spin_unlock(&data_sinfo->lock);
  3692	
  3693			/* commit the current transaction and try again */
  3694	commit_trans:
  3695			if (!committed &&
  3696			    !atomic_read(&root->fs_info->open_ioctl_trans)) {
  3697				committed = 1;
  3698	
  3699				trans = btrfs_join_transaction(root);
  3700				if (IS_ERR(trans))
  3701					return PTR_ERR(trans);
  3702				ret = btrfs_commit_transaction(trans, root);
  3703				if (ret)
  3704					return ret;
  3705				goto again;
  3706			}
  3707	
  3708			trace_btrfs_space_reservation(root->fs_info,
  3709						      "space_info:enospc",
  3710						      data_sinfo->flags, bytes, 1);
                                                      ^^^^^^^^^^^^^^^^^
Patch introduces an unchecked dereference.

  3711			return -ENOSPC;
  3712		}

regards,
dan carpenter
