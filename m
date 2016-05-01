Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41134 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbcEAXQu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 19:16:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ax0bX-0006Wz-P3
	for linux-btrfs@vger.kernel.org; Mon, 02 May 2016 01:16:47 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 01:16:47 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 01:16:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Sun, 1 May 2016 23:16:41 +0000 (UTC)
Message-ID: <pan$d1f0f$8ccdf372$96201635$9cec331b@cox.net>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
	<CAMU1PDj99OSwFy7Ep9g43uezNLEGoziqPn3kzhUUqeEMRNTWgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mike Fleetwood posted on Sun, 01 May 2016 14:54:44 +0100 as excerpted:

> On 1 May 2016 at 13:47, Duncan <1i5t5.duncan@cox.net> wrote:
>> Direct from that section of my /etc/sysctl.conf:
>>
>> ################################################################################
>> # Virtual-machine: swap, write-cache
> 
> Hi Duncan,
> 
> You mean virtual memory.

Yes, thanks for catching that.  I had figured that out at some point, but the
virtual-machine comment was from before that and I guess I never changed it.
Additionally, I'm used to VM in the machine not memory context, so still slip
up and write machine even when I'm talking about memory from time to time.
=:^( )

I'll change that comment as soon as I send this, and hopefully the specific
discussion will tune my sensitivity to it enough that I quit making that
mistake in discussion from now on, as well.  So thanks again. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

