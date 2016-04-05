Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42214 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbcDEETY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 00:19:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anISY-00020Q-CK
	for linux-btrfs@vger.kernel.org; Tue, 05 Apr 2016 06:19:22 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 06:19:22 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 06:19:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub priority, am I using it wrong?
Date: Tue, 5 Apr 2016 04:19:11 +0000 (UTC)
Message-ID: <pan$1084d$87b30d83$4860fe5b$19700f4b@cox.net>
References: <CA+WRLO-vu4B8X3Td12F0gueU70G6KwjRTD07MNwDrJfodAscNA@mail.gmail.com>
	<pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
	<CA+WRLO_fkZWsZJFdvMQud1aMTR7kErJVxr9JT0vNpjhQrh2e2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Tue, 05 Apr 2016 13:44:05 +1000 as excerpted:

> On Tue, Apr 5, 2016 at 12:37 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> 1) It appears btrfs scrub start's -c option only takes numeric class,
>> so try -c3 instead of -c idle.
> 
> 
> Does it count as a bug if it silently accepts the way I was doing it?
> 
> I've switched to -c3 and at least now the idle class listed in iotop is
> idle, so I hope that means it will be more friendly to other processes.

I'd say yes, particularly given that the value must be the numeric class 
isn't documented in the manpage at all.

Whether the bug is then one of documentation (say it must be numeric) or 
of implementation (take the class name as well) is then up for debate.  
I'd call fixing either one a fix.  If it must be numeric, document that 
(and optionally change the implementation to error in some way if a 
numeric parameter isn't supplied for -c), else change the implementation 
so the name can be taken as well (and optionally change the documentation 
to explicitly mention that either one can be used).  Doesn't matter to me 
which.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

