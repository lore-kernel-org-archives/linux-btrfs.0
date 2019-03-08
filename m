Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC13C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 07:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 779D62081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 07:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfCHH3l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 02:29:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:33484 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726238AbfCHH3l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Mar 2019 02:29:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06AE2AF9C;
        Fri,  8 Mar 2019 07:29:40 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
Subject: [PATCH 3/3] btrfs: tree-checker: Fix NULL pointer access for corrupted chunk root
Date:   Fri,  8 Mar 2019 15:29:29 +0800
Message-Id: <20190308072929.30863-4-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190308072929.30863-1-wqu@suse.com>
References: <20190308072929.30863-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
For a special crafted image, kernel can cause NULL pointer dereference like:
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
  #PF error: [normal kernel read fault]
  Oops: 0000 [#1] SMP PTI
  CPU: 0 PID: 146 Comm: kworker/u2:4 Not tainted 5.0.0-rc8+ #9
  Workqueue: btrfs-endio-meta btrfs_endio_meta_helper
  RIP: 0010:btrfs_root_node+0x10/0x50
  Call Trace:
   btrfs_read_lock_root_node+0x29/0x50
   btrfs_search_slot+0x529/0x920
   btrfs_find_root+0x56/0x240
   btrfs_read_tree_root+0x8b/0x130
   btrfs_read_fs_root+0x12/0x40
   btrfs_get_fs_root.part.49+0x53/0x170
   btrfs_get_fs_root+0x44/0xa0
   check_leaf+0xc0/0xa90
   btrfs_check_leaf_full+0x13/0x20
   btree_readpage_end_io_hook+0x242/0x290
   end_bio_extent_readpage+0x14f/0x660
   bio_endio+0xc4/0x140
   end_workqueue_fn+0x3d/0x40
   normal_work_helper+0xcb/0x320
   btrfs_endio_meta_helper+0x12/0x20
   process_one_work+0x167/0x410
   worker_thread+0x4d/0x460
   kthread+0x105/0x140
   ret_from_fork+0x35/0x40

[CAUSE]
Tree checker can be triggered when tree root is still not initialized.
This is for chunk tree read.

However if chunk tree is empty and has incorrect owner, then tree
checker will do comprehensive empty tree check.
This check involves search root tree to find the root, thus triggering
NULL pointer dereference as root tree is not yet initialized.

[FIX]
Just skip restrict owner check if tree root is not yet initialized.

Fix this fix, the corrupted image can be rejected as expected:
  BTRFS info (device loop0): disk space caching is enabled
  BTRFS info (device loop0): has skinny extents
  BTRFS error (device loop0): super_num_devices 1 mismatch with num_devices 0 found here
  BTRFS error (device loop0): failed to read chunk tree: -22
  BTRFS error (device loop0): open_ctree failed

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202753
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 5ccb4be583ea..e01a84be768f 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -760,8 +760,12 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 		 * we can't use @owner as accurate owner indicator.
 		 * Case like balance and new tree block created for commit root
 		 * can break owner check easily.
+		 *
+		 * Also we could trigger tree checker before root tree
+		 * initialized (read chunk tree), skip strict owner check
+		 * if root tree is not initialized yet.
 		 */
-		if (!check_empty_leaf)
+		if (!check_empty_leaf || !fs_info->tree_root->node)
 			return 0;
 
 		key.objectid = owner;
-- 
2.21.0

