From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: Fix a compile fail by strndup in RHEL5 env
Date: Thu, 25 Mar 2010 20:38:48 +0800
Message-ID: <4BAB5958.4020706@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

When we compile btrfs-progs in RHEL5(with default gcc 4.1.2 and glibc-2.5-18),
we can get following error:

cc1: warnings being treated as errors
btrfs-list.c: In function 'ino_resolve':
btrfs-list.c:511: warning: implicit declaration of function 'strndup'
btrfs-list.c:511: warning: incompatible implicit declaration of built-in function 'strndup'
make: *** [btrfs-list.o] Error 1
...
cc1: warnings being treated as errors
btrfs.c: In function 'split_command':
btrfs.c:168: warning: implicit declaration of function 'strndup'
btrfs.c:168: warning: incompatible implicit declaration of built-in function 'strndup'
make: *** [btrfs-list.o] Error 1

We can add _GNU_SOURCE definition according man strndup.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs-list.c |    1 +
 btrfs.c      |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 7741705..9dedb5d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define _GNU_SOURCE
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
diff --git a/btrfs.c b/btrfs.c
index ab5e57f..46314cf 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -14,7 +14,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
-
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-- 
1.6.5.2


