Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48601 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750965AbcGRImI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 04:42:08 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
 <55C017E7.40704@cn.fujitsu.com>
 <CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
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
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com>
Date: Mon, 18 Jul 2016 16:41:56 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/18/2016 04:20 PM, John Ettedgui wrote:
> On Sun, Jul 17, 2016 at 6:14 PM Qu Wenruo <quwenruo@cn.fujitsu.com
> <mailto:quwenruo@cn.fujitsu.com>> wrote:
>
>
>     Well, compression=no only affects any write after the mount option.
>     And balance won't help to convert compressed extent to
>     non-compressed one.
>
>     But maybe the defrag will convert them to normal extents.
>
>     The best method to de-compress them is, to read them out and rewrite
>     them with compression=no mount option.
>
> Right, I just don't have the extra storage for that right now, though I
> suppose I could do little by little, but manually that would take a
> really long time, so I went with the defrag route :)
>
>
>     >
>     > I'll try just defragmenting another partition but keeping the
>     > compression on and see what difference I get there the same changes.
>     >
>
> So following that, another partition got its mounting time reduced by
> about 70% by running a manual defrag (I kept compression on and used
> -clzo for this defragmentation).
> So maybe a manual defrag is really the best thing to do so far.

Seems to be the case.

For further investigation, it would be quite nice for you to upload the 
output of "btrfs-debug-tree -t 2" dump of your fs.
Both before and after, and it doesn't containing anything meaningful(no 
file name/relation, only extent allocation info), so it's should be 
quite safe to upload.

Since I'm really surprised on the mount time reduce, especially 
considering the fact that for compression case, max extent size is 
limited to 128K, IMHO defrag won't help much.


>
>     > I've tried the patch, which applied fine to my kernel (4.6.4) but I
>     > don't see any difference in mounting time, maybe I made a mistake
>     or my
>     > issue is not really the same?
>
>     Pretty possible that there is another problem causing the slow mount.
>
>     The best method to verify is to do a ftrace on the btrfs mount.
>     Here is the script I tested my patch:
>
>     ....
>     ....
>
> Thank you for the script, that makes it a lot easier for me!
>
>     And you can see open_ctree() function, the main part of btrfs mount,
>     takes about 7.67 seconds to execute, while btrfs_read_block_groups()
>     takes 7.56 seconds, about 98.6% of the open_ctree() executing time.
>
>     If your result are much the same as mine, then that's the same problem.
>
> They are similar, 99% is spent in btrfs_read_block_groups.
>
>     And after applying my patch, please try to compare the executing time of
>     btrfs_read_block_groups() to see if there is any obvious(>5%) change.
>
> Here's what I have for one partition:
>
> no patch:
> open_ctree: 16952419
> btrfs_read_block_groups: 16844453
> ratio: 0.9936312333950689
>
> patch:
> open_ctree: 16680173
> btrfs_read_block_groups: 16600532
> ratio: 0.9952254092328659
>
> ratio no patch/patch: 0.9983981761086407

OK, almost no improvement. So in your case, most BLOCK_GROUP_ITEMS are 
not at the tail of a extent tree leaf.
And in our test environment, it seems that quite some BLOCK_GROUPS_ITEMS 
are at the tail of an extent tree leaf, and make the improvement quite 
obvious.

But anyway, if we can change the on-disk format to introduce a specific 
block group items tree, then I assume the mount time would reduce to 
less than 5 seconds.

Thanks,
Qu
>
> Thank you,
> John
>


