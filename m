Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:62333 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751906AbeC3DHh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 23:07:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id F338448AE772
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 11:07:33 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Remove unused parameter
Date: Fri, 30 Mar 2018 10:56:50 +0800
Message-ID: <1522378610-21838-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Parameter usagestr is not used, remove it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-filesystem.c | 2 +-
 help.c            | 2 +-
 help.h            | 3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 467aff11..5fa8cf2b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1093,7 +1093,7 @@ static int cmd_filesystem_resize(int argc, char **argv)
 	DIR	*dirstream = NULL;
 	struct stat st;
 
-	clean_args_no_options_relaxed(argc, argv, cmd_filesystem_resize_usage);
+	clean_args_no_options_relaxed(argc, argv);
 
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_filesystem_resize_usage);
diff --git a/help.c b/help.c
index 311a4320..f1dd3946 100644
--- a/help.c
+++ b/help.c
@@ -115,7 +115,7 @@ void clean_args_no_options(int argc, char *argv[], const char * const *usagestr)
  * - "-- option1 option2 ..."
  * - "option1 option2 ..."
  */
-void clean_args_no_options_relaxed(int argc, char *argv[], const char * const *usagestr)
+void clean_args_no_options_relaxed(int argc, char *argv[])
 {
 	if (argc <= 1)
 		return;
diff --git a/help.h b/help.h
index efeded30..a1405942 100644
--- a/help.h
+++ b/help.h
@@ -72,8 +72,7 @@ int check_argc_exact(int nargs, int expected);
 int check_argc_min(int nargs, int expected);
 int check_argc_max(int nargs, int expected);
 void clean_args_no_options(int argc, char *argv[], const char * const *usage);
-void clean_args_no_options_relaxed(int argc, char *argv[],
-		const char * const *usagestr);
+void clean_args_no_options_relaxed(int argc, char *argv[]);
 
 void fixup_argv0(char **argv, const char *token);
 void set_argv0(char **argv);
-- 
2.14.3



