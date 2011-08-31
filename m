From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] Btrfs-progs:  specify label length larger than 255 bytes
 cause mkfs.btrfs buffer overflow
Date: Wed, 31 Aug 2011 12:35:51 +0800
Message-ID: <4E5DBA27.90002@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

While going through the mkfs.c, I noticed there is an issue for label 
length checking, mkfs.btrfs will crashed if the label length exceeding 
255 bytes, it's easy to triggered that out as below:

jeff@pibroch:~/opensource/btrfs-progs$ sudo ./mkfs.btrfs -L `perl -e 
'print "A"x256'` /usr/src/linux-3.0/img0

WARNING! - Btrfs v0.19-35-g1b444cd IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

*** buffer overflow detected ***: ./mkfs.btrfs terminated
======= Backtrace: =========
/lib/i386-linux-gnu/libc.so.6(__fortify_fail+0x50)[0xb7774df0]
/lib/i386-linux-gnu/libc.so.6(+0xe4cca)[0xb7773cca]
/lib/i386-linux-gnu/libc.so.6(__strcpy_chk+0x3f)[0xb777305f]
./mkfs.btrfs[0x805acc4]
./mkfs.btrfs[0x805def6]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xe7)[0xb76a5e37]
./mkfs.btrfs[0x8048ef1]
======= Memory map: ========
......


a tiny patch could fix it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
  mkfs.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2e99b95..1598aae 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -308,9 +308,9 @@ static char *parse_label(char *input)
      int i;
      int len = strlen(input);

-    if (len > BTRFS_LABEL_SIZE) {
+    if (len >= BTRFS_LABEL_SIZE) {
          fprintf(stderr, "Label %s is too long (max %d)\n", input,
-            BTRFS_LABEL_SIZE);
+            BTRFS_LABEL_SIZE - 1);
          exit(1);
      }
      for (i = 0; i < len; i++) {
-- 
1.7.4.1

