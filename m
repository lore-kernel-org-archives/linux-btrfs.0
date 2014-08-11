Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:64393 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaHKVhQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 17:37:16 -0400
Received: by mail-ob0-f175.google.com with SMTP id wp18so6532498obc.34
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 14:37:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140812011401.568c16e6@natsu>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
	<20140812011401.568c16e6@natsu>
Date: Mon, 11 Aug 2014 14:37:15 -0700
Message-ID: <CADw2B2O25ZQxT6Ez5aGs2_K7+G2S6PammCCMt6=Suu8oPLEtPw@mail.gmail.com>
Subject: Re: Large files, nodatacow and fragmentation
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 12:14 PM, Roman Mamedov <rm@romanrm.net> wrote:
>
> First of all, why do you require a COW filesystem in the first place... if all
> you do is just use it in a NoCOW mode?
>
> Second, why qcow2? It can also have internal fragmentation which is unlikely to
> do anything good for performance.

Both great questions. I'm experimenting with btrfs, and the various
permutations of
btrfs with KVM.

So, why btrfs vs lvm or ext4:
1. Because nocow isn't all I'm doing with that filesystem.
2. I like the way btrfs subvolumes work, vs lvm. I can have the nocow
files in one
subvolume, and still get great snapshot performance out of others.
3. I get the performance of a raid10 without the lvm management overhead. Online
rebalancing. Easy online resizing.
4. And frankly, I just kinda want to make it work.

>
> Try RAW format images; to reduce the space requirements, with the latest
> Qemu/KVM you can pass-through TRIM command from inside the VM guest (at least
> in the IDE controller mode) so that the backing filesystem will unmap areas
> that are no longer in use inside the VM, in effect "re-sparsifying" the image.
> This is VERY nifty. But yeah this can cause some fragmentation even with NoCOW.
>
> In my personal use case NoCOW is only utilized partly, because all subvolumes
> with running VMs are being snapshotted about every 30 minutes, and those
> snapshots are kept for two weeks. The performance is passable; at least when
> using KVM's "cache=writeback" mode (or less safer ones).

I've done my reading of qcow2 vs raw and that indicated that while
there is better
performance using raw, it's not significant enough to bypass the
ability to take a qemu
snapshot. I've not done the analysis myself, so I could be reading things wrong.

There's a great thread, "Are nocow files snapshot-aware?" [1]. My take
from that reading
is that doing a btrfs snapshot of a nocow file seems like it's
reasonable on a semi-regular
basis, but DON'T do it every 30 seconds.

Also that whole thread is predicated on the idea that your nocow files
are themselves
managed by a process/system that can read and write to them
atomically, thus I decided
against using the raw format.

>
> --
> With respect,
> Roman

Thanks Roman. But really we haven't addressed my original question,
which is - how would
I determine the root cause of the fragmentation in this nocow file on
top of a btrfs subvolume?

[1] http://www.spinics.net/lists/linux-btrfs/msg31341.html

Kind Regards,
Richard
