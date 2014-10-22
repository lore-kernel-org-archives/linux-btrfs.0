Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48892 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbaJVCIf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 22:08:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XglLl-0000SH-Ee
	for linux-btrfs@vger.kernel.org; Wed, 22 Oct 2014 04:08:33 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 04:08:33 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 04:08:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Poll: time to switch skinny-metadata on by default?
Date: Wed, 22 Oct 2014 02:08:21 +0000 (UTC)
Message-ID: <pan$19856$ee791297$ceeef1ce$27ae8dc@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net>
	<CAGfcS_nTbXQQTOC+QcBX8dbwk18Qbf-+JonQSw4WP6MOFg2z7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Tue, 21 Oct 2014 12:40:01 -0400 as excerpted:

> On Tue, Oct 21, 2014 at 5:29 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> David Sterba posted on Mon, 20 Oct 2014 18:34:03 +0200 as excerpted:
>>
>>> On Thu, Oct 16, 2014 at 01:33:37PM +0200, David Sterba wrote:
>>>> I'd like to make it default with the 3.17 release of btrfs-progs.
>>>> Please let me know if you have objections.
>>>
>>> For the record, 3.17 will not change the defaults. The timing of the
>>> poll was very bad to get enough feedback before the release. Let's
>>> keep it open for now.
>>
>> FWIW my own results agree with yours, I've had no problem with skinny-
>> metadata here, and it has been my default now for a couple
>> backup-and-new-
>> mkfs.btrfs generations, now.
>>
>>
> How does one enable it for an existing filesystem?  Is it safe to just
> run btrfstune -x?  Can this be done on a mounted filesystem?  Are there
> any risks with converting?

AFAIK, enabling skinny-metadata with btrfstune simply enables it for 
future metadata commits.  It doesn't change existing metadata.  However, 
with skinny-metadata enabled, doing a balance start -m will rewrite 
existing metadata, thus converting it to skinny if it wasn't skinny 
before.

Since the kernel has code for both "fat" metadata and skinny-metadata, 
they can exist side-by-side and the kernel will use whichever code is 
appropriate.  And since (afaik) a balance effects conversion of existing 
metadata by simply rewriting it using the same metadata writing paths 
it'd normally use only now on the skinny-metadata side, there should be 
no additional risk to that, either.

The narrow-case additional risk there is would be due to the fact that 
the code paths are different, and while both paths have been well 
exercised by now with no bugs related to those specific code paths in 
awhile, in theory anyway, it's narrowly possible that an individual 
installation's use-case and data happened to work just fine on the 
available metadata, but will trigger some exotic and as yet unseen bug 
when you switch to skinny-metadata and thus exercise the other code-
path.  I'd call the risk of that nonzero but extremely unlikely.  

IOW, if you're familiar with Douglas Adams' Hitchhiker's Guide series, 
it's almost the kind of probability that you'd need an improbability 
drive to hit. =:^)  

If not, compare it to winning the lottery or getting struck by 
lightening, yes, people do sometimes do it, but it's not something you 
should plan your life around, particularly if you aren't in the habit of 
playing golf and sticking a club in the air, in the middle of a lightning 
storm! =:^)

And if you're adverse to that sort of odds, why are you playing with 
still not entirely stable btrfs at this point, anyway?

As for the mounted filesystem question, since all it does is flip a 
switch so that new metadata writes use the skinny-metadata code path, it 
shouldn't be a problem.  However, I'd probably do it on an unmounted 
filesystem here, simply because there's no reason to tempt fate... unless 
your goal is to see what happens, of course. =:^)

Matter of fact, personally, since I tend to periodically backup, do a 
fresh mkfs.btrfs with the new features I want enabled, and restore, I've 
never actually used btrfstune for this myself, either.  But that's more a 
matter of that being the most convenient time to switch it over since I'm 
already doing the fresh mkfs anyway, than because I'm being overly 
cautious.  Still, for those with a similar btrfs rotation system already 
in place, why tempt fate, unless of course your whole /object/ is a 
deliberate test and tempt of fate?

BTW...

@ Dave Sterba: I'm running no-holes too, and haven't had problems with it 
either, tho it's obviously a bit newer and doesn't yet have the degree of 
testing that skinny-metadata has.  Any idea when that'll go default?  
It's probably best to stagger them, which probably means default no-holes 
for the 3.19 userspace release since default skinny-metadata is 
presumably going to be 3.18 now; does that sound about right?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

