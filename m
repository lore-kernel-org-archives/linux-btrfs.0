Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fau.xxx ([213.133.103.231]:54078 "EHLO om.goeswhere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab3IIWPL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 18:15:11 -0400
Date: Mon, 9 Sep 2013 23:06:24 +0100
From: "Chris West (Faux)" <git@goeswhere.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: 'optarg' shadows getopt
Message-ID: <20130909220624.GA10060@goeswhere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 btrfs-list.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 55508d2..9cadbf5 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1786,7 +1786,7 @@ char *btrfs_list_path_for_root(int fd, u64 root)
 	return ret_path;
 }
 
-int btrfs_list_parse_sort_string(char *optarg,
+int btrfs_list_parse_sort_string(char *opt_arg,
 				 struct btrfs_list_comparer_set **comps)
 {
 	int order;
@@ -1795,7 +1795,7 @@ int btrfs_list_parse_sort_string(char *optarg,
 	char **ptr_argv;
 	int what_to_sort;
 
-	while ((p = strtok(optarg, ",")) != NULL) {
+	while ((p = strtok(opt_arg, ",")) != NULL) {
 		flag = 0;
 		ptr_argv = all_sort_items;
 
@@ -1831,7 +1831,7 @@ int btrfs_list_parse_sort_string(char *optarg,
 			what_to_sort = btrfs_list_get_sort_item(p);
 			btrfs_list_setup_comparer(comps, what_to_sort, order);
 		}
-		optarg = NULL;
+		opt_arg = NULL;
 	}
 
 	return 0;
@@ -1842,37 +1842,37 @@ int btrfs_list_parse_sort_string(char *optarg,
  *
  * type is the filter object.
  */
-int btrfs_list_parse_filter_string(char *optarg,
+int btrfs_list_parse_filter_string(char *opt_arg,
 				   struct btrfs_list_filter_set **filters,
 				   enum btrfs_list_filter_enum type)
 {
 
 	u64 arg;
 	char *ptr_parse_end = NULL;
-	char *ptr_optarg_end = optarg + strlen(optarg);
+	char *ptr_opt_arg_end = opt_arg + strlen(opt_arg);
 
-	switch (*(optarg++)) {
+	switch (*(opt_arg++)) {
 	case '+':
-		arg = (u64)strtol(optarg, &ptr_parse_end, 10);
+		arg = (u64)strtol(opt_arg, &ptr_parse_end, 10);
 		type += 2;
-		if (ptr_parse_end != ptr_optarg_end)
+		if (ptr_parse_end != ptr_opt_arg_end)
 			return -1;
 
 		btrfs_list_setup_filter(filters, type, arg);
 		break;
 	case '-':
-		arg = (u64)strtoll(optarg, &ptr_parse_end, 10);
+		arg = (u64)strtoll(opt_arg, &ptr_parse_end, 10);
 		type += 1;
-		if (ptr_parse_end != ptr_optarg_end)
+		if (ptr_parse_end != ptr_opt_arg_end)
 			return -1;
 
 		btrfs_list_setup_filter(filters, type, arg);
 		break;
 	default:
-		optarg--;
-		arg = (u64)strtoll(optarg, &ptr_parse_end, 10);
+		opt_arg--;
+		arg = (u64)strtoll(opt_arg, &ptr_parse_end, 10);
 
-		if (ptr_parse_end != ptr_optarg_end)
+		if (ptr_parse_end != ptr_opt_arg_end)
 			return -1;
 		btrfs_list_setup_filter(filters, type, arg);
 		break;
-- 
1.8.4.rc3

