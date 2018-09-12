Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:32830 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbeILTvE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 15:51:04 -0400
Received: from mail.tty0.ch (hermes.tty0.ch [172.21.1.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fe1.digint.ch (Postfix) with ESMTPS id E336B30966
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 16:47:09 +0200 (CEST)
From: Axel Burri <axel@tty0.ch>
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [RFC PATCH v2 1/4] btrfs-progs: Makefile: create separated binaries for "btrfs" subcommands; add fscaps declarations
Date: Wed, 12 Sep 2018 16:46:01 +0200
Message-Id: <20180912144604.6178-2-axel@tty0.ch>
In-Reply-To: <20180912144604.6178-1-axel@tty0.ch>
References: <20180912144604.6178-1-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Create separate binaries "btrfs-xxx-yyy.separated" for each subcommand
"btrfs xxx yyy". Also declares fscaps for (supported) subcommands.
This is useful for admins to provide specific subcommand binaries with
elevated privileges (capabilities(7), suid).

Example:

    # make separated-fscaps
    # make list-fscaps
    # ./btrfs-subvolume-list.separated
    # ./btrfs-send.separated
    <...>
    # make -k separated

A list of subcommands is assembled in the makefile by matching main
entry points and generic "@SEPARATED" tags in "cmds-*.c", e.g.:

    // @SEPARATED btrfs-subvolume-delete fscaps: cap_sys_admin,cap_dac_override
    static int cmd_subvol_delete(int argc, char **argv)

A patch in "commands.h" adds a "int main()" symbol and tweaks for
building separated binaries if BTRFS_SEPARATED_BUILD and
BTRFS_SEPARATED_ENTRY are defined. These defines are set generically
for each subcommand in the "btrfs-%.separated.o" makefile target.

Makefile targets:

 - "btrfs-%.separated": builds a separated binary for a specific btrfs
   subcommand (see "make list-separated").

 - `make -k separated`: builds all separated (btrfs-xxx-yyy.separated)
   binaries. Note: some targets fail with "ld: undefined reference"
   errors (will be fixed in later commit).

 - `make separated-fscaps`: build separated binaries for subcommands
   declaring "@SEPARATED btrfs-xxx fscaps" (comments) within the
   c-file (for sysadmins / package maintainer).

 - `make list-separated`: print a list of supported subcommands.

 - `make list-fscaps`: print fscaps required for setcap(8). Note that
   this list only covers some basic subcommands (the ones used by
   btrbk-0.26.1 "backend btrfs-progs-btrbk") and needs to be improved.

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 .gitignore       |  1 +
 Makefile         | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-usage.c  |  1 +
 cmds-qgroup.c    |  1 +
 cmds-receive.c   |  1 +
 cmds-send.c      |  1 +
 cmds-subvolume.c |  4 ++++
 commands.h       | 45 +++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 107 insertions(+)

diff --git a/.gitignore b/.gitignore
index 144ebb3b..e1eb1341 100644
--- a/.gitignore
+++ b/.gitignore
@@ -10,6 +10,7 @@ Documentation/*.gz
 Documentation/*.html
 btrfs
 btrfs.static
+btrfs-*.separated
 btrfs-map-logical
 btrfs-fragments
 btrfsck
diff --git a/Makefile b/Makefile
index fcfc815a..35666ec9 100644
--- a/Makefile
+++ b/Makefile
@@ -2,6 +2,7 @@
 # Basic build targets:
 #   all		all main tools and the shared library
 #   static      build static bnaries, requires static version of the libraries
+#   separated   build separated binary for each "btrfs" subcommand
 #   test        run the full testsuite
 #   install     install to default location (/usr/local)
 #   clean       clean built binaries (not the documentation)
@@ -231,6 +232,27 @@ progs_install =
 progs_build =
 endif
 
+# Parse "int cmd_xxx_yyy(int argc, char **argv)" lines in cfiles, and
+# create whitespace separated map of form: "btrfs-xxx-yyy@key:value".
+sc_cfiles := $(wildcard cmds-*.c)
+sc_map := $(foreach file,$(sc_cfiles),$(shell sed -rn 's/^(static )?int cmd_([a-z_]+)\(int argc, char.*argv.*\)$$/btrfs_\2@cfile:$(file) btrfs_\2@entry:cmd_\2 btrfs_\2@static_entry:\1/p' $(file)))
+sc_map := $(foreach val,$(sc_map),$(subst _,-,$(firstword $(subst @, ,$(val))))@$(word 2,$(subst @, ,$(val))))
+sc_map := $(subst btrfs-subvol-,btrfs-subvolume-,$(sc_map))
+
+# Parse generic "@SEPARATED btrfs-xxx-yyy key: value" in cfiles, and add to map.
+sc_map += $(shell sed -rn 's/^.*@SEPARATED\s+(btrfs-[a-z-]+)\s+([a-z_]+):\s*(.*)$$/\1@\2:\3/p' $(sc_cfiles))
+sc_get = $(word 2,$(subst :, ,$(filter $(1)@$(2):%,$(sc_map))))
+
+# Exclude first-level commands relying on "int handle_command_group()" or buggy
+sc_exclude = btrfs-balance btrfs-balance-full btrfs-device btrfs-filesystem btrfs-inspect btrfs-property btrfs-qgroup btrfs-quota btrfs-replace btrfs-rescue btrfs-scrub btrfs-subvolume
+sc_cmds_all := $(sort $(foreach val,$(sc_map),$(firstword $(subst @, ,$(val)))))
+sc_cmds := $(filter-out $(sc_exclude),$(sc_cmds_all))
+sc_cmds_fscaps := $(sort $(subst @fscaps,,$(filter %@fscaps,$(subst :, ,$(sc_map)))))
+
+# Using suffix allows strict distinction in targets below (btrfs-%.separated[.o])
+progs_separated = $(addsuffix .separated,$(sc_cmds))
+progs_separated_fscaps = $(addsuffix .separated,$(sc_cmds_fscaps))
+
 # external libs required by various binaries; for btrfs-foo,
 # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
 btrfs_convert_cflags = -DBTRFSCONVERT_EXT2=$(BTRFSCONVERT_EXT2)
@@ -312,6 +334,17 @@ endif
 	$(Q)$(CC) $(CFLAGS) -c $< -o $@ $($(subst -,_,$(@:%.o=%)-cflags)) \
 		$($(subst -,_,btrfs-$(@:%/$(notdir $@)=%)-cflags))
 
+# Compile target objects providing main() symbol (see commands.h:
+# BTRFS_SEPARATED_BUILD), using "cfile" from sc_map (cmd-xxx.c) as gcc infile.
+btrfs-%.separated.o: $(call sc_get,$(@:%.separated.o=%),cfile)
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(CFLAGS) \
+		-DBTRFS_SEPARATED_BUILD \
+		-DBTRFS_SEPARATED_ENTRY=$(call sc_get,$(@:%.separated.o=%),entry) \
+		-DBTRFS_SEPARATED_USAGE=$(call sc_get,$(@:%.separated.o=%),entry)_usage \
+		$(if $(call sc_get,$(@:%.separated.o=%),static_entry),-DBTRFS_SEPARATED_STATIC_ENTRY) \
+		-c $(call sc_get,$(@:%.separated.o=%),cfile) -o $@
+
 %.static.o: %.c
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(STATIC_CFLAGS) -c $< -o $@ $($(subst -,_,$(@:%.static.o=%)-cflags)) \
@@ -384,6 +417,20 @@ endif
 #
 static: $(progs_static)
 
+separated: $(progs_separated)
+
+separated-fscaps: $(progs_separated_fscaps)
+
+.PHONY: separated separated-fscaps
+
+list-separated:
+	@echo "$(sc_cmds)" | tr ' ' '\n'
+
+list-fscaps:
+	@echo "$(foreach sc,$(sc_cmds_fscaps),$(sc)=$(call sc_get,$(sc),fscaps))" | tr ' ' '\n'
+
+.PHONY: list-separated list-fscaps
+
 version.h: version.h.in configure.ac
 	@echo "    [SH]     $@"
 	$(Q)bash ./config.status --silent $@
@@ -454,6 +501,11 @@ btrfs-%.static: btrfs-%.static.o $(static_objects) $(patsubst %.o,%.static.o,$(s
 		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) \
 		$($(subst -,_,$(subst .static,,$@)-libs)) $(STATIC_LIBS)
 
+btrfs-%.separated: btrfs-%.separated.o $(objects) $(cmds_objects) $(libs_static)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) -o $@ $@.o $(objects) $(libs_static) \
+		$(LDFLAGS) $(LIBS)
+
 btrfs-%: btrfs-%.o $(objects) $(standalone_deps) $(libs_static)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $(objects) $@.o \
@@ -618,6 +670,7 @@ clean: $(CLEANDIRS)
 	      $(check_defs) \
 	      $(libs) $(lib_links) \
 	      $(progs_static) \
+	      $(progs_separated) \
 	      libbtrfsutil/*.o libbtrfsutil/*.o.d
 ifeq ($(PYTHON_BINDINGS),1)
 	$(Q)cd libbtrfsutil/python; \
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index dca2e8d0..f44dfe54 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -964,6 +964,7 @@ const char * const cmd_filesystem_usage_usage[] = {
 	NULL
 };
 
+// @SEPARATED btrfs-filesystem-usage fscaps: cap_sys_admin
 int cmd_filesystem_usage(int argc, char **argv)
 {
 	int ret = 0;
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index b928edc7..554f2bf2 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -259,6 +259,7 @@ static const char * const cmd_qgroup_destroy_usage[] = {
 	NULL
 };
 
+// @SEPARATED btrfs-qgroup-destroy fscaps: cap_sys_admin,cap_dac_override
 static int cmd_qgroup_destroy(int argc, char **argv)
 {
 	int ret;
diff --git a/cmds-receive.c b/cmds-receive.c
index 34d51ef3..04aaad6c 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1248,6 +1248,7 @@ out:
 	return ret;
 }
 
+// @SEPARATED btrfs-receive fscaps: cap_sys_admin,cap_fowner,cap_chown,cap_mknod,cap_setfcap,cap_dac_override,cap_dac_read_search
 int cmd_receive(int argc, char **argv)
 {
 	char *tomnt = NULL;
diff --git a/cmds-send.c b/cmds-send.c
index 16b9f8d2..259faeff 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -489,6 +489,7 @@ static void free_send_info(struct btrfs_send *sctx)
 	subvol_uuid_search_finit(&sctx->sus);
 }
 
+// @SEPARATED btrfs-send fscaps: cap_sys_admin,cap_fowner,cap_dac_read_search
 int cmd_send(int argc, char **argv)
 {
 	char *subvol = NULL;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e7a884af..a4202ec9 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -231,6 +231,7 @@ static const char * const cmd_subvol_delete_usage[] = {
 	NULL
 };
 
+// @SEPARATED btrfs-subvolume-delete fscaps: cap_sys_admin,cap_dac_override
 static int cmd_subvol_delete(int argc, char **argv)
 {
 	int res, ret = 0;
@@ -451,6 +452,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	NULL,
 };
 
+// @SEPARATED btrfs-subvolume-list fscaps: cap_sys_admin,cap_fowner,cap_dac_read_search
 static int cmd_subvol_list(int argc, char **argv)
 {
 	struct btrfs_list_filter_set *filter_set;
@@ -623,6 +625,7 @@ static const char * const cmd_subvol_snapshot_usage[] = {
 	NULL
 };
 
+// @SEPARATED btrfs-subvolume-snapshot fscaps: cap_sys_admin,cap_fowner,cap_dac_override,cap_dac_read_search
 static int cmd_subvol_snapshot(int argc, char **argv)
 {
 	char	*subvol, *dst;
@@ -920,6 +923,7 @@ static const char * const cmd_subvol_show_usage[] = {
 	NULL
 };
 
+// @SEPARATED btrfs-subvolume-show fscaps: cap_sys_admin,cap_fowner,cap_dac_read_search
 static int cmd_subvol_show(int argc, char **argv)
 {
 	char tstr[256];
diff --git a/commands.h b/commands.h
index 76991f2b..c9901de9 100644
--- a/commands.h
+++ b/commands.h
@@ -121,4 +121,49 @@ int cmd_dump_super(int argc, char **argv);
 int cmd_debug_tree(int argc, char **argv);
 int cmd_rescue(int argc, char **argv);
 
+
+#ifdef BTRFS_SEPARATED_BUILD
+
+#ifndef BTRFS_SEPARATED_ENTRY
+#error please define BTRFS_SEPARATED_ENTRY (see Makefile: "btrfs-%.separated.o" target)
+#endif
+
+#ifdef BTRFS_SEPARATED_USAGE
+#include "help.h"
+#endif
+
+/* Note: handle_command_group is defined in btrfs.c and cannot be
+ * linked with separated subcommands because btrfs.o also contains a
+ * "main" symbol. As a workaround, we simply return 1 (error) for
+ * calls to handle_command_group() here (which is fine as this
+ * functionality is not required for BTRFS_SEPARATED_BUILD commands).
+ */
+#define handle_command_group(cmd_group,argc,argv) 1
+
+/* forward declaration of main entry point (non-static are already declared above) */
+#ifdef BTRFS_SEPARATED_STATIC_ENTRY
+static int BTRFS_SEPARATED_ENTRY(int argc, char **argv);
+static const char * const BTRFS_SEPARATED_USAGE [];
+#endif
+
+int main(int argc, char **argv)
+{
+	int i;
+	for (i = 1; i < argc; i++) {
+#ifdef BTRFS_SEPARATED_USAGE
+		if (strcmp(argv[i], "--help") == 0) {
+			usage(BTRFS_SEPARATED_USAGE);
+			return 0;
+		}
+#endif
+		if (strcmp(argv[i], "--version") == 0) {
+			printf("%s\n", PACKAGE_STRING);
+			return 0;
+		}
+	}
+	return BTRFS_SEPARATED_ENTRY (argc, argv);
+}
+
+#endif  /* BTRFS_SEPARATED_BUILD */
+
 #endif
-- 
2.16.4
