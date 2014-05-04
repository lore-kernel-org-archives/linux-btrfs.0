Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39962 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbaEDD1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 May 2014 23:27:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wgn5O-0004TP-LS
	for linux-btrfs@vger.kernel.org; Sun, 04 May 2014 05:27:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 05:27:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 05:27:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: copies= option
Date: Sun, 4 May 2014 03:27:16 +0000 (UTC)
Message-ID: <pan$9bead$d5bbe620$2c7141f7$fab07860@cox.net>
References: <201405041216.54348.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sun, 04 May 2014 12:16:54 +1000 as excerpted:

> Are there any plans for a feature like the ZFS copies= option?
> 
> I'd like to be able to set copies= separately for data and metadata.  In
> most cases RAID-1 provides adequate data protection but I'd like to have
> RAID-1 and copies=2 for metadata so that if one disk dies and another
> has some bad sectors during recovery I'm unlikely to lose metadata.

Hugo's the guy with the better info on this one, but until he answers...

The zfs license issues mean it's not an option for me and I'm thus not 
familiar with its options in any detail, but if I understand the question 
correctly, yes.

And of course since btrfs treats data and metadata separately, it's 
extremely unlikely that any sort of copies= option wouldn't be separately 
configurable for each.

There was a discussion of a very nice multi-way-configuration schema that 
I deliberately stayed out of as both a bit above my head and far enough 
in the future that I didn't want to get my hopes up too high about it 
yet.  I already want N-way-mirroring so bad I can taste it, and this was 
that and way more... if/when it ever actually gets coded and committed to 
the mainline kernel btrfs.  As I said, Hugo should have more on it, as he 
was active in that discussion as it seemed to line up perfectly with his 
area of interest.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

