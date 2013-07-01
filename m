Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54342 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3GAJLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jul 2013 05:11:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Uta8Q-000156-Gx
	for linux-btrfs@vger.kernel.org; Mon, 01 Jul 2013 11:10:58 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 11:10:58 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 11:10:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unclean shutdown and space cache rebuild
Date: Mon, 1 Jul 2013 09:10:41 +0000 (UTC)
Message-ID: <pan$d6b02$c375f8e3$e64c63ed$cc12d244@cox.net>
References: <11441914.sRzrmH57Vq@bheem> <4774295.3Q3X7zsTmb@vfr>
	<2982023.ALTX9LRhaY@bheem>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shridhar Daithankar posted on Mon, 01 Jul 2013 08:20:19 +0530 as
excerpted:

> On Sunday, June 30, 2013 01:53:48 PM Garry T. Williams wrote:

[discussing fragmentation]
> 
>> ~/.kde/share/apps/nepomuk/repository/main/data/virtuosobackend
> 
> damn!
> 
> # filefrag soprano-virtuoso.db soprano-virtuoso.db: 10518 extents found
>                                                                                                                                
> # btrfs fi defrag soprano-virtuoso.db
> 
> # filefrag soprano-virtuoso.db soprano-virtuoso.db: 957 extents found

While you evidently had quite some fragmentation as the number of extents 
dropped considerably, if you're running btrfs compression, it's worth 
noting that (based on earlier posts here) filefrag always counts 
compressed files as fragmented, even if they're not.  So a sufficiently 
sized file will almost certainly show fragmentation via filefrag if it's 
compressed, and all you can do is use filefrag as a hint in that case; 
defrag may well not do anything if it's not actually fragmented.

> How much is an extend anyways?  is it a page or 256M?

I don't know...
 
> But in general, how to find out most fragmented files and folders?
> mouting with autodefrag is a serious degradation..

It is?  AFAIK, all the autodefrag mount option does is scan files for 
fragmentation as they are written and queue any fragmentation-detected 
files for background defrag by the defrag thread.

I had expected, particularly on spinning rust, that the benefits of 
autodefrag to far exceed the costs, so your performance drag claim is 
interesting to me indeed.  If my expectation is wrong, which it could be, 
I'd love to know why, and see some numbers.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

