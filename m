Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947444AbeCBSrR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 13:47:17 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6034BAE88
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 18:47:16 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 8/8] btrfs-progs: qgroups: export qgroups usage information as JSON
Date: Fri,  2 Mar 2018 13:47:04 -0500
Message-Id: <20180302184704.22399-9-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>
References: <20180302184704.22399-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

One of the common requests I receive is for 'df' like facilities
for subvolume usage.  Really, the request is for monitoring tools to be
able to understand when subvolumes may be approaching quota in the same
manner traditional file systems approach ENOSPC.

This patch allows us to export the qgroups data in a machine-readable
format so that monitoring tools can parse it easily.

There are two modes since JSON can technically handle 64-bit numbers
but JavaScript proper cannot.  show -j enables JSON mode using 64-bit
integers directly.  --json-compat presents 64-bit numbers as an array
of two 32-bit numbers (high followed by low).

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Documentation/btrfs-qgroup.asciidoc |   4 +
 Makefile.inc.in                     |   4 +-
 cmds-qgroup.c                       |  36 +++++-
 configure.ac                        |   6 +
 qgroup.c                            | 211 ++++++++++++++++++++++++++++++++++++
 qgroup.h                            |   3 +
 6 files changed, 258 insertions(+), 6 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 360b3269..22a9c2a7 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -105,6 +105,10 @@ list all qgroups which impact the given path(include ancestral qgroups)
 list all qgroups which impact the given path(exclude ancestral qgroups)
 -v::::
 Be more verbose.  Print pathnames of member qgroups when nested.
+-j::::
+If enabled, export qgroup usage information in JSON format.  This implies --raw.
+--json-compat::::
+By default, JSON output contains full 64-bit integers, which may be incompatible with some JSON parsers.  This option exports those values as an array of 32-bit numbers in [high, low] format.
 --raw::::
 raw numbers in bytes, without the 'B' suffix.
 --human-readable::::
diff --git a/Makefile.inc.in b/Makefile.inc.in
index 56271903..68bddbed 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -18,9 +18,9 @@ BTRFSRESTORE_ZSTD = @BTRFSRESTORE_ZSTD@
 SUBST_CFLAGS = @CFLAGS@
 SUBST_LDFLAGS = @LDFLAGS@
 
-LIBS_BASE = @UUID_LIBS@ @BLKID_LIBS@ -L. -pthread
+LIBS_BASE = @UUID_LIBS@ @BLKID_LIBS@ @JSON_LIBS@ -L. -pthread
 LIBS_COMP = @ZLIB_LIBS@ @LZO2_LIBS@ @ZSTD_LIBS@
-STATIC_LIBS_BASE = @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ -L. -pthread
+STATIC_LIBS_BASE = @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ @JSON_LIBS_STATIC@ -L. -pthread
 STATIC_LIBS_COMP = @ZLIB_LIBS_STATIC@ @LZO2_LIBS_STATIC@ @ZSTD_LIBS_STATIC@
 
 prefix ?= @prefix@
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 94cd0fd3..eee15ef1 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -282,6 +282,10 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"               (excluding ancestral qgroups)",
 	"-P             print first-level qgroups using pathname",
 	"-v             verbose, prints all nested subvolumes",
+#ifdef HAVE_JSON
+	"-j             export in JSON format",
+	"--json-compat  export in JSON compatibility mode",
+#endif
 	HELPINFO_UNITS_LONG,
 	"--sort=qgroupid,rfer,excl,max_rfer,max_excl,pathname",
 	"               list qgroups sorted by specified items",
@@ -302,6 +306,8 @@ static int cmd_qgroup_show(int argc, char **argv)
 	unsigned unit_mode;
 	int sync = 0;
 	bool verbose = false;
+	bool export_json = false;
+	bool compat_json = false;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -314,16 +320,26 @@ static int cmd_qgroup_show(int argc, char **argv)
 		int c;
 		enum {
 			GETOPT_VAL_SORT = 256,
-			GETOPT_VAL_SYNC
+			GETOPT_VAL_SYNC,
+			GETOPT_VAL_JSCOMPAT,
 		};
 		static const struct option long_options[] = {
 			{"sort", required_argument, NULL, GETOPT_VAL_SORT},
 			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
 			{"verbose", no_argument, NULL, 'v'},
+#ifdef HAVE_JSON
+			{"json-compat", no_argument, NULL, GETOPT_VAL_JSCOMPAT},
+#endif
 			{ NULL, 0, NULL, 0 }
 		};
