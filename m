From: Sander <sander@humilis.net>
Subject: Re: New idea about RAID and SSD
Date: Tue, 1 Sep 2009 15:05:46 +0200
Message-ID: <20090901130546.GA10305@cumulus>
References: <4A9D1746.1020407@mmmm.it>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Massimo Maggi <massimo@mmmm.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A9D1746.1020407@mmmm.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Massimo,

Massimo Maggi wrote (ao):
> SSDs have low latency but a high price per GB,
> Traditional hard disks have high latency, but high sequential read/write
> speed and low price per GB.
> Is possibile to use a SSD for metadata, which requires many seeks and is
> relatively small, in a special "RAID mode" with a traditional hard disk
> for the extents of the real data?
> A cheap but performant SSD (maybe 32 GB) + a big and fast HD (maybe 1.5
> TB, or two in RAID0 - 3TB ), wouldn't create an array much cheaper than
> a ssd-only array of the same size, and much faster (in
> not-only-sequential workload)  than one or two traditional HDs in RAID0?
> Would it work?

If you talk RAID0 (eg no redundancy), you could RAID0 one or several
traditional disks, and use the SSD as a journal device. That would be
ext3/4 only btw.

With mdadm you could create a RAID1 and use --write-mostly:

       -W, --write-mostly
              subsequent devices listed in a --build, --create, or --add  com-
              mand will be flagged as 'write-mostly'.  This is valid for RAID1
              only and means that the 'md'  driver  will  avoid  reading  from
              these devices if at all possible.  This can be useful if mirror-
              ing over a slow link.

Where the 'slow link' would be the traditional disk. But this is raid1 and
doesn't help in your case (but couldn't resist the need to mention it :-)

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
