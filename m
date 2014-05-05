Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38948 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaEFTlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 15:41:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Whk88-0006Nq-Jr
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 20:30:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 20:30:16 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 20:30:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: copies= option
Date: Mon, 5 May 2014 02:59:35 +0000 (UTC)
Message-ID: <pan$dabcf$295111b1$f1cac574$f1f862c3@cox.net>
References: <201405041216.54348.russell@coker.com.au>
	<pan$9bead$d5bbe620$2c7141f7$fab07860@cox.net>
	<20140504111238.197768d6@ws> <20140504183155.GK24298@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sun, 04 May 2014 19:31:55 +0100 as excerpted:

>  My proposal was simply a description mechanism, not an
> implementation. The description is N-copies, M-device-stripe,
> P-parity-devices (NcMsPp), and (more or less comfortably) covers at
> minimum all of the current and currently-proposed replication levels.
> There's a couple of tweaks covering description of allocation rules
> (DUP vs RAID-1).

Thanks.  That was it. =:^)

But I had interpreted the discussion as a bit more concrete in terms of 
ultimate implementation than it apparently was.  Anyway, it would indeed 
be nice to see an eventual implementation such that the above notation 
could be used with, for instance, mkfs.btrfs, and
btrfs balance start -Xconvert, but regardless, that does look to be a way 
off.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

