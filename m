Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54503 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab2JWRvk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 13:51:40 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1518986eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 10:51:39 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/5] Move parse_size() to utils.[hc]
Date: Tue, 23 Oct 2012 19:51:51 +0200
Message-Id: <1351014715-5727-2-git-send-email-kreijack@inwind.com>
In-Reply-To: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
References: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Move the function from cmds-filesystem.c and mkfs.c to utils.c
---
 cmds-filesystem.c |   26 --------------------------
 mkfs.c            |   31 -------------------------------
 utils.c           |   26 ++++++++++++++++++++++++++
 utils.h           |    2 ++
 4 files changed, 28 insertions(+), 57 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 9c43d35..507239a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -311,32 +311,6 @@ static int cmd_sync(int argc, char **argv)
 	return 0;
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
 static int parse_compress_type(char *s)
 {
 	if (strcmp(optarg, "zlib") == 0)
diff --git a/mkfs.c b/mkfs.c
index 47f0c9c..ca850d9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -54,37 +54,6 @@ struct directory_name_entry {
 	struct list_head list;
 };
 
-static u64 parse_size(char *s)
-{
-	int len = strlen(s);
-	char c;
-	u64 mult = 1;
-	u64 ret;
-
-	s = strdup(s);
-
-	if (len && !isdigit(s[len - 1])) {
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
-	ret = atol(s) * mult;
-	free(s);
-	return ret;
-}
-
 static int make_root_dir(struct btrfs_root *root, int mixed)
 {
 	struct btrfs_trans_handle *trans;
diff --git a/utils.c b/utils.c
index 205e667..705be7b 100644
--- a/utils.c
+++ b/utils.c
@@ -1220,3 +1220,29 @@ scan_again:
 	return 0;
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
+
diff --git a/utils.h b/utils.h
index 3a0368b..714fd7a 100644
--- a/utils.h
+++ b/utils.h
@@ -46,4 +46,6 @@ int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
+
+u64 parse_size(char *s);
 #endif
-- 
1.7.10.4

