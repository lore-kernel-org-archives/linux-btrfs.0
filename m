Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57450 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbdDGDMg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 23:12:36 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cwKK2-0004Cu-Ez
        for linux-btrfs@vger.kernel.org; Fri, 07 Apr 2017 05:12:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mix ssd and hdd in single volume
Date: Fri, 7 Apr 2017 03:12:12 +0000 (UTC)
Message-ID: <pan$cdd2e$cc55a257$d0ed8ef2$bf00097b@cox.net>
References: <CAEgruXvAEBfpQaAxCi42Vq6v8w7v1dqthpn9TpE3FDDHoTWRcw@mail.gmail.com>
        <pan$dda3$b8e27938$5de5fd9$136342b5@cox.net>
        <c3b00962-6ab2-d289-be77-2586bf57cd6f@rqc.ru>
        <20170403134107.30e923d8@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Mon, 03 Apr 2017 13:41:07 +0500 as excerpted:

> On Mon, 3 Apr 2017 11:30:44 +0300 Marat Khalili <mkh@rqc.ru> wrote:
> 
>> You may want to look here: https://www.synology.com/en-global/dsm/Btrfs
>> . Somebody forgot to tell Synology, which already supports btrfs in all
>> hardware-capable devices. I think Rubicon has been crossed in
>> 'mass-market NAS[es]', for good or not.
> 
> AFAIR Synology did not come to this list asking for (any kind of) advice
> prior to implementing that (else they would have gotten the same kind of
> post from Duncan and others)[.]  I don't remember seeing them actively
> contribute improvements or fixes especially for the RAID5 or RAID6
> features (which they ADVERTISE on that page as a fully working part of
> their product).

> That doesn't seem honest to end users or playing nicely with the
> upstream developers. What the upstream gets instead is just those
> end-users coming here one by one some years later, asking how to fix
> a broken Btrfs RAID5 on an embedded box running some 3.10 or 3.14
> kernel.

And of course then the user gets the real state of btrfs and of btrfs 
raid56 mode, particularly back that far, explained to them.  Along with 
that we'll explain that any data on it is in all likelihood lost data, 
with little to no chance at recovery.

And we'll point out that if there was serious value in the data, they 
would have investigated the state of the filesystem before they put that 
data on it, and of course, as I've already said, they'd have had backups 
for anything that was of more value than the time/resources/hassle of 
doing those backups.

And if they're lucky, that NAS will have /been/ the backup, and they'll 
still have the actual working copy at least, and can make another backup 
ASAP just in case that working copy dies too.

But if they're unlucky...

Of course the user will then blame the manufacturer, but by that time the 
warranty will be up, and even if not, while they /might/ get their money 
back, that won't get their data back.

And the manufacturer will get a bad name, but by then having taken the 
money and run they'll be on to something else or perhaps be bought out by 
someone bigger or be out of business.

And all the user will be able to do is chalk it up to experience, and 
mourn the loss of their kids' baby pictures/videos or their wedding 
videos, or whatever.  If they're /really/ lucky, they'll have put them on 
facebook or youtube or whatever, and can retrieve at least those, from 
there.

Meanwhile, the user, having been once burned, may never use the by then 
much improved btrfs, or even worse, never trust anything Linux, again.

Oh, well.  The best we can do here is warn those that /do/ value their 
data enough to do their research first, so they /do/ have those backups 
or at least use something a bit more mature than btrfs raid56 mode.  Of 
course and continue to work on full btrfs stabilization.  And I like to 
think we're reasonably good at those warnings, anyway.  The 
stabilization, too, but that takes time and patience, plus coder skill, 
the last of which which I personally don't have, so I just pitch in where 
I can, answering questions, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

