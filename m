Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58400 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdG0Uo3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 16:44:29 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dapdk-0006Yd-B8
        for linux-btrfs@vger.kernel.org; Thu, 27 Jul 2017 22:44:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: write corruption due to bio cloning on raid5/6
Date: Thu, 27 Jul 2017 20:44:04 +0000 (UTC)
Message-ID: <pan$ec007$3f43fe2a$2f099431$cc969edd@cox.net>
References: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
        <20170726160717.GA32451@localhost.localdomain>
        <CANznX5Hx57JbwS75usDHwWBHbmiLj7dVHrfgZ5Swn=8zX=2iHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Janos Toth F. posted on Thu, 27 Jul 2017 16:14:47 +0200 as excerpted:

> * This is off-topic but raid5 scrub is painful. The disks run at
> constant ~100% utilization while performing at ~1/5 of their sequential
> read speeds. And despite explicitly asking idle IO priority when
> launching scrub, the filesystem becomes unbearably slow (while scrub
> takes a days or so to finish ... or get to the point where it hung the
> last time around, close to the end).

That's because basically all the userspace scrub command does is make the 
appropriate kernel calls to have it do the real scrub.  So priority-
idling the userspace scrub doesn't do what it does on normal userspace 
jobs that do much of the work themselves.

The problem is that idle-prioritizing the kernel threads actually doing 
the work could risk a deadlock due to lock inversion, since they're 
kernel threads and aren't designed with the idea of people messing with 
their priority in mind.

Meanwhile, that's yet another reason btrfs raid56 mode isn't recommended 
at this time.  Try btrfs raid1 or raid10 mode instead, or possible btrfs 
raid1, single or raid0 mode on top of a pair of mdraid5s or similar.  Tho 
parity-raid mode in general (that is, not btrfs-specific) is known for 
being slow in various cases, with raid10 normally being the best 
performing closest alternative.  (Tho in the btrfs-specific case, btrfs 
raid1 on top of a pair of mdraid/dmraid/whatever raid0s, is the normally 
recommended higher performance reasonably low danger alternative.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

