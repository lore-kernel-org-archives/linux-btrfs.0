Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34929 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756136AbdETCbG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 22:31:06 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dBuAR-0002b2-MP
        for linux-btrfs@vger.kernel.org; Sat, 20 May 2017 04:30:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID 6 corrupted
Date: Sat, 20 May 2017 02:30:48 +0000 (UTC)
Message-ID: <pan$f0a91$d5a6b148$d2f11d14$5118d69e@cox.net>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
        <pan$3156f$ad60295$88e5604$e6cc7e68@cox.net>
        <20170517101523.ylmw4qo2wjsnibfh@angband.pl>
        <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
        <20170518101719.6c9feabe@natsu> <pan$24de$e527cbb7$733b205c$f2415b2@cox.net>
        <20170519085527.GD24459@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pasi Kärkkäinen posted on Fri, 19 May 2017 11:55:27 +0300 as excerpted:

> On Thu, May 18, 2017 at 06:12:22AM +0000, Duncan wrote:
>> Roman Mamedov posted on Thu, 18 May 2017 10:17:19 +0500 as excerpted:
>> 
>> > On Thu, 18 May 2017 04:09:38 +0200 ??ukasz Wróblewski <lw@nri.pl>
>> > wrote:
>> > 
>> >> I will try when stable 4.12 comes out.
>> >> Unfortunately I do not have a backup.
>> >> Fortunately, these data are not so critical.
>> >> Some private photos and videos of youth.
>> >> However, I would be very happy if I could get it back.
>> > 
>> > Try saving your data with "btrfs restore" first
>> 
>> First post, he tried that.  No luck.  Tho that was with 4.4 userspace.
>> It might be worth trying with the 4.11-rc or soon to be released 4.11
>> userspace, tho...
>> 
>> 
> Try with 4.12-rc, I assume :)

No.  btrfs restore is 100% userspace, so we're talking btrfs-progs (thus 
the "userspace" specifier) version here, not kernel version.

And at the time 4.11-rc was the latest progs version, with 4.11 due 
within a day or two, so "4.11-rc or soon to be released 4.11 userspace" 
was correct.

Of course since then 4.11 userspace /has/ been released, so it'd be 4.11 
without the -rc, now.

(When I got the CCed email I couldn't make heads or tails since I was 
missing the thread context, tho the fact that I was dead tired probably 
didn't help.  I just checked the list, which I interface with as a 
newsgroup on gmane.org's list2news service, after getting home from work 
today, however, and there the entire thread is visible, as one would 
expect for a newsgroup, so I could make sense of the context, and realize 
it was a case of kernel version vs. userspace version confusion. Easy 
enough to clarify... =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

