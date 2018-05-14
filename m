Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752259AbeENLNn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EE60CAEBB
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 9/9] btrfs-progs: btrfs-corrupt-block: Fix -D option
Date: Mon, 14 May 2018 14:13:34 +0300
Message-Id: <1526296414-27638-10-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the -D option is essentially defunct since it's the root,
where we are going to corrupt a dir item is always set to the tree
root. Fix this by passing the root from the "-r" option. Aditionally
convert the interface for this option to the new format. So if one
wants to corrupt a dir item in the default fs tree, they should now
invoke:

 btrfs-corrupt-block -r 5 -D <objectid,DIR_ITEM,offset> -f name

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 10a0b2d13b97..37f850b5b239 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -117,7 +117,7 @@ static void print_usage(int ret)
 	printf("\t-K <u64,u8,u64> Corrupt the given key (must also specify -f for the field and optionally -r for the root)\n");
 	printf("\t-f   The field in the item to corrupt\n");
 	printf("\t-I <u64,u8,u64> Corrupt an item corresponding to the passed key triplet (must also specify the field to corrupt and root for the item)\n");
-	printf("\t-D   Corrupt a dir item, must specify key and field\n");
+	printf("\t-D <u64,u8,u64> Corrupt a dir item corresponding to the passed key triplet, must also specify a field\n");
 	printf("\t-d <u64,u8,u64> Delete item corresponding to passed key triplet\n");
 	printf("\t-r   Operate on this root (only works with -d)\n");
 	printf("\t-C   Delete a csum for the specified bytenr.  When used with -b it'll delete that many bytes, otherwise it's just sectorsize\n");
@@ -1165,7 +1165,7 @@ int main(int argc, char **argv)
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "l:c:b:eEkuUi:f:x:m:K:I:Dd:r:C:",
+		c = getopt_long(argc, argv, "l:c:b:eEkuUi:f:x:m:K:I:D:d:r:C:",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -1212,6 +1212,7 @@ int main(int argc, char **argv)
 				break;
 			case 'D':
 				corrupt_di = 1;
+				parse_key(&key.objectid, &key.type, &key.offset);
 				break;
 			case 'I':
 				corrupt_item = 1;
@@ -1338,7 +1339,7 @@ int main(int argc, char **argv)
 	if (corrupt_di) {
 		if (!key.objectid || *field == 0)
 			print_usage(1);
-		ret = corrupt_dir_item(root, &key, field);
+		ret = corrupt_dir_item(target_root, &key, field);
 		goto out_close;
 	}
 	if (csum_bytenr) {
-- 
2.7.4

