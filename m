From: Christian Kujau <christian.kujau@oracle.com>
Subject: Re: implicit declaration of function 'strndup'
Date: Fri, 14 May 2010 06:27:28 -0700
Message-ID: <4BED4FC0.1000004@oracle.com>
References: <alpine.DEB.2.01.1004220040350.18247@bogon.housecafe.de>
Reply-To: Christian Kujau <lists@nerdbynature.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: zhaolei@cn.fujitsu.com, miaox@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.1004220040350.18247@bogon.housecafe.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've sent this (see below) a while ago, the patch from Miao Xie is from
March even. I still cannot compile btrfs-progs without his fix. Please
include this fix into the repo.

Thanks,
Christian.

Christian Kujau wrote on 2010-04-22 24:50 :
> compiling the latest checkout of btrfs-progs-git, I still get the compiler 
> error Miao Xie reported[0] in March, along with a patch:
> 
>   cc1: warnings being treated as errors
>   btrfs-list.c: In function 'ino_resolve':
>   btrfs-list.c:511: warning: implicit declaration of function 'strndup'
>   btrfs-list.c:511: warning: incompatible implicit declaration of built-in 
>   function 'strndup'
>   make: *** [btrfs-list.o] Error 1
> 
> I'm on Debian/stable (gcc 4.3.2-1.1, glibc-2.7), the patch from Miao Xie 
> resolved this issue. Is there a reason it's not in git yet?
> 
> Thanks,
> Christian.
> 
> [0] https://patchwork.kernel.org/patch/88224/
>     http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04610.html

diff --git a/btrfs-list.c b/btrfs-list.c
index 7741705..9dedb5d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 +#define _GNU_SOURCE
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
diff --git a/btrfs.c b/btrfs.c
index ab5e57f..46314cf 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -14,7 +14,7 @@
  * Boston, MA 021110-1307, USA.
  */
 -
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
