Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbaDYXDT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 19:03:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wdp9I-0003Cq-Nc
	for linux-btrfs@vger.kernel.org; Sat, 26 Apr 2014 01:03:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 01:03:16 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 01:03:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: safe/necessary to balance system chunks?
Date: Fri, 25 Apr 2014 23:03:03 +0000 (UTC)
Message-ID: <pan$a73aa$187744ee$76aa9d20$301f58e9@cox.net>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
	<75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
	<535AA581.1080301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Fri, 25 Apr 2014 14:12:17 -0400 as
excerpted:
>
> On 2014-04-25 13:24, Chris Murphy wrote:
>> 
>> On Apr 25, 2014, at 8:57 AM, Steve Leung <sjleung@shaw.ca> wrote:
>> 
>>> Assuming this is something that needs to be fixed, would I be able to
>>> fix this by balancing the system chunks?  Since the "force" flag is
>>> required, does that mean that balancing system chunks is inherently
>>> risky or unpleasant?
>> 
>> I don't think force is needed. You'd use btrfs balance start
>> -sconvert=raid1 <mountpoint>; or with -sconvert=raid1,soft although
>> it's probably a minor distinction for such a small amount of data.
> 
> The kernel won't allow a balance involving system chunks unless you
> specify force, as it considers any kind of balance using them to be
> dangerous.  Given your circumstances, I'd personally say that the safety
> provided by RAID1 outweighs the risk of making the FS un-mountable.

To clear this up, FWIW...

In a balance, metadata includes system by default.

If you go back and look at the committed balance filters patch, the 
wording on the -s/system chunks option is that it requires -f/force 
because one would normally handle system as part of metadata, not for any 
other reason.

What it looks like to me is that the original patch in progress may not 
have had -s/system as a separate filter at all, treating it as
-m/metadata, but perhaps someone suggested having -s/system as a separate 
option too, and the author agreed.  But since -m/metadata includes -s/
system by default, and that was the intended way of doing things,
-f/force was added as necessary when doing only -s/system, since 
presumably that was considered an artificial distinction, and handling -s/
system as a part of -m/metadata was considered the more natural method.

Which begs the question[1], is there a safety or procedural reason one 
should prefer handling metadata and system chunks at the same time, 
perhaps because rewriting the one involves rewriting critical bits of the 
other anyway, or is it simply that the author considered system a subset 
of metadata, anyway?  That I don't know.

But what I do know is that -f/force isn't required with -m/metadata, 
which includes -s/system by default anyway, so unless there's reason to 
treat the two differently, just use -m/metadata and let it handle -s/
system as well. =:^)

---
[1] Begs the question: Modern more natural/literal majority usage 
meaning: invites/forces the question, the question becomes so obvious 
that it's "begging" to be asked, at least in the speaker/author's (my) 
own head.  Yes, I am aware of but generally prefer "assumes and thus 
can't prove the postulate" or similar wording as an alternate to the 
translation-accident meaning.  If you have some time and are wondering 
what I'm talking about and/or think I used the term incorrectly, google 
it (using duck-duck-go or the like if you don't like google's profiling). 
=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

