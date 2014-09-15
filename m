Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbaIOPJ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 11:09:58 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Hugo Mills <hugo@carfax.org.uk>,
        Nils Steinger <nst@voidptr.de>, Alexandre Oliva <oliva@gnu.org>
Subject: [UI RFC][PATCH] btrfs-progs: add options to tune units for fi df output
Date: Mon, 15 Sep 2014 17:09:52 +0200
Message-Id: <1410793792-17621-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The size unit format is a longstanding annoyance. This patch is based on
the work of Nils and Alexandre and enhances the options. It's possible
to select raw bytes, SI-based or IEC-based compact units (human
frientdly) or a fixed base from kilobytes to terabytes. The default is
compact human readable IEC-based, no change to current version.

CC: Nils Steinger <nst@voidptr.de>
CC: Alexandre Oliva <oliva@gnu.org>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

I tried to make the command line UI rich enough to address current and future
needs, I'm open to tweaks, rewording etc.

The patch is based on current snapshot of integration branch that will be the
base of 3.17 release and contains the 'enhanced df' patches, branch dev/units.

 Documentation/btrfs-filesystem.txt |  25 ++++++++-
 cmds-filesystem.c                  | 111 ++++++++++++++++++++++++++++---------
 utils.c                            |  48 ++++++++++++----
 utils.h                            |  30 +++++++---
 4 files changed, 168 insertions(+), 46 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index c9c0b006a0b0..7ac105ff350e 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -17,8 +17,31 @@ resizing, defragment.
 
 SUBCOMMAND
 ----------
-*df* <path> [<path>...]::
+*df* [options] <path>::
 Show space usage information for a mount point.
++
+`Options`
++
+-b|--raw::::
+raw numbers in bytes, without the 'B' suffix
+-h::::
+print human friendly numbers, base 1024, this is the default
+-H::::
+print human friendly numbers, base 1000
+--iec::::
+select the 1024 base for the following options, according to the IEC standard
+--si::::
+select the 1000 base for the following options, according to the SI standard
+-k|--kbytes::::
+show sizes in KiB, or KB with --si
+-m|--mbytes::::
+show sizes in MiB, or MB with --si
+-g|--gbytes::::
+show sizes in GiB, or GB with --si
+-t|--tbytes::::
+show sizes in TiB, or TB with --si
+
+If conflicting options are passed, the last one takes precedence.
 
 *show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
 Show the btrfs filesystem with some additional info.
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 89b897496256..68876957cbab 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -114,12 +114,21 @@ static const char * const filesystem_cmd_group_usage[] = {
 };
 
 static const char * const cmd_filesystem_df_usage[] = {
-       "btrfs filesystem df <path>",
+       "btrfs filesystem df [options] <path>",
        "Show space usage information for a mount point",
+	"-b|--raw           raw numbers in bytes",
+	"-h                 human friendly numbers, base 1024 (default)",
+	"-H                 human friendly numbers, base 1000",
+	"--iec              use 1024 as a base (Kib, MiB, GiB, ...)",
+	"--si               use 1000 as a base (KB, MB, GB, ...)",
+	"-k|--kbytes        show sizes in KiB, or KB with --si",
+	"-m|--mbytes        show sizes in MiB, or MB with --si",
+	"-g|--gbytes        show sizes in GiB, or GB with --si",
+	"-t|--tbytes        show sizes in TiB, or TB with --si",
        NULL
 };
 
-static void print_df(struct btrfs_ioctl_space_args *sargs)
+static void print_df(struct btrfs_ioctl_space_args *sargs, int unit_mode)
 {
        u64 i;
        struct btrfs_ioctl_space_info *sp = sargs->spaces;
@@ -128,8 +137,8 @@ static void print_df(struct btrfs_ioctl_space_args *sargs)
                printf("%s, %s: total=%s, used=%s\n",
                        group_type_str(sp->flags),
                        group_profile_str(sp->flags),
-                       pretty_size(sp->total_bytes),
-                       pretty_size(sp->used_bytes));
+                       pretty_size_mode(sp->total_bytes, unit_mode),
+                       pretty_size_mode(sp->used_bytes, unit_mode));
        }
 }
 
