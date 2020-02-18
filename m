Return-Path: <SRS0=4mvY=4G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B516DC3403F
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Feb 2020 14:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977692176D
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Feb 2020 14:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgBRO4N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 09:56:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:48212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgBRO4N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Feb 2020 09:56:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A9225C136;
        Tue, 18 Feb 2020 14:56:11 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: export btrfs_uuid_scan_kthread
Date:   Tue, 18 Feb 2020 16:56:08 +0200
Message-Id: <20200218145609.13427-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200218145609.13427-1-nborisov@suse.com>
References: <20200218145609.13427-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is preparation for the next patch that will move the rescan uuid
kthread into disk-io.c. No functional changes.
---
 fs/btrfs/volumes.c | 2 +-
 fs/btrfs/volumes.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fdc0e52542dd..0b4da3557c27 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4274,7 +4274,7 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
-static int btrfs_uuid_scan_kthread(void *data)
+int btrfs_uuid_scan_kthread(void *data)
 {
 	struct btrfs_fs_info *fs_info = data;
 	struct btrfs_root *root = fs_info->tree_root;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index f01552a0785e..311d03cf99a7 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -462,6 +462,7 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info);
+int btrfs_uuid_scan_kthread(void *data);
 int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
-- 
2.17.1

