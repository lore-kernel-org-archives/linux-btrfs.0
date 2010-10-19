From: Sage Weil <sage@newdream.net>
Subject: [PATCH 2/3] Btrfs: fix clone ioctl where range is adjacent to extent
Date: Tue, 19 Oct 2010 15:22:11 -0700
Message-ID: <1287526932-28369-3-git-send-email-sage@newdream.net>
References: <1287526932-28369-1-git-send-email-sage@newdream.net>
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1287526932-28369-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Yehuda Sadeh <yehuda@hq.newdream.net>

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
1.7.0.4

