Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53874 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbaKRUlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 15:41:17 -0500
Received: by mail-vc0-f169.google.com with SMTP id hy10so5061923vcb.14
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 12:41:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546B68F8.6080008@ubuntu.com>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>
	<pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>
	<54699CC7.1050909@swiftspirit.co.za>
	<546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
Date: Tue, 18 Nov 2014 21:41:16 +0100
Message-ID: <CAE8gLhmnqq4Z=Ktbf8HUkM89Jjik=w5t7EgHAT4Agnpz47OWUw@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-11-18 16:42 GMT+01:00 Phillip Susi <psusi@ubuntu.com>:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 11/18/2014 1:16 AM, Chris Murphy wrote:
> > If fstab specifies rootfs as UUID, and there are two volumes with
> > the same UUID, it’s now ambiguous which one at boot time is the
> > intended rootfs. It’s no different than the days of /dev/sdXY where
> > X would change designations between boots = ambiguity and why we
> > went to UUID.
>
> He already said he has NOT rebooted, so there is no way that the
> snapshot has actually been mounted, even if it were UUID confusion.
>

That's right.

Anyway, I've built a system to reproduce the bug. You can download the
image and run it with KVM or other virtualization technology.
Instructions are straightforward – if you start the VM, you'll know
what to do, and you'll see what I was talking about.

http://undead.megabrutal.com/kvm-reproduce-1391429.img.xz

Download size: 113 MB; Unpacked image size: 2 GB.


> > So we kinda need a way to distinguish derivative volumes. Maybe
> > XFS and ext4 could easily change the volume UUID, but my vague
> > recollection is this is difficult on Btrfs? So that led me to the
> > idea of a way to create an on-the-fly (but consistent) “virtual
> > volume UUID” maybe based on a hash of both the LVM LV and fs
> > volume UUID.
>
> When using LVM, you should be referring to the volume by the LVM name
> rather than UUID.  LVM names are stable, and don't have the duplicate
> uuid problem.
>

I use LVM names to identify volumes. I initially suspected it's an
UUID confusion, because I thought grub-probe looks for the volume by
UUID. But now I think the problem is nothing to do with UUIDs.
Probably I should have looked deeper into the problem before I
hypothesized.
