From: Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Fix space checking during fs resize
Date: Wed, 25 Apr 2012 14:20:02 +0800
Message-ID: <1335334802-15469-1-git-send-email-daniel@quora.org>
Cc: Yan Zheng <yanzheng@21cn.com>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix out-of-space checking, addressing a warning and potential resource
leak when resizing the filesystem down while allocating blocks.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
Reviewed-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/relocation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 017281d..cd2b46e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3811,7 +3811,7 @@ restart:
 
 		ret = btrfs_block_rsv_check(rc->extent_root, rc->block_rsv, 5);
 		if (ret < 0) {
-			if (ret != -EAGAIN) {
+			if (ret != -ENOSPC) {
 				err = ret;
 				WARN_ON(1);
 				break;
-- 
1.7.9.5

