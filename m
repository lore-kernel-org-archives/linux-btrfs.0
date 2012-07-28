Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55269 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2G1WUQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 18:20:16 -0400
Received: by ghrr11 with SMTP id r11so4090963ghr.19
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jul 2012 15:20:15 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: =?UTF-8?q?=5BPATCH=200/1=5D=20Btrfs=3A=20Explicitly=20include=20vmalloc=2Eh=20in=20send=2Ec?=
Date: Sat, 28 Jul 2012 17:20:02 -0500
Message-Id: <1343514003-10942-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When compiling without SMP and generic x86_64, I encountered the
following errors due to vmalloc.h not being implicitly included:

  CC      fs/btrfs/send.o
fs/btrfs/send.c: In function ‘fs_path_free’:
fs/btrfs/send.c:185:4: error: implicit declaration of function ‘vfree’
fs/btrfs/send.c: In function ‘fs_path_ensure_buf’:
fs/btrfs/send.c:215:4: error: implicit declaration of function ‘vmalloc’
fs/btrfs/send.c:215:12: warning: assignment makes pointer from integer without a cast
fs/btrfs/send.c:225:12: warning: assignment makes pointer from integer without a cast
fs/btrfs/send.c:233:13: warning: assignment makes pointer from integer without a cast
fs/btrfs/send.c: In function ‘iterate_dir_item’:
fs/btrfs/send.c:900:10: warning: assignment makes pointer from integer without a cast
fs/btrfs/send.c:909:11: warning: assignment makes pointer from integer without a cast
fs/btrfs/send.c: In function ‘btrfs_ioctl_send’:
fs/btrfs/send.c:4462:17: warning: assignment makes pointer from integer without a cast
fs/btrfs/send.c:4468:17: warning: assignment makes pointer from integer without a cast
fs/btrfs/send.c:4474:2: error: implicit declaration of function ‘vzalloc’
fs/btrfs/send.c:4474:20: warning: assignment makes pointer from integer without a cast
fs/btrfs/send.c:4482:21: warning: assignment makes pointer from integer without a cast
make[2]: *** [fs/btrfs/send.o] Error 1
make[1]: *** [fs/btrfs] Error 2 

If it makes sense, please feel free to include this minor change in with
other send/receive fixes.

Mitch Harder (1):
  Btrfs: Explicitly include vmalloc.h in send.c

 fs/btrfs/send.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
1.7.8.6

