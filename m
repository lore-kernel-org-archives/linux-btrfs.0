Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55656 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbbDFDVh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Apr 2015 23:21:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YexbR-0005Yn-IX
	for linux-btrfs@vger.kernel.org; Mon, 06 Apr 2015 05:21:33 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 05:21:33 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 05:21:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs hangs 3.19-10
Date: Mon, 6 Apr 2015 03:21:18 +0000 (UTC)
Message-ID: <pan$d8274$4104f220$c763dc8e$c4e4259e@cox.net>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
	<20150404130047.GC13864@carfax.org.uk>
	<pan$bf795$4bdcf130$e29eb18a$9b854964@cox.net>
	<201504050330.47299.russell@coker.com.au>
	<20150405100417.GE13864@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sun, 05 Apr 2015 10:04:17 +0000 as excerpted:

> On Sun, Apr 05, 2015 at 03:30:47AM +0000, Russell Coker wrote:
>> On Sun, 5 Apr 2015 03:16:21 AM Duncan wrote:
>> > Hugo Mills posted on Sat, 04 Apr 2015 13:00:47 +0000 as excerpted:
>> > > On Sat, Apr 04, 2015 at 12:55:08PM +0000, Russell Coker wrote:
>> > >> As an aside are there options to mkfs.btrfs that would make a
>> > >> filesystem mountable by kernel 3.2.65?  If so I'll file a
>> > >> Debian/Jessie bug report requesting that a specific mention be
>> > >> added to the man page.
>> > > 
>> > > Yes, there are. It's probably -O^extref, but if you can show the
>> > > dmesg output from the 3.2 kernel on the failed mount (so that it
>> > > shows what the actual failure was), we should be able to give you a
>> > > more precise answer.
>> 
>> [698190.987065] Btrfs loaded
>> [698190.999992] device fsid [...] devid 1 transid 426 /dev/sdf1
>> [698191.000981] btrfs: disk space caching is enabled
>> [698191.000986] BTRFS: couldn't mount because of unsupported
>> optional features (60).
> 
> That's these, I think:
> 
> #define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
> #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF    (1ULL << 6)
> 
> so it's definitely -O^extref. I don't see where big_metadata comes from,
> though. That's not a -O option.

Kernel-side, BTRFS_FEATURE_INCOMPAT_BIG_METADATA was added in 3.4.  It 
came with this code comment (retained thru 3.19 at least)

/*
 * older kernels tried to do bigger metadata blocks, but the
 * code was pretty buggy.  Lets not let them try anymore.
 */
#define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)


Git blame says commit 727011e0, which has this commit message:

commit 727011e07cbdf87772fcc1999cccd15cc915eb62
Author: Chris Mason <chris.mason@oracle.com>
Date:   Fri Aug 6 13:21:20 2010 -0400

    Btrfs: allow metadata blocks larger than the page size

    A few years ago the btrfs code to support blocks lager than
    the page size was disabled to fix a few corner cases in the
    page cache handling.  This fixes the code to properly support
    large metadata blocks again.

    Since current kernels will crash early and often with larger
    metadata blocks, this adds an incompat bit so that older kernels
    can't mount it.

    This also does away with different blocksizes for nodes and leaves.
    You get a single block size for all tree blocks.

    Signed-off-by: Chris Mason <chris.mason@oracle.com>


So...

3.2 would have had large metadata blocks disabled.  When they were 
enabled again in 3.4, the big-metadata incompat flag was added, to keep 
older kernels from even trying to mount them as they'd crash "early and 
often" if they did.

Back in the kernel 3.2 era, mkfs.btrfs had node and leaf size options, 
but the warning was not to attempt setting that manually unless you were 
creating a filesystem actually to be used on other hardware with a 
different page size, in which case, set that.

So metadata blocks were effectively forced to the 4096-byte page size.

Somewhere after the kernel was able to handle the larger metadata blocks 
again (I could look it up as I did the kernel code above, but meh...), 
the mkfs.btrfs default was upped to 16K, that being found to be much more 
efficient thru testing.

So... for 3.2 compatibility, extref must not be enabled (tho it's now the 
default and AFAIK there's no way to actually disable it, only enable, so 
an old btrfs-tools would have to be used that doesn't enable it by 
default), AND the nodesize must be set to page size, 4096 bytes for x86.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

