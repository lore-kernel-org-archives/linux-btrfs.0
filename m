From: Peter Stuge <peter@stuge.se>
Subject: Re: resize ate my root node
Date: Mon, 18 Apr 2011 23:12:49 +0200
Message-ID: <20110418211249.5085.qmail@stuge.se>
References: <20110307174820.5100.qmail@stuge.se> <1299620014-sup-698@think> <20110310062333.13172.qmail@stuge.se> <1299762537-sup-5020@think> <1299763154-sup-2900@think> <20110310134509.13787.qmail@stuge.se> <1299765769-sup-265@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299765769-sup-265@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> > > Which tool and which version of the tool did you use to delete the
> > > partition?
> > 
> > fdisk from util-linux-2.18
> 
> Straight from util-linux, or with distro patches?

Yes a few Gentoo patches, but nothing that seems relevant:

epatch "${FILESDIR}"/${P}-ncursesw.patch
Subject: [PATCH] cfdisk: search for ncursesw/ncurses.h

Deals with building cfdisk, which I did not use. (I used plain fdisk)


epatch "${FILESDIR}"/${P}-slang.patch #326373
Subject: [PATCH] cfdisk: fix --with-slang

Fixes bug in cfdisk --with-slang, which I did not enable.


epatch "${FILESDIR}"/${P}-cfdisk-string-len.patch #328959
Subject: [PATCH] cfdisk: get_string not calculating correct limits

cfdisk string input length limit stuff.


epatch "${FILESDIR}"/${P}-falloc.patch #339432
Subject: [PATCH] fallocate: fix build failure with old linux headers

I built with new linux headers and had no problem during build.


> > > We can't be sure without looking at the mapping tree (which we
> > > don't have),
> > 
> > Could we guess at where it was put?
> 
> Until you do something funky like balance the drive, there's a 1:1
> mapping.  The easy way to guess is to strace btrfsck and see where
> it read.

Basically same as gdb:

open("/dev/sdb2", O_RDONLY|O_LARGEFILE) = 3
pread64(3, "p\23{\335\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\302"..., 2859, 65536) = 2859
pread64(3, "\320rS\23\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\302"..., 2859, 67108864) = 2859
pread64(3, ""..., 2859, 274877906944)   = 0
open("/dev/sdb2", O_RDONLY|O_LARGEFILE) = 5
pread64(5, "p\23{\335\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\302"..., 2859, 65536) = 2859
pread64(5, "\320rS\23\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\302"..., 2859, 67108864) = 2859
pread64(5, ""..., 2859, 274877906944)   = 0
pread64(5, "\353$m<\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\302"..., 4096, 20971520) = 4096
pread64(5, "\275\354\332\225\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\302"..., 4096, 20987904) = 4096
pread64(5, "\253\22#(\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\302"..., 4096, 20983808) = 4096
pread64(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096, 36675878912) = 4096
pread64(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096, 36675878912) = 4096
pread64(5, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096, 36944314368) = 4096
write(2, "btrfsck: disk-io.c:739: open_ctre"..., 79btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
) = 79


I see that I made a mistake copypasting from gdb in the other email.
I didn't think that btrfs-debug-tree actually read at 36675878912 twice.


//Peter
