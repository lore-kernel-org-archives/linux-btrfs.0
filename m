Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62349 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbcGOFZI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 01:25:08 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55BADEC4.3020409@cn.fujitsu.com>
 <CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
 <55BAFEF9.1070107@cn.fujitsu.com>
 <CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
 <55BB0A39.1050208@cn.fujitsu.com>
 <CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
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
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fd718727-9b54-ba58-5f39-63066181d13e@cn.fujitsu.com>
Date: Fri, 15 Jul 2016 13:24:45 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYRXwDVVfT0TRRiM9dEw-7TvY8qG=WvMYKczZOv6wkFWAQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/15/2016 12:39 PM, John Ettedgui wrote:
> On Thu, Jul 14, 2016 at 8:56 PM Qu Wenruo <quwenruo@cn.fujitsu.com
> <mailto:quwenruo@cn.fujitsu.com>> wrote:
>
>     Sorry for the late reply.
>
> Oh it's all good, it's only a been a few days.
>
>     [Slow mount]
>     In fact we also reproduce the same problem, and found the problem.
>
> Awesome!
>
>     It's related to the size of extent tree.
>
>     If the extent tree is large enough, mount needs to do quite a lot of IO
>     to read out all block group items.
>     And such read is random small read (default leaf size is just 16K), and
>     considering the per GB cost, spinning rust is the normal choice for such
>     large fs, which makes random small read even more slower.
>
>
>     The good news is, we have patch to slightly speedup the mount, by
>     avoiding reading out unrelated tree blocks.
>
>     In our test environment, it takes 15% less time to mount a fs filled
>     with 16K files(2T used space).
>
>     https://patchwork.kernel.org/patch/9021421/
>
>
> Great, I will try this and report on it.
>
>     And according to the facts that only extent size is related to the
>     problem, any method to reduce extent tree size will help, including
>     defrag, nodatacow.
>
> Would increasing the leaf size help as well?
May help.
But didn't test it, and since leafsize can only be determined at mkfs 
time, it's not an easy thing to try it.

> nodatacow seems unsafe
Nodatacow is not that unsafe, as btrfs will still do data cow if it's 
needed, like rewriting data of another subvolume/snapshot.

That would be one of the most obvious method if you do a lot of rewrite.

> as for defrag, all my partitions are already on
> autodefrag, so I assume that should be good. Or is manual once in a
> while a good idea as well?
AFAIK autodefrag will only help if you're doing appending write.

Manual one will help more, but since btrfs has problem defraging extents 
shared by different subvolumes, I doubt the effect if you have a lot of 
subvolumes/snapshots.


Another method is to disable compression.
For compression, file extent size up limit is 128K, while for 
non-compress case, it's 128M.

So for the same 1G sized file, it would cause 8K extents using 
compression, while only 8 extents without compression.

>
> Is there a way to display the tree size? that would help knowing what
> worked and what didn't.

You can dump the whole extent tree to get the accurate size:

# btrfs-debug-tree -t 2 <your dev> > some_file

It may be quite long, so output redirection is highly recommended.
You can do it online(mounted), but if the fs is very very large, it's 
recommended to do it offline(unmounted), or at least make sure there is 
not much write while mounted.

Check the first few line then you can already get the overall size:

------
btrfs-progs v4.6.1
extent tree key (EXTENT_TREE ROOT_ITEM 0)
node 30441472 level *1* items 41 free 452 generation 7 owner 2
------

If the level is high (7 is the highest possible value), it's almost sure 
that's the problem.

For accurate space size, use the following scrip
t to get the number of extent tree blocks:

------
$ egrep -e "^node" -e "^leaf" some_file | wc -l
------

Then multiple it by nodesize, you get the accurate size of extent tree.

Thanks,
Qu
>
>
>     [Btrfsck OOM]
>     Lu Fengqi is developing btrfsck low memory usage mode.
>     It's not merged into mainline btrfs progs and not fully completely, but
>     shows quite positive result for large fs.
>
>     It may needs sometime to get it stable, but IMHO it's going the right
>     direction.
>
> Well that is great news as well, thank you for sharing it!
>
>     Thanks,
>     Qu
>
>
> Thank you!
> John


