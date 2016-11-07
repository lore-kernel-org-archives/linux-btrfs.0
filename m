Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56023 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbcKGIGv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 03:06:51 -0500
Received: from localhost.localdomain (unknown [10.167.226.107])
        by cn.fujitsu.com (Postfix) with ESMTP id 4B44241B4BC2
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Nov 2016 16:06:38 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: add necessary comments about tickets_id
Date: Mon,  7 Nov 2016 15:59:16 +0800
Message-Id: <1478505557-1406-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tickets_id's name may result in some misunderstandings,  it just indicates
the next ticket will be handled and is not stored per ticket.

Fixes: ce12965 ("btrfs: introduce tickets_id to determine whether
asynchronous metadata reclaim work makes progress")
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b8ce2b..9307084 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -429,6 +429,10 @@ struct btrfs_space_info {
 	struct list_head ro_bgs;
 	struct list_head priority_tickets;
 	struct list_head tickets;
+	/*
+	 * tickets_id just indicates the next ticket will be handled, so note
+	 * it's not stored per ticket.
+	 */
 	u64 tickets_id;
 
 	struct rw_semaphore groups_sem;
-- 
2.5.0



