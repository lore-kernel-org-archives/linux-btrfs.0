Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54113 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbbGZFjq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jul 2015 01:39:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZJEew-0001G6-ML
	for linux-btrfs@vger.kernel.org; Sun, 26 Jul 2015 07:39:38 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2015 07:39:38 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2015 07:39:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Anyone tried out btrbk yet?
Date: Sun, 26 Jul 2015 05:39:33 +0000 (UTC)
Message-ID: <pan$c3d84$44e79b82$a4995e51$e6fa6d40@cox.net>
References: <11148188.L9vtSMaNHV@merkaba> <559FA280.8090309@tty0.ch>
	<20150712035523.GI5274@merlins.org> <20150713004249.GP5274@merlins.org>
	<CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
	<20150715031412.GZ5274@merlins.org> <20150715080057.GA15200@panda>
	<CAC=t97CxDRoakqzoOAoHpN=1qS1jyvMEfOCe+RWvGTm6xSCqPQ@mail.gmail.com>
	<CAC=t97BS2gNNLZEatTRCmmiUHLH8m6NFbgtkbWnaqrEsCye1KQ@mail.gmail.com>
	<20150715214913.GG5274@merlins.org>
	<CAC=t97CcemZzBjABSLS5etSF6B-67SvwL25q62hxv2de3zLPbw@mail.gmail.com>
	<pan$7f5c7$63eed743$33fa939$36f57317@cox.net>
	<CAC=t97AK_4PMT4NAWiW_OwhGFidJOR6mrUh=9gnTqeRNHAjxRw@mail.gmail.com>
	<pan$3ae51$bc5b796f$ddf9ddc1$392a5e3c@cox.net>
	<CAC=t97B-J2DhY5Bv9EUxSRo4g6xPg8E=n3TenrYa6X5xVQx5cg@mail.gmail.com>
	<CAC=t97Dp2DU0_4bC-ZQmUa9_J96yi6VLfEZ27Wu3LufOfcLwEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald Pearson posted on Sat, 25 Jul 2015 08:27:03 -0500 as excerpted:

[Duncan wrote...]

>>>>> Also, FWIW, the btrfs quota subsystem increases snapshot management
>>>>> complexity dramatically, so if you're using that, aim for the low
>>>>> ends of the above recommendation if at all possible, and/or consider
>>>>> either turning off the quota stuff or using a filesystem other than
>>>>> btrfs, as in addition to the scaling issues, the quota management
>>>>> code has been a source of repeated bugs and isn't a feature I'd
>>>>> recommend relying on until it has at least several kernel cycles
>>>>> worth of trouble-free history behind it.

[Big intervening thread snip...]

> I can confirm that getting rid of the quotas fixed the issue for me.
> Just disabling quotas wasn't enough, I had to enable, delete all
> qgroups, reboot because disable was hung on one of the filesystems,
> then disable quotas.  Now when btrfs-cleaner runs it doesn't completely
> consume a core, I can see corresponding disk i/o, and the process goes
> away after a reasonable amount of time.

Thanks for the confirmation!

Good to have a recent and concrete report to point to, on the subject of 
btrfs and quotas, now.  Now I can at least say something like "we do have 
at least one report (4.1 timeframe) of snapshot deletion scaling or 
lockup issues where quotas was implicated -- after deleting qgroups and 
disabling quotas, the problem disappeared."

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

