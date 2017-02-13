Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41601 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752245AbdBMJe2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:28 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 32E25ABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 12/29] btrfs: remove unused parameter from tree_move_down
Date: Mon, 13 Feb 2017 10:33:58 +0100
Message-Id: <522e0e7934478160a6dd06f87e65fcef486b582d.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never needed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b98e90a3eee7..a981c2acd6fa 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5241,7 +5241,7 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 
 static int tree_move_down(struct btrfs_fs_info *fs_info,
 			   struct btrfs_path *path,
-			   int *level, int root_level)
+			   int *level)
 {
 	struct extent_buffer *eb;
 
@@ -5299,7 +5299,7 @@ static int tree_advance(struct btrfs_fs_info *fs_info,
 		ret = tree_move_next_or_upnext(fs_info, path, level,
 					       root_level);
 	} else {
-		ret = tree_move_down(fs_info, path, level, root_level);
+		ret = tree_move_down(fs_info, path, level);
 	}
 	if (ret >= 0) {
 		if (*level == 0)
-- 
2.10.1

