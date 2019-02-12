Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15460C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 14:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1A5C2186A
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 14:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbfBLONR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 09:13:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:37918 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728629AbfBLONR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 09:13:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55AD7AEBC
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 14:13:16 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Transpose btrfs_close_devices/btrfs_mapping_tree_free in close_ctree
Date:   Tue, 12 Feb 2019 16:13:14 +0200
Message-Id: <20190212141314.9169-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190211083510.27591-8-nborisov@suse.com>
References: <20190211083510.27591-8-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Following the introduction of the alloc_state tree, some of the callees
of btrfs_mapping_tree_free will have to interact with the btrfs_device
of the constituent devices. Enable this by moving the code responsible
for freeing devices after the last user (btrfs_mapping_tree_free).
Otherwise the kernel could crash due to UAF.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Hello David, 

The following patch either needs to come before "btrfs: replace pending/pinned
chunks lists with io tree" or has to be squashed in said commit. I'd prefer it 
to be a separate patch to have the explanation of the order of functions in 
the commit log. 


 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f1c42d242d48..4f74942f1d97 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4041,8 +4041,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 		btrfsic_unmount(fs_info->fs_devices);
 #endif
 
-	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
+	btrfs_close_devices(fs_info->fs_devices);
 
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
 	percpu_counter_destroy(&fs_info->delalloc_bytes);
-- 
2.17.1

