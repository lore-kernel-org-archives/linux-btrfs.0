Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56524 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaICFh7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 01:37:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XP3GV-00051D-2u
	for linux-btrfs@vger.kernel.org; Wed, 03 Sep 2014 07:37:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 07:37:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 07:37:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120
 seconds
Date: Wed, 3 Sep 2014 05:37:43 +0000 (UTC)
Message-ID: <pan$d7111$755bc381$f59147dd$8ff671d2@cox.net>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
	<540498AF.6030109@fb.com>
	<CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
	<pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
	<CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com>
	<pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
	<C5F63696-2ADD-4CB6-A049-71B71A9D083E@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 02 Sep 2014 20:44:06 -0600 as excerpted:

> On Sep 2, 2014, at 12:40 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> 
>> Mkfs.btrfs used to default to 4 KiB node/leaf sizes; now days it
>> defaults to 16 KiB as that's far better for most usage.  I wonder if
>> USB sticks are an exception…
> 
> USB sticks > 1 GB get 16KB nodesize also.

Seems you read into that a meaning I didn't even consider when I wrote 
it. =:^/

I /meant/ that AFAIK mkfs.btrfs did the usual 16K thing, but that perhaps 
(some, depending on erase-block size) USB sticks are an exception to 16K 
being better than 4K thing.

> At <= 1 GB, mixed-bg is
> default as is 4KB nodesize. Probably because queue/rotational is 1 for
> USB sticks, they mount without ssd or ssd_spread which may be
> unfortunate (I haven't benchmarked it but I suspect ssd_spread would
> work well for USB sticks).

I did mention ssd_spread somewhere in my replies, due to the same 
suspicion.  Good to see you have the same suspicion I do. =:^)

> It was suggested a while ago that maybe mixed-bg should apply to larger
> volumes, maybe up to 8GB or 16GB?

Indeed.  Considering the default data chunk size is 1 GiB, that as the 
cutoff for default mixed-bg mode seems kinda low.  If anything, I think 
16 GiB is still a low cutoff value, at least as long as the only way to 
reclaim out-of-balance data/metadata assigned chunks is via a manual 
balance.  I'd suggest a 32 GiB cutover by default.

Tho if btrfs gets a good auto-balance-trigger mechanism that say triggers 
when allocated (fi show device figure) is within say 10% of total 
filesystem space (rounded up to the nearest GiB, minimum 2 GiB) AND data 
or metadata has more than say 10% spread between used and allocated (fi 
df, again rounded up, 2 GiB minimum), that can arguably come down a 
notch, to say 16 GiB.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

