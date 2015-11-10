Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47788 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbKJJIg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 04:08:36 -0500
Date: Tue, 10 Nov 2015 12:08:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: btrfs: add tracing for failed reservations
Message-ID: <20151110090827.GA2934@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ This is old.  I don't know why it's only complaining now. Anyway this
  looks like one of those rarely used code paths so it might be a real
  bug. ]

Hello Jeff Mahoney,

The patch cab45e22da48: "btrfs: add tracing for failed reservations"
from Oct 16, 2013, leads to the following static checker warning:

	fs/btrfs/extent-tree.c:4116 btrfs_alloc_data_chunk_ondemand()
	error: we previously assumed 'data_sinfo' could be null (see line 4016)

fs/btrfs/extent-tree.c
  4014  
  4015          data_sinfo = fs_info->data_sinfo;
  4016          if (!data_sinfo)
                    ^^^^^^^^^^^
Check for NULL.

  4017                  goto alloc;
  4018  
  4019  again:
  4020          /* make sure we have enough space to handle the data first */
  4021          spin_lock(&data_sinfo->lock);
  4022          used = data_sinfo->bytes_used + data_sinfo->bytes_reserved +
  4023                  data_sinfo->bytes_pinned + data_sinfo->bytes_readonly +
  4024                  data_sinfo->bytes_may_use;
  4025  
  4026          if (used + bytes > data_sinfo->total_bytes) {
  4027                  struct btrfs_trans_handle *trans;
  4028  
  4029                  /*
  4030                   * if we don't have enough free bytes in this space then we need
  4031                   * to alloc a new chunk.
  4032                   */
  4033                  if (!data_sinfo->full) {
  4034                          u64 alloc_target;
  4035  
  4036                          data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
  4037                          spin_unlock(&data_sinfo->lock);
  4038  alloc:

We jump to here.

  4039                          alloc_target = btrfs_get_alloc_profile(root, 1);
  4040                          /*
  4041                           * It is ugly that we don't call nolock join
  4042                           * transaction for the free space inode case here.
  4043                           * But it is safe because we only do the data space
  4044                           * reservation for the free space cache in the
  4045                           * transaction context, the common join transaction
  4046                           * just increase the counter of the current transaction
  4047                           * handler, doesn't try to acquire the trans_lock of
  4048                           * the fs.
  4049                           */
  4050                          trans = btrfs_join_transaction(root);
  4051                          if (IS_ERR(trans))
  4052                                  return PTR_ERR(trans);
  4053  
  4054                          ret = do_chunk_alloc(trans, root->fs_info->extent_root,
  4055                                               alloc_target,
  4056                                               CHUNK_ALLOC_NO_FORCE);
  4057                          btrfs_end_transaction(trans, root);
  4058                          if (ret < 0) {
  4059                                  if (ret != -ENOSPC)
  4060                                          return ret;
  4061                                  else {
  4062                                          have_pinned_space = 1;
  4063                                          goto commit_trans;

The btrfs_end_transaction() call fails.

  4064                                  }
  4065                          }
  4066  
  4067                          if (!data_sinfo)
  4068                                  data_sinfo = fs_info->data_sinfo;
  4069  
  4070                          goto again;
  4071                  }
  4072  
  4073                  /*
  4074                   * If we don't have enough pinned space to deal with this
  4075                   * allocation, and no removed chunk in current transaction,
  4076                   * don't bother committing the transaction.
  4077                   */
  4078                  have_pinned_space = percpu_counter_compare(
  4079                          &data_sinfo->total_bytes_pinned,
  4080                          used + bytes - data_sinfo->total_bytes);
  4081                  spin_unlock(&data_sinfo->lock);
  4082  
  4083                  /* commit the current transaction and try again */
  4084  commit_trans:

We jump to here.

  4085                  if (need_commit &&
  4086                      !atomic_read(&root->fs_info->open_ioctl_trans)) {
  4087                          need_commit--;
  4088  
  4089                          if (need_commit > 0)
  4090                                  btrfs_wait_ordered_roots(fs_info, -1);
  4091  
  4092                          trans = btrfs_join_transaction(root);
  4093                          if (IS_ERR(trans))
  4094                                  return PTR_ERR(trans);
  4095                          if (have_pinned_space >= 0 ||
  4096                              test_bit(BTRFS_TRANS_HAVE_FREE_BGS,
  4097                                       &trans->transaction->flags) ||
  4098                              need_commit > 0) {
  4099                                  ret = btrfs_commit_transaction(trans, root);
  4100                                  if (ret)
  4101                                          return ret;
  4102                                  /*
  4103                                   * make sure that all running delayed iput are
  4104                                   * done
  4105                                   */
  4106                                  down_write(&root->fs_info->delayed_iput_sem);
  4107                                  up_write(&root->fs_info->delayed_iput_sem);
  4108                                  goto again;
  4109                          } else {
  4110                                  btrfs_end_transaction(trans, root);
  4111                          }
  4112                  }
  4113  
  4114                  trace_btrfs_space_reservation(root->fs_info,
  4115                                                "space_info:enospc",
  4116                                                data_sinfo->flags, bytes, 1);
                                                      ^^^^^^^^^^^^^^^^^
Potential NULL deref.

  4117                  return -ENOSPC;

regards,
dan carpenter
