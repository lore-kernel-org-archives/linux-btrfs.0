Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932446AbcJXO6E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 10:58:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4FB9BAC6C
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 14:58:01 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs-progs: Initialize btrfs_path before use
Date: Mon, 24 Oct 2016 09:57:54 -0500
Message-Id: <20161024145754.7165-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

While performing an fsck, an assertion failure occurs because of reusing path in a loop.
ctree.c:1112: btrfs_search_slot: Warning: assertion `p->nodes[0] != NULL` failed, value 0

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

diff --git a/cmds-check.c b/cmds-check.c
index 670ccd1..a6f281c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7541,6 +7541,7 @@ static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
 		key.objectid = dback->owner;
 		key.type = BTRFS_EXTENT_DATA_KEY;
 		key.offset = dback->offset;
+		btrfs_init_path(path);
 
 		ret = btrfs_search_slot(NULL, dest_root, &key, path, 0, 0);
 		/*
