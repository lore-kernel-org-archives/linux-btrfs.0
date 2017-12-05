Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33319 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752609AbdLEIjy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:39:54 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C58F2ACE6
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 08:39:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/7] btrfs-progs: Remove recover_get_good_super
Date: Tue,  5 Dec 2017 10:39:45 +0200
Message-Id: <1512463189-24724-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-1-git-send-email-nborisov@suse.com>
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently getting the good super really consists of just getting the first entry
on the linked list, since it's the one with the highest transid. So remove
the function and just use list_first_entry directly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 super-recover.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/super-recover.c b/super-recover.c
index 6a13d81b0b29..e12513100f17 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -177,15 +177,6 @@ static int read_fs_supers(struct btrfs_recover_superblock *recover)
 	return 0;
 }
 
-static struct super_block_record *recover_get_good_super(
-				struct btrfs_recover_superblock *recover)
-{
-	struct super_block_record *record;
-	record = list_entry(recover->good_supers.next,
-				struct super_block_record, list);
-	return record;
-}
-
 static void print_super_info(struct super_block_record *record)
 {
 	printf("\t\tdevice name = %s\n", record->device_name);
@@ -280,7 +271,9 @@ int btrfs_recover_superblocks(const char *dname,
 			goto no_recover;
 		}
 	}
-	record = recover_get_good_super(&recover);
+	record = list_first_entry(&recover.good_supers,
+				  struct super_block_record, list);
+
 	root = open_ctree(record->device_name, record->bytenr,
 			  OPEN_CTREE_RECOVER_SUPER | OPEN_CTREE_WRITES);
 	if (!root) {
-- 
2.7.4

