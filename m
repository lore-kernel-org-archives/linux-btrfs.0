Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15282 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756438AbdCHCnS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 21:43:18 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>,
        <kilobyte@angband.pl>, <demfloro@demfloro.ru>
Subject: [PATCH v3 3/7] btrfs: Do chunk level degradation check for remount
Date: Wed, 8 Mar 2017 10:41:20 +0800
Message-ID: <20170308024124.16899-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just the same for mount time check, use btrfs_check_rw_degradable() to
check if we are OK to be remounted rw.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index da687dc79cce..1f5772501c92 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1784,9 +1784,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
-		if (fs_info->fs_devices->missing_devices >
-		     fs_info->num_tolerated_disk_barrier_failures &&
-		    !(*flags & MS_RDONLY)) {
+		if (!(*flags & MS_RDONLY) &&
+		    !btrfs_check_rw_degradable(fs_info)) {
 			btrfs_warn(fs_info,
 				"too many missing devices, writeable remount is not allowed");
 			ret = -EACCES;
-- 
2.12.0



