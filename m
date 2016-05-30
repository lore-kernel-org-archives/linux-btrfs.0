Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50250 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422658AbcE3Vz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 17:55:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b7V9i-0001ti-Kp
	for linux-btrfs@vger.kernel.org; Mon, 30 May 2016 23:55:26 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 23:55:26 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 23:55:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Date: Mon, 30 May 2016 21:55:20 +0000 (UTC)
Message-ID: <pan$aa8d9$36fb64$9a2d8d63$4849129@cox.net>
References: <572D0C8B.8010404@mendix.com> <574C1EEE.2030507@mendix.com>
	<pan$ec157$35290f6a$2662f654$78485165@cox.net>
	<574CAE1C.6060604@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Mon, 30 May 2016 23:18:20 +0200 as
excerpted:

>> Snip the dump, but curious as a user (not a dev) what command you used.
>> Presumably one of the debug commands which I'm not particularly
>> familiar with, but I wasn't aware it was even possible.
> 
> It's the output of a little programming exercise calling the search
> ioctl from python. https://github.com/knorrie/btrfs-heatmap
> 
> While using balance I got interested in knowing where balance got the
> information from to find how much % a chunk is used. I want to see that
> list in advance, so I can see what -dusage the most effective would be.
> My munin graphs show the stacked total value, which does not give you an
> idea about how badly the unused space is fragmented over already
> allocated chunks.
> 
> So, with some help of Hugo on IRC to get started, I ended up with this
> PoC, which can create nice movies of your data moving around over the
> physical space of the filesystem over time, like this one:
> 
> https://syrinx.knorrie.org/~knorrie/btrfs/heatmap.gif
> 
> Seeing the chunk allocator work its way around the two devices, choosing
> the one with the most free space, and reusing the gaps left by balance
> is super interesting. :-]

Very cool indeed.  Reminds me of the nice eye candy dynamic graphicals 
that MS defrag had back in 9x times.  (I've no idea what they have now as 
I've been off the platform for a decade and a half now.)

I may have to play with it a bit, when I have more time (I'm moving in a 
couple days...).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

