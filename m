Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F3BC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 08:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8FB320820
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 08:17:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8FB320820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbeKVSz6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 13:55:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:52458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727486AbeKVSz6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 13:55:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 958CFAD52;
        Thu, 22 Nov 2018 08:17:35 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     josef@toxicpanda.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove unnecessary code from __btrfs_rebalance
Date:   Thu, 22 Nov 2018 10:17:33 +0200
Message-Id: <20181122081733.26082-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The first step fo the rebalance process, ensuring there is 1mb free on
each device. This number seems rather small. And in fact when talking
to the original authors their opinions were:

"man that's a little bonkers"
"i don't think we even need that code anymore"
"I think it was there to make sure we had room for the blank 1M at the
beginning. I bet it goes all the way back to v0"
"we just don't need any of that tho, i say we just delete it"

Clearly, this piece of code has lost its original intent throughout
the years. It doesn't really bring any real practical benefits to the
relocation process. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Suggested-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/volumes.c | 53 ----------------------------------------------
 1 file changed, 53 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8e36cbb355df..eb9fa8a6429c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3645,17 +3645,11 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
 	struct btrfs_root *chunk_root = fs_info->chunk_root;
-	struct btrfs_root *dev_root = fs_info->dev_root;
-	struct list_head *devices;
-	struct btrfs_device *device;
-	u64 old_size;
-	u64 size_to_free;
 	u64 chunk_type;
 	struct btrfs_chunk *chunk;
 	struct btrfs_path *path = NULL;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	struct btrfs_trans_handle *trans;
 	struct extent_buffer *leaf;
 	int slot;
 	int ret;
@@ -3670,53 +3664,6 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	u32 count_sys = 0;
 	int chunk_reserved = 0;
 
-	/* step one make some room on all the devices */
-	devices = &fs_info->fs_devices->devices;
-	list_for_each_entry(device, devices, dev_list) {
-		old_size = btrfs_device_get_total_bytes(device);
-		size_to_free = div_factor(old_size, 1);
-		size_to_free = min_t(u64, size_to_free, SZ_1M);
-		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
-		    btrfs_device_get_total_bytes(device) -
-		    btrfs_device_get_bytes_used(device) > size_to_free ||
-		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
-			continue;
-
-		ret = btrfs_shrink_device(device, old_size - size_to_free);
-		if (ret == -ENOSPC)
-			break;
-		if (ret) {
-			/* btrfs_shrink_device never returns ret > 0 */
-			WARN_ON(ret > 0);
-			goto error;
-		}
-
-		trans = btrfs_start_transaction(dev_root, 0);
-		if (IS_ERR(trans)) {
-			ret = PTR_ERR(trans);
-			btrfs_info_in_rcu(fs_info,
-		 "resize: unable to start transaction after shrinking device %s (error %d), old size %llu, new size %llu",
-					  rcu_str_deref(device->name), ret,
-					  old_size, old_size - size_to_free);
-			goto error;
-		}
-
-		ret = btrfs_grow_device(trans, device, old_size);
-		if (ret) {
-			btrfs_end_transaction(trans);
-			/* btrfs_grow_device never returns ret > 0 */
-			WARN_ON(ret > 0);
-			btrfs_info_in_rcu(fs_info,
-		 "resize: unable to grow device after shrinking device %s (error %d), old size %llu, new size %llu",
-					  rcu_str_deref(device->name), ret,
-					  old_size, old_size - size_to_free);
-			goto error;
-		}
-
-		btrfs_end_transaction(trans);
-	}
-
-	/* step two, relocate all the chunks */
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-- 
2.17.1

