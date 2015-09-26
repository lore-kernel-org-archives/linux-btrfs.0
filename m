Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40076 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbbIZCFU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 22:05:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZferM-0005fD-AE
	for linux-btrfs@vger.kernel.org; Sat, 26 Sep 2015 04:05:08 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 04:05:08 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 04:05:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Latest kernel to use?
Date: Sat, 26 Sep 2015 02:04:52 +0000 (UTC)
Message-ID: <pan$9f488$3e7cc077$732442f6$c6dbba94@cox.net>
References: <4362384.AA8xu4anSN@hoefnix> <3800342.Pn9bHBFuTx@hoefnix>
	<20150925135134.GF3749@carfax.org.uk>
	<CAEp_DRCiMRzuX8m9JoNO=8rtSWSP_Vqs4LfVW7JppDa2c4e_7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bostjan Skufca posted on Fri, 25 Sep 2015 16:34:16 +0200 as excerpted:

> Similar here: I am sticking with 3.19.2 which has proven to work fine
> for me (backup systems with btrfs on lvm, lots of snapshots/subvolumes
> and occasional rebalance, no fancy/fresh stuff like btrfs-raid, online
> compression or subvolume quota, though this last one is tempting in my
> use case).

On that last one, subvolume quota, you've been following list discussion, 
right?  Just in case you haven't...

Btrfs quotas have been an incredibly tough feature to stabilize.  They're 
on the third rewrite and still have some major bugs to fix, so I'd say at 
least a couple more kernel cycles, then check again before using the 
feature.

So, unless you're actively testing and reporting bugs in that specific 
feature (in which case, thanks and please continue! =:^), I continue to 
strongly recommend leaving quotas off for now, as I have been for a year 
or more, now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

