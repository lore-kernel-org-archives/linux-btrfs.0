Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41126 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752011AbeENLNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 58BECADB4
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/9] btrfs-progs: btrfs-corrupt-block: Add support for handling specific root when using -K option
Date: Mon, 14 May 2018 14:13:32 +0300
Message-Id: <1526296414-27638-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the -K option supports corrupting items only in the default
root (which is the root tree). This makes it impossible to test the
free-space recovery (or any other) code for that matter. Fix it by
using the root corresponding to the one passed in -r (if any).

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 8bbfe1cdb855..74928eae839e 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -114,7 +114,7 @@ static void print_usage(int ret)
 	printf("\t-i   The inode item to corrupt (must also specify the field to corrupt)\n");
 	printf("\t-x   The file extent item to corrupt (must also specify -i for the inode and -f for the field to corrupt)\n");
 	printf("\t-m   The metadata block to corrupt (must also specify -f for the field to corrupt)\n");
-	printf("\t-K <u64,u8,u64> Corrupt the given key (must also specify -f for the field)\n");
+	printf("\t-K <u64,u8,u64> Corrupt the given key (must also specify -f for the field and optionally -r for the root)\n");
 	printf("\t-f   The field in the item to corrupt\n");
 	printf("\t-I <u64,u8,u64> Corrupt an item corresponding to the passed key triplet (must also specify the field to corrupt and root for the item)\n");
 	printf("\t-D   Corrupt a dir item, must specify key and field\n");
@@ -449,7 +449,6 @@ static int corrupt_key(struct btrfs_root *root, struct btrfs_key *key,
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	root = root->fs_info->fs_root;
 	if (corrupt_field == BTRFS_KEY_BAD) {
 		fprintf(stderr, "Invalid field %s\n", field);
 		return -EINVAL;
@@ -1364,7 +1363,8 @@ int main(int argc, char **argv)
 	if (should_corrupt_key) {
 		if (*field == 0)
 			print_usage(1);
-		ret = corrupt_key(root, &key, field);
+
+		ret = corrupt_key(target_root, &key, field);
 		goto out_close;
 	}
 	/*
-- 
2.7.4

