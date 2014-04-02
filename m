Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43101 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaDCNqm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Apr 2014 09:46:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WVgnU-0000Du-Ua
	for linux-btrfs@vger.kernel.org; Thu, 03 Apr 2014 14:31:08 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Apr 2014 14:31:08 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Apr 2014 14:31:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [Help] Errors found in extent allocation tree or chunk
 allocation
Date: Wed, 2 Apr 2014 07:27:24 +0000 (UTC)
Message-ID: <pan$a7acf$9977ad03$78352907$e25802e4@cox.net>
References: <ac786c9023364c699d8212b42da536f2-mfwitten@gmail.com>
	<pan$6d267$8b0a867f$c580cca9$4eb55f7b@cox.net>
	<20b782af1cb448c39cce358cd6d37e8c-mfwitten@gmail.com>
	<8e4932bb29f743419660da1846c2363b-mfwitten@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Witten posted on Tue, 01 Apr 2014 19:05:16 +0000 as excerpted:

> The `btrfs balance' completed successfully without error, and DID solve
> my issues; it "relocated" every chunk, after which `btrfsck'
> ran smoothly.
> 
> Thanks for the advice! You've put me at ease, and you've saved me a lot
> of time and energy.

Very good! =:^)  Thanks for the fix-report.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

