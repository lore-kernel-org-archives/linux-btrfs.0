Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41537 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdBMJeI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:08 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 43173ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:02 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/29] btrfs: remove unused parameter from split_item
Date: Mon, 13 Feb 2017 10:33:33 +0100
Message-Id: <131f5894701d44f5e855de99f5c8334b316bc1de.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never used.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d509dafdb20c..4c5d7c40c8bf 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4413,8 +4413,7 @@ static noinline int setup_leaf_for_split(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static noinline int split_item(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info,
+static noinline int split_item(struct btrfs_fs_info *fs_info,
 			       struct btrfs_path *path,
 			       const struct btrfs_key *new_key,
 			       unsigned long split_offset)
@@ -4511,7 +4510,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	ret = split_item(trans, root->fs_info, path, new_key, split_offset);
+	ret = split_item(root->fs_info, path, new_key, split_offset);
 	return ret;
 }
 
-- 
2.10.1

