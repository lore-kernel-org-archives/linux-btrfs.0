Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:36498 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdFRXPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Jun 2017 19:15:54 -0400
Received: by mail-vk0-f50.google.com with SMTP id y70so43317399vky.3
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Jun 2017 16:15:54 -0700 (PDT)
MIME-Version: 1.0
From: Jason Detring <detringj@gmail.com>
Date: Sun, 18 Jun 2017 19:15:52 -0400
Message-ID: <CA+AKrqAELw+C+XwrsweD=j6aB45_YMey5XLVsxcnQmOjQ=J+yA@mail.gmail.com>
Subject: Feature request: Tuneable zlib compression level
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I'd like to request a new feature:  make zlib compression level a tuneable.

The general use-case is a device where CPU cycles are "cheap enough",
but backing storage is expensive or difficult-to-replace.   An example
might be a powerful embedded system with eMMC that can't be swapped
for a larger part.

My particular case is re-purposing a Wyse Z-class thin client as a
desktop.  It has an AMD 1.5 Ghz G-series CPU (G-T52R) paired with a 2
GB SATA Disk-on-Module.   1.7 GB is usable for the rootfs after
partitioning.   Using Btrfs zlib compression and data+metadata mixed
mode I've stuffed most of a nicely outfitted Slackware desktop on it
(~3.5 GB), but have bumped into a filled disk a time or two.

An experiment in replacing
   zlib_deflateInit(&workspace->strm, 3)
with
   zlib_deflateInit(&workspace->strm, Z_BEST_COMPRESSION)
and then recompressing the filesystem ("btrfs fi defrag -czlib -v -r
/") has yielded an increase in free space from 125 MB to 215 MB.
That's an increase of 90 MB!   Not to mention that new items stored in
that newly freed space will also be compressed at maximum effort.
For a tight disk, that is a huge win!   Desktop usability is not
greatly impacted.  Large writes such as software upgrades are slower,
but small day-to-day desktop writes such as web browser cache
insertions are swallowed up by Linux's disk buffers and never felt to
any great degree.  I haven't perceived any change in time spent
decompressing reads for anything--maybe a cold X11 startup is slower?

I'm not familiar with Btrfs internals.  I don't know how to add this
as a tuneable myself.  It's easy to stuff a number in a function call
to test a theory, but I can foresee this needing a bit more care to be
added into the code.   Perhaps as a knob that can be adjusted on a
live filesystem.  Perhaps as a property somewhere so that other
mounted btrfses (a USB flash drive, for example) are not subject to
the same time-space trade-off conclusion.   Perhaps all the way down
to the node level so it can be inherited from a parent directory
differently than other directories on the same file system.   I'm not
sure how fine-grained the design needs to be.

Thanks!
Jason
