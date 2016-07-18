Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36363 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbcGRPbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 11:31:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bPAVn-0003lI-I8
	for linux-btrfs@vger.kernel.org; Mon, 18 Jul 2016 17:31:16 +0200
Received: from 64.134.221.72 ([64.134.221.72])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 17:31:15 +0200
Received: from 1i5t5.duncan by 64.134.221.72 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 17:31:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
Date: Mon, 18 Jul 2016 15:31:00 +0000 (UTC)
Message-ID: <pan$dd5b6$9cf94b5a$62923e99$f654aec1@cox.net>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55C02AF9.3070600@cn.fujitsu.com>
	<CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
	<55C0A1ED.6020407@gmail.com>
	<CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
	<55C1F3DD.7020603@gmail.com>
	<CAJ3TwYSW+SvbBrh1u_x+c3HTRx03qSR6BoH5cj_VzCXxZYv6EA@mail.gmail.com>
	<126f9f09-4e28-3c12-5384-63032e17942f@cn.fujitsu.com>
	<CAJ3TwYRXwDVVfT0TRRiM9dEw-7TvY8qG=WvMYKczZOv6wkFWAQ@mail.gmail.com>
	<fd718727-9b54-ba58-5f39-63066181d13e@cn.fujitsu.com>
	<CAJ3TwYSTnQfj=qmBLtnmtXQKexMMD4x=9Gk3p3anf4uF+G26kw@mail.gmail.com>
	<CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
	<5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com>
	<CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
	<799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com>
	<CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
	<e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 18 Jul 2016 17:07:47 +0800 as excerpted:

>>     Since I'm really surprised on the mount time reduce, especially
>>     considering the fact that for compression case, max extent size is
>>     limited to 128K, IMHO defrag won't help much.
>>
>> Is the 128K limit for the whole FS or only for files that btrfs deemed
>> worth to compress? If it's the latter, that could explain why defrag
>> helped.
> 
> The latter. But the 128K is not for compressed size, but raw size.
> 
> So no matter the compressed size, any extent whose uncompressed size is
> larger than 128K will be split.
> 
> The main reason I'm surprised about the mount time reduce, is that
> considering the sectorsize (4K for x86_64 and x86), the fragments won't
> increase too much.
> The smallest extent size is determined by sectorsize(4K for most arch).
> Compressed extent up limit is 128K,  4K -> 128K is only 32 times. While
> for non-compress case, its extent size up limit is 128M.
> 32K times larger than sector size, or 1024 times larger than compressed
> extent size.
> 
> So I'm quite surprised that defrag helps so much.

[I'm only seeing your posts here, not his (yet?), so I'm only seeing what 
you quote from his posts and may be missing part of the story.  Never-the-
less...]

I think what he's referring to is that he's only running compress, not 
compress-force, and presumably not autodefrag.  So there's probably a lot 
of uncompressed files that were heavily fragmented and thus in many 
extents, that a defrag run helped consolidate, thus reducing mount time 
substantially.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

