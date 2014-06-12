Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16859 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755197AbaFLCaY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 22:30:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5C2UAFW024488
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 10:30:10 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: cleanup unused assignment for chunk-recover
Date: Thu, 12 Jun 2014 10:25:01 +0800
Message-ID: <1402539901-22779-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'num_unordered' will be recounted after 'goto out',
just remove it.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index d5a688e..8bc5bc3 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1905,7 +1905,6 @@ next_csum:
 		fprintf(stderr, "Fetch csum failed\n");
 		goto fail_out;
 	} else if (ret == 1) {
-		num_unordered = count_devext_records(&unordered);
 		if (!(*flags & EQUAL_STRIPE))
 			*flags |= EQUAL_STRIPE;
 		goto out;
-- 
1.8.1.4