-
-		c = getopt_long(argc, argv, "pPcreFfv", long_options, NULL);
+		const char getopt_chars[] = {
+			'p', 'P', 'c', 'r', 'e', 'F', 'f', 'v',
+#ifdef HAVE_JSON
+			'j',
+#endif
+			'\0' };
+
+		c = getopt_long(argc, argv, getopt_chars, long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
@@ -353,6 +369,14 @@ static int cmd_qgroup_show(int argc, char **argv)
 		case 'f':
 			filter_flag |= 0x2;
 			break;
+#ifdef HAVE_JSON
+		case GETOPT_VAL_JSCOMPAT:
+			compat_json = true;
+		case 'j':
+			unit_mode = UNITS_RAW;
+			export_json = true;
+			break;
+#endif
 		case GETOPT_VAL_SORT:
 			ret = btrfs_qgroup_parse_sort_string(optarg,
 							     &comparer_set);
@@ -405,7 +429,11 @@ static int cmd_qgroup_show(int argc, char **argv)
 					BTRFS_QGROUP_FILTER_PARENT,
 					qgroupid);
 	}
-	ret = btrfs_show_qgroups(fd, filter_set, comparer_set, verbose);
+	if (export_json)
+		ret = btrfs_export_qgroups_json(fd, filter_set, comparer_set,
+						compat_json);
+	else
+		ret = btrfs_show_qgroups(fd, filter_set, comparer_set, verbose);
 	close_file_or_dir(fd, dirstream);
 	free(filter_set);
 	free(comparer_set);
diff --git a/configure.ac b/configure.ac
index 56d17c3a..6aec672a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -197,6 +197,12 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
 PKG_CHECK_MODULES(ZLIB, [zlib])
 PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
 
