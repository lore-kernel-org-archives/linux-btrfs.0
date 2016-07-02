Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54879 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbcGBKy4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jul 2016 06:54:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bJIZF-0007eB-5J
	for linux-btrfs@vger.kernel.org; Sat, 02 Jul 2016 12:54:34 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jul 2016 12:54:33 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jul 2016 12:54:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs ops hang indefinitely (process in D state)
Date: Sat, 2 Jul 2016 10:54:27 +0000 (UTC)
Message-ID: <pan$d43f3$27b9c4f4$192fd921$a96a4735@cox.net>
References: <57778E41.1010000@average.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eugene Crosser posted on Sat, 02 Jul 2016 12:49:53 +0300 as excerpted:

> Enter the second system. It is a rented physical server in a datacenter
> with two hard disks, joined into a single root btrfs (/dev/sd[ab]1 are
> swap partitions):
> 
> root@dehost:~# uname -a
> Linux dehost 3.13.0-91-generic [...]
> root@dehost:~# btrfs --version
> Btrfs v3.12
> root@dehost:~#

v3.12 userspace and v3.13 kernel are both ancient history in btrfs terms, 
far too old to provide anything useful in terms of debugging info.

In general, btrfs is not yet fully stable, and usage on the production 
systems where that ancient a kernel and userspace might be considered for 
stability reasons is considered highly incompatible with that sort of an 
interest in stability at the cost of new features, because btrfs itself 
isn't anything close to that level of stable.  So the general 
recommendation is choose one, either the still stabilizing btrfs on a 
more current system if you want btrfs, or something truly stable, if you 
really need that sort of years outdated stability.

That said, while this list does tend to focus on mainline and the last 
two mainline releases series of the current and LTS kernels, so ATM 4.6 
and 4.5 for current and 4.4 and 4.1 for LTS, not really much earlier, we 
recognize that various distros do backporting and support much further 
back.  But this list tracks mainline, not those distro kernels, and 
specifically, we don't track what they've backported vs. what they 
haven't.  So if you wish to use your distro's old kernels, that's fine, 
but you're going to be better off going to them for support then, because 
they'll know what they've backported and what they haven't and are thus 
in a better position to provide that support.

Meanwhile, I do recognize that you had something similar happen on a much 
newer kernel as well, but that was on a different system, and you don't 
have the details or logs left for that one, so that's not of much help 
either.

Unless of course you can duplicate the behavior once again with a 
reasonably current kernel within the two-release series either LTS or 
current range, as specified above, and can provide the logs, etc, from 
it...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

