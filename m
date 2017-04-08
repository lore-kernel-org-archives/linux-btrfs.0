Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46099 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdDHFMe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 01:12:34 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cwifd-0003A3-3G
        for linux-btrfs@vger.kernel.org; Sat, 08 Apr 2017 07:12:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Volume appears full but TB's of space available
Date: Sat, 8 Apr 2017 05:12:08 +0000 (UTC)
Message-ID: <pan$2e792$2cb39d1$9f52bd61$285d9133@cox.net>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
        <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
        <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
        <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
        <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
        <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
        <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Fri, 07 Apr 2017 07:41:22 -0400 as
excerpted:

> 2. Results from 'btrfs scrub'.  This is somewhat tricky because scrub is
> either asynchronous or blocks for a _long_ time.  The simplest option
> I've found is to fire off an asynchronous scrub to run during down-time,
> and then schedule recurring checks with 'btrfs scrub status'.  On the
> plus side, 'btrfs scrub status' already returns non-zero if the scrub
> found errors.

This is (one place) where my "keep it small enough to be in-practice-
manageable" comes in.

I always run my scrubs with -B (don't background, always, because I've 
scripted it), and they normally come back within a minute. =:^)

But that's because I'm running multiple btrfs pair-device raid1 on a pair 
of partitioned SSDs, with each independent btrfs built on a partition 
from each ssd, with all partitions under 50 GiB.  So scrubs takes less 
than a minute to run (on the under 1 GiB /var/log, it returns effectively 
immediately, as soon as I hit enter on the command), but that's not 
entirely surprising at the sizes of the ssd-based btrfs' I am running.

When scrubs (and balances, and checks) come back in a minute or so, it 
makes maintenance /so/ much less of a hassle. =:^)

And the generally single-purpose and relatively small size of each 
filesystem means I can, for instance, keep / (with all the system libs, 
bins, manpages, and the installed-package database, among other things) 
mounted read-only by default, and keep the updates partition (gentoo so 
that's the gentoo and overlay trees, the sources and binpkg cache, ccache 
cache, etc) and (large non-ssd/non-btrfs) media partitions unmounted by 
default.

Which in turn means when something /does/ go wrong, as long as it wasn't 
a physical device, there's much less data at risk, because most of it was 
probably either unmounted, or mounted read-only.

Which in turn means I don't have to worry about scrub/check or other 
repair on those filesystems at all, only the ones that were actually 
mounted writable.  And as mentioned, those scrub and check fast enough 
that I can literally wait at the terminal for command completion. =:^)

Of course my setup's what most would call partitioned to the extreme, but 
it does have its advantages, and it works well for me, which after all is 
the important thing for /my/ setup.

But the more generic point remains, if you setup multi-TB filesystems 
that take days or weeks for a maintenance command to complete, running 
those maintenance commands isn't going to be something done as often as 
one arguably should, and rebuilding from a filesystem or device failure 
is going to take far longer than one would like, as well.  We've seen the 
reports here.  If that's what you're doing, strongly consider breaking 
your filesystems down to something rather more manageable, say a couple 
TiB each.  Broken along natural usage lines, it can save a lot on the  
caffeine and headache pills when something does go wrong.

Unless of course like one poster here, you're handling double-digit-TB 
super-collider data files.  Those tend to be a bit difficult to store on 
sub-double-digit-TB filesystems.  =:^)  But that's the other extreme from 
what I've done here, and he actually has a good /reason/ for /his/
double-digit- or even triple-digit-TB filesystems.  There's not much to 
be done about his use-case, and indeed, AFAIK he decided btrfs simply 
isn't stable and mature enough for that use-case yet, tho I believe he's 
using it for some other, more minor and less gargantuan use-cases.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

