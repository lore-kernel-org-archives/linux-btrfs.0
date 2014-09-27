Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38926 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaI0Cgd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 22:36:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XXhs7-0000E5-96
	for linux-btrfs@vger.kernel.org; Sat, 27 Sep 2014 04:36:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 04:36:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 04:36:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.16 Managed to ENOSPC with <80% used
Date: Sat, 27 Sep 2014 02:36:12 +0000 (UTC)
Message-ID: <pan$41b80$e9472660$dc93ed19$748d19cd@cox.net>
References: <CAPL5yKfTfzkqBT9dQBpJAjuBtq2-=QqdCn_Pzfnnd1URKA_q4A@mail.gmail.com>
	<pan.2014.09.24.22.23.33@googlemail.com>
	<CAPL5yKdt7eTk-+0NP2Y9Aa8zNQqJpujTm31z_ee04OS3DocMXg@mail.gmail.com>
	<pan.2014.09.25.21.21.47@googlemail.com>
	<CAGfcS_koxt3d4kBv1o+5FnpDj-6+WA6tsPbPkBdehNnWcYnaKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Fri, 26 Sep 2014 10:18:37 -0400 as excerpted:

> On Thu, Sep 25, 2014 at 5:21 PM, Holger Hoffstätte
> <holger.hoffstaette@googlemail.com> wrote:
>> That's why I mentioned adding a second device - that will immediately
>> allow cleanup with headroom. An additional 8GB tmpfs volume can works
>> wonders.
>>
>>
> If you add a single 8GB tmpfs to a RAID1 btrfs array, is it safe to
> assume that you'll still always have a redundant copy of everything on a
> disk somewhere during the recovery?  Would only a single tmpfs volume
> actually help in this case?  I get a bit nervous about doing a cleanup
> that involves moving metadata to tmpfs of all places, since some kind of
> deadlock/etc could result in unrecoverable data loss.
> 
> Doing the same thing with an actual hard drive would concern me less.

That has been my concern too, and why I'd be leery about using a loopback 
on tmpfs, even for the few minutes (more like seconds since I'm on SSD 
and we /are/ talking memory-backed tmpfs) it'd take to free a minimal 
number of chunks (say usage=2% or 5% or whatever, the smallest number 
that actually frees anything).

With SSD and with backups I'd probably do it, but it's not something I 
could recommend, and I'm not sure I'd do it on slower spinning rust, just 
because the time is longer.

I'd probably use a thumb drive or the like, instead, and would certainly 
recommend that to others, altho if they're comfortable with it and want 
to risk it, a loopback file on tmpfs should work fine, provided the power 
doesn't go out in the middle or something.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

