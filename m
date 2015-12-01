Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58133 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbbLAOqq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 09:46:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a3mCY-0007cN-UC
	for linux-btrfs@vger.kernel.org; Tue, 01 Dec 2015 15:46:42 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 15:46:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 15:46:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: utils version and convert crash
Date: Tue, 1 Dec 2015 14:46:31 +0000 (UTC)
Message-ID: <pan$bd6b9$902b9704$e341af26$75b25a3@cox.net>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
	<CA+WRLO-1K5sRYiVQ0tEF+WUHJFSe++3fWHaqZ7ZvkhopFaWcbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Tue, 01 Dec 2015 23:57:28 +1100 as excerpted:

> Poking around I just noticed that btrfs de stats /data points out that 3
> of my drives have some read_io_errors. I'm guessing that is a bad thing.
> I assume this would indicate bad hardware and would be a likely cause of
> system crashes.

Yes it's a bad thing and can indicate hardware issues.

But something that has tricked a number of posters in the past... the 
stats numbers don't reset on reboot, they're meant to indicate errors 
over time and thus continue to increase until manually reset (stats -z 
displays and resets).

In particular, if you had a system crash or hard power-down, it likely 
left some errors (fixable by scrub if you're running dup/raid other than 
raid0) that will show up when btrfs comes across them, that don't 
necessarily mean hardware problems (other than likely lack of a UPS).  
Because the numbers don't reset unless you do so manually, that crash/
hard-power-down could have been months ago...

So yes it's a bad thing, but potentially not as alarming as you might 
have first thought, if you had incorrectly assumed those error counts 
were since last boot. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

