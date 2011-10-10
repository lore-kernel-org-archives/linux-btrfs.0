From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0] btrfs-progs: add qgroup commands
Date: Mon, 10 Oct 2011 17:14:27 +0200
Message-ID: <1318259667-27560-1-git-send-email-sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This adds the necessary interface to control the qgroups feature. The
command set is still preliminary and low-level. It is planned to add
some convenience commands to manage common usecases. There's still work
to be done to define a good representation for the end user.
I'll add a manpage in a later version, when we settle on an interface.

See http://sensille.com/qgroups.pdf for an explanation of the concepts.

Commands added by this patch:

btrfs quota enable
    Enable subvolume quota support for a filesystem. It creates the quota
    tree.

btrfs quota disable
    Disable subvolume quota support for a filesystem. It removes the quota
    tree and with it all configuration information.

btrfs quota rescan
    Triggers a full re-init of quota information, doing a full fs rescan.
    Kernel side currently does not implement it yet.

btrfs qgroup assign <srcid> <destid> <path>
    Assigns the lower level qgroup src to the higher level qgroup dest in the
    btrfs found in <path>. It is used to build qgroup hierarchies.

btrfs qgroup remove <srcid> <destid> <path>
    Remove the qgroup src from the qgroup dest.

btrfs qgroup create <qgroupid> <path>
    Creates a qgroup with id <qgroupid> for the btrfs found in <path>. It will
    not be part of any hierarchy.

btrfs qgroup destroy <qgroupid> <path>
    Removes the qgroup qgroupid from the btrfs found in <path>. It will also
    be removed from any higher-level qgroups.

btrfs qgroup show
    Lists all configured qgroup together with the current exclusive and
    referenced values.

btrfs qgroup limit <size>|none <path-to-subvol>
btrfs qgroup limit <size>|none <qgroupid> <path-to-btrfs>
    Impose a limit of <size> for the amount of referenced space onto the
    qgroup <qgroupid> in btrfs <path-to-btrfs> or onto the qgroup referenced
    by <path-to-subvol>. A size of none removes the limit.

Commands extended for this patch:
btrfs subvolume create [-i <qid>] [-c <cspec>] [-x <cspec>] <name>
btrfs subvolume snapshot [-i <qid>] [-c <cspec>] [-x <cspec>] <source> <name>
    With the creation of a subvolume either by subvolume create or subvolume
    snapshot a qgroup gets created automatically. With -i this qgroup can be
    added to a higher level qgroup <qid> at creation time. This option can be
    given multiple times.
    -c and -x copy the values from one qgroup to another at creation time.
    In some usecases this is necessary to keep the values consistent. See
    the above mentioned concept paper for details. The copy spec <cspec>
    consists of two qgroupid separated by ':', giving <srcid>:<dstid>. -c
    copies the 'referenced' value, -x copies the 'exclusive' value.  These
    options can be given multiple times.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 btrfs.c      |   38 ++++-
 btrfs_cmds.c |  593 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 btrfs_cmds.h |    9 +
 ctree.h      |   91 +++++++++
 debug-tree.c |    6 +
 ioctl.h      |   63 ++++++-
 print-tree.c |  100 +++++++++-
 7 files changed, 881 insertions(+), 19 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index a3f9a01..38c15f5 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -60,7 +60,7 @@ static struct Command commands[] = {
 		"Delete the subvolume <subvolume>.",
 	  NULL
 	},
