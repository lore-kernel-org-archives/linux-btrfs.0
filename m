Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53218 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaAUXgq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 18:36:46 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so8462845wgh.26
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 15:36:45 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix snprintf usage by send's gen_unique_name
Date: Tue, 21 Jan 2014 23:36:38 +0000
Message-Id: <1390347398-6490-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The buffer size argument passed to snprintf must account for the
trailing null byte added by snprintf, and it returns a value >= then
sizeof(buffer) when the string can't fit in the buffer.

Since our buffer has a size of 64 characters, and the maximum orphan
name we can generate is 63 characters wide, we must pass 64 as the
buffer size to snprintf, and not 63.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 84aed2f..27edc5e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1336,7 +1336,7 @@ static int gen_unique_name(struct send_ctx *sctx,
 		return -ENOMEM;
 
 	while (1) {
-		len = snprintf(tmp, sizeof(tmp) - 1, "o%llu-%llu-%llu",
+		len = snprintf(tmp, sizeof(tmp), "o%llu-%llu-%llu",
 				ino, gen, idx);
 		if (len >= sizeof(tmp)) {
 			/* should really not happen */
-- 
1.7.9.5

