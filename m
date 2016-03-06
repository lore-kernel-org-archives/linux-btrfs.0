Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35188 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbcCFOCr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Mar 2016 09:02:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1acZGd-0002QV-F5
	for linux-btrfs@vger.kernel.org; Sun, 06 Mar 2016 15:02:43 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 15:02:43 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 15:02:43 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid
Date: Sun, 6 Mar 2016 14:02:38 +0000 (UTC)
Message-ID: <pan$77bad$4a5f81ec$4b6f7ef6$12196f5c@cox.net>
References: <CAO2Nr8dqVBiOSTLxdS-E_WoKk13mJkGJ9PB7qOBDq-1YhHi-Gg@mail.gmail.com>
	<20160301162758.GA27786@carfax.org.uk>
	<CAGfcS_nXei2FszQz_-HoeOi04vhWw9YF3LKwd+2zRxmW1Wiupw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Sun, 06 Mar 2016 07:01:00 -0500 as excerpted:

> On Tue, Mar 1, 2016 at 11:27 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>
>>    Definitely don't use parity RAID on 3.19. It's not really something
>> I'd trust, personally, even on 4.4, except for testing purposes.
> 
> ++ - raid 5/6 are fairly unstable at this point.  Raid 1 should be just
> fine.
> 
>>    TBH, I wouldn't really want to be running something as old as 3.19
>> either. The actual problems of running older kernels are, IME,
>> considerably worse than the perceived problems of upgrading.
> 
> I think it depends on how you define "old."  I think that 3.18.28 would
> be fine as it is a supported longterm.  I've just upgraded to the 4.1
> series which I plan to track until a new longterm has been out for a few
> months and things lok quiet.
> 
> 3.19 is very problematic though, as it is no longer supported.  I'd
> sooner "downgrade" to 3.18.28 (which likely has more btrfs backports
> unless your distro handles them).  Or, upgrade to 4.1.19.
> 
> If you are using highly experimental features like raid5 support on
> btrfs then bleeding-edge is probably better, but I've found I've had the
> fewest issues sticking with the previous longterm.  I've been bitten by
> a few btrfs regressions over the years and I think 3.19 was actually
> around the time I got hit by one of them.  Since I've switched to just
> staying on a longterm once it hits the x.x.15 version or so I've found
> things to be much more reliable.

Agreed.

The two generally recommended kernel tracks are current and long-term 
stable.  If you choose current, staying within the last two releases is 
recommended.  That's 4.3 or 4.4 at this point, tho 4.3 is getting a bit 
long in the tooth and 4.5 is close to release (I upgraded to it between 
rc5 and rc6).

For some time, the LTS track was also the last couple releases, which 
with 4.4 being LTS, would be it or 4.1, but the previous LTS 3.18 has 
been fairly stable as well, and as long as you're not trying to run 
parity raid, there hasn't been a hugely pressing reason to recommend 
upgrading for those who prefer to play things conservative.

But older than 3.18 LTS is definitely not recommended, and 3.19 isn't LTS 
and is long out of standard support so isn't recommended either.  Neither 
are 4.0 and 4.2 as they too are out of support.

And parity raid is still unstable enough that you really need to be on 
latest current for it, for another couple kernel series anyway.  Once it 
stabilizes, it's likely 4.4 will be the first LTS series considered 
stable for parity raid, and hopefully 4.6 will do it, but as of now, 
there's at least one more bug that hasn't been traced, whereby restriping 
to cover changes in the number of devices takes about 10 times longer 
than it should, and if that change in the number of devices is due to a 
device failure, that means a window during which additional device 
failures isn't covered also 10 times longer than it should be.  Not good 
for the life of your data, for sure!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

