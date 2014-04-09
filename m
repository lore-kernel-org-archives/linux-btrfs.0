Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:50897 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbaDINis (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 09:38:48 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so2516186wes.11
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 06:38:47 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't access non-existent key when csum tree is empty
Date: Wed,  9 Apr 2014 14:38:34 +0100
Message-Id: <1397050714-14132-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the csum tree is empty, our leaf (path->nodes[0]) has a number
of items equal to 0 and since btrfs_header_nritems() returns an
unsigned integer (and so is our local nritems variable) the following
comparison always evaluates to false:

     if (path->slots[0] >= nritems - 1) {

As the casting rules lead to:

     if ((u32)0 >= (u32)4294967295) {

This makes us access key at slot paths->slots[0] + 1 (1) of the empty leaf
some lines below:

    btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
    if (found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
        found_key.type != BTRFS_EXTENT_CSUM_KEY) {
		found_next = 1;
		goto insert;
    }

So just don't access such non-existent slot and don't set found_next to 1
when the tree is empty. It's very unlikely we'll get a random key with the
objectid and type values above, which is where we could go into trouble.

If nritems is 0, just set found_next to 1 anyway as it will make us insert
a csum item covering our whole extent (or the whole leaf) when the tree is
empty.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/file-item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 9d84658..0721113 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -749,7 +749,7 @@ again:
 		int slot = path->slots[0] + 1;
 		/* we didn't find a csum item, insert one */
 		nritems = btrfs_header_nritems(path->nodes[0]);
-		if (path->slots[0] >= nritems - 1) {
+		if (!nritems || (path->slots[0] >= nritems - 1)) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret == 1)
 				found_next = 1;
-- 
1.7.9.5

