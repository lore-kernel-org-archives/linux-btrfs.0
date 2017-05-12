Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55291 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1757729AbdELCBl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 22:01:41 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d8ztX-0004BA-4p
        for linux-btrfs@vger.kernel.org; Fri, 12 May 2017 04:01:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: errno=-28 No space left, with kernel backtrace (blocking bug)
Date: Fri, 12 May 2017 02:01:20 +0000 (UTC)
Message-ID: <pan$20f7a$c3e419e4$7d304de2$d7bbcf23@cox.net>
References: <b780be0e-a8cf-ccb8-b6e1-0563ec9c5910@first-world.info>
        <003dca87-5ed1-4095-3bcf-c975543cd3ab@first-world.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

alpha_one_x86 posted on Thu, 11 May 2017 17:25:32 +0200 as excerpted:

> Up plz, I can work with this bug.
> 
> 
> On 05/11/17 01:39, alpha_one_x86 wrote:
>> Hi, this bug is very blocking for me:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=195257
>>
>> The server is backup server, I btrfs receive (with and without -p), and
>> of course btrfs subvolume delete The volume is 70TB, then I use
>> space_cache=v2

Since you can work with it, do so.  We're not stopping you. =:^)

Or did you mean /can't/?

Keep in mind that while btrfs is considered stabilizing, on this list at 
least it's not considered fully stable and mature.  If you want/need a 
filesystem that's stable and mature, there's others out there that fill 
that requirement.  We don't claim btrfs does.  Your system, your choice 
of filesystem and with it, filesystem maturity.

Meanwhile, btrfs devs have a lot of stuff on their plate, including bugs 
they're already working on and further development, and (as with most 
devs) aren't going to take kindly to demands that they work on *YOUR* bug 
*RIGHT* *NOW*.  That, if anything, is about the fastest way I know of to 
ensure that working on it is /deprioritized/, with stuff that would have 
been put off to work on it, done first, instead.

Unless of course you're paying the salary of that dev.  If you are, then 
you get to call the shots, to some degree at least.  Good devs tend to 
find other employment if you're too controlling, tho, and they can 
because good devs are in enough demand they often pick their jobs from a 
list of offers, and they tend to be motivated by more than money so if 
you're too demanding you can't expect to simply outbid everyone else on 
the list, either, no matter how much money you have.  And any dev skilled 
enough to regularly get their work into the mainline kernel can be 
considered a good dev, so...

So I'd suggest that if it's high enough priority to you, you'll find a 
kernel dev and sponsor them to work on it for you.  But be warned, if 
they're not already a btrfs dev, it'll take them some time to come upto 
speed.  Otherwise, you'll wait in line with everyone else... unless you 
push too much, in which case your reports will as I said get 
deprioritized, and if noone else reports them, your bugs may not get 
handled until there's nothing else waiting... which could easily push 
resolution past 2027... yes, a decade or more out.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

