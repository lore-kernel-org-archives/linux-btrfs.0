Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30069 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753625AbdFSH0c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 03:26:32 -0400
Subject: Re: Feature request: Tuneable zlib compression level
To: Jason Detring <detringj@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+AKrqAELw+C+XwrsweD=j6aB45_YMey5XLVsxcnQmOjQ=J+yA@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <540566b4-f44e-966b-fbc4-4280b0abe15a@oracle.com>
Date: Mon, 19 Jun 2017 15:32:39 +0800
MIME-Version: 1.0
In-Reply-To: <CA+AKrqAELw+C+XwrsweD=j6aB45_YMey5XLVsxcnQmOjQ=J+yA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks! for suggesting Jason. More below.

On 06/19/2017 07:15 AM, Jason Detring wrote:
> Hello list,
> 
> I'd like to request a new feature:  make zlib compression level a tuneable.
> 
> The general use-case is a device where CPU cycles are "cheap enough",
> but backing storage is expensive or difficult-to-replace.   An example
> might be a powerful embedded system with eMMC that can't be swapped
> for a larger part.
> 
> My particular case is re-purposing a Wyse Z-class thin client as a
> desktop.  It has an AMD 1.5 Ghz G-series CPU (G-T52R) paired with a 2
> GB SATA Disk-on-Module.   1.7 GB is usable for the rootfs after
> partitioning.   Using Btrfs zlib compression and data+metadata mixed
> mode I've stuffed most of a nicely outfitted Slackware desktop on it
> (~3.5 GB), but have bumped into a filled disk a time or two.
> 
> An experiment in replacing
>     zlib_deflateInit(&workspace->strm, 3)
> with
>     zlib_deflateInit(&workspace->strm, Z_BEST_COMPRESSION)
> and then recompressing the filesystem ("btrfs fi defrag -czlib -v -r
> /") has yielded an increase in free space from 125 MB to 215 MB.
> That's an increase of 90 MB!   Not to mention that new items stored in
> that newly freed space will also be compressed at maximum effort.
> For a tight disk, that is a huge win!   Desktop usability is not
> greatly impacted.

   Nice. This makes sense to me.


>  Large writes such as software upgrades are slower,
> but small day-to-day desktop writes such as web browser cache
> insertions are swallowed up by Linux's disk buffers and never felt to
> any great degree.  I haven't perceived any change in time spent
> decompressing reads for anything--maybe a cold X11 startup is slower?

> I'm not familiar with Btrfs internals.  I don't know how to add this
> as a tuneable myself.  It's easy to stuff a number in a function call
> to test a theory, but I can foresee this needing a bit more care to be
> added into the code.

> Perhaps as a knob that can be adjusted on a live filesystem.

> Perhaps as a property somewhere so that other
> mounted btrfses (a USB flash drive, for example) are not subject to
> the same time-space trade-off conclusion.

>  Perhaps all the way down
> to the node level so it can be inherited from a parent directory
> differently than other directories on the same file system.

  This should be a subvol property. I am attempting to write one.

  As of now we do not have the facility to make two properties
  depending on each other. We would need such a feature if
  we are creating a new property just for the compression ratio.
  And such a type of depending properties will also help encryption
  (not fs/crypto) in the long term. Will think on how to do that.

  But, other easy way to do this will be to modify the compression
  property which will also accept the compression-ratio in the input.
  For example:
    btrfs prop set <subvol> compression zlib:8
    mount -o compress=zlib:8 /dev/sdb /btrfs

  (In mount its compress and in property its compression, IMO we
  should use common names).


Thanks, Anand
