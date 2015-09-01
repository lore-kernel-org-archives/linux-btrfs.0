Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59855 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbbIAHbB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 03:31:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZWg1x-0006CJ-Kq
	for linux-btrfs@vger.kernel.org; Tue, 01 Sep 2015 09:30:57 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 09:30:57 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 09:30:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: errors while "btrfs receive"
Date: Tue, 1 Sep 2015 07:30:52 +0000 (UTC)
Message-ID: <pan$e8554$6dbe382c$ff1dc29$3d51b79e@cox.net>
References: <1441046042.49932584@apps.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vincent Olivier posted on Mon, 31 Aug 2015 14:34:02 -0400 as excerpted:

> i'm doing a ~900TiB receive on a 6x4TB RAID0
> 
> "fi show", "device scan" all fail and report "unable to connect to
> /dev/sdX"
> 
> is it normal ?

Can't answer your direct question as my use-case doesn't include send/
receive, but...

~900TiB receive on a 24TB (6x4TB) raid0?  

Did you mean ~900GiB, or did you miss the decimal point, or ????  I mean, 
yeah, btrfs does have the compress= option, but I don't think it's going 
to compress 900 TiB to fit in under 24!  That's likely to be some 
seriously lossy compression!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

