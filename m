Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49327 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaJRX2F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 19:28:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XfdPn-0004ZO-O0
	for linux-btrfs@vger.kernel.org; Sun, 19 Oct 2014 01:28:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 01:28:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 01:28:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid10 drive replacement
Date: Sat, 18 Oct 2014 23:27:52 +0000 (UTC)
Message-ID: <pan$3bb44$7642c5c4$22d7904d$2c7ad586@cox.net>
References: <CAMhgxDMxRNviq5iayuziqUiQXGzSP5cZV2qxnch-3wWLZvwNAA@mail.gmail.com>
	<daf1096c58d3dd54392809f7d3f89e4d@sonic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Suman Chakravartula posted on Fri, 17 Oct 2014 19:02:49 -0700 as
excerpted:


> On 2014-10-17 18:47, Vincent. wrote:
>> Hi !
>> 
>> I have a faulty drive in my raid10 and want it to be replaced. Working
>> drive are xvd[bef] and replacement drive is xvdc.
>> 
> This is something I ran into the other day. Key difference is that I was
> running 3.17.1 kernel and 3.16 btrfs-progs
> 
>> When I mount my drive in RW:
>> #mount -odegraded /dev/xvdb /tank
>> [ 6219.703606] Btrfs: too many missing devices, writeable mount
>> is not allowed
>> 
>> 
> In my case, I was able to rw mount. May be update btrfs-progs and retry?
>> 
> Because my mount was rw, replace worked.
> 
>> FYI I'm on ubuntu 14.04 with btrfs 3.12

I'd suggest updating both btrfs-progs (as Suman suggested) and the kernel 
(the version of which you don't mention).

There was a period when btrfs was too strict in what it would allow to 
mount writable, thus not allowing a device replace to fix the problem.  
It would appear ubuntu 14.4's versions fell in that period.

For kernel, given some recent bugs, you want the latest stable 3.16, 
definitely > 3.16.2 as that contained a vital btrfs bugfix.  Current 3.17 
stable has a different bug that didn't affect 3.16, patch pending but not 
in 3.17, or in 3.18-rc yet, but 3.16.4 (I believe the latest) should be 
good.  You can also try the latest long-term-stable 3.14.x as it's pretty 
stable btrfs-wise, but 3.14 might have still been in the can't-mount-
writable period and I'm not sure they backported that fix to stable-
series.  But 3.16.4+ should be great.

Because btrfs is evolving so fast, in general you'll want to run a 
current kernel and keep up with the list to know about any current bugs 
(like the one currently affecting 3.17 and the 3.18-rcs, and the earlier 
one affecting the entire 3.15 series and 3.16 before 3.16.2).  Most 
distros run somewhat outdated kernels so sticking to a distro kernel 
doesn't always work so well.

btrfs-progs userspace isn't quite so vital to keep current as the kernel, 
but you still want to keep at least reasonably current.  3.12 is getting 
a bit long in the tooth, now, and I'd recommend at least 3.14.2, with 
3.16.1 preferred.  (A 3.17 is in rc ATM but not yet released.)

And (you may not need this but we get people all the time for whom it's a 
bit late so it's worth repeating) of course, because btrfs /is/ evolving 
so fast and isn't yet completely stable, the general rule that if you 
value it you have backups for it that applies even to mature and stable 
filesystems such as ext3 and ext4, applies even more to btrfs.   If 
something goes wrong and you don't have a backup, no matter HOW much you /
claim/ to value that data in hindsight, your actions say you simply 
didn't value it enough to ensure yourself against such possibilities by 
keeping backups, which means you by your actions you considered it throw-
away data if something /did/ go wrong.  Also, be aware that a backup 
that's not tested can't be considered a backup at all, because you don't 
know for sure that you can recover from it.  And RAID isn't a substitute 
for backups.

So if you value your data, have (tested) backups!  Not doing so simply 
means you don't value that data, no matter what you /claim/.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

