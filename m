From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/3][RESEND] xfstests: fix 251's cp -axT problem
Date: Mon, 6 Feb 2012 16:27:47 +0800
Message-ID: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <xfs@oss.sgi.com>, <hch@infradead.org>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When I ran xfstests, 251 got failed cause I use a symlink and
"cp -axT" did not work as wish:
cp: cannot overwrite directory `/mnt/scratch/1' with non-directory

With this patch, 251 has passed.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 251 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/251 b/251
index fa3d74a..b54e4c3 100755
--- a/251
+++ b/251
@@ -130,7 +130,7 @@ function run_process() {
 
 		# Copy content -> partition.
 		mkdir $SCRATCH_MNT/$p
-		cp -axT $content $SCRATCH_MNT/$p
+		cp -axT $content/ $SCRATCH_MNT/$p/
 		export chpid=$! && wait $chpid &> /dev/null
 
 		check_sums
-- 
1.6.5.2

