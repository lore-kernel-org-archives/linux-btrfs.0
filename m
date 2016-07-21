Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795AbcGUIKk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 04:10:40 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
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
 <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com>
Date: Thu, 21 Jul 2016 16:10:29 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the info, pretty helpful.

After a simple analysis, the defrag did do a pretty good job.

-----------------------------------------------------------------------
            | Avg Extent size | Median Extent size | Data Extents      |
-----------------------------------------------------------------------
Predefrag  | 2.6M            | 512K               | 1043589           |
Postdefrag | 7.4M            | 80K                | 359823            |

Defrag reduced the number of extents to 34%!

Quite awesome.

While I still see quite a lot small extents (In fact, small extents are 
more after defrag), so I assume there can be more improvement.

But considering the mount time is only affected by number of extents 
(data and meta, but amount of meta is not affect by defrag), so the 
improvement is already quite obvious now.

Much more obvious than my expectation.

Thanks,
Qu

At 07/20/2016 06:44 PM, John Ettedgui wrote:
> On Mon, Jul 18, 2016 at 2:07 AM Qu Wenruo <quwenruo@cn.fujitsu.com
> <mailto:quwenruo@cn.fujitsu.com>> wrote:
>
>     Yes, to compare the extent size and verify my assumption.
>
>     But I'm afraid you don't have any fs with that slow mount time any more.
>
>
> Here are 2 links for the information you requested, I've gzipped each
> file as it was quite big...
>
> https://mega.nz/#!QhQSHBhb!RwN3kDBK6ZOkq3e5UkNhzB0XnbfgZgql4c5fvjfDq1w
> <https://mega.nz/#%21QhQSHBhb%21RwN3kDBK6ZOkq3e5UkNhzB0XnbfgZgql4c5fvjfDq1w>
> https://mega.nz/#!M5gVAbLA!S_TxIls1_q6MqMVlCRK5XxTXifXPE76tdJWsf5XRxYE
> <https://mega.nz/#%21M5gVAbLA%21S_TxIls1_q6MqMVlCRK5XxTXifXPE76tdJWsf5XRxYE>
>
> I didn't look at their content, but just comparing their size, there is
> quite a difference there.
>
> Thank you,
> John


