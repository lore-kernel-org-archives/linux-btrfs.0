Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43791 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbaLMBMb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 20:12:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XzbG1-0002Zz-VI
	for linux-btrfs@vger.kernel.org; Sat, 13 Dec 2014 02:12:29 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 02:12:29 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 02:12:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: A note on spotting "bugs" [Was: ENOSPC after conversion]
Date: Sat, 13 Dec 2014 01:12:15 +0000 (UTC)
Message-ID: <pan$93dc7$f46dda26$f7d33e3f$b328e05d@cox.net>
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>
	<548A13F7.30904@pobox.com>
	<CAA7pwKNKeuysdoS83m=z-Cn5ecWtGrQAfjNKwXjryRceHUV=3Q@mail.gmail.com>
	<548AEDD6.1090904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Fri, 12 Dec 2014 05:29:58 -0800 as excerpted:

> This still doesnt say _anything_ is wrong with your filesystem except
> that it doesn't have enough _raw_ space to create a 2-ish gig extent.

What's wrong with the filesystem is that there shouldn't /be/ a need to 
create a 2-ish gig extent.  All btrfs native structures are 1 GiB each or 
smaller, and the completed-without-error btrfs fi defrag should have 
eliminated any > 1 GiB structures remaining from the conversion from 
ext*, such that btrfs balance only has to deal with <= 1 GiB structures.

So that balance is having to deal with a 2-ish gig extent at all is 
indicative of a bug.  Balance isn't prepared to have to allocate 2-ish 
GiB extents in the first place as that's beyond it's design specs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

