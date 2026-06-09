Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CE823645D
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 03:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780975435; cv=none; b=QQn+ou7qyvOGN63Lc8C5GsPOnpbRLSDVXxtUqjW13rFZfa2HtfyPNHqNO0Y4tEcUandWnfdRBY7ydhmNP9XrgNl+Q0CKR4rNkV1ooUwNFSqCI3MrL0JJsVo1pPgROOAj8epamI8rmnbUv7+g31e2SmHn/p3far9tLBJgr29lHmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780975435; c=relaxed/simple;
	bh=ynZCOXl9lTYi+Oy545Q4te9IaDEtdy6D76q8XJkqRO0=;
	h=To:Date:Content-Type:Message-Id:Mime-Version:From:Cc:Subject; b=bcThlnZH/hWukW9egCihGARyhq9xW4qYJ2TiVeFzfPhBWgoFfJa0+pkCjUJPjHtI6OJ/W35jmDWnK72dfC/klVbeuSAp/b0w0OAi9QUGq+reJ78bjZq6u6EjezaStuYm8EHTnVJGDIbBTNBzYsofAopFzqI6qEgMQKlAJTxSIGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=g5mao6uX; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="g5mao6uX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780975421;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bHxFiGNQ6Q7coOqpnmZuFAexypLXAEMS2kuHJQYflT8=;
 b=g5mao6uX0T8Zqp8B1iH0brNtksnioVsb6qjMvqw1d1EDaVhbGDqWGzFMxFK61ss8RSlNw+
 MHbf7ZTEVnNYvC2cGwDAUxLdJ/wloCJ19KXUVrGfHXfjAxfwAKE5DoNtSvQ/5BpMcGjh6E
 y6N/PYJk6xWUe3gJkYdQxsOkVSWzh2Nvm8wlTQzT7Kp8/5jYvUZ7y9ncz8c1t0dWm73g9y
 DGavijB6oYCUJqRWg0paYY3QNS6KEXueZHZ7uXjhLjjVc8LVCMRi+gV56Pm5VCf9tIl+by
 HQk3ypGR/FaJMH+iQy/JZHupwA2LEsa5Psyxw63RFrfYCUhFtJ7Du80IpQqf0Q==
To: <linux-btrfs@vger.kernel.org>
Date: Tue,  9 Jun 2026 11:23:18 +0800
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260609032318.3745767-1-zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
X-Mailer: git-send-email 2.39.5
X-Lms-Return-Path: <lba+26a27873b+a015c8+vger.kernel.org+zhudongjiang@fnnas.com>
Cc: <wqu@suse.com>, <dsterba@suse.com>, <fdmanana@suse.com>
Subject: [PATCH v3] btrfs: start qgroup ioctl transactions on the quota root
Received: from pdzhu.teiron-inc.cn ([183.34.167.208]) by smtp.feishu.cn with ESMTPS; Tue, 09 Jun 2026 11:23:38 +0800

The qgroup ioctls update the quota tree, but they currently start their
transactions using the root of the inode passed to the ioctl. This makes
the transaction reservation depend on the path used for the ioctl instead
of the tree being modified.

Start qgroup ioctl transactions on the quota root instead. Take a reference
to fs_info->quota_root under qgroup_ioctl_lock before starting the
transaction, because quota disable can clear and put fs_info->quota_root
after the early quota-enabled check. Keep the reference until the
transaction handle is ended.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
Changes since v2:
- Grab fs_info->quota_root under qgroup_ioctl_lock to close the race with
  concurrent quota disable before taking the root reference.
- Keep the grabbed quota root reference until btrfs_end_transaction()
  instead of dropping it immediately after starting the transaction.

Changes since RFC:
- Rework the fix to start qgroup ioctl transactions on fs_info->quota_root
  instead of adding a no-qgroup-enforce transaction helper.
- Add quota root grabbing to handle concurrent quota disable.

 fs/btrfs/ioctl.c | 50 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d47d16394fc..2d693775cad5 100644
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
@@ -3637,10 +3637,20 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 		}
 	}
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	quota_root = btrfs_grab_root(fs_info->quota_root);
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
+	if (!quota_root) {
+		ret = -ENOTCONN;
+		goto drop_write;
+	}
+
 	/* 2 BTRFS_QGROUP_RELATION_KEY items. */
-	trans = btrfs_start_transaction(root, 2);
+	trans = btrfs_start_transaction(quota_root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		btrfs_put_root(quota_root);
 		goto drop_write;
 	}
 
@@ -3664,6 +3674,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 			   "qgroup status update failed after %s relation, marked as inconsistent",
 			   sa->assign ? "adding" : "deleting");
 	err = btrfs_end_transaction(trans);
+	btrfs_put_root(quota_root);
 	if (err && !ret)
 		ret = err;
 
@@ -3675,7 +3686,8 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_root *quota_root;
 	struct btrfs_ioctl_qgroup_create_args AUTO_KFREE(sa);
 	struct btrfs_trans_handle *trans;
 	int ret;
@@ -3684,7 +3696,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!btrfs_qgroup_enabled(root->fs_info))
+	if (!btrfs_qgroup_enabled(fs_info))
 		return -ENOTCONN;
 
 	ret = mnt_want_write_file(file);
@@ -3707,13 +3719,23 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	quota_root = btrfs_grab_root(fs_info->quota_root);
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
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
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		btrfs_put_root(quota_root);
 		goto drop_write;
 	}
 
@@ -3724,6 +3746,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	}
 
 	err = btrfs_end_transaction(trans);
+	btrfs_put_root(quota_root);
 	if (err && !ret)
 		ret = err;
 
@@ -3736,6 +3759,8 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *quota_root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_ioctl_qgroup_limit_args AUTO_KFREE(sa);
 	struct btrfs_trans_handle *trans;
 	int ret;
@@ -3745,7 +3770,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!btrfs_qgroup_enabled(root->fs_info))
+	if (!btrfs_qgroup_enabled(fs_info))
 		return -ENOTCONN;
 
 	ret = mnt_want_write_file(file);
@@ -3758,10 +3783,20 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	quota_root = btrfs_grab_root(fs_info->quota_root);
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
+	if (!quota_root) {
+		ret = -ENOTCONN;
+		goto drop_write;
+	}
+
 	/* 1 BTRFS_QGROUP_LIMIT_KEY item. */
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(quota_root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		btrfs_put_root(quota_root);
 		goto drop_write;
 	}
 
@@ -3774,6 +3809,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 	ret = btrfs_limit_qgroup(trans, qgroupid, &sa->lim);
 
 	err = btrfs_end_transaction(trans);
+	btrfs_put_root(quota_root);
 	if (err && !ret)
 		ret = err;
 
-- 
2.39.5