@@ -183,33 +192,83 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 
 static int cmd_filesystem_df(int argc, char **argv)
 {
-       struct btrfs_ioctl_space_args *sargs = NULL;
-       int ret;
-       int fd;
-       char *path;
-       DIR *dirstream = NULL;
+	struct btrfs_ioctl_space_args *sargs = NULL;
+	int ret;
+	int fd;
+	char *path;
+	DIR *dirstream = NULL;
+	unsigned unit_mode = UNITS_DEFAULT;
 
-       if (check_argc_exact(argc, 2))
-               usage(cmd_filesystem_df_usage);
+	optind = 1;
+	while (1) {
+		int long_index;
+		static const struct option long_options[] = {
+			{ "raw", no_argument, NULL, 'b'},
+			{ "kbytes", no_argument, NULL, 'k'},
+			{ "mbytes", no_argument, NULL, 'm'},
+			{ "gbytes", no_argument, NULL, 'g'},
+			{ "tbytes", no_argument, NULL, 't'},
+			{ "si", no_argument, NULL, 256},
+			{ "iec", no_argument, NULL, 257},
+		};
+		int c = getopt_long(argc, argv, "bhHkmgt", long_options,
+					&long_index);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'b':
+			unit_mode = UNITS_RAW;
+			break;
+		case 'k':
+			units_set_base(&unit_mode, UNITS_KBYTES);
+			break;
+		case 'm':
+			units_set_base(&unit_mode, UNITS_MBYTES);
+			break;
+		case 'g':
+			units_set_base(&unit_mode, UNITS_GBYTES);
+			break;
+		case 't':
+			units_set_base(&unit_mode, UNITS_TBYTES);
+			break;
+		case 'h':
+			unit_mode = UNITS_HUMAN_BINARY;
+			break;
+		case 'H':
+			unit_mode = UNITS_HUMAN_DECIMAL;
+			break;
+		case 256:
+			units_set_mode(&unit_mode, UNITS_DECIMAL);
+			break;
+		case 257:
+			units_set_mode(&unit_mode, UNITS_BINARY);
+			break;
+		default:
+			usage(cmd_filesystem_df_usage);
+		}
+	}
 
-       path = argv[1];
+	if (check_argc_max(argc, optind + 1))
+		usage(cmd_filesystem_df_usage);
 
-       fd = open_file_or_dir(path, &dirstream);
-       if (fd < 0) {
-               fprintf(stderr, "ERROR: can't access '%s'\n", path);
-               return 1;
-       }
-       ret = get_df(fd, &sargs);
+	path = argv[optind];
 
-       if (!ret && sargs) {
-               print_df(sargs);
-               free(sargs);
-       } else {
-               fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
-       }
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 1;
+	}
+	ret = get_df(fd, &sargs);
 
