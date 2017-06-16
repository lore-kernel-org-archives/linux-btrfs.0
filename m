Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8454 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751578AbdFPBnl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 21:43:41 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs-progs: Fix false alert about EXTENT_DATA shouldn't be hole
Date: Fri, 16 Jun 2017 09:43:22 +0800
Message-ID: <20170616014323.13170-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since incompat feature NO_HOLES still allow us to have explicit hole
file extent, current check is too restrict and will cause false alert
like:

root 5 EXTENT_DATA[257, 0] shouldn't be hole

Fix it by removing the restrict hole file extent check.

Reported-by: Henk Slager <eye1tm@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c052f66e..7bd57677 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4841,11 +4841,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	}
 
 	/* Check EXTENT_DATA hole */
-	if (no_holes && is_hole) {
-		err |= FILE_EXTENT_ERROR;
-		error("root %llu EXTENT_DATA[%llu %llu] shouldn't be hole",
-		      root->objectid, fkey->objectid, fkey->offset);
-	} else if (!no_holes && *end != fkey->offset) {
+	if (!no_holes && *end != fkey->offset) {
 		err |= FILE_EXTENT_ERROR;
 		error("root %llu EXTENT_DATA[%llu %llu] interrupt",
 		      root->objectid, fkey->objectid, fkey->offset);
-- 
2.13.1



