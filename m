Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50130 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaLQUM7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 15:12:59 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so58982wiw.4
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:12:58 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/8] Add strdup in btrfs_add_to_fsid() to track the device path.
Date: Wed, 17 Dec 2014 21:14:08 +0100
Message-Id: <1418847252-14184-5-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When creating a new btrfs_device, copy the path to track it.
This path is then used by mkfs.btrfs to list all devices.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils.c b/utils.c
index dcb4f74..3f50e4d 100644
--- a/utils.c
+++ b/utils.c
@@ -647,6 +647,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->bytes_used = 0;
 	device->total_ios = 0;
 	device->dev_root = root->fs_info->dev_root;
+	device->name = strdup(path);
 
 	ret = btrfs_add_device(trans, root, device);
 	BUG_ON(ret);
-- 
2.1.3

