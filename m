Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:55778 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753342AbeGDF2P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 01:28:15 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 227C4AC00A6
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2018 14:28:10 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 333296D6541
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2018 14:28:09 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: doc: Update man 5 btrfs for 4.18
Date: Wed, 4 Jul 2018 14:31:20 +0900
Message-ID: <885cfb4fb56ecbacc60b2d8c05785e3fdc4c6a56.1530681903.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1530681903.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1530681903.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update the information to reflect the status of 4.18

Main Updates:
- Add explanation of improved compression heuristic algorithm
- Add explanation that norecovery == nologreplay
- Add explanation of nossd_spread mount option
- Add explanation of rmdir_subovl feature

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-man5.asciidoc | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index 0529496a..e85b4d91 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -138,8 +138,9 @@ Otherwise some simple heuristics are applied to detect an incompressible file.
 If the first blocks written to a file are not compressible, the whole file is
 permanently marked to skip compression. As this is too simple, the
 'compress-force' is a workaround that will compress most of the files at the
-cost of some wasted CPU cycles on failed attempts. The heuristics of 'compress'
-will improve in the future so this will not be necessary.
+cost of some wasted CPU cycles on failed attempts.
+Since kernel 4.15, heuristic algorithm has been improved by using
+frequency sampling, repeated pattern detection and shannon entropy calculation.
 +
 NOTE: If compression is enabled, 'nodatacow' and 'nodatasum' are disabled.
 
@@ -300,6 +301,7 @@ which will effectively start the inode numbers from the beginning again.
 (default: on, even read-only)
 +
 Enable/disable log replay at mount time. See also 'treelog'.
+Note that 'nologreplay' is the same as 'norecovery'.
 +
 WARNING: currently, the tree log is replayed even with a read-only mount! To
 disable that behaviour, mount also with 'nologreplay'.
@@ -336,7 +338,8 @@ inlined files).
 (since: 4.5, default: off)
 +
 Do not attempt any data recovery at mount time. This will disable 'logreplay'
-and avoids other write operations.
+and avoids other write operations. Note that this option is the same as
+'nologreplay'
 +
 NOTE: The opposite option 'recovery' used to have different meaning but was
 changed for consistency with other filesystems, where 'norecovery' is used for
@@ -388,12 +391,13 @@ chosen, which is 'v1'.
 *ssd*::
 *ssd_spread*::
 *nossd*::
+*nossd_spread*::
 (default: SSD autodetected)
 +
 Options to control SSD allocation schemes.  By default, BTRFS will
 enable or disable SSD optimizations depending on status of a device with
 respect to rotational or non-rotational type. This is determined by the
-contents of '/sys/block/DEV/queue/rotational'). If it is 1, the 'ssd' option is
+contents of '/sys/block/DEV/queue/rotational'). If it is 0, the 'ssd' option is
 turned on.  The option 'nossd' will disable the autodetection.
 +
 The optimizations make use of the absence of the seek penalty that's inherent
@@ -411,7 +415,7 @@ fragmentation. The layout tuning has been kept intact for the option
 The 'ssd_spread' mount option attempts to allocate into bigger and aligned
 chunks of unused space, and may perform better on low-end SSDs.  'ssd_spread'
 implies 'ssd', enabling all other SSD heuristics as well. The option 'nossd'
-will disable all SSD options.
+will disable all SSD options while 'nossd_spread' only disables 'ssd_spread'.
 
 *subvol='path'*::
 Mount subvolume from 'path' rather than the toplevel subvolume. The
@@ -470,7 +474,9 @@ root user can do that.
 NOTE: historically, any user could create a snapshot even if he was not owner
 of the source subvolume, the subvolume deletion has been restricted for that
 reason. The subvolume creation has been restricted but this mount option is
-still required. This is a usability issue and will be addressed in the future.
+still required. This is a usability issue and therefore
+since 4.18, rmdir syscall can delete an empty subvolume just like an ordinary
+directory (See 'rmdir_subvol' feature in 'FILESYSTEM FEATURES').
 
 DEPRECATED MOUNT OPTIONS
 ~~~~~~~~~~~~~~~~~~~~~~~~
@@ -605,12 +611,17 @@ stored as an extent, saves a few percent of metadata if sparse files are used
 +
 the filesystem contains or contained a raid56 profile of block groups
 
+*rmdir_subvol*::
+(since: 4.18)
++
+indicate that rmdir syscall can delete an empty subvolume just like an ordinary
+directory. Note that this feature only depends on the kernel version.
+
 *skinny_metadata*::
 (since: 3.10)
 +
 reduced-size metadata for extent references, saves a few percent of metadata
 
-
 FILESYSTEM LIMITS
 -----------------
 
-- 
2.14.4


