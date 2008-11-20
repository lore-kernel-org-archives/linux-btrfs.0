From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [PATCH] Btrfs image tool
Date: Fri, 21 Nov 2008 01:10:03 +0300
Message-ID: <a4423d670811201410y639b38ffmeef02adbf666a970@mail.gmail.com>
References: <49242951.2060302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, "Chris Mason" <chris.mason@oracle.com>
To: "Yan Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49242951.2060302@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/11/19 Yan Zheng <zheng.yan@oracle.com>:
> Hello,
>
> This patch adds btrfs image tool. The image tool is
> a debugging tool that creates/restores btrfs metadump
> image. Thank you,
>
> Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

gcc -Wp,-MMD,./.btrfs-image.o.d,-MT,btrfs-image.o -Wall
-fno-strict-aliasing -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g
-Werror -Os -c btrfs-image.c
cc1: warnings being treated as errors
btrfs-image.c: In function 'dump_worker':
btrfs-image.c:220: error: passing argument 2 of 'compress2' from
incompatible pointer type
btrfs-image.c: In function 'restore_worker':
btrfs-image.c:599: error: passing argument 2 of 'uncompress' from
incompatible pointer type
make: *** [btrfs-image.o] Error 1
