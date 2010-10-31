From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs-convert fails
Date: 31 Oct 2010 20:26:00 +0100
Message-ID: <BZurfT2T1uB@helmut.hullen.de>
References: <BZurHFYT1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I wrote am 31.10.10 zum Thema btrfs-convert fails:

> I've tried to convert a 12 GByte ext2 partition (nearly full, 280
> MByte free) with btrfs-convert.

> After about 15 minutes (700-MHz-CPU) the system tells

>   ...
>   creating ext2fs image file
>   cleaning up system chunk
>   btrfs-convert: extent-tree.c:2529: btrfs_reserve_extent: Assertion
>      `!(ret)' failed
>   Abgebrochen

Next try: about 11 GByte data, about 690 MByte free: same crash.

> "syslogd" tells

> Oct 31 17:43:16 ElNath kernel: ------------[ cut here ]------------
> Oct 31 17:43:17 ElNath kernel: kernel BUG at fs/btrfs/volumes.c:2831!
> Oct 31 17:43:17 ElNath kernel: invalid opcode: 0000 [#1]
> Oct 31 17:43:17 ElNath kernel: last sysfs file:
> /sys/devices/pci0000:00/0000:00:04.0/0000:08:02.0/0000:09:00.0/class

[etc.]

These syslogd messages come when I try to mount the incompletely  
converted partition.

And then the system needs to be restarted ... mounting doesn't work,  
"halt" or "reboot" doesn't work.

------------------------------------------------

Another experiment: when the partition (about 11.7 GByte) is filled with  
about 9 GByte data, converting works fine.

How much free space needs "btrfs-convert"?

Does it need xx GByte, or does it need yy percent?

Depends this free space on the number of files? I have filled my testing  
partition with *.iso images, 2 to 4 files.

Viele Gruesse!
Helmut
