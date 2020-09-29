Return-Path: <SRS0=ogea=DG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB46C4727F
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Sep 2020 12:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E60020759
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Sep 2020 12:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732253AbgI2Mdo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 08:33:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46060 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733073AbgI2MdZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Sep 2020 08:33:25 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8537ADD7272408A6F99D;
        Tue, 29 Sep 2020 20:33:18 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Tue, 29 Sep 2020
 20:33:12 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next]  btrfs: Fix wild pointer reference in btrfs_set_buffer_lockdep_class
Date:   Tue, 29 Sep 2020 20:33:57 +0800
Message-ID: <20200929123357.930605-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

'ks' is pointer type, but not initialized, so ks->keys will reference
wild pointer.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 177da507dc2a..7068d006d43f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -189,12 +189,12 @@ void __init btrfs_init_lockdep(void)
 void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb,
 				    int level)
 {
-	struct btrfs_lockdep_keyset *ks;
+	struct btrfs_lockdep_keyset *ks = btrfs_lockdep_keysets;
 
 	BUG_ON(level >= ARRAY_SIZE(ks->keys));
 
 	/* find the matching keyset, id 0 is the default entry */
-	for (ks = btrfs_lockdep_keysets; ks->id; ks++)
+	for (; ks->id; ks++)
 		if (ks->id == objectid)
 			break;
 
-- 
2.25.4

