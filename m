Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37517 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIBL5i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 07:57:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XOmiO-0006ov-CE
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 13:57:36 +0200
Received: from pd953e79b.dip0.t-ipconnect.de ([217.83.231.155])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 13:57:36 +0200
Received: from holger.hoffstaette by pd953e79b.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 13:57:36 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Btrfs-progs: fix typos
Date: Tue, 2 Sep 2014 11:57:20 +0000 (UTC)
Message-ID: <pan.2014.09.02.11.57.20@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Fix (at least one user-visible) typos: it's its, not it's.

Signed-off-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
---
 btrfs-convert.c | 2 +-
 cmds-device.c   | 2 +-
 qgroup-verify.c | 4 ++--
 utils.c         | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 71b7bd6..f9910dc 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1643,7 +1643,7 @@ err:
 }
 
 /*
- * Migrate super block to it's default position and zero 0 ~ 16k
+ * Migrate super block to its default position and zero 0 ~ 16k
  */
 static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
 {
diff --git a/cmds-device.c b/cmds-device.c
index d7af090..0475bf6 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -295,7 +295,7 @@ out:
 
 static const char * const cmd_ready_dev_usage[] = {
 	"btrfs device ready <device>",
-	"Check device to see if it has all of it's devices in cache for mounting",
+	"Check device to see if it has all of its devices in cache for mounting",
 	NULL
 };
 
diff --git a/qgroup-verify.c b/qgroup-verify.c
index a5bd4f8..430f099 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -63,9 +63,9 @@ struct rb_root by_bytenr = RB_ROOT;
  * finding roots to account against.
  *
  * An implied ref is when a tree block has refs on it that may not
- * exist in any of it's child nodes. Even though the refs might not
+ * exist in any of its child nodes. Even though the refs might not
  * exist further down the tree, the fact that our interior node has a
- * ref means we need to account anything below it to all it's roots.
+ * ref means we need to account anything below it to all its roots.
  */
 struct ulist *tree_blocks = NULL;	/* unode->val = bytenr, ->aux
 					 * = tree_block pointer */
diff --git a/utils.c b/utils.c
index 6c09366..f0a3c07 100644
--- a/utils.c
+++ b/utils.c
@@ -2304,7 +2304,7 @@ int ask_user(char *question)
 /*
  * For a given:
  * - file or directory return the containing tree root id
- * - subvolume return it's own tree id
+ * - subvolume return its own tree id
  * - BTRFS_EMPTY_SUBVOL_DIR_OBJECTID (directory with ino == 2) the result is
  *   undefined and function returns -1
  */
-- 
2.1.0


