Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41618 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdDACmi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 22:42:38 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cu8zg-0000Vj-Rd
        for linux-btrfs@vger.kernel.org; Sat, 01 Apr 2017 04:42:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Shrinking a device - performance?
Date: Sat, 1 Apr 2017 02:42:19 +0000 (UTC)
Message-ID: <pan$581b5$d5a02cf0$e209a38b$95d5d134@cox.net>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
        <22749.10893.729399.275210@tree.ty.sabi.co.uk>
        <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
        <22750.37100.788020.938846@tree.ty.sabi.co.uk>
        <CAP8EXU2cdtVP7+Qgy6mTJ1oqCmpW4JpaoUxAsf0RZ27WprvZ3g@mail.gmail.com>
        <22750.48060.805852.28370@tree.ty.sabi.co.uk>
        <CAP8EXU3YZLn1K6v8JLB_47Y1kVOb4uFgLmnn1Lr3iSsaHLkz6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

GWB posted on Fri, 31 Mar 2017 19:02:40 -0500 as excerpted:

> It is confusing, and now that I look at it, more than a little funny.
> Your use of xargs returns the size of the kernel module for each of the
> filesystem types.  I think I get it now: you are pointing to how large
> the kernel module for btrfs is compared to other file system kernel
> modules, 833 megs (piping find through xargs to sed).  That does not
> mean the btrfs kernel module can accommodate an upper limit of a command
> line length that is 833 megs.  It is just a very big loadable kernel
> module.

Umm... 833 K, not M, I believe.  (The unit is bytes not KiB.)

Because if just one kernel module is nearing a gigabyte, then the kernel 
must be many gigabytes either monolithic or once assembled in memory, and 
it just ain't so.

But FWIW megs was my first-glance impression too, until my brain said "No 
way!  Doesn't work!" and I took a second look.

The kernel may indeed no longer fit on a 1.44 MB floppy, but it's still 
got a ways to go before it's multiple GiB! =:^)  While they're XZ-
compressed, I'm still fitting several monolithic-build kernels including 
their appended initramfs, along with grub, its config and modules, and a 
few other misc things, in a quarter-GB dup-mode btrfs, meaning 128 MiB 
capacity, including the 16 MiB system chunk so 112 MiB for data and 
metadata.  That simply wouldn't be possible if the kernel itself were 
multi-GB, even uncompressed.  Even XZ isn't /that/ good!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

