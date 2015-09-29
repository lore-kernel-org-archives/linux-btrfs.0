Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32893 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbbI2RLL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:11 -0400
Received: by wiclk2 with SMTP id lk2so161268189wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:10 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 09/11] btrfs-progs: use calloc instead of malloc+memset for quick-test.c
Date: Tue, 29 Sep 2015 19:10:44 +0200
Message-Id: <760f5635a72bc03eb6ef8188c22a71b20bff81cc.1443546001.git.silvio.fricke@gmail.com>
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
 quick-test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/quick-test.c b/quick-test.c
index 5dfb2fe..ffde85d 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -46,8 +46,7 @@ int main(int ac, char **av) {
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
 
-	buf = malloc(512);
-	memset(buf, 0, 512);
+	buf = calloc(1, 512);
 
 	radix_tree_init();
 
-- 
2.5.3

