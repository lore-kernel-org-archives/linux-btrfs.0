Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:48427 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3LCS7B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 13:59:01 -0500
Received: by mail-we0-f177.google.com with SMTP id p61so13612697wes.8
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 10:58:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r17jar_CxrYhwQX4eeKLiFgjHDuLdptes04gG_LXtozrg@mail.gmail.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
	<1381726796-27191-5-git-send-email-bo.li.liu@oracle.com>
	<CAOcd+r17jar_CxrYhwQX4eeKLiFgjHDuLdptes04gG_LXtozrg@mail.gmail.com>
Date: Tue, 3 Dec 2013 20:58:59 +0200
Message-ID: <CAOcd+r0f3THsFPgxain4ykEkuK5njbsVJaMO0hUARZ8uLeM4MA@mail.gmail.com>
Subject: Re: [PATCH v7 04/13] Btrfs: disable qgroups accounting when
 quata_enable is 0
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Liu Bo <bo.li.liu@oracle.com>, Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And same is also true for "struct tree_mod_elem" sitting in
"fs_info->tree_mod_log". Usually these are also freed up by
btrfs_delayed_refs_qgroup_accounting() calling
btrfs_put_tree_mod_seq(). But not in case of transaction abort.
Some sample kmemleak stacks below:

unreferenced object 0xffff8800365605a0 (size 128):
  comm "btrfs", pid 21162, jiffies 4295508540 (age 516.080s)
  hex dump (first 32 bytes):
    81 04 56 36 00 88 ff ff 00 00 00 00 00 00 00 00  ..V6............
    00 00 00 00 00 00 00 00 31 05 00 00 00 00 00 00  ........1.......
  backtrace:
    [<ffffffff816798e6>] kmemleak_alloc+0x26/0x50
    [<ffffffff8117dd5b>] kmem_cache_alloc_trace+0xab/0x160
    [<ffffffffa031754f>] tree_mod_log_insert_key_locked+0x4f/0x140 [btrfs]
    [<ffffffffa0317702>] tree_mod_log_free_eb+0xc2/0xf0 [btrfs]
    [<ffffffffa031a1c6>] __btrfs_cow_block+0x316/0x520 [btrfs]
    [<ffffffffa031a57e>] btrfs_cow_block+0x12e/0x1f0 [btrfs]
    [<ffffffffa031ebd1>] btrfs_search_slot+0x381/0x830 [btrfs]
    [<ffffffffa0320c8c>] btrfs_insert_empty_items+0x7c/0x110 [btrfs]
    [<ffffffffa033d263>] insert_with_overflow+0x43/0x170 [btrfs]
    [<ffffffffa033d44f>] btrfs_insert_dir_item+0xbf/0x200 [btrfs]
    [<ffffffffa034a305>] create_pending_snapshot+0xbf5/0xd70 [btrfs]
    [<ffffffffa034a5e9>] create_pending_snapshots+0x169/0x240 [btrfs]
    [<ffffffffa034ba4a>] btrfs_commit_transaction+0x4aa/0x1080 [btrfs]
    [<ffffffffa0382861>] btrfs_mksubvol.isra.51+0x501/0x5f0 [btrfs]
    [<ffffffffa0382a5f>] btrfs_ioctl_snap_create_transid+0x10f/0x1b0 [btrfs]
    [<ffffffffa0382cc5>] btrfs_ioctl_snap_create_v2+0x135/0x190 [btrfs]

