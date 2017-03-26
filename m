Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42884 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdCZFqF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 01:46:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cs0zI-0000wn-Da
        for linux-btrfs@vger.kernel.org; Sun, 26 Mar 2017 07:45:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Qgroups are not applied when snapshotting a subvol?
Date: Sun, 26 Mar 2017 05:45:02 +0000 (UTC)
Message-ID: <pan$18202$be55fb99$f080cada$e9c008d5@cox.net>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Moritz Sichert posted on Sat, 25 Mar 2017 23:03:26 +0100 as excerpted:

> I tried to configure qgroups on a btrfs filesystem but was really
> surprised that when you snapshot a subvolume, the snapshot will not be
> assigned to the qgroup the subvolume was in.

> I feel like I must be missing something here. Considering that creating
> a snapshot does not require root privileges this would mean that any
> user can just circumvent any quota and therefore make them useless.
> 
> Is there a way to enforce quotas even when a user creates snapshots?

This doesn't answer your question, but rather is general information you 
should know about btrfs quotas, that I saw no hint in your post that 
you're already aware of.

Btrfs' quota functionality has a long history of breakage, and if it's 
actually working properly now, it's only very recently so.  Don't rely on 
the btrfs quota functionality working correctly or being stable, tho 
certainly, developers are working very hard at making it eventually so.

Meanwhile, even if it is working correctly, btrfs quota functionality has 
serious scaling issues that can seriously slow the progress of btrfs 
maintenance commands such as balance and check to a crawl, making them 
practically unworkable as they may take weeks to finish on today's 
terabyte-scale filesystems -- declaring the filesystem dead, doing a 
fresh mkfs, and restoring from backups can be far faster.  These commands 
are already slow and memory hungry, and having to deal with quotas makes 
things far worse.

So basically you and your btrfs quota use-case fall into one of three 
classes:

1) You know about the issues and are working with the devs to test and 
fix them, helping to make btrfs qgroups and quotas to one day be fully 
reliable and scalable. =:^)

If this matches your situation, THANKS! =:^)

Unfortunately, your post had more of the tone of btrfs quota newbie than 
someone that knew about the situation, which means you're more likely to 
fall into one of the two classes below.

2) Your use-case really needs and relies on quotas to function stably and 
reliably.

Unfortunately, if you're in this class, btrfs is not at this time ready 
for you -- you're better off on a more mature and fully stable filesystem 
that has a reliable quota feature.

3) Your use-case doesn't rely on quotas and you simply believed they were 
a nice "extra" feature you could play with.

In this case the best recommendation is to turn the feature off and leave 
it off until such time as the quota feature is considered generally 
stable and can be recommended, for me personally, several kernel cycles 
after things on the quota front seem to have quieted down and it appears 
to have been working without major problems.

Even then, quotas are likely to come at somewhat of a scalability and 
performance cost, however, which may or may not be worth it, depending on 
what the feature can do for your use-case.


(FWIW, the otherwise stable snapshots feature also has scalability 
issues.  That's why the strong recommendation is to keep them thinned 
down to 1-300 per snapshotted subvolume, under 200 if reasonably 
possible, and under 2000 per filesystem, under 1000 if possible.  But at 
least that feature is stable and the scalability cost arguably well 
justified by the benefits if the numbers are managed well.  
Unfortunately, the same thing can't presently be said about qgroups and 
quotas.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

