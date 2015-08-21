Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36511 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbHUDKZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 23:10:25 -0400
Received: by pdbmi9 with SMTP id mi9so21199586pdb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 20:10:24 -0700 (PDT)
Received: from arch-nb.localdomain ([211.106.186.1])
        by smtp.gmail.com with ESMTPSA id qn6sm5867979pbc.22.2015.08.20.20.10.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 20 Aug 2015 20:10:22 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix memory leaks in error path
Date: Fri, 21 Aug 2015 12:10:12 +0900
Message-Id: <1440126612-53381-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch includes below fixes in error path:
1. fix memory leaks if realloc() fails
2. add missing call free_history() before return error in scrub_read_file()

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 btrfs-list.c |  8 ++++++++
 cmds-scrub.c | 18 ++++++++++++++----
 qgroup.c     |  8 ++++++++
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 875a89dc4ef0..d54de61aec01 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -254,11 +254,15 @@ static int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
 	BUG_ON(set->ncomps > set->total);
 
 	if (set->ncomps == set->total) {
+		void *tmp;
+
 		size = set->total + BTRFS_LIST_NCOMPS_INCREASE;
 		size = sizeof(*set) + size * sizeof(struct btrfs_list_comparer);
+		tmp = set;
 		set = realloc(set, size);
 		if (!set) {
 			fprintf(stderr, "memory allocation failed\n");
+			free(tmp);
 			exit(1);
 		}
 
@@ -1232,11 +1236,15 @@ int btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 	BUG_ON(set->nfilters > set->total);
 
 	if (set->nfilters == set->total) {
+		void *tmp;
+
 		size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
 		size = sizeof(*set) + size * sizeof(struct btrfs_list_filter);
+		tmp = set;
 		set = realloc(set, size);
 		if (!set) {
 			fprintf(stderr, "memory allocation failed\n");
+			free(tmp);
 			exit(1);
 		}
 
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5a85dc473c94..91cf67841849 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -502,12 +502,16 @@ again:
 		}
 		return p;
 	}
-	if (avail == -1)
+	if (avail == -1) {
+		free_history(p);
 		return ERR_PTR(-errno);
+	}
 	avail += old_avail;
 
 	i = 0;
 	while (i < avail) {
+		void *tmp;
+
 		switch (state) {
 		case 0: /* start of file */
 			ret = scrub_kvread(&i,
@@ -534,11 +538,17 @@ again:
 				continue;
 			}
 			++curr;
+			tmp = p;
 			p = realloc(p, (curr + 2) * sizeof(*p));
-			if (p)
-				p[curr] = malloc(sizeof(**p));
-			if (!p || !p[curr])
+			if (!p) {
+				free_history(tmp);
 				return ERR_PTR(-errno);
+			}
+			p[curr] = malloc(sizeof(**p));
+			if (!p[curr]) {
+				free_history(p);
+				return ERR_PTR(-errno);
+			}
 			memset(p[curr], 0, sizeof(**p));
 			p[curr + 1] = NULL;
 			++state;
diff --git a/qgroup.c b/qgroup.c
index dc04b033b145..327abd645f16 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -465,12 +465,16 @@ int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set  **comp_set,
 	BUG_ON(set->ncomps > set->total);
 
 	if (set->ncomps == set->total) {
+		void *tmp;
+
 		size = set->total + BTRFS_QGROUP_NCOMPS_INCREASE;
 		size = sizeof(*set) +
 		       size * sizeof(struct btrfs_qgroup_comparer);
+		tmp = set;
 		set = realloc(set, size);
 		if (!set) {
 			fprintf(stderr, "memory allocation failed\n");
+			free(tmp);
 			exit(1);
 		}
 
@@ -836,12 +840,16 @@ int btrfs_qgroup_setup_filter(struct btrfs_qgroup_filter_set **filter_set,
 	BUG_ON(set->nfilters > set->total);
 
 	if (set->nfilters == set->total) {
+		void *tmp;
+
 		size = set->total + BTRFS_QGROUP_NFILTERS_INCREASE;
 		size = sizeof(*set) + size * sizeof(struct btrfs_qgroup_filter);
 
+		tmp = set;
 		set = realloc(set, size);
 		if (!set) {
 			fprintf(stderr, "memory allocation failed\n");
+			free(tmp);
 			exit(1);
 		}
 		memset(&set->filters[set->total], 0,
-- 
2.5.0

