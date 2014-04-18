Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:34799 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRCj5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Apr 2014 22:39:57 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so1150264wes.30
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Apr 2014 19:39:56 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: btrfs/004, fix failure with inlined file extents
Date: Fri, 18 Apr 2014 04:39:46 +0100
Message-Id: <1397792386-18316-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Files that consist of an inline extent, have the corresponding
data in the filesystem btree and not on a dedicated extent. For
such extents filefrag (fiemap) will report a physical location
of 0 for that extent and set the 'inline' flag.

The btrfs inspect-internal logical-resolve command will cause a
lookup in the extent tree for the extent address we give it as
an argument, which fails with errno ENOENT if it is 0.

This error didn't happen always, as the test uses fsstress to
generate a random filesystem, which needed to generate at least
one file that could be inlined (content less than 4018 bytes).

Example, taken from results/btrfs/004.full:

   # filefrag -v /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/de/d1b/dcb/fb1
   Filesystem type is: 9123683e
   File size of /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/de/d1b/dcb/fb1 is 3860 (1 block of 4096 bytes)
    ext:     logical_offset:        physical_offset: length:   expected: flags:
      0:        0..    4095:          0..      4095:   4096:             not_aligned,inline,eof
      1:      280..     344:      35190..     35254:     65:          1: eof
   /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/de/d1b/dcb/fb1: 2 extents found
   after filter: 0#0#0 0#0#0
   # stat -c %i /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/de/d1b/dcb/fb1
   403
   # /home/fdmanana/git/hub/btrfs-progs/btrfs inspect-internal logical-resolve -P 0 /home/fdmanana/btrfs-tests/scratch_1
   ioctl ret=-1, error: No such file or directory

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/004 | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 670e1c2..1d5b816 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -65,9 +65,11 @@ FILEFRAG_FILTER='
 	($ext, $logical, $physical, $length) =
 		(/^\s*(\d+):\s+(\d+)..\s+\d+:\s+(\d+)..\s+\d+:\s+(\d+):/)
 	or next;
+	($flags) = /.*:\s*(\S*)$/;
 	print $physical * $blocksize, "#",
 	      $length * $blocksize, "#",
-	      $logical * $blocksize, " "'
+	      $logical * $blocksize, "#",
+	      $flags, " "'
 
 # this makes filefrag output script readable by using a perl helper.
 # output is one extent per line, with three numbers separated by '#'
@@ -230,16 +232,26 @@ workout()
 			continue;
 		fi
 		for i in $extents; do
-			physical=$i
-			length=$i
-			logical=$i
-			physical=`echo $physical | sed -e 's/#.*//'`
-			length=`echo $length | sed -e 's/[^#]+#//'`
-			length=`echo $length | sed -e 's/#.*//'`
-			logical=`echo $logical | sed -e 's/.*#//'`
-			_btrfs_inspect_check $file $physical $length $logical \
-						$snap_name
-			ret=$?
+			physical=`echo $i | cut -d '#' -f 1`
+			length=`echo $i | cut -d '#' -f 2`
+			logical=`echo $i | cut -d '#' -f 3`
+			flags=`echo $i | cut -d '#' -f 4`
+			# Skip inline extents, otherwise btrfs inspect-internal
+			# logical-resolve will fail (with errno ENOENT), as it
+			# can't find an extent with a start address of 0 in the
+			# extent tree.
+			if [ $physical -eq 0 ]; then
+				echo "$flags" | grep -E '(^|,)inline(,|$)' \
+					> /dev/null
+				ret=$?
+				if [ $ret -ne 0 ]; then
+					echo "Unexpected physical address 0 for non-inline extent, file $file, flags $flags"
+				fi
+			else
+				_btrfs_inspect_check $file $physical $length \
+					$logical $snap_name
+				ret=$?
+			fi
 			if [ $ret -ne 0 ]; then
 				errcnt=`expr $errcnt + 1`
 			fi
-- 
1.9.1

