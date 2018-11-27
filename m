Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CD4C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F99B208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F99B208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbeK0Q2V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:21 -0500
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:47094 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbeK0Q2U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:20 -0500
Received: from yt-mxauth.gw.nic.fujitsu.com (unknown [192.168.229.68]) by mgwym04.jp.fujitsu.com with smtp
         id 0563_bb75_730019d6_1f07_426c_822d_562bdb9611db;
        Tue, 27 Nov 2018 14:20:23 +0900
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 898BBAC0104
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:23 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id A3EF3584295;
        Tue, 27 Nov 2018 14:20:22 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:22 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/8] btrfs-progs: sub list: Use libbtrfsuitl for subvolume list
Date:   Tue, 27 Nov 2018 14:24:42 +0900
Message-ID: <e499704e824bab8fc65511623ed769cbb90d7dae.1543294426.git.misono.tomohiro@jp.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: disable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a copy of non-merged following patch originally written
by Omar Sandoval:
  btrfs-progs: use libbtrfsutil for subvolume list
expect this commit keeps libbtrfs implementation which above commit
tries to remove (therefore this adds suffix _v2 for struct/function).

Original Author: Omar Sandoval <osandov@fb.com>
Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-subvolume.c | 963 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 936 insertions(+), 27 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index a8395aac..84a03fd8 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -407,6 +407,915 @@ keep_fd:
 	return ret;
 }
 
