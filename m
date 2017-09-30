Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37282 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdI3Xyv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 19:54:51 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dyRai-0002FT-NJ
        for linux-btrfs@vger.kernel.org; Sun, 01 Oct 2017 01:54:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can't remove device -> I/O error
Date: Sat, 30 Sep 2017 23:54:34 +0000 (UTC)
Message-ID: <pan$e97b2$dbbbef5e$7d2adc0d$27a7ec21@cox.net>
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dirk Diggler posted on Fri, 29 Sep 2017 22:00:28 +0200 as excerpted:

> is there any chance to get my device removed?
> Scrub literally takes months to complete (SATA 2/3 mix, about 1 minute
> per gigabyte) and i'm not sure if that helps.
> I guess same with balance. Mabye there is a quicker way. I can do
> without some data if it's corrupted. I have a backup, but i want to
> avoid to copy all data from scratch!

btrfs device remove uses an implicit balance to move data to other 
devices, so even if btrfs device remove were to work for you, it'd 
proceed at the same speed as balance.

[tl;dr stop there]

Even in the generic (non-btrfs) case, parity-raid is known to be slow for 
writes and therefore isn't recommended when speed is of any priority 
above minimum, thus, only for storage where both raw size and some level 
of device failure recovery is possible, and minimal speed is acceptable.

Between that and the btrfs-specific issues btrfs parity-raid had until 
kernel 4.13, with known bugs (but not the not btrfs-specific write hole) 
now fixed but with the possibility of unknown issues still lurking, I'd 
still not consider btrfs parity-raid particularly viable, tho it's no 
longer entirely blacklisted as it was until those 4.13 fixes.

So I'd suggest surrendering the fight and chalking it up to a learning 
experience, either taking the loss now and switching to something else, 
say btrfs raid1 on top of dm/mdraid-0 for higher speed or btrfs raid10 if 
you prefer to stick with a single layer at the sacrifice of speed, or as 
you write further down a different subthread, just sticking with what you 
have (since you do have backups) until a device dies and you really don't 
have an alternative but to eat that "weeks to fix" penalty.

Of course if you have the resources, you can do both at once, continuing 
to operate on the existing setup, while you create an entirely new setup 
and either initialize it from the backups, or start copying data to it 
off the still live raid5, presumably at idle priority so as to affect 
other operations as little as possible.  But the resource requirements to 
keep both the old and the new in operation at once until you can switch 
over to the new entirely, are high enough it may not be feasible.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

