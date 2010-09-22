From: Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH] Btrfs: fix clone ioctl where range is adjacent to extent
Date: Tue, 21 Sep 2010 17:02:34 -0700
Message-ID: <5a425001257ed650ef26779a9ce419860fc163e9.1285113216.git.yehuda@hq.newdream.net>
References: <630121e7c17b2804bc24194e13469d5e58d51174.1285113216.git.yehuda@hq.newdream.net>
Cc: sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <630121e7c17b2804bc24194e13469d5e58d51174.1285113216.git.yehuda@hq.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

We had an edge case issue where the requested range was just
following an existing extent. Instead of skipping to the next
extent, we used the previous one which lead to having zero
sized extents.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3471b22..f4a3dde 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1607,7 +1607,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			}
 			btrfs_release_path(root, path);
 
-			if (key.offset + datal < off ||
+			if (key.offset + datal <= off ||
 			    key.offset >= off+len)
 				goto next;
 
-- 
1.5.6.5

