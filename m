Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AB8C282C3
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 01:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EA77218CD
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 01:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfAYBol (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 20:44:41 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:2748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727983AbfAYBol (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 20:44:41 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 68B7E8303B2C5798143E;
        Fri, 25 Jan 2019 09:44:39 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.408.0; Fri, 25 Jan 2019 09:44:30 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] btrfs: qgroup: Fix inconsistent IS_ERR and PTR_ERR
Date:   Fri, 25 Jan 2019 01:50:09 +0000
Message-ID: <1548381009-80383-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Change the call to PTR_ERR to access the value just tested by IS_ERR.

Fixes: 2b35a512e9cf ("btrfs: qgroup: Use delayed subtree rescan for balance")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8559ed9..16d7ec8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3931,7 +3931,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 				   block->reloc_generation, block->level,
 				   &block->first_key);
 	if (IS_ERR(reloc_eb)) {
-		ret = PTR_ERR(subv_eb);
+		ret = PTR_ERR(reloc_eb);
 		reloc_eb = NULL;
 		goto free_out;
 	}



