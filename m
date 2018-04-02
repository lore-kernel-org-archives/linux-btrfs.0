Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44349 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754251AbeDBKTq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Apr 2018 06:19:46 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 75C9448AE780
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Apr 2018 18:19:42 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Remove duplicate value-get for data_extents_scrubbed
Date: Mon, 2 Apr 2018 18:11:17 +0800
Message-ID: <1522663877-1547-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Get data_extents_scrubbed value for twice, since there is only
one data_extents_scrubbed in struct btrfs_scrub_progress, remove
the duplicate one.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-scrub.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index dabe7d9a..6b909f20 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -589,8 +589,6 @@ again:
 			/* fall through */
 		case 5: /* read key/value pair */
 			ret = 0;
-			_SCRUB_KVREAD(ret, &i, data_extents_scrubbed, avail, l,
-					&p[curr]->p);
 			_SCRUB_KVREAD(ret, &i, data_extents_scrubbed, avail, l,
 					&p[curr]->p);
 			_SCRUB_KVREAD(ret, &i, tree_extents_scrubbed, avail, l,
-- 
2.14.3



