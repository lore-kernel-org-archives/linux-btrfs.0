Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60091 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbbL3U5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 15:57:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aENoU-0003x8-7A
	for linux-btrfs@vger.kernel.org; Wed, 30 Dec 2015 21:57:42 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 21:57:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 21:57:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Confining scrub to a subvolume
Date: Wed, 30 Dec 2015 20:57:36 +0000 (UTC)
Message-ID: <pan$468ac$46c45058$b2c48647$420a1135@cox.net>
References: <56831EA2.3090807@totakura.in>
	<20151230173949.GH4227@twin.jikos.cz>
	<pan$88aff$ee7e2e75$cb54e003$bedb8f3a@cox.net>
	<1451503680.6350.5.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 30 Dec 2015 20:28:00 +0100 as
excerpted:

> On Wed, 2015-12-30 at 18:26 +0000, Duncan wrote:
>> That should work.  Cat the files to /dev/null and check dmesg.  For
>> single mode it should check the only copy.  For raid1/10 or dup,
>> running two checks, ensuring one is even-PID while the other is
>> odd-PID, should work to check both copies, since the read-scheduler
>> assigns copy based on even/odd PID.  Errors will show up in dmesg, as
>> well as cat's STDERR.

> That doesn't seem very reliable to me, to be honest... plus it wouldn't
> work in any RAID56 or dupN (with n!=2) case, when that gets sooner or
> later implemented.

Well, yes, but right now except on raid56... and there's a good chance 
it'll work for a year at least, as I've seen no first-patches yet to 
implement n-way (which I'm sure looking forward to), after which perhaps 
he'll have implemented the multi-btrfs on partitions or lvm thing that I 
actually prefer, myself.

Meanwhile, it's a pretty clever solution, I think. =:^)

> Also, I'd kinda guess (or better said: hope) that the kernel's cache
> would destroy these efforts, at least when the two reads happen mostly
> in parallel.

I was thinking run them in parallel, but you're right, you'd have to run 
them serially and dumpcache between runs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

