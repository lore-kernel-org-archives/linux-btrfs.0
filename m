Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21761 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbbASMAk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 07:00:40 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 09/16] Btrfs: Break loop when reach BTRFS_MAX_MIRRORS in scrub_setup_recheck_block()
Date: Mon, 19 Jan 2015 19:20:58 +0800
Message-ID: <1421666465-3892-10-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1421666465-3892-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1421666465-3892-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Use break instead of useless loop should be more suitable in this
case.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c93c43f..9afc6dd 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1386,7 +1386,7 @@ static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 			struct scrub_page *page;
 
 			if (mirror_index >= BTRFS_MAX_MIRRORS)
-				continue;
+				break;
 
 			sblock = sblocks_for_recheck + mirror_index;
 			sblock->sctx = sctx;
-- 
1.8.5.1