-	{ do_create_subvol, 1,
+	{ do_create_subvol, -1,
 	  "subvolume create", "[<dest>/]<name>\n"
 		"Create a subvolume in <dest> (or the current directory if\n"
 		"not passed).",
@@ -166,6 +166,42 @@ static struct Command commands[] = {
 		"Remove a device from a filesystem.",
 	  NULL
 	},
+	{ do_quota_enable, -1,
+	  "quota enable", "<path>\n"
+		"Enable subvolume quota support for a filesystem."
+	},
+	{ do_quota_disable, -1,
+	  "quota disable", "<path>\n"
+		"Disable subvolume quota support for a filesystem."
+	},
+	{ do_quota_rescan, -1,
+	  "quota rescan", "<path>\n"
+		"Rescan the subvolume for a changed quota setting."
+	},
+	{ do_qgroup_assign, 3,
+	  "qgroup assign", "<src> <dst> <path>\n"
+		"Assign a subvol to a quota group."
+	},
+	{ do_qgroup_remove, 3,
+	  "qgroup remove", "<src> <dst> <path>\n"
+		"Remove a subvol from a quota group."
+	},
+	{ do_qgroup_create, 2,
+	  "qgroup create", "<qgroupid> <path>\n"
+		"Create a subvolume quota group."
+	},
+	{ do_qgroup_destroy, 2,
+	  "qgroup destroy", "<qgroupid> <path>\n"
+		"Destroy a subvolume quota group."
+	},
+	{ do_qgroup_show, 1,
+	  "qgroup show", "<path>\n"
+		"Show all subvolume quota groups."
+	},
+	{ do_qgroup_limit, -2,
+	  "qgroup limit", "<size>|none {<qgroupid> <path>|<name>}\n"
+		"Limit the size of a subvolume quota group."
+	},
 	{ 0, 0, 0, 0 }
 };
 
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 699dfc2..8ddaa13 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -50,6 +50,11 @@ struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
 static inline int ioctl(int fd, int define, void *arg) { return 0; }
 #endif
 
+int inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
+int inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
+		     int type);
+int inherit_size(struct btrfs_qgroup_inherit *p);
+
 /*
  * test if path is a subvolume:
  * this function return
@@ -348,23 +353,39 @@ int do_subvol_list(int argc, char **argv)
 int do_clone(int argc, char **argv)
 {
 	char	*subvol, *dst;
-	int	res, fd, fddst, len, e, optind = 0, readonly = 0;
+	int	res, fd, fddst, len, e, readonly = 0;
 	char	*newname;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args_v2	args;
+	struct btrfs_qgroup_inherit *inherit = NULL;
 
 	memset(&args, 0, sizeof(args));
 
+	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "r");
+		int c = getopt(argc, argv, "ri:c:x:");
 
 		if (c < 0)
 			break;
 		switch (c) {
 		case 'r':
-			optind++;
 			readonly = 1;
 			break;
+		case 'i':
+			res = inherit_add_group(&inherit, optarg);
+			if (res)
+				return res;
+			break;
+		case 'c':
+			res = inherit_add_copy(&inherit, optarg, 0);
+			if (res)
+				return res;
+			break;
+		case 'x':
+			res = inherit_add_copy(&inherit, optarg, 1);
+			if (res)
+				return res;
+			break;
 		default:
 			fprintf(stderr,
 				"Invalid arguments for subvolume snapshot\n");
@@ -378,8 +399,8 @@ int do_clone(int argc, char **argv)
 		return 1;
 	}
 
-	subvol = argv[optind+1];
-	dst = argv[optind+2];
+	subvol = argv[optind];
+	dst = argv[optind+1];
 
 	res = test_issubvolume(subvol);
 	if(res<0){
@@ -445,6 +466,11 @@ int do_clone(int argc, char **argv)
 	}
 
 	args.fd = fd;
+	if (inherit) {
+		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
+		args.size = inherit_size(inherit);
+		args.qgroup_inherit = inherit;
+	}
 	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 	e = errno;
@@ -457,6 +483,7 @@ int do_clone(int argc, char **argv)
 			subvol, strerror(e));
 		return 11;
 	}
+	free(inherit);
 
 	return 0;
 
@@ -529,8 +556,44 @@ int do_create_subvol(int argc, char **argv)
 	int	res, fddst, len, e;
 	char	*newname;
 	char	*dstdir;
-	struct btrfs_ioctl_vol_args	args;
-	char	*dst = argv[1];
+	char	*dst;
+	struct btrfs_qgroup_inherit *inherit = NULL;
+
+	while (1) {
+		int c = getopt(argc, argv, "i:c:x:");
+
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'i':
+			res = inherit_add_group(&inherit, optarg);
+			if (res)
+				return res;
+			break;
+		case 'c':
+			res = inherit_add_copy(&inherit, optarg, 0);
+			if (res)
+				return res;
+			break;
+		case 'x':
+			res = inherit_add_copy(&inherit, optarg, 1);
+			if (res)
+				return res;
+			break;
+		default:
+			fprintf(stderr,
+				"Invalid arguments for subvolume create\n");
+			free(argv);
+			return 1;
+		}
+	}
+	if (argc - optind < 1) {
+		fprintf(stderr, "Invalid arguments for subvolume create\n");
+		free(argv);
+		return 1;
+	}
+
+	dst = argv[optind];
 
 	res = test_isdir(dst);
 	if(res >= 0 ){
@@ -564,8 +627,24 @@ int do_create_subvol(int argc, char **argv)
 	}
 
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
-	strncpy(args.name, newname, BTRFS_PATH_NAME_MAX);
-	res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
+	if (inherit) {
+		struct btrfs_ioctl_vol_args_v2	args;
+
+		memset(&args, 0, sizeof(args));
+		strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
+		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
+		args.size = inherit_size(inherit);
+		args.qgroup_inherit = inherit;
+
+		res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE_V2, &args);
+	} else {
+		struct btrfs_ioctl_vol_args	args;
+
+		memset(&args, 0, sizeof(args));
+		strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
+
+		res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
+	}
 	e = errno;
 
 	close(fddst);
@@ -576,6 +655,8 @@ int do_create_subvol(int argc, char **argv)
 		return 11;
 	}
 
+	free(inherit);
+
 	return 0;
 
 }
@@ -1055,3 +1136,497 @@ int do_df_filesystem(int nargs, char **argv)
 
 	return 0;
 }
+
+u64 parse_qgroupid(char *p)
+{
+	char *s = strchr(p, '/');
+	u64 level;
+	u64 id;
+
+	if (!s)
+		return atoll(p);
+	level = atoll(p);
+	id = atoll(s + 1);
+
+	return (level << 48) | id;
+}
+
+int inherit_size(struct btrfs_qgroup_inherit *p)
+{
+	return sizeof(*p) + sizeof(p->qgroups[0]) *
+			    (p->num_qgroups + 2 * p->num_ref_copies +
+			     2 * p->num_excl_copies);
+}
+
+int inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n, int pos)
+{
+	struct btrfs_qgroup_inherit *out;
+	int nitems = 0;
+
+	if (*inherit) {
+		nitems = (*inherit)->num_qgroups +
+			 (*inherit)->num_ref_copies +
+			 (*inherit)->num_excl_copies;
+	}
+
+	out = calloc(sizeof(*out) + sizeof(out->qgroups[0]) * (nitems + n), 1);
+	if (out == NULL) {
+		fprintf(stderr, "ERROR: Not enough memory\n");
+		return 13;
+	}
+
+	if (*inherit) {
+		struct btrfs_qgroup_inherit *i = *inherit;
+		int s = sizeof(out->qgroups);
+
+		out->num_qgroups = i->num_qgroups;
+		out->num_ref_copies = i->num_ref_copies;
+		out->num_excl_copies = i->num_excl_copies;
+		memcpy(out->qgroups, i->qgroups, pos * s);
+		memcpy(out->qgroups + pos + n, i->qgroups + pos,
+		       (nitems - pos) * s);
+	}
+	free(*inherit);
+	*inherit = out;
+
+	return 0;
+}
+
+int inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg)
+{
+	int ret;
+	u64 qgroupid = parse_qgroupid(arg);
+	int pos = 0;
+
+	if (qgroupid == 0) {
+		fprintf(stderr, "ERROR: bad qgroup specification\n");
+		return 12;
+	}
+
+	if (*inherit)
+		pos = (*inherit)->num_qgroups;
+	ret = inherit_realloc(inherit, 1, pos);
+	if (ret)
+		return ret;
+
+	(*inherit)->qgroups[(*inherit)->num_qgroups++] = qgroupid;
+
+	return 0;
+}
+
+int inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg, int type)
+{
+	int ret;
+	u64 qgroup_src;
+	u64 qgroup_dst;
+	char *p;
+	int pos = 0;
+
+	p = strchr(arg, ':');
+	if (!p) {
+bad:
+		fprintf(stderr, "ERROR: bad copy specification\n");
+		return 12;
+	}
+	*p = 0;
+	qgroup_src = parse_qgroupid(arg);
+	qgroup_dst = parse_qgroupid(p + 1);
+	*p = ':';
+
+	if (!qgroup_src || !qgroup_dst)
+		goto bad;
+
+printf("inherit: add copy %llx:%llx\n", qgroup_src, qgroup_dst);
+	if (*inherit)
+		pos = (*inherit)->num_qgroups +
+		      (*inherit)->num_ref_copies * 2 * type;
+
+	ret = inherit_realloc(inherit, 2, pos);
+	if (ret)
+		return ret;
+
+	(*inherit)->qgroups[pos++] = qgroup_src;
+	(*inherit)->qgroups[pos++] = qgroup_dst;
+
+	if (!type)
+		++(*inherit)->num_ref_copies;
+	else
+		++(*inherit)->num_excl_copies;
+
+	return 0;
+}
+
+int quota_ctl(int cmd, int nargs, char **argv)
+{
+	int	ret=0, fd, e;
+	char	*path = argv[1];
+	struct btrfs_ioctl_quota_ctl_args args;
+
+	memset(&args, 0, sizeof(args));
+	args.cmd = cmd;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_QUOTA_CTL, &args);
+	e = errno;
+	close(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: unable to enable subvolume quota: %s\n",
+			strerror(e));
+		return 30;
+	}
+	return 0;
+}
+
+int do_quota_enable(int nargs, char **argv)
+{
+	return quota_ctl(BTRFS_QUOTA_CTL_ENABLE, nargs, argv);
+}
+
+int do_quota_disable(int nargs, char **argv)
+{
+	return quota_ctl(BTRFS_QUOTA_CTL_DISABLE, nargs, argv);
+}
+
+int do_quota_rescan(int nargs, char **argv)
+{
+	return quota_ctl(BTRFS_QUOTA_CTL_RESCAN, nargs, argv);
+}
+
+int qgroup_assign(int assign, int nargs, char **argv)
+{
+	int	ret=0, fd, e;
+	char	*path = argv[3];
+	struct btrfs_ioctl_qgroup_assign_args args;
+
+	memset(&args, 0, sizeof(args));
+	args.assign = assign;
+	args.src = parse_qgroupid(argv[1]);
+	args.dst = parse_qgroupid(argv[2]);
+
+	/*
+	 * FIXME src should accept subvol path
+	 */
+	if (args.src >= args.dst) {
+		fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
+		return 12;
+	}
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_QGROUP_ASSIGN, &args);
+	e = errno;
+	close(fd);
+	if( ret < 0 ){
+		fprintf(stderr, "ERROR: unable to assign quota group: %s\n",
+			strerror(e));
+		return 30;
+	}
+	return 0;
+}
+
+int do_qgroup_assign(int nargs, char **argv)
+{
+	return qgroup_assign(1, nargs, argv);
+}
+
+int do_qgroup_remove(int nargs, char **argv)
+{
+	return qgroup_assign(0, nargs, argv);
+}
+
+int qgroup_create(int create, int nargs, char **argv)
+{
+	int	ret=0, fd, e;
+	char	*path = argv[2];
+	struct btrfs_ioctl_qgroup_create_args args;
+
+	memset(&args, 0, sizeof(args));
+	args.create = create;
+	args.qgroupid = parse_qgroupid(argv[1]);
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_QGROUP_CREATE, &args);
+	e = errno;
+	close(fd);
+	if( ret < 0 ){
+		fprintf(stderr, "ERROR: unable to assign quota group: %s\n",
+			strerror(e));
+		return 30;
+	}
+	return 0;
+}
+
+int do_qgroup_create(int nargs, char **argv)
+{
+	return qgroup_create(1, nargs, argv);
+}
+
+int do_qgroup_destroy(int nargs, char **argv)
+{
+	return qgroup_create(0, nargs, argv);
+}
+
+void print_qgroup_info(u64 objectid, struct btrfs_qgroup_info_item *info)
+{
+	printf("%llu/%llu %lld %lld\n", objectid >> 48,
+				objectid & ((1ll << 48) -1),
+				btrfs_stack_qgroup_info_referenced(info),
+				btrfs_stack_qgroup_info_exclusive(info));
+}
+
+int list_qgroups(int fd)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	unsigned long off = 0;
+	int i;
+	int e;
+	struct btrfs_qgroup_info_item *info;
+
+	memset(&args, 0, sizeof(args));
+
+	/* search in the quota tree */
+	sk->tree_id = BTRFS_QUOTA_TREE_OBJECTID;
+
+	/*
+	 * set the min and max to backref keys.  The search will
+	 * only send back this type of key now.
+	 */
+	sk->max_type = BTRFS_QGROUP_INFO_KEY;
+	sk->min_type = BTRFS_QGROUP_INFO_KEY;
+	sk->max_objectid = 0;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	/* just a big number, doesn't matter much */
+	sk->nr_items = 4096;
+
+	while(1) {
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			fprintf(stderr,
+				"ERROR: can't perform the search - %s\n",
+				strerror(e));
+			return ret;
+		}
+		/* the ioctl returns the number of item it found in nr_items */
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+
+		/*
+		 * for each item, pull the key out of the header and then
+		 * read the root_ref item it contains
+		 */
+		for (i = 0; i < sk->nr_items; i++) {
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+			off += sizeof(*sh);
+
+			if (sh->objectid != 0)
+				goto done;
+
+			if (sh->type != BTRFS_QGROUP_INFO_KEY)
+				goto done;
+
+			info = (struct btrfs_qgroup_info_item *)
+					(args.buf + off);
+			print_qgroup_info(sh->offset, info);
+
+			off += sh->len;
+
+			/*
+			 * record the mins in sk so we can make sure the
+			 * next search doesn't repeat this root
+			 */
+			sk->min_offset = sh->offset;
+		}
+		sk->nr_items = 4096;
+		/*
+		 * this iteration is done, step forward one qgroup for the next
+		 * ioctl
+		 */
+		if (sk->min_offset < (u64)-1) {
+			sk->min_offset++;
+		} else
+			break;
+	}
+
+done:
+	return ret;
+}
+
+int do_qgroup_show(int nargs, char **argv)
+{
+	int	ret=0, fd;
+	char	*path = argv[1];
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = list_qgroups(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: can't list qgroups\n");
+		return 30;
+	}
+
+	close(fd);
+
+	return ret;
+}
+
+static int parse_limit(const char *p, unsigned long long *s)
+{
+	char *endptr;
+	unsigned long long size;
+
+	if (strcasecmp(p, "none") == 0) {
+		*s = 0;
+		return 1;
+	}
+	size = strtoull(p, &endptr, 10);
+	switch (*endptr) {
+	case 'T':
+	case 't':
+		size *= 1024;
+	case 'G':
+	case 'g':
+		size *= 1024;
+	case 'M':
+	case 'm':
+		size *= 1024;
+	case 'K':
+	case 'k':
+		size *= 1024;
+		++endptr;
+		break;
+	case 0:
+		break;
+	default:
+		return 0;
+	}
+
+	if (*endptr)
+		return 0;
+
+	*s = size;
+
+	return 1;
+}
+
+int do_qgroup_limit(int argc, char **argv)
+{
+	int	ret=0, fd, e;
+	char	*path;
+	struct btrfs_ioctl_qgroup_limit_args args;
+	unsigned long long size;
+	int compressed = 0;
+	int exclusive = 0;
+
+	optind = 1;
+	while(1) {
+		int c = getopt(argc, argv, "ce");
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'c':
+			compressed = 1;
+			break;
+		case 'e':
+			exclusive = 1;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for qgroup limit\n");
+			free(argv);
+			return 1;
+		}
+	}
+
+	if (argc - optind < 2) {
+		fprintf(stderr, "Invalid arguments for qgroup limit\n");
+		free(argv);
+		return 1;
+	}
+
+	if (!parse_limit(argv[optind], &size)) {
+		fprintf(stderr, "Invalid size argument given\n");
+		free(argv);
+		return 1;
+	}
+
+	memset(&args, 0, sizeof(args));
+	args.qgroupid = parse_qgroupid(argv[optind + 1]);
+	if (size) {
+		if (compressed)
+			args.lim.flags |= BTRFS_QGROUP_LIMIT_RFER_CMPR |
+					  BTRFS_QGROUP_LIMIT_EXCL_CMPR;
+		if (exclusive) {
+			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_EXCL;
+			args.lim.max_exclusive = size;
+		} else {
+			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_RFER;
+			args.lim.max_referenced = size;
+		}
+	}
+
+	if (args.qgroupid == 0) {
+		path = argv[optind + 1];
+		ret = test_issubvolume(path);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: error accessing '%s'\n", path);
+			return 12;
+		}
+		if (!ret) {
+			fprintf(stderr, "ERROR: '%s' is not a subvolume\n",
+				path);
+			return 13;
+		}
+		/*
+		 * keep qgroupid at 0, this indicates that the subvolume the
+		 * fd refers to is to be limited
+		 */
+	} else {
+		if (argc - optind < 3) {
+			fprintf(stderr, "Invalid arguments for qgroup limit\n");
+			free(argv);
+			return 1;
+		}
+		path = argv[optind + 2];
+	}
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_QGROUP_LIMIT, &args);
+	e = errno;
+	close(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: unable to limit quota group: %s\n",
+			strerror(e));
+		return 30;
+	}
+	return 0;
+}
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 3e171da..e5fd9c0 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -38,3 +38,12 @@ int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int do_find_newer(int argc, char **argv);
 int do_change_label(int argc, char **argv);
 int open_file_or_dir(const char *fname);
