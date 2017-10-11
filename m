Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18474 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754231AbdJKBzt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 21:55:49 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 4DE7B47CAAE4
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 09:55:45 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH v2] btrfs: Use bd_dev to generate index when dev_state_hashtable add items.
Date: Wed, 11 Oct 2017 09:55:41 +0800
Message-ID: <1507686941-46390-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gu JinXiang <gujx@cn.fujitsu.com>

Fix bug of
<f8f84b2dfda5> (<btrfs: index check-integrity state hash by a dev_t>).

Description of this bug:
Use MOUNT_OPTIONS="-o check_int" when run xfstest, device can not be
mount successfully. So xfstest can not run.

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



