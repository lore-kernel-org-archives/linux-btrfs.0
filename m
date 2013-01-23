Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab3AWLFu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 06:05:50 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0NB5mvk006828
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2013 19:05:48 +0800
Message-ID: <50FFC3D1.3020307@cn.fujitsu.com>
Date: Wed, 23 Jan 2013 19:04:49 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: Complete the help information of btrfs send/receive
References: <50FFA5FE.9070000@cn.fujitsu.com>
In-Reply-To: <50FFA5FE.9070000@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Date: Fri, 18 Jan 2013 14:52:12 +0800
Subject: [PATCH] Btrfs-progs: Complete the help information of btrfs
 send/receive

When typing command "btrfs send --help" or "btrfs receive --help",
the help information of the commands is incomplete, which only
shows a short usage.

This patch helps to display the complete infomation of the commands.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
 btrfs.c        |    4 ++--
 cmds-receive.c |    6 +++---
 cmds-send.c    |   13 +++----------
 commands.h     |    3 +++
 4 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 687acec..f26ddb0 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -247,8 +247,8 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
-		{ "send", cmd_send, NULL, &send_cmd_group, 0 },
-		{ "receive", cmd_receive, NULL, &receive_cmd_group, 0 },
+		{ "send", cmd_send, cmd_send_usage, NULL, 0 },
+		{ "receive", cmd_receive, cmd_receive_usage, NULL, 0 },
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..2b9d359 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -879,8 +879,8 @@ static const char * const receive_cmd_group_usage[] = {
 	NULL
 };
 
-static const char * const cmd_receive_usage[] = {
-	"btrfs receive [-v] [-i <infile>] <mount>",
+const char * const cmd_receive_usage[] = {
+	"btrfs receive [-v] [-f <infile>] <mount>",
 	"Receive subvolumes from stdin.",
 	"Receives one or more subvolumes that were previously ",
 	"sent with btrfs send. The received subvolumes are stored",
@@ -891,7 +891,7 @@ static const char * const cmd_receive_usage[] = {
 	"After receiving a subvolume, it is immediately set to",
 	"read only.\n",
 	"-v               Enable verbose debug output. Each",
-	"                 occurrency of this option increases the",
+	"                 occurrence of this option increases the",
 	"                 verbose level more.",
 	"-f <infile>      By default, btrfs receive uses stdin",
 	"                 to receive the subvolumes. Use this",
diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..b4e0a55 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -613,7 +613,7 @@ static const char * const send_cmd_group_usage[] = {
 	NULL
 };
 
-static const char * const cmd_send_usage[] = {
+const char * const cmd_send_usage[] = {
 	"btrfs send [-v] [-i <subvol>] [-p <parent>] <subvol>",
 	"Send the subvolume to stdout.",
 	"Sends the subvolume specified by <subvol> to stdout.",
@@ -628,12 +628,12 @@ static const char * const cmd_send_usage[] = {
 	"A manually specified snapshot parent is also regarded",
 	"as 'clone source'.\n",
 	"-v               Enable verbose debug output. Each",
-	"                 occurrency of this option increases the",
+	"                 occurrence of this option increases the",
 	"                 verbose level more.",
 	"-i <subvol>      Informs btrfs send that this subvolume,",
 	"                 can be taken as 'clone source'. This can",
 	"                 be used for incremental sends.",
-	"-p <subvol>      Disable automatic snaphot parent",
+	"-p <subvol>      Disable automatic snapshot parent",
 	"                 determination and use <subvol> as parent.",
 	"                 This subvolume is also added to the list",
 	"                 of 'clone sources' (see -i).",
@@ -643,13 +643,6 @@ static const char * const cmd_send_usage[] = {
 	NULL
 };
 
-const struct cmd_group send_cmd_group = {
-	send_cmd_group_usage, NULL, {
-		{ "send", cmd_send_start, cmd_send_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 },
-        },
-};
-
 int cmd_send(int argc, char **argv)
 {
 	return cmd_send_start(argc, argv);
diff --git a/commands.h b/commands.h
index bb6d2dd..605c90a 100644
--- a/commands.h
+++ b/commands.h
@@ -93,6 +93,9 @@ extern const struct cmd_group receive_cmd_group;
 extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
 
+extern const char * const cmd_send_usage[];
+extern const char * const cmd_receive_usage[];
+
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
 int cmd_balance(int argc, char **argv);
-- 
1.7.7.6



