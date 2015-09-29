Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34037 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797AbbI2RLI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:08 -0400
Received: by wicfx3 with SMTP id fx3so160627507wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:07 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 07/11] btrfs-progs: use calloc instead of malloc+memset for mkfs.c
Date: Tue, 29 Sep 2015 19:10:42 +0200
Message-Id: <cfdff4755c6c94a877a805fd97f8c5a3179d02c8.1443546001.git.silvio.fricke@gmail.com>
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
 mkfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index a5802f7..ecd6fbf 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -668,12 +668,11 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 	 * do our IO in extent buffers so it can work
 	 * against any raid type
 	 */
-	eb = malloc(sizeof(*eb) + sectorsize);
+	eb = calloc(1, sizeof(*eb) + sectorsize);
 	if (!eb) {
 		ret = -ENOMEM;
 		goto end;
 	}
-	memset(eb, 0, sizeof(*eb) + sectorsize);
 
 again:
 
-- 
2.5.3

