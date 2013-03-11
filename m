Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36964 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3CKURb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 16:17:31 -0400
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@gmail.com>,
        Harald Glatt <mail@hachre.de>, Roger Binns <rogerb@rogerbinns.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Diego Calleja <diegocg@gmail.com>, sam tygier <samtygier@yahoo.co.uk>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v2 2/5] Move parse_profile to utils.c
Date: Mon, 11 Mar 2013 20:17:25 +0000
Message-Id: <1363033048-17481-3-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
References: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make parse_profile a shared function so it can be used across the
code-base.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 mkfs.c  |   94 ---------------------------------------------------------------
 utils.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |    1 +
 3 files changed, 95 insertions(+), 94 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 70df5db..0facf13 100644
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
-	/* Attempt to parse new ncmspp form */
-	/* <n>c is required and n must be an unsigned decimal number */
-	copies = strtoul(s, &parse_end, 10);
-	if(parse_end == s || (*parse_end != 'c' && *parse_end != 'C'))
-		goto unknown;
-
-	/* c may be followed by d to indicate non-redundant/DUP */
-	pos = parse_end + 1;
-	if(*pos == 'd' || *pos == 'D') {
-		dup = 1;
-		pos++;
-	}
-	if(*pos == 0)
-		goto done;
-
-	/* <m>s is optional, and <m> may be an integer, or a literal "x" */
-	if(*pos == 'x' || *pos == 'X') {
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
-	/* <p>p is optional, and p must be an integer */
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
index f68436d..f1d2432 100644
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
+	/* Attempt to parse new ncmspp form */
+	/* <n>c is required and n must be an unsigned decimal number */
+	copies = strtoul(s, &parse_end, 10);
+	if(parse_end == s || (*parse_end != 'c' && *parse_end != 'C'))
+		goto unknown;
+
+	/* c may be followed by d to indicate non-redundant/DUP */
+	pos = parse_end + 1;
+	if(*pos == 'd' || *pos == 'D') {
+		dup = 1;
+		pos++;
+	}
+	if(*pos == 0)
+		goto done;
+
+	/* <m>s is optional, and <m> may be an integer, or a literal "x" */
+	if(*pos == 'x' || *pos == 'X') {
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
+	/* <p>p is optional, and p must be an integer */
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

