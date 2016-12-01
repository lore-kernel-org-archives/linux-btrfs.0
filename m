Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60154 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbcLAHED (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 02:04:03 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cCL9u-0006VQ-6E
        for linux-btrfs@vger.kernel.org; Thu, 01 Dec 2016 07:47:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Convert from RAID 5 to 10
Date: Thu, 1 Dec 2016 06:47:47 +0000 (UTC)
Message-ID: <pan$8dacd$8d489a52$c14c4613$c5dd0426@cox.net>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
        <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
        <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
        <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com>
        <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
        <b13f13a4-639d-d460-7642-c8f8fe646832@googlemail.com>
        <19671a71-5d1c-c42e-db3d-c870ec08b2ff@gmail.com>
        <e9a4cba5-53b7-b6f0-af83-467f5f95f5b8@googlemail.com>
        <21e6765c-21f9-1726-b06f-9bd5f67c7b49@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 30 Nov 2016 11:48:57 -0500 as
excerpted:

> On 2016-11-30 10:49, Wilson Meier wrote:

>> Do you also have all home users in mind, which go to vacation (sometime
>>> 3 weeks) and don't have a 24/7 support team to replace monitored disks
>> which do report SMART errors?

> Better than 90% of people I know either shut down their systems when
> they're going to be away for a long period of time, or like me have ways
> to log in remotely and tell the FS to not use that disk anymore.

https://btrfs.wiki.kernel.org/index.php/Getting_started ...

... has two warnings offset in red right in the first section:

* If you have btrfs filesystems, run the latest kernel.

* You should keep and test backups of your data, and be prepared to use 
them.

It also says:

The status of btrfs was experimental for a long time, but the the core 
functionality is considered good enough for daily use. [...]
While many people use it reliably, there are still problems being found.


Were I editing that or something very similar would be on the main 
landing page and as a general status announcement on the feature and 
profile status page.  However, it IS on the wiki.

As to the three weeks vacation thing...

And "daily use" != "three weeks without physical access to something 
you're going to actually be relying on for parts of those three weeks".

And "keep and test backups [and] be prepared to use them" != "go away for 
three weeks and leave yourself unable to restore from those backups, for 
something you're relying on over those three weeks", either.

As Austin says, many home users actually shut down their systems when 
they're going to be away, because they are /not/ going to be using them 
in that period, and *certainly* *don't* actually /rely/ on them.

And most of those that /do/ actually rely on them, have learned or will 
learn, possibly the hard way, that "things happen", and they need either 
someone that can be called to poke the systems if necessary, or 
alternative plans in case what they can't access ATM fails.

Meanwhile, arguably those who /are/ relying on their filesystems to be up 
and running for extended periods while they can't actually poke (or have 
someone else poke) the hardware if necessary, shouldn't be running btrfs 
as yet in the first place, as it's simply not stable and mature enough 
for that.  And people who really care about it will have done the 
research to know the stability status.  And people who don't... well, by 
not doing that research they've effectively defined it as not that 
important in their life, other things have taken priority.  So if btrfs 
fails on them and they didn't know it's stability status, it can only be 
because it wasn't that important to them that they know, so no big deal.

(I know for certain that before /I/ switched to btrfs, I scoured both the 
wiki and the manpages, as well as reading a number of articles on btrfs, 
and then still posted to this list a number of questions I had remaining 
after doing all that, and got answers I read as well, before I actually 
did my switch.  That's because it was my data at risk, data I place a 
high enough value on to want to know the risk at which I was placing it 
and the best way to deal with various issues I could anticipate possibly 
happening, before they actually happened.  And I actually did some of my 
own testing before final deployment, as well, satisfying myself that I 
/could/ reasonably deal with various hardware and software disaster 
scenarios, before putting any real data at risk, as well.

Of course I don't expect everyone to do all that, but then I don't expect 
everyone to place the value in their data that I do in mine.  Which is 
fine, as long as they're willing to live with the consequences of the 
priority they placed on appreciating and dealing appropriately with the 
risk factor on their data, based on the definition of value their actions 
placed on it.  If they're willing to risk the data because it's of no 
particular value to them anyway, well then, no such preliminary research 
and testing is required.  Indeed, it would be stupid, because they surely 
have more important and higher priority things to deal with.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

