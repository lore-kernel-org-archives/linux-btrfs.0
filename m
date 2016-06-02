Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sipb-vm-99.mit.edu ([18.181.0.178]:54575 "EHLO
	ocaml.xvm.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbcFBU3D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 16:29:03 -0400
To: linux-btrfs@vger.kernel.org
From: Omari Stephens <xsdg@xsdg.org>
Subject: btrfs ENOSPC "not the usual problem"
Cc: Omari Stephens <xsdg@mit.edu>
Message-ID: <57508CED.1020109@xsdg.org>
Date: Thu, 2 Jun 2016 19:45:49 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Note: not on list; please reply-all]

I've read everything I can find about running out of space on btrfs, and 
it hasn't helped.  I'm currently dead in the water.

Everything I do seems to make the problem monotonically worse — I tried 
adding a loopback device to the fs, and now I can't remove it.  Then I 
tried adding a real device (mSATA) to the fs and now I still can't 
remove the loopback device (which is making everything super slow), and 
I also can't remove the mSATA.  I've removed about 100GB from the 
filesystem and that hasn't done anything either.

Is there anything I can to do even figure out how bad things are, what I 
need to do to make any kind of forward progress?  This is a laptop, so I 
don't want to add an external drive only to find out that I can't remove 
it without corrupting my filesystem.

### FILESYSTEM STATE
19:23:14> [root{slobol}@/home/xsdg]
#btrfs fi show /home
Label: none  uuid: 4776be5b-5058-4248-a1b7-7c213757dfbd
     Total devices 3 FS bytes used 221.02GiB
     devid    1 size 418.72GiB used 413.72GiB path /dev/sda3
     devid    2 size 10.00GiB used 5.00GiB path /dev/loop0
     devid    3 size 14.91GiB used 3.00GiB path /dev/sdb1


19:23:33> [root{slobol}@/home/xsdg]
#btrfs fi usage /home
Overall:
     Device size:         443.63GiB
     Device allocated:         421.72GiB
     Device unallocated:          21.91GiB
     Device missing:             0.00B
     Used:             221.68GiB
     Free (estimated):         219.24GiB    (min: 208.29GiB)
     Data ratio:                  1.00
     Metadata ratio:              2.00
     Global reserve:         228.00MiB    (used: 36.00KiB)

Data,single: Size:417.69GiB, Used:220.36GiB
    /dev/loop0       5.00GiB
    /dev/sda3     409.69GiB
    /dev/sdb1       3.00GiB

Metadata,single: Size:8.00MiB, Used:0.00B
    /dev/sda3       8.00MiB

Metadata,DUP: Size:2.00GiB, Used:674.45MiB
    /dev/sda3       4.00GiB

System,single: Size:4.00MiB, Used:0.00B
    /dev/sda3       4.00MiB

System,DUP: Size:8.00MiB, Used:56.00KiB
    /dev/sda3      16.00MiB

Unallocated:
    /dev/loop0       5.00GiB
    /dev/sda3       5.00GiB
    /dev/sdb1      11.91GiB


### BALANCE FAILS, EVEN WITH -dusage=0
19:23:02> [root{slobol}@/home/xsdg]
#btrfs balance start -v -dusage=0 .
Dumping filters: flags 0x1, state 0x0, force is off
   DATA (flags 0x2): balancing, usage=0
ERROR: error during balancing '.': No space left on device
There may be more info in syslog - try dmesg | tail


### CAN'T REMOVE DEVICES -> ENOSPC
#btrfs device remove /dev/loop0 /home
ERROR: error removing device '/dev/loop0': No space left on device

--xsdg
