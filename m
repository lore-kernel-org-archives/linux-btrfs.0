Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64503 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751104AbdJUGQl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Oct 2017 02:16:41 -0400
Date: Sat, 21 Oct 2017 14:16:05 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove redundant btrfs_balance_delayed_items
Message-ID: <20171021061605.GA13657@fnst.localdomain>
References: <20171020235341.17019-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20171020235341.17019-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 05:53:41PM -0600, Liu Bo wrote:
>In functions like btrfs_create(), we run both
>btrfs_balance_delayed_items() and btrfs_btree_balance_dirty() after
>the operation, but btrfs_btree_balance_dirty() is surely going to run
>btrfs_balance_delayed_items().
>
>This keeps only btrfs_btree_balance_dirty().

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>
>Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>---
> fs/btrfs/inode.c | 5 -----
> 1 file changed, 5 deletions(-)
>
>diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>index 1bd9f01..da57b03 100644
>--- a/fs/btrfs/inode.c
>+++ b/fs/btrfs/inode.c
>@@ -6599,7 +6599,6 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
> 
> out_unlock:
> 	btrfs_end_transaction(trans);
>-	btrfs_balance_delayed_items(fs_info);
> 	btrfs_btree_balance_dirty(fs_info);
> 	if (drop_inode) {
> 		inode_dec_link_count(inode);
>@@ -6680,7 +6679,6 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
> 		inode_dec_link_count(inode);
> 		iput(inode);
> 	}
>-	btrfs_balance_delayed_items(fs_info);
> 	btrfs_btree_balance_dirty(fs_info);
> 	return err;
> 
>@@ -6755,7 +6753,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
> 		btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent);
> 	}
> 
>-	btrfs_balance_delayed_items(fs_info);
> fail:
> 	if (trans)
> 		btrfs_end_transaction(trans);
>@@ -6833,7 +6830,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
> 		inode_dec_link_count(inode);
> 		iput(inode);
> 	}
>-	btrfs_balance_delayed_items(fs_info);
> 	btrfs_btree_balance_dirty(fs_info);
> 	return err;
> 
>@@ -10757,7 +10753,6 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
> 	btrfs_end_transaction(trans);
> 	if (ret)
> 		iput(inode);
>-	btrfs_balance_delayed_items(fs_info);
> 	btrfs_btree_balance_dirty(fs_info);
> 	return ret;
> 
>-- 
>2.9.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


