Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49509 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753195AbeASFhq (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:37:46 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 01/16] btrfs-progs: Moves cmds-check.c to check/main.c
Date: Fri, 19 Jan 2018 13:37:16 +0800
Message-Id: <20180119053731.10795-2-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile                     | 4 ++--
 cmds-check.c => check/main.c | 0
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename cmds-check.c => check/main.c (100%)

diff --git a/Makefile b/Makefile
index 6369e8f4209c..c4e2dc5b68a9 100644
--- a/Makefile
+++ b/Makefile
@@ -109,7 +109,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
+	       cmds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
 	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
@@ -544,7 +544,7 @@ clean: $(CLEANDIRS)
 		kernel-shared/*.o kernel-shared/*.o.d \
 		image/*.o image/*.o.d \
 		convert/*.o convert/*.o.d \
-		mkfs/*.o mkfs/*.o.d \
+		mkfs/*.o mkfs/*.o.d check/*.o check/*.o.d \
 	      dir-test ioctl-test quick-test library-test library-test-static \
               mktables btrfs.static mkfs.btrfs.static fssum \
 	      $(check_defs) \
diff --git a/cmds-check.c b/check/main.c
similarity index 100%
rename from cmds-check.c
rename to check/main.c
-- 
2.15.1

