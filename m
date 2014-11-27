Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44982 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaK0E5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 23:57:43 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 27 Nov 2014 14:57:41 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 111682CE8065
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 15:57:39 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAR4vU4X41156726
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 15:57:38 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAR4v6HQ022721
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 15:57:06 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] Btrfs-progs: add_refs_for_implied: Use root_id instead of root_bytenr.
Date: Thu, 27 Nov 2014 10:26:45 +0530
Message-Id: <1417064205-19040-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

resolve_one_root() returns the objectid of a tree rather than the logical
address of the root node. Hence using root_bytenr is misleading. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 qgroup-verify.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index c0c61d0..c98c751 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -553,11 +553,11 @@ static int add_refs_for_implied(struct btrfs_fs_info *info, u64 bytenr,
 				struct tree_block *block)
 {
 	int ret;
-	u64 root_bytenr = resolve_one_root(bytenr);
+	u64 root_id = resolve_one_root(bytenr);
 	struct btrfs_root *root;
 	struct btrfs_key key;
 
-	key.objectid = root_bytenr;
+	key.objectid = root_id;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
 
-- 
2.1.0

