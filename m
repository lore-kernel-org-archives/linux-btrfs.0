Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fep25.mx.upcmail.net ([62.179.121.45]:39862 "EHLO
	fep25.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbJEUnp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 16:43:45 -0400
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep13-int.chello.at
          (InterMail vM.8.01.05.18 201-2260-151-151-20140610) with ESMTP
          id <20151005202647.BYKZ6796.viefep13-int.chello.at@edge03.upcmail.net>
          for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 22:26:47 +0200
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS RAID1 behavior after one drive temporal disconection
Date: Mon, 5 Oct 2015 22:26:46 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201510052226.47051.pisa@cmp.felk.cvut.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

SATA connection/firmware of my drives (ST3000VN000-1H4167) failed.
Disk has not responded to hdparm, smartctl and no SW reset,
SATA controller rescan changed the situation.

I have been able to restore communication by brute force
power cable connectore removal and reconnection. I have been
able to rescan device and partitions then.

There is high probability of time coincidence of problem start
and next SMART report

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 71 09 a9 00 80 40  Device Fault; Error: ABRT at LBA = 0x008000a9 = 8388777

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  61 00 18 00 09 01 46 00   4d+15:27:59.335  WRITE FPDMA QUEUED
  61 00 80 80 08 01 46 00   4d+15:27:59.335  WRITE FPDMA QUEUED
  61 00 80 00 08 01 46 00   4d+15:27:59.335  WRITE FPDMA QUEUED
  61 00 80 80 07 01 46 00   4d+15:27:59.335  WRITE FPDMA QUEUED
  61 00 68 18 07 01 46 00   4d+15:27:59.335  WRITE FPDMA QUEUED

Disk seems to be undamaged. The smartctl -t long finished without
any error logged or reported. Some backup ext4 partition can be mounted
and is writable.

BTRFS has recognized appearance of its partition (even that hanged
from sdb5 to sde5 when disk "hotplugged" again).
But it seems that RAID1 components are not in sync and BTRFS
continues to report

BTRFS: lost page write due to I/O error on /dev/sde5
BTRFS: bdev /dev/sde5 errs: wr 11021805, rd 8526080, flush 29099, corrupt 0, gen 

I have tried to find the best way to resync RAID1 BTRFS partitions.
But problem is that filesystem is the root one of the system.
So reboot to some rescue media is required to run btrfsck --repair
which is intended for unmounted devices.

What is behavior of BTRFS in this situation?
Is BTRFS able to use data from not up to date partition in these
cases where data in respective files have not been modified?
The main reason for question is if such (stable) data can be backuped
by out of sync partition in the case of some random block is wear
out on another device. Or is this situation equivalent to running
with only one disk?

Are there some parameters/solution to run some command
(scrub balance) which makes devices to be in the sync again
without unmount or reboot?

I believe than attaching one more drive and running "btrfs replace"
would solve described situation. But is there some equivalent to
run operation "inplace".

Thanks for reply,

                Pavel Pisa
    e-mail:     pisa@cmp.felk.cvut.cz
    www:        http://cmp.felk.cvut.cz/~pisa
    university: http://dce.fel.cvut.cz/
    company:    http://www.pikron.com/
