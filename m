Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:36102 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab3B0LVp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 06:21:45 -0500
Received: by mail-da0-f52.google.com with SMTP id x33so253241dad.25
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 03:21:45 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH 3/3] Btrfs: remove reduplicate check about root in the function btrfs_clean_quota_tree
Date: Wed, 27 Feb 2013 19:21:40 +0800
Message-Id: <1361964100-2503-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The check work has been done just before the function btrfs_clean_quota_tree
is called, it is not necessary to check it again, remove it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 69fa487..aee4b1c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -742,9 +742,6 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 	int ret;
 	int nr = 0;
 
-	if (!root)
-		return -EINVAL;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.7.7.6

