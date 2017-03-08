Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933425AbdCHBM2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 20:12:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 25FC1204AD
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Mar 2017 00:34:29 +0000 (UTC)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com [209.85.223.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3644420460
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Mar 2017 00:34:26 +0000 (UTC)
Received: by mail-io0-f180.google.com with SMTP id f84so16442621ioj.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Mar 2017 16:34:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170307220348.GG12408@lim.localdomain>
References: <1488860689-6008-1-git-send-email-fdmanana@kernel.org> <20170307220348.GG12408@lim.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 8 Mar 2017 00:34:25 +0000
Message-ID: <CAL3q7H4Py-AG+2dh-y+xzVuccRA0GMXMYGY-fmK35=AE0-aMhw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix invalid attempt to free reserved space on
 failure to cow range
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 7, 2017 at 10:03 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Tue, Mar 07, 2017 at 04:24:49AM +0000, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> When attempting to COW a file range (we are starting writeback and doing
>> COW), if we manage to reserve an extent for the range we will write into
>> but fail after reserving it and before creating the respective ordered
>> extent, we end up in an error path where we attempt to decrement the
>> data space's bytes_may_use counter after we already did it while
>> reserving the extent, leading to a warning/trace like the following:
>>
>> [  847.621524] ------------[ cut here ]------------
>> [  847.625441] WARNING: CPU: 5 PID: 4905 at fs/btrfs/extent-tree.c:4316 btrfs_free_reserved_data_space_noquota+0x60/0x9f [btrfs]
>> [  847.633704] Modules linked in: btrfs crc32c_generic xor raid6_pq acpi_cpufreq i2c_piix4 ppdev psmouse tpm_tis serio_raw pcspkr parport_pc tpm_tis_core i2c_core sg
>> [  847.644616] CPU: 5 PID: 4905 Comm: xfs_io Not tainted 4.10.0-rc8-btrfs-next-37+ #2
>> [  847.648601] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
>> [  847.648601] Call Trace:
>> [  847.648601]  dump_stack+0x67/0x90
>> [  847.648601]  __warn+0xc2/0xdd
>> [  847.648601]  warn_slowpath_null+0x1d/0x1f
>> [  847.648601]  btrfs_free_reserved_data_space_noquota+0x60/0x9f [btrfs]
>> [  847.648601]  btrfs_clear_bit_hook+0x140/0x258 [btrfs]
>> [  847.648601]  clear_state_bit+0x87/0x128 [btrfs]
>> [  847.648601]  __clear_extent_bit+0x222/0x2b7 [btrfs]
>> [  847.648601]  clear_extent_bit+0x17/0x19 [btrfs]
>> [  847.648601]  extent_clear_unlock_delalloc+0x3b/0x6b [btrfs]
>> [  847.648601]  cow_file_range.isra.39+0x387/0x39a [btrfs]
>> [  847.648601]  run_delalloc_nocow+0x4d7/0x70e [btrfs]
>> [  847.648601]  ? arch_local_irq_save+0x9/0xc
>> [  847.648601]  run_delalloc_range+0xa7/0x2b5 [btrfs]
>> [  847.648601]  writepage_delalloc.isra.31+0xb9/0x15c [btrfs]
>> [  847.648601]  __extent_writepage+0x249/0x2e8 [btrfs]
>> [  847.648601]  extent_write_cache_pages.constprop.33+0x28b/0x36c [btrfs]
>> [  847.648601]  ? arch_local_irq_save+0x9/0xc
>> [  847.648601]  ? mark_lock+0x24/0x201
>> [  847.648601]  extent_writepages+0x4b/0x5c [btrfs]
>> [  847.648601]  ? btrfs_writepage_start_hook+0xed/0xed [btrfs]
>> [  847.648601]  btrfs_writepages+0x28/0x2a [btrfs]
>> [  847.648601]  do_writepages+0x23/0x2c
>> [  847.648601]  __filemap_fdatawrite_range+0x5a/0x61
>> [  847.648601]  filemap_fdatawrite_range+0x13/0x15
>> [  847.648601]  btrfs_fdatawrite_range+0x20/0x46 [btrfs]
>> [  847.648601]  start_ordered_ops+0x19/0x23 [btrfs]
>> [  847.648601]  btrfs_sync_file+0x136/0x42c [btrfs]
>> [  847.648601]  vfs_fsync_range+0x8c/0x9e
>> [  847.648601]  vfs_fsync+0x1c/0x1e
>> [  847.648601]  do_fsync+0x31/0x4a
>> [  847.648601]  SyS_fsync+0x10/0x14
>> [  847.648601]  entry_SYSCALL_64_fastpath+0x18/0xad
>> [  847.648601] RIP: 0033:0x7f5b05200800
>> [  847.648601] RSP: 002b:00007ffe204f71c8 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
>> [  847.648601] RAX: ffffffffffffffda RBX: ffffffff8109637b RCX: 00007f5b05200800
>> [  847.648601] RDX: 00000000008bd0a0 RSI: 00000000008bd2e0 RDI: 0000000000000003
>> [  847.648601] RBP: ffffc90001d67f98 R08: 000000000000ffff R09: 000000000000001f
>> [  847.648601] R10: 00000000000001f6 R11: 0000000000000246 R12: 0000000000000046
>> [  847.648601] R13: ffffc90001d67f78 R14: 00007f5b054be740 R15: 00007f5b054be740
>> [  847.648601]  ? trace_hardirqs_off_caller+0x3f/0xaa
>> [  847.685787] ---[ end trace 2a4a3e15382508e8 ]---
>>
>> So fix this by not attempting to decrement the data space info's
>> bytes_may_use counter if we already reserved the extent and an error
>> happened before creating the ordered extent. We are already correctly
>> freeing the reserved extent if an error happens, so there's no additional
>> measure needed.
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>
>> V2: Removed previous dependence on a no longer needed cleanup patch and
>>     rebased it on top of Qu's recent patchset that fixes hanging ordered
>>     extents when errors happen.
>>
>>  fs/btrfs/extent_io.h |  4 +++-
>>  fs/btrfs/inode.c     | 56 ++++++++++++++++++++++++++++++++++++++--------------
>>  2 files changed, 44 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
>> index 3e4fad4..d31313d 100644
>> --- a/fs/btrfs/extent_io.h
>> +++ b/fs/btrfs/extent_io.h
>> @@ -21,8 +21,10 @@
>>  #define EXTENT_NORESERVE     (1U << 15)
>>  #define EXTENT_QGROUP_RESERVED       (1U << 16)
>>  #define EXTENT_CLEAR_DATA_RESV       (1U << 17)
>> +#define EXTENT_SPACE_FREED   (1U << 18)
>>  #define EXTENT_IOBITS                (EXTENT_LOCKED | EXTENT_WRITEBACK)
>> -#define EXTENT_CTLBITS               (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
>> +#define EXTENT_CTLBITS               (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC |\
>> +                              EXTENT_SPACE_FREED)
>>
>>  /*
>>   * flags for bio submission. The high bits indicate the compression
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 9b03eb9b..9714453 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -942,10 +942,13 @@ static noinline int cow_file_range(struct inode *inode,
>>       u64 num_bytes;
>>       unsigned long ram_size;
>>       u64 disk_num_bytes;
>> -     u64 cur_alloc_size;
>> +     u64 cur_alloc_size = 0;
>>       u64 blocksize = fs_info->sectorsize;
>>       struct btrfs_key ins;
>>       struct extent_map *em;
>> +     unsigned clear_bits;
>> +     unsigned long page_ops;
>> +     bool extent_reserved = false;
>>       int ret = 0;
>>
>>       if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
>> @@ -990,14 +993,14 @@ static noinline int cow_file_range(struct inode *inode,
>>                       start + num_bytes - 1, 0);
>>
>>       while (disk_num_bytes > 0) {
>> -             unsigned long op;
>> -
>>               cur_alloc_size = disk_num_bytes;
>>               ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
>>                                          fs_info->sectorsize, 0, alloc_hint,
>>                                          &ins, 1, 1);
>>               if (ret < 0)
>>                       goto out_unlock;
>> +             cur_alloc_size = ins.offset;
>> +             extent_reserved = true;
>>
>>               ram_size = ins.offset;
>>               em = create_io_em(inode, start, ins.offset, /* len */
>> @@ -1012,7 +1015,6 @@ static noinline int cow_file_range(struct inode *inode,
>>                       goto out_reserve;
>>               free_extent_map(em);
>>
>> -             cur_alloc_size = ins.offset;
>>               ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
>>                                              ram_size, cur_alloc_size, 0);
>>               if (ret)
>> @@ -1047,14 +1049,14 @@ static noinline int cow_file_range(struct inode *inode,
>>                * Do set the Private2 bit so we know this page was properly
>>                * setup for writepage
>>                */
>> -             op = unlock ? PAGE_UNLOCK : 0;
>> -             op |= PAGE_SET_PRIVATE2;
>> +             page_ops = unlock ? PAGE_UNLOCK : 0;
>> +             page_ops |= PAGE_SET_PRIVATE2;
>>
>>               extent_clear_unlock_delalloc(inode, start,
>>                                            start + ram_size - 1,
>>                                            delalloc_end, locked_page,
>>                                            EXTENT_LOCKED | EXTENT_DELALLOC,
>> -                                          op);
>> +                                          page_ops);
>>               if (disk_num_bytes > cur_alloc_size)
>>                       disk_num_bytes = 0;
>>               else
>> @@ -1062,6 +1064,7 @@ static noinline int cow_file_range(struct inode *inode,
>>               num_bytes -= cur_alloc_size;
>>               alloc_hint = ins.objectid + ins.offset;
>>               start += cur_alloc_size;
>> +             extent_reserved = false;
>>
>>               /*
>>                * btrfs_reloc_clone_csums() error, since start is increased
>> @@ -1080,12 +1083,35 @@ static noinline int cow_file_range(struct inode *inode,
>>       btrfs_dec_block_group_reservations(fs_info, ins.objectid);
>>       btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
>>  out_unlock:
>> +     clear_bits = EXTENT_LOCKED | EXTENT_DO_ACCOUNTING | EXTENT_DELALLOC |
>> +             EXTENT_DEFRAG;
>> +     page_ops = PAGE_UNLOCK | PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
>> +             PAGE_END_WRITEBACK;
>> +     /*
>> +      * If we reserved an extent for our delalloc range (or a subrange) and
>> +      * failed to create the respective ordered extent, then it means that
>> +      * when we reserved the extent we decremented the extent's size from
>> +      * the data space_info's bytes_may_use counter and incremented the
>> +      * space_info's bytes_reserved counter by the same amount. We must make
>> +      * sure extent_clear_unlock_delalloc() does not try to decrement again
>> +      * the data space_info's bytes_may_use counter, therefore we pass it the
>> +      * flag EXTENT_SPACE_FREED.
>> +      */
>
> EXTENT_SPACE_FREED is to free associated metadata only while EXTENT_CLEAR_DATA_RESV is to free data only,
> EXTENT_DO_ACCOUNTING is to free both.
>
> Can we just do
> #define EXTENT_DO_ACCOUNTING (EXTENT_SPACE_FREED | EXTENT_CLEAR_DATA_RESV)
> ?

Exactly like that it wouldn't work. But I understand the idea to
simplify things. Sending a v3 that simplifies things and removes that
new flag.
thanks

>
> Thanks,
>
> -liubo
>> +     if (extent_reserved) {
>> +             extent_clear_unlock_delalloc(inode, start,
>> +                                          start + cur_alloc_size,
>> +                                          start + cur_alloc_size,
>> +                                          locked_page,
>> +                                          clear_bits | EXTENT_SPACE_FREED,
>> +                                          page_ops);
>> +             start += cur_alloc_size;
>> +             if (start >= end)
>> +                     goto out;
>> +     }
>>       extent_clear_unlock_delalloc(inode, start, end, delalloc_end,
>>                                    locked_page,
>> -                                  EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
>> -                                  EXTENT_DELALLOC | EXTENT_DEFRAG,
>> -                                  PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
>> -                                  PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
>> +                                  clear_bits,
>> +                                  page_ops);
>>       goto out;
>>  }
>>
>> @@ -1794,10 +1820,10 @@ static void btrfs_clear_bit_hook(struct btrfs_inode *inode,
>>               if (btrfs_is_testing(fs_info))
>>                       return;
>>
>> -             if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
>> -                 && do_list && !(state->state & EXTENT_NORESERVE)
>> -                 && (*bits & (EXTENT_DO_ACCOUNTING |
>> -                 EXTENT_CLEAR_DATA_RESV)))
>> +             if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID &&
>> +                 do_list && !(state->state & EXTENT_NORESERVE) &&
>> +                 (*bits & (EXTENT_DO_ACCOUNTING | EXTENT_CLEAR_DATA_RESV)) &&
>> +                 !(*bits & EXTENT_SPACE_FREED))
>>                       btrfs_free_reserved_data_space_noquota(
>>                                       &inode->vfs_inode,
>>                                       state->start, len);
>> --
>> 2.7.0.rc3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
