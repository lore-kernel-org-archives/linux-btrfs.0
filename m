Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33874 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbbI2RLB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:01 -0400
Received: by wicfx3 with SMTP id fx3so160622828wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:00 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 02/11] btrfs-progs: use calloc instead of malloc+memset for btrfs-list.c
Date: Tue, 29 Sep 2015 19:10:37 +0200
Message-Id: <e9139a9dba401d7934fa061f9270903fa7ec68e1.1443546001.git.silvio.fricke@gmail.com>
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
 btrfs-list.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index d54de61..7529e11 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -226,13 +226,12 @@ struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void)
 
 	size = sizeof(struct btrfs_list_comparer_set) +
 	       BTRFS_LIST_NCOMPS_INCREASE * sizeof(struct btrfs_list_comparer);
-	set = malloc(size);
+	set = calloc(1, size);
 	if (!set) {
 		fprintf(stderr, "memory allocation failed\n");
 		exit(1);
 	}
 
-	memset(set, 0, size);
 	set->total = BTRFS_LIST_NCOMPS_INCREASE;
 
 	return set;
@@ -474,12 +473,11 @@ static int add_root(struct root_lookup *root_lookup,
 	if (!ret)
 		return 0;
 
-	ri = malloc(sizeof(*ri));
+	ri = calloc(1, sizeof(*ri));
 	if (!ri) {
 		printf("memory allocation failed\n");
 		exit(1);
 	}
-	memset(ri, 0, sizeof(*ri));
 	ri->root_id = root_id;
 
 	if (name && name_len > 0) {
@@ -1208,13 +1206,12 @@ struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
 
 	size = sizeof(struct btrfs_list_filter_set) +
 	       BTRFS_LIST_NFILTERS_INCREASE * sizeof(struct btrfs_list_filter);
-	set = malloc(size);
+	set = calloc(1, size);
 	if (!set) {
 		fprintf(stderr, "memory allocation failed\n");
 		exit(1);
 	}
 
-	memset(set, 0, size);
 	set->total = BTRFS_LIST_NFILTERS_INCREASE;
 
 	return set;
-- 
2.5.3

