Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52381 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3CIVIS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 16:08:18 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.72)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQC-0007mr-LX
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:13 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQC-0003Hi-9F
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] Move parse_profile to utils.c
Date: Sat,  9 Mar 2013 20:31:08 +0000
Message-Id: <1362861071-12589-3-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make parse_profile a shared function so it can be used across the
code-base.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>

Conflicts:
	mkfs.c
---
 mkfs.c  |   94 ---------------------------------------------------------------
 utils.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |    1 +
 3 files changed, 95 insertions(+), 94 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 02a7086..51e545f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -348,100 +348,6 @@ static void print_version(void)
 	exit(0);
 }
 
-static u64 make_profile(int copies, int dup, int stripes, int parity)
-{
-	if(copies == 1 && !dup && stripes == 0 && parity == 0)
-		return 0;
-	else if(copies == 2 && dup && stripes == 0 && parity == 0)
-		return BTRFS_BLOCK_GROUP_DUP;
-	else if(copies == 2 && !dup && stripes == 0 && parity == 0)
-		return BTRFS_BLOCK_GROUP_RAID1;
-	else if(copies == 2 && !dup && stripes == -1 && parity == 0)
-		return BTRFS_BLOCK_GROUP_RAID10;
-	else if(copies == 1 && !dup && stripes == -1 && parity == 0)
-		return BTRFS_BLOCK_GROUP_RAID0;
-	else if(copies == 1 && !dup && stripes == -1 && parity == 1)
-		return BTRFS_BLOCK_GROUP_RAID5;
-	else if(copies == 1 && !dup && stripes == -1 && parity == 2)
-		return BTRFS_BLOCK_GROUP_RAID6;
-
-	return (u64)-1;
-}
-
-static u64 parse_profile(const char *s)
-{
-	char *pos, *parse_end;
-	int copies = 1;
-	int stripes = 0;
-	int parity = 0;
-	int dup = 0;
-	u64 profile = (u64)-1;
-
-	/* Look for exact match with historical forms first */
-	if (strcmp(s, "raid0") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID0;
-	} else if (strcmp(s, "raid1") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID1;
-	} else if (strcmp(s, "raid5") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID5;
-	} else if (strcmp(s, "raid6") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID6;
-	} else if (strcmp(s, "raid10") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID10;
-	} else if (strcmp(s, "dup") == 0) {
-		return BTRFS_BLOCK_GROUP_DUP;
-	} else if (strcmp(s, "single") == 0) {
-		return 0;
-	}
-
-	/* Attempt to parse new nCmSpP form */
-	/* nC is required and n must be an unsigned decimal number */
-	copies = strtoul(s, &parse_end, 10);
-	if(parse_end == s || (*parse_end != 'c' && *parse_end != 'C'))
-		goto unknown;
-
-	/* C may be followed by D to indicate non-redundant/DUP */
-	pos = parse_end + 1;
-	if(*pos == 'D' || *pos == 'd') {
-		dup = 1;
-		pos++;
-	}
-	if(*pos == 0)
-		goto done;
-
-	/* mS is optional, and m may be an integer, or a literal "m" */
-	if(*pos == 'm') {
-		stripes = -1;
-		parse_end = pos+1;
-	} else {
-		stripes = strtoul(pos, &parse_end, 10);
-	}
-	if(parse_end == pos || (*parse_end != 's' && *parse_end != 'S'))
-		goto unknown;
-
-	pos = parse_end + 1;
-	if(*pos == 0)
-		goto done;
-
-	/* pP is optional, and p must be an integer */
-	parity = strtoul(pos, &parse_end, 10);
-	if(parse_end == pos || (*parse_end != 'p' && *parse_end != 'P'))
-		goto unknown;
-	pos = parse_end + 1;
-	if(*pos != 0)
-		goto unknown;
-
-done:
-	profile = make_profile(copies, dup, stripes, parity);
-	if(profile == (u64)-1)
-		fprintf(stderr, "Unknown or unavailable profile '%s'\n", s);
-	return profile;
-
-unknown:
-	fprintf(stderr, "Unparseable profile '%s'\n", s);
-	return (u64)-1;
-}
-
 static char *parse_label(char *input)
 {
 	int len = strlen(input);
diff --git a/utils.c b/utils.c
index 1813dda..a6fb246 100644
--- a/utils.c
+++ b/utils.c
@@ -1420,6 +1420,100 @@ u64 parse_size(char *s)
 	return strtoull(s, NULL, 10) * mult;
 }
 
