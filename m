Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753513AbcJXPSZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 11:18:25 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6F0A5AC31
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 15:18:23 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs-progs: check: release path after usage
Date: Mon, 24 Oct 2016 10:18:14 -0500
Message-Id: <20161024151814.15231-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

While performing an fsck, an assertion failure occurs because of reusing path in a loop.
ctree.c:1112: btrfs_search_slot: Warning: assertion `p->nodes[0] != NULL` failed, value 0

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

---

diff --git a/cmds-check.c b/cmds-check.c
index 670ccd1..5d9c724 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7543,6 +7543,7 @@ static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
 		key.offset = dback->offset;
 
 		ret = btrfs_search_slot(NULL, dest_root, &key, path, 0, 0);
+		btrfs_release_path(path);
 		/*
 		 * For ret < 0, it's OK since the fs-tree may be corrupted,
 		 * we need to record it for inode/file extent rebuild.
