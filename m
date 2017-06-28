Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3961 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751541AbdF1Fnq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 01:43:46 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: <ahferroin7@gmail.com>, <kilobyte@angband.pl>, <demfloro@demfloro.ru>
Subject: [PATCH v4 3/6] btrfs: Do chunk level degradation check for remount
Date: Wed, 28 Jun 2017 13:43:32 +0800
Message-ID: <20170628054335.18806-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just the same for mount time check, use btrfs_check_rw_degradable() to
check if we are OK to be remounted rw.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 74e47794e63f..03fa52008404 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1781,8 +1781,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
-		if (fs_info->fs_devices->missing_devices >
-		     fs_info->num_tolerated_disk_barrier_failures) {
+		if (!btrfs_check_rw_degradable(fs_info)) {
 			btrfs_warn(fs_info,
 				"too many missing devices, writeable remount is not allowed");
 			ret = -EACCES;
-- 
2.13.1



