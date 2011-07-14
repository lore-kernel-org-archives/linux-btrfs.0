From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 15/16] Btrfs: clean up for wait_extent_bit()
Date: Thu, 14 Jul 2011 11:19:27 +0800
Message-ID: <4E1E603F.7040603@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

We can just use cond_resched_lock().

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6c7394f..1959a63 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -658,11 +658,7 @@ again:
 		if (start > end)
 			break;
 
-		if (need_resched()) {
-			spin_unlock(&tree->lock);
-			cond_resched();
-			spin_lock(&tree->lock);
-		}
+		cond_resched_lock(&tree->lock);
 	}
 out:
 	spin_unlock(&tree->lock);
-- 
1.7.3.1
