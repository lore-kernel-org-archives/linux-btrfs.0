Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65072 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752329AbdI0I0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 04:26:15 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v3 2/5] btrfs-progs: check: call repair_root_items() before any repair
Date: Wed, 27 Sep 2017 16:28:39 +0800
Message-ID: <20170927082839.5693-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170927063440.25961-3-suy.fnst@cn.fujitsu.com>
References: <20170927063440.25961-3-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The Annotation of repair_root_items():
"This must be run before any other repair code - not doing it so,
makes other repair code delete or modify backrefs in the extent tree
for example, which will result in an inconsistent fs after repairing
the root items."

However, the rule was broken by commit 1f728b1a514f ("Btrfs-progs,
fsck: move root items repair after root rebuilding").
The commit intends to fix failure of test-fsck/013 so it moves
repair_root_items() after check_extents_and_chunks().

The correct way is to skip calling repair_root_item() when
init_extent_tree is nonzero.
Now put repair_root_items() before do_check_chunks_and_extents() and
not call repair_root_items() if do init_extent_tree.
Then test-fsck/013 works well.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2:
   Correct commit number reported. (Suggested by Qu Wenruo)
v3:
   Change commit format. (Suggested by Qu Wenruo)
   
 cmds-check.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 93b47194..3e2f9faa 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -14644,32 +14644,35 @@ int cmd_check(int argc, char **argv)
 		goto close_out;
 	}
 
+	if (!init_extent_tree) {
+		ret = repair_root_items(info);
+		err |= !!ret;
+		if (ret < 0) {
+			error("failed to repair root items: %s",
+			      strerror(-ret));
+			goto close_out;
+		}
+		if (repair) {
+			fprintf(stderr, "Fixed %d roots.\n", ret);
+			ret = 0;
+		} else if (ret > 0) {
+			fprintf(stderr,
+				"Found %d roots with an outdated root item.\n",
+				ret);
+			fprintf(stderr,
+				"Please run a filesystem check with the option --repair to fix them.\n");
+			ret = 1;
+			err |= !!ret;
+			goto close_out;
+		}
+	}
+
 	ret = do_check_chunks_and_extents(info);
 	err |= !!ret;
 	if (ret)
 		error(
 		"errors found in extent allocation tree or chunk allocation");
 
-	ret = repair_root_items(info);
-	err |= !!ret;
-	if (ret < 0) {
-		error("failed to repair root items: %s", strerror(-ret));
-		goto close_out;
-	}
-	if (repair) {
-		fprintf(stderr, "Fixed %d roots.\n", ret);
-		ret = 0;
-	} else if (ret > 0) {
-		fprintf(stderr,
-		       "Found %d roots with an outdated root item.\n",
-		       ret);
-		fprintf(stderr,
-			"Please run a filesystem check with the option --repair to fix them.\n");
-		ret = 1;
-		err |= !!ret;
-		goto close_out;
-	}
-
 	if (!ctx.progress_enabled) {
 		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
 			fprintf(stderr, "checking free space tree\n");
-- 
2.14.1



