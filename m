Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37852 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbcFUI4L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 04:56:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bFHTC-0001yb-La
	for linux-btrfs@vger.kernel.org; Tue, 21 Jun 2016 10:55:43 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 10:55:42 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 10:55:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is "btrfs balance start" truly asynchronous?
Date: Tue, 21 Jun 2016 08:55:18 +0000 (UTC)
Message-ID: <pan$7df97$9174e96e$7848d28b$295d4358@cox.net>
References: <f68639e5a41343c04fa4d76f3fb14370@www.centurion.link>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dmitry Katsubo posted on Mon, 20 Jun 2016 18:33:54 +0200 as excerpted:

> Dear btfs community,
> 
> I have added a drive to existing raid1 btrfs volume and decided to
> perform balancing so that data distributes "fairly" among drives. I have
> started "btrfs balance start", but it stalled for about 5-10 minutes
> intensively doing the work. After that time it has printed something
> like "had to relocate 50 chunks" and exited. According to drive I/O,
> "btrfs balance" did most (if not all) of the work, so after it has
> exited the job was done.
> 
> Shouldn't "btrfs balance start" do the operation in the background?

>From the btrfs-balance (8) manpage (from btrfs-progs-4.5.3):

start [options] <path>
    start the balance operation according to the specified filters,
    no filters will rewrite the entire filesystem. The process runs
    in the foreground.


So the balance start operation runs in the foreground, but as explained 
elsewhere in the manpage, the balance is interruptible by unmount and 
will automatically restart after a remount.  It can also be paused and 
resumed or canceled with the appropriate btrfs balance subcommands.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

