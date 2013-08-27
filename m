Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab3H0TRy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 15:17:54 -0400
Message-ID: <521CFB5D.3020307@suse.com>
Date: Tue, 27 Aug 2013 15:17:49 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] utils: add support for getting/changing file system,
 features
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds support for getting and changing file system
feature bits. It supports both unmounted and mounted operation via
a new set of ioctls.

Setting bits not supported by the running kernel, if the file system is
mounted, or the tools, if the file system is unmounted, can be forced with
a -f option.

It supports clearing of feature bits, but I've left that undocumented
intentionally.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-filesystem.c |  42 +++++
 ioctl.h           |  12 ++
 man/btrfs.8.in    |  28 ++++
 utils.c           | 478 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 utils.h           |  10 ++
 5 files changed, 569 insertions(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..ca096e0 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -515,6 +515,47 @@ static int cmd_label(int argc, char **argv)
 		return get_label(argv[1]);
 }
 
+static const char * const cmd_features_usage[] = {
+	"btrfs filesystem features [<device>|<mountpoint>] [[-f] <features>]",
+	"Get or change the list of features currently enabled by a filesystem",
+	"With one argument, get the currently enabled features of filesystem",
+	"on <device> or <mountpoint>.", "",
+	"If <features> is passed, add new features to the file system.",
+	"The format of new features can be a comma separated list of names or",
+	"or a comma-separated list of specifiers of the following format: A",
+	"prefix of compat, compat_ro, or incompat and a decimal number, ",
+	"separated by a colon: (e.g. compat:10)", "",
+	"Features to be enabled will be confirmed against the supported",
+	"features of the kernel (if mounted) or the progs (if unmounted). This",
+	"behavior can be overridden when operating on unmounted",
+	"filesystems by using the -f (force) flag.", "",
+	"A list of features supported by the progs can be found in the manual.",
+	NULL
+};
+
+static int cmd_features(int argc, char **argv)
+{
+	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
+		usage(cmd_features_usage);
+
+	if (argc > 2) {
+		char *features = argv[2];
+		int force = 0;
+		if (argc > 3) {
+			if (!strcmp(argv[3], "-f"))
+				force = 1;
+			else if (!strcmp(argv[2], "-f")) {
+				force = 1;
+				features = argv[3];
+			} else
+				usage(cmd_features_usage);
+		}
+
+		return parse_and_set_features(argv[1], features, force);
+	} else
+		return get_features(argv[1]);
+}
+
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
 		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
@@ -524,6 +565,7 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ "features", cmd_features, cmd_features_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 },
 	}
 };
diff --git a/ioctl.h b/ioctl.h
index abe6dd4..44483d1 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -172,6 +172,12 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[124];			/* pad to 1k */
 };
 
+struct btrfs_ioctl_feature_flags {
+	__u64 compat_flags;
+	__u64 compat_ro_flags;
+	__u64 incompat_flags;
+};
+
 /* balance control ioctl modes */
 #define BTRFS_BALANCE_CTL_PAUSE		1
 #define BTRFS_BALANCE_CTL_CANCEL	2
@@ -537,6 +543,12 @@ struct btrfs_ioctl_clone_range_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 54, \
+				    struct btrfs_ioctl_feature_flags)
+#define BTRFS_IOC_ADD_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 55, \
+				    struct btrfs_ioctl_feature_flags)
+#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 56, \
+				    struct btrfs_ioctl_feature_flags[2])
 
 #ifdef __cplusplus
 }
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index af7df4d..9c5b61e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -31,6 +31,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
+\fBbtrfs\fP \fBfilesystem features\fP\fI <dev|mountpoint> [[-f ]newlabel]\fP
+.PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
@@ -280,6 +282,32 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
+\fBfilesystem features\fP\fI <dev|mountpoint> [[-f] features]\fP
+Show or update the features of a filesystem. \fI<dev>\fR is used to identify an umounted filesystem.  \fI<mountpoint>\fR is used to identify a mounted filesystem.
+If a \fIfeatures\fR optional argument is passed, the features are updated.
+The following features are currently supported by the tool:
+.br
+- mixed_backref
+.br
+- default_subvol
+.br
+- mixed_groups
+.br
+- compress_lzo
+.br
+- compress_lzov2
+.br
+- big_metadata
+.br
+- extended_iref
+.br
+- raid56
+.br
+- skinny_metadata
+.IP
+It is possible, but not recommended to set undocumented features using one of the following prefixes: compat, compat_ro, incompat and a bit number, separated by a colon. e.g. compat:12. Please note that changing unrecognized feature bits is a dangerous operation and may result in an umountable file system that needs to be manually repaired by an expert.
+.TP
+
 \fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
 Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
 \fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
