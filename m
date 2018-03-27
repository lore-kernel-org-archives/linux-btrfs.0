Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52229 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752082AbeC0HTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 45A16B046
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 09/10] btrfs-progs: Remove ext_ref local variable from check_fs_roots_lowmem
Date: Tue, 27 Mar 2018 10:19:31 +0300
Message-Id: <1522135172-8276-10-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All real consumers of that variable have inlined the checks since they
are simple enough. So just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index eb6ca6453dc5..4f463d4f726f 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4458,13 +4458,10 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct extent_buffer *node;
-	unsigned int ext_ref;
 	int slot;
 	int ret;
 	int err = 0;
 
-	ext_ref = btrfs_fs_incompat(fs_info, EXTENDED_IREF);
-
 	btrfs_init_path(&path);
 	key.objectid = BTRFS_FS_TREE_OBJECTID;
 	key.offset = 0;
-- 
2.7.4

