Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaL3O5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 09:57:45 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AED09ABFC
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 14:57:44 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/5] btrfs-progs: check, missing parens around compound block in find_normal_file_extent
Date: Tue, 30 Dec 2014 15:57:44 +0100
Message-Id: <01a9f4308ba2625dbfb83e3fad2bcc6c2e512b9f.1419951036.git.dsterba@suse.cz>
In-Reply-To: <cover.1419951036.git.dsterba@suse.cz>
References: <cover.1419951036.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-coverity-id: 1260248
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 71e4f4f3a13b..d2d218a88589 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2160,9 +2160,10 @@ static int find_normal_file_extent(struct btrfs_root *root, u64 ino)
 		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_file_extent_item);
 		type = btrfs_file_extent_type(path->nodes[0], fi);
-		if (type != BTRFS_FILE_EXTENT_INLINE)
+		if (type != BTRFS_FILE_EXTENT_INLINE) {
 			ret = 1;
 			goto out;
+		}
 	}
 out:
 	btrfs_free_path(path);
-- 
2.1.3

