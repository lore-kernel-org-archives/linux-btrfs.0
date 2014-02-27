Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23657 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaB0Hro (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 02:47:44 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1R7lgG2001807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:47:43 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s1R7lfuU013698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:47:42 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1R7lf6A001108
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:47:41 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2 v2] Btrfs: rename waiting_dir_move
Date: Thu, 27 Feb 2014 15:47:33 +0800
Message-Id: <1393487254-17978-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparation work, rename waiting_dir_move to send_dir_node.
We'd like to share waiting_dir_move structure in new did_create_dir() code.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: fix wrong patch name.

 fs/btrfs/send.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 9dde971..33063d1 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -186,7 +186,7 @@ struct pending_dir_move {
 	struct list_head update_refs;
 };
 
-struct waiting_dir_move {
+struct send_dir_node {
 	struct rb_node node;
 	u64 ino;
 };
@@ -2741,10 +2741,10 @@ out:
 static int is_waiting_for_move(struct send_ctx *sctx, u64 ino)
 {
 	struct rb_node *n = sctx->waiting_dir_moves.rb_node;
-	struct waiting_dir_move *entry;
+	struct send_dir_node *entry;
 
 	while (n) {
-		entry = rb_entry(n, struct waiting_dir_move, node);
+		entry = rb_entry(n, struct send_dir_node, node);
 		if (ino < entry->ino)
 			n = n->rb_left;
 		else if (ino > entry->ino)
@@ -2759,7 +2759,7 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 {
 	struct rb_node **p = &sctx->waiting_dir_moves.rb_node;
 	struct rb_node *parent = NULL;
-	struct waiting_dir_move *entry, *dm;
+	struct send_dir_node *entry, *dm;
 
 	dm = kmalloc(sizeof(*dm), GFP_NOFS);
 	if (!dm)
@@ -2768,7 +2768,7 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 
 	while (*p) {
 		parent = *p;
-		entry = rb_entry(parent, struct waiting_dir_move, node);
+		entry = rb_entry(parent, struct send_dir_node, node);
 		if (ino < entry->ino) {
 			p = &(*p)->rb_left;
 		} else if (ino > entry->ino) {
@@ -2787,10 +2787,10 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 static int del_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 {
 	struct rb_node *n = sctx->waiting_dir_moves.rb_node;
-	struct waiting_dir_move *entry;
+	struct send_dir_node *entry;
 
 	while (n) {
-		entry = rb_entry(n, struct waiting_dir_move, node);
+		entry = rb_entry(n, struct send_dir_node, node);
 		if (ino < entry->ino) {
 			n = n->rb_left;
 		} else if (ino > entry->ino) {
@@ -5469,10 +5469,10 @@ out:
 	WARN_ON(sctx && !ret && !RB_EMPTY_ROOT(&sctx->waiting_dir_moves));
 	while (sctx && !RB_EMPTY_ROOT(&sctx->waiting_dir_moves)) {
 		struct rb_node *n;
-		struct waiting_dir_move *dm;
+		struct send_dir_node *dm;
 
 		n = rb_first(&sctx->waiting_dir_moves);
-		dm = rb_entry(n, struct waiting_dir_move, node);
+		dm = rb_entry(n, struct send_dir_node, node);
 		rb_erase(&dm->node, &sctx->waiting_dir_moves);
 		kfree(dm);
 	}
-- 
1.8.2.1

