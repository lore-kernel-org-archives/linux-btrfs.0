Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53053 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2JOTPH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 15:15:07 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so3145388eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 12:15:06 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Move parse_size() in utils.c
Date: Mon, 15 Oct 2012 21:15:23 +0200
Message-Id: <1350328523-7465-2-git-send-email-kreijack@gmail.com>
In-Reply-To: <1350328523-7465-1-git-send-email-kreijack@gmail.com>
References: <1350299942-23468-1-git-send-email-sbehrens@giantdisaster.de>
 <1350328523-7465-1-git-send-email-kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Move parse_size() in utils.c, because it is used both from
cmds-filesystem.c and mkfs.c.
Moreover added check about overflow, support to further units (
t=tera, e=exa, z=zetta, y=yotta).
Correct a bug which happens if a value like 123MB is passed: before
the function returned 123 instead of 123*1024*1024
---
 cmds-filesystem.c |   26 -----------------------
 mkfs.c            |   31 ---------------------------
 utils.c           |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |    1 +
 4 files changed, 62 insertions(+), 57 deletions(-)

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
index 205e667..b1bd669 100644
--- a/utils.c
+++ b/utils.c
@@ -1220,3 +1220,64 @@ scan_again:
 	return 0;
 }
 
+/* 
+ *  see http://gurmeet.net/puzzles/fast-bit-counting-routines/ for
+ *  further algorithms, I used the only one which I understood :-)
+ */
+static int bitcount(u64 v)
+{
+	int	n;
+	for(n=0; v ; n++, v >>= 1) ;
+
+	return n;
+}
+
+u64 parse_size(char *s)
+{
+	int shift = 0;
+	u64 ret;
+	int n, i;
+
+	s = strdup(s);
+
+	for( i = 0 ; s[i] && isdigit(s[i]) ; i++ ) ; 
+	switch (tolower(s[i])) {
+		/* note: the yobibyte and the zebibyte don't fit
+		   in a u64, they need an u128 !!! */
+		case 'y':	/* yobibyte */
+			shift += 10;
+		case 'z':	/* zebibyte */
+			shift += 10;
+		case 'e':	/* exbibyte */
+			shift += 10;
+		case 'p':	/* pebibyte */
+			shift += 10;
+		case 't':	/* tetibyte */
+			shift += 10;
+		case 'g':	/* gibibyte */
+			shift += 10;
+		case 'm':	/* mebibyte */
+			shift += 10;
+		case 'k':	/* kibibyte */
+			shift += 10;
+		case 0:
+			break;
+		default:
+			fprintf(stderr, "ERROR: Unknown size descriptor %c\n", 
+				s[i]);
+			exit(1);
+	}
+	ret = strtoull(s, 0, 0);
+	n = bitcount(ret);
+
+	if( ( n + shift ) > ( sizeof(u64) * CHAR_BIT )) {
+		fprintf(stderr, "ERROR: Overflow, the value '%s' is too big\n",
+			s);
+		fprintf(stderr, "ERROR: Abort\n");
+		exit(1);
+	}
+
+	return ret << shift;
+}
+
+
diff --git a/utils.h b/utils.h
index 3a0368b..180b3f9 100644
--- a/utils.h
+++ b/utils.h
@@ -46,4 +46,5 @@ int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
+u64 parse_size(char *s);
 #endif
-- 
1.7.10.4