diff --git a/utils.c b/utils.c
index 7b4cd74..bc607a4 100644
--- a/utils.c
+++ b/utils.c
@@ -20,7 +20,7 @@
 #define _XOPEN_SOURCE 700
 #define __USE_XOPEN2K8
 #define __XOPEN2K8 /* due to an error in dirent.h, to get dirfd() */
-#define _GNU_SOURCE	/* O_NOATIME */
+#define _GNU_SOURCE	/* O_NOATIME, %as in sscanf */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -1350,6 +1350,482 @@ int set_label(const char *btrfs_dev, const char *label)
 		set_label_mounted(btrfs_dev, label);
 }
 
+enum {
+	FEAT_COMPAT = 0,
+	FEAT_COMPAT_RO,
+	FEAT_INCOMPAT,
+};
+
+const char *feature_type[] = {
+	"compat",
+	"compat_ro",
+	"incompat",
+};
+
+const char *compat_features[] = { NULL };
+const char *compat_ro_features[] = { NULL };
+const char *incompat_features[] = {
+	"mixed_backref",
+	"default_subvol",
+	"mixed_groups",
+	"compress_lzo",
+	"compress_lzov2",
+	"big_metadata",
+	"extended_iref",
+	"raid56",
+	"skinny_metadata",
+	NULL,
+};
+
+#define NAMEBUFSZ 4096 /* 64 names * 64 bytes/name (safe max) */
+char *feature_names(int type, u64 flags)
+{
+	int i;
+	int name_count;
+	const char **names;
+	int count = 0;
+	char *buf = malloc(NAMEBUFSZ);
+	char *ptr = buf;
+	char typename[10]; /* compat_ro + 1 */
+	*buf = 0;
+
+	switch (type) {
+	case FEAT_COMPAT:
+		name_count = ARRAY_SIZE(compat_features);
+		names = compat_features;
+		break;
+	case FEAT_COMPAT_RO:
+		name_count = ARRAY_SIZE(compat_ro_features);
+		names = compat_ro_features;
+		break;
+	case FEAT_INCOMPAT:
+		name_count = ARRAY_SIZE(incompat_features);
+		names = incompat_features;
+		break;
+	default:
+		BUG_ON(1);
+	};
+
+	strcpy(typename, feature_type[type]);
+	for (i = 0; i < sizeof(typename); i++)
+		typename[i] = tolower(typename[i]);
+
+	for (i = 0; i < sizeof(flags) << 3; i++) {
+		if (!(flags & (1ULL << i)))
+			continue;
+
+		if (i >= name_count)
+			ptr += snprintf(ptr, NAMEBUFSZ, "%s%s:%u",
+				       count ? "," : "", typename, i);
+		else
+			ptr += snprintf(ptr, NAMEBUFSZ, "%s%s",
+				       count ? "," : "", names[i]);
+		count++;
+
+		BUG_ON(ptr > buf + NAMEBUFSZ);
+	}
+
+	return buf;
+}
+
+static int print_features(struct btrfs_ioctl_feature_flags *flags)
+{
+	char *compat, *compat_ro, *incompat;
+
+	compat = feature_names(FEAT_COMPAT, flags->compat_flags);
+	compat_ro = feature_names(FEAT_COMPAT_RO, flags->compat_ro_flags);
+	incompat = feature_names(FEAT_INCOMPAT, flags->incompat_flags);
+
+	printf("Features enabled: %s%s%s%s%s\n", compat, compat[0] ? "," : "",
+	       compat_ro, compat_ro[0] ? "," : "", incompat);
+
+	free(compat);
+	free(compat_ro);
+	free(incompat);
+
+	return 0;
+}
+
+static int get_features_mounted(const char *mount_path)
+{
+	int fd;
+	struct btrfs_ioctl_feature_flags flags;
+
+	fd = open(mount_path, O_RDONLY | O_NOATIME);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: unable to access '%s': %s\n",
+			mount_path, strerror(errno));
+		return -1;
+	}
+
+	if (ioctl(fd, BTRFS_IOC_GET_FEATURES, &flags) < 0) {
+		fprintf(stderr,
+			"ERROR: unable to get features from kernel: %s\n",
+			strerror(errno));
+		close(fd);
+		return -1;
+	}
+	close(fd);
+
+	return print_features(&flags);
+}
+
+static int get_features_unmounted(const char *btrfs_dev)
+{
+	int ret;
+	struct btrfs_root *root;
+	struct btrfs_super_block *disk_super;
+	struct btrfs_ioctl_feature_flags flags;
+
+	ret = check_mounted(btrfs_dev);
+	if (ret < 0) {
+	       fprintf(stderr, "FATAL: error checking %s mount status\n",
+		       btrfs_dev);
+	       return -1;
+	}
+	if (ret > 0) {
+		fprintf(stderr, "ERROR: dev %s is mounted, use mount point\n",
+			btrfs_dev);
+		return -1;
+	}
+
+	/* Open the super_block at the default location
+	 * and as read-only.
+	 */
+	root = open_ctree(btrfs_dev, 0, 0);
+	if(!root)
+		return -1;
+
+	disk_super = root->fs_info->super_copy;
+
+	flags.compat_flags = btrfs_super_compat_flags(disk_super);
+	flags.compat_ro_flags = btrfs_super_compat_ro_flags(disk_super);
+	flags.incompat_flags = btrfs_super_incompat_flags(disk_super);
+
+	close_ctree(root);
+
+	return print_features(&flags);
+}
+
+int get_features(const char *btrfs_dev)
+{
+	return is_existing_blk_or_reg_file(btrfs_dev) ?
+		get_features_unmounted(btrfs_dev) :
+		get_features_mounted(btrfs_dev);
+
+}
+
+static int __check_feature_bits(const char *source,
+				int type, u64 flags, u64 supported_flags,
+				u64 allowed_flags, int force)
+{
+	u64 unsupported, disallowed;
+	const char *errlevel = force ? "WARNING" : "ERROR";
+
+	unsupported = (flags & ~supported_flags);
+	if (unsupported) {
+		char *names = feature_names(type, unsupported);
+		fprintf(stderr,
+			"%s: %s does not support %s features: %s\n",
+			errlevel, source, feature_type[type], names);
+		free(names);
+	}
+
+	disallowed = (flags & ~allowed_flags) & ~unsupported;
+	if (disallowed) {
+		char *names = feature_names(type, disallowed);
+		fprintf(stderr,
+			"%s: %s does not support online changing of %s features: %s\n",
+			errlevel, source, feature_type[type], names);
+		free(names);
+	}
+
+	if (unsupported || disallowed) {
+		if (type == FEAT_INCOMPAT)
+			fprintf(stderr,
+				"%s: changing an unrecognized incompatible feature may result in a\n%s: file system that must be manually repaired.\n",
+				errlevel, errlevel);
+		return -1;
+	}
+	return 0;
+}
+
+#define check_feature_bits_mounted(a,b,c,d) \
+	__check_feature_bits("kernel", a, b, c, d, 0)
+
+#define check_feature_bits_unmounted(a,b,c,d, e) \
+	__check_feature_bits("progs", a, b, c, d, e)
+
+static int set_features_mounted(const char *mount_path,
+			const struct btrfs_ioctl_feature_flags *flags,
+			const struct btrfs_ioctl_feature_flags *clear_flags)
+{
+	int fd;
+	int ret;
+	struct btrfs_ioctl_feature_flags kernel_flags[2];
+
+	if (clear_flags->compat_flags || clear_flags->compat_ro_flags ||
+	    clear_flags->incompat_flags) {
+		fprintf(stderr,
+			"ERROR: clearing flags is not supported on mounted filesystems.\n");
+		return -1;
+	}
+
+	fd = open(mount_path, O_RDONLY | O_NOATIME);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: unable to access '%s': %s\n",
+			mount_path, strerror(errno));
+		return -1;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_GET_SUPPORTED_FEATURES, kernel_flags);
+	if (ret) {
+		fprintf(stderr,
+			"ERROR: unable to get the kernel's supported feature list: %s\n",
+			strerror(errno));
+		goto out;
+	}
+
+	ret = check_feature_bits_mounted(FEAT_COMPAT, flags->compat_flags,
+					 kernel_flags[0].compat_flags,
+					 kernel_flags[1].compat_flags);
+
+	ret |= check_feature_bits_mounted(FEAT_COMPAT_RO,
+					  flags->compat_ro_flags,
+					  kernel_flags[0].compat_ro_flags,
+					  kernel_flags[1].compat_ro_flags);
+
+	ret |= check_feature_bits_mounted(FEAT_INCOMPAT, flags->incompat_flags,
+					  kernel_flags[0].incompat_flags,
+					  kernel_flags[1].incompat_flags);
+	if (ret)
+		goto out;
+
+	ret = ioctl(fd, BTRFS_IOC_ADD_FEATURES, &flags);
+	if (ret)
+		fprintf(stderr,
+			"ERROR: failed to add features on file system mounted at %s\n",
+			mount_path);
+out:
+	close(fd);
+	return ret;
+}
+
+static int set_features_unmounted(const char *device,
+			const struct btrfs_ioctl_feature_flags *flags,
+			const struct btrfs_ioctl_feature_flags *clear_flags,
+			int force)
+{
+	struct btrfs_root *root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_super_block *disk_super;
+	u64 super_flags;
+	int ret;
+
+	ret = check_feature_bits_unmounted(FEAT_COMPAT, flags->compat_flags,
+					   BTRFS_FEATURE_COMPAT_SUPP,
+					   BTRFS_FEATURE_COMPAT_SUPP, force);
+	ret |= check_feature_bits_unmounted(FEAT_COMPAT_RO,
+					    flags->compat_ro_flags,
+					    BTRFS_FEATURE_COMPAT_RO_SUPP,
+					    BTRFS_FEATURE_COMPAT_RO_SUPP,
+					    force);
+	ret |= check_feature_bits_unmounted(FEAT_INCOMPAT,
+					    flags->incompat_flags,
+					    BTRFS_FEATURE_INCOMPAT_SUPP,
+					    BTRFS_FEATURE_INCOMPAT_SUPP, force);
+	if (clear_flags) {
+		ret |= check_feature_bits_unmounted(FEAT_COMPAT,
+					    clear_flags->compat_flags,
+					    BTRFS_FEATURE_COMPAT_SUPP,
+					    BTRFS_FEATURE_COMPAT_SUPP, force);
+		ret |= check_feature_bits_unmounted(FEAT_COMPAT_RO,
+					    clear_flags->compat_ro_flags,
+					    BTRFS_FEATURE_COMPAT_RO_SUPP,
+					    BTRFS_FEATURE_COMPAT_RO_SUPP,
+					    force);
+		ret |= check_feature_bits_unmounted(FEAT_INCOMPAT,
+					    clear_flags->incompat_flags,
+					    BTRFS_FEATURE_INCOMPAT_SUPP,
+					    BTRFS_FEATURE_INCOMPAT_SUPP, force);
+	}
+	if (ret && !force)
+		return 1;
+
+	ret = check_mounted(device);
+	if (ret < 0) {
+	       fprintf(stderr, "FATAL: error checking %s mount status\n",
+		       device);
+	       return -1;
+	}
+	if (ret > 0) {
+		fprintf(stderr, "ERROR: dev %s is mounted, use mount point\n",
+			device);
+		return -1;
+	}
+
+	root = open_ctree(device, 0, 1);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		return 1;
+	}
+
+	disk_super = root->fs_info->super_copy;
+
+	trans = btrfs_start_transaction(root, 1);
+
+	super_flags = btrfs_super_compat_flags(disk_super);
+	super_flags |= flags->compat_flags;
+	if (clear_flags)
+		super_flags &= ~clear_flags->compat_flags;
+	btrfs_set_super_compat_flags(disk_super, super_flags);
+
+	super_flags = btrfs_super_compat_ro_flags(disk_super);
+	super_flags |= flags->compat_ro_flags;
+	if (clear_flags)
+		super_flags &= ~clear_flags->compat_ro_flags;
+	btrfs_set_super_compat_ro_flags(disk_super, super_flags);
+
+	super_flags = btrfs_super_incompat_flags(disk_super);
+	super_flags |= flags->incompat_flags;
+	if (clear_flags)
+		super_flags &= ~clear_flags->incompat_flags;
+	btrfs_set_super_incompat_flags(disk_super, super_flags);
+
+	btrfs_commit_transaction(trans,root);
+
+	return 0;
+}
+
+static int parse_numbered_feature(const char *feature,
+				  struct btrfs_ioctl_feature_flags *flags)
+{
+	int ret = -1;
+	u64 *fptr = NULL;
+	char *fname = strdup(feature);
+	char *colon = strchr(fname, ':');
+	unsigned long num;
+
+	if (!colon)
+		goto fail;
+
+	*colon++ = 0;
+
+	num = strtoul(colon, NULL, 10);
+	if (num == ULONG_MAX) {
+		fprintf(stderr,
+			"ERROR: invalid numbered feature predicate: %s\n",
+			colon);
+		goto fail;
+	}
+
+	if (!strcmp(fname, "compat"))
+		fptr = &flags->compat_flags;
+	else if (!strcmp(fname, "compat_ro"))
+		fptr = &flags->compat_ro_flags;
+	else if (!strcmp(fname, "incompat"))
+		fptr = &flags->incompat_flags;
+
+	if (!fptr) {
+		fprintf(stderr,
+			"ERROR: invalid numbered feature prefix: %s\n", fname);
+
+		goto fail;
+	}
+
+	*fptr |= (1ULL << num);
+
+	ret = 0;
+fail:
+	free(fname);
+	return ret;
+
+}
+
+int parse_features(const char *features,
+		   struct btrfs_ioctl_feature_flags *set_flags,
+		   struct btrfs_ioctl_feature_flags *cleared_flags)
+{
+	char *s, *ptr, *tmp;
+	int ret = -1;
+
+	memset(set_flags, 0, sizeof(*set_flags));
+	memset(cleared_flags, 0, sizeof(*cleared_flags));
+
+	s = ptr = tmp = strdup(features);
+
+	while ((s = strsep(&tmp, ","))) {
+		struct btrfs_ioctl_feature_flags *flags = set_flags;
+		int i;
+		if (s[0] == '^') {
+			flags = cleared_flags;
+			s++;
+		}
+
+		if (strchr(s, ':')) {
+			ret = parse_numbered_feature(s, flags);
+			if (ret)
+				goto out;
+			continue;
+		}
+		for (i = 0; i < ARRAY_SIZE(compat_features); i++) {
+			if (!strcmp(compat_features[i], s)) {
+				flags->compat_flags |= (1ULL << i);
+				continue;
+			}
+		}
+
+		for (i = 0; i < ARRAY_SIZE(compat_ro_features); i++) {
+			if (!strcmp(compat_ro_features[i], s)) {
+				flags->compat_ro_flags |= (1ULL << i);
+				continue;
+			}
+		}
+
+		for (i = 0; i < ARRAY_SIZE(incompat_features); i++) {
+			if (!strcmp(incompat_features[i], s)) {
+				flags->incompat_flags |= (1ULL << i);
+				continue;
+			}
+		}
+		fprintf(stderr, "ERROR: unknown named feature %s\n", s);
+		goto out;
+	}
+
+	ret = 0;
+out:
+	free(ptr);
+	return ret;
+}
+
+int set_features(const char *dev,
+		 const struct btrfs_ioctl_feature_flags *set_flags,
+		 const struct btrfs_ioctl_feature_flags *clear_flags, int force)
+{
+	return is_existing_blk_or_reg_file(dev) ?
+		set_features_unmounted(dev, set_flags, clear_flags, force) :
+		set_features_mounted(dev, set_flags, clear_flags);
+}
+
+int parse_and_set_features(const char *btrfs_dev, const char *features,
+			   int force)
+{
+	int ret;
+	struct btrfs_ioctl_feature_flags set_flags, clear_flags;
+
+	ret = parse_features(features, &set_flags, &clear_flags);
+	if (ret)
+		return ret;
+
+	if ((clear_flags.compat_flags || clear_flags.compat_ro_flags ||
+	    clear_flags.incompat_flags) && !force) {
+		fprintf(stderr, "ERROR: clearing flags is dangerous and requires the -f option to continue.\nERROR: if clearing a flag that indicates the presence of an on-disk feature\nERROR: that is in use, serious corruption and/or crashes may result.\nERROR: PROCEED WITH CAUTION.\n");
+		return -1;
+	}
+
+	return set_features(btrfs_dev, &set_flags, &clear_flags, force);
+}
+
 int btrfs_scan_block_devices(int run_ioctl)
 {
 
diff --git a/utils.h b/utils.h
index 3c17e14..ca86025 100644
--- a/utils.h
+++ b/utils.h
@@ -55,6 +55,16 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
 int get_label(const char *btrfs_dev);
 int set_label(const char *btrfs_dev, const char *label);
+int get_features(const char *btrfs_dev);
+int parse_features(const char *features,
+		   struct btrfs_ioctl_feature_flags *set_flags,
+		   struct btrfs_ioctl_feature_flags *clear_flags);
+int set_features(const char *btrfs_dev,
+		 const struct btrfs_ioctl_feature_flags *flags,
+		 const struct btrfs_ioctl_feature_flags *clear_flags,
+		 int force);
+int parse_and_set_features(const char *btrfs_dev, const char *features,
+			   int force);
 
 char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
-- 
1.8.1.4


-- 
Jeff Mahoney
SUSE Labs
