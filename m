Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40133 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbcLVKNV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 05:13:21 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cK0Lo-0002KI-DP
        for linux-btrfs@vger.kernel.org; Thu, 22 Dec 2016 11:11:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs_log2phys: cannot lookup extent mapping
Date: Thu, 22 Dec 2016 10:11:35 +0000 (UTC)
Message-ID: <pan$67936$e25a272c$77926cea$931807ed@cox.net>
References: <89be6fee-5b18-7a9d-11ea-85abeab28022@ece.wisc.edu>
        <pan$14679$e5d5bc21$812abe03$ef75194d@cox.net>
        <4e2fcf15-5af4-54b0-f7bb-46518b9bb5a4@ece.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Hanke posted on Wed, 21 Dec 2016 08:50:02 -0600 as excerpted:

> Thank you for your reply. If I've emailed the wrong list, please let me
> know.

Well, it's the right list... for /current/ btrfs.  For 3.0, as I said 
your distro lists may be more appropriate.  But from the below you do 
seem willing to upgrade, so...

> What I hear you saying, in short, is that btrfs is not yet fully
> stable but current 4.x versions may work better.

Yes.

> I'm willing to upgrade,
> but I'm told that the upgrade process may result in total failure, and
> I'm not sure I can trust the contents of the volume either way. Given
> that, it seems I must backup the backup, erase and start over. What
> would you do?

That's exactly what I'd do, but...

Given the maturing-but-not-yet-fully-stable-and-mature state of btrfs 
today, being no further from a usable current backup than the data you're 
willing to lose, at least worst-case, remains an even stronger 
recommendation than it is on fully mature and stable filesystem, kernel 
and hardware.  (And even on such a stable system, any sysadmin worth the 
name defines the real value of data by the extent to which it is backed 
up, no backup means it's simply not worth the trouble and the loss of the 
data is a smaller loss than the loss of resources and hassle required to 
back it up as insurance against loss of the data, regardless of any 
claims to the contrary.)

Knowing that, I do have reasonable backups, and while they aren't always 
current, I take seriously the backup or lack thereof as data value 
definition discussed above, so if I lose it due to not having a backup, I 
swallow hard and know I must have considered the time saved worth it...

Which is a long way of saying I have my backups closer at hand and am 
more willing to use them and lose what wasn't backed up, than some.  So 
it's easier for me to say that's what I'd do, than it would be for some.  
I actually make it a point to keep my data in reasonably sized for 
management partitions, with equivalently sized partitions elsewhere for 
the backups, to multiple levels in many cases, tho some are rather old.  
So freshening or restoring a backup is simply a matter of copying from 
one partition (or pair of partitions given that many of them are btrfs 
raid1 pair-mirrors) to another, deliberately pre-provisioned to the same 
size, for use /as/ the working and backup copies.  Similarly, falling 
back to a backup is simply a matter of ensuring the appropriate physical 
media is connected, and either mounting it as a backup, or switching a 
couple entries in fstab, and mounting it in place of the original.

So it's relatively easy here, but only because I've taken pains to set it 
up to make it so.

Meanwhile, btrfs does have some tools that can /sometimes/ help recover 
data off of unmountable fs' that would otherwise be "in the backup gap".  
Btrfs restore has helped me save that "backup gap" data a few times -- it 
may not have been worth the trouble of a backup when the risk was still 
theoretical, and I'd have accepted the loss if it came to it, but that 
didn't mean it wasn't worth spending a bit more time trying to save it, 
successfully in my case, once I knew I was actually in the recovery or 
loss situation.

Tho in your case it looks like you are looking at the warnings before it 
gets to that point, and it's both a backup already, so you presumably 
have the live data in most cases, and you can still mount and read most 
or all of it, so it's just a question of the time and hassle to do it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

