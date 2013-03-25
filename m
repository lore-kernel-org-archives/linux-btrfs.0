Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48401 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3CYLI3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 07:08:29 -0400
Received: by mail-pa0-f47.google.com with SMTP id bj3so515175pad.20
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2013 04:08:28 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, sensille@gmx.net
Subject: [PATCH 1/2] Btrfs: fix double free in the btrfs_qgroup_account_ref()
Date: Mon, 25 Mar 2013 19:08:23 +0800
Message-Id: <1364209703-1590-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The function btrfs_find_all_roots is responsible to allocate
memory for 'roots' and free it if errors happen,so the caller should not
free it again since the work has been done.

Besides,'tmp' is allocated after the function btrfs_find_all_roots,
so we can return directly if btrfs_find_all_roots() fails.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1aff3a8..e3598fa 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1208,7 +1208,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	ret = btrfs_find_all_roots(trans, fs_info, node->bytenr,
 				   sgn > 0 ? node->seq - 1 : node->seq, &roots);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
@@ -1330,7 +1330,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	ret = 0;
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
-out:
 	ulist_free(roots);
 	ulist_free(tmp);
 
-- 
1.7.7.6

