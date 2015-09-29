Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32864 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934840AbbI2RLK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:10 -0400
Received: by wiclk2 with SMTP id lk2so161267309wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:09 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 08/11] btrfs-progs: use calloc instead of malloc+memset for qgroup.c
Date: Tue, 29 Sep 2015 19:10:43 +0200
Message-Id: <9951a5c05498bcf3cba532a639e8cda077b9bbc9.1443546001.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443546000.git.silvio.fricke@gmail.com>
References: <cover.1443546000.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443546000.git.silvio.fricke@gmail.com>
References: <cover.1443459879.git.silvio.fricke@gmail.com> <cover.1443546000.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch is generated from a coccinelle semantic patch:

	identifier t;
	expression e;
	statement s;
	@@
	-t = malloc(e);
	+t = calloc(1, e);
	(
	if (!t) s
	|
	if (t == NULL) s
	|
	)
	-memset(t, 0, e);

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 qgroup.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index ec9a3ac..99fddea 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -436,13 +436,12 @@ struct btrfs_qgroup_comparer_set *btrfs_qgroup_alloc_comparer_set(void)
 	size = sizeof(struct btrfs_qgroup_comparer_set) +
 	       BTRFS_QGROUP_NCOMPS_INCREASE *
 	       sizeof(struct btrfs_qgroup_comparer);
-	set = malloc(size);
+	set = calloc(1, size);
 	if (!set) {
 		fprintf(stderr, "memory allocation failed\n");
 		exit(1);
 	}
 
-	memset(set, 0, size);
 	set->total = BTRFS_QGROUP_NCOMPS_INCREASE;
 
 	return set;
@@ -644,12 +643,11 @@ static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 	if (!ret)
 		return 0;
 
-	bq = malloc(sizeof(*bq));
+	bq = calloc(1, sizeof(*bq));
 	if (!bq) {
 		printf("memory allocation failed\n");
 		exit(1);
 	}
-	memset(bq, 0, sizeof(*bq));
 	if (qgroupid) {
 		bq->qgroupid = qgroupid;
 		INIT_LIST_HEAD(&bq->qgroups);
@@ -813,12 +811,11 @@ struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void)
 	size = sizeof(struct btrfs_qgroup_filter_set) +
 	       BTRFS_QGROUP_NFILTERS_INCREASE *
 	       sizeof(struct btrfs_qgroup_filter);
-	set = malloc(size);
+	set = calloc(1, size);
 	if (!set) {
 		fprintf(stderr, "memory allocation failed\n");
 		exit(1);
 	}
-	memset(set, 0, size);
 	set->total = BTRFS_QGROUP_NFILTERS_INCREASE;
 
 	return set;
-- 
2.5.3