+int do_quota_enable(int argc, char **argv);
+int do_quota_disable(int argc, char **argv);
+int do_quota_rescan(int argc, char **argv);
+int do_qgroup_assign(int argc, char **argv);
+int do_qgroup_remove(int argc, char **argv);
+int do_qgroup_create(int argc, char **argv);
+int do_qgroup_destroy(int argc, char **argv);
+int do_qgroup_show(int argc, char **argv);
+int do_qgroup_limit(int argc, char **argv);
diff --git a/ctree.h b/ctree.h
index 6e1b80b..bfa06d0 100644
--- a/ctree.h
+++ b/ctree.h
@@ -59,6 +59,7 @@ struct btrfs_trans_handle;
 #define BTRFS_ROOT_TREE_DIR_OBJECTID 6ULL
 /* holds checksums of all the data extents */
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
+#define BTRFS_QUOTA_TREE_OBJECTID 8ULL
 
 
 /* oprhan objectid for tracking unlinked/truncated files */
@@ -651,12 +652,49 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
 
+#define BTRFS_QGROUP_STATUS_OFF			0
+#define BTRFS_QGROUP_STATUS_ON			1
+#define BTRFS_QGROUP_STATUS_SCANNING		2
+
+#define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT	(1 << 0)
+
+struct btrfs_qgroup_status_item {
+	__le64 version;
+	__le64 generation;
+	__le64 flags;
+	__le64 scan;		/* progress during scanning */
+} __attribute__ ((__packed__));
+
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
 	__le64 flags;
 } __attribute__ ((__packed__));
 
