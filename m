Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:49342 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaFSEwh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 00:52:37 -0400
From: Russell Coker <russell@coker.com.au>
To: george@chinilu.com
Reply-To: russell@coker.com.au
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on whole disk (no partitions)
Date: Thu, 19 Jun 2014 14:52:31 +1000
Message-ID: <1588129.Lk34yRcVbz@xev>
In-Reply-To: <53A23678.7070806@chinilu.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com> <53A23678.7070806@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 18 Jun 2014 18:01:44 George Mitchell wrote:
> A lot of good comments on this topic already.  I would just add that on 
> large (TB) drives, not partitioning can result in some pretty slow mount 
> and umount times (even applies to mounting subvolumes).

If you mount a subvol then the kernel goes through the process of mounting the 
filesystem and makes just the subvol visible.  Mounting a second subvol from 
that filesystem while the first is mounted should be instant.

Mounting multiple filesystems on separate partitions should take longer than 
mounting a single large filesystem.  If mounting a 4TB filesystem takes longer 
than 4*1TB filesystems then that would probably be a bug.

> That is one of 
> the frustrating side effects I have noticed with a non-partitioned 4TB 
> drive on 32bit dual core pentium system.

BTRFS can take a lot of CPU time (some of that is probably bugs in BTRFS).  I 
wouldn't do anything serious with it on a 32bit system.  That said there might 
be some performance bugs you are hitting so giving details about that on this 
list might be useful.

> Additionally, with one big 
> partitionless drive, any serious defect on any part of the drive can 
> cost you the whole shebang, while, if partitioned, your loss is limited 
> to the affected partition.

Backups are the first step to solving that problem.  The next step is RAID, 
BTRFS allows you to convert to RAID-1 on the fly which is convenient for that 
situation.

If you want to have data survive after getting errors in one part of a disk 
then you can run RAID-1 across 2 partitions on the same disk.  Performance 
will be poor but it works well.  I have a BTRFS RAID-1 on 2*1.5TB partitions 
on a 3TB disk that has ~100 bad sectors.  It's working well for me.

> I would also re-emphasize something that has 
> been mentioned by someone else already, which is that most partitioning 
> tools see a non-partitioned drive as being EMPTY, which can pose dangers 
> and risk costly mistakes with the push of a button.  So there are 
> definitely some trade-offs.

file(1) is one way of finding out what the disk is used for.  Admittedly a 
Linux installation disk might have some problems, but it could mess up a 
partitioned disk just as easily.

# file -s /dev/sd?
/dev/sda: sticky x86 boot sector; partition 1: ID=0x83, active, starthead 32, 
startsector 2048, 997376 sectors; partition 2: ID=0x82, starthead 53, 
startsector 999424, 1953792 sectors; partition 3: ID=0x83, starthead 211, 
startsector 2953216, 231487488 sectors, code offset 0x63
/dev/sdb: sticky BTRFS Filesystem sectorsize 4096, nodesize 4096, leafsize 
4096)
/dev/sdc: sticky BTRFS Filesystem sectorsize 4096, nodesize 4096, leafsize 
4096)

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

