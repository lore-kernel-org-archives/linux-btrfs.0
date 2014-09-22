Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35877 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaIVQ5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 12:57:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XW6g4-0005vH-23
	for linux-btrfs@vger.kernel.org; Mon, 22 Sep 2014 18:41:28 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 18:41:28 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 18:41:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: device delete progress
Date: Mon, 22 Sep 2014 16:29:26 +0000 (UTC)
Message-ID: <pan$c3643$3e5c01cf$cc7cb117$c2a00b4b@cox.net>
References: <201409211209.11875.russell@coker.com.au>
	<pan$1d8a8$448bb26c$d55fc521$929be7e0@cox.net>
	<20140922094955.GI9715@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Mon, 22 Sep 2014 11:49:55 +0200 as excerpted:

> The upcomming 3.17 release should contain all the 'new df' patches that
> were unfortunatelly delayed. There are some minor issues to be fixed but
> I hope it'll be ready close to the kernel 3.17 release.

Will that fix my "unknown" chunk profiles too?

I expected either userspace 3.16 or kernel 3.17 to fix that, but I'm 
running both (well, kernel 3.17 git, since the release hasn't happened 
yet) and still seeing the unknown chunk profiles.

Either that, or if userspace 3.16 and kernel 3.17 should have fixed it, 
I'm triggering a bug somewhere.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

