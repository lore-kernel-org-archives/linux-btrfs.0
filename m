Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B887AC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 03:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0602082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 03:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbfC0DIq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 23:08:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48106 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732617AbfC0DIq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 23:08:46 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 13E93EDCC689C7A7E2CF;
        Wed, 27 Mar 2019 11:08:44 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.408.0; Wed, 27 Mar 2019 11:08:34 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] btrfs: remove set but not used variable 'fs_devices'
Date:   Wed, 27 Mar 2019 03:20:24 +0000
Message-ID: <20190327032024.63906-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

fs/btrfs/volumes.c: In function 'btrfs_grow_device':
fs/btrfs/volumes.c:2824:27: warning:
 variable 'fs_devices' set but not used [-Wunused-but-set-variable]

It's not used after 6f32a50a232b ("btrfs: combine device update operations
during transaction commit")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/volumes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index afafc92e70e9..605230482009 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2821,7 +2821,6 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_super_block *super_copy = fs_info->super_copy;
-	struct btrfs_fs_devices *fs_devices;
 	u64 old_total;
 	u64 diff;
 
@@ -2840,8 +2839,6 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 	}
 
-	fs_devices = fs_info->fs_devices;
-
 	btrfs_set_super_total_bytes(super_copy,
 			round_down(old_total + diff, fs_info->sectorsize));
 	device->fs_devices->total_rw_bytes += diff;



