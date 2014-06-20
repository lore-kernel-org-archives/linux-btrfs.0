Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:52917 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaFTTwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 15:52:09 -0400
Received: by mail-la0-f51.google.com with SMTP id mc6so2640671lab.24
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jun 2014 12:52:08 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] trivial: fs/btrfs/tree-log.c: Fix closing brace followed by if
Date: Fri, 20 Jun 2014 21:51:43 +0200
Message-Id: <1403293903-17696-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe "else if" was meant, but because of the goto out_unlock, it
doesn't make a difference. Anyway, I chose the "only whitespace" fix.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/btrfs/tree-log.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9e1f2cd..50af2b9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3980,7 +3980,8 @@ again:
 		if (ret < 0) {
 			err = ret;
 			goto out_unlock;
-		} if (ret) {
+		}
+		if (ret) {
 			ins_nr = 0;
 			btrfs_release_path(path);
 			continue;
-- 
1.9.2

