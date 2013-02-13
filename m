Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:11632 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab3BMLUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 06:20:05 -0500
From: Arne Jansen <sensille@gmx.net>
To: shyam.btrfs@gmail.com
Cc: linux-btrfs@vger.kernel.org, list.btrfs@jan-o-sch.net
Subject: [PATCH] Btrfs: fix crash in log replay with qgroups enabled
Date: Wed, 13 Feb 2013 12:20:01 +0100
Message-Id: <1360754401-24807-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When replaying a log tree with qgroups enabled, tree_mod_log_rewind does a
sanity-check of the number of items against the maximum possible number.
It calculates that number with the nodesize of fs_root. Unfortunately
fs_root is not yet set at this stage. So instead use the nodesize from
tree_root, which is already initialized.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index eea5da7..6eff0fa 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1222,7 +1222,7 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 
 	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
-		BTRFS_NODEPTRS_PER_BLOCK(fs_info->fs_root));
+		BTRFS_NODEPTRS_PER_BLOCK(fs_info->tree_root));
 
 	return eb_rewin;
 }
-- 
1.7.1

