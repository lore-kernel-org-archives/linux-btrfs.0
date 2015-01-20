Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7142 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753425AbbATHND (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 02:13:03 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 05/15] Btrfs: Fix a jump typo of nodatasum_case to avoid wrong WARN_ON()
Date: Tue, 20 Jan 2015 15:11:35 +0800
Message-ID: <1421737905-1693-6-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1421737905-1693-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1421737905-1693-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

if (sctx->is_dev_replace && !is_metadata && !have_csum) {
    ...
    goto nodatasum_case;
}
...
nodatasum_case:
    WARN_ON(sctx->is_dev_replace);

In above code, nodatasum_case marker should be moved after
WARN_ON().

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 1c50982..ec0a2f8 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1028,9 +1028,10 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	if (!is_metadata && !have_csum) {
 		struct scrub_fixup_nodatasum *fixup_nodatasum;
 
-nodatasum_case:
 		WARN_ON(sctx->is_dev_replace);
 
+nodatasum_case:
+
 		/*
 		 * !is_metadata and !have_csum, this means that the data
 		 * might not be COW'ed, that it might be modified
-- 
1.8.5.1

