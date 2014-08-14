Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46863 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750786AbaHNEXN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 00:23:13 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Large files, nodatacow and fragmentation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
Date: Wed, 13 Aug 2014 22:23:11 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com> <20140812011401.568c16e6@natsu> <AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com> <CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 13, 2014, at 9:57 PM, "G. Richard Bellamy" <rbellamy@pteradigm.com> wrote:

> On Mon, Aug 11, 2014 at 11:36 AM, G. Richard Bellamy
> <rbellamy@pteradigm.com> wrote:
>> That being said, how would I determine what the root issue is?
>> Specifically, the qcow2 file in question seems to have increasing
>> fragmentation, even with the No_COW attr.
>> 
>> [1]
>> $ mkfs.btrfs -m raid10 -d raid10 /dev/sda /dev/sdb /dev/sdc /dev/sdd
>> $ mount /dev/sda /mnt
>> $ cd /mnt
>> $ btrfs create subvolume __data
>> $ btrfs create subvolume __data/libvirt
>> $ cd /
>> $ umount /mnt
>> $ mount /dev/sda /var/lib/libvirt
>> $ chattr +C /var/lib/libvirt/images
>> $ cp /run/media/rbellamy/433acf1d-a1a4-4596-a6a7-005e643b24e0/libvirt/images/atlas.qcow2
>> /var/lib/libvirt/images/
>> $ filefrag /var/lib/libvirt/images/atlas.qcow2
>> /var/lib/libvirt/images/atlas.qcow2: 0 extents found

Sorta weird, it ought to have at least 1. Or maybe it wasn't sync'd yet from the copy.

>> [START UP THE VM - DO SOME THINGS]
>> $ filefrag /var/lib/libvirt/images/atlas.qcow2
>> /var/lib/libvirt/images/atlas.qcow2: 12236 extents found
>> [START UP THE VM - DO SOME THINGS]
>> $ filefrag /var/lib/libvirt/images/atlas.qcow2
>> /var/lib/libvirt/images/atlas.qcow2: 34988 extents found
> 
> I appreciate the information to date.

lsattr /var/lib/libvirt/images/atlas.qcow2

Is the xattr actually in place on that file?
> 
> So, I think my question still stands: how can I determine empirically
> what is causing the fragmentation?

It will fragment somewhat but I can't say that I've seen this much fragmentation with xattr C applied to qcow2. What's the workload? How was the qcow2 created? I recommend -o preallocation=metadata,compat=1.1,lazy_refcounts=on when creating it. My workloads were rather simplistic: OS installs and reinstalls. What's the filesystem being used in the guest that's using the qcow2 as backing?

It might be that your workload is best suited for a preallocated raw file that inherits +C, or even possibly an LV.


Chris Murphy

