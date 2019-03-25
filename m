Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCC6C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4891C2085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731185AbfCYMbo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:31:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:55586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730996AbfCYMbl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 08:31:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4107AE89
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 12:31:39 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 03/12] btrfs: Handle pending/pinned chunks before blockgroup relocation during device shrink
Date:   Mon, 25 Mar 2019 14:31:23 +0200
Message-Id: <20190325123132.27835-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190325123132.27835-1-nborisov@suse.com>
References: <20190325123132.27835-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

During device shrink pinned/pending chunks (i.e those which have been
deleted/created respectively, in the current transaction and haven't
touched disk) need to be accounted when doing device shrink. Presently
this happens after the main relocation loop in btrfs_shrink_device,
which could lead to making another go in the body of the function.

Since there is no hard requirement to perform pinned/pending chunks
handling after the relocation loop, move the code before it. This leads
to simplifying the code flow around - i.e no need to use 'goto again'.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 54 ++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3f81380265e5..b49cc5ad758e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4722,15 +4722,15 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	int slot;
 	int failed = 0;
 	bool retried = false;
-	bool checked_pending_chunks = false;
 	struct extent_buffer *l;
 	struct btrfs_key key;
 	struct btrfs_super_block *super_copy = fs_info->super_copy;
 	u64 old_total = btrfs_super_total_bytes(super_copy);
 	u64 old_size = btrfs_device_get_total_bytes(device);
 	u64 diff;
+	u64 start;
 
-	new_size = round_down(new_size, fs_info->sectorsize);
+	start = new_size = round_down(new_size, fs_info->sectorsize);
 	diff = round_down(old_size - new_size, fs_info->sectorsize);
 
 	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
@@ -4742,6 +4742,10 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 	path->reada = READA_BACK;
 
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	mutex_lock(&fs_info->chunk_mutex);
 
 	btrfs_device_set_total_bytes(device, new_size);
@@ -4749,7 +4753,21 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		device->fs_devices->total_rw_bytes -= diff;
 		atomic64_sub(diff, &fs_info->free_chunk_space);
 	}
-	mutex_unlock(&fs_info->chunk_mutex);
+
+	/*
+	 * Once the device's size has been set to the new size, ensure all
+	 * in-memory chunks are synced to disk so that the loop below sees them
+	 * and relocates them accordingly.
+	 */
+	if (contains_pending_extent(trans->transaction, device, &start, diff)) {
+		mutex_unlock(&fs_info->chunk_mutex);
+		ret = btrfs_commit_transaction(trans);
+		if (ret)
+			goto done;
+	} else {
+		mutex_unlock(&fs_info->chunk_mutex);
+		btrfs_end_transaction(trans);
+	}
 
 again:
 	key.objectid = device->devid;
@@ -4840,36 +4858,6 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	}
 
 	mutex_lock(&fs_info->chunk_mutex);
-
-	/*
-	 * We checked in the above loop all device extents that were already in
-	 * the device tree. However before we have updated the device's
-	 * total_bytes to the new size, we might have had chunk allocations that
-	 * have not complete yet (new block groups attached to transaction
-	 * handles), and therefore their device extents were not yet in the
-	 * device tree and we missed them in the loop above. So if we have any
-	 * pending chunk using a device extent that overlaps the device range
-	 * that we can not use anymore, commit the current transaction and
-	 * repeat the search on the device tree - this way we guarantee we will
-	 * not have chunks using device extents that end beyond 'new_size'.
-	 */
-	if (!checked_pending_chunks) {
-		u64 start = new_size;
-		u64 len = old_size - new_size;
-
-		if (contains_pending_extent(trans->transaction, device,
-					    &start, len)) {
-			mutex_unlock(&fs_info->chunk_mutex);
-			checked_pending_chunks = true;
-			failed = 0;
-			retried = false;
-			ret = btrfs_commit_transaction(trans);
-			if (ret)
-				goto done;
-			goto again;
-		}
-	}
-
 	btrfs_device_set_disk_total_bytes(device, new_size);
 	if (list_empty(&device->post_commit_list))
 		list_add_tail(&device->post_commit_list,
-- 
2.17.1

