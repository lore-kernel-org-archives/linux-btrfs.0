Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52787 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab3ICQIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 12:08:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VGt9h-0006x6-2S
	for linux-btrfs@vger.kernel.org; Tue, 03 Sep 2013 18:08:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 18:08:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 18:08:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recovering from csum errors
Date: Tue, 3 Sep 2013 16:08:18 +0000 (UTC)
Message-ID: <pan$7dd78$5704ef42$348d7f12$25b893cf@cox.net>
References: <20130902220006.GA6389@carfax.org.uk> <
	pan$97a5$71cfb7f0$286a61f9$62ed2e15@cox.net> <
	CAA1QwTbiYGWpxctxOrF67wOzdAr6U6TKR__HZW44c2q9XeVM2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David MacKinnon posted on Tue, 03 Sep 2013 19:26:10 +1000 as excerpted:

> On 3 September 2013 18:54, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> > In case the data is wrong, there may be a reverse CRC32 algorithm
>> > implemented. Most likely it's only several bytes which got "flipped".
>>
>> But... that flips the entire reason for choosing direct-IO in the first
>> place -- performance -- on its head, incurring a **HUGE** slowdown just
> 
> Not wanting to put words in the original posters mouth, but I read that
> as an offline recovery method (scrub?), rather than real time recovery
> attempts. If the frequency of errors is low, then for certain purposes
> accepting, a few errors if you had a recovery option might be
> acceptable.

You might be right.  Tho there's already scrub available... it just 
requires a second, hopefully valid, copy to work from.  Which is what 
btrfs raid1 mode is all about, and why I chose to run it. =:^)

It would be nice to be able to say accept the invalid data, if it's not 
deemed critical and isn't so corrupted it's entirely invalid, which was 
something the poster suggested.  And in a way, that's what nocow does, by 
way of nosum; it just has to be setup before the fact; there's 
(currently) no way to make it work after the damage has occurred.

But I don't believe brute-forcing a correct crc match to be as 
necessarily feasible as the poster suggested as another alternative.  And 
even if a proper match is found, what's to say it's the /correct/ match?

Meanwhile, even if brute-forcing a match /is/ possible, in this 
particular case, it'd likely crash the VM or otherwise cause at the very 
least invalid results if not horrible VM corruption, because the written 
data was very likely correct, just changed after btrfs calculated the 
checksum.  So changing it back to what btrfs calculated the checksum on, 
even if possible, would actually corrupt the data from the VM's 
perspective, and then the VM would be acting on that corrupt data, which 
would certainly have unexpected and very possibly horribly bad results.

> As mentioned, nocow is probably best for VM images anyhow, but still :)

Agreed on that.  If the VM insists on breaking the rules and scribbling 
over its own data, just don't do the checksumming and LET it scribble 
over its own data if that's what it wants to do and as long as it doesn't 
try to scribble over anything that's NOT its data to scribble over.  If 
it breaks in pieces as a result, it gets to keep 'em. =:^\

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