-       close_file_or_dir(fd, dirstream);
-       return !!ret;
+	if (ret == 0) {
+		print_df(sargs, unit_mode);
+		free(sargs);
+	} else {
+		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
+	}
+
+	close_file_or_dir(fd, dirstream);
+	return !!ret;
 }
 
 static int match_search_item_kernel(__u8 *fsid, char *mnt, char *label,
diff --git a/utils.c b/utils.c
index 9ab1480ede43..5db05010e839 100644
--- a/utils.c
+++ b/utils.c
@@ -1383,33 +1383,36 @@ static const char* unit_suffix_binary[] =
 static const char* unit_suffix_decimal[] =
 	{ "B", "KB", "MB", "GB", "TB", "PB", "EB"};
 
-int pretty_size_snprintf(u64 size, char *str, size_t str_size, int unit_mode)
+int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mode)
 {
 	int num_divs;
 	float fraction;
-	int base = 0;
+	u64 base = 0;
+	int mult = 0;
 	const char** suffix = NULL;
 	u64 last_size;
 
 	if (str_size == 0)
 		return 0;
 
-	if (unit_mode == UNITS_RAW) {
+	if ((unit_mode & ~UNITS_MODE_MASK) == UNITS_RAW) {
 		snprintf(str, str_size, "%llu", size);
 		return 0;
 	}
 
-	if (unit_mode == UNITS_BINARY) {
+	if ((unit_mode & ~UNITS_MODE_MASK) == UNITS_BINARY) {
 		base = 1024;
+		mult = 1024;
 		suffix = unit_suffix_binary;
-	} else if (unit_mode == UNITS_DECIMAL) {
+	} else if ((unit_mode & ~UNITS_MODE_MASK) == UNITS_DECIMAL) {
 		base = 1000;
+		mult = 1000;
 		suffix = unit_suffix_decimal;
 	}
 
 	/* Unknown mode */
 	if (!base) {
-		fprintf(stderr, "INTERNAL ERROR: unknown unit base, mode %d",
+		fprintf(stderr, "INTERNAL ERROR: unknown unit base, mode %d\n",
 				unit_mode);
 		assert(0);
 		return -1;
@@ -1417,11 +1420,22 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_size, int unit_mode)
 
 	num_divs = 0;
 	last_size = size;
-
-	while (size >= base) {
-		last_size = size;
-		size /= base;
-		num_divs++;
+	switch (unit_mode & UNITS_MODE_MASK) {
+	case UNITS_TBYTES: base *= mult; num_divs++;
+	case UNITS_GBYTES: base *= mult; num_divs++;
+	case UNITS_MBYTES: base *= mult; num_divs++;
+	case UNITS_KBYTES: num_divs++;
+			   break;
+	case UNITS_BYTES:
+			   base = 1;
+			   num_divs = 0;
+			   break;
+	default:
+		while (size >= mult) {
+			last_size = size;
+			size /= mult;
+			num_divs++;
+		}
 	}
 
 	if (num_divs >= ARRAY_SIZE(unit_suffix_binary)) {
@@ -2573,3 +2587,15 @@ const char *group_profile_str(u64 flag)
 	}
 }
 
+void units_set_mode(unsigned *units, unsigned mode)
+{
+	unsigned base = *units & UNITS_MODE_MASK;
+
+	*units = base | mode;
+}
+void units_set_base(unsigned *units, unsigned base)
+{
+	unsigned mode = *units & ~UNITS_MODE_MASK;
+
+	*units = base | mode;
+}
diff --git a/utils.h b/utils.h
index 1eed0c1606aa..8156f13126af 100644
--- a/utils.h
+++ b/utils.h
@@ -50,12 +50,26 @@ void fixup_argv0(char **argv, const char *token);
 void set_argv0(char **argv);
 
 /*
- * Output mode of byte units
+ * Output modes of size
  */
-#define UNITS_RAW			(1)
-#define UNITS_BINARY			(2)
-#define UNITS_DECIMAL			(3)
-#define UNITS_HUMAN			UNITS_BINARY
+#define UNITS_RESERVED			(0)
+#define UNITS_BYTES			(1)
+#define UNITS_KBYTES			(2)
+#define UNITS_MBYTES			(3)
+#define UNITS_GBYTES			(4)
+#define UNITS_TBYTES			(5)
+#define UNITS_RAW			(1U << UNITS_MODE_SHIFT)
+#define UNITS_BINARY			(2U << UNITS_MODE_SHIFT)
+#define UNITS_DECIMAL			(3U << UNITS_MODE_SHIFT)
+#define UNITS_MODE_MASK			((1U << UNITS_MODE_SHIFT) - 1)
+#define UNITS_MODE_SHIFT		(8)
+#define UNITS_HUMAN_BINARY		(UNITS_BINARY)
+#define UNITS_HUMAN_DECIMAL		(UNITS_DECIMAL)
+#define UNITS_HUMAN			(UNITS_HUMAN_BINARY)
+#define UNITS_DEFAULT			(UNITS_HUMAN)
+
+void units_set_mode(unsigned *units, unsigned mode);
+void units_set_base(unsigned *units, unsigned base);
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       char *fs_uuid, u64 blocks[6], u64 num_bytes, u32 nodesize,
@@ -79,12 +93,12 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 
-int pretty_size_snprintf(u64 size, char *str, size_t str_bytes, int unit_mode);
-#define pretty_size(size) 	pretty_size_mode(size, UNITS_BINARY)
+int pretty_size_snprintf(u64 size, char *str, size_t str_bytes, unsigned unit_mode);
+#define pretty_size(size) 	pretty_size_mode(size, UNITS_DEFAULT)
 #define pretty_size_mode(size, mode) 					      \
 	({								      \
 		static __thread char _str[32];				      \
-		(void)pretty_size_snprintf((size), _str, sizeof(_str), mode); \
+		(void)pretty_size_snprintf((size), _str, sizeof(_str), (mode)); \
 		_str;							      \
 	})
 
-- 
2.1.0

