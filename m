Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59805 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab3F1P4v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 11:56:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Usb2T-0005jn-0S
	for linux-btrfs@vger.kernel.org; Fri, 28 Jun 2013 17:56:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 17:56:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 17:56:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid1 inefficient unbalanced filesystem reads
Date: Fri, 28 Jun 2013 15:56:27 +0000 (UTC)
Message-ID: <pan$ae66e$32536288$6e47cfba$521b389f@cox.net>
References: <kqk4sc$t5d$1@ger.gmane.org>
	<20130628153418.GW4288@localhost.localdomain>
	<20130628153910.GM14601@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Fri, 28 Jun 2013 16:39:10 +0100 as excerpted:

> On Fri, Jun 28, 2013 at 11:34:18AM -0400, Josef Bacik wrote:
>> On Fri, Jun 28, 2013 at 02:59:45PM +0100, Martin wrote:
>> > On kernel 3.8.13:
>> > 
>> > Using two equal performance SATAII HDDs, formatted for btrfs raid1
>> > for both data and metadata and:
>> > 
>> > The second disk appears to suffer about x8 the read activity of the
>> > first disk. This causes the second disk to quickly get maxed out
>> > whilst the first disk remains almost idle.
>> > 
>> > Total writes to the two disks is equal.
>> > 
>> > This is noticeable for example when running "emerge --sync" or
>> > running compiles on Gentoo.
>> 
>> So we balance based on pids, so if you have one process that's doing a
>> lot of work it will tend to be stuck on one disk, which is why you are
>> seeing that kind of imbalance.  Thanks,
> 
>    The other scenario is if the sequence of processes executed to do
> each compilation step happens to be an even number, then the heavy-duty
> file-reading parts will always hit the same parity of PID number. If
> each tool has, say, a small wrapper around it, then the wrappers will
> all run as (say) odd PIDs, and the tools themselves will run as even
> pids...

Ouch and double-ouch!  I'm a gentooer too, but I guess I haven't seen the 
issue probably because I switched to ssd at the same time I switched to 
btrfs (in dual ssd raid1 mode for data/metadata both), and the 
performance difference between my old reiserfs on spinning rust and my 
new btrfs on ssd is enough that it's many times faster in any case, such 
that I simply haven't noticed this issue.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

