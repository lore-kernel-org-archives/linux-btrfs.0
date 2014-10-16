Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38702 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaJOXdf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 19:33:35 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so2448724wgh.28
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 16:33:34 -0700 (PDT)
From: Filipe Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Btrfs-progs: check, fix return value check of is_child_root()
Date: Thu, 16 Oct 2014 01:33:23 +0100
Message-Id: <1413419603-19146-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1413410320-22954-1-git-send-email-fdmanana@suse.com>
References: <1413410320-22954-1-git-send-email-fdmanana@suse.com>
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
error, instead of continuing.

This affects only the 3.17 release candidates (3.16 and older releases
don't have this issue).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Made it return 2 (instead of -1) when the root child_root_id doesn't
    have any parent roots, in order to behave exactly like the code
    pre-commit f495a2ac66116f0a1b15e73380c8cbca6e0a4ca0.

 cmds-check.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 99d1a94..310eb2a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -895,6 +895,14 @@ static int leave_shared_node(struct btrfs_root *root,
 	return 0;
 }
 
+/*
+ * Returns:
+ * < 0 - on error
+ * 1   - if the root with id child_root_id is a child of root parent_root_id
+ * 0   - if the root child_root_id isn't a child of the root parent_root_id but
+ *       has other root(s) as parent(s)
+ * 2   - if the root child_root_id doesn't have any parent roots
+ */
 static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 			 u64 child_root_id)
 {
@@ -952,7 +960,7 @@ out:
 	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
-	return has_parent? 0 : -1;
+	return has_parent ? 0 : 2;
 }
 
 static int process_dir_item(struct btrfs_root *root,
-- 
1.9.1

