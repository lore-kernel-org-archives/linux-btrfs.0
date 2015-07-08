Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33647 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757828AbbGHDqk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 23:46:40 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t683is7X024535
	for <linux-btrfs@vger.kernel.org>; Wed, 8 Jul 2015 11:44:54 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 2/4] btrfs: Separate scrub_blocked_if_needed() to scrub_pause_on/off()
Date: Wed, 8 Jul 2015 11:44:07 +0800
Message-ID: <c18667e154f9ebcd3d12d268af77b0ce9cd8bfce.1436326244.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1436326244.git.zhaolei@cn.fujitsu.com>
References: <cover.1436326244.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

It can reduce current duplicated code which is similar to
scrub_blocked_if_needed() but can not call it because little
different.
It also used by my next patch which is in same case.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 94db0fa..cbfb8c7 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -332,11 +332,14 @@ static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
 	}
 }
 
-static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
+static void scrub_pause_on(struct btrfs_fs_info *fs_info)
 {
 	atomic_inc(&fs_info->scrubs_paused);
 	wake_up(&fs_info->scrub_pause_wait);
+}
 
+static void scrub_pause_off(struct btrfs_fs_info *fs_info)
+{
 	mutex_lock(&fs_info->scrub_lock);
 	__scrub_blocked_if_needed(fs_info);
 	atomic_dec(&fs_info->scrubs_paused);
@@ -345,6 +348,12 @@ static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
 	wake_up(&fs_info->scrub_pause_wait);
 }
 
+static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
+{
+	scrub_pause_on(fs_info);
+	scrub_pause_off(fs_info);
+}
+
 /*
  * used for workers that require transaction commits (i.e., for the
  * NOCOW case)
-- 
1.8.5.1

