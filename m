Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E3C3E92B5
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 08:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780563360; cv=none; b=EGB2gLoFEL7/NJxnXlU18gMlQUkkHwqVZa7b6gGpW5/l6skpbOjEaf1h/W+D2lCDAzLK2ApV/HnTBuxJqyyiY8GCR9LXxM1OplikdnuP8REuP2AvV5H2JvjbAoTuvtVKNFQa/YYudZ5pm57vO3/86q7Wid9tPjqd1KeatKqdAKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780563360; c=relaxed/simple;
	bh=/sCMumURoRkgmjX1+8Zlf6K5LtMTYl8eihMVfQDVD4k=;
	h=To:Cc:From:Date:Subject:Message-Id:Mime-Version:Content-Type; b=bY644FIfak2QJDsleQWv0edj54zOVOiJKmeADa2oFTSDbEZGMxQtpc41kisUA+KDj3808BkB20GH24a6JXPiV4ChB9SoMJA8l1cVxwndTjYrCaCPEB4mX1TKvsl7NNNuti61jGyHhDKVez2Scas4CcpW1woGfrG4MzZEabQBSU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=zBXODrRc; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="zBXODrRc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780563346;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=WC7Zh5UUZ6A9r3oFynsQfb4u/+b4PBmeQLDw6ZxSHdc=;
 b=zBXODrRcy6FE0Bkm+TvFqRqCZZJn4U/jJLQh6TaMGZ7rviIc/uNppri/imu3FUQVA6EdFm
 NSb89U0lTW3DVtZ9QDdAVeodHgd89vo1wsHoutYwL/7HvtaFRLu4aeUPXKjKAWrVtMBvGb
 tR97G74PwBci829fTrY7ZHYgzTMo18tqCLP5ZpwoMmp0xDcQuqy0em7lF+3VvPDVQI91YK
 kbJbRx5fdWO8bAt4ul9inSNZwzYHOFMc+rrx7+VfA10FdXObXFEkoHsqUh6iUgD74G4VlL
 phO4gOcsXjDhjSnWuLYGwwOawDU6xeFTj6dxvgQ8TJV9I9Ficjrxew1sGB0WAw==
To: <linux-btrfs@vger.kernel.org>
Cc: <wqu@suse.com>, <dsterba@suse.com>, <fdmanana@suse.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Date: Thu,  4 Jun 2026 16:55:22 +0800
Subject: [PATCH v2] btrfs: start qgroup ioctl transactions on the quota root
Content-Transfer-Encoding: 7bit
Received: from localhost.localdomain ([183.34.166.141]) by smtp.feishu.cn with ESMTPS; Thu, 04 Jun 2026 16:55:43 +0800
X-Lms-Return-Path: <lba+26a213d90+9b98fd+vger.kernel.org+zhudongjiang@fnnas.com>
Message-Id: <20260604085522.3872126-1-zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset=UTF-8

The qgroup ioctls update the quota tree, but they currently start their
transactions using the root of the inode passed to the ioctl. This makes
the transaction reservation depend on the path used for the ioctl instead
of the tree being modified.

Start qgroup ioctl transactions on the quota root instead. Grab a
reference to the quota root before starting the transaction, as quota
disable can clear fs_info->quota_root concurrently after the early quota
enabled check.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
Changes since RFC:
- Rework the fix to start qgroup ioctl transactions on fs_info->quota_root
  instead of adding a no-qgroup-enforce transaction helper.
- Grab the quota root before starting the transaction to handle concurrent
  quota disable.

 fs/btrfs/ioctl.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d47d16394fc..bec4f921aefd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3606,7 +3606,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *quota_root;
 	struct btrfs_ioctl_qgroup_assign_args AUTO_KFREE(sa);
 	struct btrfs_qgroup_list AUTO_KFREE(prealloc);
 	struct btrfs_trans_handle *trans;
@@ -3637,8 +3637,15 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 		}
 	}
 
+	quota_root = btrfs_grab_root(fs_info->quota_root);
+	if (!quota_root) {
+		ret = -ENOTCONN;
+		goto drop_write;
+	}
+
 	/* 2 BTRFS_QGROUP_RELATION_KEY items. */
-	trans = btrfs_start_transaction(root, 2);
+	trans = btrfs_start_transaction(quota_root, 2);
+	btrfs_put_root(quota_root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto drop_write;
@@ -3675,7 +3682,8 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_root *quota_root;
 	struct btrfs_ioctl_qgroup_create_args AUTO_KFREE(sa);
 	struct btrfs_trans_handle *trans;
 	int ret;
@@ -3684,7 +3692,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!btrfs_qgroup_enabled(root->fs_info))
+	if (!btrfs_qgroup_enabled(fs_info))
 		return -ENOTCONN;
 
 	ret = mnt_want_write_file(file);
@@ -3707,11 +3715,18 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	quota_root = btrfs_grab_root(fs_info->quota_root);
+	if (!quota_root) {
+		ret = -ENOTCONN;
+		goto drop_write;
+	}
+
 	/*
 	 * 1 BTRFS_QGROUP_INFO_KEY item.
 	 * 1 BTRFS_QGROUP_LIMIT_KEY item.
 	 */
-	trans = btrfs_start_transaction(root, 2);
+	trans = btrfs_start_transaction(quota_root, 2);
+	btrfs_put_root(quota_root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto drop_write;
@@ -3736,6 +3751,8 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *quota_root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_ioctl_qgroup_limit_args AUTO_KFREE(sa);
 	struct btrfs_trans_handle *trans;
 	int ret;
@@ -3745,7 +3762,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!btrfs_qgroup_enabled(root->fs_info))
+	if (!btrfs_qgroup_enabled(fs_info))
 		return -ENOTCONN;
 
 	ret = mnt_want_write_file(file);
@@ -3758,8 +3775,15 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	quota_root = btrfs_grab_root(fs_info->quota_root);
+	if (!quota_root) {
+		ret = -ENOTCONN;
+		goto drop_write;
+	}
+
 	/* 1 BTRFS_QGROUP_LIMIT_KEY item. */
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(quota_root, 1);
+	btrfs_put_root(quota_root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto drop_write;
-- 
2.39.5
