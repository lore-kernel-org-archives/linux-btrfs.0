Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40493 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751201AbcGUIT3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 04:19:29 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
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
 <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
 <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com>
 <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com>
Date: Thu, 21 Jul 2016 16:19:26 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/21/2016 04:13 PM, John Ettedgui wrote:
> On Thu, Jul 21, 2016 at 1:10 AM Qu Wenruo <quwenruo@cn.fujitsu.com
> <mailto:quwenruo@cn.fujitsu.com>> wrote:
>
>     Thanks for the info, pretty helpful.
>
>     After a simple analysis, the defrag did do a pretty good job.
>
>     -----------------------------------------------------------------------
>                 | Avg Extent size | Median Extent size | Data Extents      |
>     -----------------------------------------------------------------------
>     Predefrag  | 2.6M            | 512K               | 1043589           |
>     Postdefrag | 7.4M            | 80K                | 359823            |
>
>     Defrag reduced the number of extents to 34%!
>
>     Quite awesome.
>
>     While I still see quite a lot small extents (In fact, small extents are
>     more after defrag), so I assume there can be more improvement.
>
>     But considering the mount time is only affected by number of extents
>     (data and meta, but amount of meta is not affect by defrag), so the
>     improvement is already quite obvious now.
>
>     Much more obvious than my expectation.
>
>     Thanks,
>     Qu
>
> I'm glad to be of help.
> Is there anything else you'd like me to try?
> I don't have any non-defragmented partitions anymore, but you already
> got that information so that should be ok.
>
> Thank you,
> John

No more.

The dump is already good enough for me to dig for some time.

We don't usually get such large extent tree dump from a real world use case.

It would help us in several ways, from determine how fragmented a block 
group is to determine if a defrag will help.

Thanks,
Qu


