Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33331 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdE2XSe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 19:18:34 -0400
Received: by mail-wm0-f67.google.com with SMTP id b84so21118087wmh.0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 16:18:33 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v5 2/2] Btrfs: compression must free at least one sector size
Date: Tue, 30 May 2017 02:18:05 +0300
Message-Id: <20170529231805.4797-3-nefelim4ag@gmail.com>
In-Reply-To: <20170529231805.4797-1-nefelim4ag@gmail.com>
References: <20170529231805.4797-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs already skip store of data where compression didn't
free at least one byte. Let's make logic better and make check
that compression free at least one sector size
because in another case it useless to store this data compressed

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe930..2793007b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -609,9 +609,10 @@ static noinline void compress_file_range(struct inode *inode,
 		/*
 		 * one last check to make sure the compression is really a
 		 * win, compare the page count read with the blocks on disk
+		 * compression must free at least one sector size
 		 */
 		total_in = ALIGN(total_in, PAGE_SIZE);
-		if (total_compressed >= total_in) {
+		if (total_compressed + blocksize > total_in) {
 			will_compress = 0;
 		} else {
 			num_bytes = total_in;
--
2.13.0
