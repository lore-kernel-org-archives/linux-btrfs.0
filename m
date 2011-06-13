From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: fix dereference of ERR_PTR value
Date: Mon, 13 Jun 2011 19:54:22 +0200
Message-ID: <1307987662-6772-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

smatch reports:

btrfs_recover_log_trees error: 'wc.replay_dest' dereferencing
possible ERR_PTR()

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/tree-log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 592396c..4ce8a9f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3177,7 +3177,7 @@ again:
 		tmp_key.offset = (u64)-1;
 
 		wc.replay_dest = btrfs_read_fs_root_no_name(fs_info, &tmp_key);
-		BUG_ON(!wc.replay_dest);
+		BUG_ON(IS_ERR_OR_NULL(wc.replay_dest));
 
 		wc.replay_dest->log_root = log;
 		btrfs_record_root_in_trans(trans, wc.replay_dest);
-- 
1.7.5.2.353.g5df3e

