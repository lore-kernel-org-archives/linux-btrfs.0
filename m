Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2FXVUe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jun 2012 17:20:34 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2680230bkc.19
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jun 2012 14:20:33 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 2/5] Btrfs-progs: move skip_prefix and prefixcmp to utils.c
Date: Sun, 24 Jun 2012 23:20:05 +0200
Message-Id: <1340572808-30281-3-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
References: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Needed by btrfs fi prop.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 btrfs.c    |   17 ++---------------
 commands.h |    2 --
 help.c     |    2 ++
 utils.c    |   15 +++++++++++++++
 utils.h    |    3 +++
 5 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 88238d6..f48e483 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -19,7 +19,9 @@
 #include <stdlib.h>
 #include <string.h>
 
+#include "ctree.h"
 #include "commands.h"
+#include "utils.h"
 #include "version.h"
 
 static const char * const btrfs_cmd_group_usage[] = {
@@ -32,21 +34,6 @@ static const char btrfs_cmd_group_info[] =
 
 char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
 
-static inline const char *skip_prefix(const char *str, const char *prefix)
-{
-	size_t len = strlen(prefix);
-	return strncmp(str, prefix, len) ? NULL : str + len;
-}
-
-int prefixcmp(const char *str, const char *prefix)
-{
-	for (; ; str++, prefix++)
-		if (!*prefix)
-			return 0;
-		else if (*str != *prefix)
-			return (unsigned char)*prefix - (unsigned char)*str;
-}
-
 static int parse_one_token(const char *arg, const struct cmd_group *grp,
 			   const struct cmd_struct **cmd_ret)
 {
diff --git a/commands.h b/commands.h
index a303a50..64acf17 100644
--- a/commands.h
+++ b/commands.h
@@ -58,8 +58,6 @@ struct cmd_group {
 };
 
 /* btrfs.c */
-int prefixcmp(const char *str, const char *prefix);
-
 int check_argc_exact(int nargs, int expected);
 int check_argc_min(int nargs, int expected);
 int check_argc_max(int nargs, int expected);
diff --git a/help.c b/help.c
index 6d04293..29ff3d6 100644
--- a/help.c
+++ b/help.c
@@ -18,7 +18,9 @@
 #include <stdlib.h>
 #include <string.h>
 
+#include "ctree.h"
 #include "commands.h"
+#include "utils.h"
 
 extern char argv0_buf[ARGV0_BUF_SIZE];
 
diff --git a/utils.c b/utils.c
index 5833030..61ae39b 100644
--- a/utils.c
+++ b/utils.c
@@ -1216,3 +1216,18 @@ scan_again:
 	return 0;
 }
 
+const char *skip_prefix(const char *str, const char *prefix)
+{
+	size_t len = strlen(prefix);
+	return strncmp(str, prefix, len) ? NULL : str + len;
+}
+
+int prefixcmp(const char *str, const char *prefix)
+{
+	for (; ; str++, prefix++)
+		if (!*prefix)
+			return 0;
+		else if (*str != *prefix)
+			return (unsigned char)*prefix - (unsigned char)*str;
+}
+
diff --git a/utils.h b/utils.h
index c5f55e1..e6b5df8 100644
--- a/utils.h
+++ b/utils.h
@@ -46,4 +46,7 @@ int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
+
+const char *skip_prefix(const char *str, const char *prefix);
+int prefixcmp(const char *str, const char *prefix);
 #endif
-- 
1.7.10

