Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18332 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751545AbaE1Kyc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 06:54:32 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4SAsUix028122
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 18:54:30 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: fix blindly goto failure for chunk-recover
Date: Wed, 28 May 2014 18:49:38 +0800
Message-ID: <1401274178-4523-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1401274178-4523-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1401274178-4523-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the csum of one stripe is not able to judge the order of two
device extents, the stripe may happen to belong to the device extent
that is already kicked out as ordered.
Take this condition into consideration, don't report failure and
give more tries with the stripes following.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 924b2f6..5a68d2e 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1943,10 +1943,9 @@ next_csum:
 			list_splice_init(&unordered, &chunk->dextents);
 			btrfs_release_path(&path);
 			return 0;
-		} else
-			ret = 1;
+		}
 
-		goto fail_out;
+		goto next_stripe;
 	}
 
 	if (list_is_last(candidates.next, &candidates)) {
-- 
1.8.1.4

