Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:32838 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbeILTvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 15:51:05 -0400
Received: from mail.tty0.ch (hermes.tty0.ch [172.21.1.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fe1.digint.ch (Postfix) with ESMTPS id 0A76A30966
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 16:47:12 +0200 (CEST)
From: Axel Burri <axel@tty0.ch>
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [RFC PATCH v2 3/4] btrfs-progs: Makefile: add extra objects definitions for separated binaries
Date: Wed, 12 Sep 2018 16:46:03 +0200
Message-Id: <20180912144604.6178-4-axel@tty0.ch>
In-Reply-To: <20180912144604.6178-1-axel@tty0.ch>
References: <20180912144604.6178-1-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some separated binaries have references to specific command objects
($cmds_objects). Add these dependencies in the Makefile, and use them
in the linker target (as in target "btrfs-%:").

Fixes linkage errors for these subcommands. The "make separated"
target now builds without errors.

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Makefile b/Makefile
index 95db571b..362550c9 100644
--- a/Makefile
+++ b/Makefile
@@ -249,6 +249,15 @@ sc_cmds_all := $(sort $(foreach val,$(sc_map),$(firstword $(subst @, ,$(val)))))
 sc_cmds := $(filter-out $(sc_exclude),$(sc_cmds_all))
 sc_cmds_fscaps := $(sort $(subst @fscaps,,$(filter %@fscaps,$(subst :, ,$(sc_map)))))
 
+# Additional cmds_objects required for separated binaries
+btrfs_device_add_objects = mkfs/common.o
+btrfs_device_usage_objects = cmds-fi-usage.o
+btrfs_filesystem_show_objects = cmds-fi-usage.o
+btrfs_replace_start_objects = mkfs/common.o
+btrfs_rescue_super_recover_objects = super-recover.o
+btrfs_rescue_chunk_recover_objects = check/mode-lowmem.o check/mode-common.o check/main.o chunk-recover.o
+btrfs_restore_objects = $(LIBS_COMP)
+
 # Using suffix allows strict distinction in targets below (btrfs-%.separated[.o])
 progs_separated = $(addsuffix .separated,$(sc_cmds))
 progs_separated_fscaps = $(addsuffix .separated,$(sc_cmds_fscaps))
@@ -504,6 +513,7 @@ btrfs-%.static: btrfs-%.static.o $(static_objects) $(patsubst %.o,%.static.o,$(s
 btrfs-%.separated: btrfs-%.separated.o $(objects) $(cmds_objects) $(libs_static)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $@.o $(objects) $(libs_static) \
+		$($(subst -,_,$(@:%.separated=%)-objects)) \
 		$(LDFLAGS) $(LIBS)
 
 btrfs-%: btrfs-%.o $(objects) $(standalone_deps) $(libs_static)
-- 
2.16.4
