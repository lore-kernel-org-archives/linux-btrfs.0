Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52871 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751359AbaKRGV6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 01:21:58 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54699CC7.1050909@swiftspirit.co.za>
Date: Mon, 17 Nov 2014 23:21:57 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, bug-grub@gnu.org
Message-Id: <988DFC86-0C84-4735-AF3D-02CD394D5FEA@colorremedies.com>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 16, 2014, at 11:59 PM, Brendan Hide <brendan@swiftspirit.co.za> wrote:

> cc'd bug-grub@gnu.org for FYI
> 
> On 2014/11/17 03:42, Duncan wrote:
>> MegaBrutal posted on Sun, 16 Nov 2014 22:35:26 +0100 as excerpted:
>> 
>>> Hello guys,
>>> 
>>> I think you'll like this...
>>> https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1391429
>> UUID is an initialism for "Universally Unique IDentifier".[1]
>> 
>> If the UUID isn't unique, by definition, then, it can't be a UUID, and
>> that's a bug in whatever is making the non-unique would-be UUID that
>> isn't unique and thus cannot be a universally unique ID.  In this case
>> that would appear to be LVM.
> Perhaps the right question to ask is "Where should this bug be fixed?”.
> 
> TL;DR: This needs more thought and input from btrfs devs. To LVM, the bug is likely seen as being "out of scope". The "correct" fix probably lies in the ecosystem design, which requires co-operation from btrfs.

I think the libblkid folks should be brought into this discussion, see what their take on this.

LVM conventional snapshots causing this problem is rare / self-limiting as they’re short lived. LVM thinp snapshots mean there can be dozens, and they can sanely endure for the life of the thin pool.

Effectively we have derivative volumes. At snapshot time, should a.) the fs volume UUID be changed; b.) each fs adds an additional/secondary volume UUID at snapshot time; c.) each fs adds a derivative/version indicator, i.e. 0 at mkfs time and maybe epoch time stamped at snapshot time; d.) not use fs UUID for identifying volumes uniqueness, instead use a virtual volume UUID which is externally determined based on whether the fs is on an LV snapshot.



> Making a snapshot in LVM is a fundamental thing - and I feel LVM, in making its snapshot, is doing its job "exactly as expected".
> 
> Additionally, there are other ways to get to a similar state without LVM: ddrescue backup, SAN snapshot, old "missing" disk re-introduced, etc.

Sure and likewise self limiting problem. LVM thinp snapshots actually do make this confusion of multiple instances of the same volume UUID much much more likely.

> 
> That leaves two places where this can be fixed: grub and btrfs

The GRUB os-prober and grub-mkconfig paradigm I think needs to come to an end. The grub.cfg is not supposed to be externally modified, the design is that os-prober + grub-mkconfig obliterate it and generate a whole new one from scratch anytime the system boot state changes, i.e. anytime a new kernel is added.

GRUB isn’t good at OS discovery now, I think it should just be abandoned. It can have its grub.cfg generated to do whatever complex things are needed, but the individual boot menu entries should exist as drop-in scripts managed by whatever is changing the OS boot state. This is the fundamental part of the two bootloaderspecs:
http://www.freedesktop.org/wiki/Specifications/BootLoaderSpec/
http://www.freedesktop.org/wiki/MatthewGarrett/BootLoaderSpec/

And it’s a fundamental part of OSTree which supports multiple bootable trees on any filesystem, and currently uses a variation on bootloaderspec drop-in scripts to inform GRUB how to boot such a system:
https://wiki.gnome.org/action/show/Projects/OSTree?action=show&redirect=OSTree




> 
> Grub is already a little smart here - it avoids snapshots. But in this case it is relying on the UUID and only finding it in the snapshot. So possibly this is a bug in grub affecting the bug reporter specifically - but perhaps the bug is in btrfs where grub is relying on btrfs code.
> 
> Yes, I'd rather use btrfs' snapshot mechanism - but this is often a choice that is left to the user/admin/distro. I don't think saying "LVM snapshots are incompatible with btrfs" is the right way to go either.
> 
> That leaves two aspects of this issue which I view as two separate bugs:
> a) Btrfs cannot gracefully handle separate filesystems that have the same UUID. At all.
> b) Grub appears to pick the wrong filesystem when presented with two filesystems with the same UUID.
> 
> I feel a) is a btrfs bug.
> I feel b) is a bug that is more about "ecosystem design" than grub being silly.

I think we’re well past the expiration date on grub.cfg, a line should be drawn in the sand to deprecate routine use of os-prober + grub-mkconfig, and move to drop-in scripts by whatever the distro presumes will be responsible for managing what “tree” will be booted or will be offered as a boot option, all GRUB needs to learn is how to use that drop in script file format.

Ergo just because I’ve snapshot my root does not mean grub-mkconfig should be creating boot entries for it. But whatever usespace tool I’m using to do those snapshots (ostree, snapper, whatever the GNOME folks might come up with) should be the thing that creates the boot entry script; or as simple as this 2-4 line script should be, even hand done by a user, unlike the current grub.cfg file format.

Further I’d like to get more traction from the syslinux/extlinux folks to support the same drop-in boot file format. There’s no good reason for us to not support a single file format for boot menu entries. 


Chris Murphy