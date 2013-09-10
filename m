Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3IJEfK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:35:10 -0400
Message-ID: <522EA170.1030003@suse.com>
Date: Tue, 10 Sep 2013 00:34:56 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <clmason@fusionio.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2 v2] utils: add support for getting/changing file system,
 features
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds support for getting and changing file system
feature bits. It supports both unmounted and mounted operation via
a new set of ioctls.

Changing bits not supported by the tools directly can be forced with -f
when the file system is unmounted.

v2: Implemented new ioctl methods from newer ioctl patchset; Cleanup

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-filesystem.c |  43 ++++
 ioctl.h           |  12 ++
 man/btrfs.8.in    |  28 +++
 utils.c           | 588 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |   9 +
 5 files changed, 680 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..8e2e693 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -515,6 +515,48 @@ static int cmd_label(int argc, char **argv)
 		return get_label(argv[1]);
 }
 
+static const char * const cmd_features_usage[] = {
+	"btrfs filesystem features [<device>|<mountpoint>] [[-f] <features>]",
+	"Get or change the list of features currently enabled by a filesystem",
+	"With one argument, get the currently enabled features of filesystem",
+	"on <device> or <mountpoint>.", "",
+	"If <features> is passed, add or remove new features to the ",
+	"filesystem.  The format of features can be a comma separated list ",
+	"of names or or a comma-separated list of specifiers of the following",
+	"format: A prefix of compat, compat_ro, or incompat and a decimal",
+	"number, separated by a colon: (e.g. compat:10).  Prefixing the ",
+	"feature name with a caret (^) will clear the flag.", "",
+	"The kernel has a defined set of feature flags that it will allow",
+	"to be set or cleared at runtime.  Features not supported by the",
+	"tools can be changed by using the -f (force) flag when operating",
+	"on an unmounted filesystem.", "",
+	"A list of features supported by the tools can be found in the manual.",
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
@@ -524,6 +566,7 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ "features", cmd_features, cmd_features_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 },
 	}
 };
diff --git a/ioctl.h b/ioctl.h
index abe6dd4..3605c4a 100644
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
+#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 54, \
+				    struct btrfs_ioctl_feature_flags[2])
+#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 54, \
+				    struct btrfs_ioctl_feature_flags[3])
 
 #ifdef __cplusplus
 }
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index af7df4d..0b3815f 100644
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
+It is possible, but not recommended to set undocumented features using one of the following prefixes: compat, compat_ro, incompat and a bit number, separated by a colon. e.g. compat:12. Please note that changing unrecognized feature bits is a dangerous operation and may result in an umountable file system that needs to be manually repaired by an expert. It is also possible to clear a set flag by prefixing the flag name with a caret (^).
+.TP
+
 \fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
 Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
 \fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
diff --git a/utils.c b/utils.c
index 7b4cd74..447ca9c 100644
--- a/utils.c
+++ b/utils.c
@@ -1350,6 +1350,594 @@ int set_label(const char *btrfs_dev, const char *label)
 		set_label_mounted(btrfs_dev, label);
 }
 
