Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33597 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab3JCNtT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Oct 2013 09:49:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VRjHK-0006jZ-9h
	for linux-btrfs@vger.kernel.org; Thu, 03 Oct 2013 15:49:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 15:49:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 15:49:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs balance bug
Date: Thu, 3 Oct 2013 13:48:55 +0000 (UTC)
Message-ID: <pan$6b7b8$ac96773e$1f9200ff$3f6ba883@cox.net>
References: <CADef55pBMJ-oeOLy9Z3AeP7iRyFqm6fNfuS8BNm0qbDk876SwQ@mail.gmail.com>
	<pan$a0456$a7c238f0$83bcabb4$dcdfc7c5@cox.net>
	<pan.2013.10.03.11.56.25.811568@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstaette posted on Thu, 03 Oct 2013 13:56:25 +0200 as excerpted:

> On Thu, 03 Oct 2013 11:45:31 +0000, Duncan wrote:
> 
>> 3.11.3.  However, it /should/ be in the /next/ set 3.11-stable release,
>> as they uncrossed their signals and GKH said he'd pull them this time. 
>> (You
> 
> There are no btrfs updates in 3.11.4. I know because I just built -rc1 5
> minutes ago and again had to apply some emergency patches myself.

I had forgotten whether it was 3.11.3 or 3.11.4 that was current, but 
that crossed-signals thread is too fresh for the patches to be in 
whatever's current, thus the reason I said "next" instead of 3.11.4 or 
3.11.5, since I didn't know and didn't want to go look which it would be.

But since you mentioned 3.11.4 didn't have them, I'd (now) expect them to 
be in 3.11.5...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

