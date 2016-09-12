Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37015 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757251AbcILNOJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 09:14:09 -0400
Received: by mail-it0-f49.google.com with SMTP id 186so10686550itf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 06:14:09 -0700 (PDT)
Subject: Re: Is stability a joke?
To: Michel Bouissou <michel.bouissou@umontpellier.fr>
References: <57D51BF9.2010907@online.no> <20160911130221.GE7138@carfax.org.uk>
 <be04c51d-c35d-39fe-c5f7-a7ab13d72cc5@gmail.com> <13278997.DcMfnd2pLu@vajra>
Cc: Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
        Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f923a129-1097-8f89-049d-267840ccb205@gmail.com>
Date: Mon, 12 Sep 2016 09:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <13278997.DcMfnd2pLu@vajra>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 08:59, Michel Bouissou wrote:
> Le lundi 12 septembre 2016, 08:20:20 Austin S. Hemmelgarn a écrit :
>> FWIW, here's a list of what I personally consider stable (as in, I'm
>> willing to bet against reduced uptime to use this stuff on production
>> systems at work and personal systems at home):
>> 1. Single device mode, including DUP data profiles on single device
>> without mixed-bg.
>> 2. Multi-device … raid1, … with symmetrical
>> devices (all devices are the same size).
>> 4. Small numbers (max double digit) of snapshots, taken at infrequent
>> intervals (no more than once an hour).  I use single snapshots regularly
>> to get stable images of the filesystem for backups, and I keep hourly
>> ones of my home directory for about 48 hours.
>> 5. Subvolumes used to isolate parts of a filesystem from snapshots.  I
>> use this regularly to isolate areas of my filesystems from backups.
>> 6. Non-incremental send/receive (no clone source, no parent's, no
>> deduplication).  I use this regularly for cloning virtual machines.
>> 7. Checksumming and scrubs using any of the profiles I've listed above.
>> 8. Defragmentation, including autodefrag.
>> 9. All of the compat_features, including no-holes and skinny-metadata.
>
> I would also agree that all this is perfectly stable in my own experience. (I
> removed above what I didn’t personnally use, or didn’t use long enough to
> vouch for it).
FWIW, the multi-device single and raid0 profiles that I listed are not 
something I personally use, but I do include testing of them in my 
regular testing of BTRFS, and it's never hit anything unique to that 
configuration, so I'd be willing to use them if I had a use case for it. 
  The raid10 profile I have used in the past, but these days I usually 
run raid1 on top of LVM raid0 volumes, which gives the essentially the 
same net result, but with better performance and slightly better 
reliability (I can actually fix a double device loss in this 
configuration half the time, albeit with a lot of manual work).
>
>> Things I consider stable enough that I'm willing to use them on my
>> personal systems but not systems at work:
>> 1. In-line data compression with compress=lzo.  I use this on my laptop
>> and home server system.  I've never had any issues with it myself, but I
>> know that other people have, and it does seem to make other things more
>> likely to have issues.
>
> I never had problems with lzo compression, although I suspect that it (in
> conjuction with snapshots) adds much fragmentation that may relate to the
> extremely bad performance I get over time with mechanical HDs.
FWIW, the issues with compression in general (everyone talks about lzo 
compression, but almost nobody uses zlib even in testing, so we really 
have no indication that it doesn't have the same issue) seem to only be 
when there's lots of read errors on compressed data.  I usually replace 
my storage devices before they get to that point, so it makes sense that 
I've never seen any issues.
>
>> 2. Batch deduplication.
>
> Every time I tried to use any of the available dedup tools, either it
> immediately failed miserably, or it failed after eating all of my machine’s
> RAM. It didn’t eat my data, although.
Like I said, I only use it on one set of filesystems, and in this case, 
I've been using it through a script which finds files with duplicate 
data.  Instead of running duperemove over the whole filesystem, I use 
this script to call it directly on a list of files which have duplicate 
data, which speeds up the scanning phase in duperemove and really cuts 
down on the RAM usage, albeit at the cost of taking longer in the 
initial phase to find duplicates.  Some day I may post the script, but 
at the moment it looks horrible, isn't all that efficient itself, and 
has a couple of bugs that cause it to not reliably catch all the 
duplicated data, so I'm not too keen to share it in it's current 
condition.  The actual process itself isn't all that hard though, you 
can parse the output of diff to get the info, or you can do a manual 
block comparison like duperemove and use files to store the results to 
save on RAM usage.
