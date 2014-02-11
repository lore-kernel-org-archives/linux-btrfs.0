Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaBKKIl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 05:08:41 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] xfstests: btrfs/004: fix to make test really work
Date: Tue, 11 Feb 2014 18:06:44 +0800
Message-Id: <1392113204-29237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So i was wondering why test 004 could pass my previous wrong
kernel patch while it defenitely should not.

By some debugging, i found here perl script is wrong, we did not
filter out anything and this unit test did not work acutally.so
it came out we will never fail this test.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Changelog v1->v2:
	format perl script to make it more readable(thanks to Dave Chinner)
---
 tests/btrfs/004 | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 14da9f1..1d608db 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -57,11 +57,17 @@ _require_command "/usr/sbin/filefrag"
 
 rm -f $seqres.full
 
-FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
-'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
-'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
-'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
-'$length * $blocksize, "#", $logical * $blocksize, " "'
+FILEFRAG_FILTER='
+	if (/blocks of (\d+) bytes/) {
+		$blocksize = $1;
+		next
+	}
+	($ext, $logical, $physical, $length) =
+		(/^\s*(\d+):\s+(\d+)..\s+\d+:\s+(\d+)..\s+\d+:\s+(\d+):/)
+	or next;
+	print $physical * $blocksize, "#",
+	      $length * $blocksize, "#",
+	      $logical * $blocksize, " "'
 
 # this makes filefrag output script readable by using a perl helper.
 # output is one extent per line, with three numbers separated by '#'
-- 
1.8.3.1