+static u64 make_profile(int copies, int dup, int stripes, int parity)
+{
+	if(copies == 1 && !dup && stripes == 0 && parity == 0)
+		return 0;
+	else if(copies == 2 && dup && stripes == 0 && parity == 0)
+		return BTRFS_BLOCK_GROUP_DUP;
+	else if(copies == 2 && !dup && stripes == 0 && parity == 0)
+		return BTRFS_BLOCK_GROUP_RAID1;
+	else if(copies == 2 && !dup && stripes == -1 && parity == 0)
+		return BTRFS_BLOCK_GROUP_RAID10;
+	else if(copies == 1 && !dup && stripes == -1 && parity == 0)
+		return BTRFS_BLOCK_GROUP_RAID0;
+	else if(copies == 1 && !dup && stripes == -1 && parity == 1)
+		return BTRFS_BLOCK_GROUP_RAID5;
+	else if(copies == 1 && !dup && stripes == -1 && parity == 2)
+		return BTRFS_BLOCK_GROUP_RAID6;
+
+	return (u64)-1;
+}
+
+u64 parse_profile(const char *s)
+{
+	char *pos, *parse_end;
+	int copies = 1;
+	int stripes = 0;
+	int parity = 0;
+	int dup = 0;
+	u64 profile = (u64)-1;
+
+	/* Look for exact match with historical forms first */
+	if (strcmp(s, "raid0") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID0;
+	} else if (strcmp(s, "raid1") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID1;
+	} else if (strcmp(s, "raid5") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID5;
+	} else if (strcmp(s, "raid6") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID6;
+	} else if (strcmp(s, "raid10") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID10;
+	} else if (strcmp(s, "dup") == 0) {
+		return BTRFS_BLOCK_GROUP_DUP;
+	} else if (strcmp(s, "single") == 0) {
+		return 0;
+	}
+
+	/* Attempt to parse new nCmSpP form */
+	/* nC is required and n must be an unsigned decimal number */
+	copies = strtoul(s, &parse_end, 10);
+	if(parse_end == s || (*parse_end != 'c' && *parse_end != 'C'))
+		goto unknown;
+
+	/* C may be followed by D to indicate non-redundant/DUP */
+	pos = parse_end + 1;
+	if(*pos == 'D' || *pos == 'd') {
+		dup = 1;
+		pos++;
+	}
+	if(*pos == 0)
+		goto done;
+
+	/* mS is optional, and m may be an integer, or a literal "m" */
+	if(*pos == 'm') {
+		stripes = -1;
+		parse_end = pos+1;
+	} else {
+		stripes = strtoul(pos, &parse_end, 10);
+	}
+	if(parse_end == pos || (*parse_end != 's' && *parse_end != 'S'))
+		goto unknown;
+
+	pos = parse_end + 1;
+	if(*pos == 0)
+		goto done;
+
+	/* pP is optional, and p must be an integer */
+	parity = strtoul(pos, &parse_end, 10);
+	if(parse_end == pos || (*parse_end != 'p' && *parse_end != 'P'))
+		goto unknown;
+	pos = parse_end + 1;
+	if(*pos != 0)
+		goto unknown;
+
+done:
+	profile = make_profile(copies, dup, stripes, parity);
+	if(profile == (u64)-1)
+		fprintf(stderr, "Unknown or unavailable profile '%s'\n", s);
+	return profile;
+
+unknown:
+	fprintf(stderr, "Unparseable profile '%s'\n", s);
+	return (u64)-1;
+}
+
 int open_file_or_dir(const char *fname)
 {
 	int ret;
diff --git a/utils.h b/utils.h
index 0b681ed..dcaaa7f 100644
--- a/utils.h
+++ b/utils.h
@@ -47,6 +47,7 @@ char *pretty_sizes(u64 size);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
+u64 parse_profile(const char* s);
 int open_file_or_dir(const char *fname);
 int get_device_info(int fd, u64 devid,
 		    struct btrfs_ioctl_dev_info_args *di_args);
-- 
1.7.10.4

