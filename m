From: CACook@quantum-sci.com
Subject: Re: Adding a disk fails
Date: Fri, 21 Jan 2011 02:16:49 -0800
Message-ID: <201101210216.49389.CACook@quantum-sci.com>
References: <201101201318.40686.CACook@quantum-sci.com> <201101201510.54418.CACook@quantum-sci.com> <201101210755.54750.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101210755.54750.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 20 January 2011 22:55:54 Hubert Kario wrote:
> You still have a btrfs on /dev/sdc, do a 
> dd if=/dev/zero of=/dev/sdc bs=8192
> (overkill, but I don't remember which blocks have to be zeroed to destroy 
> btrfs superblock)

I gave up and started over.  Maybe it should be clarified in the wiki that no mkfs should be done on additional volumes, as it's counterintuitive to some.


> yes. rc.local is too late, unless you will also mount the volume from there 
> and not using /etc/fstab

How and when then?


> That depends - it has to be done before mounting. And if the device is
> part of the boot partition then you may put the "scan" command into an
> init-ramdisk.

This does not seem to have been sent to the listserv, as I only got it in a reply.  This is likely incomplete.


> Using something like "device=/dev/sdb,device=/dev/sdc" on fstab mount
> options should also work.

You mean as a substitute for a scan?

On my other server the btrfs array seems to mount just fine without any measures to scan.  I don't understand this,  nor why no specific advice is given about scanning on boot in the wiki.
