Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41304 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaJOU6w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 16:58:52 -0400
Received: by mail-wi0-f179.google.com with SMTP id d1so3040808wiv.6
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 13:58:50 -0700 (PDT)
From: Filipe Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs-progs: check, fix return value check of is_child_root()
Date: Wed, 15 Oct 2014 22:58:40 +0100
Message-Id: <1413410320-22954-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following commit:

    "btrfs-progs: fsck: remove unfriendly BUG_ON() for searching tree failure"
    f495a2ac66116f0a1b15e73380c8cbca6e0a4ca0

introduced a regression, detected through xfstests/btrfs/054, where
previously a negative return value (-1) was used to mean a particular
root didn't had any parent root, and now, after that change, a negative
value is also used to mean that an error happened. That change also made
the only caller of is_child_root() interpret any negative return value
as an error and therefore incorrectly made the caller leave with an
error, instead of jumping to its "skip" label.

Since the return value that means "the root with id child_root_id doesn't
have any parent root" isn't used by the only caller of is_child_root(),
just get rid of it and make is_child_root() return 0 if parent_root_id
isn't a parent of child_root_id, return 1 if it is, and a negative value
on error.

This affects only the 3.17 release candidates (3.16 and older releases
don't have this issue).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 cmds-check.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 99d1a94..002d3e9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -901,7 +901,6 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	int has_parent = 0;
 	int ret;
 
 	btrfs_init_path(&path);
@@ -939,8 +938,6 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 		    key.type != BTRFS_ROOT_BACKREF_KEY)
 			break;
 
-		has_parent = 1;
-
 		if (key.offset == parent_root_id) {
 			btrfs_release_path(&path);
 			return 1;
@@ -952,7 +949,7 @@ out:
 	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
-	return has_parent? 0 : -1;
+	return 0;
 }
 
 static int process_dir_item(struct btrfs_root *root,
-- 
1.9.1

