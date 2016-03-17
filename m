Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37505 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbcCQHAc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 03:00:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1agRv3-0001j9-Lk
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 08:00:29 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 08:00:29 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 08:00:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Major HDD performance degradation on btrfs receive
Date: Thu, 17 Mar 2016 07:00:23 +0000 (UTC)
Message-ID: <pan$993a$3e6653ed$790f69a1$c396ece4@cox.net>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
	<72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
	<CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
	<ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
	<CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
	<5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
	<CAPmG0jZwapQ1=V-dHMEEwMYQUjb4+1M102eo96XQeJQV1JoxeQ@mail.gmail.com>
	<1557fe0b-bbcc-c125-5220-46a56e936590@mokrynskyi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nazar Mokrynskyi posted on Wed, 16 Mar 2016 05:37:02 +0200 as excerpted:

> I'm not sure what you mean exactly by searching. My first SSD died
> during waking up from suspend mode, it worked perfectly till last
> moment. It was not used for critical data at that time, but now I
> understand clearly that SSD failure can happen at any time. Having RAID0
> of 2 SSDs it 2 times more risky, so I'm not ready to lose anything
> beyond 15 minutes threshold. I'd rather end up having another HDD purely
> for backup purposes.

I understand the raid0 N times the danger part, which is why I only ever 
used raid0 on stuff like the distro packages cache that I could easily 
redownload from the net, here.

But seriously, what are you doing that you can't lose more than 15 
minutes of?  Couldn't it be even 20 minutes, or a half-hour or an hour 
with 15 minute snapshots only on the ssds (yes, I know the raid0 factor, 
but the question still applies)?

What /would/ you do if you lost a whole hour's worth of work?  Surely you 
could duplicate it in the next hour?  Or are you doing securities trading 
or something, where you /can't/ recover work at all, because by then the 
market and your world have moved on?  But in that case...

And perhaps more importantly for your data, btrfs is still considered 
"stabilizing, not fully stable and mature".  Use without backups is 
highly discouraged, but I'd suggest that btrfs in its current state might 
not be what you're looking for if you can't deal with loss of more than 
15 minutes worth of changes anyway.

Be that as it may...

Btrfs is definitely not yet optimized.  In many cases it reads or writes 
only one device at a time, for instance, even in RaidN configuration.  
And there are definitely snapshot scaling issues altho at your newer 500 
snapshots total that shouldn't be /too/ bad.

Dealing with reality, regardless of how or why, you currently have a 
situation of intolerably slow receives that needs addressed.  From a 
practical perspective you said an ssd for backups is ridiculous and I 
can't disagree, but there's another "throw hardware at it" solution that 
might be a bit more reasonable...

Spinning rust hard drives are cheap.  What about getting another one, and 
alternating your backup receives between them?  That would halve the load 
to one every thirty minutes, without changing your 15-minute snapshot and 
backup policy at all. =:^)

So that gives you two choices for halving the load to the spinning rust.  
Either decide you really can live with half-hour loss of data, or throw 
only a relatively small amount of money (well, as long as you have room 
to plug in another sata device anyway, otherwise...) at it for a second 
backup device, and alternate between them.


OTOH, since you mentioned possible coding, optimization might not be a 
bad thing, if you're willing to put in the time necessary to get up to 
speed with the code and can work with the other devs in terms of timing, 
etc.  But that will definitely take significant time even if you do it, 
and the alternating backup solution can be put to use as soon as you can 
get another device plugged in and setup. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

