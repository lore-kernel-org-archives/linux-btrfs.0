Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42112 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaDRCih (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Apr 2014 22:38:37 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so251551wiv.3
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Apr 2014 19:38:36 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: btrfs/004, fix filefrag filter for files with 1 block only
Date: Fri, 18 Apr 2014 04:34:23 +0100
Message-Id: <1397792063-3660-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the file consists of a single block, then filefrag mentions
'1 block of ...', and the filter expected 'blocks of ...'.

Example:

$ echo qwerty > foobar
$ filefrag -v foobar
Filesystem type is: ef53
File size of foobar is 7 (1 block of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:          0..         0:      1:             unknown,delalloc,eof
foobar: 1 extent found

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/004 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 211d8bc..670e1c2 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -58,7 +58,7 @@ _require_command "/usr/sbin/filefrag"
 rm -f $seqres.full
 
 FILEFRAG_FILTER='
-	if (/blocks of (\d+) bytes/) {
+	if (/blocks? of (\d+) bytes/) {
 		$blocksize = $1;
 		next
 	}
-- 
1.9.1

