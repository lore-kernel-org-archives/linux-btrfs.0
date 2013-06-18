Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37465 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3FRDwN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 23:52:13 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so3457620pbc.11
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 20:52:12 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([119.119.225.132])
        by mx.google.com with ESMTPSA id 6sm16261148pbn.45.2013.06.17.20.52.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 17 Jun 2013 20:52:11 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: do not print uuid 0 when printing root item
Date: Tue, 18 Jun 2013 11:52:06 +0800
Message-Id: <1371527526-3691-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
 print-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index aae47a9..c1d8d18 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -355,8 +355,10 @@ static void print_root(struct extent_buffer *leaf, int slot)
 		(unsigned long long)btrfs_root_generation(&root_item));
 
 	if (root_item.generation == root_item.generation_v2) {
-		uuid_unparse(root_item.uuid, uuid_str);
-		printf("\t\tuuid %s\n", uuid_str);
+		if (count_bytes(root_item.uuid, BTRFS_UUID_SIZE, 0) != BTRFS_UUID_SIZE) {
+			uuid_unparse(root_item.uuid, uuid_str);
+			printf("\t\tuuid %s\n", uuid_str);
+		}
 		if (count_bytes(root_item.parent_uuid, BTRFS_UUID_SIZE, 0) != BTRFS_UUID_SIZE) {
 			uuid_unparse(root_item.parent_uuid, uuid_str);
 			printf("\t\tparent_uuid %s\n", uuid_str);
-- 
1.7.11.7

