Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37552 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934106AbbI2RLE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:04 -0400
Received: by wicfx3 with SMTP id fx3so25949009wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:03 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 04/11] btrfs-progs: use calloc instead of malloc+memset for cmds-check.c
Date: Tue, 29 Sep 2015 19:10:39 +0200
Message-Id: <9f98533d94e0228c499935656d24904fa4877999.1443546001.git.silvio.fricke@gmail.com>
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
 cmds-check.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 07df79f..2923d05 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4892,14 +4892,12 @@ struct chunk_record *btrfs_new_chunk_record(struct extent_buffer *leaf,
 	ptr = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, ptr);
 
-	rec = malloc(btrfs_chunk_record_size(num_stripes));
+	rec = calloc(1, btrfs_chunk_record_size(num_stripes));
 	if (!rec) {
 		fprintf(stderr, "memory allocation failed\n");
 		exit(-1);
 	}
 
-	memset(rec, 0, btrfs_chunk_record_size(num_stripes));
-
 	INIT_LIST_HEAD(&rec->list);
 	INIT_LIST_HEAD(&rec->dextents);
 	rec->bg_rec = NULL;
@@ -4997,12 +4995,11 @@ btrfs_new_block_group_record(struct extent_buffer *leaf, struct btrfs_key *key,
 	struct btrfs_block_group_item *ptr;
 	struct block_group_record *rec;
 
-	rec = malloc(sizeof(*rec));
+	rec = calloc(1, sizeof(*rec));
 	if (!rec) {
 		fprintf(stderr, "memory allocation failed\n");
 		exit(-1);
 	}
-	memset(rec, 0, sizeof(*rec));
 
 	rec->cache.start = key->objectid;
 	rec->cache.size = key->offset;
@@ -5046,12 +5043,11 @@ btrfs_new_device_extent_record(struct extent_buffer *leaf,
 	struct device_extent_record *rec;
 	struct btrfs_dev_extent *ptr;
 
-	rec = malloc(sizeof(*rec));
+	rec = calloc(1, sizeof(*rec));
 	if (!rec) {
 		fprintf(stderr, "memory allocation failed\n");
 		exit(-1);
 	}
-	memset(rec, 0, sizeof(*rec));
 
 	rec->cache.objectid = key->objectid;
 	rec->cache.start = key->offset;
-- 
2.5.3

