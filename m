Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752037AbeENLNl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B4F80AEFE
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/9] btrfs-progs: btrfs-corrupt-block: Convert -K flag argument handling to common function
Date: Mon, 14 May 2018 14:13:30 +0300
Message-Id: <1526296414-27638-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is now a common function used to parse btrfs keys triplets so
use that one. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 4cc3528df105..7a5513c455e6 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -114,7 +114,7 @@ static void print_usage(int ret)
 	printf("\t-i   The inode item to corrupt (must also specify the field to corrupt)\n");
 	printf("\t-x   The file extent item to corrupt (must also specify -i for the inode and -f for the field to corrupt)\n");
 	printf("\t-m   The metadata block to corrupt (must also specify -f for the field to corrupt)\n");
-	printf("\t-K   The key to corrupt in the format <num>,<num>,<num> (must also specify -f for the field)\n");
+	printf("\t-K <u64,u8,u64> Corrupt the given key (must also specify -f for the field)\n");
 	printf("\t-f   The field in the item to corrupt\n");
 	printf("\t-I <u64,u8,u64> Corrupt an item corresponding to the passed key triplet (must also specify the field to corrupt and root for the item)\n");
 	printf("\t-D   Corrupt a dir item, must specify key and field\n");
@@ -1129,6 +1129,7 @@ int main(int argc, char **argv)
 	int corrupt_item = 0;
 	int corrupt_di = 0;
 	int delete = 0;
+	int should_corrupt_key = 0;
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
@@ -1207,15 +1208,8 @@ int main(int argc, char **argv)
 				metadata_block = arg_strtou64(optarg);
 				break;
 			case 'K':
-				ret = sscanf(optarg, "%llu,%u,%llu",
-					     &key.objectid,
-					     (unsigned int *)&key.type,
-					     &key.offset);
-				if (ret != 3) {
-					fprintf(stderr, "error reading key "
-						"%d\n", errno);
-					print_usage(1);
-				}
+				should_corrupt_key = 1;
+				parse_key(&key.objectid, &key.type, &key.offset);
 				break;
 			case 'D':
 				corrupt_di = 1;
@@ -1370,7 +1364,7 @@ int main(int argc, char **argv)
 		ret = delete_item(target, &key);
 		goto out_close;
 	}
-	if (key.objectid || key.offset || key.type) {
+	if (should_corrupt_key) {
 		if (*field == 0)
 			print_usage(1);
 		ret = corrupt_key(root, &key, field);
-- 
2.7.4

