Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:50728 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254AbaDRXOQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 19:14:16 -0400
Date: Sat, 19 Apr 2014 02:14:14 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs-progs: receive: remove return type of
 close_inode_for_write
Message-ID: <20140418231413.GA1885@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"close_inode_for_write" always returns 0, so just remove its return
value and remove dead checking in caller.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-receive.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 7a23823..39309f2 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -612,19 +612,14 @@ out:
 	return ret;
 }
 
-static int close_inode_for_write(struct btrfs_receive *r)
+static void close_inode_for_write(struct btrfs_receive *r)
 {
-	int ret = 0;
-
 	if(r->write_fd == -1)
-		goto out;
+		return;
 
 	close(r->write_fd);
 	r->write_fd = -1;
 	r->write_path[0] = 0;
-
-out:
-	return ret;
 }
 
 static int process_write(const char *path, const void *data, u64 offset,
@@ -1017,9 +1012,7 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 		if (ret)
 			end = 1;
 
-		ret = close_inode_for_write(r);
-		if (ret < 0)
-			goto out;
+		close_inode_for_write(r);
 		ret = finish_subvol(r);
 		if (ret < 0)
 			goto out;
-- 
1.8.5.3

