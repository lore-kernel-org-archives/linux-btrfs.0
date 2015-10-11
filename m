Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38446 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbJKSJh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 14:09:37 -0400
Received: by wiclk2 with SMTP id lk2so126595277wic.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 11:09:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54AC65C2.8000801@jp.fujitsu.com>
References: <1420473663-9315-1-git-send-email-naota@elisp.net>
	<54AC65C2.8000801@jp.fujitsu.com>
Date: Sun, 11 Oct 2015 20:09:36 +0200
Message-ID: <CAOcd+r10Q08zhvjMawOrQ8jWBReD6dYxeEtiZSoqUEuHCeM27g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: clear bio reference after submit_one_bio()
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Naohiro Aota <naota@elisp.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Naota,

What happens if btrfs_bio_alloc() in submit_extent_page fails? Then we
return -ENOMEM to the caller, but we do not set *bio_ret to NULL. And
if *bio_ret was non-NULL upon entry into submit_extent_page, then we
had submitted this bio before getting to btrfs_bio_alloc(). So should
btrfs_bio_alloc() failure be handled in the same way?

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3915c94..cd443bc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2834,8 +2834,11 @@ static int submit_extent_page(int rw, struct
extent_io_tree *tree,

        bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
                        GFP_NOFS | __GFP_HIGH);
-       if (!bio)
+       if (!bio) {
+               if (bio_ret)
+                       *bio_ret = NULL;
                return -ENOMEM;
+       }

        bio_add_page(bio, page, page_size, offset);
        bio->bi_end_io = end_io_func;


Thanks,
Alex.

