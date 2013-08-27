Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63815 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3H0KvG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 06:51:06 -0400
Received: by mail-lb0-f174.google.com with SMTP id w6so2382405lbh.19
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 03:51:04 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Xavier Bassery <xavier@bartica.org>, idryomov@gmail.com
Subject: [PATCH] Btrfs: stop refusing the relocation of chunk 0
Date: Tue, 27 Aug 2013 13:50:44 +0300
Message-Id: <1377600644-10349-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

AFAICT chunk 0 is no longer special, and so it should be restriped just
like every other chunk.  One reason for this change is us refusing the
relocation can lead to filesystems that can only be mounted ro, and
never rw -- see the bugzilla [1] for details.  The other reason is that
device removal code is already doing this: it will happily relocate
chunk 0 is part of shrinking the device.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=60594

Reported-by: Xavier Bassery <xavier@bartica.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c9a0977..e8325de 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2991,10 +2991,6 @@ again:
 		if (found_key.objectid != key.objectid)
 			break;
 
-		/* chunk zero is special */
-		if (found_key.offset == 0)
-			break;
-
 		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
 
 		if (!counting) {
@@ -3030,6 +3026,8 @@ again:
 			spin_unlock(&fs_info->balance_lock);
 		}
 loop:
+		if (found_key.offset == 0)
+			break;
 		key.offset = found_key.offset - 1;
 	}
 
-- 
1.7.10.4

