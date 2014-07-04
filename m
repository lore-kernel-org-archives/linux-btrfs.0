Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39525 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbaGDWEm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 18:04:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X3Bax-0006zF-VF
	for linux-btrfs@vger.kernel.org; Sat, 05 Jul 2014 00:04:39 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Jul 2014 00:04:39 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Jul 2014 00:04:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs fi
 df' command
Date: Fri, 4 Jul 2014 22:04:27 +0000 (UTC)
Message-ID: <pan$6f3ab$9b4cf7f$df6ad356$b0215b95@cox.net>
References: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com>
	<20140704135226.GO1553@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Fri, 04 Jul 2014 15:52:26 +0200 as excerpted:

> I disagree here, it's much more convenient to run 'fi df' anywhere and
> get the output. The system 'df' command works the same way.

Agreed.

I believe the proposed patch (at least based on its commit comment), 
however, simply warns if the fi df is not done on a mount-point, giving 
the mount-point that it's printing information for.  IMO that /is/ 
helpful, and comparable to standard df, which has a mountpoint column, so 
with the patch the same mount-point information is available from fi df 
as from normal df, just a bit differently.

It wasn't quite clear from the discussion whether that would be the case, 
and I was prepared to protest the patch if it wasn't, but the way things 
turned out (based on the commit comment, I don't claim to read code) 
seems fine to me.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

