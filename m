Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:59288 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbcCML6M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 07:58:12 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1af4ew-0002fD-4Y
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 12:58:10 +0100
Date: Sun, 13 Mar 2016 12:58:10 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: New file system with same issue (was: Again, no space left on device
 while rebalancing and recipe doesnt work)
Message-ID: <20160313115809.GQ2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> The alternative if this can't be fixed, is to recreate the filesystem
> because there's no practical way yet to migrate so many snapshots to a
> new file system.

I recreated the file system on March 7, with 200 GiB in size, using
btrfs-tools 4.4. The snapshot-taking process has been running since
then, but I also regularly cleaned up. The number of snapshots on the
new filesystem has never exceeded 1000, with the current count being
at 148.

And btrfs balance runs into the same ENOSPC issues as the old one:

[9/508]mh@fan:~$ grep -v 'device dm-15' 20160313-fanbtr-btrfs-syslog
Mar 13 11:05:45 fan mh: BEGIN btrfs-balance script
Mar 13 11:05:45 fan mh: btrfs fi df /
Mar 13 11:05:45 fan root: Data, single: total=80.00GiB, used=77.71GiB
Mar 13 11:05:45 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 13 11:05:45 fan root: Metadata, single: total=27.00GiB, used=2.38GiB
Mar 13 11:05:45 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 13 11:05:45 fan mh: btrfs fi show /
Mar 13 11:05:45 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 13 11:05:45 fan root: #011Total devices 1 FS bytes used 80.09GiB
Mar 13 11:05:45 fan root: #011devid    1 size 200.00GiB used 107.03GiB path /dev/mapper/fanbtr
Mar 13 11:05:45 fan root:
Mar 13 11:05:45 fan mh: btrfs fi usage /
Mar 13 11:05:45 fan root: Overall:
Mar 13 11:05:45 fan root:     Device size:#011#011 200.00GiB
Mar 13 11:05:45 fan root:     Device allocated:#011#011 107.03GiB
Mar 13 11:05:45 fan root:     Device unallocated:#011#011  92.97GiB
Mar 13 11:05:45 fan root:     Device missing:#011#011     0.00B
Mar 13 11:05:45 fan root:     Used:#011#011#011  80.09GiB
Mar 13 11:05:45 fan root:     Free (estimated):#011#011  95.26GiB#011(min: 95.26GiB)
Mar 13 11:05:45 fan root:     Data ratio:#011#011#011      1.00
Mar 13 11:05:45 fan root:     Metadata ratio:#011#011      1.00
Mar 13 11:05:45 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 13 11:05:45 fan root:
Mar 13 11:05:45 fan root: Data,single: Size:80.00GiB, Used:77.71GiB
Mar 13 11:05:45 fan root:    /dev/mapper/fanbtr#011  80.00GiB
Mar 13 11:05:45 fan root:
Mar 13 11:05:45 fan root: Metadata,single: Size:27.00GiB, Used:2.38GiB
Mar 13 11:05:45 fan root:    /dev/mapper/fanbtr#011  27.00GiB
Mar 13 11:05:45 fan root:
Mar 13 11:05:45 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 13 11:05:45 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 13 11:05:45 fan root:
Mar 13 11:05:45 fan root: Unallocated:
Mar 13 11:05:45 fan root:    /dev/mapper/fanbtr#011  92.97GiB
Mar 13 11:05:45 fan mh: BEGIN btrfs balance start /
Mar 13 11:20:30 fan root: ERROR: error during balancing '/': No space left on device
Mar 13 11:20:30 fan root: There may be more info in syslog - try dmesg | tail
Mar 13 11:20:30 fan root: btrfs fi df /
Mar 13 11:20:30 fan root: Data, single: total=78.00GiB, used=77.70GiB
Mar 13 11:20:30 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 13 11:20:30 fan root: Metadata, single: total=15.00GiB, used=2.38GiB
Mar 13 11:20:30 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 13 11:20:30 fan root: btrfs fi show /
Mar 13 11:20:30 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 13 11:20:30 fan root: #011Total devices 1 FS bytes used 80.08GiB
Mar 13 11:20:30 fan root: #011devid    1 size 200.00GiB used 93.03GiB path /dev/mapper/fanbtr
Mar 13 11:20:30 fan root:
Mar 13 11:20:30 fan root: btrfs fi usage /
Mar 13 11:20:30 fan root: Overall:
Mar 13 11:20:30 fan root:     Device size:#011#011 200.00GiB
Mar 13 11:20:30 fan root:     Device allocated:#011#011  93.03GiB
Mar 13 11:20:30 fan root:     Device unallocated:#011#011 106.97GiB
Mar 13 11:20:30 fan root:     Device missing:#011#011     0.00B
Mar 13 11:20:30 fan root:     Used:#011#011#011  80.08GiB
Mar 13 11:20:30 fan root:     Free (estimated):#011#011 107.27GiB#011(min: 107.27GiB)
Mar 13 11:20:30 fan root:     Data ratio:#011#011#011      1.00
Mar 13 11:20:30 fan root:     Metadata ratio:#011#011      1.00
Mar 13 11:20:30 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 13 11:20:30 fan root:
Mar 13 11:20:30 fan root: Data,single: Size:78.00GiB, Used:77.70GiB
Mar 13 11:20:30 fan root:    /dev/mapper/fanbtr#011  78.00GiB
Mar 13 11:20:30 fan root:
Mar 13 11:20:30 fan root: Metadata,single: Size:15.00GiB, Used:2.38GiB
Mar 13 11:20:30 fan root:    /dev/mapper/fanbtr#011  15.00GiB
Mar 13 11:20:30 fan root:
Mar 13 11:20:30 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 13 11:20:30 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 13 11:20:30 fan root:
Mar 13 11:20:30 fan root: Unallocated:
Mar 13 11:20:30 fan root:    /dev/mapper/fanbtr#011 106.97GiB
Mar 13 11:20:30 fan root: BEGIN btrfs balance start -dprofiles=single /
Mar 13 11:36:17 fan root: Done, had to relocate 78 out of 94 chunks
Mar 13 11:36:17 fan root: btrfs fi df /
Mar 13 11:36:17 fan root: Data, single: total=78.00GiB, used=77.71GiB
Mar 13 11:36:17 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 13 11:36:17 fan root: Metadata, single: total=15.00GiB, used=2.38GiB
Mar 13 11:36:17 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 13 11:36:17 fan root: btrfs fi show /
Mar 13 11:36:17 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 13 11:36:17 fan root: #011Total devices 1 FS bytes used 80.09GiB
Mar 13 11:36:17 fan root: #011devid    1 size 200.00GiB used 93.03GiB path /dev/mapper/fanbtr
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: btrfs fi usage /
Mar 13 11:36:17 fan root: Overall:
Mar 13 11:36:17 fan root:     Device size:#011#011 200.00GiB
Mar 13 11:36:17 fan root:     Device allocated:#011#011  93.03GiB
Mar 13 11:36:17 fan root:     Device unallocated:#011#011 106.97GiB
Mar 13 11:36:17 fan root:     Device missing:#011#011     0.00B
Mar 13 11:36:17 fan root:     Used:#011#011#011  80.09GiB
Mar 13 11:36:17 fan root:     Free (estimated):#011#011 107.26GiB#011(min: 107.26GiB)
Mar 13 11:36:17 fan root:     Data ratio:#011#011#011      1.00
Mar 13 11:36:17 fan root:     Metadata ratio:#011#011      1.00
Mar 13 11:36:17 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Data,single: Size:78.00GiB, Used:77.71GiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  78.00GiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Metadata,single: Size:15.00GiB, Used:2.38GiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  15.00GiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Unallocated:
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011 106.97GiB
Mar 13 11:36:17 fan root: BEGIN btrfs balance start -mprofiles=dup /
Mar 13 11:36:17 fan root: Done, had to relocate 0 out of 94 chunks
Mar 13 11:36:17 fan root: btrfs fi df /
Mar 13 11:36:17 fan root: Data, single: total=78.00GiB, used=77.71GiB
Mar 13 11:36:17 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 13 11:36:17 fan root: Metadata, single: total=15.00GiB, used=2.38GiB
Mar 13 11:36:17 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 13 11:36:17 fan root: btrfs fi show /
Mar 13 11:36:17 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 13 11:36:17 fan root: #011Total devices 1 FS bytes used 80.09GiB
Mar 13 11:36:17 fan root: #011devid    1 size 200.00GiB used 93.03GiB path /dev/mapper/fanbtr
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: btrfs fi usage /
Mar 13 11:36:17 fan root: Overall:
Mar 13 11:36:17 fan root:     Device size:#011#011 200.00GiB
Mar 13 11:36:17 fan root:     Device allocated:#011#011  93.03GiB
Mar 13 11:36:17 fan root:     Device unallocated:#011#011 106.97GiB
Mar 13 11:36:17 fan root:     Device missing:#011#011     0.00B
Mar 13 11:36:17 fan root:     Used:#011#011#011  80.09GiB
Mar 13 11:36:17 fan root:     Free (estimated):#011#011 107.26GiB#011(min: 107.26GiB)
Mar 13 11:36:17 fan root:     Data ratio:#011#011#011      1.00
Mar 13 11:36:17 fan root:     Metadata ratio:#011#011      1.00
Mar 13 11:36:17 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Data,single: Size:78.00GiB, Used:77.71GiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  78.00GiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Metadata,single: Size:15.00GiB, Used:2.38GiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  15.00GiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Unallocated:
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011 106.97GiB
Mar 13 11:36:17 fan root: BEGIN btrfs balance start --force -sprofiles=dup /
Mar 13 11:36:17 fan root: Done, had to relocate 0 out of 94 chunks
Mar 13 11:36:17 fan root: btrfs fi df /
Mar 13 11:36:17 fan root: Data, single: total=78.00GiB, used=77.71GiB
Mar 13 11:36:17 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 13 11:36:17 fan root: Metadata, single: total=15.00GiB, used=2.38GiB
Mar 13 11:36:17 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 13 11:36:17 fan root: btrfs fi show /
Mar 13 11:36:17 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 13 11:36:17 fan root: #011Total devices 1 FS bytes used 80.09GiB
Mar 13 11:36:17 fan root: #011devid    1 size 200.00GiB used 93.03GiB path /dev/mapper/fanbtr
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: btrfs fi usage /
Mar 13 11:36:17 fan root: Overall:
Mar 13 11:36:17 fan root:     Device size:#011#011 200.00GiB
Mar 13 11:36:17 fan root:     Device allocated:#011#011  93.03GiB
Mar 13 11:36:17 fan root:     Device unallocated:#011#011 106.97GiB
Mar 13 11:36:17 fan root:     Device missing:#011#011     0.00B
Mar 13 11:36:17 fan root:     Used:#011#011#011  80.09GiB
Mar 13 11:36:17 fan root:     Free (estimated):#011#011 107.26GiB#011(min: 107.26GiB)
Mar 13 11:36:17 fan root:     Data ratio:#011#011#011      1.00
Mar 13 11:36:17 fan root:     Metadata ratio:#011#011      1.00
Mar 13 11:36:17 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Data,single: Size:78.00GiB, Used:77.71GiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  78.00GiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Metadata,single: Size:15.00GiB, Used:2.38GiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  15.00GiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 13 11:36:17 fan root:
Mar 13 11:36:17 fan root: Unallocated:
Mar 13 11:36:17 fan root:    /dev/mapper/fanbtr#011 106.97GiB
Mar 13 11:36:17 fan root: BEGIN btrfs balance start /
Mar 13 11:51:23 fan root: ERROR: error during balancing '/': No space left on device
Mar 13 11:51:23 fan root: There may be more info in syslog - try dmesg | tail
Mar 13 11:51:23 fan root: btrfs fi df /
Mar 13 11:51:23 fan root: Data, single: total=78.00GiB, used=77.70GiB
Mar 13 11:51:23 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 13 11:51:23 fan root: Metadata, single: total=23.00GiB, used=2.38GiB
Mar 13 11:51:23 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 13 11:51:23 fan root: btrfs fi show /
Mar 13 11:51:23 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 13 11:51:23 fan root: #011Total devices 1 FS bytes used 80.08GiB
Mar 13 11:51:23 fan root: #011devid    1 size 200.00GiB used 101.03GiB path /dev/mapper/fanbtr
Mar 13 11:51:23 fan root:
Mar 13 11:51:23 fan root: btrfs fi usage /
Mar 13 11:51:23 fan root: Overall:
Mar 13 11:51:23 fan root:     Device size:#011#011 200.00GiB
Mar 13 11:51:23 fan root:     Device allocated:#011#011 101.03GiB
Mar 13 11:51:23 fan root:     Device unallocated:#011#011  98.97GiB
Mar 13 11:51:23 fan root:     Device missing:#011#011     0.00B
Mar 13 11:51:23 fan root:     Used:#011#011#011  80.08GiB
Mar 13 11:51:23 fan root:     Free (estimated):#011#011  99.26GiB#011(min: 99.26GiB)
Mar 13 11:51:23 fan root:     Data ratio:#011#011#011      1.00
Mar 13 11:51:23 fan root:     Metadata ratio:#011#011      1.00
Mar 13 11:51:23 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 13 11:51:23 fan root:
Mar 13 11:51:23 fan root: Data,single: Size:78.00GiB, Used:77.70GiB
Mar 13 11:51:23 fan root:    /dev/mapper/fanbtr#011  78.00GiB
Mar 13 11:51:23 fan root:
Mar 13 11:51:23 fan root: Metadata,single: Size:23.00GiB, Used:2.38GiB
Mar 13 11:51:23 fan root:    /dev/mapper/fanbtr#011  23.00GiB
Mar 13 11:51:23 fan root:
Mar 13 11:51:23 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 13 11:51:23 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 13 11:51:23 fan root:
Mar 13 11:51:23 fan root: Unallocated:
Mar 13 11:51:23 fan root:    /dev/mapper/fanbtr#011  98.97GiB
Mar 13 11:51:23 fan root: END btrfs-balance script
[10/509]mh@fan:~$

I see the same metadata spread as with the old filesystem in btrfs fi
df, totl at 23 and used at 2.38 GiB. What I find strange is that this
filesystem has Data, System and Metadata in "single" profile, is this
the new default for a 200 GiB file system?

Full log is at http://q.bofh.de/~mh/stuff/20160313-fanbtr-btrfs-syslog

The log was taken with enospc_debug active on the file system and all
file system, block device and storage relevant log lines were left in.

Is there anything missing? Is this the same issue? Would the log help
as addition in https://bugzilla.kernel.org/show_bug.cgi?id=114451?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
