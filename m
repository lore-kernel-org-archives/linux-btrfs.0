Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33917 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999AbbI2RLD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:03 -0400
Received: by wicfx3 with SMTP id fx3so160624002wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:02 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 03/11] btrfs-progs: use calloc instead of malloc+memset for chunk-recover.c
Date: Tue, 29 Sep 2015 19:10:38 +0200
Message-Id: <c5aaa76ff11a328e0f07d76052b067d341aa097b.1443546001.git.silvio.fricke@gmail.com>
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
 chunk-recover.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 1fb04f7..d0ca920 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -85,13 +85,12 @@ static struct extent_record *btrfs_new_extent_record(struct extent_buffer *eb)
 {
 	struct extent_record *rec;
 
-	rec = malloc(sizeof(*rec));
+	rec = calloc(1, sizeof(*rec));
 	if (!rec) {
 		fprintf(stderr, "Fail to allocate memory for extent record.\n");
 		exit(1);
 	}
 
-	memset(rec, 0, sizeof(*rec));
 	rec->cache.start = btrfs_header_bytenr(eb);
 	rec->cache.size = eb->len;
 	rec->generation = btrfs_header_generation(eb);
@@ -2228,10 +2227,9 @@ static int btrfs_recover_chunks(struct recover_control *rc)
 		nstripes = btrfs_get_device_extents(bg->objectid,
 						    &rc->devext.no_chunk_orphans,
 						    &devexts);
-		chunk = malloc(btrfs_chunk_record_size(nstripes));
+		chunk = calloc(1, btrfs_chunk_record_size(nstripes));
 		if (!chunk)
 			return -ENOMEM;
-		memset(chunk, 0, btrfs_chunk_record_size(nstripes));
 		INIT_LIST_HEAD(&chunk->dextents);
 		chunk->bg_rec = bg;
 		chunk->cache.start = bg->objectid;
-- 
2.5.3

