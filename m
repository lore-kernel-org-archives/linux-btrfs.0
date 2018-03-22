Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58780 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbeCVI4i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 04:56:38 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1eyvzR-0000UB-Ak
        for linux-btrfs@vger.kernel.org; Thu, 22 Mar 2018 09:54:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Out of space and incorrect size reported
Date: Thu, 22 Mar 2018 08:54:22 +0000 (UTC)
Message-ID: <pan$3e3ce$2eec198f$28c68a6e$d9a54d5c@cox.net>
References: <4B67E3B8-BF96-43A5-9F0E-91B32496CE7E@indepth.com>
        <20180321215615.GE17966@carfax.org.uk>
        <471593AD-7540-44BE-9E16-E7804D5C44A3@indepth.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shane Walton posted on Thu, 22 Mar 2018 00:56:05 +0000 as excerpted:

>>>> btrfs fi df /mnt2/pool_homes
>>> Data, RAID1: total=240.00GiB, used=239.78GiB
>>> System, RAID1: total=8.00MiB, used=64.00KiB
>>> Metadata, RAID1: total=8.00GiB, used=5.90GiB
>>> GlobalReserve, single: total=512.00MiB, used=59.31MiB
>>> 
>>>> btrfs filesystem show /mnt2/pool_homes
>>> Label: 'pool_homes'  uuid: 0987930f-8c9c-49cc-985e-de6383863070
>>> 	Total devices 2 FS bytes used 245.75GiB
>>> 	devid    1 size 465.76GiB used 248.01GiB path /dev/sdaThe output 
from the (relatively new and thus possibly not yet in the old 4.4 you 
posted with above and upgraded from) btrfs filesystem usage command makes 
this somewhat clearer, tho 
>>> 	devid    2 size 465.76GiB used 248.01GiB path /dev/sdb
>>> 
>>> Why is the line above "Data, RAID1: total=240.00GiB, used=239.78GiB
>>> almost full and limited to 240 GiB when there is I have 2x 500 GB HDD?

>>> What can I do to make this larger or closer to the full size of 465
>>> GiB (minus the System and Metadata overhead)?

By my read, Hugo answered correctly, but (I think) not the question you 
asked.

The upgrade was certainly a good idea, 4.4 being quite old now and not 
really supported well here now, as this is a development list and we tend 
to be focused on new, not long ago history, but it didn't change the 
report output as you expected, because based on your question you're 
misreading it and it doesn't say what you are interpreting it as saying.

BTW, you might like the output from btrfs filesystem usage a bit better 
as it's somewhat clearer than the previously required (usage is a 
relatively new subcommand that might not have been in 4.4 yet) btrfs fi 
df and btrfs fi show, but understanding how btrfs works and what the 
reported numbers mean is still useful.

Btrfs does two-stage allocation.  First, it allocates chunks of a 
specific type, normally data or metadata (system is special, normally 
only one chunk so no more allocated, and global reserve is actually 
reserved from metadata and counts as part of it) from unused/unallocated 
space (which isn't shown by show/df, but usage shows it separately), then 
when necessary, btrfs actually uses space from the chunks it allocated 
previously.

So what the above df line is saying is that 240 GiB of space have been 
allocated as data chunks, and 239.78 GiB of that, almost all of it, is 
used.

But you should still have 200+ GiB of unallocated space on each of the 
devices, as here shown by the individual device lines of the show command 
(465 total, 248 used), tho as I said, btrfs filesystem usage makes that 
rather clearer.

And btrfs should normally allocate additional space from that 200+ gigs 
unallocated, to data or metadata chunks, as necessary.  Further, because 
btrfs can't directly take chunks allocated as data and reallocate them as 
metadata, you *WANT* lots of unallocated space.  You do NOT want all that 
extra space allocated as data chunks, because then they wouldn't be 
available to allocate as metadata if needed.

Now with 200+ GiB of space on each of the two devices unallocated, you 
shouldn't yet be running into ENOSPC (error no space) errors.  If you 
are, that's a bug, and there have actually been a couple bugs like that 
recently, but that doesn't mean you want btrfs to unnecessarily allocate 
all that unallocated space as data space, which would be what it did if 
it reported all that as data.  Rather, you need btrfs to allocate data, 
and metadata, chunks as needed, and any space related errors you are 
seeing would be bugs related to that.

Now that you have a newer btrfs-progs and kernel, and have read my 
attempt at an explanation above, try btrfs filesystem usage and see if 
things are clearer.  If not, maybe Hugo or someone else can do better 
now, answering /that/ question.  And of course if with the newer 4.12 
kernel you're getting ENOSPC errors, please report that too, tho be aware 
that 4.14 is the latest LTS series, with 4.9 the LTS before that, and as 
a normal non-LTS series kernel 4.12 support has ended as well, so you 
might wish to either upgrade to a current 4.14 LTS or downgrade to the 
older 4.9 LTS, for best support.

Or of course you could go with a current non-LTS.  Normally the latest 
two release series in both normal and LTS are best supported, so with 
4.15 out and 4.16 nearing release, that's the latest 4.15 stable release 
now, or 4.14, to be 4.16 and 4.15 at 4.16 release, or on the LTS track 
the previously mentioned 4.14 and 4.9 series, tho at a year old plus, 4.9 
is already getting rather harder to support, and 4.14 is old enough now 
it's preferred for LTS track.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

