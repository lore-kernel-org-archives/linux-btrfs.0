Return-Path: <SRS0=hMu+=QD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0565C282C0
	for <linux-btrfs@archiver.kernel.org>; Sun, 27 Jan 2019 04:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AABF62148D
	for <linux-btrfs@archiver.kernel.org>; Sun, 27 Jan 2019 04:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfA0E6Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 26 Jan 2019 23:58:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48840 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfA0E6Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Jan 2019 23:58:16 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.91 #2 (Red Hat Linux))
        id 1gncW8-00041p-9X; Sun, 27 Jan 2019 04:58:05 +0000
Date:   Sun, 27 Jan 2019 04:58:00 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: oops in device_list_add()
Message-ID: <20190127045755.GH2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

	alloc_fs_devices() can return ERR_PTR(-ENOMEM), so
dereferencing its result before the check for IS_ERR() is
a bad idea...

Fixes: d1a63002829a4
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 85149f27644d..72adc5643bde 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -955,11 +955,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		else
 			fs_devices = alloc_fs_devices(disk_super->fsid, NULL);
 
-		fs_devices->fsid_change = fsid_change_in_progress;
-
 		if (IS_ERR(fs_devices))
 			return ERR_CAST(fs_devices);
 
+		fs_devices->fsid_change = fsid_change_in_progress;
+
 		mutex_lock(&fs_devices->device_list_mutex);
 		list_add(&fs_devices->fs_list, &fs_uuids);
 
