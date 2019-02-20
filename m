Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCFEC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 12:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9876F2147A
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 12:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfBTMSf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:18:35 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:39398 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726209AbfBTMSf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 07:18:35 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4AE3C6E181238EFBA108;
        Wed, 20 Feb 2019 20:18:32 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.408.0; Wed, 20 Feb 2019 20:18:22 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Subject: [PATCH v2 -next] btrfs: Remove unnecessary casts in btrfs_read_root_item
Date:   Wed, 20 Feb 2019 12:32:02 +0000
Message-ID: <20190220123202.43256-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220030840.188854-1-yuehaibing@huawei.com>
References: <20190220030840.188854-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a messy cast here:
	min_t(int, len, (int)sizeof(*item)));

min_t() should normally cast to unsigned.  It's not possible for
"len" to be negative, but if it were then we definitely
wouldn't want to pass negatives to read_extent_buffer().  Also there
is an extra cast.

This patch shouldn't affect runtime, it's just a clean up.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: modify commit message as Dan suggested 
---
 fs/btrfs/root-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 02d1a57af78b..893d12fbfda0 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -21,12 +21,12 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 				struct btrfs_root_item *item)
 {
 	uuid_le uuid;
-	int len;
+	u32 len;
 	int need_reset = 0;
 
 	len = btrfs_item_size_nr(eb, slot);
 	read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
-			min_t(int, len, (int)sizeof(*item)));
+			   min_t(u32, len, sizeof(*item)));
 	if (len < sizeof(*item))
 		need_reset = 1;
 	if (!need_reset && btrfs_root_generation(item)



