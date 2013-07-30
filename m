Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58592 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3G3ROU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 13:14:20 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4AE437C0691
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 11:14:20 -0600 (MDT)
Date: Tue, 30 Jul 2013 13:13:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Thorsten Glaser <tg@mirbsd.de>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        <linux-btrfs@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide (was: Re: Linux 3.10 problem reports (yes,
 plural))
Message-ID: <20130730171329.GF24583@localhost.localdomain>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 30, 2013 at 11:07:30AM +0200, Geert Uytterhoeven wrote:
> On Tue, 30 Jul 2013, Thorsten Glaser wrote:
> > NEW problem: btrfs doesn’t work at all. I had to reboot my
> > buildd into 3.2 using echo s/u/s/o >/proc/sysrq-trigger as
> > the attempt to mount it left the system hanging there.
> 
> > [    0.000000] Linux version 3.10-1-m68k (debian-kernel@lists.debian.org) (gcc version 4.8.1 (Debian 4.8.1-7+m68k.1) ) #1 Debian 3.10.3-1 (2013-07-27)
> 
> > [    6.720000] bio: create slab <bio-1> at 1
> > [    6.740000] Btrfs loaded
> > [    6.830000] device label ara5-butter devid 1 transid 376178 /dev/nfhd8p3
> > [    7.150000] EXT4-fs (nfhd8p1): mounted filesystem with ordered data mode. Opts: (null)
> > [   14.520000] udevd[228]: starting version 175
> > [   17.820000] device label ara5-butter devid 1 transid 376178 /dev/nfhd8p3
> > [   20.850000] Adding 3670012k swap on /dev/nfhd8p2.  Priority:-1 extents:1 across:3670012k
> > [   21.380000] EXT4-fs (nfhd8p1): re-mounted. Opts: (null)
> > [   31.300000] EXT4-fs (nfhd8p1): re-mounted. Opts: errors=remount-ro
> > [   38.460000] device label ara5-butter devid 1 transid 376178 /dev/nfhd8p3
> > [   38.530000] btrfs: setting nodatacow, compression disabled
> > [   38.540000] btrfs: enabling auto recovery
> > [   38.570000] btrfs: disk space caching is enabled
> > [   38.600000] *** ZERO DIVIDE ***   FORMAT=2
> > [   38.630000] Current process id is 722
> > [   38.660000] BAD KERNEL TRAP: 00000000
> > [   38.680000] Modules linked in: evdev mac_hid ext4 crc16 jbd2 mbcache btrfs xor lzo_compress zlib_deflate raid6_pq crc32c libcrc32c
> > [   38.730000] PC: [<319535b2>] __btrfs_map_block+0x11c/0x119a [btrfs]
> 
> Woops, adding the btrfs devs to CC.
> 

Can you gdb btrfs.ko and do 

list *(__btrfs_map_block+0x11c)

so I can see where this is?  I've not seen this yet, just so I'm clear this is
blowing up because we're doing

blah / 0

right?  I've looked at all the places we do divides in this function and it
doesn't look like we're doing this anywhere but I could be blind.  Thanks,

Josef
