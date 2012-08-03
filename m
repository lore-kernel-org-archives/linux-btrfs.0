Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46605 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2HCJvd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 05:51:33 -0400
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/9] Btrfs-progs: search subvolumes with proper objectid
Date: Fri,  3 Aug 2012 17:48:51 +0800
Message-Id: <1343987338-10612-4-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
 <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

Btrfs's subvolume/snapshot is limited to
[BTRFS_FIRST_FREE_OBJECTID, BTRFS_LAST_FREE_OBJECTID], so just apply the range.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 btrfs-list.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 35e6139..680dd03 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -585,11 +585,13 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
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
 
@@ -641,7 +643,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 		if (sk->min_type < BTRFS_ROOT_BACKREF_KEY) {
 			sk->min_type = BTRFS_ROOT_BACKREF_KEY;
 			sk->min_offset = 0;
-		} else  if (sk->min_objectid < (u64)-1) {
+		} else  if (sk->min_objectid < BTRFS_LAST_FREE_OBJECTID) {
 			sk->min_objectid++;
 			sk->min_type = BTRFS_ROOT_BACKREF_KEY;
 			sk->min_offset = 0;
-- 
1.7.1

