From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: block discard.
Date: Fri, 08 Aug 2008 15:05:06 +0100
Message-ID: <1218204306.12232.169.camel@pmac.infradead.org>
References: <1218202998.12232.161.camel@pmac.infradead.org>
	 <1218203792.15342.235.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218203792.15342.235.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-08-08 at 09:56 -0400, Chris Mason wrote:
> So you mkfs ; dd large file ; rm large file ; look for discards?
> 
> Try rm large file ; sync ; sync; look for discards

Yeah, I did that. The actual data extent isn't getting removed.

[root@dyn-226 /]# modprobe mtdram total_size=280000
[root@dyn-226 /]# modprobe mtdchar
[root@dyn-226 /]# ftl_format /dev/mtd0
Partition size = 280000 kb, erase unit size = 128 kb, 1 transfer units
Reserved 5%, formatted size = 262765 kb
Erasing all blocks...
+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+++++++*+
Writing erase unit headers...
format successful.
[root@dyn-226 /]# modprobe ftl
[root@dyn-226 /]# ~dwmw2/btrfs-progs-unstable/mkfs.btrfs /dev/ftla
fs created label (null) on /dev/ftla
	nodesize 4096 leafsize 4096 sectorsize 4096 size 256.61MB
Btrfs Btrfs v0.15
[root@dyn-226 /]# mount -tbtrfs /dev/ftla /mnt/spare
[root@dyn-226 /]# cd /mnt/spare
[root@dyn-226 spare]# cp /etc/services .
[root@dyn-226 spare]# sync
[root@dyn-226 spare]# hexdump -C /dev/ftla | grep /etc/services:
00c00000  23 20 2f 65 74 63 2f 73  65 72 76 69 63 65 73 3a  |# /etc/services:|
[root@dyn-226 spare]# dmesg -c > /dev/null
[root@dyn-226 spare]# rm services
[root@dyn-226 spare]# sync
[root@dyn-226 spare]# dmesg
num_bytes 4096, map_length 24576
Discard from stripe 0: 73808-8
FTL erase sector 73808 for 8 sectors
num_bytes 4096, map_length 12288
Discard from stripe 0: 73832-8
FTL erase sector 73832 for 8 sectors
num_bytes 4096, map_length 20480
Discard from stripe 0: 73816-8
FTL erase sector 73816 for 8 sectors
[root@dyn-226 spare]# hexdump -C /dev/ftla | grep /etc/services:
00c00000  23 20 2f 65 74 63 2f 73  65 72 76 69 63 65 73 3a  |# /etc/services:|
[root@dyn-226 spare]# echo $((0xc00000/512))
24576

-- 
dwmw2

