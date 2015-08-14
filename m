Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42879 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbbHNJ2h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 05:28:37 -0400
Date: Fri, 14 Aug 2015 12:28:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: miaox@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: don't start the log transaction if the log tree init fails
Message-ID: <20150814092826.GA11685@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Miao Xie,

The patch e87ac1368700: "Btrfs: don't start the log transaction if
the log tree init fails" from Feb 20, 2014, leads to the following
static checker warning:

	fs/btrfs/tree-log.c:178 start_log_trans()
	warn: we tested 'root->log_root' before and it was 'false'

fs/btrfs/tree-log.c
   147          if (root->log_root) {

We test "root->log_root" here.

   148                  if (btrfs_need_log_full_commit(root->fs_info, trans)) {
   149                          ret = -EAGAIN;
   150                          goto out;
   151                  }
   152                  if (!root->log_start_pid) {
   153                          root->log_start_pid = current->pid;
   154                          clear_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
   155                  } else if (root->log_start_pid != current->pid) {
   156                          set_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
   157                  }
   158  
   159                  atomic_inc(&root->log_batch);
   160                  atomic_inc(&root->log_writers);
   161                  if (ctx) {
   162                          index = root->log_transid % 2;
   163                          list_add_tail(&ctx->list, &root->log_ctxs[index]);
   164                          ctx->log_transid = root->log_transid;
   165                  }
   166                  mutex_unlock(&root->log_mutex);
   167                  return 0;
   168          }
   169  
   170          ret = 0;
   171          mutex_lock(&root->fs_info->tree_log_mutex);
   172          if (!root->fs_info->log_root_tree)
   173                  ret = btrfs_init_log_root_tree(trans, root->fs_info);
   174          mutex_unlock(&root->fs_info->tree_log_mutex);
   175          if (ret)
   176                  goto out;
   177  
   178          if (!root->log_root) {

Couldn't we just remove this condition here?  This is a new Smatch thing
I am working on and I am investigating false positives.

   179                  ret = btrfs_add_log_tree(trans, root);
   180                  if (ret)
   181                          goto out;
   182          }

regards,
dan carpenter
