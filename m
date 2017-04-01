Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36464 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdDAE1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 00:27:04 -0400
Received: by mail-wm0-f41.google.com with SMTP id o81so11284262wmb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 21:27:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$581b5$d5a02cf0$e209a38b$95d5d134@cox.net>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk> <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu> <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
 <22746.30348.324000.636753@tree.ty.sabi.co.uk> <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
 <22749.10893.729399.275210@tree.ty.sabi.co.uk> <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
 <22750.37100.788020.938846@tree.ty.sabi.co.uk> <CAP8EXU2cdtVP7+Qgy6mTJ1oqCmpW4JpaoUxAsf0RZ27WprvZ3g@mail.gmail.com>
 <22750.48060.805852.28370@tree.ty.sabi.co.uk> <CAP8EXU3YZLn1K6v8JLB_47Y1kVOb4uFgLmnn1Lr3iSsaHLkz6w@mail.gmail.com>
 <pan$581b5$d5a02cf0$e209a38b$95d5d134@cox.net>
From: GWB <gwb@2realms.com>
Date: Fri, 31 Mar 2017 23:26:22 -0500
Message-ID: <CAP8EXU0TWqZZrDe6J0nRLEhgO7w2iUvSPh-H86JNPeYQqtA9fw@mail.gmail.com>
Subject: Re: Shrinking a device - performance?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Indeed, that does make sense.  It's the output of the size command in
the Berkeley format of "text", not decimal, octal or hex.  Out of
curiosity about kernel module sizes, I dug up some old MacBooks and
looked around in:

/System/Library/Extensions/[modulename].kext/Content/MacOS:

udf is 637K on Mac OS 10.6
exfat is 75K on Mac OS 10.9
msdosfs is 79K on Mac OS 10.9
ntfs is 394K (That must be Paragon's ntfs for Mac)

And here's the kernel extension sizes for zfs (From OpenZFS):

/Library/Extensions/[modulename].kext/Content/MacOS:

zfs is 1.7M (10.9)
spl is 247K (10.9)

Different kernel from linux, of course (evidently a "mish mash" of
NextStep, BSD, Mach and Apple's own code), but that is one large
kernel extension for zfs.  If they are somehow comparable even with
the differences, 833K is not bad for btrfs compared to zfs.  I did not
look at the format of the file; it must be binary, but compression may
be optional for third party kexts.

So the kernel module sizes are large for both btrfs and zfs.  Given
the feature sets of both, is that surprising?

My favourite kernel extension in Mac OS X is:

/System/Library/Extensions/Dont Steal Mac OS X.kext/

Subtle, very subtle.

Gordon

On Fri, Mar 31, 2017 at 9:42 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> GWB posted on Fri, 31 Mar 2017 19:02:40 -0500 as excerpted:
>
>> It is confusing, and now that I look at it, more than a little funny.
>> Your use of xargs returns the size of the kernel module for each of the
>> filesystem types.  I think I get it now: you are pointing to how large
>> the kernel module for btrfs is compared to other file system kernel
>> modules, 833 megs (piping find through xargs to sed).  That does not
>> mean the btrfs kernel module can accommodate an upper limit of a command
>> line length that is 833 megs.  It is just a very big loadable kernel
>> module.
>
> Umm... 833 K, not M, I believe.  (The unit is bytes not KiB.)
>
> Because if just one kernel module is nearing a gigabyte, then the kernel
> must be many gigabytes either monolithic or once assembled in memory, and
> it just ain't so.
>
> But FWIW megs was my first-glance impression too, until my brain said "No
> way!  Doesn't work!" and I took a second look.
>
> The kernel may indeed no longer fit on a 1.44 MB floppy, but it's still
> got a ways to go before it's multiple GiB! =:^)  While they're XZ-
> compressed, I'm still fitting several monolithic-build kernels including
> their appended initramfs, along with grub, its config and modules, and a
> few other misc things, in a quarter-GB dup-mode btrfs, meaning 128 MiB
> capacity, including the 16 MiB system chunk so 112 MiB for data and
> metadata.  That simply wouldn't be possible if the kernel itself were
> multi-GB, even uncompressed.  Even XZ isn't /that/ good!
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
