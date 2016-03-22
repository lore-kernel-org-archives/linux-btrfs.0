Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbcCVRfB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 13:35:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 56066AC64
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 17:34:59 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: fix build of standalone utilities after clean
Date: Tue, 22 Mar 2016 18:34:26 +0100
Message-Id: <1458668066-27136-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ make clean
$ make btrfs-debug-tree

will fail because the dependency from $(btrfs_debug_tree_objects) is
missing. The variable standalone_deps magically collects all the deps
and will build them in advance. The simple fix to use the existing
substitution based on $@ does not work for pattern rules, as Noah found
out.

Reported-by: Noah Massey <nmassey@kmbs.konicaminolta.us>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 Makefile.in | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 71ef76d4fd4e..0a1aece70dab 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -130,6 +130,9 @@ btrfs_debug_tree_objects = cmds-inspect-dump-tree.o
 btrfs_show_super_objects = cmds-inspect-dump-super.o
 btrfs_calc_size_objects = cmds-inspect-tree-stats.o
 
+# collect values of the variables above
+standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs)))),$($(dep)))
+
 SUBDIRS =
 BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
 INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
@@ -256,14 +259,14 @@ $(libs_static): $(libbtrfs_objects)
 # For static variants, use an extra $(subst) to get rid of the ".static"
 # from the target name before translating to list of libs
 
-btrfs-%.static: $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects)
+btrfs-%.static: $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects) $(patsubst %.o,%.static.o,$(standalone_deps))
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(STATIC_CFLAGS) -o $@ $@.o $(static_objects) \
 		$(patsubst %.o, %.static.o, $($(subst -,_,$(subst .static,,$@)-objects))) \
 		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) \
 		$($(subst -,_,$(subst .static,,$@)-libs)) $(STATIC_LIBS)
 
-btrfs-%: $(objects) $(libs_static) btrfs-%.o
+btrfs-%: $(objects) $(libs_static) btrfs-%.o $(standalone_deps)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o \
 		$($(subst -,_,$@-objects)) \
-- 
2.7.1

