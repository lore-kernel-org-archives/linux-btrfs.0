Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23263 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaATIpw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 03:45:52 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0K8jWnX008674
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 16:45:34 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix double free when deleting subvolumes
Date: Mon, 20 Jan 2014 16:44:21 +0800
Message-Id: <1390207461-27997-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
	# mkfs.btrfs -f /dev/sda8
	# mount /dev/sda8 /mnt
	# btrfs sub create /mnt/a
	# touch /mnt/b
	# btrfs sub create /mnt/c
	# btrfs sub delete /mnt/*

Above steps will trigger following abortion:

ERROR: 'b' is not a subvolume
*** Error in `btrfs': double free or corruption (out): 0x0000000002116060 ***
======= Backtrace: =========
/lib64/libc.so.6[0x3fa467cef8]
/lib64/libc.so.6(closedir+0xd)[0x3fa46b846d]
btrfs[0x43e608]
btrfs[0x40622f]
btrfs[0x403d19]
btrfs[0x4062c6]
btrfs[0x403f68]

We try to fix it by resetting @fd && @dirstream before trying next
subvolume deletion.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-subvolume.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 38229d0..61a78fa 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -354,6 +354,9 @@ out:
 	cnt++;
 	if (cnt < argc) {
 		close_file_or_dir(fd, dirstream);
+		/* avoid double free */
+		fd = -1;
+		dirstream = NULL;
 		goto again;
 	}
 
-- 
1.8.3.1

