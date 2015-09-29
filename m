Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35463 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934584AbbI2RLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:07 -0400
Received: by wicge5 with SMTP id ge5so160119420wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:05 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 06/11] btrfs-progs: use calloc instead of malloc+memset for extent_io.c
Date: Tue, 29 Sep 2015 19:10:41 +0200
Message-Id: <2346aa9e38c50d7c9e58c101eb2a5e6d50de8047.1443546001.git.silvio.fricke@gmail.com>
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
 extent_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index 07695ef..75496ce 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -538,12 +538,11 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 {
 	struct extent_buffer *eb;
 
-	eb = malloc(sizeof(struct extent_buffer) + blocksize);
+	eb = calloc(1, sizeof(struct extent_buffer) + blocksize);
 	if (!eb) {
 		BUG();
 		return NULL;
 	}
-	memset(eb, 0, sizeof(struct extent_buffer) + blocksize);
 
 	eb->start = bytenr;
 	eb->len = blocksize;
-- 
2.5.3

