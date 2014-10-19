Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54084 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaJSFhw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 01:37:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XfjBc-0004s8-LN
	for linux-btrfs@vger.kernel.org; Sun, 19 Oct 2014 07:37:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 07:37:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 07:37:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange 3.16.3 problem
Date: Sun, 19 Oct 2014 05:37:36 +0000 (UTC)
Message-ID: <pan$9d78b$40e61441$d421f088$d69188b0@cox.net>
References: <201410181454.19375.russell@coker.com.au>
	<54426C16.5030206@pobox.com> <201410191041.42013.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sun, 19 Oct 2014 10:41:41 +1100 as excerpted:

> # find . -name "*546" -exec rm "{}" \;
> rm: cannot remove `./1412233213.M638209P10546': No such file or
> directory

Going with the non-printable-character theory, what happens if you expand 
that *546 find one character at a time?  Does *0546 work? *10546? etc.

Additionally, I'd say use the default print instead of the -exec rm.  
Because once you find it, you might want to do other tests (doing a file 
on it to find type, finding the size, possibly catting it...) to figure 
out what it is and possibly how it came to get there, before ultimate 
removal.

When you find a boundary where it goes from working to not-working, what 
happens if you stick a wildcard in that boundary?  Assuming *0546 doesn't 
work, for instance, thus creating a boundary between the 0 and the 5, 
what about *0*546 or *0?546?

... Just things I'd be trying were I to see such a thing here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

