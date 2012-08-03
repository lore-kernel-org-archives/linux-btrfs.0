Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44887 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2HCJve (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 05:51:34 -0400
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4/9] Btrfs-progs: nuke redundant zeroing in __list_subvol_search()
Date: Fri,  3 Aug 2012 17:48:53 +0800
Message-Id: <1343987338-10612-6-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
 <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Ilya Dryomov <idryomov@gmail.com>

There's no need to zero out things twice.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs-list.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 5c21cac..911b238 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -570,10 +570,6 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
 
-	root_lookup_init(root_lookup);
-
-	memset(&args, 0, sizeof(args));
-
 	/* search in the tree of tree roots */
 	sk->tree_id = 1;
 
-- 
1.7.1

