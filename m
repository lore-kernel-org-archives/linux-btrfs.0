From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] Btrfs-progs: man: fix typo
Date: Wed, 22 Feb 2012 13:47:27 +0100
Message-ID: <1329914848-5698-1-git-send-email-andrea.gelmini@gelma.net>
Cc: lizf@cn.fujitsu.com, Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

s/eveery/every/

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 man/btrfs.8.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 8e3b2f5..e2792c9 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -137,7 +137,7 @@ is similar to \fBsubvolume list\fR command.
 Defragment file data and/or directory metadata. To defragment all files in a
 directory you have to specify each one on its own or use your shell wildcards.
 
-The start position and the number of bytes to deframention can be specified by \fIstart\fR and \fIlen\fR. Any extent bigger than \fIthresh\fR will be considered already defragged. Use 0 to take the kernel default, and use 1 to say eveery single extent must be rewritten. You can also turn on compression in defragment operations.
+The start position and the number of bytes to deframention can be specified by \fIstart\fR and \fIlen\fR. Any extent bigger than \fIthresh\fR will be considered already defragged. Use 0 to take the kernel default, and use 1 to say every single extent must be rewritten. You can also turn on compression in defragment operations.
 
 \fB-v\fP be verbose
 
-- 
1.7.9.1.275.gd59d2

