Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.artfiles.de ([80.252.97.80]:47573 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbaBROAh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 09:00:37 -0500
Received: from [178.13.125.3] (helo=fuckup.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80.1)
	id 1WFkaV-00070s-ME
	for linux-btrfs@vger.kernel.org; Tue, 18 Feb 2014 14:19:51 +0100
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Read i/o errs and disk replacement
Date: Tue, 18 Feb 2014 14:19:47 +0100
Message-ID: <8051054.BLVnDBVVi7@fuckup>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

well, I hit the first incidence where I really have to work with my btrfs 
setup. To get things straight I want to double-check here to not screw things 
up right from the start. We are talking about a home server. There is no time 
or user pressure involved, and there are backups, too.


Software
-------------
Linux 3.13.3
Btrfs v3.12


Hardware
---------------
5 1T hard drives configured to be a raid 10 for both data and metadata
    Data, RAID10: total=282.00GiB, used=273.33GiB
    System, RAID10: total=64.00MiB, used=36.00KiB
    Metadata, RAID10: total=1.00GiB, used=660.48MiB


Error
--------
This is not btrfs' fault but due to an hd error. I saw in the system logs
    btrfs: bdev /dev/sdb errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
and a subsequent check on btrfs showed
    [/dev/sdb].write_io_errs   0
    [/dev/sdb].read_io_errs    2
    [/dev/sdb].flush_io_errs   0
    [/dev/sdb].corruption_errs 0
    [/dev/sdb].generation_errs 0

So, I have a read error on sdb.


Questions
---------------
1)
Do I have to take action immediately (shutdown the system, umount the file 
system)? Can I even ignore the error? Unfortunately, I can not access SMART 
information through the sata interface of the enclosure which hosts the hds.

2)
I only can replace the disk, not add a new one and than swap over. There is no 
space left in the disk enclosure I am using. I also can not guarantee that if 
I remove sdb and start the system up again that all the other disks are named 
the same as they are now, and that the newly added disk will be names sdb 
again. Is this an issue?

3)
I know that btrfs can handle disks of different sizes. Is there a downside if I 
go for a 3T disk and add it to the 1T disks? Is there e.g. more stuff saved on 
the 3T disk, and if this ones fails I lose redundancy? Is a soft transition to 
3T where I replace every dying 1T disk with a 3T disk advisable?


Proposed solution for the current issue
--------------------------------------------------------------
1)
Delete the faulted drive using
    btrfs device delete /dev/sdb /path/to/pool
2)
Format the new disk with btrfs
    mkfs.btrfs
3)
Add the new disk to the filesystem using
    btrfs device add /dev/newdiskname /path/to/pool
4)
Balance the file system
    btrfs fs balance /path/to/pool

Is this the proper way to deal with the situation?


Thank you for your advice.
Best,
Wolfgang
