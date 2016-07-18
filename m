Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28445 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326AbcGRBOP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 21:14:15 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
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
 <fd718727-9b54-ba58-5f39-63066181d13e@cn.fujitsu.com>
 <CAJ3TwYSTnQfj=qmBLtnmtXQKexMMD4x=9Gk3p3anf4uF+G26kw@mail.gmail.com>
 <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com>
Date: Mon, 18 Jul 2016 09:13:57 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/16/2016 07:17 PM, John Ettedgui wrote:
> On Thu, Jul 14, 2016 at 10:54 PM John Ettedgui <john.ettedgui@gmail.com
> <mailto:john.ettedgui@gmail.com>> wrote:
>
>     On Thu, Jul 14, 2016 at 10:26 PM Qu Wenruo <quwenruo@cn.fujitsu.com
>     <mailto:quwenruo@cn.fujitsu.com>> wrote:
>
>
>         > Would increasing the leaf size help as well?
>
>         > nodatacow seems unsafe
>
>
>         Nodatacow is not that unsafe, as btrfs will still do data cow if
>         it's
>         needed, like rewriting data of another subvolume/snapshot.
>
>     Alright.
>
>         That would be one of the most obvious method if you do a lot of
>         rewrite.
>
>         > as for defrag, all my partitions are already on
>         > autodefrag, so I assume that should be good. Or is manual once
>         in a
>         > while a good idea as well?
>         AFAIK autodefrag will only help if you're doing appending write.
>
>         Manual one will help more, but since btrfs has problem defraging
>         extents
>         shared by different subvolumes, I doubt the effect if you have a
>         lot of
>         subvolumes/snapshots.
>
>     I don't have any subvolume/snapshot for the big partitions, my usage
>     there is fairly simple. I'll have to add a regular defrag job then.
>
>
>         Another method is to disable compression.
>         For compression, file extent size up limit is 128K, while for
>         non-compress case, it's 128M.
>
>         So for the same 1G sized file, it would cause 8K extents using
>         compression, while only 8 extents without compression.
>
>     Now that might be something important, I do use LZO compression on
>     all of them.
>     Does this limit apply to only compressed files, or any file if the
>     fs is mounted using the compression option?
>     Would mounting these partitions without compression option and then
>     defragmenting them reverse the compression?
>
> I've tried this for the slowest to mount partition.
> I changed its mount option to compression=no, run defrag and balance.
> Not sure if the latter was needed but I thought to try... like in the
> past it worked fine up to dusage=99 but with 100% I get a crash, oh well.
> The result of defrag + nocompress (I don't know how much it actually
> decompressed, and if it changed the limit Qu mentioned before) is about
> 26% less time spent to mount the partition, and it's no more my slowerst
> partition to mount.!

Well, compression=no only affects any write after the mount option.
And balance won't help to convert compressed extent to non-compressed one.

But maybe the defrag will convert them to normal extents.

The best method to de-compress them is, to read them out and rewrite 
them with compression=no mount option.

>
> I'll try just defragmenting another partition but keeping the
> compression on and see what difference I get there the same changes.
>
> I've tried the patch, which applied fine to my kernel (4.6.4) but I
> don't see any difference in mounting time, maybe I made a mistake or my
> issue is not really the same?

Pretty possible that there is another problem causing the slow mount.

The best method to verify is to do a ftrace on the btrfs mount.
Here is the script I tested my patch:

------
#!/bin/bash

trace_dir=/sys/kernel/debug/tracing

init_trace () {
	echo 0 > $trace_dir/tracing_on
	echo > $trace_dir/trace
	echo function_graph > $trace_dir/current_tracer
	echo > $trace_dir/set_ftrace_filter

	echo open_ctree			>> $trace_dir/set_ftrace_filter
	echo btrfs_read_chunk_tree	>> $trace_dir/set_ftrace_filter
	echo btrfs_read_block_groups	>> $trace_dir/set_ftrace_filter

	# This will generate tons of trace, better to comment it out
	echo find_block_group		>> $trace_dir/set_ftrace_filter

	echo 1 > $trace_dir/tracing_on
}

end_trace () {
	cp $trace_dir/trace $(dirname $0)
	echo 0 > $trace_dir/tracing_on
	echo > $trace_dir/set_ftrace_filter
	echo > $trace_dir/trace
}

init_trace
echo start mounting
time mount /dev/sdb /mnt/test
echo mount done
end_trace
------

After executing the script, you got a file named "trace" at the same 
directory of the script.

The content will be like:
------
# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
  1) $ 7670856 us  |  open_ctree [btrfs]();
  2) * 13533.45 us |    btrfs_read_chunk_tree [btrfs]();
  2) # 1320.981 us |    btrfs_init_space_info [btrfs]();
  2)               |    btrfs_read_block_groups [btrfs]() {
  2) * 10127.35 us |      find_block_group [btrfs]();
  2)   4.951 us    |      find_block_group [btrfs]();
  2) * 26225.17 us |      find_block_group [btrfs]();
......
  3) * 26450.28 us |      find_block_group [btrfs]();
  3) * 11590.29 us |      find_block_group [btrfs]();
  3) $ 7557210 us  |    } /* btrfs_read_block_groups [btrfs] */ <<<
------

And you can see open_ctree() function, the main part of btrfs mount, 
takes about 7.67 seconds to execute, while btrfs_read_block_groups() 
takes 7.56 seconds, about 98.6% of the open_ctree() executing time.

If your result are much the same as mine, then that's the same problem.

And after applying my patch, please try to compare the executing time of 
btrfs_read_block_groups() to see if there is any obvious(>5%) change.

Thanks,
Qu

>
> Thank you,
> John


