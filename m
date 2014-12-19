Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55355 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLSFcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 00:32:11 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 7F9293EE0BB
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:32:09 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 79B3CAC07E7
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:32:08 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 25FAAE08001
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:32:08 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
	by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 5395B584396
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:32:07 +0900 (JST)
Message-ID: <5493B84A.6080100@jp.fujitsu.com>
Date: Fri, 19 Dec 2014 14:31:54 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: cleanup: avoid to use literal for getopt val
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
Tested with dev/integration-20141218 + this patch
---
 cmds-fi-disk_usage.c | 8 ++++----
 cmds-filesystem.c    | 8 ++++----
 utils.h              | 3 +++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index d81f011..5e8e39b 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -877,8 +877,8 @@ int cmd_filesystem_usage(int argc, char **argv)
 			{ "mbytes", no_argument, NULL, 'm'},
 			{ "gbytes", no_argument, NULL, 'g'},
 			{ "tbytes", no_argument, NULL, 't'},
-			{ "si", no_argument, NULL, 256},
-			{ "iec", no_argument, NULL, 257},
+			{ "si", no_argument, NULL, GETOPT_VAL_SI},
+			{ "iec", no_argument, NULL, GETOPT_VAL_IEC},
 		};
 		int c = getopt_long(argc, argv, "bhHkmgtT", long_options,
 				&long_index);
@@ -907,10 +907,10 @@ int cmd_filesystem_usage(int argc, char **argv)
 		case 'H':
 			unit_mode = UNITS_HUMAN_DECIMAL;
 			break;
-		case 256:
+		case GETOPT_VAL_SI:
 			units_set_mode(&unit_mode, UNITS_DECIMAL);
 			break;
-		case 257:
+		case GETOPT_VAL_IEC:
 			units_set_mode(&unit_mode, UNITS_BINARY);
 			break;
 		case 'T':
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7eaccb9..8f037dd 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -216,8 +216,8 @@ static int cmd_filesystem_df(int argc, char **argv)
 			{ "mbytes", no_argument, NULL, 'm'},
 			{ "gbytes", no_argument, NULL, 'g'},
 			{ "tbytes", no_argument, NULL, 't'},
-			{ "si", no_argument, NULL, 256},
-			{ "iec", no_argument, NULL, 257},
+			{ "si", no_argument, NULL, GETOPT_VAL_SI},
+			{ "iec", no_argument, NULL, GETOPT_VAL_IEC},
 		};
 		int c = getopt_long(argc, argv, "bhHkmgt", long_options,
 					&long_index);
@@ -245,10 +245,10 @@ static int cmd_filesystem_df(int argc, char **argv)
 		case 'H':
 			unit_mode = UNITS_HUMAN_DECIMAL;
 			break;
-		case 256:
+		case GETOPT_VAL_SI:
 			units_set_mode(&unit_mode, UNITS_DECIMAL);
 			break;
-		case 257:
+		case GETOPT_VAL_IEC:
 			units_set_mode(&unit_mode, UNITS_BINARY);
 			break;
 		default:
diff --git a/utils.h b/utils.h
index 0464c2d..34fd5e4 100644
--- a/utils.h
+++ b/utils.h
@@ -40,6 +40,9 @@
 
 #define ARGV0_BUF_SIZE	PATH_MAX
 
+#define GETOPT_VAL_SI	256
+#define GETOPT_VAL_IEC	257
+
 int check_argc_exact(int nargs, int expected);
 int check_argc_min(int nargs, int expected);
 int check_argc_max(int nargs, int expected);
-- 
1.8.3.1

