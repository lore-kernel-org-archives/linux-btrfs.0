Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33034 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbbLGB5U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Dec 2015 20:57:20 -0500
Received: by pabfh17 with SMTP id fh17so119545987pab.0
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 17:57:19 -0800 (PST)
Received: from localhost (114-198-89-204.dyn.iinet.net.au. [114.198.89.204])
        by smtp.gmail.com with ESMTPSA id v89sm30535578pfa.91.2015.12.06.17.57.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Dec 2015 17:57:19 -0800 (PST)
Date: Mon, 7 Dec 2015 12:57:15 +1100
From: Alistair Grant <akgrant0710@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Fixing recursive fault and parent transid verify failed
Message-ID: <20151207015715.GA13954@alistair-xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

(Resending as it looks like the first attempt didn't get through,
probably too large, so logs are now in dropbox)

I have a btrfs volume which is raid1 across two spinning rust disks,
each 2TB.

When trying to access some files from a another machine using sshfs the
server machine has crashed twice resulting in a hard lock up, i.e. power
off required to restart the machine.

There are no crash dumps in /var/log/syslog, or anything that looks like
an associated error message to me, however on the second occasion I was
able to see the following message flash up the console (in addition to
some stack dumps):

Fixing recursive fault, but reboot is needed

I've ran btrfs scrub and btrfsck on the drives, with the output
included below.  Based on what I've found on the web, I assume that a
btrfs-zero-log is required.

* Is this the recommended path?
* Is there a way to find out which files will be affected by the loss of
  the transactions?

I do have a backup of the drive (which I believe is completely up to
date, the btrfs volume is used for archiving media and documents, and
single person use of git repositories, i.e. only very light writing and
reading).

Some basic details:

OS: Ubuntu 15.10
Kernel: Ubuntu 4.2.0-19-generic (which is based on mainline 4.2.6)

> sudo btrfs fi df /srv/d2root
==============================

Data, RAID1: total=250.00GiB, used=248.86GiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=8.00MiB, used=64.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=1.00GiB, used=466.77MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=160.00MiB, used=0.00B

> sudo btrfs fi usage /srv/d2root
=================================

Overall:
    Device size:		   3.64TiB
    Device allocated:		 502.04GiB
    Device unallocated:		   3.15TiB
    Device missing:		     0.00B
    Used:			 498.62GiB
    Free (estimated):		   1.58TiB	(min: 1.58TiB)
    Data ratio:			      2.00
    Metadata ratio:		      1.99
    Global reserve:		 160.00MiB	(used: 0.00B)

Data,single: Size:8.00MiB, Used:0.00B
   /dev/sdc	   8.00MiB

Data,RAID1: Size:250.00GiB, Used:248.86GiB
   /dev/sdb	 250.00GiB
   /dev/sdc	 250.00GiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdc	   8.00MiB

Metadata,RAID1: Size:1.00GiB, Used:466.77MiB
   /dev/sdb	   1.00GiB
   /dev/sdc	   1.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdc	   4.00MiB

System,RAID1: Size:8.00MiB, Used:64.00KiB
   /dev/sdb	   8.00MiB
   /dev/sdc	   8.00MiB

Unallocated:
   /dev/sdb	   1.57TiB
   /dev/sdc	   1.57TiB


btrfs scrub output:
https://www.dropbox.com/s/blqvopa1lhkghe5/scrub.log?dl=0


btrfsck sdb output:
https://www.dropbox.com/s/hw6w6cupuu1rny4/btrfsck.sdb.log?dl=0


btrfsck sdc output:
https://www.dropbox.com/s/mijz492mjr76p8z/btrfsck.sdc.log?dl=0



Thanks very much,
Alistair

