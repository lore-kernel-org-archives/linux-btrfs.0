Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64775 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756359AbbHZOFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 10:05:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7QE58NE026801
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 22:05:08 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/4] btrfs-progs: Fix infinite loop of btrfs subvolumn sync
Date: Wed, 26 Aug 2015 22:03:36 +0800
Message-ID: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can trigger the bug by following operation:
  (no wait between commands 3~5)
  btrfs subvolume create /mnt/btrfs/mysubvol
  btrfs subvolume snapshot /mnt/btrfs/mysubvol /mnt/btrfs/mysubvol_snap
  btrfs subvolume delete /mnt/btrfs/mysubvol_snap
  btrfs subvolume delete /mnt/btrfs/mysubvol
  btrfs subvolume sync /mnt/btrfs
The last command will not exit.

Reason:
  List of "deleted subvolumes" are not currectly set.

  It caused by a typo of value assign, in detail:
  *ids[idx] = sh->offset;
  should be:
  (*ids)[idx] = sh->offset;
  So only first element is set to right memory address.

  If there are multiple "deleted subvolumes", program will
  keep wait.

Above typo also caused some segment fault in my test.

This patch fixed above bug.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-subvolume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 61f08f5..8e8d019 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1207,7 +1207,7 @@ static int enumerate_dead_subvols(int fd, int count, u64 **ids)
 			off += sizeof(*sh);
 
 			if (sh->type == BTRFS_ORPHAN_ITEM_KEY) {
-				*ids[idx] = sh->offset;
+				(*ids)[idx] = sh->offset;
 				idx++;
 				if (idx >= count) {
 					u64 *newids;
-- 
1.8.5.1

