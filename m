Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S968013AbeF1TDl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 15:03:41 -0400
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
 <bceb24d5-fa2f-b019-fc60-146fa7a62844@gmx.com>
 <9f158a77-fb11-1b77-d67a-e64f42e67e51@jp.fujitsu.com>
 <fd81f784-4c2e-5911-421a-39738c99177f@gmx.com>
 <50806075-6faa-db22-1508-450c5d5b6e34@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <80e72414-325c-61f1-a466-d5aaafe2a65b@suse.com>
Date: Thu, 28 Jun 2018 11:32:02 +0300
MIME-Version: 1.0
In-Reply-To: <50806075-6faa-db22-1508-450c5d5b6e34@jp.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------1DF9D428F5983A66BC43D841"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1DF9D428F5983A66BC43D841
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit



On 28.06.2018 11:10, Misono Tomohiro wrote:
> On 2018/06/28 16:12, Qu Wenruo wrote:
>>
>>
>> On 2018年06月27日 16:25, Misono Tomohiro wrote:
>>> On 2018/06/27 17:10, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018年06月26日 14:00, Misono Tomohiro wrote:
>>>>> Hello Nikolay,
>>>>>
>>>>> I noticed that commit 5d23515be669 ("btrfs: Move qgroup rescan
>>>>> on quota enable to btrfs_quota_enable") in 4.17 sometimes causes
>>>>> to fail correctly rescanning quota when quota is enabled.
>>>>>
>>>>> Simple reproducer:
>>>>>
>>>>> $ mkfs.btrfs -f $DEV
>>>>> $ mount $DEV /mnt
>>>>> $ dd if=/dev/urandom of=/mnt/file bs=1000 count=1000
>>>>> $ btrfs quota enbale /mnt
>>>>> $ umount /mnt
>>>>> $ btrfs check $DEV
>>>>> ...
>> Unfortunately in my environment, btrfs/114 failed to reprocduce it with
>> 1024 runs overnight, with v4.18-rc1 kernel.
>>
>> Would you please provide the whole btrfs-image dump of the corrupted fs?
> 
> Yes.
> The attached file is an image-dump of above reproducer (kernel 4.17.0, progs 4.17)
> as the dump of btrfs/114 is a bit large for mail.
> 
> Though this does not always happen, I see the failure both on 4.17.0 or 4.18-rc2.
> 
> Thanks,
> Tomohiro Misono

Misono,

Can you please try the attached patch?

> 
>>
>> There are several different assumptions on how the bug happens, with
>> your btrfs-image dump, it would help a lot to rule out some assumption.
>>
>> Thanks,
>> Qu

--------------1DF9D428F5983A66BC43D841
Content-Type: text/x-patch;
 name="0001-btrfs-qgroups-Move-transaction-managed-inside-btrfs_.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-btrfs-qgroups-Move-transaction-managed-inside-btrfs_.pa";
 filename*1="tch"

>From 10345e21bc2b4e61644da6b76ee4528710b2be25 Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Tue, 26 Jun 2018 10:03:58 +0300
Subject: [PATCH] btrfs: qgroups: Move transaction managed inside
 btrfs_quota_enable/disable

Commit 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to
btrfs_quota_enable") not only resulted in an easier to follow code but
it also introduced a subtle bug. It changed the timing when the initial
transaction rescan was happening - before the commit it would happen
after transaction commit had occured but after the commit it might happen
before the transaction was committed. This results in failure to
correctly rescan the quota since there could be data which is still not
committed on disk.

This patch aims to fix this by movign the transaction creation/commit
inside btrfs_quota_enable, which allows to schedule the quota commit
after the transaction has been committed. For the sake of symmetry this patch 
also moves the transaction logic inside btrfs_quota_disable

Fixes: 5d23515be669 ("btrfs: Move qgroup rescan on quota enable to btrfs_quota_enable")
Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Link: https://marc.info/?l=linux-btrfs&m=152999289017582
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c  | 15 ++-------------
 fs/btrfs/qgroup.c | 38 +++++++++++++++++++++++++++++++-------
 fs/btrfs/qgroup.h |  6 ++----
 3 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a399750b9e41..316fb1af15e2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5135,9 +5135,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ioctl_quota_ctl_args *sa;
-	struct btrfs_trans_handle *trans = NULL;
 	int ret;
-	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -5153,28 +5151,19 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	}
 
 	down_write(&fs_info->subvol_sem);
-	trans = btrfs_start_transaction(fs_info->tree_root, 2);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		goto out;
-	}
 
 	switch (sa->cmd) {
 	case BTRFS_QUOTA_CTL_ENABLE:
-		ret = btrfs_quota_enable(trans, fs_info);
+		ret = btrfs_quota_enable(fs_info);
 		break;
 	case BTRFS_QUOTA_CTL_DISABLE:
-		ret = btrfs_quota_disable(trans, fs_info);
+		ret = btrfs_quota_disable(fs_info);
 		break;
 	default:
 		ret = -EINVAL;
 		break;
 	}
 
-	err = btrfs_commit_transaction(trans);
-	if (err && !ret)
-		ret = err;
-out:
 	kfree(sa);
 	up_write(&fs_info->subvol_sem);
 drop_write:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1874a6d2e6f5..1d84af0d053f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -875,8 +875,7 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_quota_enable(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info)
+int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_root *tree_root = fs_info->tree_root;
@@ -886,6 +885,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_qgroup *qgroup = NULL;
+	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 	int slot;
 
@@ -893,6 +893,12 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	if (fs_info->quota_root)
 		goto out;
 
+	trans = btrfs_start_transaction(tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
 	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
 	if (!fs_info->qgroup_ulist) {
 		ret = -ENOMEM;
@@ -987,6 +993,11 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	fs_info->quota_root = quota_root;
 	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	spin_unlock(&fs_info->qgroup_lock);
+
+	ret = btrfs_commit_transaction(trans);
+	if (ret)
+		goto out_free_path;
+
 	ret = qgroup_rescan_init(fs_info, 0, 1);
 	if (!ret) {
 	        qgroup_rescan_zero_tracking(fs_info);
@@ -1011,15 +1022,22 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_quota_disable(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info)
+int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *quota_root;
+	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root)
 		goto out;
+
+	trans = btrfs_start_transaction(fs_info->tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
 	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 	spin_lock(&fs_info->qgroup_lock);
@@ -1031,12 +1049,16 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	btrfs_free_qgroup_config(fs_info);
 
 	ret = btrfs_clean_quota_tree(trans, quota_root);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		goto out;
+	}
 
 	ret = btrfs_del_root(trans, fs_info, &quota_root->root_key);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		goto out;
+	}
 
 	list_del(&quota_root->dirty_list);
 
@@ -1048,6 +1070,8 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	free_extent_buffer(quota_root->node);
 	free_extent_buffer(quota_root->commit_root);
 	kfree(quota_root);
+
+	ret = btrfs_commit_transaction(trans);
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
@@ -3061,7 +3085,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len);
 	extent_changeset_init(&changeset);
-	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
+	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
 			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d60dd06445ce..bec7c9b17a8e 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -141,10 +141,8 @@ struct btrfs_qgroup {
 #define QGROUP_RELEASE		(1<<1)
 #define QGROUP_FREE		(1<<2)
 
-int btrfs_quota_enable(struct btrfs_trans_handle *trans,
-		       struct btrfs_fs_info *fs_info);
-int btrfs_quota_disable(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info);
+int btrfs_quota_enable(struct btrfs_fs_info *fs_info);
+int btrfs_quota_disable(struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
 void btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
-- 
2.7.4


--------------1DF9D428F5983A66BC43D841--
