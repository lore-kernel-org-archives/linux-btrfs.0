Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42637 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbcF0TsB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 15:48:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bHcVg-0000ww-8n
	for linux-btrfs@vger.kernel.org; Mon, 27 Jun 2016 21:47:59 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 21:47:56 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 21:47:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
Date: Mon, 27 Jun 2016 19:47:35 +0000 (UTC)
Message-ID: <pan$c4bd4$c1594f22$8b12854$dd1b6d96@cox.net>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
	<CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
	<pan$60ea0$54eb541$a3b060fc$181835e5@cox.net>
	<CAN05THQCJS8x0yF6DjDFfsNWzp1u4edv5dH-BMb1TTofZdtjgA@mail.gmail.com>
	<0c4e71329babb09442966c6659f9d965@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steven Haigh posted on Mon, 27 Jun 2016 13:21:00 +1000 as excerpted:

> I'd also recommend updates to the ArchLinux wiki - as for some reason I
> always seem to end up there when searching for a certain topic...

Not really btrfs related, but for people using popular search engines, at 
least, this is likely for two reasons:

1) Arch is apparently the most popular distro among reasonably 
technically literate users -- those who will both tend to have good 
technical knowledge and advice on the various real-life issues Linux 
users tend to encounter, and are likely to post it to an easily publicly 
indexable forum.  (And in that regard, wikis are likely to be more 
indexable than (web archives of) mailing lists like this, because that's 
(part of) what wikis /do/ by design, make topics keyword searchable.  
Lists, not so much.)

2) Specifically to the point of being _publicly_ indexable, Arch may have 
a more liberal robots.txt that allows indexers more access, than other 
distros, some of which may limit robot access for performance reasons.


With this combination, arch's wiki is a natural place for searches to 
point.

So agreed, a high priority on getting the raid56 warning up there on the 
arch wiki is a good idea, indeed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

