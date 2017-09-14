Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36547 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdINW6H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 18:58:07 -0400
Received: by mail-wm0-f68.google.com with SMTP id r136so1325350wmf.3
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Sep 2017 15:58:06 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH] Btrfs: cleanup 'start' subtraction from try uncompressed inline extent
Date: Fri, 15 Sep 2017 01:57:26 +0300
Message-Id: <20170914225726.31218-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Was added in:
  c8b978188c9a0fd3d535c13debd19d522b726f1f
  "Btrfs: Add zlib compression support"
Survive to near time (from 08.10.2008).

Because 'start' checked for zero before branch, so it's
safe to remove that subtraction.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 02ef32149c15..81123408e82e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -570,7 +570,7 @@ static noinline void compress_file_range(struct inode *inode,
 cont:
 	if (start == 0) {
 		/* lets try to make an inline extent */
-		if (ret || total_in < (actual_end - start)) {
+		if (ret || total_in < actual_end) {
 			/* we didn't compress the entire range, try
 			 * to make an uncompressed inline extent.
 			 */
-- 
2.14.1

