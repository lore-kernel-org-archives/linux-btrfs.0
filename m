Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41431 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751467AbdI2IQm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 04:16:42 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <hch@lst.de>, Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH] btrfs: Use bd_dev to generate index when dev_state_hashtable add items.
Date: Fri, 29 Sep 2017 16:16:35 +0800
Message-ID: <1506672995-12488-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gu JinXiang <gujx@cn.fujitsu.com>

Fix bug of
<f8f84b2dfda5> (<btrfs: index check-integrity state hash by a dev_t>).

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/check-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 9d3854839038..86d79bc4cfb3 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -613,7 +613,7 @@ static void btrfsic_dev_state_hashtable_add(
 		struct btrfsic_dev_state_hashtable *h)
 {
 	const unsigned int hashval =
-	    (((unsigned int)((uintptr_t)ds->bdev)) &
+	    (((unsigned int)((uintptr_t)ds->bdev->bd_dev)) &
 	     (BTRFSIC_DEV2STATE_HASHTABLE_SIZE - 1));
 
 	list_add(&ds->collision_resolving_node, h->table + hashval);
-- 
2.13.5



