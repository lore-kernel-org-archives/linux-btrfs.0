Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49995 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaBJMNN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 07:13:13 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa1so6160241pad.27
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 04:13:12 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] xfstests: btrfs/004: fix to make test really work
Date: Mon, 10 Feb 2014 20:10:56 +0800
Message-Id: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

So i was wandering why test 004 could pass my previous wrong
kernel patch while it defenitely should not.

By some debugging, i found here perl script is wrong, we did not
filter out anything and this unit test did not work acutally.so
it came out we will never fail this test.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/004 | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)
 mode change 100755 => 100644 tests/btrfs/004

diff --git a/tests/btrfs/004 b/tests/btrfs/004
old mode 100755
new mode 100644
index 14da9f1..17a6e34
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -57,10 +57,9 @@ _require_command "/usr/sbin/filefrag"
 
 rm -f $seqres.full
 
-FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
-'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
-'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
-'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
+FILEFRAG_FILTER='if (/blocks of (\d+) bytes/) {$blocksize = $1; next} ($ext, '\
+'$logical, $physical, $length) = (/^\s*(\d+):\s+(\d+)..\s+\d+:'\
+'\s+(\d+)..\s+\d+:\s+(\d+):/) or next; print $physical * $blocksize, "#", '\
 '$length * $blocksize, "#", $logical * $blocksize, " "'
 
 # this makes filefrag output script readable by using a perl helper.
-- 
1.8.4

