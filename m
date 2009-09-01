From: Massimo Maggi <massimo@mmmm.it>
Subject: New idea about RAID and SSD
Date: Tue, 01 Sep 2009 14:44:54 +0200
Message-ID: <4A9D1746.1020407@mmmm.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
SSDs have low latency but a high price per GB,
Traditional hard disks have high latency, but high sequential read/write
speed and low price per GB.
Is possibile to use a SSD for metadata, which requires many seeks and is
relatively small, in a special "RAID mode" with a traditional hard disk
for the extents of the real data?
A cheap but performant SSD (maybe 32 GB) + a big and fast HD (maybe 1.5
TB, or two in RAID0 - 3TB ), wouldn't create an array much cheaper than
a ssd-only array of the same size, and much faster (in
not-only-sequential workload)  than one or two traditional HDs in RAID0?
Would it work?
Thank you for your precious time!
Massimo Maggi
massimo@mmmm.it


