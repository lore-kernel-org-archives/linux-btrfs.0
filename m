Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44730 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbbEHWGR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 May 2015 18:06:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YqqPQ-0007IR-1P
	for linux-btrfs@vger.kernel.org; Sat, 09 May 2015 00:06:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 May 2015 00:06:16 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 May 2015 00:06:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel Dump scanning directory
Date: Fri, 8 May 2015 22:06:10 +0000 (UTC)
Message-ID: <pan$d9931$d653b924$fe7b0555$13f9ab1@cox.net>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net>
	<4B045A3B-60E2-4151-86E7-029E79585886@plack.net>
	<60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net>
	<EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net>
	<pan$ef76f$1decf414$ca28dae0$217ae55f@cox.net>
	<D7C742B6-7DD3-49F3-B49A-4C8FD5B97527@plack.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anthony Plack posted on Fri, 08 May 2015 16:37:05 -0500 as excerpted:

> 30 seconds on a server can be allot of data, and is to small of a time
> span for adequate backups to occur.
 
> Maybe we need a warning at the top of the BTRFS page that it is highly
> likely, if BTRFS crashes and the transactions get corrupt, that you WILL
> loose at a minimum the last 30 seconds of your data and maybe more.

Note that commit time has been a mount-time option for a number of kernel 
releases, now.  It's 30 seconds by default, and IMO that's a reasonable 
compromise, but it /is/ an option.

In general I agree, however, particularly about the stability, which 
simply isn't as good as some would make it, ATM[1], tho Hugo does make a 
valid point, there's another bug triggering the (current) problem, and 
getting that rooted out is critical, regardless of where this more 
general debate goes.

---
[1] And unfortunately, that lack of very visible stability warning, as 
they've all been removed, is causing people to rely on btrfs without 
backups, that really should either have backups, or if they really /must/ 
play without backups, they really /should/ be on something other than 
btrfs at this point.

Tho FWIW I think the unstated thinking is that the warnings were scaring 
away the broader level of testing that btrfs needs at this point, with 
the thought being chicken and egg, we wouldn't get the needed testing 
with the warnings, and the warnings couldn't be truthfully taken away 
without that needed testing and followup, so I think someone decided it 
was time to fudge a bit, at least to the extent of arranging for the 
absence of warnings that /were/ there previously, thus allowing deception 
by omission for those who simply don't look close enough at the small-
print when they choose their filesystem, as well as not realizing that 
even on "stable" filesystems let alone something still not entirely 
stable like btrfs, lack of a backup really does state by action that you 
simply don't care about the data, and prefer to risk its potential loss 
over the certain time and opportunity cost of actually doing/testing the 
backups.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

