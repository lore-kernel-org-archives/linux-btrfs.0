Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50199 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbbJPEBT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 00:01:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZmwCd-0000aG-0G
	for linux-btrfs@vger.kernel.org; Fri, 16 Oct 2015 06:01:11 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 06:01:10 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 06:01:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: State of Dedup / Defrag
Date: Fri, 16 Oct 2015 04:01:00 +0000 (UTC)
Message-ID: <pan$1433c$c848cef6$10901216$d97ac9fa@cox.net>
References: <CAGfcS_kADCxYy2yvTsHLdTTk=OEpx8FyspRfhvjLhbCQwdspKw@mail.gmail.com>
	<20151014050916.GA4400@hungrycats.org>
	<CAGfcS_nBFR7-aBVcTgU=htQBDWjzQnB_ePpdWKESVx+x4nROpw@mail.gmail.com>
	<20151015024749.GB4400@hungrycats.org>
	<CAGfcS_kWLphBDrcg=AxTMsuqf5zOSigxpLrqU=h5VwfCp=ZUDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Thu, 15 Oct 2015 12:33:56 -0400 as excerpted:

> On Wed, Oct 14, 2015 at 10:47 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
>>
>> I wouldn't describe dedup+defrag as unsafe.  More like insane.  You
>> won't lose any data, but running both will waste a lot of time and
>> power. Either one is OK without the other, or applied to
>> non-overlapping sets of files, but they are operations with opposite
>> results.
> 
> That is probably why I disabled it then.  I now recall past discussion
> that defragging a file wasn't snapshot-aware, though I thought that was
> fixed.

Well, snapshot-aware defrag was indeed released... in 3.9 IIRC (it's on 
the wiki)...

Unfortunately, it didn't scale well /at/ /all/, as in spending half a day 
defragging just a handful of blocks. (Worst-case was many thousands of 
snapshots, with quotas enabled -- and this was back before the 
scalability work and quota code rewrites, so it was really **REALLY** 
bad!!111, and could be more like a day on a single block!)

Obviously that simply didn't work /at/ /all/, so in ordered to have a 
defrag that was at least semi-usable, snapshot awareness was disabled 
again, making things /so/ much simpler, but of course dramatically 
increasing the possible downsides of actually running defrag.

The disabling was in 3.12, IIRC, so defrag was only snapshot-aware for 
three kernel cycles, about seven months' worth of current development.

Since then defrag's snapshot-awareness has remained disabled, tho AFAIK 
the plan remains to enable it again, if/when the devs are satisfied that 
they've made the code efficient and scalable enough that it's still going 
to be actually runnable in practical time, into (I'd say) 5-digits worth 
of snapshots, anyway.  But that's going to necessarily involve stable 
quota code, and the quota code has been a continued problem tho there's 
some hope that it's coming together now, so it's anyone's guess when even 
the quota-code prerequisite is complete, let along if/when the 
scalability will then be reasonable enough, or if more work will still 
need to be done there... or if it'll _ever_ be practical to turn it back 
on.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

