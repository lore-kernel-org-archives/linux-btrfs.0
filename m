Return-Path: <SRS0=FriU=YS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E39CA9EA0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 09:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 622C821D7B
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 09:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571997197;
	bh=id1HFiMkODHoDeekxqnlpvkiTR5j3ztIsclSDELpYNo=;
	h=From:To:Subject:Date:List-ID:From;
	b=knUEq0MqmFELC8dXz8QnXcDYBY0prI0dBuHwLiP6YCboUBlAnEThtK+NSuN2917JX
	 R9YttF6k8TxuZ9BQeIycTptS7TkFzL3ekNivtF8wgnx7iDmIEqBlA/vIbtMTJEdjic
	 ApQyGVqZzNmw54ZUmhdiZEL2cGMqvL+eEu4IQGSY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408875AbfJYJxQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 05:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390193AbfJYJxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Oct 2019 05:53:16 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3545A21929
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2019 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571997195;
        bh=id1HFiMkODHoDeekxqnlpvkiTR5j3ztIsclSDELpYNo=;
        h=From:To:Subject:Date:From;
        b=vNCTwGllS11U27uH/qIOO/OmMu3RPBCv5cM4Th046aRQWev5b7m0DNAGpYvT/2GdZ
         ItqOgdI3fUTyTEkc11k6PVYbFoPKbdAkA5widSmmigEq/VWrTIjt/Pi5VLE4LvABCm
         RluHeUVwA1hkRs60fiJ1dndb8tzy6AZR9JVEFOVE=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove wait queue from space_info structure
Date:   Fri, 25 Oct 2019 10:53:12 +0100
Message-Id: <20191025095312.17608-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

It is not used anymore since commit 957780eb2788d8 ("Btrfs: introduce
ticketed enospc infrastructure"), so just remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/space-info.c | 1 -
 fs/btrfs/space-info.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 98dc092a905e..260a883994b9 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -58,7 +58,6 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 	spin_lock_init(&space_info->lock);
 	space_info->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
-	init_waitqueue_head(&space_info->wait);
 	INIT_LIST_HEAD(&space_info->ro_bgs);
 	INIT_LIST_HEAD(&space_info->tickets);
 	INIT_LIST_HEAD(&space_info->priority_tickets);
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 8867e84aa33d..c234ba91d9f1 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -63,7 +63,6 @@ struct btrfs_space_info {
 	struct rw_semaphore groups_sem;
 	/* for block groups in our same type */
 	struct list_head block_groups[BTRFS_NR_RAID_TYPES];
-	wait_queue_head_t wait;
 
 	struct kobject kobj;
 	struct kobject *block_group_kobjs[BTRFS_NR_RAID_TYPES];
-- 
2.11.0

