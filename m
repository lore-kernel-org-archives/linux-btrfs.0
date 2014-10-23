Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58384 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbaJWCmB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 22:42:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xh8Lf-0008S4-77
	for linux-btrfs@vger.kernel.org; Thu, 23 Oct 2014 04:41:59 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 04:41:59 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 04:41:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Poll: time to switch skinny-metadata on by default?
Date: Thu, 23 Oct 2014 02:41:47 +0000 (UTC)
Message-ID: <pan$319b5$6b7e279$b22089f8$74c1c033@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net>
	<CAGfcS_nTbXQQTOC+QcBX8dbwk18Qbf-+JonQSw4WP6MOFg2z7A@mail.gmail.com>
	<pan$19856$ee791297$ceeef1ce$27ae8dc@cox.net>
	<CAAVQaYA9UWbF3ROXRRmcbKX9U7dwrT19Rc3NSX2vuzfVr3oXVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave posted on Wed, 22 Oct 2014 08:49:46 -0400 as excerpted:

> On Tue, Oct 21, 2014 at 10:08 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> As for the mounted filesystem question, since all it does is flip a
>> switch so that new metadata writes use the skinny-metadata code path,
>> it shouldn't be a problem.
> 
> Nope.  Just tried it here:
> 
> # btrfs --version Btrfs v3.16.1-42-g140eccb
> 
> # btrfstune -x /dev/dm-0 /dev/dm-0 is mounted

Thanks.

So btrfstune refuses to set the skinny-metadata flag at all on mounted 
devices.  Nicely reduces risk, /and/ answers the question. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

