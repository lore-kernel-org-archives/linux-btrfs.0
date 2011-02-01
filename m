From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 1/7] moved parse_size() to utils.c
Date: Tue,  1 Feb 2011 14:54:44 +0100
Message-ID: <1296568490-13264-2-git-send-email-list.btrfs@jan-o-sch.net>
References: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: chris.mason@oracle.com, sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 btrfs_cmds.c |   26 --------------------------
 mkfs.c       |   26 --------------------------
 utils.c      |   26 ++++++++++++++++++++++++++
 utils.h      |    1 +
 4 files changed, 27 insertions(+), 52 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..d707a7d 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -116,32 +116,6 @@ static int open_file_or_dir(const char *fname)
 	return fd;
 }
 
-static u64 parse_size(char *s)
-{
-	int len = strlen(s);
-	char c;
-	u64 mult = 1;
-
-	if (!isdigit(s[len - 1])) {
-		c = tolower(s[len - 1]);
-		switch (c) {
-		case 'g':
-			mult *= 1024;
-		case 'm':
-			mult *= 1024;
-		case 'k':
-			mult *= 1024;
-		case 'b':
-			break;
-		default:
-			fprintf(stderr, "Unknown size descriptor %c\n", c);
-			exit(1);
-		}
-		s[len - 1] = '\0';
-	}
-	return atoll(s) * mult;
-}
-
 int do_defrag(int ac, char **av)
 {
 	int fd;
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..d1dd4a3 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -43,32 +43,6 @@
 #include "utils.h"
 #include "version.h"
 
-static u64 parse_size(char *s)
-{
-	int len = strlen(s);
-	char c;
-	u64 mult = 1;
-
-	if (!isdigit(s[len - 1])) {
-		c = tolower(s[len - 1]);
-		switch (c) {
-		case 'g':
-			mult *= 1024;
-		case 'm':
-			mult *= 1024;
-		case 'k':
-			mult *= 1024;
-		case 'b':
-			break;
-		default:
-			fprintf(stderr, "Unknown size descriptor %c\n", c);
-			exit(1);
-		}
-		s[len - 1] = '\0';
-	}
-	return atol(s) * mult;
-}
-
 static int make_root_dir(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle *trans;
diff --git a/utils.c b/utils.c
index 815b967..5fb82dc 100644
--- a/utils.c
+++ b/utils.c
@@ -35,6 +35,7 @@
 #include <linux/major.h>
 #include <linux/kdev_t.h>
 #include <limits.h>
+#include <ctype.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -1003,3 +1004,28 @@ char *pretty_sizes(u64 size)
 	return pretty;
 }
 
+u64 parse_size(char *s)
+{
+	int len = strlen(s);
+	char c;
+	u64 mult = 1;
+
+	if (!isdigit(s[len - 1])) {
+		c = tolower(s[len - 1]);
+		switch (c) {
+		case 'g':
+			mult *= 1024;
+		case 'm':
+			mult *= 1024;
+		case 'k':
+			mult *= 1024;
+		case 'b':
+			break;
+		default:
+			fprintf(stderr, "Unknown size descriptor %c\n", c);
+			exit(1);
+		}
+		s[len - 1] = '\0';
+	}
+	return atoll(s) * mult;
+}
diff --git a/utils.h b/utils.h
index 9dce5b0..dc1b41d 100644
--- a/utils.h
+++ b/utils.h
@@ -40,4 +40,5 @@ int check_mounted(const char *devicename);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
+u64 parse_size(char *s);
 #endif
-- 
1.7.2.2

