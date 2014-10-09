Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50829 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaJILxi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 07:53:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XcCHm-0003H8-KJ
	for linux-btrfs@vger.kernel.org; Thu, 09 Oct 2014 13:53:34 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Oct 2014 13:53:34 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Oct 2014 13:53:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What is the vision for btrfs fs repair?
Date: Thu, 9 Oct 2014 11:53:23 +0000 (UTC)
Message-ID: <pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
References: <54358C77.2070808@redhat.com> <54367193.6000202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 09 Oct 2014 07:29:23 -0400 as
excerpted:

> Also, you should be running btrfs scrub regularly to correct bit-rot
> and force remapping of blocks with read errors.  While BTRFS
> technically handles both transparently on reads, it only corrects thing
> on disk when you do a scrub.

AFAIK that isn't quite correct.  Currently, the number of copies is 
limited to two, meaning if one of the two is bad, there's a 50% chance of 
btrfs reading the good one on first try.

If btrfs reads the good copy, it simply uses it.  If btrfs reads the bad 
one, it checks the other one and assuming it's good, replaces the bad one 
with the good one both for the read (which otherwise errors out), and by 
overwriting the bad one.

But here's the rub.  The chances of detecting that bad block are 
relatively low in most cases.  First, the system must try reading it for 
some reason, but even then, chances are 50% it'll pick the good one and 
won't even notice the bad one.

Thus, while btrfs may randomly bump into a bad block and rewrite it with 
the good copy, scrub is the only way to systematically detect and (if 
there's a good copy) fix these checksum errors.  It's not that btrfs 
doesn't do it if it finds them, it's that the chances of finding them are 
relatively low, unless you do a scrub, which systematically checks the 
entire filesystem (well, other than files marked nocsum, or nocow, which 
implies nocsum, or files written when mounted with nodatacow or 
nodatasum).

At least that's the way it /should/ work.  I guess it's possible that 
btrfs isn't doing those routine "bump-into-it-and-fix-it" fixes yet, but 
if so, that's the first /I/ remember reading of it.

Other than that detail, what you posted matches my knowledge and 
experience, such as it may be as a non-dev list regular, as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

