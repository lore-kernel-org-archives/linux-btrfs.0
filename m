Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34935 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750992AbdEBGYn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 02:24:43 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CF4EA47E6343
        for <linux-btrfs@vger.kernel.org>; Tue,  2 May 2017 14:24:37 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: check: Fix heap use after free.
Date: Tue, 2 May 2017 14:26:19 +0800
Message-ID: <20170502062619.497-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fsck/004-no-dir-index makes valgrinds complaining about Invalid read.
==31890== Invalid read of size 1
==31890==    at 0x453D09: repair_inode_backrefs (cmds-check.c:2690)
==31890==    by 0x453D09: check_inode_recs (cmds-check.c:3330)
==31890==    by 0x453D09: check_fs_root (cmds-check.c:4012)
==31890==    by 0x45E788: check_fs_roots (cmds-check.c:4098)
==31890==    by 0x45E788: cmd_check (cmds-check.c:13031)
==31890==    by 0x40A88A: main (btrfs.c:246)
==31890==  Address 0x5cb7b90 is 16 bytes inside a block of size 50 free'd
==31890==    at 0x4C2C14B: free (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==31890==    by 0x453D08: repair_inode_backrefs (cmds-check.c:2684)
==31890==    by 0x453D08: check_inode_recs (cmds-check.c:3330)
==31890==    by 0x453D08: check_fs_root (cmds-check.c:4012)
==31890==    by 0x45E788: check_fs_roots (cmds-check.c:4098)
==31890==    by 0x45E788: cmd_check (cmds-check.c:13031)
==31890==    by 0x40A88A: main (btrfs.c:246)
==31890==  Block was alloc'd at
==31890==    at 0x4C2AF1F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==31890==    by 0x45055C: get_inode_backref (cmds-check.c:1075)
==31890==    by 0x45055C: add_inode_backref (cmds-check.c:1097)
==31890==    by 0x45180C: process_dir_item (cmds-check.c:1525)
==31890==    by 0x45180C: process_one_leaf (cmds-check.c:1838)
==31890==    by 0x45180C: walk_down_tree (cmds-check.c:2134)
==31890==    by 0x45180C: check_fs_root (cmds-check.c:3957)
==31890==    by 0x45E788: check_fs_roots (cmds-check.c:4098)
==31890==    by 0x45E788: cmd_check (cmds-check.c:13031)
==31890==    by 0x40A88A: main (btrfs.c:246)
==31890==
==31890== Invalid read of size 8
==31890==    at 0x452D66: repair_inode_backrefs (cmds-check.c:2731)
==31890==    by 0x452D66: check_inode_recs (cmds-check.c:3330)
==31890==    by 0x452D66: check_fs_root (cmds-check.c:4012)
==31890==    by 0x45E788: check_fs_roots (cmds-check.c:4098)
==31890==    by 0x45E788: cmd_check (cmds-check.c:13031)
==31890==    by 0x40A88A: main (btrfs.c:246)
==31890==  Address 0x5cb7b90 is 16 bytes inside a block of size 50 free'd
==31890==    at 0x4C2C14B: free (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==31890==    by 0x453D08: repair_inode_backrefs (cmds-check.c:2684)
==31890==    by 0x453D08: check_inode_recs (cmds-check.c:3330)
==31890==    by 0x453D08: check_fs_root (cmds-check.c:4012)
==31890==    by 0x45E788: check_fs_roots (cmds-check.c:4098)
==31890==    by 0x45E788: cmd_check (cmds-check.c:13031)
==31890==    by 0x40A88A: main (btrfs.c:246)
==31890==  Block was alloc'd at
==31890==    at 0x4C2AF1F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==31890==    by 0x45055C: get_inode_backref (cmds-check.c:1075)
==31890==    by 0x45055C: add_inode_backref (cmds-check.c:1097)
==31890==    by 0x45180C: process_dir_item (cmds-check.c:1525)
==31890==    by 0x45180C: process_one_leaf (cmds-check.c:1838)
==31890==    by 0x45180C: walk_down_tree (cmds-check.c:2134)
==31890==    by 0x45180C: check_fs_root (cmds-check.c:3957)
==31890==    by 0x45E788: check_fs_roots (cmds-check.c:4098)
==31890==    by 0x45E788: cmd_check (cmds-check.c:13031)
==31890==    by 0x40A88A: main (btrfs.c:246)
==31890==

The repair_inode_backrefs use the backref again after free while iterating over backrefs.
So let it continue to next step after free can fix it.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5cc84690..c910e520 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2666,6 +2666,7 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 			repaired++;
 			list_del(&backref->list);
 			free(backref);
+			continue;
 		}
 
 		if (!delete && !backref->found_dir_index &&
@@ -2676,12 +2677,12 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 				break;
 			repaired++;
 			if (backref->found_dir_item &&
-			    backref->found_dir_index &&
 			    backref->found_dir_index) {
 				if (!backref->errors &&
 				    backref->found_inode_ref) {
 					list_del(&backref->list);
 					free(backref);
+					continue;
 				}
 			}
 		}
-- 
2.12.2



