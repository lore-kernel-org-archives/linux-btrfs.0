Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14211C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 21:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA7C620851
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 21:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544735849;
	bh=hs+t7bRJit1TBjmjORPZPtul+zHfMxUyre0q+V+OsDI=;
	h=From:To:Subject:Date:List-ID:From;
	b=vNdaCgBA5UVbHlQvbtWuWsSknnISXA4s/9jq1A9Ekr66JQz6hk+Du4OvhawFL5s22
	 POpTnDhzODoRU+P5962SoZWvWtt1P9LaWCp2TWAiqGdI8OVA/DhWH1CPHHQsIf+AS9
	 uCVGia2RBMJdujtbmbgyxz18Xoy1qOb9RMiD3EzA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA7C620851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbeLMVR2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbeLMVR2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 16:17:28 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB00C20851
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 21:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544735848;
        bh=hs+t7bRJit1TBjmjORPZPtul+zHfMxUyre0q+V+OsDI=;
        h=From:To:Subject:Date:From;
        b=bUDiPQzNUDfQ0MEpvkeY9GwKh1v5ibjSuzu2WEg1q/T5puVVbO0CYzhlsPJZGkhmW
         /bOsUa8ZhRUAFMml54AQGy0lQIR+NkNKD11vnIPIsBpZWmjhcqdIt3OH1QfGPdtUcj
         7qajc1ICHj564/rb9Rv9OUqSU/08RF1gFYUDnxtU=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: avoid deadlock with memory reclaim due to allocation of devices
Date:   Thu, 13 Dec 2018 21:17:25 +0000
Message-Id: <20181213211725.14832-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Several places allocate a device while holding the device list mutex. This
can result in a deadlock if reclaim happens because the device, and its
flush bio, are allocated using GFP_KERNEL mode (by __alloc_device() which
is used by btrfs_alloc_device()). A transaction commit, which reclaim can
trigger, needs to lock the device list mutex in its critical section, done
at btrfs_update_commit_device_size().

Some of these places are device_list_add(), which ends up being called
through the device scan ioctl, and btrfs_close_one_device(), which ends up
being called through the device remove ioctl.

Since all the places that add elements to the list of resized devices (the
device grow and shrink functions) only lock the chunk mutex before adding
a device to the list, drop the need to acquire the device list mutex from
btrfs_update_commit_device_size(), which is the only other place that uses
this list and it already locks the chunk mutex.

Fixes: 78f2c9e6dbb14 ("btrfs: device add and remove: use GFP_KERNEL")
Fixes: e0ae999414238 ("btrfs: preallocate device flush bio")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 8 ++------
 fs/btrfs/volumes.h | 1 +
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c872adfc939e..74c4ed29e36e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -176,7 +176,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  * chunk_mutex
  * -----------
  * protects chunks, adding or removing during allocation, trim or when a new
- * device is added/removed
+ * device is added/removed, and the list of resized devices at struct
+ * btrfs_fs_info::fs_devices::resized_devices
  *
  * cleaner_mutex
  * -------------
@@ -7298,10 +7299,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *curr, *next;
 
-	if (list_empty(&fs_devices->resized_devices))
-		return;
-
-	mutex_lock(&fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
 	list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
 				 resized_list) {
@@ -7309,7 +7306,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
 		curr->commit_total_bytes = curr->disk_total_bytes;
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
-	mutex_unlock(&fs_devices->device_list_mutex);
 }
 
 /* Must be invoked during the transaction commit */
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index aefce895e994..362574b9c37a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -229,6 +229,7 @@ struct btrfs_fs_devices {
 	struct mutex device_list_mutex;
 	struct list_head devices;
 
+	/* protected by struct btrfs_fs_info::chunk_mutex */
 	struct list_head resized_devices;
 	/* devices not currently being allocated */
 	struct list_head alloc_list;
-- 
2.11.0

