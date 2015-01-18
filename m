Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20500 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbbARBxC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Jan 2015 20:53:02 -0500
From: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Drop feature defines from C files, in favour of CFLAGS defines.
Date: Sun, 18 Jan 2015 01:52:58 +0000
Message-Id: <1421545978-19661-1-git-send-email-dimitri.j.ledkov@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

glibc 2.10+ (5+ years old) enables all the desired features:
_XOPEN_SOURCE 700, __XOPEN2K8, POSIX_C_SOURCE, DEFAULT_SOURCE; with a
single _GNU_SOURCE define in the makefile alone. For portability to
other libc implementations (e.g. dietlibc) _XOPEN_SOURCE=700 is also
defined.

This also resolves Debian bug report filed by Michael Tautschnig -
"Inconsistent use of _XOPEN_SOURCE results in conflicting
declarations". Whilst I was not able to reproduce the results, the
reported fact is that _XOPEN_SOURCE set to 500 in one set of files
(e.g. cmds-filesystem.c) generates/defines different struct stat from
other files (cmds-replace.c).

This patch thus cleans up all feature defines, and sets them at a
consistent level.

Bug-Debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=747969
Signed-off-by: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
---
 Makefile              | 2 +-
 btrfs-calc-size.c     | 2 --
 btrfs-convert.c       | 3 ---
 btrfs-corrupt-block.c | 2 --
 btrfs-find-root.c     | 2 --
 btrfs-fragments.c     | 1 -
 btrfs-image.c         | 2 --
 btrfs-list.c          | 1 -
 btrfs-map-logical.c   | 2 --
 btrfs-select-super.c  | 2 --
 btrfs-show-super.c    | 2 --
 btrfs-zero-log.c      | 2 --
 btrfs.c               | 1 -
 btrfstune.c           | 2 --
 chunk-recover.c       | 2 --
 cmds-check.c          | 2 --
 cmds-filesystem.c     | 1 -
 cmds-receive.c        | 5 -----
 cmds-restore.c        | 2 --
 cmds-send.c           | 1 -
 disk-io.c             | 3 ---
 extent_io.c           | 2 --
 mkfs.c                | 3 ---
 send-test.c           | 2 --
 super-recover.c       | 3 ---
 utils-lib.c           | 2 --
 utils.c               | 4 ----
 volumes.c             | 2 --
 28 files changed, 1 insertion(+), 59 deletions(-)

diff --git a/Makefile b/Makefile
index 8b843bb..4d7cb4a 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ export
 CC = gcc
 LN = ln
 AR = ar
-AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fno-strict-aliasing -fPIC
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=700 -D_GNU_SOURCE -fno-strict-aliasing -fPIC
 CFLAGS = -g -O1 -fno-strict-aliasing
 LDFLAGS = -rdynamic
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 501111c..17d048c 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <ctype.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/btrfs-convert.c b/btrfs-convert.c
index bbd19bb..da10ad6 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -16,9 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 600
-#define _GNU_SOURCE 1
-
 #include "kerncompat.h"
 
 #include <sys/ioctl.h>
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index b477e87..6b9dac5 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 6fa61cc..3517107 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index 360f10f..d742f60 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -14,7 +14,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/btrfs-image.c b/btrfs-image.c
index cb17f16..0485c8f 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/btrfs-list.c b/btrfs-list.c
index 50edcf4..3e29cf8 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -16,7 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _GNU_SOURCE
 #include <sys/ioctl.h>
 #include <sys/mount.h>
 #include "ioctl.h"
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 47d1104..c235d44 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 6231d42..063ffa3 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 2b48f44..4afa852 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index 4154175..31e7481 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
diff --git a/btrfs.c b/btrfs.c
index e83349c..2451885 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -14,7 +14,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/btrfstune.c b/btrfstune.c
index 050418a..e175137 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
diff --git a/chunk-recover.c b/chunk-recover.c
index 381b596..89219d2 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -15,8 +15,6 @@
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  * Boston, MA 021110-1307, USA.
  */
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE
 
 #include <stdio.h>
 #include <stdio_ext.h>
diff --git a/cmds-check.c b/cmds-check.c
index f06e029..6741003 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a3cf114..da12ede 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -14,7 +14,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/cmds-receive.c b/cmds-receive.c
index f269ade..983d179 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -16,11 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _GNU_SOURCE
-#define _POSIX_C_SOURCE 200809
-#define _XOPEN_SOURCE 700
-#define _DEFAULT_SOURCE
-
 #include "kerncompat.h"
 
 #include <unistd.h>
diff --git a/cmds-restore.c b/cmds-restore.c
index 859deaf..0bcba92 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -16,8 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
 
 #include "kerncompat.h"
 
diff --git a/cmds-send.c b/cmds-send.c
index 9b32c1f..e59ba50 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -16,7 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _GNU_SOURCE
 
 #include "kerncompat.h"
 
diff --git a/disk-io.c b/disk-io.c
index b853f66..7f03790 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -16,9 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 600
-#define __USE_XOPEN2K
-#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
diff --git a/extent_io.c b/extent_io.c
index 9c982f9..cd0efdd 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -16,8 +16,6 @@
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  * Boston, MA 021110-1307, USA.
  */
-#define _XOPEN_SOURCE 600
-#define __USE_XOPEN2K
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
diff --git a/mkfs.c b/mkfs.c
index 98a1edd..9e63b2e 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -16,9 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE
-
 #include "kerncompat.h"
 
 #include <sys/ioctl.h>
diff --git a/send-test.c b/send-test.c
index 0e804a2..af8229e 100644
--- a/send-test.c
+++ b/send-test.c
@@ -21,8 +21,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _GNU_SOURCE
-
 #include <unistd.h>
 #include <stdint.h>
 #include <dirent.h>
diff --git a/super-recover.c b/super-recover.c
index adb2c44..197fc4b 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -16,9 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
diff --git a/utils-lib.c b/utils-lib.c
index 9d53c6e..79ef35e 100644
--- a/utils-lib.c
+++ b/utils-lib.c
@@ -1,5 +1,3 @@
-#define _GNU_SOURCE
-
 #include "kerncompat.h"
 #include <unistd.h>
 #include <stdlib.h>
diff --git a/utils.c b/utils.c
index 9b08144..a818950 100644
--- a/utils.c
+++ b/utils.c
@@ -17,10 +17,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#define _XOPEN_SOURCE 700
-#define __USE_XOPEN2K8
-#define __XOPEN2K8 /* due to an error in dirent.h, to get dirfd() */
-#define _GNU_SOURCE	/* O_NOATIME */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/volumes.c b/volumes.c
index 5ba5db5..16dbf64 100644
--- a/volumes.c
+++ b/volumes.c
@@ -15,8 +15,6 @@
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  * Boston, MA 021110-1307, USA.
  */
-#define _XOPEN_SOURCE 600
-#define __USE_XOPEN2K
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/types.h>
-- 
2.1.0

