Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55631 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbbGTI3N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 04:29:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZH6Rj-0008AD-Ef
	for linux-btrfs@vger.kernel.org; Mon, 20 Jul 2015 10:29:11 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2015 10:29:11 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2015 10:29:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Anyone tried out btrbk yet?
Date: Mon, 20 Jul 2015 08:28:53 +0000 (UTC)
Message-ID: <pan$7f5c7$63eed743$33fa939$36f57317@cox.net>
References: <11148188.L9vtSMaNHV@merkaba> <559FA280.8090309@tty0.ch>
	<20150712035523.GI5274@merlins.org> <20150713004249.GP5274@merlins.org>
	<CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
	<20150715031412.GZ5274@merlins.org> <20150715080057.GA15200@panda>
	<CAC=t97CxDRoakqzoOAoHpN=1qS1jyvMEfOCe+RWvGTm6xSCqPQ@mail.gmail.com>
	<CAC=t97BS2gNNLZEatTRCmmiUHLH8m6NFbgtkbWnaqrEsCye1KQ@mail.gmail.com>
	<20150715214913.GG5274@merlins.org>
	<CAC=t97CcemZzBjABSLS5etSF6B-67SvwL25q62hxv2de3zLPbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald Pearson posted on Mon, 20 Jul 2015 00:15:26 -0500 as excerpted:

> I'm starting to think there's something wrong with creating and removing
> snapshots that leaves btrfs-cleaner either locked up or nearly so.  If
> the btrfs-cleaner process was hard-disk limited I should be seeing some
> HDD I/O to coincide but I don't.
> 
> So far btrfs-cleaner is has been using lots of CPU for 1900+ hours and
> my disk I/O is basically idle.  My hourly snaps via cronjob stalled 11
> hours ago.
> 
> Otherwise attempts to read/write to the filesystem appear to be
> perfectly normal.

Hourly snaps.  How many snapshots/subvolumes on the filesystem?  I assume 
the snap removal you mention is scheduled thinning?

A general rule of thumb is under 2000 snapshots per filesystem total, 
under 1000 if at all reasonable.  At 250 snapshots per subvolume, 2000 
snapshots is eight subvolumes worth, and 250-ish snapshots per subvolume 
is well within reason with reasonable thinning.

If you have lots of subvolumes, 3000 snapshots per filesystem isn't /too/ 
bad, but filesystem maintenance including snapshot deletion simply does 
/not/ scale well, and you'll likely run into scalability issues if you 
let it reach 10K snapshots on the filesystem.

If you're at 10K snapshots on the filesystem, it's quite likely the usual 
scalability issue's you're seeing, almost certain at 100K+ snapshots.  
OTOH, if you're under 1K or even 2K snapshots, it's very likely something 
abnormal.  2K-10K, should be usable in most cases, but there are likely 
corner-cases where it's bad.

Also, FWIW, the btrfs quota subsystem increases snapshot management 
complexity dramatically, so if you're using that, aim for the low ends of 
the above recommendation if at all possible, and/or consider either 
turning off the quota stuff or using a filesystem other than btrfs, as in 
addition to the scaling issues, the quota management code has been a 
source of repeated bugs and isn't a feature I'd recommend relying on 
until it has at least several kernel cycles worth of trouble-free history 
behind it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

