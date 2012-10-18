Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51759 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2JRHe0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 03:34:26 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9I7YPuF011981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 07:34:26 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9I7YOhJ007052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 07:34:25 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9I7YOEt024636
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 02:34:24 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: MOD_LOG_KEY_REMOVE_WHILE_MOVING never change node's nritems
Date: Thu, 18 Oct 2012 15:32:53 +0800
Message-Id: <1350545573-2544-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Key MOD_LOG_KEY_REMOVE_WHILE_MOVING means that we're doing memmove inside
an extent buffer node, and the node's number of items remains unchanged,
so we don't need to increment node's number of items during rewinding,
otherwise we may get an node larger than leafsize and cause general protection
errors later.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b334362..2858c2f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1142,13 +1142,13 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 		switch (tm->op) {
 		case MOD_LOG_KEY_REMOVE_WHILE_FREEING:
 			BUG_ON(tm->slot < n);
-		case MOD_LOG_KEY_REMOVE_WHILE_MOVING:
 		case MOD_LOG_KEY_REMOVE:
+			n++;
+		case MOD_LOG_KEY_REMOVE_WHILE_MOVING:
 			btrfs_set_node_key(eb, &tm->key, tm->slot);
 			btrfs_set_node_blockptr(eb, tm->slot, tm->blockptr);
 			btrfs_set_node_ptr_generation(eb, tm->slot,
 						      tm->generation);
-			n++;
 			break;
 		case MOD_LOG_KEY_REPLACE:
 			BUG_ON(tm->slot >= n);
-- 
1.7.7.6

