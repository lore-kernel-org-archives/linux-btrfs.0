Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:56173 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3KVIMq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 03:12:46 -0500
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Cc: linux-raid@vger.kernel.org
Subject: Re: Triple parity and beyond
Date: Fri, 22 Nov 2013 19:12:39 +1100
Message-ID: <4544086.2UTvYHxkvM@russell.coker.com.au>
In-Reply-To: <528DD86E.8040608@websitemanagers.com.au>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <528DCD36.1060808@hesbynett.no> <528DD86E.8040608@websitemanagers.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 21 Nov 2013 20:54:54 Adam Goryachev wrote:
> On a pure storage server, the CPU would normally have nothing to do,
> except a little interrupt handling, it is just shuffling bytes around.
> Of course, if you need RAID7.5 then you probably have a dedicated
> storage server, so I don't see the problem with using the CPU to do all
> the calculations.

How would the pure storage server in question send data out to client systems?  
SMB?  NFS?  IMAP?  All options will take some CPU power.

There's a common myth that people should use hardware RAID to save CPU time, 
that's obviously wrong in the case of RAID-1 (just writing the data twice) and 
RAID-5 (XOR for parity).  But as we get into the more complex forms of parity 
CPU performance could become an issue.

Of course in terms of overall system performance the cost of doing a RAID 
rebuild in terms of disk seeks will probably exceed the CPU use.  As an aside, 
are there plans to limit the RAID rebuild speed for BTRFS?

On Thu, 21 Nov 2013 18:30:49 Stan Hoeppner wrote:
> I suggest that anyone in the future needing fast random write IOPS is
> going to move those workloads to SSD, which is steadily increasing in
> capacity.  And I suggest anyone building arrays with 10-20TB drives
> isn't in need of fast random write IOPS.

Traditionally SCSI/SAS disks have tended to be a lot smaller than IDE/SATA 
disks.  Now Dell has just started offering 2TB SAS disks while the largest SATA 
disks that they sell (In Australia on PowerEdge T110 servers at least) are 
also 2TB.  Presumably RAID recovery time was one factor that made 
manufacturers not bother with making larger SCSI/SAS disks in the past.

When 20TB disks become available a user could choose to just use the first 10TB 
of the disk.  Even in the days when 40G disks were big some people would use 
less than the full capacity of the disk for performance.

Will people really be storing data that is so important that triple parity is 
needed on 20TB disks but be unable to afford enough disks to use only the first 
10TB of each disk?  Is this a use-case that is worth coding for?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

