Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38695 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaHNOa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 10:30:29 -0400
Received: by mail-ob0-f178.google.com with SMTP id nu7so1035928obb.9
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 07:30:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
	<20140812011401.568c16e6@natsu>
	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
	<CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
	<9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>
Date: Thu, 14 Aug 2014 07:30:28 -0700
Message-ID: <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
Subject: Re: Large files, nodatacow and fragmentation
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 13, 2014 at 9:23 PM, Chris Murphy <lists@colorremedies.com> wrote:
> lsattr /var/lib/libvirt/images/atlas.qcow2
>
> Is the xattr actually in place on that file?

2014-08-14 07:07:36
$ filefrag /var/lib/libvirt/images/atlas.qcow2
/var/lib/libvirt/images/atlas.qcow2: 46378 extents found
2014-08-14 07:08:34
$ lsattr /var/lib/libvirt/images/atlas.qcow2
---------------C /var/lib/libvirt/images/atlas.qcow2

So, yeah, the attribute is set.

>
> It will fragment somewhat but I can't say that I've seen this much fragmentation with xattr C applied to qcow2. What's the workload? How was the qcow2 created? I recommend -o preallocation=metadata,compat=1.1,lazy_refcounts=on when creating it. My workloads were rather simplistic: OS installs and reinstalls. What's the filesystem being used in the guest that's using the qcow2 as backing?

When I created the file, I definitely preallocated the metadata, but
did not set compat or lazy_refcounts. However, isn't that more a
function of how qemu + KVM managed the image, rather than how btrfs?
This is a p2v target, if that matters. Workload has been minimal since
virtualizing because I have yet to get usable performance with this
configuration. The filesystem in the guest is Win7 NTFS. I have seen
massive thrashing of the underlying volume during VSS operations in
the guest, if that signifies.

>
> It might be that your workload is best suited for a preallocated raw file that inherits +C, or even possibly an LV.

I'm close to that decision. As I mentioned, I much prefer the btrfs
subvolume story over lvm, so moving to raw is probably more desirable
than that... however, then I run into my lack of understanding of the
difference between qcow2 and raw with respect to recoverability, e.g.
does raw have the same ACID characteristics as a qcow2 image, or is
atomicity a completely separate concern from the format? The ability
for the owning process to recover from corruption or inconsistency is
a key factor in deciding whether or not to turn COW off in btrfs - if
your overlying system is capable of such recovery, like a database
engine or (presumably) virtualization layer, then COW isn't a
necessary function from the underlying system.

So, just since I started this reply, you can see the difference in
fragmentation:
2014-08-14 07:25:04
$ filefrag /var/lib/libvirt/images/atlas.qcow2
/var/lib/libvirt/images/atlas.qcow2: 46461 extents found

That's 17 minutes, an OS without interaction (I wasn't doing anything
with it, but it may have been doing its own work like updates, etc.),
and I see an fragmentation increase of 83 extents, and a raid10 volume
that was beating itself up (I could hear the drives chattering away as
they worked).

-rb