+#define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
+#define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
+
+struct listed_subvol {
+	struct btrfs_util_subvolume_info info;
+	char *path;
+};
+
+struct subvol_list {
+	size_t num;
+	struct listed_subvol subvols[];
+};
+
+typedef int (*btrfs_list_filter_func_v2)(struct listed_subvol *, uint64_t);
+typedef int (*btrfs_list_comp_func_v2)(const struct listed_subvol *,
+				    const struct listed_subvol *,
+				    int);
+
+struct btrfs_list_filter_v2 {
+	btrfs_list_filter_func_v2 filter_func;
+	u64 data;
+};
+
+struct btrfs_list_comparer_v2 {
+	btrfs_list_comp_func_v2 comp_func;
+	int is_descending;
+};
+
+struct btrfs_list_filter_set_v2 {
+	int total;
+	int nfilters;
+	int only_deleted;
+	struct btrfs_list_filter_v2 filters[0];
+};
+
+struct btrfs_list_comparer_set_v2 {
+	int total;
+	int ncomps;
+	struct btrfs_list_comparer_v2 comps[0];
+};
+
+static struct {
+	char	*name;
+	char	*column_name;
+	int	need_print;
+} btrfs_list_columns[] = {
+	{
+		.name		= "ID",
+		.column_name	= "ID",
+		.need_print	= 0,
+	},
+	{
+		.name		= "gen",
+		.column_name	= "Gen",
+		.need_print	= 0,
+	},
+	{
+		.name		= "cgen",
+		.column_name	= "CGen",
+		.need_print	= 0,
+	},
+	{
+		.name		= "parent",
+		.column_name	= "Parent",
+		.need_print	= 0,
+	},
+	{
+		.name		= "top level",
+		.column_name	= "Top Level",
+		.need_print	= 0,
+	},
+	{
+		.name		= "otime",
+		.column_name	= "OTime",
+		.need_print	= 0,
+	},
+	{
+		.name		= "parent_uuid",
+		.column_name	= "Parent UUID",
+		.need_print	= 0,
+	},
+	{
+		.name		= "received_uuid",
+		.column_name	= "Received UUID",
+		.need_print	= 0,
+	},
+	{
+		.name		= "uuid",
+		.column_name	= "UUID",
+		.need_print	= 0,
+	},
+	{
+		.name		= "path",
+		.column_name	= "Path",
+		.need_print	= 0,
+	},
+	{
+		.name		= NULL,
+		.column_name	= NULL,
+		.need_print	= 0,
+	},
+};
+
+static btrfs_list_filter_func_v2 all_filter_funcs[];
+static btrfs_list_comp_func_v2 all_comp_funcs[];
+
+static void btrfs_list_setup_print_column_v2(enum btrfs_list_column_enum column)
+{
+	int i;
+
+	ASSERT(0 <= column && column <= BTRFS_LIST_ALL);
+
+	if (column < BTRFS_LIST_ALL) {
+		btrfs_list_columns[column].need_print = 1;
+		return;
+	}
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++)
+		btrfs_list_columns[i].need_print = 1;
+}
+
+static int comp_entry_with_rootid_v2(const struct listed_subvol *entry1,
+				  const struct listed_subvol *entry2,
+				  int is_descending)
+{
+	int ret;
+
+	if (entry1->info.id > entry2->info.id)
+		ret = 1;
+	else if (entry1->info.id < entry2->info.id)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_gen_v2(const struct listed_subvol *entry1,
+			       const struct listed_subvol *entry2,
+			       int is_descending)
+{
+	int ret;
+
+	if (entry1->info.generation > entry2->info.generation)
+		ret = 1;
+	else if (entry1->info.generation < entry2->info.generation)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_ogen_v2(const struct listed_subvol *entry1,
+				const struct listed_subvol *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (entry1->info.otransid > entry2->info.otransid)
+		ret = 1;
+	else if (entry1->info.otransid < entry2->info.otransid)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_path_v2(const struct listed_subvol *entry1,
+				const struct listed_subvol *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (strcmp(entry1->path, entry2->path) > 0)
+		ret = 1;
+	else if (strcmp(entry1->path, entry2->path) < 0)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static btrfs_list_comp_func_v2 all_comp_funcs[] = {
+	[BTRFS_LIST_COMP_ROOTID]	= comp_entry_with_rootid_v2,
+	[BTRFS_LIST_COMP_OGEN]		= comp_entry_with_ogen_v2,
+	[BTRFS_LIST_COMP_GEN]		= comp_entry_with_gen_v2,
+	[BTRFS_LIST_COMP_PATH]		= comp_entry_with_path_v2,
+};
+
+static char *all_sort_items[] = {
+	[BTRFS_LIST_COMP_ROOTID]	= "rootid",
+	[BTRFS_LIST_COMP_OGEN]		= "ogen",
+	[BTRFS_LIST_COMP_GEN]		= "gen",
+	[BTRFS_LIST_COMP_PATH]		= "path",
+	[BTRFS_LIST_COMP_MAX]		= NULL,
+};
+
+static int btrfs_list_get_sort_item(char *sort_name)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_COMP_MAX; i++) {
+		if (strcmp(sort_name, all_sort_items[i]) == 0)
+			return i;
+	}
+	return -1;
+}
+
+static struct btrfs_list_comparer_set_v2 *btrfs_list_alloc_comparer_set_v2(void)
+{
+	struct btrfs_list_comparer_set_v2 *set;
+	int size;
+
+	size = sizeof(struct btrfs_list_comparer_set_v2) +
+		BTRFS_LIST_NCOMPS_INCREASE *
+		sizeof(struct btrfs_list_comparer_v2);
+	set = calloc(1, size);
+	if (!set) {
+		fprintf(stderr, "memory allocation failed\n");
+		exit(1);
+	}
+
+	set->total = BTRFS_LIST_NCOMPS_INCREASE;
+
+	return set;
+}
+
+static int btrfs_list_setup_comparer_v2(struct btrfs_list_comparer_set_v2 **comp_set,
+				     enum btrfs_list_comp_enum comparer,
+				     int is_descending)
+{
+	struct btrfs_list_comparer_set_v2 *set = *comp_set;
+	int size;
+
+	ASSERT(set != NULL);
+	ASSERT(comparer < BTRFS_LIST_COMP_MAX);
+	ASSERT(set->ncomps <= set->total);
+
+	if (set->ncomps == set->total) {
+		void *tmp;
+
+		size = set->total + BTRFS_LIST_NCOMPS_INCREASE;
+		size = sizeof(*set) +
+			size * sizeof(struct btrfs_list_comparer_v2);
+		tmp = set;
+		set = realloc(set, size);
+		if (!set) {
+			fprintf(stderr, "memory allocation failed\n");
+			free(tmp);
+			exit(1);
+		}
+
+		memset(&set->comps[set->total], 0,
+		       BTRFS_LIST_NCOMPS_INCREASE *
+		       sizeof(struct btrfs_list_comparer_v2));
+		set->total += BTRFS_LIST_NCOMPS_INCREASE;
+		*comp_set = set;
+	}
+
+	ASSERT(set->comps[set->ncomps].comp_func == NULL);
+
+	set->comps[set->ncomps].comp_func = all_comp_funcs[comparer];
+	set->comps[set->ncomps].is_descending = is_descending;
+	set->ncomps++;
+	return 0;
+}
+
+static int subvol_comp(const void *entry1, const void *entry2, void *arg)
+{
+	const struct btrfs_list_comparer_set_v2 * const set = arg;
+	int rootid_compared = 0;
+	int ret;
+	int i;
+
+	for (i = 0; set && i < set->ncomps; i++) {
+		if (!set->comps[i].comp_func)
+			break;
+
+		ret = set->comps[i].comp_func(entry1, entry2,
+					      set->comps[i].is_descending);
+		if (ret)
+			return ret;
+
+		if (set->comps[i].comp_func == comp_entry_with_rootid_v2)
+			rootid_compared = 1;
+	}
+
+	if (!rootid_compared)
+		return comp_entry_with_rootid_v2(entry1, entry2, 0);
+
+	return 0;
+}
+
+static void sort_subvols(struct btrfs_list_comparer_set_v2 *comp_set,
+			 struct subvol_list *subvols)
+{
+	qsort_r(subvols->subvols, subvols->num, sizeof(subvols->subvols[0]),
+		subvol_comp, comp_set);
+}
+
+static int filter_by_rootid(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.id == data;
+}
+
+static int filter_snapshot(struct listed_subvol *subvol, uint64_t data)
+{
+	return !uuid_is_null(subvol->info.parent_uuid);
+}
+
+static int filter_flags(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.flags & data;
+}
+
+static int filter_gen_more(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.generation >= data;
+}
+
+static int filter_gen_less(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.generation <= data;
+}
+
+static int filter_gen_equal(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.generation == data;
+}
+
+static int filter_cgen_more(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.otransid >= data;
+}
+
+static int filter_cgen_less(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.otransid <= data;
+}
+
+static int filter_cgen_equal(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.otransid == data;
+}
+
+static int filter_topid_equal(struct listed_subvol *subvol, uint64_t data)
+{
+	/* See the comment in print_subvolume_column() about top level. */
+	return subvol->info.parent_id == data;
+}
+
+static int filter_full_path(struct listed_subvol *subvol, uint64_t data)
+{
+	/*
+	 * This implements the same behavior as before the conversion to
+	 * libbtrfsutil, which is mostly nonsensical.
+	 */
+	if (subvol->info.parent_id != data) {
+		char *tmp;
+		int ret;
+
+		ret = asprintf(&tmp, "<FS_TREE>/%s", subvol->path);
+		if (ret == -1) {
+			error("out of memory");
+			exit(1);
+		}
+
+		free(subvol->path);
+		subvol->path = tmp;
+	}
+	return 1;
+}
+
+static int filter_by_parent(struct listed_subvol *subvol, uint64_t data)
+{
+	return !uuid_compare(subvol->info.parent_uuid,
+			     (u8 *)(unsigned long)data);
+}
+
+static btrfs_list_filter_func_v2 all_filter_funcs[] = {
+	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
+	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
+	[BTRFS_LIST_FILTER_FLAGS]		= filter_flags,
+	[BTRFS_LIST_FILTER_GEN_MORE]		= filter_gen_more,
+	[BTRFS_LIST_FILTER_GEN_LESS]		= filter_gen_less,
+	[BTRFS_LIST_FILTER_GEN_EQUAL]           = filter_gen_equal,
+	[BTRFS_LIST_FILTER_CGEN_MORE]		= filter_cgen_more,
+	[BTRFS_LIST_FILTER_CGEN_LESS]		= filter_cgen_less,
+	[BTRFS_LIST_FILTER_CGEN_EQUAL]          = filter_cgen_equal,
+	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
+	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
+	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
+};
+
+static struct btrfs_list_filter_set_v2 *btrfs_list_alloc_filter_set_v2(void)
+{
+	struct btrfs_list_filter_set_v2 *set;
+	int size;
+
+	size = sizeof(struct btrfs_list_filter_set_v2) +
+		BTRFS_LIST_NFILTERS_INCREASE *
+		sizeof(struct btrfs_list_filter_v2);
+	set = calloc(1, size);
+	if (!set) {
+		fprintf(stderr, "memory allocation failed\n");
+		exit(1);
+	}
+
+	set->total = BTRFS_LIST_NFILTERS_INCREASE;
+
+	return set;
+}
+
+/*
+ * Setup list filters. Exit if there's not enough memory, as we can't continue
+ * without the structures set up properly.
+ */
+static void btrfs_list_setup_filter_v2(struct btrfs_list_filter_set_v2 **filter_set,
+				    enum btrfs_list_filter_enum filter,
+				    u64 data)
+{
+	struct btrfs_list_filter_set_v2 *set = *filter_set;
+	int size;
+
+	ASSERT(set != NULL);
+	ASSERT(filter < BTRFS_LIST_FILTER_MAX);
+	ASSERT(set->nfilters <= set->total);
+
+	if (set->nfilters == set->total) {
+		void *tmp;
+
+		size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
+		size = sizeof(*set) +
+			size * sizeof(struct btrfs_list_filter_v2);
+		tmp = set;
+		set = realloc(set, size);
+		if (!set) {
+			fprintf(stderr, "memory allocation failed\n");
+			free(tmp);
+			exit(1);
+		}
+
+		memset(&set->filters[set->total], 0,
+		       BTRFS_LIST_NFILTERS_INCREASE *
+		       sizeof(struct btrfs_list_filter_v2));
+		set->total += BTRFS_LIST_NFILTERS_INCREASE;
+		*filter_set = set;
+	}
+
+	ASSERT(set->filters[set->nfilters].filter_func == NULL);
+
+	if (filter == BTRFS_LIST_FILTER_DELETED) {
+		set->only_deleted = 1;
+	} else {
+		set->filters[set->nfilters].filter_func =
+					all_filter_funcs[filter];
+		set->filters[set->nfilters].data = data;
+		set->nfilters++;
+	}
+}
+
+static int filters_match(struct listed_subvol *subvol,
+			 struct btrfs_list_filter_set_v2 *set)
+{
+	int i, ret;
+
+	if (!set)
+		return 1;
+
+	for (i = 0; i < set->nfilters; i++) {
+		if (!set->filters[i].filter_func)
+			break;
+		ret = set->filters[i].filter_func(subvol, set->filters[i].data);
+		if (!ret)
+			return 0;
+	}
+	return 1;
+}
+
+static void print_subvolume_column(struct listed_subvol *subvol,
+				   enum btrfs_list_column_enum column)
+{
+	char tstr[256];
+	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
+
+	ASSERT(0 <= column && column < BTRFS_LIST_ALL);
+
+	switch (column) {
+	case BTRFS_LIST_OBJECTID:
+		printf("%" PRIu64, subvol->info.id);
+		break;
+	case BTRFS_LIST_GENERATION:
+		printf("%" PRIu64, subvol->info.generation);
+		break;
+	case BTRFS_LIST_OGENERATION:
+		printf("%" PRIu64, subvol->info.otransid);
+		break;
+	case BTRFS_LIST_PARENT:
+	/*
+	 * Top level used to mean something else, but since 4f5ebb3ef553
+	 * ("Btrfs-progs: fix to make list specified directory's subvolumes
+	 * work") it was always set to the parent ID. See
+	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html.
+	 */
+	case BTRFS_LIST_TOP_LEVEL:
+		printf("%" PRIu64, subvol->info.parent_id);
+		break;
+	case BTRFS_LIST_OTIME:
+		if (subvol->info.otime.tv_sec) {
+			struct tm tm;
+
+			localtime_r(&subvol->info.otime.tv_sec, &tm);
+			strftime(tstr, sizeof(tstr), "%Y-%m-%d %X", &tm);
+		} else
+			strcpy(tstr, "-");
+		printf("%s", tstr);
+		break;
+	case BTRFS_LIST_UUID:
+		if (uuid_is_null(subvol->info.uuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subvol->info.uuid, uuidparse);
+		printf("%-36s", uuidparse);
+		break;
+	case BTRFS_LIST_PUUID:
+		if (uuid_is_null(subvol->info.parent_uuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subvol->info.parent_uuid, uuidparse);
+		printf("%-36s", uuidparse);
+		break;
+	case BTRFS_LIST_RUUID:
+		if (uuid_is_null(subvol->info.received_uuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subvol->info.received_uuid, uuidparse);
+		printf("%-36s", uuidparse);
+		break;
+	case BTRFS_LIST_PATH:
+		printf("%s", subvol->path);
+		break;
+	default:
+		break;
+	}
+}
+
+static void print_one_subvol_info_raw(struct listed_subvol *subvol,
+				      const char *raw_prefix)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
+			continue;
+
+		if (raw_prefix)
+			printf("%s", raw_prefix);
+
+		print_subvolume_column(subvol, i);
+	}
+	printf("\n");
+}
+
+static void print_one_subvol_info_table(struct listed_subvol *subvol)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
+			continue;
+
+		print_subvolume_column(subvol, i);
+
+		if (i != BTRFS_LIST_PATH)
+			printf("\t");
+
+		if (i == BTRFS_LIST_TOP_LEVEL)
+			printf("\t");
+	}
+	printf("\n");
+}
+
+static void print_one_subvol_info_default(struct listed_subvol *subvol)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
+			continue;
+
+		printf("%s ", btrfs_list_columns[i].name);
+		print_subvolume_column(subvol, i);
+
+		if (i != BTRFS_LIST_PATH)
+			printf(" ");
+	}
+	printf("\n");
+}
+
+static void print_all_subvol_info_tab_head(void)
+{
+	int i;
+	int len;
+	char barrier[20];
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (btrfs_list_columns[i].need_print)
+			printf("%s\t", btrfs_list_columns[i].name);
+
+		if (i == BTRFS_LIST_ALL-1)
+			printf("\n");
+	}
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		memset(barrier, 0, sizeof(barrier));
+
+		if (btrfs_list_columns[i].need_print) {
+			len = strlen(btrfs_list_columns[i].name);
+			while (len--)
+				strcat(barrier, "-");
+
+			printf("%s\t", barrier);
+		}
+		if (i == BTRFS_LIST_ALL-1)
+			printf("\n");
+	}
+}
+
+static void print_all_subvol_info(struct subvol_list *subvols,
+				  enum btrfs_list_layout layout,
+				  const char *raw_prefix)
+{
+	size_t i;
+
+	if (layout == BTRFS_LIST_LAYOUT_TABLE)
+		print_all_subvol_info_tab_head();
+
+	for (i = 0; i < subvols->num; i++) {
+		struct listed_subvol *subvol = &subvols->subvols[i];
+
+		switch (layout) {
+		case BTRFS_LIST_LAYOUT_DEFAULT:
+			print_one_subvol_info_default(subvol);
+			break;
+		case BTRFS_LIST_LAYOUT_TABLE:
+			print_one_subvol_info_table(subvol);
+			break;
+		case BTRFS_LIST_LAYOUT_RAW:
+			print_one_subvol_info_raw(subvol, raw_prefix);
+			break;
+		}
+	}
+}
+
+static void free_subvol_list(struct subvol_list *subvols)
+{
+	size_t i;
+
+	if (subvols) {
+		for (i = 0; i < subvols->num; i++)
+			free(subvols->subvols[i].path);
+		free(subvols);
+	}
+}
+
+static struct subvol_list *btrfs_list_deleted_subvols(int fd,
+						      struct btrfs_list_filter_set_v2 *filter_set)
+{
+	struct subvol_list *subvols = NULL;
+	uint64_t *ids = NULL;
+	size_t i, n;
+	enum btrfs_util_error err;
+	int ret = -1;
+
+	err = btrfs_util_deleted_subvolumes_fd(fd, &ids, &n);
+	if (err) {
+		error_btrfs_util(err);
+		return NULL;
+	}
+
+	subvols = malloc(sizeof(*subvols) + n * sizeof(subvols->subvols[0]));
+	if (!subvols) {
+		error("out of memory");
+		goto out;
+	}
+
+	subvols->num = 0;
+	for (i = 0; i < n; i++) {
+		struct listed_subvol *subvol = &subvols->subvols[subvols->num];
+
+		err = btrfs_util_subvolume_info_fd(fd, ids[i], &subvol->info);
+		if (err) {
+			error_btrfs_util(err);
+			goto out;
+		}
+
+		subvol->path = strdup("DELETED");
+		if (!subvol->path)
+			goto out;
+
+		if (!filters_match(subvol, filter_set)) {
+			free(subvol->path);
+			continue;
+		}
+
+		subvols->num++;
+	}
+
+	ret = 0;
+out:
+	if (ret) {
+		free_subvol_list(subvols);
+		subvols = NULL;
+		free(ids);
+	}
+	return subvols;
+}
+
+static struct subvol_list *btrfs_list_subvols(int fd,
+					      struct btrfs_list_filter_set_v2 *filter_set)
+{
+	struct subvol_list *subvols;
+	size_t capacity = 0;
+	struct btrfs_util_subvolume_iterator *iter;
+	enum btrfs_util_error err;
+	int ret = -1;
+
+	subvols = malloc(sizeof(*subvols));
+	if (!subvols) {
+		error("out of memory");
+		return NULL;
+	}
+	subvols->num = 0;
+
+	err = btrfs_util_create_subvolume_iterator_fd(fd,
+						      BTRFS_FS_TREE_OBJECTID, 0,
+						      &iter);
+	if (err) {
+		iter = NULL;
+		error_btrfs_util(err);
+		goto out;
+	}
+
+	for (;;) {
+		struct listed_subvol subvol;
+
+		err = btrfs_util_subvolume_iterator_next_info(iter,
+							      &subvol.path,
+							      &subvol.info);
+		if (err == BTRFS_UTIL_ERROR_STOP_ITERATION) {
+			break;
+		} else if (err) {
+			error_btrfs_util(err);
+			goto out;
+		}
+
+		if (!filters_match(&subvol, filter_set)) {
+			free(subvol.path);
+			continue;
+		}
+
+		if (subvols->num >= capacity) {
+			struct subvol_list *new_subvols;
+			size_t new_capacity = max_t(size_t, 1, capacity * 2);
+
+			new_subvols = realloc(subvols,
+					      sizeof(*new_subvols) +
+					      new_capacity *
+					      sizeof(new_subvols->subvols[0]));
+			if (!new_subvols) {
+				error("out of memory");
+				goto out;
+			}
+
+			subvols = new_subvols;
+			capacity = new_capacity;
+		}
+
+		subvols->subvols[subvols->num] = subvol;
+		subvols->num++;
+	}
+
+	ret = 0;
+out:
+	if (iter)
+		btrfs_util_destroy_subvolume_iterator(iter);
+	if (ret) {
+		free_subvol_list(subvols);
+		subvols = NULL;
+	}
+	return subvols;
+}
+
+static int btrfs_list_subvols_print_v2(int fd,
+				    struct btrfs_list_filter_set_v2 *filter_set,
+				    struct btrfs_list_comparer_set_v2 *comp_set,
+				    enum btrfs_list_layout layout,
+				    int full_path, const char *raw_prefix)
+{
+	struct subvol_list *subvols;
+
+	/*
+	 * full_path hasn't done anything since 4f5ebb3ef553 ("Btrfs-progs: fix
+	 * to make list specified directory's subvolumes work"). See
+	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html
+	 */
+
+	if (filter_set->only_deleted)
+		subvols = btrfs_list_deleted_subvols(fd, filter_set);
+	else
+		subvols = btrfs_list_subvols(fd, filter_set);
+	if (!subvols)
+		return -1;
+
+	sort_subvols(comp_set, subvols);
+
+	print_all_subvol_info(subvols, layout, raw_prefix);
+
+	free_subvol_list(subvols);
+
+	return 0;
+}
+
+static int btrfs_list_parse_sort_string_v2(char *opt_arg,
+					struct btrfs_list_comparer_set_v2 **comps)
+{
+	int order;
+	int flag;
+	char *p;
+	char **ptr_argv;
+	int what_to_sort;
+
+	while ((p = strtok(opt_arg, ",")) != NULL) {
+		flag = 0;
+		ptr_argv = all_sort_items;
+
+		while (*ptr_argv) {
+			if (strcmp(*ptr_argv, p) == 0) {
+				flag = 1;
+				break;
+			} else {
+				p++;
+				if (strcmp(*ptr_argv, p) == 0) {
+					flag = 1;
+					p--;
+					break;
+				}
+				p--;
+			}
+			ptr_argv++;
+		}
+
+		if (flag == 0)
+			return -1;
+
+		else {
+			if (*p == '+') {
+				order = 0;
+				p++;
+			} else if (*p == '-') {
+				order = 1;
+				p++;
+			} else
+				order = 0;
+
+			what_to_sort = btrfs_list_get_sort_item(p);
+			btrfs_list_setup_comparer_v2(comps,
+						what_to_sort, order);
+		}
+		opt_arg = NULL;
+	}
+
+	return 0;
+}
+
+static int btrfs_list_parse_filter_string_v2(char *opt_arg,
+					  struct btrfs_list_filter_set_v2 **filters,
+					  enum btrfs_list_filter_enum type)
+{
+
+	u64 arg;
+
+	switch (*(opt_arg++)) {
+	case '+':
+		arg = arg_strtou64(opt_arg);
+		type += 2;
+
+		btrfs_list_setup_filter_v2(filters, type, arg);
+		break;
+	case '-':
+		arg = arg_strtou64(opt_arg);
+		type += 1;
+
+		btrfs_list_setup_filter_v2(filters, type, arg);
+		break;
+	default:
+		opt_arg--;
+		arg = arg_strtou64(opt_arg);
+
+		btrfs_list_setup_filter_v2(filters, type, arg);
+		break;
+	}
+
+	return 0;
+}
+
 /*
  * Naming of options:
  * - uppercase for filters and sort options
@@ -454,8 +1363,8 @@ static const char * const cmd_subvol_list_usage[] = {
 
 static int cmd_subvol_list(int argc, char **argv)
 {
-	struct btrfs_list_filter_set *filter_set;
-	struct btrfs_list_comparer_set *comparer_set;
+	struct btrfs_list_filter_set_v2 *filter_set;
+	struct btrfs_list_comparer_set_v2 *comparer_set;
 	u64 flags = 0;
 	int fd = -1;
 	u64 top_id;
@@ -466,8 +1375,8 @@ static int cmd_subvol_list(int argc, char **argv)
 	DIR *dirstream = NULL;
 	enum btrfs_list_layout layout = BTRFS_LIST_LAYOUT_DEFAULT;
 
-	filter_set = btrfs_list_alloc_filter_set();
-	comparer_set = btrfs_list_alloc_comparer_set();
+	filter_set = btrfs_list_alloc_filter_set_v2();
+	comparer_set = btrfs_list_alloc_comparer_set_v2();
 
 	optind = 0;
 	while(1) {
@@ -484,21 +1393,21 @@ static int cmd_subvol_list(int argc, char **argv)
 
 		switch(c) {
 		case 'p':
-			btrfs_list_setup_print_column(BTRFS_LIST_PARENT);
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_PARENT);
 			break;
 		case 'a':
 			is_list_all = 1;
 			break;
 		case 'c':
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_OGENERATION);
 			break;
 		case 'd':
-			btrfs_list_setup_filter(&filter_set,
+			btrfs_list_setup_filter_v2(&filter_set,
 						BTRFS_LIST_FILTER_DELETED,
 						0);
 			break;
 		case 'g':
-			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_GENERATION);
 			break;
 		case 'o':
 			is_only_in_path = 1;
@@ -507,27 +1416,27 @@ static int cmd_subvol_list(int argc, char **argv)
 			layout = BTRFS_LIST_LAYOUT_TABLE;
 			break;
 		case 's':
-			btrfs_list_setup_filter(&filter_set,
+			btrfs_list_setup_filter_v2(&filter_set,
 						BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
 						0);
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
-			btrfs_list_setup_print_column(BTRFS_LIST_OTIME);
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_OGENERATION);
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_OTIME);
 			break;
 		case 'u':
-			btrfs_list_setup_print_column(BTRFS_LIST_UUID);
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_UUID);
 			break;
 		case 'q':
-			btrfs_list_setup_print_column(BTRFS_LIST_PUUID);
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_PUUID);
 			break;
 		case 'R':
-			btrfs_list_setup_print_column(BTRFS_LIST_RUUID);
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_RUUID);
 			break;
 		case 'r':
 			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 			break;
 		case 'G':
-			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
-			ret = btrfs_list_parse_filter_string(optarg,
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_GENERATION);
+			ret = btrfs_list_parse_filter_string_v2(optarg,
 							&filter_set,
 							BTRFS_LIST_FILTER_GEN);
 			if (ret) {
@@ -537,8 +1446,8 @@ static int cmd_subvol_list(int argc, char **argv)
 			break;
 
 		case 'C':
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
-			ret = btrfs_list_parse_filter_string(optarg,
+			btrfs_list_setup_print_column_v2(BTRFS_LIST_OGENERATION);
+			ret = btrfs_list_parse_filter_string_v2(optarg,
 							&filter_set,
 							BTRFS_LIST_FILTER_CGEN);
 			if (ret) {
@@ -547,7 +1456,7 @@ static int cmd_subvol_list(int argc, char **argv)
 			}
 			break;
 		case 'S':
-			ret = btrfs_list_parse_sort_string(optarg,
+			ret = btrfs_list_parse_sort_string_v2(optarg,
 							   &comparer_set);
 			if (ret) {
 				uerr = 1;
@@ -575,7 +1484,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	}
 
 	if (flags)
-		btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_FLAGS,
+		btrfs_list_setup_filter_v2(&filter_set, BTRFS_LIST_FILTER_FLAGS,
 					flags);
 
 	ret = btrfs_list_get_path_rootid(fd, &top_id);
@@ -583,21 +1492,21 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 
 	if (is_list_all)
-		btrfs_list_setup_filter(&filter_set,
+		btrfs_list_setup_filter_v2(&filter_set,
 					BTRFS_LIST_FILTER_FULL_PATH,
 					top_id);
 	else if (is_only_in_path)
-		btrfs_list_setup_filter(&filter_set,
+		btrfs_list_setup_filter_v2(&filter_set,
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
 
 	/* by default we shall print the following columns*/
-	btrfs_list_setup_print_column(BTRFS_LIST_OBJECTID);
-	btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
-	btrfs_list_setup_print_column(BTRFS_LIST_TOP_LEVEL);
-	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
+	btrfs_list_setup_print_column_v2(BTRFS_LIST_OBJECTID);
+	btrfs_list_setup_print_column_v2(BTRFS_LIST_GENERATION);
+	btrfs_list_setup_print_column_v2(BTRFS_LIST_TOP_LEVEL);
+	btrfs_list_setup_print_column_v2(BTRFS_LIST_PATH);
 
-	ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
+	ret = btrfs_list_subvols_print_v2(fd, filter_set, comparer_set,
 			layout, !is_list_all && !is_only_in_path, NULL);
 
 out:
-- 
2.19.1


