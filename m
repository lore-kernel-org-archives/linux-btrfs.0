Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:58084 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaBACFp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 21:05:45 -0500
Received: by mail-we0-f172.google.com with SMTP id p61so288374wes.3
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 18:05:44 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: more tests for test case btrfs/030
Date: Sat,  1 Feb 2014 02:05:32 +0000
Message-Id: <1391220332-22118-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This change adds some new tests for btrfs' incremental send feature.
These are all related with inverting the parent-child relationship
of directories, and cover the cases:

* when the new parent didn't get renamed (just moved)
* when a child file of the former parent gets renamed too

These new cases are fixed by the following btrfs linux kernel patches:

* "Btrfs: more send support for parent/child dir relationship inversion"
* "Btrfs: fix send dealing with file renames and directory moves"

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/030 |   86 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 21 deletions(-)

diff --git a/tests/btrfs/030 b/tests/btrfs/030
index 6678ed8..6b52a0d 100755
--- a/tests/btrfs/030
+++ b/tests/btrfs/030
@@ -73,22 +73,41 @@ mkdir $SCRATCH_MNT/a/b/www
 echo "hey" > $SCRATCH_MNT/a/b/foobar.txt
 mkdir -p $SCRATCH_MNT/a/b/c3/x/y
 
+mkdir -p $SCRATCH_MNT/a/b/foo1/foo2
+echo "hey" > $SCRATCH_MNT/a/b/foo1/foo2/f.txt
+mkdir $SCRATCH_MNT/a/b/foo3
+
+mkdir -p $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4
+echo "ola" > $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4/hello.txt
+
 # Directory tree looks like:
 #
-# .                         (ino 256)
-# |-- a/                    (ino 257)
-#     |-- b/                (ino 258)
-#         |-- c/            (ino 259)
-#         |   |-- file.txt  (ino 260)
-#         |   |-- d/        (ino 261)
+# .                                      (ino 256)
+# |-- a/                                 (ino 257)
+#     |-- b/                             (ino 258)
+#         |-- c/                         (ino 259)
+#         |   |-- file.txt               (ino 260)
+#         |   |-- d/                     (ino 261)
+#         |
+#         |-- c2/                        (ino 262)
+#         |-- www/                       (ino 263)
+#         |-- foobar.txt                 (ino 264)
+#         |
+#         |-- c3/                        (ino 265)
+#         |   |-- x/                     (ino 266)
+#         |       |-- y/                 (ino 267)
+#         |
+#         |-- foo1/                      (ino 268)
+#         |    |---foo2/                 (ino 269)
+#         |         |---f.txt            (ino 270)
 #         |
-#         |-- c2/           (ino 262)
-#         |-- www/          (ino 263)
-#         |-- foobar.txt    (ino 264)
+#         |-- foo3/                      (ino 271)
 #         |
-#         |-- c3/           (ino 265)
-#             |-- x/        (ino 266)
-#                 |-- y/    (ino 267)
+#         |-- bar1/                      (ino 272)
+#              |-- bar2/                 (ino 273)
+#                  |-- bar3/             (ino 274)
+#                      |-- bar4          (ino 275)
+#                           |--hello.txt (ino 276)
 
 run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
     $SCRATCH_MNT/mysnap1
@@ -104,21 +123,46 @@ mv $SCRATCH_MNT/a/b/foobar.txt $SCRATCH_MNT/a/b/c2/y2/x2/qwerty.txt
 ln $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2/Z/file_link.txt
 mv $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2
 
+mv $SCRATCH_MNT/a/b/foo3 $SCRATCH_MNT/a/b/foo1/foo33
+mv $SCRATCH_MNT/a/b/foo1/foo2 $SCRATCH_MNT/a/b/foo1/foo33/foo22
+mv $SCRATCH_MNT/a/b/foo1/foo33/foo22/f.txt \
+    $SCRATCH_MNT/a/b/foo1/foo33/foo22/fff.txt
+
+echo " hello" >> $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4/hello.txt
+mv $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4/hello.txt \
+    $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4/hello2.txt
+mv $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4 $SCRATCH_MNT/a/b/k44
+mv $SCRATCH_MNT/a/b/bar1/bar2/bar3 $SCRATCH_MNT/a/b/k44
+mv $SCRATCH_MNT/a/b/bar1/bar2 $SCRATCH_MNT/a/b/k44/bar3
+mv $SCRATCH_MNT/a/b/bar1 $SCRATCH_MNT/a/b/k44/bar3/bar2/k11
+
 # Directory tree now looks like:
 #
 # .                                         (ino 256)
 # |-- a/                                    (ino 257)
 #     |-- b/                                (ino 258)
 #         |-- c2/                           (ino 262)
-#             |-- d2/                       (ino 261)
-#             |   |-- cc/                   (ino 259)
-#             |        |-- file.txt         (ino 260)
-#             |-- y2/                       (ino 267)
-#                 |-- x2/                   (ino 266)
-#                     |-- qwerty.txt        (ino 264)
-#                     |-- WWW/              (ino 263)
-#                     |-- Z/                (ino 265)
-#                         |-- file_link.txt
+#         |   |-- d2/                       (ino 261)
+#         |   |   |-- cc/                   (ino 259)
+#         |   |
+#         |   |-- y2/                       (ino 267)
+#         |       |-- x2/                   (ino 266)
+#         |           |-- file.txt          (ino 260)
+#         |           |-- qwerty.txt        (ino 264)
+#         |           |-- WWW/              (ino 263)
+#         |           |-- Z/                (ino 265)
+#         |               |-- file_link.txt
+#         |
+#         |-- foo1/                         (ino 268)
+#         |    |---foo33/                   (ino 271)
+#         |          |---foo22/             (ino 269)
+#         |                |---fff.txt      (ino 270)
+#         |
+#         |-- k44/                          (ino 275)
+#              |-- hello2.txt               (ino 276)
+#              |-- bar3/                    (ino 274)
+#                   |-- bar2/               (ino 273)
+#                        |-- k11/           (ino 272)
 
 run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
     $SCRATCH_MNT/mysnap2
-- 
1.7.9.5

