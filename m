Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45922 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab2I1Mw5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 08:52:57 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8SCquSd032767
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 12:52:57 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8SCquXe009861
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 12:52:56 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8SCquU3029844
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 07:52:56 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: make btrfs_list_setup_filter to modify a set filter
Date: Fri, 28 Sep 2012 20:55:48 +0800
Message-Id: <1348836948-19537-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <50584E6D.8000602@cn.fujitsu.com>
References: <50584E6D.8000602@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   50 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index e5f0f96..b1c9714 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1213,37 +1213,51 @@ void btrfs_list_free_filter_set(struct btrfs_list_filter_set *filter_set)
 	free(filter_set);
 }
 
+static int btrfs_list_is_filter_set(struct btrfs_list_filter_set *fset,
+			enum btrfs_list_filter_enum filter)
+{
+	int i;
+	for (i=0; i < fset->nfilters; i++) {
+		if (fset->filters[i].filter_func == all_filter_funcs[filter])
+			return i;
+	}
+	return -1;
+}
+
 int btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 			    enum btrfs_list_filter_enum filter, u64 data)
 {
 	struct btrfs_list_filter_set *set = *filter_set;
 	int size;
+	int nfilter;
 
 	BUG_ON(!set);
 	BUG_ON(filter >= BTRFS_LIST_FILTER_MAX);
 	BUG_ON(set->nfilters > set->total);
 
-	if (set->nfilters == set->total) {
-		size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
-		size = sizeof(*set) + size * sizeof(struct btrfs_list_filter);
-		set = realloc(set, size);
-		if (!set) {
-			fprintf(stderr, "memory allocation failed\n");
-			exit(1);
-		}
+	nfilter = btrfs_list_is_filter_set(set, filter);
+	if (nfilter < 0) {
+		if (set->nfilters == set->total) {
+			size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
+			size = sizeof(*set) + size * sizeof(struct btrfs_list_filter);
+			set = realloc(set, size);
+			if (!set) {
+				fprintf(stderr, "memory allocation failed\n");
+				exit(1);
+			}
 
-		memset(&set->filters[set->total], 0,
-		       BTRFS_LIST_NFILTERS_INCREASE *
-		       sizeof(struct btrfs_list_filter));
-		set->total += BTRFS_LIST_NFILTERS_INCREASE;
-		*filter_set = set;
+			memset(&set->filters[set->total], 0,
+			       BTRFS_LIST_NFILTERS_INCREASE *
+			       sizeof(struct btrfs_list_filter));
+			set->total += BTRFS_LIST_NFILTERS_INCREASE;
+			*filter_set = set;
+		}
+		nfilter = set->nfilters;
+		set->nfilters++;
 	}
 
-	BUG_ON(set->filters[set->nfilters].filter_func);
-
-	set->filters[set->nfilters].filter_func = all_filter_funcs[filter];
-	set->filters[set->nfilters].data = data;
-	set->nfilters++;
+	set->filters[nfilter].filter_func = all_filter_funcs[filter];
+	set->filters[nfilter].data = data;
 	return 0;
 }
 
-- 
1.7.1