+enum {
+	FEAT_COMPAT = 0,
+	FEAT_COMPAT_RO,
+	FEAT_INCOMPAT,
+};
+
+static const char * const feature_type[] = {
+	"compat",
+	"compat_ro",
+	"incompat",
+};
+
+static const char * const compat_features[] = {};
+static const char * const compat_ro_features[] = {};
+static const char * const incompat_features[] = {
+	"mixed_backref",
+	"default_subvol",
+	"mixed_groups",
+	"compress_lzo",
+	"compress_lzov2",
+	"big_metadata",
+	"extended_iref",
+	"raid56",
+	"skinny_metadata",
+};
+
+#define NAMEBUFSZ 4096 /* 64 names * 64 bytes/name (safe max) */
+static char *feature_names(int type, u64 flags)
+{
+	int i;
+	int name_count;
+	const char **names;
+	int count = 0;
+	char *buf = malloc(NAMEBUFSZ);
+	char *ptr = buf;
+	char typename[10]; /* compat_ro + 1 */
+
+	if (!buf)
+		return NULL;
+
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
+static int print_features(const char *message,
+			  struct btrfs_ioctl_feature_flags *flags)
+{
+	char *compat = NULL, *compat_ro = NULL, *incompat = NULL;
+
+	compat = feature_names(FEAT_COMPAT, flags->compat_flags);
+	compat_ro = feature_names(FEAT_COMPAT_RO, flags->compat_ro_flags);
+	incompat = feature_names(FEAT_INCOMPAT, flags->incompat_flags);
+	if (!compat || !compat_ro || !incompat)
+		goto enomem;
+
+	printf("%s: %s%s%s%s%s\n", message,
+	       compat, compat[0] ? "," : "", compat_ro,
+	       compat_ro[0] ? "," : "", incompat);
+
+	free(compat);
+	free(compat_ro);
+	free(incompat);
+
+	return 0;
+
+enomem:
+	fprintf(stderr,
+		"ERROR: Couldn't allocate memory while printing features.\n");
+	free(compat);
+	free(compat_ro);
+	free(incompat);
+	return -ENOMEM;
+}
+
+static int get_features_mounted(const char *mount_path)
+{
+	int fd;
+	struct btrfs_ioctl_feature_flags flags[3];
+	int ret;
+
+	fd = open(mount_path, O_RDONLY | O_DIRECTORY);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: unable to access '%s': %s\n",
+			mount_path, strerror(errno));
+		return -1;
+	}
+
+	if (ioctl(fd, BTRFS_IOC_GET_SUPPORTED_FEATURES, &flags) < 0) {
+		ret = -errno;
+		fprintf(stderr,
+			"ERROR: unable to get supported features from kernel: %s\n",
+			strerror(errno));
+		close(fd);
+		return errno;
+	}
+
+	ret = print_features("Features supported by running kernel",
+			     &flags[0]);
+	if (ret) {
+		close(fd);
+		return ret;
+	}
+
+	ret = print_features("Features that can be enabled by running kernel",
+			     &flags[1]);
+	if (ret) {
+		close(fd);
+		return ret;
+	}
+
+	ret = print_features("Features that can be cleared by running kernel",
+			     &flags[2]);
+	if (ret) {
+		close(fd);
+		return ret;
+	}
+
+	if (ioctl(fd, BTRFS_IOC_GET_FEATURES, &flags[0]) < 0) {
+		ret = -errno;
+		fprintf(stderr,
+			"ERROR: unable to get features from kernel: %s\n",
+			strerror(errno));
+		close(fd);
+		return ret;
+	}
+	close(fd);
+
+	return print_features("Features enabled on filesystem", &flags[0]);
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
+		fprintf(stderr, "FATAL: error checking %s mount status\n",
+			btrfs_dev);
+		return -1;
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
+	if (!root)
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
+	return print_features("Features enabled on filesystem: ", &flags);
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
+				int type, u64 change_mask,
+				u64 flags, u64 supported_flags,
+				u64 allowed_set, u64 allowed_clear,
+				int force)
+{
+	u64 unsupported, set, clear;
+	const char *errlevel = force ? "WARNING" : "ERROR";
+
+	unsupported = flags & change_mask & ~supported_flags;
+	if (unsupported) {
+		char *names = feature_names(type, unsupported);
+		if (names) {
+			fprintf(stderr,
+				"%s: %s does not support %s features: %s\n",
+				errlevel, source, feature_type[type], names);
+			free(names);
+		} else
+			fprintf(stderr,
+				"%s: %s does not support %s feature bits: %llx\n",
+				errlevel, source, feature_type[type],
+				unsupported);
+	}
+
+	set = flags & ~change_mask & allowed_set & ~unsupported;
+	if (set) {
+		char *names = feature_names(type, set);
+		if (names) {
+			fprintf(stderr,
+				"%s: %s does not support online setting of %s features: %s\n",
+				errlevel, source, feature_type[type], names);
+			free(names);
+		} else
+			fprintf(stderr,
+				"%s: %s does not support online setting of %s feature bits: %llx\n",
+				errlevel, source, feature_type[type], set);
+	}
+
+	clear = ~flags & ~change_mask & allowed_clear & ~unsupported;
+	if (clear) {
+		char *names = feature_names(type, clear);
+		if (names) {
+			fprintf(stderr,
+				"%s: %s does not support online clearing of %s features: %s\n",
+				errlevel, source, feature_type[type], names);
+			free(names);
+		} else
+			fprintf(stderr,
+				"%s: %s does not support online clearing of %s feature bits: %llx\n",
+				errlevel, source, feature_type[type], clear);
+	}
+
+	if (unsupported || set || clear) {
+		if (type == FEAT_INCOMPAT)
+			fprintf(stderr,
+				"Changing an unrecognized incompatible feature may result in a\nfile system that must be manually repaired.\n");
+		return -1;
+	}
+	return 0;
+}
+
+#define check_feature_bits_mounted(a, b, c, d, e, f) \
+	__check_feature_bits("kernel", a, b, c, d, e, f, 0)
+
+#define check_feature_bits_unmounted(a, b, c, d, e) \
+	__check_feature_bits("progs", a, b, c, d, d, d, e)
+
+static int set_features_mounted(const char *mount_path,
+			const struct btrfs_ioctl_feature_flags *change_mask,
+			const struct btrfs_ioctl_feature_flags *flags)
+{
+	int fd;
+	int ret;
+	struct btrfs_ioctl_feature_flags kernel_flags[3];
+	struct btrfs_ioctl_feature_flags our_flags[2];
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
+	/*
+	 * The kernel will perform these checks as well. We repeat the checks
+	 * in order to give the user something more helpful than -EPERM
+	 * in the failure case.
+	 */
+	ret = check_feature_bits_mounted(FEAT_COMPAT,
+					 change_mask->compat_flags,
+					 flags->compat_flags,
+					 kernel_flags[0].compat_flags,
+					 kernel_flags[1].compat_flags,
+					 kernel_flags[2].compat_flags);
+
+	ret |= check_feature_bits_mounted(FEAT_COMPAT_RO,
+					  change_mask->compat_ro_flags,
+					  flags->compat_ro_flags,
+					  kernel_flags[0].compat_ro_flags,
+					  kernel_flags[1].compat_ro_flags,
+					  kernel_flags[2].compat_ro_flags);
+
+	ret |= check_feature_bits_mounted(FEAT_INCOMPAT,
+					  change_mask->incompat_flags,
+					  flags->incompat_flags,
+					  kernel_flags[0].incompat_flags,
+					  kernel_flags[1].incompat_flags,
+					  kernel_flags[2].incompat_flags);
+	if (ret)
+		goto out;
+
+	our_flags[0].compat_flags = change_mask->compat_flags;
+	our_flags[1].compat_flags = flags->compat_flags;
+	our_flags[0].compat_ro_flags = change_mask->compat_ro_flags;
+	our_flags[1].compat_ro_flags = flags->compat_ro_flags;
+	our_flags[0].incompat_flags = change_mask->incompat_flags;
+	our_flags[1].incompat_flags = flags->incompat_flags;
+
+	ret = ioctl(fd, BTRFS_IOC_SET_FEATURES, our_flags);
+	if (ret)
+		fprintf(stderr, "ERROR: failed to change features: %s\n",
+			strerror(errno));
+out:
+	close(fd);
+	return ret;
+}
+
+static int set_features_unmounted(const char *device,
+			const struct btrfs_ioctl_feature_flags *change_mask,
+			const struct btrfs_ioctl_feature_flags *flags,
+			int force)
+{
+	struct btrfs_root *root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_super_block *disk_super;
+	u64 super_flags;
+	int ret;
+
+	ret = check_feature_bits_unmounted(FEAT_COMPAT,
+					   change_mask->compat_flags,
+					   flags->compat_flags,
+					   BTRFS_FEATURE_COMPAT_SUPP,
+					   force);
+	ret |= check_feature_bits_unmounted(FEAT_COMPAT_RO,
+					    change_mask->compat_ro_flags,
+					    flags->compat_ro_flags,
+					    BTRFS_FEATURE_COMPAT_RO_SUPP,
+					    force);
+	ret |= check_feature_bits_unmounted(FEAT_INCOMPAT,
+					    change_mask->incompat_flags,
+					    flags->incompat_flags,
+					    BTRFS_FEATURE_INCOMPAT_SUPP,
+					    force);
+
+	if (((change_mask->compat_flags & ~flags->compat_flags) ||
+	     (change_mask->compat_ro_flags & ~flags->compat_ro_flags) ||
+	     (change_mask->incompat_flags & ~flags->incompat_flags)) &&
+	    !force) {
+		fprintf(stderr, "ERROR\nclearing flags is dangerous and requires the -f option to continue.\nif clearing a flag that indicates the presence of an on-disk feature\nthat is in use, serious corruption and/or crashes may result.\nPROCEED WITH CAUTION.\n");
+		return -1;
+	}
+
+	if (ret && !force)
+		return 1;
+
+	ret = check_mounted(device);
+	if (ret < 0) {
+		fprintf(stderr, "FATAL: error checking %s mount status\n",
+			device);
+		return -1;
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
+	super_flags |= (change_mask->compat_flags & flags->compat_flags);
+	super_flags &= ~(change_mask->compat_flags &
+			 ~flags->compat_flags);
+	btrfs_set_super_compat_flags(disk_super, super_flags);
+
+	super_flags = btrfs_super_compat_ro_flags(disk_super);
+	super_flags |= (change_mask->compat_ro_flags & flags->compat_ro_flags);
+	super_flags &= ~(change_mask->compat_ro_flags &
+			 ~flags->compat_ro_flags);
+	btrfs_set_super_compat_ro_flags(disk_super, super_flags);
+
+	super_flags = btrfs_super_incompat_flags(disk_super);
+	super_flags |= (change_mask->incompat_flags & flags->incompat_flags);
+	super_flags &= ~(change_mask->incompat_flags &
+			 ~flags->incompat_flags);
+	btrfs_set_super_incompat_flags(disk_super, super_flags);
+
+	btrfs_commit_transaction(trans, root);
+
+	return 0;
+}
+
+static int parse_numbered_feature(const char *feature, int set,
+				  struct btrfs_ioctl_feature_flags *change_mask,
+				  struct btrfs_ioctl_feature_flags *flags)
+{
+	int ret = -1;
+	u64 *fptr = NULL;
+	u64 *mptr = NULL;
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
+	if (!strcmp(fname, "compat")) {
+		mptr = &change_mask->compat_flags;
+		fptr = &flags->compat_flags;
+	} else if (!strcmp(fname, "compat_ro")) {
+		mptr = &change_mask->compat_ro_flags;
+		fptr = &flags->compat_ro_flags;
+	} else if (!strcmp(fname, "incompat")) {
+		mptr = &change_mask->incompat_flags;
+		fptr = &flags->incompat_flags;
+	}
+
+	if (!fptr) {
+		fprintf(stderr,
+			"ERROR: invalid numbered feature prefix: %s\n", fname);
+
+		goto fail;
+	}
+
+	*mptr |= (1ULL << num);
+	if (set)
+		*fptr |= (1ULL << num);
+	else
+		*fptr &= ~(1ULL << num);
+
+	ret = 0;
+fail:
+	free(fname);
+	return ret;
+
+}
+
+int parse_features(const char *features,
+		   struct btrfs_ioctl_feature_flags *change_mask,
+		   struct btrfs_ioctl_feature_flags *flags)
+{
+	char *s, *ptr, *tmp;
+	int ret;
+
+	memset(change_mask, 0, sizeof(*change_mask));
+	memset(flags, 0, sizeof(*flags));
+
+	ptr = tmp = strdup(features);
+
+	while ((s = strsep(&tmp, ","))) {
+		int i;
+		int set = 1;
+		u64 bit;
+		if (s[0] == '^') {
+			set = 0;
+			s++;
+		}
+
+		if (strchr(s, ':')) {
+			ret = parse_numbered_feature(s, set, change_mask,
+						     flags);
+			if (ret)
+				goto out;
+			continue;
+		}
+		for (i = 0; i < ARRAY_SIZE(compat_features); i++) {
+			if (!strcmp(compat_features[i], s)) {
+				bit = (1ULL << i);
+				change_mask->compat_flags |= bit;
+				if (set)
+					flags->compat_flags |= bit;
+				else
+					flags->compat_flags &= ~bit;
+				s = NULL;
+				break;
+			}
+		}
+
+		for (i = 0; i < ARRAY_SIZE(compat_ro_features); i++) {
+			if (!strcmp(compat_ro_features[i], s)) {
+				bit = (1ULL << i);
+				change_mask->compat_ro_flags |= bit;
+				if (set)
+					flags->compat_ro_flags |= bit;
+				else
+					flags->compat_ro_flags &= ~bit;
+				s = NULL;
+				break;
+			}
+		}
+
+		for (i = 0; i < ARRAY_SIZE(incompat_features); i++) {
+			if (!strcmp(incompat_features[i], s)) {
+				bit = (1ULL << i);
+				change_mask->incompat_flags |= bit;
+				if (set)
+					flags->incompat_flags |= bit;
+				else
+					flags->incompat_flags &= ~bit;
+				s = NULL;
+				break;
+			}
+		}
+
+		if (s) {
+			fprintf(stderr, "ERROR: unknown named feature %s\n", s);
+			ret = -1;
+			goto out;
+		}
+	}
+
+	ret = 0;
+out:
+	free(ptr);
+	return ret;
+}
+
+int set_features(const char *dev,
+		 const struct btrfs_ioctl_feature_flags *change_mask,
+		 const struct btrfs_ioctl_feature_flags *flags, int force)
+{
+	if (is_existing_blk_or_reg_file(dev))
+		return set_features_unmounted(dev, change_mask, flags, force);
+
+	return set_features_mounted(dev, change_mask, flags);
+}
+
+int parse_and_set_features(const char *btrfs_dev, const char *features,
+			   int force)
+{
+	int ret;
+	struct btrfs_ioctl_feature_flags change_mask, flags;
+
+	ret = parse_features(features, &change_mask, &flags);
+	if (ret)
+		return ret;
+
+	return set_features(btrfs_dev, &change_mask, &flags, force);
+}
+
 int btrfs_scan_block_devices(int run_ioctl)
 {
 
diff --git a/utils.h b/utils.h
index 3c17e14..6faad28 100644
--- a/utils.h
+++ b/utils.h
@@ -55,6 +55,15 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
 int get_label(const char *btrfs_dev);
 int set_label(const char *btrfs_dev, const char *label);
+int get_features(const char *btrfs_dev);
+int parse_features(const char *features,
+		   struct btrfs_ioctl_feature_flags *change_mask,
+		   struct btrfs_ioctl_feature_flags *flags);
+int set_features(const char *btrfs_dev,
+		 const struct btrfs_ioctl_feature_flags *change_mask,
+		 const struct btrfs_ioctl_feature_flags *flags, int force);
+int parse_and_set_features(const char *btrfs_dev, const char *features,
+			   int force);
 
 char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
-- 
1.8.1.4


-- 
Jeff Mahoney
SUSE Labs
