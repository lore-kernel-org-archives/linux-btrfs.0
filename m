Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53493 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S941236AbcIZCVz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 22:21:55 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1boLY0-0005Yt-Tg
        for linux-btrfs@vger.kernel.org; Mon, 26 Sep 2016 04:21:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unable to handle kernel paging request - btrfs
Date: Mon, 26 Sep 2016 02:21:22 +0000 (UTC)
Message-ID: <pan$b52da$3be1bbf5$8f186275$d22036bc@cox.net>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
        <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net>
        <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Sun, 25 Sep 2016 09:55:42 -0400 as excerpted:

> On Fri, Sep 23, 2016 at 12:58 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> Btrfs raid1 you say, and you have existing compressed files it's trying
>> to read in the backtrace?
>>
>> Sounds like the issues I see sometimes and have posted about where
>> after a crash that resulted in one device of my raid1 pair getting
>> behind the other, the kernel will crash if it sees too many
>> csum-errors, even tho it's /supposed/ to check the other copy and read
>> from it if valid (which it is as a btrfs scrub resolves the issue).
>>
>> When booted to rescue/single-user mode, can you run a scrub?
> 
> After a few reboots trying to capture the initial panic message (even
> when I set panic_on_oops=1 I was getting multiple ones with only the
> tainted one staying on screen), the system managed to stay up.  I
> completed a scrub and it found no errors.

Well, so much for that theory.  If it found and fixed errors you'd likely 
be seeing the same problem I see sometimes, but if it didn't find any to 
fix... unlikely.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