unreferenced object 0xffff88007ab00c60 (size 128):
  comm "btrfs", pid 21162, jiffies 4295508540 (age 516.760s)
  hex dump (first 32 bytes):
    10 0e b0 7a 00 88 ff ff 00 00 00 00 00 00 00 00  ...z............
    00 00 00 00 00 00 00 00 b7 05 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816798e6>] kmemleak_alloc+0x26/0x50
    [<ffffffff8117dd5b>] kmem_cache_alloc_trace+0xab/0x160
    [<ffffffffa03172e4>] tree_mod_log_insert_key_mask.isra.33+0xb4/0x1c0 [btrfs]
    [<ffffffffa03174fe>] tree_mod_log_insert_key+0xe/0x10 [btrfs]
    [<ffffffffa031a16f>] __btrfs_cow_block+0x2bf/0x520 [btrfs]
    [<ffffffffa031a57e>] btrfs_cow_block+0x12e/0x1f0 [btrfs]
    [<ffffffffa031dc43>] push_leaf_right+0x133/0x1a0 [btrfs]
    [<ffffffffa031e381>] split_leaf+0x5e1/0x770 [btrfs]
    [<ffffffffa031efd0>] btrfs_search_slot+0x780/0x830 [btrfs]
    [<ffffffffa0320c8c>] btrfs_insert_empty_items+0x7c/0x110 [btrfs]
    [<ffffffffa033d263>] insert_with_overflow+0x43/0x170 [btrfs]
    [<ffffffffa033d44f>] btrfs_insert_dir_item+0xbf/0x200 [btrfs]
    [<ffffffffa034a305>] create_pending_snapshot+0xbf5/0xd70 [btrfs]
    [<ffffffffa034a5e9>] create_pending_snapshots+0x169/0x240 [btrfs]
    [<ffffffffa034ba4a>] btrfs_commit_transaction+0x4aa/0x1080 [btrfs]
    [<ffffffffa0382861>] btrfs_mksubvol.isra.51+0x501/0x5f0 [btrfs]


