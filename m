Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36433 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbbDFJUY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Apr 2015 05:20:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yf3Cg-0000mK-Ef
	for linux-btrfs@vger.kernel.org; Mon, 06 Apr 2015 11:20:22 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 11:20:22 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 11:20:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs hangs 3.19-10
Date: Mon, 6 Apr 2015 09:20:12 +0000 (UTC)
Message-ID: <pan$420e7$db822c51$3b826361$7a5d035c@cox.net>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
	<20150404130047.GC13864@carfax.org.uk>
	<pan$bf795$4bdcf130$e29eb18a$9b854964@cox.net>
	<201504050330.47299.russell@coker.com.au>
	<20150405100417.GE13864@carfax.org.uk>
	<2f6a9ac9-0684-4b9a-982e-031286be398e@lists.xtsubasa.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pavel Volkov posted on Mon, 06 Apr 2015 10:40:03 +0300 as excerpted:

> On Sunday, April 5, 2015 1:04:17 PM MSK, Hugo Mills wrote:
>>    That's these, I think:
>>
>> #define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
>> #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF    (1ULL << 6)
>>
>> so it's definitely -O^extref. I don't see where big_metadata comes
>> from, though. That's not a -O option. Try with -O^extref and see where
>> that gets you. (Also, don't mount the FS on a newer kernel -- it may be
>> setting big metadata automatically, although it probably shouldn't do).
> 
> By the way, is there any way to see which options are enabled on a local
> filesystem without having to try mounting it with old kernel and
> checking dmesg?

btrfs-show-super shows what flags are enabled, both numerically and 
symbolically.

At least for btrfs-progs 3.19.1, which I have installed.  I'm not sure 
how far that goes back, but I don't believe it's new functionality, so 
I'd guess 3.14 at least, but likely not back all the way to 0.19, as that 
was a very long time ago in btrfs terms.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

