Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45876 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932668AbbCDSm1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2015 13:42:27 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t24IfWi0016424
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 02:41:32 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 6/6] btrfs: Remove unused err = 0 line for raid_rmw_end_io()
Date: Thu, 5 Mar 2015 02:41:12 +0800
Message-ID: <b06c3a67e588c422ed49024c1a10a42c5a917b5b.1425494151.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <86557aad51883ada25ace853f10d1474e8db048e.1425494151.git.zhaolei@cn.fujitsu.com>
References: <86557aad51883ada25ace853f10d1474e8db048e.1425494151.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 2285e78..c087870 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1464,7 +1464,6 @@ static void raid_rmw_end_io(struct bio *bio, int err)
 	if (!atomic_dec_and_test(&rbio->stripes_pending))
 		return;
 
-	err = 0;
 	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
 		goto cleanup;
 
-- 
1.8.5.1

