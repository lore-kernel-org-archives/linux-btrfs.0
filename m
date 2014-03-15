Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:54157 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752864AbaCOLqT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 07:46:19 -0400
Date: Sat, 15 Mar 2014 13:46:15 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: return with -ENOMEM if malloc fails
Message-ID: <20140315114613.GA8420@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Prevent segfault if memory allocation fails for sargs in get_df
(cmds-filesystem.c).

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-filesystem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index c9e27fc..7eb6e9d 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -146,7 +146,7 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 	sargs = malloc(sizeof(struct btrfs_ioctl_space_args) +
 			(count * sizeof(struct btrfs_ioctl_space_info)));
 	if (!sargs)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	sargs->space_slots = count;
 	sargs->total_spaces = 0;
-- 
1.8.5.3

