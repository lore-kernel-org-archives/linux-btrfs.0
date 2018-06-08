Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44255 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752693AbeFHMsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:03 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D288AF99
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/15] btrfs-progs: Add functions to modify the used space by a root
Date: Fri,  8 Jun 2018 15:47:46 +0300
Message-Id: <1528462078-24490-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pull the necessary function, excluding locking. Required to enable
integration of delayed refs.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/ctree.c b/ctree.c
index 2c51580fec65..7b74716bf92f 100644
--- a/ctree.c
+++ b/ctree.c
@@ -76,6 +76,18 @@ void add_root_to_dirty_list(struct btrfs_root *root)
 	}
 }
 
+static void root_add_used(struct btrfs_root *root, u32 size)
+{
+        btrfs_set_root_used(&root->root_item,
+                            btrfs_root_used(&root->root_item) + size);
+}
+
+static void root_sub_used(struct btrfs_root *root, u32 size)
+{
+        btrfs_set_root_used(&root->root_item,
+                            btrfs_root_used(&root->root_item) - size);
+}
+
 int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      struct extent_buffer *buf,
-- 
2.7.4

