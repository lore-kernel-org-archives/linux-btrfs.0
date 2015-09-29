Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37743 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934899AbbI2RLN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:13 -0400
Received: by wicfx3 with SMTP id fx3so25954606wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:12 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 10/11] btrfs-progs: use calloc instead of malloc+memset for volumes.c
Date: Tue, 29 Sep 2015 19:10:45 +0200
Message-Id: <15a59eb69ae9db79ef8ad353b1570f1ed42342f9.1443546001.git.silvio.fricke@gmail.com>
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
 volumes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index ca50f1c..83ddd16 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1968,10 +1968,9 @@ static void split_eb_for_raid56(struct btrfs_fs_info *info,
 		if (raid_map[i] >= BTRFS_RAID5_P_STRIPE)
 			break;
 
-		eb = malloc(sizeof(struct extent_buffer) + stripe_len);
+		eb = calloc(1, sizeof(struct extent_buffer) + stripe_len);
 		if (!eb)
 			BUG();
-		memset(eb, 0, sizeof(struct extent_buffer) + stripe_len);
 
 		eb->start = raid_map[i];
 		eb->len = stripe_len;
-- 
2.5.3