+struct btrfs_qgroup_info_item {
+	__le64 generation;
+	__le64 referenced;
+	__le64 referenced_compressed;
+	__le64 exclusive;
+	__le64 exclusive_compressed;
+} __attribute__ ((__packed__));
+
+/* flags definition for qgroup limits */
+#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
+#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
+#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
+#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
+#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
+#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
+
+struct btrfs_qgroup_limit_item {
+	__le64 flags;
+	__le64 max_referenced;
+	__le64 max_exclusive;
+	__le64 rsv_referenced;
+	__le64 rsv_exclusive;
+} __attribute__ ((__packed__));
+
 struct btrfs_space_info {
 	u64 flags;
 	u64 total_bytes;
@@ -858,6 +896,14 @@ struct btrfs_root {
 #define BTRFS_CHUNK_ITEM_KEY	228
 
 /*
+ * quota groups
+ */
+#define BTRFS_QGROUP_STATUS_KEY		240
+#define BTRFS_QGROUP_INFO_KEY		242
+#define BTRFS_QGROUP_LIMIT_KEY		244
+#define BTRFS_QGROUP_RELATION_KEY	246
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
@@ -1635,6 +1681,51 @@ BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
 BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 		   other_encoding, 16);
 
+/* btrfs_qgroup_status_item */
+BTRFS_SETGET_FUNCS(qgroup_status_version, struct btrfs_qgroup_status_item,
+		   version, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_generation, struct btrfs_qgroup_status_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
+		   flags, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
+		   scan, 64);
+
+/* btrfs_qgroup_info_item */
+BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_referenced, struct btrfs_qgroup_info_item,
+		   referenced, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_referenced_compressed,
+		   struct btrfs_qgroup_info_item, referenced_compressed, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_exclusive, struct btrfs_qgroup_info_item,
+		   exclusive, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_exclusive_compressed,
+		   struct btrfs_qgroup_info_item, exclusive_compressed, 64);
+
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_generation,
+			 struct btrfs_qgroup_info_item, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_referenced,
+			 struct btrfs_qgroup_info_item, referenced, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_referenced_compressed,
+		   struct btrfs_qgroup_info_item, referenced_compressed, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_exclusive,
+			 struct btrfs_qgroup_info_item, exclusive, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_exclusive_compressed,
+		   struct btrfs_qgroup_info_item, exclusive_compressed, 64);
+
+/* btrfs_qgroup_limit_item */
+BTRFS_SETGET_FUNCS(qgroup_limit_flags, struct btrfs_qgroup_limit_item,
+		   flags, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_max_referenced, struct btrfs_qgroup_limit_item,
+		   max_referenced, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_max_exclusive, struct btrfs_qgroup_limit_item,
+		   max_exclusive, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_rsv_referenced, struct btrfs_qgroup_limit_item,
+		   rsv_referenced, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_rsv_exclusive, struct btrfs_qgroup_limit_item,
+		   rsv_exclusive, 64);
+
 /* this returns the number of file bytes represented by the inline item.
  * If an item is compressed, this is the uncompressed size
  */
