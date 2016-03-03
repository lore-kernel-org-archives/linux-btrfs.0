Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49895 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbcCCTyA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 14:54:00 -0500
Subject: Re: Stray 4k extents with slow buffered writes
To: bo.li.liu@oracle.com
References: <56D82DED.5030107@googlemail.com>
 <20160303183322.GA16959@localhost.localdomain>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56D89655.70504@googlemail.com>
Date: Thu, 3 Mar 2016 20:53:57 +0100
MIME-Version: 1.0
In-Reply-To: <20160303183322.GA16959@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/03/16 19:33, Liu Bo wrote:
> On Thu, Mar 03, 2016 at 01:28:29PM +0100, Holger Hoffstätte wrote:
(..)
>> I've noticed that slow slow buffered writes create a huge number of
>> unnecessary 4k sized extents. At first I wrote it off as odd buffering
>> behaviour of the application (a download manager), but it can be easily
>> reproduced. For example:
> 
> On a new fresh btrfs, I cannot reproduce the fragmented layout with "wget --limit-rate=1m",

For better effect lower the bandwidth, 100k or so.

> [root@10-11-17-236 btrfs]# filefrag -v -b linux-4.5-rc6.tar.xz             
> Filesystem type is: 9123683e
> File size of linux-4.5-rc6.tar.xz is 88362576 (86292 blocks, blocksize
> 1024)
>  ext logical physical expected length flags
>    0       0   143744            5264 
>    1    5264   149008           35884 
>    2   41148   220848   184892      4

So you also have one, after ~35 MB. See below.

>    3   41152   184896   220852  35948 
>    4   77100   220852   220844   9192 eof
> linux-4.5-rc6.tar.xz: 4 extents found

No sync? filefrag is a notorious liar. ;)

It changes things because you likely have a higher value set for
vm/dirty_expire_centisecs or dirty_bytes explicitly configured; I have
it set to 1000 (10s) to prevent large writebacks from choking everything.
The default is probably still 30s aka 3000.

I understand that I should get smaller extents overall, but not the stray
4k sized ones in regular intervals.

> Can you gather your mount options and 'btrfs fi show/df' output?

I can reproduce that on another machine/drive where it also initially
didn't show the 4k extents in a parallel-running filefrag, but did
after a sync (when the extents were written). That was surprising.

Anyway, it's just an external scratch drive..the mount options really
don't matter much:

$mount | grep sdf
/dev/sdf1 on /mnt/usb type btrfs (rw,relatime,space_cache=v2,subvolid=5,subvol=/)

$btrfs fi df /mnt/usb
Data, single: total=4.00GiB, used=3.31GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=1.00GiB, used=4.45MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

$btrfs fi show /mnt/usb
Label: 'Test'  uuid: 1d37a067-5b7d-4dcf-b2c1-7c5745b9c7a5
	Total devices 1 FS bytes used 3.32GiB
	devid    1 size 111.79GiB used 5.03GiB path /dev/sdf1

I then remounted with -ocommit=300 and set dirty_expire_centisecs=10000
(100s). That results in a single large extent, even after sync, so
writeback expiry and commit definitely play a part.

Here is what it looks like when both dirty_expire and commit are set
to very low 5s:

$filefrag -ek linux-4.4.4.tar.bz2
Filesystem type is: 9123683e
File size of linux-4.4.4.tar.bz2 is 105008928 (102548 blocks of 1024 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    5199:  227197920.. 227203119:   5200:            
   1:     5200..    5203:  227169600.. 227169603:      4:  227203120:
   2:     5204..   15407:  227203124.. 227213327:  10204:  227169604:
   3:    15408..   20623:  227213332.. 227218547:   5216:  227213328:
   4:    20624..   20627:  227169604.. 227169607:      4:  227218548:
   5:    20628..   30831:  227218552.. 227228755:  10204:  227169608:
   6:    30832..   36047:  227228760.. 227233975:   5216:  227228756:
   7:    36048..   36051:  227169608.. 227169611:      4:  227233976:
   8:    36052..   41263:  227233980.. 227239191:   5212:  227169612:
   9:    41264..   46479:  227271164.. 227276379:   5216:  227239192:
  10:    46480..   46483:  227239196.. 227239199:      4:  227276380:
  11:    46484..   51695:  227276384.. 227281595:   5212:  227239200:
  12:    51696..   61903:  227281600.. 227291807:  10208:  227281596:
  13:    61904..   61907:  227239200.. 227239203:      4:  227291808:
  14:    61908..   67119:  227291812.. 227297023:   5212:  227239204:
  15:    67120..   77327:  227297028.. 227307235:  10208:  227297024:
  16:    77328..   77331:  227239204.. 227239207:      4:  227307236:
  17:    77332..   82543:  227307240.. 227312451:   5212:  227239208:
  18:    82544..   92751:  227312456.. 227322663:  10208:  227312452:
  19:    92752..   92755:  227239208.. 227239211:      4:  227322664:
  20:    92756..   97967:  227322668.. 227327879:   5212:  227239212:
  21:    97968..  102547:  227239212.. 227243791:   4580:  227327880: last,eof
linux-4.4.4.tar.bz2: 22 extents found

There's definitely a pattern here.

Out of curiosity I also tried the above run with autodefrag enabled, and
that helped a little bit: it merges those 4k extents into 256k-sized ones
with the adjacent followup extent. That was nice, but still a bit unexpected
since we've been told autodefrag is for random writes.
It also doesn't really explain the original behaviour.

I guess I need to add autodefrag everywhere now. :)

Thanks,
Holger

