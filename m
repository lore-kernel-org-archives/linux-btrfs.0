Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752672AbdLEIjz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:39:55 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1BCA8ACF0
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 08:39:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/7] btrfs-progs: Use list_for_each_entry in write_dev_all_supers
Date: Tue,  5 Dec 2017 10:39:46 +0200
Message-Id: <1512463189-24724-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-1-git-send-email-nborisov@suse.com>
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to use extra variable and 2 macros when we can succintly use 1.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 disk-io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index f5edc4796619..3d8785d5bb37 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1556,7 +1556,6 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 
 int write_all_supers(struct btrfs_fs_info *fs_info)
 {
-	struct list_head *cur;
 	struct list_head *head = &fs_info->fs_devices->devices;
 	struct btrfs_device *dev;
 	struct btrfs_super_block *sb;
@@ -1566,8 +1565,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
 
 	sb = fs_info->super_copy;
 	dev_item = &sb->dev_item;
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (!dev->writeable)
 			continue;
 
-- 
2.7.4