diff --git a/debug-tree.c b/debug-tree.c
index 34cefe9..a3f9c31 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -238,6 +238,12 @@ again:
 				if (!skip) {
 					printf("extent checksum");
 				}
+				break;
+			case BTRFS_QUOTA_TREE_OBJECTID:
+				if (!skip) {
+					printf("quota");
+				}
+				break;
 			case BTRFS_MULTIPLE_OBJECTIDS:
 				if (!skip) {
 					printf("multiple");
diff --git a/ioctl.h b/ioctl.h
index a391695..83c0e16 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -32,13 +32,45 @@ struct btrfs_ioctl_vol_args {
 };
 
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
+
+#define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
+
 #define BTRFS_SUBVOL_NAME_MAX 4039
 
+struct btrfs_qgroup_limit {
+	__u64	flags;
+	__u64	max_referenced;
+	__u64	max_exclusive;
+	__u64 	rsv_referenced;
+	__u64 	rsv_exclusive;
+};
+
+struct btrfs_qgroup_inherit {
+	__u64	flags;
+	__u64	num_qgroups;
+	__u64	num_ref_copies;
+	__u64	num_excl_copies;
+	struct btrfs_qgroup_limit lim;
+	__u64	qgroups[0];
+};
+
+struct btrfs_ioctl_qgroup_limit_args {
+	__u64	qgroupid;
+	struct btrfs_qgroup_limit lim;
+};
+
 struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
 	__u64 transid;
 	__u64 flags;
-	__u64 unused[4];
+	union {
+		struct {
+			__u64 size;
+			struct btrfs_qgroup_inherit *qgroup_inherit;
+		};
+		__u64 unused[4];
+	};
 	char name[BTRFS_SUBVOL_NAME_MAX + 1];
 };
 
