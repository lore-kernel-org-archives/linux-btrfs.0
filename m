Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33989 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbbLFEVi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Dec 2015 23:21:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a5QpL-0004LW-O0
	for linux-btrfs@vger.kernel.org; Sun, 06 Dec 2015 05:21:35 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 05:21:35 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 05:21:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: compression disk space saving - what are your results?
Date: Sun, 6 Dec 2015 04:21:30 +0000 (UTC)
Message-ID: <pan$8b10f$b3ac4256$83d73f5e$98d77741@cox.net>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
	<6329794.eixGOkx0p3@thetick> <1864635.CI05HQM0X6@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Sat, 05 Dec 2015 15:11:51 +0100 as excerpted:

> I do think it's interesting that compression (even with LZO) seems to
> have offset the extra space wastage caused by autodefrag.

I've seen (I think) you mention that twice now.  Perhaps I'm missing 
something... How does autodefrag trigger space wastage?

What autodefrag does is watch for seriously fragmented files and queue 
them up for later defrag by a worker thread.  How would that waste space?

Unless of course you're talking about breaking reflinks to existing 
snapshots or other (possibly partial) copies of the file.  But I'd call 
that wasting space due to the snapshots storing old copies, not due to 
autodefrag keeping the current copy defragmented.  And reflinks are 
saving space by effectively storing parts of two files in the same 
extent, not autodefrag wasting it, as the default on a normal filesystem 
would be separate copies, so that's the zero-point base, and reflinks 
save from it, with autodefrag therefore not changing things from the zero-
point base.  No snapshots, no reflinks, autodefrag no longer "wastes" 
space, so it's not autodefrag's wastage in the first place, it's the 
other mechanisms' saving space.

>From my viewpoint, anyway.  I'd not ordinarily quibble over it one way or 
the other if that's what you're referring to.  But just in case you had 
something else in mind that I'm not aware of, I'm posting the question.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

