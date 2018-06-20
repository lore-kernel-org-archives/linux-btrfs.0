Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56650 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbeFTMfU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:35:20 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fVcII-00049T-Tk
        for linux-btrfs@vger.kernel.org; Wed, 20 Jun 2018 14:33:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID56
Date: Wed, 20 Jun 2018 12:32:56 +0000 (UTC)
Message-ID: <pan$b4093$530d6fbe$2b899612$2a7bbfaa@cox.net>
References: <CAJH6TXhoL+HLEp8ioMMt06fvykEjM3Usq7OMAk9VwpcsfTBHpA@mail.gmail.com>
        <pan$5b36b$e29a9693$2c5705da$6ebdcc0d@cox.net>
        <CAJH6TXg4jJ0nD1dkWAm-oSLjQrvaTaWJYAbtuDTWdGnK0S_H8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gandalf Corvotempesta posted on Wed, 20 Jun 2018 11:15:03 +0200 as
excerpted:

> Il giorno mer 20 giu 2018 alle ore 10:34 Duncan <1i5t5.duncan@cox.net>
> ha scritto:
>> Parity-raid is certainly nice, but mandatory, especially when there's
>> already other parity solutions (both hardware and software) available
>> that btrfs can be run on top of, should a parity-raid solution be
>> /that/ necessary?
> 
> You can't be serious. hw raid as much more flaws than any sw raid.

I didn't say /good/ solutions, I said /other/ solutions.
FWIW, I'd go for mdraid at the lower level, were I to choose, here.

But for a 4-12-ish device solution, I'd probably go btrfs raid1 on a pair 
of mdraid-0s.  That gets you btrfs raid1 data integrity and recovery from 
its other mirror, while also being faster than the still not optimized 
btrfs raid 10.  Beyond about a dozen devices, six per "side" of the btrfs 
raid1, the risk of multi-device breakdown before recovery starts to get 
too high for comfort, but six 8 TB devices in raid0 gives you up to 48 TB 
to work with, and more than that arguably should be broken down into 
smaller blocks to work with in any case, because otherwise you're simply 
dealing with so much data it'll take you unreasonably long to do much of 
anything non-incremental with it, from any sort of fscks or btrfs 
maintenance, to trying to copy or move the data anywhere (including for 
backup/restore purposes), to ... whatever.

Actually, I'd argue that point is reached well before 48 TB, but the 
point remains, at some point it's just too much data to do much of 
anything with, too much to risk losing all at once, too much to backup 
and restore all at once as it just takes too much time to do it, just too 
much...  And that point's well within ordinary raid sizes with a dozen 
devices or less, mirrored, these days.

Which is one of the reasons I'm so skeptical about parity-raid being 
mandatory "nowadays".  Maybe it was in the past, when disks were (say) 
half a TB or less and mirroring a few TB of data was resource-
prohibitive, but now?

Of course we've got a guy here who works with CERN and deals with their 
annual 50ish petabytes of data (49 in 2016, see wikipedia's CERN 
article), but that's simply problems on a different scale.

Even so, I'd say it needs broken up into manageable chunks, and 50 PB is 
"only" a bit over 1000 48 TB filesystems worth.  OK, say 2000, so you're 
not filling them all absolutely full.

Meanwhile, I'm actually an N-way-mirroring proponent, here, as opposed to 
a parity-raid proponent.  And at that sort of scale, you /really/ don't 
want to have to restore from backups, so 3-way or even 4-5 way mirroring 
makes a lot of sense.  Hmm... 2.5 dozen for 5-way-mirroring, 2000 times, 
2.5*12*2000=... 60K devices!  That's a lot of hard drives!  And a lot of 
power to spin them.  But I guess it's a rounding error compared to what 
CERN uses for the LHC.

FWIW, N-way-mirroring has been on the btrfs roadmap, since at least 
kernel 3.6, for "after raid56".  I've been waiting awhile too; no sign of 
it yet so I guess I'll be waiting awhile longer.  So as they say, 
"welcome to the club!"  I'm 51 now.  Maybe I'll see it before I die.  
Imagine, I'm in my 80s in the retirement home and get the news btrfs 
finally has N-way-mirroring in mainline.  I'll be jumping up and down and 
cause a ruckus when I break my hip!  Well, hoping it won't be /that/ 
long, but... =;^]

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

