Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2GXKkN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 06:40:13 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6OAeAES006620
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2012 18:40:11 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs-progs: search subvolumes with proper objectid
Date: Tue, 24 Jul 2012 18:39:23 +0800
Message-Id: <1343126364-27919-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs's subvolume/snapshot is limited to
[BTRFS_FIRST_FREE_OBJECTID, BTRFS_LAST_FREE_OBJECTID], so just apply the range.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 btrfs-list.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index c53d016..ac6507a 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -634,11 +634,13 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	sk->max_type = BTRFS_ROOT_BACKREF_KEY;
 	sk->min_type = BTRFS_ROOT_BACKREF_KEY;
 
+	sk->min_objectid = BTRFS_FIRST_FREE_OBJECTID;
+
 	/*
 	 * set all the other params to the max, we'll take any objectid
 	 * and any trans
 	 */
-	sk->max_objectid = (u64)-1;
+	sk->max_objectid = BTRFS_LAST_FREE_OBJECTID;
 	sk->max_offset = (u64)-1;
 	sk->max_transid = (u64)-1;
 
@@ -690,7 +692,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 		if (sk->min_type < BTRFS_ROOT_BACKREF_KEY) {
 			sk->min_type = BTRFS_ROOT_BACKREF_KEY;
 			sk->min_offset = 0;
-		} else  if (sk->min_objectid < (u64)-1) {
+		} else  if (sk->min_objectid < BTRFS_LAST_FREE_OBJECTID) {
 			sk->min_objectid++;
 			sk->min_type = BTRFS_ROOT_BACKREF_KEY;
 			sk->min_offset = 0;
-- 
1.6.5.2

