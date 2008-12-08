From: Gabor MICSKO <gabor.micsko@gmail.com>
Subject: No space left on device
Date: Mon, 08 Dec 2008 10:46:25 +0100
Message-ID: <1228729585.6954.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hi,

I have an 80GB external HDD with one btrfs partition. Latest kernel
module and btrfs-progs from "unstable" git repos.

# mount
[...]
/dev/sdb1 on /media/coolermaster type btrfs (rw)

# df -h
[...]
/dev/sdb1              75G   61G   15G  81% /media/coolermaster

It seems like i have 15GB free space on the btrfs formatted partition,
but when i try to create a file of 4GB on the btrfs filesystem i get the
following error:

root@alderaan:/media/coolermaster/tmp# dd if=/dev/zero of=foobar.img
bs=1024 count=4000K
dd: writing `foobar.img': No space left on device
3372894+0 records in
3372893+0 records out
3453842432 bytes (3.5 GB) copied, 321.087 s, 10.8 MB/s

syslog:

Dec  8 10:35:46 alderaan kernel: [30716.434747] device fsid
46489b7e62f254e0-e306291dd7724d8f devid 1 transid 283 /dev/sdb1
Dec  8 10:35:50 alderaan kernel: [30720.457774] space info full 36

Am i missing something (e.g. reserved space for root, etc.) obvious
here?

Thanks,

--
mg


