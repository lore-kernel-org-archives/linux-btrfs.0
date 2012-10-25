Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52296 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2JYC7b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 22:59:31 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1670748iea.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 19:59:30 -0700 (PDT)
Message-ID: <5088AB08.9080902@gmail.com>
Date: Thu, 25 Oct 2012 10:59:20 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: avoid memory leak in find_and_setup_log_root
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In find_and_setup_log_root, the malloced log_root would be leaked
if we have bytenr = 0, which would happen at our mkfs stage.

Move the memory allocation after the bytenr check, and add allocation
failure check.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 disk-io.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 0395205..3a80284 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -456,11 +456,15 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 {
 	u32 blocksize;
 	u64 blocknr = btrfs_super_log_root(disk_super);
-	struct btrfs_root *log_root = malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *log_root = NULL;

 	if (blocknr == 0)
 		return 0;

+	log_root = malloc(sizeof(struct btrfs_root));
+	if (!log_root)
+		return -ENOMEM;
+
 	blocksize = btrfs_level_size(tree_root,
 			     btrfs_super_log_root_level(disk_super));

-- 
1.7.5.4

