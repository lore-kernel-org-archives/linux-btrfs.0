Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33240 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZQen (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 11:34:43 -0500
Received: by mail-la0-f52.google.com with SMTP id q1so2822092lam.11
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 08:34:42 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5475FEC7.2050606@fb.com>
References: <1417015735-8581-1-git-send-email-fdmanana@suse.com>
	<1417015735-8581-3-git-send-email-fdmanana@suse.com>
	<5475F85F.7090705@fb.com>
	<CAL3q7H4-gUg8W2zFR15Uk38b6S4K9P66mdf7JUMBni8WSjT75Q@mail.gmail.com>
	<5475FEC7.2050606@fb.com>
Date: Wed, 26 Nov 2014 16:34:41 +0000
Message-ID: <CAL3q7H6VpvJDdO_aAF60zq_ftCam9naf12pCa16kgP8NN7DdQQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] Btrfs: fix crash caused by block group removal
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 26, 2014 at 4:24 PM, Josef Bacik <jbacik@fb.com> wrote:
> On 11/26/2014 11:09 AM, Filipe David Manana wrote:
>>
>> On Wed, Nov 26, 2014 at 3:57 PM, Josef Bacik <jbacik@fb.com> wrote:
>>>
>>> On 11/26/2014 10:28 AM, Filipe Manana wrote:
>>>>
>>>>
>>>> If we remove a block group (because it became empty), we might have left
>>>> a caching_ctl structure in fs_info->caching_block_groups that points to
>>>> the block group and is accessed at transaction commit time. This results
>>>> in accessing an invalid or incorrect block group. This issue became
>>>> visible
>>>> after Josef's patch "Btrfs: remove empty block groups automatically".
>>>>
>>>> So if the block group is removed make sure we don't leave a dangling
>>>> caching_ctl in caching_block_groups.
>>>>
>>>> Sample crash trace:
>>>>
>>>> [58380.439449] BUG: unable to handle kernel paging request at
>>>> ffff8801446eaeb8
>>>> [58380.439707] IP: [<ffffffffa03f6d05>]
>>>> block_group_cache_done.isra.21+0xc/0x1c [btrfs]
>>>> [58380.440879] PGD 1acb067 PUD 23f5ff067 PMD 23f5db067 PTE
>>>> 80000001446ea060
>>>> [58380.441220] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
>>>> [58380.441486] Modules linked in: btrfs crc32c_generic xor raid6_pq nfsd
>>>> auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop psmouse
>>>> processor i2c_piix4 parport_pc parport pcspkr serio_raw evdev i2ccore
>>>> thermal_sys microcode button ext4 crc16 jbd2 mbcache sr_mod cdrom
>>>> ata_generic sg sd_mod crc_t10dif crct10dif_generic crct10dif_common
>>>> virtio_scsi floppy ata_piix e1000 libata virtio_pci scsi_mod virtio_ring
>>>> virtio [last unloaded: btrfs]
>>>> [58380.443238] CPU: 3 PID: 25728 Comm: btrfs-transacti Tainted: G
>>>> W
>>>> 3.17.0-rc5-btrfs-next-1+ #1
>>>> [58380.443238] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>>>> BIOS
>>>> rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>>>> [58380.443238] task: ffff88013ac82090 ti: ffff88013896c000 task.ti:
>>>> ffff88013896c000
>>>> [58380.443238] RIP: 0010:[<ffffffffa03f6d05>]  [<ffffffffa03f6d05>]
>>>> block_group_cache_done.isra.21+0xc/0x1c [btrfs]
>>>> [58380.443238] RSP: 0018:ffff88013896fdd8  EFLAGS: 00010283
>>>> [58380.443238] RAX: ffff880222cae850 RBX: ffff880119ba74c0 RCX:
>>>> 0000000000000000
>>>> [58380.443238] RDX: 0000000000000000 RSI: ffff880185e16800 RDI:
>>>> ffff8801446eaeb8
>>>> [58380.443238] RBP: ffff88013896fdd8 R08: ffff8801a9ca9fa8 R09:
>>>> ffff88013896fc60
>>>> [58380.443238] R10: ffff88013896fd28 R11: 0000000000000000 R12:
>>>> ffff880222cae000
>>>> [58380.443238] R13: ffff880222cae850 R14: ffff880222cae6b0 R15:
>>>> ffff8801446eae00
>>>> [58380.443238] FS:  0000000000000000(0000) GS:ffff88023ed80000(0000)
>>>> knlGS:0000000000000000
>>>> [58380.443238] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> [58380.443238] CR2: ffff8801446eaeb8 CR3: 0000000001811000 CR4:
>>>> 00000000000006e0
>>>> [58380.443238] Stack:
>>>> [58380.443238]  ffff88013896fe18 ffffffffa03fe2d5 ffff880222cae850
>>>> ffff880185e16800
>>>> [58380.443238]  ffff88000dc41c20 0000000000000000 ffff8801a9ca9f00
>>>> 0000000000000000
>>>> [58380.443238]  ffff88013896fe80 ffffffffa040fbcf ffff88018b0dcdb0
>>>> ffff88013ac82090
>>>> [58380.443238] Call Trace:
>>>> [58380.443238]  [<ffffffffa03fe2d5>]
>>>> btrfs_prepare_extent_commit+0x5a/0xd7
>>>> [btrfs]
>>>> [58380.443238]  [<ffffffffa040fbcf>]
>>>> btrfs_commit_transaction+0x45c/0x882
>>>> [btrfs]
>>>> [58380.443238]  [<ffffffffa040c058>] transaction_kthread+0xf2/0x1a4
>>>> [btrfs]
>>>> [58380.443238]  [<ffffffffa040bf66>] ?
>>>> btrfs_cleanup_transaction+0x3d8/0x3d8 [btrfs]
>>>> [58380.443238]  [<ffffffff8105966b>] kthread+0xb7/0xbf
>>>> [58380.443238]  [<ffffffff810595b4>] ? __kthread_parkme+0x67/0x67
>>>> [58380.443238]  [<ffffffff813ebeac>] ret_from_fork+0x7c/0xb0
>>>> [58380.443238]  [<ffffffff810595b4>] ? __kthread_parkme+0x67/0x67
>>>>
>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>> ---
>>>>    fs/btrfs/ctree.h       |  1 +
>>>>    fs/btrfs/extent-tree.c | 27 +++++++++++++++++++++++++++
>>>>    2 files changed, 28 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>> index d3ccd09..7f40a65 100644
>>>> --- a/fs/btrfs/ctree.h
>>>> +++ b/fs/btrfs/ctree.h
>>>> @@ -1277,6 +1277,7 @@ struct btrfs_block_group_cache {
>>>>          unsigned int ro:1;
>>>>          unsigned int dirty:1;
>>>>          unsigned int iref:1;
>>>> +       unsigned int has_caching_ctl:1;
>>>>
>>>
>>> Don't do this, just unconditionally call get_caching_control in
>>> btrfs_remove_block_group, then if we get something we can do stuff,
>>> otherwise we can just continue.  Thanks,
>>
>>
>> That's what I initially thought too. However, get_caching_control only
>> returns us the caching_ctl if block_group->cached ==
>> BTRFS_CACHE_STARTED, so it's not enough to use it exclusively. The
>> has_caching_ctl flag is just to avoid holding the semaphore and search
>> through the list (since block_group->caching_ctl can be NULL but a
>> caching_ctl point to the block group can be in the list).
>>
>
> Oh God that's not good, we need to change get_caching_control to return if
> there is a caching control at all, since the other users want to wait for
> the fast caching to finish too.  So change that and then use it
> unconditionally.  I bet this has been causing us the random early ENOSPC
> problems.  Thanks,

Right, I think that's a separate change different from what I'm trying to fix.

When caching_thread finishes, it sets the block_group->caching_ctl to
NULL, and caching_ctl remains in the list until transaction commit
time. So doing that change, to make get_caching_control() always
return the block group's ->caching_ctl wouldn't solve this issue - we
still need to search in the list if block_group->caching_ctl is NULL.


>
> Josef
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
