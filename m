Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37444 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753880AbdEQJwo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 05:52:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dAvdE-0007nB-4F
        for linux-btrfs@vger.kernel.org; Wed, 17 May 2017 11:52:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID 6 corrupted
Date: Wed, 17 May 2017 09:52:28 +0000 (UTC)
Message-ID: <pan$3156f$ad60295$88e5604$e6cc7e68@cox.net>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Łukasz Wróblewski posted on Wed, 17 May 2017 10:27:53 +0200 as excerpted:

> About two years ago I created RAID 6 consisting of 5 disks with BTRFS.
> One of the disks has crashed.
> I started to exchange it for another, but I did something wrong.
> Or at the time, RAID56 support was experimental in BTRFS.
> There was a situation where I could not mount the partition again.
> 
> I decided to put the disks aside and wait for the better tools.
> A newer version of BTRFS in the hope that I can retrieve the data.
> 
> Currently the situation looks like this:
>  ~ # uname -a
> Linux localhost 4.10.12-coreos

For anything raid56 related, you'll need at /least/ 4.11, as it has some 
major raid56 stability patch updates.

There's still some issues with raid56, the biggest being that unlike most 
of btrfs, the parity isn't COW, meaning the traditional parity-raid write 
hole remains as an issue, a BIG issue for btrfs due to its design, but 
that's not really fixable without a full raid56 rewrite, so it'll remain 
the case with the existing raid56 mode likely forever, and a new 
implementation that COWs parity as well may eventually happen.

But the patches that went into 4.11 fix the known existing issues other 
than the usual write hole, and they're effectively mandatory for any 
attempt at repair or recovery of existing raid56 once there are issues of 
any sort.  They're not a guarantee of a fix, but before that, any attempt 
at a fix has a rather good chance of making the problem worse instead of 
better, so you really do want 4.11 if you're doing btrfs raid56 at all.

Beyond that, I'll let others more familiar with btrfs raid56 help, but 
I'd still not recommend it, even with those fixes.  IMO, the existence of 
the parity-raid write hole simply doesn't work well with btrfs general 
assumptions, and can't and won't work well until there's a COW-parity 
based btrfs parity-raid solution, so even with those fixes I wouldn't use 
it myself, nor can I in good faith recommend it to others.

The best I could recommend is getting off of it, possibly by blowing away 
the existing btrfs raid56 mode filesystem and recreating as whatever, 
then restoring from backups.  Of course if you didn't have backups of 
data on a known experimental btrfs raid56 mode, then as is always the 
case even on mature filesystems on known good hardware, but even more so 
given the experimental nature of btrfs raid56, you were deliberately 
defining the data as not worth the time and trouble to do the backups, so 
there's nothing really to lose by doing that, since you already saved 
what you self-evidently considered more important, the time and resources 
you would have otherwise put into doing that backup and keeping it 
current.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