On Wed, Jan 7, 2015 at 12:46 AM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:
> Hi Naota,
>
> On 2015/01/06 1:01, Naohiro Aota wrote:
>> After submit_one_bio(), `bio' can go away. However submit_extent_page()
>> leave `bio' referable if submit_one_bio() failed (e.g. -ENOMEM on OOM).
>> It will cause invalid paging request when submit_extent_page() is called
>> next time.
>>
>> I reproduced ENOMEM case with the following script (need
>> CONFIG_FAIL_PAGE_ALLOC, and CONFIG_FAULT_INJECTION_DEBUG_FS).
>
> I confirmed that this problem reproduce with 3.19-rc3 and
> not reproduce with 3.19-rc3 with your patch.
>
> Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>
> Thank you for reporting this problem with the reproducer
> and fixing it too.
>
>   NOTE:
>   I used v3.19-rc3's tools/testing/fault-injection/failcmd.sh
>   for the following "./failcmd.sh".
>
>   >            ./failcmd.sh -p $percent -t $times -i $interval \
>   >                    --ignore-gfp-highmem=N --ignore-gfp-wait=N --min-order=0 \
>   >                    -- \
>   >                    cat $directory/file > /dev/null
>
> * 3.19-rc1 + your patch
>
> ===============================================================================
> # ./run
> 512+0 records in
> 512+0 records out
> #
> ===============================================================================
>
> * 3.19-rc3
>
> ===============================================================================
> # ./run
> 512+0 records in
> 512+0 records out
> [  188.433726] run (776): drop_caches: 1
> [  188.682372] FAULT_INJECTION: forcing a failure.
> name fail_page_alloc, interval 100, probability 111000, space 0, times 3
> [  188.689986] CPU: 0 PID: 954 Comm: cat Not tainted 3.19.0-rc3-ktest #1
> [  188.693834] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [  188.698466]  0000000000000064 ffff88007b343618 ffffffff816e5563 ffff88007fc0fc78
> [  188.702730]  ffffffff81c655c0 ffff88007b343638 ffffffff813851b5 0000000000000010
> [  188.707043]  0000000000000002 ffff88007b343768 ffffffff81188126 ffff88007b3435a8
> [  188.711283] Call Trace:
> [  188.712620]  [<ffffffff816e5563>] dump_stack+0x45/0x57
> [  188.715330]  [<ffffffff813851b5>] should_fail+0x135/0x140
> [  188.718218]  [<ffffffff81188126>] __alloc_pages_nodemask+0xd6/0xb30
> [  188.721567]  [<ffffffff81339075>] ? blk_rq_map_sg+0x35/0x170
> [  188.724558]  [<ffffffffa0010705>] ? virtio_queue_rq+0x145/0x2b0 [virtio_blk]
> [  188.728191]  [<ffffffffa01bd00f>] ? btrfs_submit_compressed_read+0xcf/0x4d0 [btrfs]
> [  188.732079]  [<ffffffff811d99fb>] ? kmem_cache_alloc+0x1cb/0x230
> [  188.735153]  [<ffffffff81181265>] ? mempool_alloc_slab+0x15/0x20
> [  188.738188]  [<ffffffff811cee1a>] alloc_pages_current+0x9a/0x120
> [  188.741153]  [<ffffffffa01bd0e9>] btrfs_submit_compressed_read+0x1a9/0x4d0 [btrfs]
> [  188.744835]  [<ffffffffa0178621>] btrfs_submit_bio_hook+0x1c1/0x1d0 [btrfs]
> [  188.748225]  [<ffffffffa018b7b3>] ? lookup_extent_mapping+0x13/0x20 [btrfs]
> [  188.751547]  [<ffffffffa0179c08>] ? btrfs_get_extent+0x98/0xad0 [btrfs]
> [  188.754656]  [<ffffffffa01901d7>] submit_one_bio+0x67/0xa0 [btrfs]
> [  188.757554]  [<ffffffffa0193f27>] submit_extent_page.isra.35+0xd7/0x1c0 [btrfs]
> [  188.760981]  [<ffffffffa019509d>] __do_readpage+0x31d/0x7b0 [btrfs]
> [  188.763920]  [<ffffffffa0195f10>] ? btrfs_create_repair_bio+0x110/0x110 [btrfs]
> [  188.767382]  [<ffffffffa0179b70>] ? btrfs_submit_direct+0x7b0/0x7b0 [btrfs]
> [  188.770671]  [<ffffffffa018f88d>] ? btrfs_lookup_ordered_range+0x13d/0x180 [btrfs]
> [  188.774366]  [<ffffffffa01958ca>] __extent_readpages.constprop.42+0x2ba/0x2d0 [btrfs]
> [  188.778031]  [<ffffffffa0179b70>] ? btrfs_submit_direct+0x7b0/0x7b0 [btrfs]
> [  188.781241]  [<ffffffffa01969b9>] extent_readpages+0x169/0x1b0 [btrfs]
> [  188.784322]  [<ffffffffa0179b70>] ? btrfs_submit_direct+0x7b0/0x7b0 [btrfs]
> [  188.789014]  [<ffffffffa0176b0f>] btrfs_readpages+0x1f/0x30 [btrfs]
> [  188.792028]  [<ffffffff8118bf5c>] __do_page_cache_readahead+0x18c/0x1f0
> [  188.795078]  [<ffffffff8118c09f>] ondemand_readahead+0xdf/0x260
> [  188.797702]  [<ffffffffa016c5df>] ? btrfs_congested_fn+0x5f/0xa0 [btrfs]
> [  188.800718]  [<ffffffff8118c291>] page_cache_async_readahead+0x71/0xa0
> [  188.803650]  [<ffffffff8118017f>] generic_file_read_iter+0x40f/0x5e0
> [  188.806480]  [<ffffffff811f43be>] new_sync_read+0x7e/0xb0
> [  188.808832]  [<ffffffff811f55d8>] __vfs_read+0x18/0x50
> [  188.811068]  [<ffffffff811f569a>] vfs_read+0x8a/0x140
> [  188.813298]  [<ffffffff811f5796>] SyS_read+0x46/0xb0
> [  188.815486]  [<ffffffff81125806>] ? __audit_syscall_exit+0x1f6/0x2a0
> [  188.818293]  [<ffffffff816eb8e9>] system_call_fastpath+0x12/0x17
> [  188.821005] BUG: unable to handle kernel paging request at 000000010000000c
> [  188.821984] IP: [<ffffffffa01901b3>] submit_one_bio+0x43/0xa0 [btrfs]
> [  188.821984] PGD 7bad3067 PUD 0
> [  188.821984] Oops: 0000 [#1] SMP
> [  188.821984] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables bnep bluetooth rfkill btrfs xor raid6_pq microcode 8139too serio_raw virtio_balloon 8139cp mii nfsd auth_rpcgss nfs_acl lockd grace sunrpc virtio_blk ata_generic pata_acpi
> [  188.821984] CPU: 1 PID: 954 Comm: cat Not tainted 3.19.0-rc3-ktest #1
> [  188.821984] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [  188.821984] task: ffff880037665220 ti: ffff88007b340000 task.ti: ffff88007b340000
> [  188.821984] RIP: 0010:[<ffffffffa01901b3>]  [<ffffffffa01901b3>] submit_one_bio+0x43/0xa0 [btrfs]
> [  188.821984] RSP: 0018:ffff88007b3438c8  EFLAGS: 00010202
> [  188.821984] RAX: 0000000000000000 RBX: ffff88007c282ba8 RCX: 0000000000010001
> [  188.821984] RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000000
> [  188.821984] RBP: ffff88007b3438d8 R08: ffffea0001e33100 R09: 00000000000027df
> [  188.821984] R10: ffff88007fd1c000 R11: 0000000000dbb000 R12: ffff88007b343b40
> [  188.821984] R13: ffff88007c282ba8 R14: 0000000000006dd8 R15: ffff880071584f80
> [  188.821984] FS:  00007fdf777c5740(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
> [  188.821984] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  188.821984] CR2: 000000010000000c CR3: 000000007bf59000 CR4: 00000000000006e0
> [  188.821984] Stack:
> [  188.821984]  0000000000001000 ffff88007b343b40 ffff88007b343938 ffffffffa0193f27
> [  188.821984]  ffff88007b343938 0000000000000001 0000000000000000 ffffea0001e33180
> [  188.821984]  00000000027e0000 0000000000001000 ffff88007cc24680 ffff88007b343b50
> [  188.821984] Call Trace:
> [  188.821984]  [<ffffffffa0193f27>] submit_extent_page.isra.35+0xd7/0x1c0 [btrfs]
> [  188.821984]  [<ffffffffa019509d>] __do_readpage+0x31d/0x7b0 [btrfs]
> [  188.821984]  [<ffffffffa0195f10>] ? btrfs_create_repair_bio+0x110/0x110 [btrfs]
> [  188.821984]  [<ffffffffa0179b70>] ? btrfs_submit_direct+0x7b0/0x7b0 [btrfs]
> [  188.821984]  [<ffffffffa018f88d>] ? btrfs_lookup_ordered_range+0x13d/0x180 [btrfs]
> [  188.821984]  [<ffffffffa01958ca>] __extent_readpages.constprop.42+0x2ba/0x2d0 [btrfs]
> [  188.821984]  [<ffffffffa0179b70>] ? btrfs_submit_direct+0x7b0/0x7b0 [btrfs]
> [  188.821984]  [<ffffffffa01969b9>] extent_readpages+0x169/0x1b0 [btrfs]
> [  188.821984]  [<ffffffffa0179b70>] ? btrfs_submit_direct+0x7b0/0x7b0 [btrfs]
> [  188.821984]  [<ffffffffa0176b0f>] btrfs_readpages+0x1f/0x30 [btrfs]
> [  188.821984]  [<ffffffff8118bf5c>] __do_page_cache_readahead+0x18c/0x1f0
> [  188.821984]  [<ffffffff8118c09f>] ondemand_readahead+0xdf/0x260
> [  188.821984]  [<ffffffffa016c5df>] ? btrfs_congested_fn+0x5f/0xa0 [btrfs]
> [  188.821984]  [<ffffffff8118c291>] page_cache_async_readahead+0x71/0xa0
> [  188.821984]  [<ffffffff8118017f>] generic_file_read_iter+0x40f/0x5e0
> [  188.821984]  [<ffffffff811f43be>] new_sync_read+0x7e/0xb0
> [  188.821984]  [<ffffffff811f55d8>] __vfs_read+0x18/0x50
> [  188.821984]  [<ffffffff811f569a>] vfs_read+0x8a/0x140
> [  188.821984]  [<ffffffff811f5796>] SyS_read+0x46/0xb0
> [  188.821984]  [<ffffffff81125806>] ? __audit_syscall_exit+0x1f6/0x2a0
> [  188.821984]  [<ffffffff816eb8e9>] system_call_fastpath+0x12/0x17
> [  188.821984] Code: c1 e0 04 48 8d 44 06 f0 48 8b 73 50 4c 8b 00 8b 40 0c 4d 8b 48 10 48 c7 43 50 00 00 00 00 f0 ff 43 74 48 8b 76 20 48 85 f6 74 4d <4c> 8b 56 18 4d 85 d2 74 44 4d 8b 58 08 49 c1 e1 0c 49 89 c8 89
> [  188.821984] RIP  [<ffffffffa01901b3>] submit_one_bio+0x43/0xa0 [btrfs]
> [  188.821984]  RSP <ffff88007b3438c8>
> [  188.821984] CR2: 000000010000000c
> [  188.953169] ---[ end trace 498f24be78e8baad ]---
> #
> ===============================================================================
>
> Thanks,
> Satoru
>
>>
>>    #!/bin/bash
>>
>>    dmesgout=dmesg.txt
>>    start=100000
>>    end=300000
>>    step=1000
>>
>>    # btrfs options
>>    device=/dev/vdb1
>>    directory=/mnt/btrfs
>>
>>    # fault-injection options
>>    percent=100
>>    times=3
>>
>>    mkdir -p $directory || exit 1
>>    mount -o compress $device $directory || exit 1
>>
>>    rm -f $directory/file || exit 1
>>    dd if=/dev/zero of=$directory/file bs=1M count=512 || exit 1
>>
>>    for interval in `seq $start $step $end`; do
>>            dmesg -C
>>            echo 1 > /proc/sys/vm/drop_caches
>>            sync
>>            export FAILCMD_TYPE=fail_page_alloc
>>            ./failcmd.sh -p $percent -t $times -i $interval \
>>                    --ignore-gfp-highmem=N --ignore-gfp-wait=N --min-order=0 \
>>                    -- \
>>                    cat $directory/file > /dev/null
>>            dmesg > ${dmesgout}
>>            if grep -q BUG: ${dmesgout}; then
>>                    cat ${dmesgout}
>>                    exit 1
>>            fi
>>    done
>>
>>    umount $directory
>>    exit 0
>>
>> Signed-off-by: Naohiro Aota <naota@elisp.net>
>> ---
>>   fs/btrfs/extent_io.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 4ebabd2..4421161 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2816,8 +2816,10 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
>>                   bio_add_page(bio, page, page_size, offset) < page_size) {
>>                       ret = submit_one_bio(rw, bio, mirror_num,
>>                                            prev_bio_flags);
>> -                     if (ret < 0)
>> +                     if (ret < 0) {
>> +                             *bio_ret = NULL;
>>                               return ret;
>> +                     }
>>                       bio = NULL;
>>               } else {
>>                       return 0;
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
