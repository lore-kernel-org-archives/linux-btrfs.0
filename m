Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45240 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750705AbdDJAwr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 20:52:47 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: Graham Cobb <g.btrfs@cobb.uk.net>, btrfs <linux-btrfs@vger.kernel.org>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
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
 <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com>
 <5790EEAC.4090008@cobb.uk.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <986cc45e-baed-1101-44a9-6fa37f9c6db0@cn.fujitsu.com>
Date: Mon, 10 Apr 2017 08:52:42 +0800
MIME-Version: 1.0
In-Reply-To: <5790EEAC.4090008@cobb.uk.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/21/2016 11:47 PM, Graham Cobb wrote:
> On 21/07/16 09:19, Qu Wenruo wrote:
>> We don't usually get such large extent tree dump from a real world use
>> case.
>
> Let us know if you want some more :-)
>
> I have a heavily used single disk BTRFS filesystem with about 3.7TB in
> use and about 9 million extents.  I am happy to provide an extent dump
> if it is useful to you.  Particularly if you don't need me to actually
> unmount it (i.e. you can live with some inconsistencies).

Btrfs-debug-tree can dump fs on-line. But I'm not sure if the result is 
consistent.


BTW, for the original problem (slow mount and fsck OOM), although we 
have no progress to handle slow mount but use defrag to reduce the 
number of extents, for fsck OOM, the lowmem mode now can handle all the 
trees.

So now lowmem mode should not cause OOM now, but it may take much longer 
time if you have multiple snapshots.
It would be nice if you could try it, especially to see if the lowmem 
mode really lives up to its name.

Thanks,
Qu

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


