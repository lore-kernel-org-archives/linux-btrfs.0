Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6888 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750800AbdBOGl6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 01:41:58 -0500
Subject: Re: btrfs/125 deadlock using nospace_cache or space_cache=v2
To: Anand Jain <anand.jain@oracle.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <0daf31e9-d666-5044-f9a9-fcf54576a144@cn.fujitsu.com>
 <7ecb7b66-72d1-2bbd-b6f4-91550f2e1ab3@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <955bdf2a-6d44-01d1-a19d-10fad8f7760b@cn.fujitsu.com>
Date: Wed, 15 Feb 2017 14:41:49 +0800
MIME-Version: 1.0
In-Reply-To: <7ecb7b66-72d1-2bbd-b6f4-91550f2e1ab3@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

State updated:

The deadlock seems to be caused by 2 bugs:

1) Bad error handling in run_delalloc_nocow()
    The direct cause is, btrfs_reloc_clone_csums() fails and return -EIO.
    Then error handler will call extent_clear_unlock_delalloc() to
    clear dirty flag and end writeback of the resting pages in the
    extent.

    However this makes the ordered extent not happy, as it just skips IO
    of the remaining pages, which ordered extent relies on to finish.

    This is quite easy to reproduce using the following modification:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e861a0..b9d0bcb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1497,8 +1497,11 @@ static noinline int run_delalloc_nocow(struct 
inode *inode,

                 if (root->root_key.objectid ==
                     BTRFS_DATA_RELOC_TREE_OBJECTID) {
+                       ret = -EIO;
+                               /*
                         ret = btrfs_reloc_clone_csums(inode, cur_offset,
                                                       num_bytes);
+                                                     */
                         if (ret) {
                                 if (!nolock && nocow)
 
btrfs_end_write_no_snapshoting(root);


    Then any balance will cause btrfs to wait ordered extent which will
    never finish, just like what we encountered.

2) RAID5/6 recover not working in some tree operation.
    In fact, btrfs succeeded to mount the fs, so RAID5/6 recover code is
    working, at least for some trees.

    And btrfs succeeded in recovering all the data with correct checksum,
    if using normal read(cat works here) before balance.

    However it fails to read csum tree and causes run_delalloc_nocow() to
    return -EIO, which leads to above bug.

    So there is something related to RAID5/6 code, maybe readahead? which
    contributes to this bug.

I'll continue digging and keep the state updated if anyone is interested 
in this bug.

Thanks,
Qu


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


