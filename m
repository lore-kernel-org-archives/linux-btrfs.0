Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59769 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaF0RU4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 13:20:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X0ZpV-00071Y-Qu
	for linux-btrfs@vger.kernel.org; Fri, 27 Jun 2014 19:20:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 19:20:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 19:20:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Blocked tasks on 3.15.1
Date: Fri, 27 Jun 2014 17:20:41 +0000 (UTC)
Message-ID: <pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<pan$81d96$8a4effae$94572f09$472a11ff@cox.net>
	<CAGfcS_khFRS3nMOtAD7srzHg6Q73LF1iogEzTy4YH1KW=qEu0g@mail.gmail.com>
	<4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 27 Jun 2014 09:52:46 -0600 as excerpted:

> On Jun 27, 2014, at 9:14 AM, Rich Freeman <r-btrfs@thefreemanclan.net>
> wrote:
> 
>> On Fri, Jun 27, 2014 at 9:06 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> Hopefully that problem's fixed on 3.16-rc2+, but as of yet there's not
>>> enough 3.16-rc2+ reports out there from folks experiencing issues with
>>> 3.15 blocked tasks to rightfully say.
>> 
>> Any chance that it was backported to 3.15.2?  I'd rather not move to
>> mainline just for btrfs.
> 
> The backports don't happen that quickly.

The lockup bug that affected early 3.16 was introduced in the commit-
window pull for 3.16, so the fix for that shouldn't have needed backported 
(unless the problem commit ended up in stable too, which I doubt but 
don't know for sure).

3.15.0 didn't contain that bug, which affected me, but as I said, there 
did seem to be more blocked-task reports in 3.15, which didn't affect me.

I didn't run 3.15.1, however, staying on 3.15.0 until after 3.16-rc2 
fixed the earlier 3.16-pre series bug that had kept me from the 3.16 
series until then.  So anything that might have affected the 3.15 stable 
series after 3.15.0, I wouldn't know about.

If I'm not mistaken the fix for the 3.16 series bug was:

ea4ebde02e08558b020c4b61bb9a4c0fcf63028e

Btrfs: fix deadlocks with trylock on tree nodes.

But I think the 3.16 commit-window changes introducing the bug weren't 
btrfs specific but instead at the generic vfs level.  If that's the case, 
then it's possible that the bug was there before 3.16's commit window and 
might have been triggering some of the 3.15 reports as well, and the 3.16 
vfs change simply made it much worse.

IOW, I don't know whether that 3.16 series fix will help 3.15 or not, but 
I don't believe it'll hurt, and it /might/ help.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

