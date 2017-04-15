Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35075 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdDOBlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 21:41:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1czCiW-0003sk-0W
        for linux-btrfs@vger.kernel.org; Sat, 15 Apr 2017 03:41:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Encountered kernel bug#72811. Advice on recovery?
Date: Sat, 15 Apr 2017 01:41:28 +0000 (UTC)
Message-ID: <pan$5f10d$2c1e5c86$a2062192$8e2ab6b@cox.net>
References: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
        <pan$29c2d$faf1fff7$a4518780$dbb0b61@cox.net>
        <CAN05THTcoQ6zLrDaVmoZ=pUQ3oMxU8EvYrz8TcUGOAo6a=5qHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ronnie sahlberg posted on Fri, 14 Apr 2017 09:56:30 -0700 as excerpted:

> On Thu, Apr 13, 2017 at 8:47 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Ank Ular posted on Thu, 13 Apr 2017 14:49:41 -0400 as excerpted:
> ...
>> OK, I'm one of the ones that's going to "go off" on you, but FWIW, I
>> expect pretty much everyone else would pretty much agree.  At least you
>> do have backups. =:^)
>>
>> I don't think you appreciate just how bad raid56 is ATM.  There are
>> just too many REALLY serious bugs like the one you mention with it, and
>> it's actively NEGATIVELY recommended here as a result.  It's bad enough
>> with even current kernels, and the problems are well known enough to
>> the devs,
>> that there's really not a whole lot to test ATM...
> 
> Can we please hide the ability to even create any new raid56 filesystems
> behind a new flag :
> 
> --i-accept-total-data-loss
> 
> to make sure that folks are prepared for how risky it currently is. That
> should be an easy patch to the userland utilities.

The biggest problem with such a flag in general is that people often use 
a kernel and userland that are /vastly/ out of sync, version-wise.  Were 
such a flag to be introduced, people would still be seeing it five years 
or more after it no longer applied to the kernel they're using (because 
the kernel's what actually does the work in many cases, including scrub).

Even making such a warning conditional on kernel version is problematic, 
because many distros backport major blocks of code, including perhaps 
btrfs fixes, and the nominally 3.14 or whatever kernel may actually be 
running btrfs and other fixes from 4.14 or later, by the time they 
actually drop support for whatever LTS distro version and quit backporting 
fixes.

Besides which, if the patch was submitted now, the earliest it could 
really hit btrfs-progs would be 4.12, and by the time people actually get 
that in their distro they may well be on 4.13 or 4.15 or whatever, and 
the patches fixing raid56 mode to actually work may already be in place.

The only place such a warning really works is on the wiki at
https://btrfs.wiki.kernel.org , because that's really the only place that 
can be updated to current status in a realistic timeframe.  And there's 
already a feature maturity matrix there, with raid56 mode marked 
appropriately, last I checked.

Meanwhile, it can be argued that admins (and anyone making the choice of 
filesystem and device layout they're going to run is an admin of those 
systems, even if they're just running them at home for their own use) who 
don't care enough about the safety of their data to actually research the 
stability of the filesystem and filesystem features they plan to use... 
really don't value that data very highly in the first place.  And the 
status is out there both on this list and on the wiki, so even a trivial 
google should find it without issue.

Indeed:  https://www.google.com/search?q=btrfs+raid56+stability



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

