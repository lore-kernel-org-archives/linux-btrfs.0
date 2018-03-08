Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60635 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935199AbeCHClH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:07 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1C33BAF84
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:06 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 19/20] btrfs-progs: qgroups: add json output for usage command
Date: Wed,  7 Mar 2018 21:40:46 -0500
Message-Id: <20180308024047.10104-20-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

One of the common requests I receive is for 'df' like facilities
for subvolume usage.  Really, the request is for monitoring tools to be
able to understand when subvolumes may be approaching quota in the same
manner traditional file systems approach ENOSPC.

This patch allows us to export the qgroups data in a machine-readable
format so that monitoring tools can parse it easily.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Documentation/btrfs-qgroup.asciidoc |   3 +
 cmds-qgroup.c                       |  22 +++-
 qgroup.c                            | 222 ++++++++++++++++++++++++++++++++++++
 qgroup.h                            |   8 +-
 4 files changed, 251 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 360b3269..7863a4d9 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -87,6 +87,9 @@ the btrfs filesystem identified by <path>.
 *show* [options] <path>::
 Show all qgroups in the btrfs filesystem identified by <path>.
 +
+If enabled, this command supports extended output in json and json:compat modes.
+Use of either json mode implies -P and --raw.
++
 `Options`
 +
 -p::::
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index f9e81e30..fd637a45 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -301,6 +301,10 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"               you can use '+' or '-' in front of each item.",
 	"               (+:ascending, -:descending, ascending default)",
 	"--sync         force sync of the filesystem before getting info",
+	"",
+#ifdef HAVE_JSON
+	"json and json:compat output implies -P and --raw.",
+#endif
 	NULL
 };
 
@@ -386,6 +390,10 @@ static int cmd_qgroup_show(const struct cmd_struct *cmd,
 	}
 	btrfs_qgroup_setup_units(unit_mode);
 
+	if (cmdcxt->output_mode == CMD_OUTPUT_JSON ||
+	    cmdcxt->output_mode == CMD_OUTPUT_JSON_COMPAT)
+		unit_mode = UNITS_RAW;
+
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd);
 
@@ -420,7 +428,15 @@ static int cmd_qgroup_show(const struct cmd_struct *cmd,
 					BTRFS_QGROUP_FILTER_PARENT,
 					qgroupid);
 	}
-	ret = btrfs_show_qgroups(fd, filter_set, comparer_set, verbose);
+
+	if (cmdcxt->output_mode == CMD_OUTPUT_JSON ||
+	    cmdcxt->output_mode == CMD_OUTPUT_JSON_COMPAT) {
+		bool compat = (cmdcxt->output_mode == CMD_OUTPUT_JSON_COMPAT);
+
+		ret = btrfs_qgroup_output_json(fd, filter_set, comparer_set,
+					       compat);
+	} else
+		ret = btrfs_show_qgroups(fd, filter_set, comparer_set, verbose);
 	close_file_or_dir(fd, dirstream);
 	free(filter_set);
 	free(comparer_set);
@@ -428,7 +444,9 @@ static int cmd_qgroup_show(const struct cmd_struct *cmd,
 out:
 	return !!ret;
 }
-static DEFINE_SIMPLE_COMMAND(qgroup_show, "show");
+static DEFINE_COMMAND(qgroup_show, "show", cmd_qgroup_show,
+		      cmd_qgroup_show_usage, NULL, 0,
+		      CMD_OUTPUT_FLAG(JSON)|CMD_OUTPUT_FLAG(JSON_COMPAT));
 
 static const char * const cmd_qgroup_limit_usage[] = {
 	"btrfs qgroup limit [options] <size>|none [<qgroupid>] <path>",
diff --git a/qgroup.c b/qgroup.c
index d076b1de..95d443db 100644
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
@@ -1398,6 +1402,224 @@ int btrfs_show_qgroups(int fd,
 	return ret;
 }
 
+#ifdef HAVE_JSON
+#define QGROUPID_FORMAT_BUF_LEN (20 + 20 + 1 + 1)
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
+	char buf[QGROUPID_FORMAT_BUF_LEN];
+	json_object *obj, *tmp;
+
+	obj = json_object_new_object();
+	if (!obj)
+		return false;
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
+		if (qgroup->pathname) {
+			tmp = json_object_new_string(qgroup->pathname);
+			if (!tmp)
+				goto failure;
+			json_object_object_add(obj, "pathname", tmp);
+		}
+	} else {
+		json_object *array = json_object_new_array();
+		struct btrfs_qgroup_list *list = NULL;
+
+		if (!array)
+			goto failure;
+		json_object_object_add(obj, "members", array);
+
+		list_for_each_entry(list, &qgroup->qgroups, next_qgroup) {
+			struct btrfs_qgroup *member = list->qgroup;
+			char buf2[QGROUPID_FORMAT_BUF_LEN];
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
+"This data contains 64-bit values that are incompatible with Javascript. Export in compatibility mode using --format=json:compat."
+
+static void export_all_qgroups(const struct qgroup_lookup *qgroup_lookup,
+			       bool compat)
+{
+
+	struct rb_node *n;
+	const char *json;
+	json_object *container, *dict, *obj;
+	struct btrfs_qgroup *entry;
+	int json_flags = JSON_C_TO_STRING_PRETTY;
+
+#ifdef JSON_C_TO_STRING_NOSLASHESCAPE
+	json_flags |= JSON_C_TO_STRING_NOSLASHESCAPE;
+#endif
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
+	json = json_object_to_json_string_ext(container, json_flags);
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
+int btrfs_qgroup_output_json(int fd,
+			     struct btrfs_qgroup_filter_set *filter_set,
+			     struct btrfs_qgroup_comparer_set *comp_set,
+			     bool compat)
+{
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
index 688f92b2..4344c7d8 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -95,8 +95,12 @@ struct btrfs_qgroup_stats {
 
 int btrfs_qgroup_parse_sort_string(const char *opt_arg,
 				struct btrfs_qgroup_comparer_set **comps);
-int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
-		       struct btrfs_qgroup_comparer_set *, bool verbose);
+int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *filter_set,
+		       struct btrfs_qgroup_comparer_set *comp_set,
+		       bool verbose);
+int btrfs_qgroup_output_json(int fd, struct btrfs_qgroup_filter_set *filter_set,
+			     struct btrfs_qgroup_comparer_set *comp_set,
+			     bool compat);
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
 void btrfs_qgroup_setup_units(unsigned unit_mode);
 struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
-- 
2.12.3

