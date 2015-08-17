Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45315 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbbHQDm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 23:42:58 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>, <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
References: <20150814092826.GA11685@mwanda>
In-Reply-To: <20150814092826.GA11685@mwanda>
Subject: RE: Btrfs: don't start the log transaction if the log tree init fails
Date: Mon, 17 Aug 2015 11:42:52 +0800
Message-ID: <000d01d0d89e$cc308a70$64919f50$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Dan Carpenter

Thanks for reporting this problem.
Keeping code in good logic can reduce bug and make it easy to maintenance.

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Dan Carpenter
> Sent: Friday, August 14, 2015 5:28 PM
> To: miaox@cn.fujitsu.com
> Cc: linux-btrfs@vger.kernel.org
> Subject: re: Btrfs: don't start the log transaction if the log tree init fails
> 
> Hello Miao Xie,
> 
> The patch e87ac1368700: "Btrfs: don't start the log transaction if the log tree
> init fails" from Feb 20, 2014, leads to the following static checker warning:
> 
> 	fs/btrfs/tree-log.c:178 start_log_trans()
> 	warn: we tested 'root->log_root' before and it was 'false'
> 
> fs/btrfs/tree-log.c
>    147          if (root->log_root) {
> 
> We test "root->log_root" here.
> 
>    148                  if (btrfs_need_log_full_commit(root->fs_info,
> trans)) {
>    149                          ret = -EAGAIN;
>    150                          goto out;
>    151                  }
>    152                  if (!root->log_start_pid) {
>    153                          root->log_start_pid = current->pid;
>    154
> clear_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
>    155                  } else if (root->log_start_pid != current->pid) {
>    156
> set_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
>    157                  }
>    158
>    159                  atomic_inc(&root->log_batch);
>    160                  atomic_inc(&root->log_writers);
>    161                  if (ctx) {
>    162                          index = root->log_transid % 2;
>    163                          list_add_tail(&ctx->list,
> &root->log_ctxs[index]);
>    164                          ctx->log_transid = root->log_transid;
>    165                  }
>    166                  mutex_unlock(&root->log_mutex);
>    167                  return 0;
>    168          }
>    169
>    170          ret = 0;
>    171          mutex_lock(&root->fs_info->tree_log_mutex);
>    172          if (!root->fs_info->log_root_tree)
>    173                  ret = btrfs_init_log_root_tree(trans,
> root->fs_info);
>    174          mutex_unlock(&root->fs_info->tree_log_mutex);
>    175          if (ret)
>    176                  goto out;
>    177
>    178          if (!root->log_root) {
> 
> Couldn't we just remove this condition here?  This is a new Smatch thing I am
> working on and I am investigating false positives.
> 
Above problem was introduced by commit: 7237f1833,
and this patch(e87ac1368700) make the problem easy to find out.

We can remove above condition to make code pass smatch checking,
but a better way is to do some cleanup to remove duplicated code
in above function.

I'll fix it.

Thanks
Zhaolei

>    179                  ret = btrfs_add_log_tree(trans, root);
>    180                  if (ret)
>    181                          goto out;
>    182          }
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

