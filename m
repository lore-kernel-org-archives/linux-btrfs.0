Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:59432
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab3GZATl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 20:19:41 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.fire (8.14.5/8.14.5) with ESMTP id r6Q0Jehv002841
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 01:19:40 +0100
Message-ID: <51F1C09C.9020602@petezilla.co.uk>
Date: Fri, 26 Jul 2013 01:19:40 +0100
From: Pete <pete@petezilla.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Error on rebooting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear All,

Have I anything to be concerned about?

I have got some error messages on booting.  The scenario was that I had 
installed some ram and I suspect that I had disturbed a cable as one 
disk was not visible.  I could not mount the other disk (did not try 
degraded, but the messages seemed to indicate something serious was up).

After installing ram booted.  But some issue with some files, anything 
accessing those files froze.  Had to reboot.  Failed to shutdown 
correctly (shutdown stalled on unmount)

Reboot.

/home etc not mounted (btrfs in question)

Btrfsck /dev/sdb showed various errors.

When complete turned off machine.  Fiddled with cables.  Affected drive 
now seen on reboot.

Rebooted.  Mounted disks (perhaps) error messages may have been present 
on boot.  Much disk IO.  Disk IO stopped.  Machine appeared frozen 
except that Caps lock and Num lock worked.  Ctrl-alt-backspace did not 
sort out stalled x(?)dm session.  Hard power down.

Last reboot.  Error messages.  However, works.  Example messages from dmesg:

[    8.063138] btrfs: enabling inode map caching
[    8.067617] btrfs: use lzo compression
[    8.072092] btrfs: disk space caching is enabled
[    8.147324] btrfs: bdev /dev/sdb errs: wr 4015, rd 464, flush 0, 
corrupt 0, gen 0
[    8.802275] NET: Registered protocol family 10
[   15.462313] device fsid 2628a800-e095-4460-9b93-8847e9fb626b devid 2 
transid 27794 /dev/sdc
[   15.511463] device fsid 2628a800-e095-4460-9b93-8847e9fb626b devid 2 
transid 27794 /dev/sdc
[   15.566689] device fsid 2628a800-e095-4460-9b93-8847e9fb626b devid 2 
transid 27794 /dev/sdc
[   15.587851] device fsid 2628a800-e095-4460-9b93-8847e9fb626b devid 2 
transid 27794 /dev/sdc
[   15.620678] device fsid 2628a800-e095-4460-9b93-8847e9fb626b devid 2 
transid 27794 /dev/sdc
[   16.024295] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
...

...

...

...
    19.491507] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   56.064899] parent transid verify failed on 1142639534080 wanted 
27788 found 26856
[   56.154721] btrfs read error corrected: ino 1 off 1142639534080 (dev 
/dev/sdb sector 2179305424)
[   56.166301] parent transid verify failed on 1142597795840 wanted 
27777 found 27772
[   56.186790] btrfs read error corrected: ino 1 off 1142597795840 (dev 
/dev/sdb sector 2179223904)
[   56.460857] parent transid verify failed on 1142599532544 wanted 
27779 found 27772
[   56.461396] btrfs read error corrected: ino 1 off 1142599532544 (dev 
/dev/sdb sector 2179227296)
[   59.927078] ata1.00: configured for UDMA/133
[   59.927082] ata1: EH complete
[   59.933467] ata2.00: configured for UDMA/133
[   59.933473] ata2: EH complete
[   60.129445] ata3.00: configured for UDMA/133
[   60.129458] ata3: EH complete
[   61.449810] parent transid verify failed on 1142629605376 wanted 
27784 found 26856
[   61.473817] btrfs read error corrected: ino 1 off 1142629605376 (dev 
/dev/sdb sector 2179286032)
[   61.478075] parent transid verify failed on 1142629638144 wanted 
27784 found 26856
[   61.478574] btrfs read error corrected: ino 1 off 1142629638144 (dev 
/dev/sdb sector 2179286096)
[   61.478743] parent transid verify failed on 1142629658624 wanted 
27784 found 26856
[   61.478946] btrfs read error corrected: ino 1 off 1142629658624 (dev 
/dev/sdb sector 2179286136)
[   61.479147] parent transid verify failed on 1142629847040 wanted 
27784 found 26856
[   61.479382] btrfs read error corrected: ino 1 off 1142629847040 (dev 
/dev/sdb sector 2179286504)
[   61.479767] parent transid verify failed on 1142630506496 wanted 
27784 found 26856
[   61.480691] btrfs read error corrected: ino 1 off 1142630506496 (dev 
/dev/sdb sector 2179287792)
[   61.501092] parent transid verify failed on 1142629761024 wanted 
27784 found 26856
[   61.501423] btrfs read error corrected: ino 1 off 1142629761024 (dev 
/dev/sdb sector 2179286336)
[   62.704754] kded4[2419]: segfault at 10 ip 00007f99a11b26e0 sp 
00007fff4305e578 error 4 in libkscreen.so.0.9.0[7f99a11a7000+e000]
[   85.012565] parent transid verify failed on 1142612619264 wanted 
27777 found 26856
[   85.049566] btrfs read error corrected: ino 1 off 1142612619264 (dev 
/dev/sdb sector 2179252856)
[   87.961731] btrfs csum failed ino 749162 off 0 csum 2452727536 
private 1516042199
[   87.975603] btrfs read error corrected: ino 749162 off 0 (dev 
/dev/sdb sector 2181130648)
[   87.981595] btrfs csum failed ino 749163 off 0 csum 459327135 private 
1516042199
[   87.992897] btrfs read error corrected: ino 749163 off 0 (dev 
/dev/sdb sector 2181149880)
[  104.179638] parent transid verify failed on 1142638817280 wanted 
27786 found 26856
[  104.189146] btrfs read error corrected: ino 1 off 1142638817280 (dev 
/dev/sdb sector 2179304024)
[  104.197071] btrfs csum failed ino 1544486 off 0 csum 4176447263 
private 467839912
[  104.197136] btrfs csum failed ino 1544486 off 4096 csum 3482415336 
private 475019870
[  104.198076] btrfs csum failed ino 1544486 off 0 csum 4176447263 
private 467839912
[  104.198140] btrfs csum failed ino 1544486 off 4096 csum 3482415336 
private 475019870
[  104.204035] btrfs read error corrected: ino 1544486 off 0 (dev 
/dev/sdb sector 2182960392)
[  104.204551] btrfs read error corrected: ino 1544486 off 4096 (dev 
/dev/sdb sector 2182960400)
[  117.249253] parent transid verify failed on 1142609051648 wanted 
27774 found 26856
[  117.255886] btrfs read error corrected: ino 1 off 1142609051648 (dev 
/dev/sdb sector 2179245888)
[  117.419294] parent transid verify failed on 1142599507968 wanted 
27779 found 27772
[  117.437317] btrfs read error corrected: ino 1 off 1142599507968 (dev 
/dev/sdb sector 2179227248)
[  137.502176] NFSD: Unable to end grace period: -110

Given that I have booted now - does this mean that the above was btrfs 
sorting itself out?

Thanks

Pete
