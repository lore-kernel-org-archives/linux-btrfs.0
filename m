From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix how we set max_size for free space clusters
Date: Fri, 30 Oct 2009 17:12:11 -0400
Message-ID: <20091030211211.GC3940@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes a problem where max_size can be set to 0 even though we
filled the cluster properly.  We set max_size to 0 if we restart the cluster
window, but if the new start entry is big enough to be our new cluster then we
could return with a max_size set to 0, which will mean the next time we try to
allocate from this cluster it will fail.  So set max_extent to the entry's
size.  Tested this on my box and now we actually allocate from the cluster
after we fill it.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5c2caad..cb2849f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1296,7 +1296,7 @@ again:
 			window_start = entry->offset;
 			window_free = entry->bytes;
 			last = entry;
-			max_extent = 0;
+			max_extent = entry->bytes;
 		} else {
 			last = next;
 			window_free += next->bytes;
-- 
1.5.4.3

