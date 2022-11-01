Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8BFFA3741
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Nov 2022 01:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiKABtY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 21:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKABtW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2022 21:49:22 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE951583F
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Oct 2022 18:49:20 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N1XxT0qBszHvQL;
        Tue,  1 Nov 2022 09:49:01 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 09:49:18 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-btrfs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>
Subject: [PATCH 0/3] Fix UAF and kmemleak when sanity test
Date:   Tue, 1 Nov 2022 10:53:53 +0800
Message-ID: <20221101025356.1643836-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Zhang Xiaoxu (3):
  btrfs: Fix wrong check in btrfs_free_dummy_root()
  btrfs: Fix uaf of the ulist in test_multiple_refs()
  btrfs: Fix ulist memory leak in test_multiple_refs()

 fs/btrfs/tests/btrfs-tests.c  |  2 +-
 fs/btrfs/tests/qgroup-tests.c | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

-- 
2.31.1

