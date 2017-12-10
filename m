Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38638 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbdLJBOM (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Sat, 9 Dec 2017 20:14:12 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, hadrian2002@googlemail.com
Subject: [PATCH] btrfs: disk-io: Allow 0 as tree block bytenr
Date: Sun, 10 Dec 2017 09:14:03 +0800
Message-Id: <20171210011403.14452-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some btrfs created by old mkfs.btrfs can have tree block with 0 bytenr.

In fact, any aligned bytenr is allowed in btrfs, and in some case it can
cause problem if the valid tree block at 0 bytenr can't be read.

Currently, the superblock checker and bytenr alignment checker can
already handle the case so there is no need to check bytenr < sectorsize
in read_tree_block().

Reported-by: Benjamin Beichler <hadrian2002@googlemail.com>
Fixes: 6cca2ea9bea9 ("btrfs-progs: more sanity checks in read_tree_block_fs_info")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index f5edc4796619..7f13f05ac600 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -318,7 +318,7 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 	 * Such unaligned tree block will free overlapping extent buffer,
 	 * causing use-after-free bugs for fuzzed images.
 	 */
-	if (bytenr < sectorsize || !IS_ALIGNED(bytenr, sectorsize)) {
+	if (!IS_ALIGNED(bytenr, sectorsize)) {
 		error("tree block bytenr %llu is not aligned to sectorsize %u",
 		      bytenr, sectorsize);
 		return ERR_PTR(-EIO);
-- 
2.15.1

