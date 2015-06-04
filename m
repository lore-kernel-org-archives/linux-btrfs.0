Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35315 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbFDCKu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 22:10:50 -0400
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naota@elisp.net>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] btrfs: tweak key advancing condition
Date: Thu,  4 Jun 2015 11:10:12 +0900
Message-Id: <1433383812-17688-1-git-send-email-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The key advancing condition used in copy_to_sk() is loose. It can
advance the key even if it reaches sk->max_*: e.g. when the max key = (512,
1024, -1) and the current key = (512, 1025, 10), it increments the
offset by 1, continues hopeless search from (512, 1025, 11). This issue
make ioctl() to take a lot of time scanning all the leaf a blocks one by
one.

This commit fix the problem using standard way of key comparison:
btrfs_comp_cpu_keys()

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/ioctl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c22c65..07dc01d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1932,6 +1932,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 	u64 found_transid;
 	struct extent_buffer *leaf;
 	struct btrfs_ioctl_search_header sh;
+	struct btrfs_key test;
 	unsigned long item_off;
 	unsigned long item_len;
 	int nritems;
@@ -2015,12 +2016,17 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 	}
 advance_key:
 	ret = 0;
-	if (key->offset < (u64)-1 && key->offset < sk->max_offset)
+	test.objectid = sk->max_objectid;
+	test.type = sk->max_type;
+	test.offset = sk->max_offset;
+	if (btrfs_comp_cpu_keys(key, &test) >= 0)
+		ret = 1;
+	else if (key->offset < (u64)-1)
 		key->offset++;
-	else if (key->type < (u8)-1 && key->type < sk->max_type) {
+	else if (key->type < (u8)-1) {
 		key->offset = 0;
 		key->type++;
-	} else if (key->objectid < (u64)-1 && key->objectid < sk->max_objectid) {
+	} else if (key->objectid < (u64)-1) {
 		key->offset = 0;
 		key->type = 0;
 		key->objectid++;
-- 
2.4.1

