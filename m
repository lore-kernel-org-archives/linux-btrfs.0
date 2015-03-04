Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60202 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932543AbbCDSm0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2015 13:42:26 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t24IfV0n016417
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 02:41:31 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 4/6] btrfs: Clear PageUptodate bit in alloc_rbio_parity_pages()
Date: Thu, 5 Mar 2015 02:41:10 +0800
Message-ID: <5fb5122be1e18f6f031761eea935598f4d744085.1425494151.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <86557aad51883ada25ace853f10d1474e8db048e.1425494151.git.zhaolei@cn.fujitsu.com>
References: <86557aad51883ada25ace853f10d1474e8db048e.1425494151.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0d902ac..0a40d07 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1049,6 +1049,7 @@ static int alloc_rbio_parity_pages(struct btrfs_raid_bio *rbio)
 		if (!page)
 			return -ENOMEM;
 		rbio->stripe_pages[i] = page;
+		ClearPageUptodate(page);
 	}
 	return 0;
 }
-- 
1.8.5.1

