Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36774 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaKYP5l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 10:57:41 -0500
Received: by mail-wi0-f178.google.com with SMTP id hi2so1931930wib.11
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 07:57:40 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/4] Add the btrfs chunk list command
Date: Tue, 25 Nov 2014 16:57:24 +0100
Message-Id: <1416931045-24259-4-git-send-email-kreijack@inwind.it>
In-Reply-To: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the 'btrfs chunk' groups command.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile   | 2 +-
 btrfs.c    | 1 +
 commands.h | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 4cae30c..1744f9c 100644
--- a/Makefile
+++ b/Makefile
@@ -15,7 +15,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
-	       cmds-property.o
+	       cmds-property.o cmds-chunk.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/btrfs.c b/btrfs.c
index e83349c..25fbb71 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -197,6 +197,7 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "check", cmd_check, cmd_check_usage, NULL, 0 },
+		{ "chunk", cmd_chunk, NULL, &chunk_cmd_group, 0 },
 		{ "rescue", cmd_rescue, NULL, &rescue_cmd_group, 0 },
 		{ "restore", cmd_restore, cmd_restore_usage, NULL, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
diff --git a/commands.h b/commands.h
index 4d870f6..41d69b0 100644
--- a/commands.h
+++ b/commands.h
@@ -80,6 +80,7 @@ extern const struct cmd_group filesystem_cmd_group;
 extern const struct cmd_group balance_cmd_group;
 extern const struct cmd_group device_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
+extern const struct cmd_group chunk_cmd_group;
 extern const struct cmd_group inspect_cmd_group;
 extern const struct cmd_group property_cmd_group;
 extern const struct cmd_group quota_cmd_group;
@@ -101,6 +102,7 @@ int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
 int cmd_check(int argc, char **argv);
+int cmd_chunk(int argc, char **argv);
 int cmd_chunk_recover(int argc, char **argv);
 int cmd_super_recover(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
-- 
2.1.3

