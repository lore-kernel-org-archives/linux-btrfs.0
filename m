From: Christian Kujau <lists@nerdbynature.de>
Subject: implicit declaration of function 'strndup'
Date: Thu, 22 Apr 2010 00:50:07 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1004220040350.18247@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: zhaolei@cn.fujitsu.com, miaox@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

compiling the latest checkout of btrfs-progs-git, I still get the compiler 
error Miao Xie reported[0] in March, along with a patch:

  cc1: warnings being treated as errors
  btrfs-list.c: In function 'ino_resolve':
  btrfs-list.c:511: warning: implicit declaration of function 'strndup'
  btrfs-list.c:511: warning: incompatible implicit declaration of built-in 
  function 'strndup'
  make: *** [btrfs-list.o] Error 1

I'm on Debian/stable (gcc 4.3.2-1.1, glibc-2.7), the patch from Miao Xie 
resolved this issue. Is there a reason it's not in git yet?

Thanks,
Christian.

[0] https://patchwork.kernel.org/patch/88224/
    http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04610.html
-- 
BOFH excuse #374:

It's the InterNIC's fault.
