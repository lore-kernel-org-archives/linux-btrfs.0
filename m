Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:37130 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaKQIAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 03:00:03 -0500
Received: by mail-vc0-f181.google.com with SMTP id le20so4264417vcb.12
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 00:00:03 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Nov 2014 09:00:03 +0100
Message-ID: <CAE8gLhkZXrPoCeoxFmLSK_S47TyGXhLbJqSVQcjzSdjnBjXCaA@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-11-17 7:59 GMT+01:00 Brendan Hide <brendan@swiftspirit.co.za>:
>
> Grub is already a little smart here - it avoids snapshots. But in this case it is relying on the UUID and only finding it in the snapshot. So possibly this is a bug in grub affecting the bug reporter specifically - but perhaps the bug is in btrfs where grub is relying on btrfs code.


Yesterday, when I reproduced the phenomenon on a VM, I've found
something rather interesting thing: even /proc/mounts reports
incorrectly, that the snapshot is being mounted instead of the root
FS. Note, there were no reboot. Just create an LVM snapshot and then
check /proc/mounts.

I couldn't reproduce the same with non-root file systems. It seems
this only appears when the device in question is mounted as root FS.


> Yes, I'd rather use btrfs' snapshot mechanism - but this is often a choice that is left to the user/admin/distro. I don't think saying "LVM snapshots are incompatible with btrfs" is the right way to go either.


Before I did a release upgrade, just to be safe, I made both (LVM and
btrfs snapshot).


>
> That leaves two aspects of this issue which I view as two separate bugs:
> a) Btrfs cannot gracefully handle separate filesystems that have the same UUID. At all.
> b) Grub appears to pick the wrong filesystem when presented with two filesystems with the same UUID.
>
> I feel a) is a btrfs bug.
> I feel b) is a bug that is more about "ecosystem design" than grub being silly.
>
> I imagine a couple of aspects that could help fix a):
> - Utilise a "unique drive identifier" in the btrfs metadata (surely this exists already?). This way, any two filesystems will always have different drive identifiers *except* in cases like a ddrescue'd copy or a block-level snapshot. This will provide a sensible mechanism for "defined behaviour", preventing corruption - even if that "defined behaviour" is to simply give out lots of "PEBKAC" errors and panic.
> - Utilise a "drive list" to ensure that two unrelated filesystems with the same UUID cannot get "mixed up". Yes, the user/admin would likely be the culprit here (perhaps a VM rollout process that always gives out the same UUID in all its filesystems). Again, does btrfs not already have something like this built-in that we're simply not utilising fully?
>
> I'm not exactly sure of the "correct" way to fix b) except that I imagine it would be trivial to fix once a) is fixed.


Note that everything that is written into the file system's metadata
gets duplicated with an LVM snapshot. So a "unique drive identifier"
wouldn't solve the problem, as it would also get replicated, and BTRFS
would still see two identical devices.

But devices on Linux have major and minor numbers those uniquely
identify devices while they are attached. The original and the
snapshot device have different major/minor numbers, and it would be
quite enough to differentiate the devices while they are being
opened/mounted.

By the way, I actually made an entire release upgrade with the
snapshot being there and being reported incorrectly. This would have
caused enough corruption in the file system that I would have surely
noticed it. But I didn't perceive any data corruption. BTRFS didn't
actually write to the snapshot device. It seems the device is only
mixed up in /proc/mounts, so probably the problem is not so severe as
we think, and wouldn't require fundamental changes to BTRFS to fix it.
