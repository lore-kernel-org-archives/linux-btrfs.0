Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:46651 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751760Ab3AaAGi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:06:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/11] btrfs: remove unused "item" in btrfs_insert_delayed_item()
Date: Wed, 30 Jan 2013 18:54:59 -0600
Message-Id: <1359593702-53056-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"item" was set but never used in this function.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/delayed-inode.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 3483603..092c680 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -875,7 +875,6 @@ static int btrfs_insert_delayed_item(struct btrfs_trans_handle *trans,
 				     struct btrfs_delayed_item *delayed_item)
 {
 	struct extent_buffer *leaf;
-	struct btrfs_item *item;
 	char *ptr;
 	int ret;
 
@@ -886,7 +885,6 @@ static int btrfs_insert_delayed_item(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 
-	item = btrfs_item_nr(leaf, path->slots[0]);
 	ptr = btrfs_item_ptr(leaf, path->slots[0], char);
 
 	write_extent_buffer(leaf, delayed_item->data, (unsigned long)ptr,
-- 
1.7.1

