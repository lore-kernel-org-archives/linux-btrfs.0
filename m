Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41129 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbeENLNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AA11FADD2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 8/9] btrfs-progs: btrfs-corrupt-block: Change format of -d option
Date: Mon, 14 May 2018 14:13:33 +0300
Message-Id: <1526296414-27638-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently if we want to delete an item we need to invoke corrupt block
like so:

  btrfs-corrupt-block [-r <numeric id of root>] -K <objectid,type,offset> -d

Instead, this patch converts the format to:

  btrfs-corrupt-block [-r <numeric id of root>] -d <objectid,type,offset>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 74928eae839e..10a0b2d13b97 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -118,7 +118,7 @@ static void print_usage(int ret)
 	printf("\t-f   The field in the item to corrupt\n");
 	printf("\t-I <u64,u8,u64> Corrupt an item corresponding to the passed key triplet (must also specify the field to corrupt and root for the item)\n");
 	printf("\t-D   Corrupt a dir item, must specify key and field\n");
-	printf("\t-d   Delete this item (must specify -K)\n");
+	printf("\t-d <u64,u8,u64> Delete item corresponding to passed key triplet\n");
 	printf("\t-r   Operate on this root (only works with -d)\n");
 	printf("\t-C   Delete a csum for the specified bytenr.  When used with -b it'll delete that many bytes, otherwise it's just sectorsize\n");
 	exit(ret);
@@ -1165,7 +1165,7 @@ int main(int argc, char **argv)
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "l:c:b:eEkuUi:f:x:m:K:I:Ddr:C:",
+		c = getopt_long(argc, argv, "l:c:b:eEkuUi:f:x:m:K:I:Dd:r:C:",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -1219,6 +1219,7 @@ int main(int argc, char **argv)
 				break;
 			case 'd':
 				delete = 1;
+				parse_key(&key.objectid, &key.type, &key.offset);
 				break;
 			case 'r':
 				root_objectid = arg_strtou64(optarg);
-- 
2.7.4

