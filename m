Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbaD2QCp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E8D82AD13
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:02:44 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 11/14] btrfs-progs: extend pretty printers with unit mode
Date: Tue, 29 Apr 2014 18:02:44 +0200
Message-Id: <d34ddb9597c9b48babfbbf3cded31e254dd0487a.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The functionality of pretty unit printing was duplicated by
df_pretty_sizes, merge it with pretty_size and enhance the interface
with more suffix mode. Raw, binary or decimal.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c |  9 ++-----
 utils.c              | 71 ++++++++++++++++++++++++++++++++++++----------------
 utils.h              | 21 +++++++++++-----
 3 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index e472833c646d..c823223ee8a8 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -33,18 +33,13 @@
 
 /*
  * Pretty print the size
- * PAY ATTENTION: it return a statically buffer
  */
 char *df_pretty_sizes(u64 size, int mode)
 {
-	static char buf[30];
-
 	if (mode & DF_HUMAN_UNIT)
-		(void)pretty_size_snprintf(size, buf, sizeof(buf));
+		return pretty_size_mode(size, UNITS_HUMAN);
 	else
-		sprintf(buf, "%llu", size);
-
-	return buf;
+		return pretty_size_mode(size, UNITS_RAW);
 }
 
 /*
diff --git a/utils.c b/utils.c
index 159abf8bd0e4..69112be51cb2 100644
--- a/utils.c
+++ b/utils.c
@@ -1252,35 +1252,62 @@ out:
 	return ret;
 }
 
-static char *size_strs[] = { "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
-int pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
+static const char const *unit_suffix_binary[] =
+	{ "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
+static const char const *unit_suffix_decimal[] =
+	{ "B", "KB", "MB", "GB", "TB", "PB", "EB"};
+
+int pretty_size_snprintf(u64 size, char *str, size_t str_size, int unit_mode)
 {
-	int num_divs = 0;
+	int num_divs;
 	float fraction;
+	int base = 0;
+	const char const **suffix = NULL;
+	u64 last_size;
 
-	if (str_bytes == 0)
+	if (str_size == 0)
 		return 0;
 
-	if( size < 1024 ){
-		fraction = size;
-		num_divs = 0;
-	} else {
-		u64 last_size = size;
-		num_divs = 0;
-		while(size >= 1024){
-			last_size = size;
-			size /= 1024;
-			num_divs ++;
-		}
+	if (unit_mode == UNITS_RAW) {
+		snprintf(str, str_size, "%llu", size);
+		return 0;
+	}
 
-		if (num_divs >= ARRAY_SIZE(size_strs)) {
-			str[0] = '\0';
-			return -1;
-		}
-		fraction = (float)last_size / 1024;
+	if (unit_mode == UNITS_BINARY) {
+		base = 1024;
+		suffix = unit_suffix_binary;
+	} else if (unit_mode == UNITS_DECIMAL) {
+		base = 1000;
+		suffix = unit_suffix_decimal;
 	}
-	return snprintf(str, str_bytes, "%.2f%s", fraction,
-			size_strs[num_divs]);
+
+	/* Unknown mode */
+	if (!base) {
+		fprintf(stderr, "INTERNAL ERROR: unknown unit base, mode %d",
+				unit_mode);
+		assert(0);
+		return -1;
+	}
+
+	num_divs = 0;
+	last_size = size;
+
+	while (size >= base) {
+		last_size = size;
+		size /= base;
+		num_divs++;
+	}
+
+	if (num_divs >= ARRAY_SIZE(unit_suffix_binary)) {
+		str[0] = '\0';
+		printf("INTERNAL ERROR: unsupported unit suffix, index %d\n",
+				num_divs);
+		assert(0);
+		return -1;
+	}
+	fraction = (float)last_size / base;
+
+	return snprintf(str, str_size, "%.2f%s", fraction, suffix[num_divs]);
 }
 
 /*
diff --git a/utils.h b/utils.h
index 2d08e0b2a3a4..3aea8b47d9e7 100644
--- a/utils.h
+++ b/utils.h
@@ -39,6 +39,14 @@
 
 #define BTRFS_UUID_UNPARSED_SIZE	37
 
+/*
+ * Output mode of byte units
+ */
+#define UNITS_RAW			(1)
+#define UNITS_BINARY			(2)
+#define UNITS_DECIMAL			(3)
+#define UNITS_HUMAN			UNITS_BINARY
+
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features);
@@ -59,12 +67,13 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 
-int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
-#define pretty_size(size) 						\
-	({								\
-		static __thread char _str[24];				\
-		(void)pretty_size_snprintf((size), _str, sizeof(_str));	\
-		_str;							\
+int pretty_size_snprintf(u64 size, char *str, size_t str_bytes, int unit_mode);
+#define pretty_size(size) 	pretty_size_mode(size, UNITS_BINARY)
+#define pretty_size_mode(size, mode) 					      \
+	({								      \
+		static __thread char _str[32];				      \
+		(void)pretty_size_snprintf((size), _str, sizeof(_str), mode); \
+		_str;							      \
 	})
 
 int get_mountpt(char *dev, char *mntpt, size_t size);
-- 
1.9.0