@@ -200,6 +232,25 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+#define BTRFS_QUOTA_CTL_ENABLE	1
+#define BTRFS_QUOTA_CTL_DISABLE	2
+#define BTRFS_QUOTA_CTL_RESCAN	3
+struct btrfs_ioctl_quota_ctl_args {
+	__u64 cmd;
+	__u64 status;
+};
+
+struct btrfs_ioctl_qgroup_assign_args {
+	__u64 assign;
+	__u64 src;
+	__u64 dst;
+};
+
+struct btrfs_ioctl_qgroup_create_args {
+	__u64 create;
+	__u64 qgroupid;
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
@@ -240,6 +291,8 @@ struct btrfs_ioctl_space_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 24, \
+				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
 				struct btrfs_ioctl_scrub_args)
 #define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
@@ -249,4 +302,12 @@ struct btrfs_ioctl_space_args {
 					struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
 					struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_QUOTA_CTL _IOWR(BTRFS_IOCTL_MAGIC, 40, \
+			       struct btrfs_ioctl_quota_ctl_args)
+#define BTRFS_IOC_QGROUP_ASSIGN _IOW(BTRFS_IOCTL_MAGIC, 41, \
+			       struct btrfs_ioctl_qgroup_assign_args)
+#define BTRFS_IOC_QGROUP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 42, \
+			       struct btrfs_ioctl_qgroup_create_args)
+#define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
+			       struct btrfs_ioctl_qgroup_limit_args)
 #endif
