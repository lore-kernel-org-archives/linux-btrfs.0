Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:4071 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759541Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/17] btrfs-progs: free memory before error exit in read_whole_eb
Date: Mon, 25 Feb 2013 16:54:42 -0600
Message-Id: <1361832890-40921-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Free the memory allocated to "multi" before the error
exit in read_whole_eb().  Set it to NULL after we free
it in the loop to avoid any potential double-free.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 disk-io.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 5aa9aa3..897d0cf 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -198,17 +198,21 @@ static int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, i
 				      mirror, NULL);
 		if (ret) {
 			printk("Couldn't map the block %Lu\n", eb->start + offset);
+			kfree(multi);
 			return -EIO;
 		}
 		device = multi->stripes[0].dev;
 
-		if (device->fd == 0)
+		if (device->fd == 0) {
+			kfree(multi);
 			return -EIO;
+		}
 
 		eb->fd = device->fd;
 		device->total_ios++;
 		eb->dev_bytenr = multi->stripes[0].physical;
 		kfree(multi);
+		multi = NULL;
 
 		if (read_len > bytes_left)
 			read_len = bytes_left;
-- 
1.7.1

