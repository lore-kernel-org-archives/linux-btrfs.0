Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47433 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbbDCFOU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Apr 2015 01:14:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ydtvu-000812-6a
	for linux-btrfs@vger.kernel.org; Fri, 03 Apr 2015 07:14:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 07:14:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 07:14:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs hangs 3.19-10
Date: Fri, 3 Apr 2015 05:14:12 +0000 (UTC)
Message-ID: <pan$a9ed6$bb1c7fdd$74534d5d$7b638441@cox.net>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
	<20150402114608.GG32078@carfax.org.uk> <20150402191312.1ee31af3@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Thu, 02 Apr 2015 19:13:12 +0500 as excerpted:

> Yeah I believe I just hit that in 3.14.37, system unbootable (locks up
> at "Scanning for Btrfs filesystems"), resulted in a many hour downtime
> as it was a remote system w/o IPMI. Fine after a reboot to 3.14.34. Too
> bad that even staying on the "stable" series kernel can back-stab you
> like that from time to time.

Well, btrfs itself isn't really stable yet...  Stable series should be 
stable at least to the extent that whatever you're using in them is, but 
with btrfs itself not yet entirely stable...  

If your goal is full stability, something that has been demonstrated 
mature, stable, and problem free for some period (say six months if 
you're edgy, a year if you're moderate, at least two years if you're 
conservative), is still a far better choice.  Given existing problems 
even now, even if 4.0 btrfs proves entirely stable, btrfs won't have that 
demonstrated history at least until the end of whatever length of period 
you consider appropriate, because that couldn't start until 4.0's 
release, which is still in the future.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

