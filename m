Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38188 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbcGRJH4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 05:07:56 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
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
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com>
Date: Mon, 18 Jul 2016 17:07:47 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/18/2016 04:53 PM, John Ettedgui wrote:
> On Mon, Jul 18, 2016 at 1:42 AM Qu Wenruo <quwenruo@cn.fujitsu.com
> <mailto:quwenruo@cn.fujitsu.com>> wrote:
>
>
>     > So following that, another partition got its mounting time reduced by
>     > about 70% by running a manual defrag (I kept compression on and used
>     > -clzo for this defragmentation).
>     > So maybe a manual defrag is really the best thing to do so far.
>
>     Seems to be the case.
>
>     For further investigation, it would be quite nice for you to upload the
>     output of "btrfs-debug-tree -t 2" dump of your fs.
>     Both before and after, and it doesn't containing anything meaningful(no
>     file name/relation, only extent allocation info), so it's should be
>     quite safe to upload.
>
> What do you mean by before and after?
> Before defragmentation?

Yes, to compare the extent size and verify my assumption.

But I'm afraid you don't have any fs with that slow mount time any more.

>
>     Since I'm really surprised on the mount time reduce, especially
>     considering the fact that for compression case, max extent size is
>     limited to 128K, IMHO defrag won't help much.
>
> Is the 128K limit for the whole FS or only for files that btrfs deemed
> worth to compress? If it's the latter, that could explain why defrag helped.

The latter. But the 128K is not for compressed size, but raw size.

So no matter the compressed size, any extent whose uncompressed size is 
larger than 128K will be split.

The main reason I'm surprised about the mount time reduce, is that 
considering the sectorsize (4K for x86_64 and x86), the fragments won't 
increase too much.
The smallest extent size is determined by sectorsize(4K for most arch).
Compressed extent up limit is 128K,  4K -> 128K is only 32 times.
While for non-compress case, its extent size up limit is 128M.
32K times larger than sector size, or 1024 times larger than compressed 
extent size.

So I'm quite surprised that defrag helps so much.

>
>
>     >     And after applying my patch, please try to compare the
>     executing time of
>     >     btrfs_read_block_groups() to see if there is any obvious(>5%)
>     change.
>     >
>     > Here's what I have for one partition:
>     >
>     > no patch:
>     > open_ctree: 16952419
>     > btrfs_read_block_groups: 16844453
>     > ratio: 0.9936312333950689
>     >
>     > patch:
>     > open_ctree: 16680173
>     > btrfs_read_block_groups: 16600532
>     > ratio: 0.9952254092328659
>     >
>     > ratio no patch/patch: 0.9983981761086407
>
>     OK, almost no improvement. So in your case, most BLOCK_GROUP_ITEMS are
>     not at the tail of a extent tree leaf.
>     And in our test environment, it seems that quite some BLOCK_GROUPS_ITEMS
>     are at the tail of an extent tree leaf, and make the improvement quite
>     obvious.
>
>     But anyway, if we can change the on-disk format to introduce a specific
>     block group items tree, then I assume the mount time would reduce to
>     less than 5 seconds.
>
> Less than 5 seconds without regular defrag would be nice.
> It  would be even nicer to be able to convert from one format to another
> and not need to do it at mkfs time, but I don't know how feasible that
> will be.

If it's possible, it may works just like METADATA_ITEM(or 
skinny_metadata feature), and in that case, time reduce will depend on 
how many BLOCK_GROUP_ITEMs are in the new tree.

Thanks,
Qu
>
> Another option would be to use something like bcache to have the extent
> tree on a SSD while the data stays on the HD. No idea how feasible that
> would be though...
>
> Thank you,
> John


