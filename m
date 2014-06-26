Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6366 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753169AbaFZC6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 22:58:30 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5Q2wQoc027087
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 10:58:27 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/6] btrfs-progs: fix btrfs-image old_restore fsck failure
Date: Thu, 26 Jun 2014 10:53:01 +0800
Message-ID: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
	# mkfs.btrfs -f <dev1>
	# btrfs-image <dev1> <image_file>
	# btrfs-image -r -o <image_file> <dev2>
	# btrfs check <dev2>

btrfs check output:
	: read block failed check_tree_block
	: Couldn't read tree root
	: Couldn't open file system

The btrfs-image should not mess with the chunk tree under the old_restore way.

The new restore way was introduced by:
	commit d6f7e3da0dae7b60cb7565f8a47c3b9045c52d1d
	Btrfs-progs: make btrfs-image restore with a valid chunk tree V2
	...
And the following commit enhanced the new restore on the valid chunk tree
building stuff:
	commit ef2a8889ef813ba77061f6a92f4954d047a78932
	Btrfs-progs: make image restore with the original device offsets
	...

But the second commit should not effect the old_restore way since the
old_restore way doesn't try to build a valid chunk tree at all.
---
 btrfs-image.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 02ae5d6..c90bca8 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1668,7 +1668,7 @@ static void *restore_worker(void *data)
 		if (!mdres->fixup_offset) {
 			while (size) {
 				u64 chunk_size = size;
-				if (!mdres->multi_devices)
+				if (!mdres->multi_devices && !mdres->old_restore)
 					bytenr = logical_to_physical(mdres,
 								     async->start + offset,
 								     &chunk_size);
@@ -2282,7 +2282,7 @@ static int __restore_metadump(const char *input, FILE *out, int old_restore,
 		goto failed_cluster;
 	}
 
-	if (!multi_devices) {
+	if (!multi_devices && !old_restore) {
 		ret = build_chunk_tree(&mdrestore, cluster);
 		if (ret)
 			goto out;
-- 
1.8.1.4

