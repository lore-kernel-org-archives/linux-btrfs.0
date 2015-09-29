Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37463 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbbI2RLB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:01 -0400
Received: by wicfx3 with SMTP id fx3so25946586wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:10:59 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 01/11] btrfs-progs: use calloc instead of malloc+memset for btrfs-image.c
Date: Tue, 29 Sep 2015 19:10:36 +0200
Message-Id: <35b226d067c019506e1a81caf93a43c051862837.1443546001.git.silvio.fricke@gmail.com>
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
 btrfs-image.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 82eed05..20396ef 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1505,10 +1505,9 @@ static struct extent_buffer *alloc_dummy_eb(u64 bytenr, u32 size)
 {
 	struct extent_buffer *eb;
 
-	eb = malloc(sizeof(struct extent_buffer) + size);
+	eb = calloc(1, sizeof(struct extent_buffer) + size);
 	if (!eb)
 		return NULL;
-	memset(eb, 0, sizeof(struct extent_buffer) + size);
 
 	eb->start = bytenr;
 	eb->len = size;
-- 
2.5.3

