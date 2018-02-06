Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:53743 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752038AbeBFHCm (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 6 Feb 2018 02:02:42 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 3/3] btrfs-progs: Move check/main.c to cmds-check.c to maintain the subcommand hierarchy
Date: Tue,  6 Feb 2018 15:02:23 +0800
Message-Id: <20180206070223.28791-4-wqu@suse.com>
In-Reply-To: <20180206070223.28791-1-wqu@suse.com>
References: <20180206070223.28791-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmds-check.c is back now, with include files cleaned up.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile                     |  8 ++++----
 check/main.c => cmds-check.c | 17 -----------------
 2 files changed, 4 insertions(+), 21 deletions(-)
 rename check/main.c => cmds-check.c (97%)

diff --git a/Makefile b/Makefile
index f51a8d701a2c..58e894c0171b 100644
--- a/Makefile
+++ b/Makefile
@@ -100,6 +100,7 @@ CHECKER_FLAGS := -include $(check_defs) -D__CHECKER__ \
 	-D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized -Wshadow -Wundef \
 	-U_FORTIFY_SOURCE -Wdeclaration-after-statement -Wdefault-bitfield-sign
 
+check_objects = check/mode-lowmem.o check/mode-original.o check/mode-common.o
 objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
@@ -109,12 +110,11 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
+	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
 	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
-	       mkfs/common.o check/mode-common.o check/mode-lowmem.o \
-	       check/mode-original.o
+	       mkfs/common.o
 libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 		   kernel-lib/crc32c.o messages.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
@@ -391,7 +391,7 @@ btrfs-%: btrfs-%.o $(objects) $(standalone_deps) $(libs_static)
 		$(libs_static) \
 		$(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
 
-btrfs: btrfs.o $(objects) $(cmds_objects) $(libs_static)
+btrfs: btrfs.o $(objects) $(cmds_objects) $(libs_static) $(check_objects)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) $(LIBS_COMP)
 
diff --git a/check/main.c b/cmds-check.c
similarity index 97%
rename from check/main.c
rename to cmds-check.c
index 1bb2142e113e..28746712fac1 100644
--- a/check/main.c
+++ b/cmds-check.c
@@ -16,32 +16,15 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
 #include <getopt.h>
 #include <uuid/uuid.h>
-#include "ctree.h"
 #include "volumes.h"
 #include "repair.h"
 #include "disk-io.h"
-#include "print-tree.h"
 #include "task-utils.h"
 #include "transaction.h"
 #include "utils.h"
-#include "commands.h"
-#include "free-space-cache.h"
-#include "free-space-tree.h"
-#include "btrfsck.h"
 #include "qgroup-verify.h"
-#include "rbtree-utils.h"
-#include "backref.h"
-#include "kernel-shared/ulist.h"
-#include "hash.h"
 #include "help.h"
 #include "check/mode-common.h"
 #include "check/mode-original.h"
-- 
2.16.1