unreferenced object 0xffff88007b024780 (size 32):
  comm "btrfs", pid 26945, jiffies 4295316905 (age 767.060s)
  hex dump (first 32 bytes):
    20 47 02 7b 00 88 ff ff 00 4f 02 7b 00 88 ff ff   G.{.....O.{....
    90 86 b6 6a 00 88 ff ff 00 00 00 00 00 00 00 00  ...j............
  backtrace:
    [<ffffffff816798e6>] kmemleak_alloc+0x26/0x50
    [<ffffffff8117dd5b>] kmem_cache_alloc_trace+0xab/0x160
    [<ffffffffa03ae944>] btrfs_qgroup_record_ref+0x44/0xd0 [btrfs]
    [<ffffffffa039c861>] btrfs_add_delayed_tree_ref+0x141/0x1f0 [btrfs]
    [<ffffffffa032f5cd>] btrfs_free_tree_block+0x9d/0x220 [btrfs]
    [<ffffffffa031b325>] __btrfs_cow_block+0x475/0x520 [btrfs]
    [<ffffffffa031b57e>] btrfs_cow_block+0x12e/0x1f0 [btrfs]
    [<ffffffffa031fbd1>] btrfs_search_slot+0x381/0x830 [btrfs]
    [<ffffffffa0321c8c>] btrfs_insert_empty_items+0x7c/0x110 [btrfs]
    [<ffffffffa033e253>] insert_with_overflow+0x43/0x170 [btrfs]
    [<ffffffffa033e43f>] btrfs_insert_dir_item+0xbf/0x200 [btrfs]
    [<ffffffffa034b2f5>] create_pending_snapshot+0xbf5/0xd50 [btrfs]
    [<ffffffffa034b551>] create_pending_snapshots+0x101/0x1d0 [btrfs]
    [<ffffffffa034c9aa>] btrfs_commit_transaction+0x4aa/0x1080 [btrfs]
    [<ffffffffa03837c1>] btrfs_mksubvol.isra.51+0x501/0x5f0 [btrfs]
    [<ffffffffa03839bf>] btrfs_ioctl_snap_create_transid+0x10f/0x1b0 [btrfs]

unreferenced object 0xffff88007b024210 (size 32):
  comm "btrfs", pid 26945, jiffies 4295316907 (age 767.068s)
  hex dump (first 32 bytes):
    e0 44 02 7b 00 88 ff ff 60 46 02 7b 00 88 ff ff  .D.{....`F.{....
    50 e1 41 6a 00 88 ff ff 70 68 96 6b 00 88 ff ff  P.Aj....ph.k....
  backtrace:
    [<ffffffff816798e6>] kmemleak_alloc+0x26/0x50
    [<ffffffff8117dd5b>] kmem_cache_alloc_trace+0xab/0x160
    [<ffffffffa03ae944>] btrfs_qgroup_record_ref+0x44/0xd0 [btrfs]
    [<ffffffffa039c861>] btrfs_add_delayed_tree_ref+0x141/0x1f0 [btrfs]
    [<ffffffffa03312c4>] btrfs_alloc_free_block+0x1a4/0x450 [btrfs]
    [<ffffffffa031afe8>] __btrfs_cow_block+0x138/0x520 [btrfs]
    [<ffffffffa031b57e>] btrfs_cow_block+0x12e/0x1f0 [btrfs]
    [<ffffffffa031fbd1>] btrfs_search_slot+0x381/0x830 [btrfs]
    [<ffffffffa0321c8c>] btrfs_insert_empty_items+0x7c/0x110 [btrfs]
    [<ffffffffa033e253>] insert_with_overflow+0x43/0x170 [btrfs]
    [<ffffffffa033e43f>] btrfs_insert_dir_item+0xbf/0x200 [btrfs]
    [<ffffffffa034b2f5>] create_pending_snapshot+0xbf5/0xd50 [btrfs]
    [<ffffffffa034b551>] create_pending_snapshots+0x101/0x1d0 [btrfs]
    [<ffffffffa034c9aa>] btrfs_commit_transaction+0x4aa/0x1080 [btrfs]
    [<ffffffffa03837c1>] btrfs_mksubvol.isra.51+0x501/0x5f0 [btrfs]
    [<ffffffffa03839bf>] btrfs_ioctl_snap_create_transid+0x10f/0x1b0 [btrfs]


On Tue, Dec 3, 2013 at 7:13 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
> Hi Liu, Jan,
>
> What happens to "struct qgroup_update"s sitting in
> trans->qgroup_ref_list in case the transaction aborts? It seems that
> they are not freed.
>
> For example, if we are in btrfs_commit_transaction() and:
> - call create_pending_snapshots()
> - call btrfs_run_delayed_items() and this fails
> So we go to cleanup_transaction() without calling
> btrfs_delayed_refs_qgroup_accounting(), which would have been called
> by btrfs_run_delayed_refs().
>
> I receive kmemleak warnings about these thingies not being freed,
> although on an older kernel. However, looking at Josef's tree, this
> still seems to be the case.
>
> Thanks,
> Alex.
>
>
> On Mon, Oct 14, 2013 at 7:59 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> It's unnecessary to do qgroups accounting without enabling quota.
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>>  fs/btrfs/ctree.c       |    2 +-
>>  fs/btrfs/delayed-ref.c |   18 ++++++++++++++----
>>  fs/btrfs/qgroup.c      |    3 +++
>>  3 files changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 61b5bcd..fb89235 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -407,7 +407,7 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
>>
>>         tree_mod_log_write_lock(fs_info);
>>         spin_lock(&fs_info->tree_mod_seq_lock);
>> -       if (!elem->seq) {
>> +       if (elem && !elem->seq) {
>>                 elem->seq = btrfs_inc_tree_mod_seq_major(fs_info);
>>                 list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
>>         }
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 9e1a1c9..3ec3d08 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -691,8 +691,13 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>         ref->is_head = 0;
>>         ref->in_tree = 1;
>>
>> -       if (need_ref_seq(for_cow, ref_root))
>> -               seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
>> +       if (need_ref_seq(for_cow, ref_root)) {
>> +               struct seq_list *elem = NULL;
>> +
>> +               if (fs_info->quota_enabled)
>> +                       elem = &trans->delayed_ref_elem;
>> +               seq = btrfs_get_tree_mod_seq(fs_info, elem);
>> +       }
>>         ref->seq = seq;
>>
>>         full_ref = btrfs_delayed_node_to_tree_ref(ref);
>> @@ -750,8 +755,13 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>         ref->is_head = 0;
>>         ref->in_tree = 1;
>>
>> -       if (need_ref_seq(for_cow, ref_root))
>> -               seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
>> +       if (need_ref_seq(for_cow, ref_root)) {
>> +               struct seq_list *elem = NULL;
>> +
>> +               if (fs_info->quota_enabled)
>> +                       elem = &trans->delayed_ref_elem;
>> +               seq = btrfs_get_tree_mod_seq(fs_info, elem);
>> +       }
>>         ref->seq = seq;
>>
>>         full_ref = btrfs_delayed_node_to_data_ref(ref);
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 4e6ef49..1cb58f9 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1188,6 +1188,9 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
>>  {
>>         struct qgroup_update *u;
>>
>> +       if (!trans->root->fs_info->quota_enabled)
>> +               return 0;
>> +
>>         BUG_ON(!trans->delayed_ref_elem.seq);
>>         u = kmalloc(sizeof(*u), GFP_NOFS);
>>         if (!u)
>> --
>> 1.7.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
