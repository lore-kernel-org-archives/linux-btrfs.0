Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933910AbdGLIj0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 04:39:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CAB1AAAB9
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 08:39:24 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Check if tgt_device is not null
Date: Wed, 12 Jul 2017 11:39:22 +0300
Message-Id: <1499848762-24234-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_err_in_rcu indiscriminately dereferences tgt_device to access its
->name member in an error path. However, couple of lines below there is code
which checks whether tgt_device is not NULL. Let's be consistent and check if
the tgt_device is NULL before dereferencing it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/dev-replace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index bee3edeea7a3..e2a16cb8f7f3 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -541,7 +541,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				 src_device->missing ? "<missing disk>" :
 				 rcu_str_deref(src_device->name),
 				 src_device->devid,
-				 rcu_str_deref(tgt_device->name), scrub_ret);
+				 tgt_device ? rcu_str_deref(tgt_device->name) :
+				 "<missing disk>", scrub_ret);
 		btrfs_dev_replace_unlock(dev_replace, 1);
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-- 
2.7.4

