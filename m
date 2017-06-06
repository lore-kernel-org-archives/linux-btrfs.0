Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34747 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdFFLl1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 07:41:27 -0400
Received: by mail-wm0-f65.google.com with SMTP id 70so9949368wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 04:41:26 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH v6] Btrfs: compression must free at least one sector size
Date: Tue,  6 Jun 2017 14:41:15 +0300
Message-Id: <20170606114115.21602-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs already skip store of data where compression didn't
free at least one byte. Let's make logic better and make check
that compression free at least one sector size
because in another case it useless to store this data compressed

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
Cc: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe930..7646f46b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -609,11 +609,10 @@ static noinline void compress_file_range(struct inode *inode,
 		/*
 		 * one last check to make sure the compression is really a
 		 * win, compare the page count read with the blocks on disk
+		 * compression must free at least one sector size
 		 */
 		total_in = ALIGN(total_in, PAGE_SIZE);
-		if (total_compressed >= total_in) {
-			will_compress = 0;
-		} else {
+		if (total_compressed + blocksize <= total_in) {
 			num_bytes = total_in;
 			*num_added += 1;

--
2.13.0