+PKG_CHECK_MODULES(JSON, [json-c], [
+	AC_DEFINE(HAVE_JSON, [1], [Have JSON]),
+	PKG_STATIC(JSON_LIBS_STATIC, [json-c], [
+		AC_DEFINE(HAVE_JSON_STATIC, [1], [Have JSON static])], [true])
+	], [true])
+
 AC_ARG_ENABLE([zstd],
 	AS_HELP_STRING([--disable-zstd], [build without zstd support]),
 	[], [enable_zstd=yes]
diff --git a/qgroup.c b/qgroup.c
index 2d0a6947..f632a45c 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -16,12 +16,16 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include "version.h"
 #include "qgroup.h"
 #include <sys/ioctl.h>
 #include "ctree.h"
 #include "ioctl.h"
 #include "utils.h"
 #include <errno.h>
+#ifdef HAVE_JSON
+#include <json-c/json.h>
+#endif
 
 #define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
 #define BTRFS_QGROUP_NCOMPS_INCREASE (2 * BTRFS_QGROUP_COMP_MAX)
@@ -1346,6 +1350,213 @@ int btrfs_show_qgroups(int fd,
 	return ret;
 }
 
+#ifdef HAVE_JSON
+static void format_qgroupid(char *buf, size_t size, u64 qgroupid)
+{
+	int ret;
+
+	ret = snprintf(buf, size, "%llu/%llu",
+		       btrfs_qgroup_level(qgroupid),
+		       btrfs_qgroup_subvid(qgroupid));
+	ASSERT(ret < sizeof(buf));
+}
+
+static json_object *export_one_u64(u64 value, bool compat)
+{
+	json_object *array, *tmp;
+
+	if (!compat)
+		return json_object_new_int64(value);
+
+	array = json_object_new_array();
+	if (!array)
+		return NULL;
+
+	tmp = json_object_new_int(value >> 32);
+	if (!tmp)
+		goto failure;
+	json_object_array_add(array, tmp);
+
+	tmp = json_object_new_int(value & 0xffffffff);
+	if (!tmp)
+		goto failure;
+	json_object_array_add(array, tmp);
+
+	return array;
+failure:
+	json_object_put(array);
+	return NULL;
+}
+
+static bool export_one_qgroup(json_object *container,
+			     const struct btrfs_qgroup *qgroup, bool compat)
+{
+	json_object *obj = json_object_new_object();
+	json_object *tmp;
+	char buf[42];
+
+	format_qgroupid(buf, sizeof(buf), qgroup->qgroupid);
+	tmp = json_object_new_string(buf);
+	if (!tmp)
+		return false;
+	json_object_object_add(obj, "qgroupid", tmp);
+
+	tmp = export_one_u64(qgroup->qgroupid, compat);
+	if (!tmp)
+		goto failure;
+	json_object_object_add(obj, "qgroupid_raw", tmp);
+
+	tmp = export_one_u64(qgroup->info.generation, compat);
+	if (!tmp)
+		goto failure;
+	json_object_object_add(obj, "generation", tmp);
+
+	tmp = export_one_u64(qgroup->info.referenced, compat);
+	if (!tmp)
+		goto failure;
+	json_object_object_add(obj, "referenced_bytes", tmp);
+
+	tmp = export_one_u64(qgroup->info.exclusive, compat);
+	if (!tmp)
+		goto failure;
+	json_object_object_add(obj, "exclusive_bytes", tmp);
+
+	tmp = export_one_u64(qgroup->limit.max_referenced, compat);
+	if (!tmp)
+		goto failure;
+	json_object_object_add(obj, "referenced_limit_bytes", tmp);
+
+	tmp = export_one_u64(qgroup->limit.max_exclusive, compat);
+	if (!tmp)
+		goto failure;
+	json_object_object_add(obj, "exclusive_limit_bytes", tmp);
+
+	if (btrfs_qgroup_level(qgroup->qgroupid) == 0) {
+		tmp = json_object_new_string(qgroup->pathname);
+		if (!tmp)
+			goto failure;
+		json_object_object_add(obj, "pathname", tmp);
+	} else {
+		json_object *array = json_object_new_array();
+		struct btrfs_qgroup_list *list = NULL;
+		if (!array)
+			goto failure;
+		json_object_object_add(obj, "members", array);
+
+		list_for_each_entry(list, &qgroup->qgroups, next_qgroup) {
+			struct btrfs_qgroup *member = list->qgroup;
+			char buf2[42];
+
+			format_qgroupid(buf2, sizeof(buf2), member->qgroupid);
+			tmp = json_object_new_string(buf2);
+			if (!tmp)
+				goto failure;
+
+			json_object_array_add(array, tmp);
+		}
+	}
+
+	json_object_object_add(container, buf, obj);
+	return true;
+failure:
+	json_object_put(obj);
+	return false;
+}
+
+#define BTRFS_JSON_WARNING \
+"This data contains 64-bit values that are incompatible with Javascript. Export in compatibility mode using --json-compat."
+
+static void export_all_qgroups(const struct qgroup_lookup *qgroup_lookup,
+			       bool compat)
+{
+
+	struct rb_node *n;
+	const char *json;
+	json_object *container, *dict, *obj;
+	struct btrfs_qgroup *entry;
+
+	container = json_object_new_object();
+	if (!container)
+		goto failure_msg;
+
+	obj = json_object_new_string(BTRFS_BUILD_VERSION);
+	if (!obj)
+		goto failure;
+	json_object_object_add(container, "exporter", obj);
+
+	if (!compat) {
+		obj = json_object_new_string(BTRFS_JSON_WARNING);
+		if (!obj)
+			goto failure;
+		json_object_object_add(container, "compatibility-warning", obj);
+
+		obj = json_object_new_string("64-bit");
+		if (!obj)
+			goto failure;
+		json_object_object_add(container, "u64-format", obj);
+	} else {
+		obj = json_object_new_string("array");
+		if (!obj)
+			goto failure;
+		json_object_object_add(container, "u64-format", obj);
+	}
+
+	dict = json_object_new_object();
+	if (!dict)
+		goto failure;
+	json_object_object_add(container, "qgroup_data", dict);
+
+	n = rb_first(&qgroup_lookup->root);
+	while (n) {
+		entry = rb_entry(n, struct btrfs_qgroup, sort_node);
+		if (!export_one_qgroup(dict, entry, compat))
+			goto failure;
+		n = rb_next(n);
+	}
+
+	json = json_object_to_json_string(container);
+	if (!json)
+		goto failure;
+
+	puts(json);
+
+	/* clean up container */
+	json_object_put(container);
+	return;
+
+failure:
+	json_object_put(container);
+failure_msg:
+	error("Failed to create JSON object.");
+}
+#endif
+
+int btrfs_export_qgroups_json(int fd,
+			      struct btrfs_qgroup_filter_set *filter_set,
+			      struct btrfs_qgroup_comparer_set *comp_set,
+			      bool compat)
+{
+
+#ifdef HAVE_JSON
+	struct qgroup_lookup qgroup_lookup;
+	struct qgroup_lookup sort_tree;
+	int ret = 0;
+
+	ret = qgroups_search_all(fd, &qgroup_lookup);
+	if (ret)
+		return ret;
+	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
+				  filter_set, comp_set);
+	export_all_qgroups(&sort_tree, compat);
+
+	__free_all_qgroups(&qgroup_lookup);
+
+	return ret;
+#else
+	return 0;
+#endif
+}
+
 int btrfs_qgroup_parse_sort_string(const char *opt_arg,
 				   struct btrfs_qgroup_comparer_set **comps)
 {
diff --git a/qgroup.h b/qgroup.h
index 688f92b2..2883727b 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -97,6 +97,9 @@ int btrfs_qgroup_parse_sort_string(const char *opt_arg,
 				struct btrfs_qgroup_comparer_set **comps);
 int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
 		       struct btrfs_qgroup_comparer_set *, bool verbose);
+int btrfs_export_qgroups_json(int fd, struct btrfs_qgroup_filter_set *,
+			      struct btrfs_qgroup_comparer_set *,
+			      bool compat);
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
 void btrfs_qgroup_setup_units(unsigned unit_mode);
 struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
-- 
2.15.1

