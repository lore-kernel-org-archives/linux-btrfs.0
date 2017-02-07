Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26970 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752035AbdBGI0g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 03:26:36 -0500
Subject: Re: btrfs/125 deadlock using nospace_cache or space_cache=v2
To: Anand Jain <anand.jain@oracle.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <0daf31e9-d666-5044-f9a9-fcf54576a144@cn.fujitsu.com>
 <7ecb7b66-72d1-2bbd-b6f4-91550f2e1ab3@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f4c97521-0d28-93ec-6c92-98af6b1bb9dd@cn.fujitsu.com>
Date: Tue, 7 Feb 2017 16:26:29 +0800
MIME-Version: 1.0
In-Reply-To: <7ecb7b66-72d1-2bbd-b6f4-91550f2e1ab3@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

At 02/07/2017 04:02 PM, Anand Jain wrote:
>
> Hi Qu,
>
>  I don't think I have seen this before, I don't know the reason
>  why I wrote this, may be to test encryption, however it was all
>  with default options.
>
>  But now I could reproduce and, looks like balance fails to
>  start with IO error though the mount is successful.
> ------------------
> # tail -f ./results/btrfs/125.full
>     intense and takes potentially very long. It is recommended to
>     use the balance filters to narrow down the balanced data.
>     Use 'btrfs balance start --full-balance' option to skip this
>     warning. The operation will start in 10 seconds.
>     Use Ctrl-C to stop it.
> 10 9 8 7 6 5 4 3 2 1ERROR: error during balancing '/scratch':
> Input/output error
> There may be more info in syslog - try dmesg | tail
>
> Starting balance without any filters.
> failed: '/root/bin/btrfs balance start /scratch'
> --------------------
>
>  This must be fixed. For debugging if I add a sync before previous
>  unmount, the problem isn't reproduced. just fyi. Strange.

Thanks for the extra info, this seems to be a clue to dig further.

Thanks,
Qu
>
> -------
> diff --git a/tests/btrfs/125 b/tests/btrfs/125
> index 91aa8d8c3f4d..4d4316ca9f6e 100755
> --- a/tests/btrfs/125
> +++ b/tests/btrfs/125
> @@ -133,6 +133,7 @@ echo "-----Mount normal-----" >> $seqres.full
>  echo
>  echo "Mount normal and balance"
>
> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>  _scratch_unmount
>  _run_btrfs_util_prog device scan
>  _scratch_mount >> $seqres.full 2>&1
> ------
>
>  HTH.
>
> Thanks, Anand
>
>
> On 02/07/17 14:09, Qu Wenruo wrote:
>> Hi Anand,
>>
>> I found that btrfs/125 test case can only pass if we enabled space cache.
>>
>> If using nospace_cache or space_cache=v2 mount option, it will get
>> blocked forever with the following callstack(the only blocked process):
>>
>> [11382.046978] btrfs           D11128  6705   6057 0x00000000
>> [11382.047356] Call Trace:
>> [11382.047668]  __schedule+0x2d4/0xae0
>> [11382.047956]  schedule+0x3d/0x90
>> [11382.048283]  btrfs_start_ordered_extent+0x160/0x200 [btrfs]
>> [11382.048630]  ? wake_atomic_t_function+0x60/0x60
>> [11382.048958]  btrfs_wait_ordered_range+0x113/0x210 [btrfs]
>> [11382.049360]  btrfs_relocate_block_group+0x260/0x2b0 [btrfs]
>> [11382.049703]  btrfs_relocate_chunk+0x51/0xf0 [btrfs]
>> [11382.050073]  btrfs_balance+0xaa9/0x1610 [btrfs]
>> [11382.050404]  ? btrfs_ioctl_balance+0x3a0/0x3b0 [btrfs]
>> [11382.050739]  btrfs_ioctl_balance+0x3a0/0x3b0 [btrfs]
>> [11382.051109]  btrfs_ioctl+0xbe7/0x27f0 [btrfs]
>> [11382.051430]  ? trace_hardirqs_on+0xd/0x10
>> [11382.051747]  ? free_object+0x74/0xa0
>> [11382.052084]  ? debug_object_free+0xf2/0x130
>> [11382.052413]  do_vfs_ioctl+0x94/0x710
>> [11382.052750]  ? enqueue_hrtimer+0x160/0x160
>> [11382.053090]  ? do_nanosleep+0x71/0x130
>> [11382.053431]  SyS_ioctl+0x79/0x90
>> [11382.053735]  entry_SYSCALL_64_fastpath+0x18/0xad
>> [11382.054570] RIP: 0033:0x7f397d7a6787
>>
>> I also found in the test case, we only have 3 continuous data extents,
>> whose sizes are 1M, 68.5M and 31.5M respectively.
>>
>> Original data block group:
>> 0       1M                     64M    69.5M                  101M   128M
>> | Ext A |     Extent B(68.5M)         |    Extent C(31.5M)   |
>>
>>
>> While relocation write them in 4 extents:
>> 0~1M            :same as Extent A.         (1st)
>> 1M~68.3438M     :smaller than Extent B     (2nd)
>> 68.3438M~69.5M  :tail part of Extent B     (3rd)
>> 69.5M~ 101M     :same as Extent C.         (4th)
>>
>> However only ordered extent of (3rd) and (4th) get finished.
>> While ordered extent of (1st) and (2nd) never reached
>> finish_ordered_io().
>>
>> So relocation will wait for no one to finish the these two ordered
>> extent, and get blocked.
>>
>> Did you experienced the same bug submitting the test case?
>> Is there any known fix for it?
>>
>> Thanks,
>> Qu
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


