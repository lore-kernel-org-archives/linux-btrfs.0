Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab2EQL60 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 07:58:26 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4HBwMbH005960
	for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 19:58:23 +0800
Message-ID: <4FB4E785.4050902@cn.fujitsu.com>
Date: Thu, 17 May 2012 19:56:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] Btrfs: count the chunks which will be relocated at first
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

the balance function should count the chunks which will be relocated at first,
and then relocate those chunks one by one.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 759d024..91da8a2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2580,7 +2580,7 @@ again:
 
 		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
 
-		if (!counting) {
+		if (counting) {
 			spin_lock(&fs_info->balance_lock);
 			bctl->stat.considered++;
 			spin_unlock(&fs_info->balance_lock);
-- 
1.7.6.5
