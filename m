Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:35143 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbaHNTZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 15:25:05 -0400
From: Nils Steinger <nst@voidptr.de>
To: linux-btrfs@vger.kernel.org
Cc: Nils Steinger <nst@voidptr.de>
Subject: [PATCH] Add options to use a fixed unit for `filesystem df` instead of determining it automatically.
Date: Thu, 14 Aug 2014 21:24:21 +0200
Message-Id: <1408044261-11234-2-git-send-email-nst@voidptr.de>
In-Reply-To: <1408044261-11234-1-git-send-email-nst@voidptr.de>
References: <1408044261-11234-1-git-send-email-nst@voidptr.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The automatic unit selection makes parsing the output of `filesystem df` unnecessarily difficult.
Using the new options -b, -k, -m, and -g, the output unit can be set to bytes, kibi-, mebi-, and gibibytes respectively.

Signed-off-by: Nils Steinger <nst@voidptr.de>
---
 cmds-filesystem.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 utils.c           | 30 +++++++++++++++++++++++++++
 utils.h           |  8 +++++++
 3 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 306f715..54406a5 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -113,8 +113,13 @@ static const char * const filesystem_cmd_group_usage[] = {
 };
 
 static const char * const cmd_df_usage[] = {
-	"btrfs filesystem df <path>",
+	"btrfs filesystem df [options] <path>",
 	"Show space usage information for a mount point",
+	"",
+	"-b             display all values in bytes",
+	"-k             display all values in kibibytes",
+	"-m             display all values in mebibytes",
+	"-g             display all values in gibibytes",
 	NULL
 };
 
@@ -204,7 +209,7 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 	return 0;
 }
 
-static void print_df(struct btrfs_ioctl_space_args *sargs)
+static void print_df(struct btrfs_ioctl_space_args *sargs, int output_unit)
 {
 	u64 i;
 	struct btrfs_ioctl_space_info *sp = sargs->spaces;
@@ -213,8 +218,8 @@ static void print_df(struct btrfs_ioctl_space_args *sargs)
 		printf("%s, %s: total=%s, used=%s\n",
 			group_type_str(sp->flags),
 			group_profile_str(sp->flags),
-			pretty_size(sp->total_bytes),
-			pretty_size(sp->used_bytes));
+			fixed_unit_size(sp->total_bytes, output_unit),
+			fixed_unit_size(sp->used_bytes, output_unit));
 	}
 }
 
@@ -223,13 +228,56 @@ static int cmd_df(int argc, char **argv)
 	struct btrfs_ioctl_space_args *sargs = NULL;
 	int ret;
 	int fd;
+	int output_unit = 0;
+	int multiple_options_specified = 0;
 	char *path;
 	DIR  *dirstream = NULL;
 
-	if (check_argc_exact(argc, 2))
+	optind = 1;
+	while(1) {
+		int c = getopt(argc, argv, "bkmg");
+		if (c < 0)
+			break;
+
+		switch(c) {
+		case 'b':
+			if (output_unit > 0)
+				multiple_options_specified = 1;
+
+			output_unit = 1;
+			break;
+		case 'k':
+			if (output_unit > 0)
+				multiple_options_specified = 1;
+
+			output_unit = 1024;
+			break;
+		case 'm':
+			if (output_unit > 0)
+				multiple_options_specified = 1;
+
+			output_unit = 1024 * 1024;
+			break;
+		case 'g':
+			if (output_unit > 0)
+				multiple_options_specified = 1;
+
+			output_unit = 1024 * 1024 * 1024;
+			break;
+		default:
+			usage(cmd_df_usage);
+		}
+	}
+
+	if (multiple_options_specified) {
+		fprintf(stderr, "Please only specify one the unit selection parameters -b/k/m/g\n.");
+		return EINVAL;
+	}
+
+	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_df_usage);
 
-	path = argv[1];
+	path = argv[argc - 1];
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
@@ -239,7 +287,7 @@ static int cmd_df(int argc, char **argv)
 	ret = get_df(fd, &sargs);
 
 	if (!ret && sargs) {
-		print_df(sargs);
+		print_df(sargs, output_unit);
 		free(sargs);
 	} else {
 		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
diff --git a/utils.c b/utils.c
index e130849..971e0ac 100644
--- a/utils.c
+++ b/utils.c
@@ -1280,6 +1280,36 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 	return snprintf(str, str_bytes, "%.2f%s", fraction,
 			size_strs[num_divs]);
 }
+int fixed_unit_size_snprintf(u64 size, int unit, char *str, size_t str_bytes)
+{
+	int size_str_idx;
+	float fraction;
+
+	switch (unit) {
+	case 1:
+		size_str_idx = 0;
+		break;
+	case 1024:
+		size_str_idx = 1;
+		break;
+	case 1024 * 1024:
+		size_str_idx = 2;
+		break;
+	case 1024 * 1024 * 1024:
+		size_str_idx = 3;
+		break;
+	default:
+		return pretty_size_snprintf(size, str, str_bytes);
+	}
+
+	if (str_bytes == 0)
+		return 0;
+
+	fraction = (float)size / unit;
+
+	return snprintf(str, str_bytes, "%.2f%s", fraction,
+			size_strs[size_str_idx]);
+}
 
 /*
  * __strncpy__null - strncpy with null termination
diff --git a/utils.h b/utils.h
index db8d63c..313408b 100644
--- a/utils.h
+++ b/utils.h
@@ -67,6 +67,14 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
 		_str;							\
 	})
 
+int fixed_unit_size_snprintf(u64 size, int unit, char *str, size_t str_bytes);
+#define fixed_unit_size(size, unit) 						\
+	({								\
+		static __thread char _str[24];				\
+		(void)fixed_unit_size_snprintf((size), (unit), _str, sizeof(_str));	\
+		_str;							\
+	})
+
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
