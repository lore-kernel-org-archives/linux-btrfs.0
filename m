Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35590 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752857AbdLWU7B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 15:59:01 -0500
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 609C620278
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 21:52:38 +0100 (CET)
From: Hans van Kranenburg <hans@knorrie.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: Fix progs_extra build dependencies
Date: Sat, 23 Dec 2017 21:52:37 +0100
Message-Id: <20171223205238.19678-2-hans@knorrie.org>
In-Reply-To: <20171223205238.19678-1-hans@knorrie.org>
References: <20171223205238.19678-1-hans@knorrie.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The Makefile does not have a dependency path that builds dependencies
for tools listed in progs_extra.

E.g. doing make btrfs-show-super in a clean build environment results in:
    gcc: error: cmds-inspect-dump-super.o: No such file or directory
    Makefile:389: recipe for target 'btrfs-show-super' failed

Signed-off-by: Hans van Kranenburg <hans@knorrie.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 30a0ee22..390b138f 100644
--- a/Makefile
+++ b/Makefile
@@ -220,7 +220,7 @@ cmds_restore_cflags = -DBTRFSRESTORE_ZSTD=$(BTRFSRESTORE_ZSTD)
 CHECKER_FLAGS += $(btrfs_convert_cflags)
 
 # collect values of the variables above
-standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs)))),$($(dep)))
+standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs) $(progs_extra)))),$($(dep)))
 
 SUBDIRS =
 BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
-- 
2.11.0

