Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:37843 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaHND53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 23:57:29 -0400
Received: by mail-oi0-f48.google.com with SMTP id h136so479751oig.21
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 20:57:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
	<20140812011401.568c16e6@natsu>
	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
Date: Wed, 13 Aug 2014 20:57:28 -0700
Message-ID: <CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
Subject: Re: Large files, nodatacow and fragmentation
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 11:36 AM, G. Richard Bellamy
<rbellamy@pteradigm.com> wrote:
> That being said, how would I determine what the root issue is?
> Specifically, the qcow2 file in question seems to have increasing
> fragmentation, even with the No_COW attr.
>
> [1]
> $ mkfs.btrfs -m raid10 -d raid10 /dev/sda /dev/sdb /dev/sdc /dev/sdd
> $ mount /dev/sda /mnt
> $ cd /mnt
> $ btrfs create subvolume __data
> $ btrfs create subvolume __data/libvirt
> $ cd /
> $ umount /mnt
> $ mount /dev/sda /var/lib/libvirt
> $ chattr +C /var/lib/libvirt/images
> $ cp /run/media/rbellamy/433acf1d-a1a4-4596-a6a7-005e643b24e0/libvirt/images/atlas.qcow2
> /var/lib/libvirt/images/
> $ filefrag /var/lib/libvirt/images/atlas.qcow2
> /var/lib/libvirt/images/atlas.qcow2: 0 extents found
> [START UP THE VM - DO SOME THINGS]
> $ filefrag /var/lib/libvirt/images/atlas.qcow2
> /var/lib/libvirt/images/atlas.qcow2: 12236 extents found
> [START UP THE VM - DO SOME THINGS]
> $ filefrag /var/lib/libvirt/images/atlas.qcow2
> /var/lib/libvirt/images/atlas.qcow2: 34988 extents found

I appreciate the information to date.

$ filefrag /var/lib/libvirt/images/atlas.qcow2
/var/lib/libvirt/images/atlas.qcow2: 39738 extents found

That's after a few reboots and limited access to the guest vm OS.

So, I think my question still stands: how can I determine empirically
what is causing the fragmentation? Or maybe a better question is, what
would be reasonable fragmentation of a nocow file in btrfs? For that
matter, what about a regular cow file in btrfs? I'm willing to read
technical documentation or source if that is where I need to go to
become better educated, so any pointers at all will be very much
appreciated.

-rb


On Mon, Aug 11, 2014 at 4:31 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Aug 11, 2014, at 1:14 PM, Roman Mamedov <rm@romanrm.net> wrote:
>
>
>>
>> Second, why qcow2? It can also have internal fragmentation which is unlikely to
>> do anything good for performance.
>
> It really depends on what version of libvirt and qemu-image you've got. I did some testing during Fedora 20 prior to release, and the best results for my configuration (a laptop with an HDD at that time): btrfs host, +C qcow2, btrfs guest, both 16KB leaf size, and the drive pointing to the qcow2 file with cache policy set to unsafe. And even when obliterating the VM while writing data, I never lost the guest Btrfs file system. Not that I recommend it, the cache policy is unsafe after all. I did lose some data but it was limited to commit time. We're not talking huge differences, the metric I was using was installing Fedora 20 based on installer log start/stop time for doing the unattended portion of the install. It also matters somewhat to pre-allocate metadata when creating the qcow2 file.
>
> I also tested XFS on XFS, ext4 on ext4, also in qcow2. And also on raw images. And also on LV's. I'd think the LV would have been faster since it completely eliminates one of the file systems (there is no host fs).
>
> Anyway, what I determined was the only way to know is to actually test your workload, or a good approximation of it, with various configurations.
>
> And another test is LVM thinp LV's once libvirt has support for using them (which may already have happened, I haven't revisted this since Oct 2013 testing), because those snapshots should be as usable as Btrfs snapshots, unlike conventional LVM snapshots which are slow and need explicit preallocation.
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
