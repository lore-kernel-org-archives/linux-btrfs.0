Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:45550 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2H1T6X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Aug 2012 15:58:23 -0400
Received: from [84.145.154.32] (helo=hermione.invalid)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.68)
	(envelope-from <berberic@fmi.uni-passau.de>)
	id 1T6Rq9-0002z0-Ka
	for linux-btrfs@vger.kernel.org; Tue, 28 Aug 2012 21:52:45 +0200
Received: from berberic by hermione.invalid with local (Exim 4.80)
	(envelope-from <berberic@fmi.uni-passau.de>)
	id 1T6Rq8-0005Zs-Nt
	for linux-btrfs@vger.kernel.org; Tue, 28 Aug 2012 21:52:44 +0200
Date: Tue, 28 Aug 2012 21:52:44 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: =?utf-8?B?4oCcQnVn4oCdLXJlcG9ydA==?= =?utf-8?Q?=3A?= inconsistency
 kernel <-> tools
Message-ID: <20120828195244.GA15021@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

We had set up a btrfs-fs over 6 hot-plugable SAS-disks for
testing and got it into a state where kernel and btrfs-tools do not
agree any more about the state of the filesystem.

We do not remember exaclty what we did, but roughly it was something
like this (on the running system). THIS IS FROM MEMORY!

(1) pulled out one disk
(2) removed disk from btrfs
(3) rebalanced btrfs
(4) pulled out another disk
(5) removed disk from btrfs
(6) rebalanced btrfs

This went fine sofar.

(7) reinserted disk (and rebooted)
    At some point before reboot the first 10 sectors of one disk
    were zeroed to test if the disk gets removed from the btrfs.

Now btrfs-tools showed:

---------------------------------------------------------------------------
# btrfs fi show                      
failed to read /dev/sr0
Label: 'BTRFS_RAID'  uuid: 807193fd-17de-4088-9a54-3e7cacdc89db
        Total devices 6 FS bytes used 3.07GB
        devid    4 size 931.00GB used 75.00GB path /dev/sdf
        devid    5 size 931.00GB used 324.03GB path /dev/sde
        devid    6 size 931.00GB used 83.03GB path /dev/sdd
        devid    3 size 931.00GB used 326.03GB path /dev/sdc
        devid    2 size 931.00GB used 326.03GB path /dev/sdb
        devid    1 size 931.00GB used 324.04GB path /dev/sda

Btrfs Btrfs v0.19
---------------------------------------------------------------------------

As far as we can tell, only four of the disks are considered part of
the btrfs by kernel. There were only four “btrfs: bdev”-lines in dmesg
and only four disks took part in balancing. “btrfs device scan” says:

  unable to scan the device '/dev/sdd' - Device or resource busy

and balance does not balance theses two devices (of 6)

It was neither possible to remove the disk from the btrfs via “btrfs
device delete” nor adding them via “btrfs device add”.

(8) a colleague swaped the two disk

Now btrfs-tools showed:

---------------------------------------------------------------------------
# btrfs fi show
failed to read /dev/sr0
Label: 'BTRFS_RAID'  uuid: 807193fd-17de-4088-9a54-3e7cacdc89db
        Total devices 5 FS bytes used 3.01GB
        devid    6 size 931.00GB used 83.03GB path /dev/sdf
        devid    4 size 931.00GB used 75.00GB path /dev/sdd
        devid    5 size 931.00GB used 325.03GB path /dev/sde
        devid    3 size 931.00GB used 326.03GB path /dev/sdc
        devid    2 size 931.00GB used 325.03GB path /dev/sdb
        devid    1 size 931.51GB used 326.04GB path /dev/sda

Btrfs Btrfs v0.19
---------------------------------------------------------------------------

Claiming the btrfs has 5 disk, but listing 6 disks out of 5 (6 of 5).

He finally managed to get the btrfs complete again by overwriting the
first 100G of the two disk. After this the btrfs-tools (correctly)
stated a filesystem with 4 disk and it was possible to add the two
disk again.


Assumption:
kernel and btrfs do not share the same view of the filesystem.

In this state commands to repair the filesystem do not work, because
they are either rejected by the tools or by the kernel.

A tool that allows a disk/partition to be marked as not-a-btrfs-part
would be nice.

A “/proc/btrfs” showing the kernels view of the filesystem would be
usefull.

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic
