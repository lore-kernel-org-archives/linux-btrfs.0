Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752745AbeFHMsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:05 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2AF16AF99
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/15] btrfs-progs: Add boolean to signal whether we are re-initing extent tree
Date: Fri,  8 Jun 2018 15:47:53 +0300
Message-Id: <1528462078-24490-11-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a boolean to record whether the extent tree is being re-initialised
in the current transaction. This is going to be needed by the
delayed refs code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 transaction.c | 1 +
 transaction.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/transaction.c b/transaction.c
index 9619265ef6e8..ecafbb156610 100644
--- a/transaction.c
+++ b/transaction.c
@@ -46,6 +46,7 @@ struct btrfs_trans_handle* btrfs_start_transaction(struct btrfs_root *root,
 	fs_info->generation++;
 	h->transid = fs_info->generation;
 	h->blocks_reserved = num_blocks;
+	h->reinit_extent_tree = false;
 	root->last_trans = h->transid;
 	root->commit_root = root->node;
 	extent_buffer_get(root->node);
diff --git a/transaction.h b/transaction.h
index 470ee3de1358..750e329e1ba8 100644
--- a/transaction.h
+++ b/transaction.h
@@ -27,6 +27,7 @@ struct btrfs_trans_handle {
 	u64 transid;
 	u64 alloc_exclude_start;
 	u64 alloc_exclude_nr;
+	bool reinit_extent_tree;
 	unsigned long blocks_reserved;
 	unsigned long blocks_used;
 	struct btrfs_block_group_cache *block_group;
-- 
2.7.4

