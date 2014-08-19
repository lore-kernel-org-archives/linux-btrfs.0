Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59691 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaHSFs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 01:48:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XJcHS-0003v6-TA
	for linux-btrfs@vger.kernel.org; Tue, 19 Aug 2014 07:48:26 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 07:48:26 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 07:48:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: exact nature of send/receive problems?
Date: Tue, 19 Aug 2014 05:48:16 +0000 (UTC)
Message-ID: <pan$86bb7$dbe0132c$fbfa4dde$ba09eacd@cox.net>
References: <CAH-HCWVO7VnT6C0wjWWJjRfaPfQy3zd_Q6oAqhyrUHfPpOZYrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shriramana Sharma posted on Sun, 17 Aug 2014 18:17:48 +0530 as excerpted:

> Hello. This is wrt this thread:
> http://www.spinics.net/lists/linux-btrfs/msg36639.html
> 
> The OP of that thread had not clarified (IMO) what exactly he means by
> "unreliability of btrfs send/receive". Is it only via ssh/network, or
> even in the case of backup to local alternate (external) drive? What
> exactly happens? Does it:
> 
> a) muck up existing data on the source,
> b) or on the target,
> c) or doesn't muck up any data but fails *silently* halfway,
> d) or fails halfway and tells me it failed?
> 
> One of the important reasons I'm looking to use BTRFS is the backup
> economy that send/receive promises. If this reason is going to be
> affected seriously, then I'll return to BTRFS a year hence as was
> suggested elsewhere...

AFAIK, if a send/receive completes successfully it should be entirely 
safe to rely on the received copy.

The problem is various corner-cases are still being found, that can 
suddenly start triggering errors even on systems where it has previously 
been reliably working for months.

As just one example of such a corner case that was fixed I think a kernel 
cycle or two ago now, if subdir B was originally nested within subdir A, 
but then the admin reversed things and subdir A ends up nested inside 
subdir B, the send/receive system couldn't cope with it.

Tho as I said that case was fixed, it's various generally more complex 
cases of that general sort of thing that they're still working on.

So basically what it comes down to is this.  While if a session completes 
successfully it should be reliable, just because you tested it and it 
worked, and it has been working fine for several months, the next time 
you try it it might fail, and you may or may not be able to fix that 
failure and get it working again.  So basically you have to be prepared 
to revert to rsync or something else for backups at any point, because 
you can never be sure that the last send/receive you successfully 
completed won't be the last one that works.

But as long as it works, it should be reliable.  If that's what you need 
for your usage and you can and are prepared to fall back to rsync or 
whatever should it be necessary, and you test it and find it does work 
for you at least right now, you should be good to go.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

