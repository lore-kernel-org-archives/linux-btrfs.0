Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25525 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LRCiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 21:38:15 -0500
Message-ID: <52B10C85.90405@oracle.com>
Date: Wed, 18 Dec 2013 10:46:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: "Garry T. Williams" <gtwilliams@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs RAID1 File System Grew Something Extra
References: <1617587.38j2eTuIdt@vfr>
In-Reply-To: <1617587.38j2eTuIdt@vfr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Garry,

  this is a known bug in mkfs.btrfs, the workaround for now is
  to run balance on FS having some data. so that unused group-
  profile will go away.

HTH, Anand

On 12/18/2013 10:03 AM, Garry T. Williams wrote:
> I have been using btrfs for my /home partition on my home machine for
> a few years now.  I created the file system RAID1 using two disk
> partitions.  Recently I noticed btrfs fi df shows extra Data, System,
> and Metadata allocations.  And btrfs fi show indicates extra
> allocations on one of my disk drives accounting for the 20 MiB
> allocation in the df display.
>
> I'm confused.  What does this mean?
>
>      garry@vfr$ sudo btrfs subvolume list /home
>      garry@vfr$ sudo btrfs filesystem df /home
>      Data, RAID1: total=32.00GiB, used=21.01GiB
> --> Data, single: total=8.00MiB, used=0.00
>      System, RAID1: total=8.00MiB, used=12.00KiB
> --> System, single: total=4.00MiB, used=0.00
>      Metadata, RAID1: total=15.00GiB, used=424.60MiB
> --> Metadata, single: total=8.00MiB, used=0.00
>      garry@vfr$ sudo btrfs filesystem show /home
>      Label: none  uuid: 6c3aeff6-9a50-4481-a175-7b98980eb638
> 	    Total devices 2 FS bytes used 21.43GiB
> -->         devid    1 size 373.76GiB used 47.03GiB path /dev/sda4
> 	    devid    2 size 373.76GiB used 47.01GiB path /dev/sdb4
>
>      Btrfs v3.12
>      garry@vfr$
>
> If it matters, I create a snapshot each night and run a rsync backup
> to another drive and then delete the snapshot.
>
> garry@vfr$ uname -r
> 3.11.10-200.fc19.x86_64
> garry@vfr$ rpm -q btrfs-progs
> btrfs-progs-3.12-1.fc19.x86_64
>
