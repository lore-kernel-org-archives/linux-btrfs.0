Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37092 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaJMVuN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 17:50:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XdnVK-0003Ag-7K
	for linux-btrfs@vger.kernel.org; Mon, 13 Oct 2014 23:50:10 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 23:50:10 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 23:50:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
Date: Mon, 13 Oct 2014 21:49:55 +0000 (UTC)
Message-ID: <pan$cf0dc$5fba5ce6$217e75d5$ea5d5c3e@cox.net>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com> <543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
	<CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
	<CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com>
	<CANg_oxz7Kpp8ppTn0jg8aeHcrpoakO6mAcHkv9Nnn9ms4M-2rQ@mail.gmail.com>
	<543C4343.30903@prnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Arendt posted on Mon, 13 Oct 2014 23:25:23 +0200 as excerpted:

> I'm also using no compression.
> 
> On 10/13/2014 11:22 PM, john terragon wrote:
>> I'm using "compress=no" so compression doesn't seem to be related, at
>> least in my case. Just read-only snapshots on 3.17 (although I haven't
>> tried 3.16).

While I'm not a mind-reader and thus don't know for sure, Rich's 
reference to 3.16 and compression might not be related to this bug at 
all.  In 3.15 and early 3.16, there was a different bug related to 
compression, tho IIRC it was patched in 3.16.2 and 3.17-rc2 (or maybe .3 
and rc3, it's patched in the latest 3.16.x anyway, and in 3.17).  So how 
I read his comment was that he was considering going back to 3.16 and 
disabling compression to deal with that bug (he may not know the patch 
was marked for stable and is in current 3.16.x), rather than stay on 
3.17, since this bug hasn't even been traced yet, let alone patched.

Meanwhile, this bug makes me glad my use-case doesn't involve snapshots, 
and I've seen nothing of it. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

