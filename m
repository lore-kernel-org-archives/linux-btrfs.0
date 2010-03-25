From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: Avoid uninitialized variant compile warning
Date: Thu, 25 Mar 2010 20:39:54 +0800
Message-ID: <4BAB599A.2050605@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

When we compile btrfs-progs in RHEL5(with default gcc version 4.1.2 20070626),
we can get following error:

cc1: warnings being treated as errors
btrfs-list.c: In function 'find_updated_files':
btrfs-list.c:668: warning: 'disk_offset' may be used uninitialized in this function
btrfs-list.c:667: warning: 'disk_start' may be used uninitialized in this function
btrfs-list.c:666: warning: 'len' may be used uninitialized in this function
make: *** [btrfs-list.o] Error 1

These varient are always initialized except inconsistent data in file system.
We can set initial value for these variant for this situation.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs-list.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 9dedb5d..112bed2 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -663,9 +663,9 @@ static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
 			    char **cache_dir_name, u64 *cache_ino,
 			    char **cache_full_name)
 {
-	u64 len;
-	u64 disk_start;
-	u64 disk_offset;
+	u64 len = 0;
+	u64 disk_start = 0;
+	u64 disk_offset = 0;
 	u8 type;
 	int compressed = 0;
 	int flags = 0;
-- 
1.6.5.2


