From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Sat, 04 Feb 2012 12:40:24 +0100
Message-ID: <82ivv8-dsn.ln1@hurikhan.ath.cx>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:

> Just happened while writing a huge avi file to my usb3 backup disk:
> 
> [356036.596292] ------------[ cut here ]------------
> [356036.596300] kernel BUG at fs/btrfs/inode.c:1588!
[...]
> 
> btrfsck now finds many of these:
> 
> jupiter ~ # btrfsck /dev/sde1
> root 256 inode 12746 errors 400
> root 256 inode 12747 errors 400
> root 256 inode 12748 errors 400
> root 256 inode 12749 errors 400
> root 256 inode 17141 errors 400
> root 256 inode 219966 errors 400
> root 256 inode 224243 errors 400
> root 256 inode 225245 errors 400
> root 256 inode 225354 errors 400
> root 256 inode 290639 errors 2000
> root 256 inode 291751 errors 2000

It looks like the latter isn't a consequence of the former. I found kernel 
commit f70a9a6b9 which is supposed to do something about "inode errors 400":

commit f70a9a6b94af86fca069a7552ab672c31b457786
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Thu Jan 12 19:10:12 2012 -0500
Btrfs: fix btrfsck error 400 when truncating a compressed

It's actually the case for me that rsync writes to the device using mount 
options "compress-force=zlib" and that rsync probably truncates files 
sometimes when using the inplace option.

So that occurence is explained. Can anyone tell how bad it is to have this 
error? May the fs explode at some point or is it just an error I could 
safely ignore for the moment?

And what about the "inode errors 2000"? What's the 2000 standing for?

Thanks,
Kai

