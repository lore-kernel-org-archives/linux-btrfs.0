Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41117 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752169AbeENLNl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6D80EAEFC
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/9] btrfs-progs: btrfs-corrupt-block: Change -I flag parameter format
Date: Mon, 14 May 2018 14:13:29 +0300
Message-Id: <1526296414-27638-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Presently, if we want to corrupt a particular item we need to call
corrupt block like so:

btrfs-corrupt-block -I -K <objectid,type,offset> -r "numeric rootid"

This is problematic because the -K option not only sets the key to the
item that the -I option should corrupt but it also signals that we
want to corrupt the key itself. This way we cannot really use the
program with the following semantics:

"Corrupt only the item which corresponds to this key but leave the
key intact"

This patch aims to fix this by changing the format of the -I flag. So
if one wants to corrupt only an item (and leave the key intact) they
should use:

  btrfs-corrupt-block -r <numeric rootid> -I <objectid,type,offset>

In addition to this problem, -K doesn't really understand the the "-r"
argument, so when using it in conjunction with -I to corrupt an item,
not part of the root tree, it will always produce an error:

  Couldn't find the key to corrupt

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 39a611d89d55..4cc3528df105 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -116,7 +116,7 @@ static void print_usage(int ret)
 	printf("\t-m   The metadata block to corrupt (must also specify -f for the field to corrupt)\n");
 	printf("\t-K   The key to corrupt in the format <num>,<num>,<num> (must also specify -f for the field)\n");
 	printf("\t-f   The field in the item to corrupt\n");
-	printf("\t-I   An item to corrupt (must also specify the field to corrupt and a root+key for the item)\n");
+	printf("\t-I <u64,u8,u64> Corrupt an item corresponding to the passed key triplet (must also specify the field to corrupt and root for the item)\n");
 	printf("\t-D   Corrupt a dir item, must specify key and field\n");
 	printf("\t-d   Delete this item (must specify -K)\n");
 	printf("\t-r   Operate on this root (only works with -d)\n");
@@ -1165,7 +1165,7 @@ int main(int argc, char **argv)
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "l:c:b:eEkuUi:f:x:m:K:IDdr:C:",
+		c = getopt_long(argc, argv, "l:c:b:eEkuUi:f:x:m:K:I:Ddr:C:",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -1222,6 +1222,7 @@ int main(int argc, char **argv)
 				break;
 			case 'I':
 				corrupt_item = 1;
+				parse_key(&key.objectid, &key.type, &key.offset);
 				break;
 			case 'd':
 				delete = 1;
@@ -1356,6 +1357,7 @@ int main(int argc, char **argv)
 		target = open_root(root->fs_info, root_objectid);
 
 		ret = corrupt_btrfs_item(target, &key, field);
+		goto out_close;
 	}
 	if (delete) {
 		struct btrfs_root *target = root;
-- 
2.7.4

