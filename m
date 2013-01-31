Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:46510 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754379Ab3AaAGk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:06:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/11] btrfs: list_entry can't return NULL
Date: Wed, 30 Jan 2013 18:54:53 -0600
Message-Id: <1359593702-53056-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to test the result, we can't get a
null pointer from list_entry()

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a8f652d..d89da40 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3823,8 +3823,6 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 	while (!list_empty(&list)) {
 		t = list_entry(list.next, struct btrfs_transaction, list);
-		if (!t)
-			break;
 
 		btrfs_destroy_ordered_operations(root);
 
-- 
1.7.1

