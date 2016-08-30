Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17313 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754185AbcH3CQ3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 22:16:29 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        <linux-btrfs@vger.kernel.org>
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57C4EB85.7030000@cn.fujitsu.com>
Date: Tue, 30 Aug 2016 10:12:21 +0800
MIME-Version: 1.0
In-Reply-To: <1472485953.3290.0.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 08/29/2016 11:52 PM, Ronan Arraes Jardim Chagas wrote:
> Hi guys,
>
> I just have the problem again. Now, it happens during the lunch time
> when the machine was idle. Only the system processes were running. It
> was not the first time that I saw this problem just after lunch when
> the machine stayed idle for a long period (+- 1h).
>
> Here is the information requested:
>
> /sys/fs/btrfs/$UUID/allocation/data
>
> ./bytes_may_use
> 0
> ./bytes_pinned
> 0
> ./bytes_reserved
> 0
> ./bytes_used
> 36128374784
> ./disk_total
> 37589352448
> ./disk_used
> 36128374784
> ./flags
> 1
> ./total_bytes
> 37589352448
> ./total_bytes_pinned
> 20339560448
> ./single/total_bytes
> 37589352448
> ./single/used_bytes
> 36128374784
>
> /sys/fs/btrfs/$UUID/allocation/metadata
>
> ./bytes_may_use
> 84974452736
> ./bytes_pinned
> 0
> ./bytes_reserved
> 0
> ./bytes_used
> 977354752
> ./disk_total
> 4294967296
> ./disk_used
> 1954709504
> ./flags
> 4
> ./total_bytes
> 2147483648
> ./total_bytes_pinned
> -57851904
> ./dup/total_bytes
> 2147483648
> ./dup/used_bytes
> 977354752

For metadata, "bytes_may_use" is about 80GB, it's very big,
I think this value is very abnormal.

So this explains why you have huge unallocated space, you still
get ENOSPC error. In kernel btrfs, there is a function should_alloc_chunk()
to determine whether to allocate new chunks(new device space)
  num_bytes = total_bytes - bytes_readonly; it's 2147483648
  num_allocated = bytes_used + bytes_reserved; it's 977354752

if num_allocated < num_bytes * 0.8, it will not allocate new device 
space :) even you
have huge unallocated space.

I think the root reason is that bytes_may_use has some computation error and
is not be converted to bytes_used or bytes_reserved.

I just explain why you get ENOSPC error even with huge unallocated space 
from
codes :)

>
> # btrfs fi usage /
>
> btrfs_destroy_inode+0x23f/0x2b0 [btrfs]
> Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff8121f6d1>]
> do_unlinkat+0x131/0x310
> Ago 29 12:06:07 ronanarraes-osd kernel:  [<ffffffff816bb4f6>]
> entry_SYSCALL_64_fastpath+0x1e/0xa8
> Ago 29 12:06:07 ronanarraes-osd kernel: DWARF2 unwinder stuck at
> entry_SYSCALL_64_fastpath+0x1e/0xa8
> Ago 29 12:06:07 ronanarraes-osd kernel:
> Ago 29 12:06:07 ronanarraes-osd kernel: Leftover inexact backtrace:
> Ago 29 12:06:07 ronanarraes-osd kernel: ---[ end trace 5774bd3049f78a63
> ]---
Yes, I know these WARNINGs, but indeed they are already results,
we don't know the procedures which cause these results.

Can you work out a reproducer for this ENOSPC error, then I can
dig into codes to figure out the true reason.

Regards,
Xiaoguang Wang

>
> Best regards,
> Ronan Arraes
>
>



