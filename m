Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:31418 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755075AbaCOMWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 08:22:41 -0400
Date: Sat, 15 Mar 2014 14:22:37 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fsck: fix memory leak and unnecessary call to
 free
Message-ID: <20140315122235.GA9023@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Free already allocated memory to item1_data if malloc fails for
item2_data in swap_values. Seems to be a typo from commit 70749a77.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index d1cafe1..60708d0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2380,7 +2380,7 @@ static int swap_values(struct btrfs_root *root, struct btrfs_path *path,
 			return -ENOMEM;
 		item2_data = malloc(item2_size);
 		if (!item2_data) {
-			free(item2_data);
+			free(item1_data);
 			return -ENOMEM;
 		}
 
-- 
1.8.5.3