diff --git a/print-tree.c b/print-tree.c
index 59c23c5..251baaf 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -198,11 +198,9 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		struct btrfs_tree_block_info *info;
 		info = (struct btrfs_tree_block_info *)(ei + 1);
 		btrfs_tree_block_key(eb, info, &key);
-		printf("\t\ttree block key (%llu %x %llu) level %d\n",
-		       (unsigned long long)btrfs_disk_key_objectid(&key),
-		       key.type,
-		       (unsigned long long)btrfs_disk_key_offset(&key),
-		       btrfs_tree_block_level(eb, info));
+		printf("\t\ttree block key ");
+		btrfs_print_key(&key);
+		printf(" level %d\n", btrfs_tree_block_level(eb, info));
 		iref = (struct btrfs_extent_inline_ref *)(info + 1);
 	} else {
 		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
@@ -354,8 +352,20 @@ static void print_key_type(u8 type)
 	case BTRFS_STRING_ITEM_KEY:
 		printf("STRING_ITEM");
 		break;
+	case BTRFS_QGROUP_STATUS_KEY:
+		printf("BTRFS_STATUS_KEY");
+		break;
+	case BTRFS_QGROUP_RELATION_KEY:
+		printf("BTRFS_QGROUP_RELATION_KEY");
+		break;
+	case BTRFS_QGROUP_INFO_KEY:
+		printf("BTRFS_QGROUP_INFO_KEY");
+		break;
+	case BTRFS_QGROUP_LIMIT_KEY:
+		printf("BTRFS_QGROUP_LIMIT_KEY");
+		break;
 	default:
-		printf("UNKNOWN");
+		printf("%d", type);
 	};
 }
 
@@ -365,6 +375,12 @@ static void print_objectid(unsigned long long objectid, u8 type)
 		printf("%llu", objectid); /* device id */
 		return;
 	}
+	switch (type) {
+	case BTRFS_QGROUP_RELATION_KEY:
+		printf("%llu/%llu", objectid >> 48,
+			objectid & ((1ll << 48) - 1));
+		return;
+	}
 
 	switch (objectid) {
 	case BTRFS_ROOT_TREE_OBJECTID:
@@ -409,6 +425,9 @@ static void print_objectid(unsigned long long objectid, u8 type)
 	case BTRFS_EXTENT_CSUM_OBJECTID:
 		printf("EXTENT_CSUM");
 		break;
+	case BTRFS_QUOTA_TREE_OBJECTID:
+		printf("QUOTA_TREE");
+		break;
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
 		break;
@@ -419,20 +438,31 @@ static void print_objectid(unsigned long long objectid, u8 type)
 		}
 		/* fall-thru */
 	default:
