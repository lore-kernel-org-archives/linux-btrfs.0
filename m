Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:47995 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdJWW35 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 18:29:57 -0400
Received: by mail-wm0-f66.google.com with SMTP id t69so12236782wmt.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 15:29:57 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v4] Btrfs: compress_file_range() change page dirty status once
Date: Tue, 24 Oct 2017 01:29:48 +0300
Message-Id: <20171023222948.10648-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to call extent_range_clear_dirty_for_io()
on compression range to prevent application from changing
page content, while pages compressing.

extent_range_clear_dirty_for_io() run on each loop iteration,
"(end - start)" can be much (up to 1024 times) bigger
then compression range (BTRFS_MAX_UNCOMPRESSED).

That produce extra calls to page managment code.

Fix that behaviour by call extent_range_clear_dirty_for_io()
only once.

v1 -> v2:
 - Make that more obviously and more safeprone

v2 -> v3:
 - Rebased on:
   Btrfs: compress_file_range() remove dead variable num_bytes
 - Update change log
 - Add comments

v3 -> v4:
 - Rebased on: kdave for-next
 - To avoid dirty bit clear/set behaviour change
   call clear_bit once, istead of per compression range

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b93fe05a39c7..5816dd3cb6e6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -536,8 +536,10 @@ static noinline void compress_file_range(struct inode *inode,
 		 * If the compression fails for any reason, we set the pages
 		 * dirty again later on.
 		 */
-		extent_range_clear_dirty_for_io(inode, start, end);
-		redirty = 1;
+		if (!redirty) {
+			extent_range_clear_dirty_for_io(inode, start, end);
+			redirty = 1;
+		}

 		/* Compression level is applied here and only here */
 		ret = btrfs_compress_pages(
--
2.14.2
