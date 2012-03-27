From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 08/10] Btrfs: update to the right index of defragment
Date: Tue, 27 Mar 2012 14:44:36 +0800
Message-ID: <1332830678-3992-9-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

When we use autodefrag, we forget to update the index which indicates
the last page we've dirty.  And we'll set dirty flags on a same set of
pages again and again.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7a6d15c..e3cb770 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1172,6 +1172,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			if (newer_off == (u64)-1)
 				break;
 
+			if (ret > 0)
+				i += ret;
+
 			newer_off = max(newer_off + 1,
 					(u64)i << PAGE_CACHE_SHIFT);
 
-- 
1.6.5.2