-		printf("%llu", objectid);
+		printf("%lld", (long long)objectid);
 	}
 }
 
 void btrfs_print_key(struct btrfs_disk_key *disk_key)
 {
 	u8 type;
+	u64 offset = (unsigned long long)btrfs_disk_key_offset(disk_key);
 	printf("key (");
 	type = btrfs_disk_key_type(disk_key);
 	print_objectid((unsigned long long)btrfs_disk_key_objectid(disk_key),
 		type);
 	printf(" ");
 	print_key_type(type);
-	printf(" %llu)", (unsigned long long)btrfs_disk_key_offset(disk_key));
+	switch (type) {
+	case BTRFS_QGROUP_RELATION_KEY:
+	case BTRFS_QGROUP_INFO_KEY:
+	case BTRFS_QGROUP_LIMIT_KEY:
+		printf(" %llu/%llu)", offset >> 48,
+			offset & ((1ll << 48) - 1));
+		break;
+	default:
+		printf(" %lld)", (long long)offset);
+		break;
+	}
 }
 
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
@@ -453,6 +483,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_root_item root_item;
 	struct btrfs_block_group_item bg_item;
 	struct btrfs_dir_log_item *dlog;
+	struct btrfs_qgroup_info_item *qg_info;
+	struct btrfs_qgroup_limit_item *qg_limit;
+	struct btrfs_qgroup_status_item *qg_status;
 	u32 nr = btrfs_header_nritems(l);
 	u32 type;
 
@@ -597,6 +630,57 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       (unsigned long long)
 			       btrfs_dev_extent_length(l, dev_extent));
 			break;
+		case BTRFS_QGROUP_STATUS_KEY:
+			qg_status = btrfs_item_ptr(l, i,
+					       struct btrfs_qgroup_status_item);
+			printf("\t\tversion %llu generation %llu"
+			     " flags 0x%llx scan %lld\n",
+			       (unsigned long long)
+			       btrfs_qgroup_status_version(l, qg_status),
+			       (unsigned long long)
+			       btrfs_qgroup_status_generation(l, qg_status),
+			       (unsigned long long)
+			       btrfs_qgroup_status_flags(l, qg_status),
+			       (unsigned long long)
+			       btrfs_qgroup_status_scan(l, qg_status));
+		case BTRFS_QGROUP_RELATION_KEY:
+			break;
+		case BTRFS_QGROUP_INFO_KEY:
+			qg_info = btrfs_item_ptr(l, i,
+						 struct btrfs_qgroup_info_item);
+			printf("\t\tgeneration %llu\n"
+			     "\t\treferenced %lld referenced compressed %lld\n"
+			     "\t\texclusive %lld exclusive compressed %lld\n",
+			       (unsigned long long)
+			       btrfs_qgroup_info_generation(l, qg_info),
+			       (unsigned long long)
+			       btrfs_qgroup_info_referenced(l, qg_info),
+			       (unsigned long long)
+			       btrfs_qgroup_info_referenced_compressed(l,
+								       qg_info),
+			       (unsigned long long)
+			       btrfs_qgroup_info_exclusive(l, qg_info),
+			       (unsigned long long)
+			       btrfs_qgroup_info_exclusive_compressed(l,
+								      qg_info));
+			break;
+		case BTRFS_QGROUP_LIMIT_KEY:
+			qg_limit = btrfs_item_ptr(l, i,
+					 struct btrfs_qgroup_limit_item);
+			printf("\t\tflags %llx\n"
+			     "\t\tmax referenced %lld max exclusive %lld\n"
+			     "\t\trsv referenced %lld rsv exclusive %lld\n",
+			       (unsigned long long)
+			       btrfs_qgroup_limit_flags(l, qg_limit),
+			       (unsigned long long)
+			       btrfs_qgroup_limit_max_referenced(l, qg_limit),
+			       (unsigned long long)
+			       btrfs_qgroup_limit_max_exclusive(l, qg_limit),
+			       (unsigned long long)
+			       btrfs_qgroup_limit_rsv_referenced(l, qg_limit),
+			       (unsigned long long)
+			       btrfs_qgroup_limit_rsv_exclusive(l, qg_limit));
+			break;
 		case BTRFS_STRING_ITEM_KEY:
 			/* dirty, but it's simple */
 			str = l->data + btrfs_item_ptr_offset(l, i);
-- 
1.7.3.4

