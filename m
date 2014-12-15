Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61107 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaLOUCl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 15:02:41 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so11633548wib.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 12:02:40 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/7] Add strdup in btrfs_add_to_fsid() to track the device path.
Date: Mon, 15 Dec 2014 21:02:57 +0100
Message-Id: <1418673780-22000-5-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
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

