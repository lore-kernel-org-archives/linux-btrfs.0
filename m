Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:47952 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbIHUC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 16:02:28 -0400
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "util-linux@vger.kernel.org" <util-linux@vger.kernel.org>,
        "Kani, Toshimitsu" <toshi.kani@hpe.com>,
        "Knippers, Linda" <linda.knippers@hpe.com>
Subject: RE: mkfs.btrfs cannot find rotational file for SSD detection for a
 pmem device
Date: Tue, 8 Sep 2015 20:00:02 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BD1EB13@G4W3202.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B40295BD1BF1F@G4W3202.americas.hpqcorp.net>
 <55EEDAE8.1060905@gmail.com>
In-Reply-To: <55EEDAE8.1060905@gmail.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: Austin S Hemmelgarn [mailto:ahferroin7@gmail.com]
> Sent: Tuesday, September 8, 2015 7:56 AM
> Subject: Re: mkfs.btrfs cannot find rotational file for SSD detection for
> a pmem device
> 
> On 2015-09-06 13:51, Elliott, Robert (Persistent Memory) wrote:
...
> > The impact looks limited to the print and causing it to not
> > automatically disable "metadata duplication on a single device."
> This is an issue inherent in the current pmem driver however, it should
> be fixed there and not in mkfs.btrfs, as other filesystems make
> decisions based on this file also, as does the I/O scheduler, and some
> block storage servers.  
> ...

The rotational file does exist, at:
/sys/devices/LNXSYSTM\:00/LNXSYBUS\:00/ACPI0012\:00/ndbus1/region0/namespace0.0/block/pmem0/queue/rotational

One or more functions are having trouble parsing that 108-byte string
... mkfs.btrfs's is_ssd, libblkid's blkid_devno_to_wholedisk, or
libblkid's sysfs_devno_to_wholedisk.  I'm not sure where the
breakdown occurs.

This is reminiscent of an issue that numactl has parsing the path to
get to .../device/numa_node (rather than .../queue/rotational).  It
was confused by not finding "/devices/pci" in a path for a storage
device.

> This gets tricky though because pmem isn't
> technically a block device at the low level, and doesn't use some parts
> of the block layer that most other block devices do.
> 
> On that note however, if the pmem device is backed by actual RAM and not
> flash storage (and most of them are from what I've seen), then the only
> advantage of using single metadata mode over dup is space savings, as
> RAM is not (usually) write limited.

pmem devices will be a mix ranging from flash-backed DRAM to new
technologies like 3D Crosspoint, usually offering high performance
and good wearout characteristics.

The btrfs driver does detect it as SSD after mkfs.btrfs did not:
kernel: BTRFS info (device pmem0): disk space caching is enabled
kernel: BTRFS: has skinny extents
kernel: BTRFS: flagging fs with big metadata feature
kernel: BTRFS: detected SSD devices, enabling SSD mode

