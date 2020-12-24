Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66639C433E9
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Dec 2020 13:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39445224B1
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Dec 2020 13:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgLXNWo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Dec 2020 08:22:44 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9485 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgLXNWo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Dec 2020 08:22:44 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D1rLc6nqyzhvDG;
        Thu, 24 Dec 2020 21:21:12 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 24 Dec 2020 21:21:41 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 -next] btrfs: use DEFINE_MUTEX() for mutex lock
Date:   Thu, 24 Dec 2020 21:22:17 +0800
Message-ID: <20201224132217.30741-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 fs/btrfs/check-integrity.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 81a8c87a5afb..783e1cad9ae3 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -371,7 +371,7 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 					   struct btrfsic_dev_state *dev_state,
 					   u64 dev_bytenr);
 
-static struct mutex btrfsic_mutex;
+static DEFINE_MUTEX(btrfsic_mutex);
 static int btrfsic_is_initialized;
 static struct btrfsic_dev_state_hashtable btrfsic_dev_state_hashtable;
 
@@ -2789,7 +2789,6 @@ int btrfsic_mount(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;
 
 	if (!btrfsic_is_initialized) {
-		mutex_init(&btrfsic_mutex);
 		btrfsic_dev_state_hashtable_init(&btrfsic_dev_state_hashtable);
 		btrfsic_is_initialized = 1;
 	}
-- 
2.22.0

