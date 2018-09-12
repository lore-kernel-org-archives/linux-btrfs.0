Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:32834 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbeILTvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 15:51:05 -0400
Received: from mail.tty0.ch (hermes.tty0.ch [172.21.1.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fe1.digint.ch (Postfix) with ESMTPS id 038AC30966
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 16:47:11 +0200 (CEST)
From: Axel Burri <axel@tty0.ch>
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [RFC PATCH v2 2/4] btrfs-progs: remove unneeded dependencies on separated build (-DBTRFS_SEPARATED_BUILD)
Date: Wed, 12 Sep 2018 16:46:02 +0200
Message-Id: <20180912144604.6178-3-axel@tty0.ch>
In-Reply-To: <20180912144604.6178-1-axel@tty0.ch>
References: <20180912144604.6178-1-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove references to unneeded symbols when building separated
subcommands: "btrfs-*.separated.o".

Note that this patch still leaves unreferenced static symbols, which
in turn makes the compiler warn about "unused function/variable".
Stripping all symbols would imply adaptions in the source code
(especially by moving "int handle_command_group" functionality into a
separate compile unit).

This is not a problem, ignore these warnings when building object:

    $(CC) -Wno-unused-function -Wno-unused-const-variable

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 Makefile          | 2 +-
 cmds-balance.c    | 2 ++
 cmds-device.c     | 2 ++
 cmds-filesystem.c | 2 ++
 cmds-inspect.c    | 2 ++
 cmds-property.c   | 2 ++
 cmds-qgroup.c     | 2 ++
 cmds-quota.c      | 2 ++
 cmds-replace.c    | 2 ++
 cmds-rescue.c     | 2 ++
 cmds-scrub.c      | 2 ++
 cmds-subvolume.c  | 2 ++
 commands.h        | 8 --------
 13 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 35666ec9..95db571b 100644
--- a/Makefile
+++ b/Makefile
@@ -338,7 +338,7 @@ endif
 # BTRFS_SEPARATED_BUILD), using "cfile" from sc_map (cmd-xxx.c) as gcc infile.
 btrfs-%.separated.o: $(call sc_get,$(@:%.separated.o=%),cfile)
 	@echo "    [CC]     $@"
-	$(Q)$(CC) $(CFLAGS) \
+	$(Q)$(CC) $(CFLAGS) -Wno-unused-function -Wno-unused-const-variable \
 		-DBTRFS_SEPARATED_BUILD \
 		-DBTRFS_SEPARATED_ENTRY=$(call sc_get,$(@:%.separated.o=%),entry) \
 		-DBTRFS_SEPARATED_USAGE=$(call sc_get,$(@:%.separated.o=%),entry)_usage \
diff --git a/cmds-balance.c b/cmds-balance.c
index 6cc26c35..72292bc8 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -914,6 +914,7 @@ static int cmd_balance_full(int argc, char **argv)
 static const char balance_cmd_group_info[] =
 "balance data across devices, or change block groups using filters";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group balance_cmd_group = {
 	balance_cmd_group_usage, balance_cmd_group_info, {
 		{ "start", cmd_balance_start, cmd_balance_start_usage, NULL, 0 },
@@ -940,3 +941,4 @@ int cmd_balance(int argc, char **argv)
 
 	return handle_command_group(&balance_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-device.c b/cmds-device.c
index 2a05f70a..719afc01 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -597,6 +597,7 @@ static int cmd_device_usage(int argc, char **argv)
 static const char device_cmd_group_info[] =
 "manage and query devices in the filesystem";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group device_cmd_group = {
 	device_cmd_group_usage, device_cmd_group_info, {
 		{ "add", cmd_device_add, cmd_device_add_usage, NULL, 0 },
@@ -616,3 +617,4 @@ int cmd_device(int argc, char **argv)
 {
 	return handle_command_group(&device_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 06c8311b..be5d50f2 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1182,6 +1182,7 @@ static int cmd_filesystem_label(int argc, char **argv)
 static const char filesystem_cmd_group_info[] =
 "overall filesystem tasks and information";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, filesystem_cmd_group_info, {
 		{ "df", cmd_filesystem_df, cmd_filesystem_df_usage, NULL, 0 },
@@ -1209,3 +1210,4 @@ int cmd_filesystem(int argc, char **argv)
 {
 	return handle_command_group(&filesystem_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-inspect.c b/cmds-inspect.c
index ac77a5ee..1ad48548 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -634,6 +634,7 @@ out:
 static const char inspect_cmd_group_info[] =
 "query various internal information";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group inspect_cmd_group = {
 	inspect_cmd_group_usage, inspect_cmd_group_info, {
 		{ "inode-resolve", cmd_inspect_inode_resolve,
@@ -660,3 +661,4 @@ int cmd_inspect(int argc, char **argv)
 {
 	return handle_command_group(&inspect_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-property.c b/cmds-property.c
index 03bafa05..c98e8ebb 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -408,6 +408,7 @@ static int cmd_property_list(int argc, char **argv)
 static const char property_cmd_group_info[] =
 "modify properties of filesystem objects";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group property_cmd_group = {
 	property_cmd_group_usage, property_cmd_group_info, {
 		{ "get", cmd_property_get,
@@ -424,3 +425,4 @@ int cmd_property(int argc, char **argv)
 {
 	return handle_command_group(&property_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 554f2bf2..5f5a3563 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -503,6 +503,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 static const char qgroup_cmd_group_info[] =
 "manage quota groups";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group qgroup_cmd_group = {
 	qgroup_cmd_group_usage, qgroup_cmd_group_info, {
 		{ "assign", cmd_qgroup_assign, cmd_qgroup_assign_usage,
@@ -525,3 +526,4 @@ int cmd_qgroup(int argc, char **argv)
 {
 	return handle_command_group(&qgroup_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-quota.c b/cmds-quota.c
index c9ea9c0f..8585d427 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -194,6 +194,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 static const char quota_cmd_group_info[] =
 "manage filesystem quota settings";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group quota_cmd_group = {
 	quota_cmd_group_usage, quota_cmd_group_info, {
 		{ "enable", cmd_quota_enable, cmd_quota_enable_usage, NULL, 0 },
@@ -208,3 +209,4 @@ int cmd_quota(int argc, char **argv)
 {
 	return handle_command_group(&quota_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-replace.c b/cmds-replace.c
index 1fa80284..44456c4a 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -545,6 +545,7 @@ static int cmd_replace_cancel(int argc, char **argv)
 static const char replace_cmd_group_info[] =
 "replace a device in the filesystem";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group replace_cmd_group = {
 	replace_cmd_group_usage, replace_cmd_group_info, {
 		{ "start", cmd_replace_start, cmd_replace_start_usage, NULL,
@@ -561,3 +562,4 @@ int cmd_replace(int argc, char **argv)
 {
 	return handle_command_group(&replace_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-rescue.c b/cmds-rescue.c
index 38c4ab9b..bdc6dd4b 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -253,6 +253,7 @@ out:
 static const char rescue_cmd_group_info[] =
 "toolbox for specific rescue operations";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group rescue_cmd_group = {
 	rescue_cmd_group_usage, rescue_cmd_group_info, {
 		{ "chunk-recover", cmd_rescue_chunk_recover,
@@ -270,3 +271,4 @@ int cmd_rescue(int argc, char **argv)
 {
 	return handle_command_group(&rescue_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 6b909f20..e418f907 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1788,6 +1788,7 @@ out:
 static const char scrub_cmd_group_info[] =
 "verify checksums of data and metadata";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group scrub_cmd_group = {
 	scrub_cmd_group_usage, scrub_cmd_group_info, {
 		{ "start", cmd_scrub_start, cmd_scrub_start_usage, NULL, 0 },
@@ -1802,3 +1803,4 @@ int cmd_scrub(int argc, char **argv)
 {
 	return handle_command_group(&scrub_cmd_group, argc, argv);
 }
+#endif
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index a4202ec9..15dbdf3a 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1226,6 +1226,7 @@ out:
 static const char subvolume_cmd_group_info[] =
 "manage subvolumes: create, delete, list, etc";
 
+#ifndef BTRFS_SEPARATED_BUILD
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, subvolume_cmd_group_info, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -1249,3 +1250,4 @@ int cmd_subvolume(int argc, char **argv)
 {
 	return handle_command_group(&subvolume_cmd_group, argc, argv);
 }
+#endif
diff --git a/commands.h b/commands.h
index c9901de9..35081b94 100644
--- a/commands.h
+++ b/commands.h
@@ -132,14 +132,6 @@ int cmd_rescue(int argc, char **argv);
 #include "help.h"
 #endif
 
-/* Note: handle_command_group is defined in btrfs.c and cannot be
- * linked with separated subcommands because btrfs.o also contains a
- * "main" symbol. As a workaround, we simply return 1 (error) for
- * calls to handle_command_group() here (which is fine as this
- * functionality is not required for BTRFS_SEPARATED_BUILD commands).
- */
-#define handle_command_group(cmd_group,argc,argv) 1
-
 /* forward declaration of main entry point (non-static are already declared above) */
 #ifdef BTRFS_SEPARATED_STATIC_ENTRY
 static int BTRFS_SEPARATED_ENTRY(int argc, char **argv);
-- 
2.16.4
