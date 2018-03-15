Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40910 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbeCOJAn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 05:00:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1ewOiX-00008Z-OC
        for linux-btrfs@vger.kernel.org; Thu, 15 Mar 2018 09:58:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid1 volume stuck as read-only: How to dump, recreate and
 restore its content?
Date: Thu, 15 Mar 2018 08:58:26 +0000 (UTC)
Message-ID: <pan$ac0e3$6a5ebef0$a6113417$246d8e12@cox.net>
References: <CAEm4ggntj1ccp6PXvECDVrj0_RXrzn6fX7mu+CWtHNwCAoXbvg@mail.gmail.com>
        <20180311174713.53tqlmjn6t3d4gwh@angband.pl>
        <pan$16a8$693752e8$556456d2$4e57d94b@cox.net>
        <7f9921b0-8f66-b070-7599-8750160649dd@siedziba.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Piotr Pawłow posted on Tue, 13 Mar 2018 08:08:27 +0100 as excerpted:

> Hello,
>> Put differently, 4.7 is missing a year and a half worth of bugfixes
>> that you won't have when you run it to try to check or recover that
>> btrfs that won't mount! Do you *really* want to risk your data on bugs
>> that were after all discovered and fixed over a year ago?
> 
> It is also missing newly introduced bugs. Right now I'm dealing with
> btrfs raid1 server that had the fs getting stuck and kernel oopses due
> to a regression:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=198861
> 
> I had to cherry-pick commit 3be8828fc507cdafe7040a3dcf361a2bcd8e305b and
> recompile the kernel to even start moving the data off the failing
> drive, as the fix is not in stable yet, and encountering any i/o error
> would break the kernel. And now it seems the fs is corrupted, maybe due
> to all the crashes earlier.
> 
> FYI in case you decide to switch to 4.15

In context I was referring to userspace as the 4.7 was userspace btrfs-
progs, not kernelspace.

For kernelspace he was on 4.9, which is the second-newest LTS (long-term-
stable) kernel series, and thus should continue to be at least somewhat 
supported on this list for another year or so, as we try to support the 
two newest kernels from both the current and LTS series.  Tho 4.9 does 
lack the newer raid1 per-chunk degraded-writable scanning feature, and 
AFAIK that won't be stable-backported as it's more a feature than a bugfix 
and as such, doesn't meet the requirements for stable-series backports.  
Which is why Adam recommended a newer kernel, since that was the 
particular problem needing addressed here.

But for someone on an older kernel, presumably because they like 
stability, I'd suggest the newer 4.14 LTS series kernel as an upgrade, 
not the only short-term supported 4.15 series... unless the intent is to 
continue staying current after that, with 4.16, 4.17, etc.  Which your 
point about newer kernels coming with newer bugs in addition to fixes 
supports as well.  Moving to the 4.14 LTS should get the real fixes and 
the longer stabilization time, tho not the feature adds, which would 
bring a higher chance of more bugs, as well.

And with 4.15 out for awhile now and 4.16 close, 4.14 should be 
reasonably stabilizing by now and should be pretty safe to move to.

But of course there's some risk of new bugs in addition to fixes for 
newer userspace versions too.  But since it's kernelspace that's the 
operational code and userspace is primarily recovery, and we know that 
older bugs ARE fixed in newer userspace, and assuming a sane backups 
policy which I stressed in the same post (if you don't have a backup, 
you're defining the data as of less value than the time/trouble/resources 
to create the backup, thus defining it as of relatively low/trivial value 
in the first place, because you're more willing to risk losing it than 
you are to spend the time/resources/hassle to ensure against that risk), 
the better chance at an updated userspace being able to fix problems with 
less risk of further damage really does justify considering updating to 
reasonably current userspace.  If there's any doubt, stay a version or 
two behind the latest release and watch for reports of problems with the 
latest, but certainly, with 4.15 userspace out and no serious reports of 
new damage from 4.14 userspace, the latter should now be a reasonably 
safe upgrade.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

