Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63825 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751279AbcGOD4m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 23:56:42 -0400
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
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <126f9f09-4e28-3c12-5384-63032e17942f@cn.fujitsu.com>
Date: Fri, 15 Jul 2016 11:56:32 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYSW+SvbBrh1u_x+c3HTRx03qSR6BoH5cj_VzCXxZYv6EA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the late reply.

[Slow mount]
In fact we also reproduce the same problem, and found the problem.

It's related to the size of extent tree.

If the extent tree is large enough, mount needs to do quite a lot of IO 
to read out all block group items.
And such read is random small read (default leaf size is just 16K), and 
considering the per GB cost, spinning rust is the normal choice for such 
large fs, which makes random small read even more slower.


The good news is, we have patch to slightly speedup the mount, by 
avoiding reading out unrelated tree blocks.

In our test environment, it takes 15% less time to mount a fs filled 
with 16K files(2T used space).

https://patchwork.kernel.org/patch/9021421/


And according to the facts that only extent size is related to the 
problem, any method to reduce extent tree size will help, including 
defrag, nodatacow.

[Btrfsck OOM]
Lu Fengqi is developing btrfsck low memory usage mode.
It's not merged into mainline btrfs progs and not fully completely, but 
shows quite positive result for large fs.

It may needs sometime to get it stable, but IMHO it's going the right 
direction.

Thanks,
Qu



At 07/12/2016 04:31 AM, John Ettedgui wrote:
> On Wed, Aug 5, 2015 at 4:30 AM Austin S Hemmelgarn <ahferroin7@gmail.com
> <mailto:ahferroin7@gmail.com>> wrote:
>> Yeah, you're probably better off getting a TB disk and starting with
>> that. In theory it is possible to automate the process, but I would
>> advise against that if at all possible, it's a lot easier to recover
>> from an error if you're doing it manually.
>
> Hello,
>
> Has there been any progress on this issue?
>
> My btrfs partitions are now all cleanly made, not converted from ext4,
> and yet they still take up to 30s to mount. Interestingly they're all
> about the same size, but some take quite longer than others.. I guess
> differences FS related.
>
>
> Thank you!
> John


