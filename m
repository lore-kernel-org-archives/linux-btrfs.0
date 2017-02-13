Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752263AbdBMJec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:32 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 44B3BABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 13/29] btrfs: remove unused parameter from tree_move_next_or_upnext
Date: Mon, 13 Feb 2017 10:34:01 +0100
Message-Id: <760c406686a36b6bedcb07ee3a600d460c37cc13.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not needed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a981c2acd6fa..1192bc7d2ee7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5256,8 +5256,7 @@ static int tree_move_down(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static int tree_move_next_or_upnext(struct btrfs_fs_info *fs_info,
-				    struct btrfs_path *path,
+static int tree_move_next_or_upnext(struct btrfs_path *path,
 				    int *level, int root_level)
 {
 	int ret = 0;
@@ -5296,8 +5295,7 @@ static int tree_advance(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	if (*level == 0 || !allow_down) {
-		ret = tree_move_next_or_upnext(fs_info, path, level,
-					       root_level);
+		ret = tree_move_next_or_upnext(path, level, root_level);
 	} else {
 		ret = tree_move_down(fs_info, path, level);
 	}
-- 
2.10.1

