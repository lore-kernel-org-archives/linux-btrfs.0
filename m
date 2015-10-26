Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5812 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752150AbbJZB1H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 21:27:07 -0400
Subject: Re: [PATCH v3 06/21] btrfs: delayed_ref: Add new function to record
 reserved space into delayed ref
To: <fdmanana@gmail.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1444702827-18169-7-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <562D8164.2080903@cn.fujitsu.com>
Date: Mon, 26 Oct 2015 09:27:00 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2015/10/25 14:39 +0000:
> On Tue, Oct 13, 2015 at 3:20 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Add new function btrfs_add_delayed_qgroup_reserve() function to record
>> how much space is reserved for that extent.
>>
>> As btrfs only accounts qgroup at run_delayed_refs() time, so newly
>> allocated extent should keep the reserved space until then.
>>
>> So add needed function with related members to do it.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2:
>>    None
>> v3:
>>    None
>> ---
>>   fs/btrfs/delayed-ref.c | 29 +++++++++++++++++++++++++++++
>>   fs/btrfs/delayed-ref.h | 14 ++++++++++++++
>>   2 files changed, 43 insertions(+)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index ac3e81d..bd9b63b 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -476,6 +476,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>          INIT_LIST_HEAD(&head_ref->ref_list);
>>          head_ref->processing = 0;
>>          head_ref->total_ref_mod = count_mod;
>> +       head_ref->qgroup_reserved = 0;
>> +       head_ref->qgroup_ref_root = 0;
>>
>>          /* Record qgroup extent info if provided */
>>          if (qrecord) {
>> @@ -746,6 +748,33 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>          return 0;
>>   }
>>
>> +int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
>> +                                    struct btrfs_trans_handle *trans,
>> +                                    u64 ref_root, u64 bytenr, u64 num_bytes)
>> +{
>> +       struct btrfs_delayed_ref_root *delayed_refs;
>> +       struct btrfs_delayed_ref_head *ref_head;
>> +       int ret = 0;
>> +
>> +       if (!fs_info->quota_enabled || !is_fstree(ref_root))
>> +               return 0;
>> +
>> +       delayed_refs = &trans->transaction->delayed_refs;
>> +
>> +       spin_lock(&delayed_refs->lock);
>> +       ref_head = find_ref_head(&delayed_refs->href_root, bytenr, 0);
>> +       if (!ref_head) {
>> +               ret = -ENOENT;
>> +               goto out;
>> +       }
>
> Hi Qu,
>
> So while running btrfs/063, with qgroups enabled (I modified the test
> to enable qgroups), ran into this 2 times:

Thanks for the test.

I also want a method to enable quota for all other btrfs/generic tests,
but have no good idea other than modifing testcase itself.

Any good ideas?
>
> [169125.246506] BTRFS info (device sdc): disk space caching is enabled
> [169125.363164] ------------[ cut here ]------------
> [169125.365236] WARNING: CPU: 10 PID: 2827 at fs/btrfs/inode.c:2929
> btrfs_finish_ordered_io+0x347/0x4eb [btrfs]()
> [169125.367702] BTRFS: Transaction aborted (error -2)
> [169125.368830] Modules linked in: btrfs dm_flakey dm_mod
> crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
> lockd grace fscache sunrpc loop fuse parport_pc parport i2c_piix4
> psmouse acpi_cpufreq microcode pcspkr processor evdev i2c_core
> serio_raw button ext4 crc16 jbd2 mbcache sd_mod sg sr_mod cdrom
> ata_generic virtio_scsi ata_piix libata floppy virtio_pci virtio_ring
> scsi_mod e1000 virtio [last unloaded: btrfs]
> [169125.376755] CPU: 10 PID: 2827 Comm: kworker/u32:14 Tainted: G
>    W       4.3.0-rc5-btrfs-next-17+ #1
> [169125.378522] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org
> 04/01/2014
> [169125.380916] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
> [169125.382167]  0000000000000000 ffff88007ef2bc28 ffffffff812566f4
> ffff88007ef2bc70
> [169125.383643]  ffff88007ef2bc60 ffffffff8104d0a6 ffffffffa03cac33
> ffff8801f5ca6db0
> [169125.385197]  ffff8802c6c7ee98 ffff880122bc1000 00000000fffffffe
> ffff88007ef2bcc8
> [169125.386691] Call Trace:
> [169125.387194]  [<ffffffff812566f4>] dump_stack+0x4e/0x79
> [169125.388205]  [<ffffffff8104d0a6>] warn_slowpath_common+0x9f/0xb8
> [169125.389386]  [<ffffffffa03cac33>] ?
> btrfs_finish_ordered_io+0x347/0x4eb [btrfs]
> [169125.390837]  [<ffffffff8104d107>] warn_slowpath_fmt+0x48/0x50
> [169125.391839]  [<ffffffffa03d67bb>] ? unpin_extent_cache+0xbe/0xcc [btrfs]
> [169125.392973]  [<ffffffffa03cac33>]
> btrfs_finish_ordered_io+0x347/0x4eb [btrfs]
> [169125.395714]  [<ffffffff8147c612>] ? _raw_spin_unlock_irqrestore+0x38/0x60
> [169125.396888]  [<ffffffff81087d0b>] ? trace_hardirqs_off_caller+0x1f/0xb9
> [169125.397986]  [<ffffffffa03cadec>] finish_ordered_fn+0x15/0x17 [btrfs]
> [169125.399122]  [<ffffffffa03ec706>] normal_work_helper+0x14c/0x32a [btrfs]
> [169125.400300]  [<ffffffffa03ec9e6>] btrfs_endio_write_helper+0x12/0x14 [btrfs]
> [169125.401450]  [<ffffffff81063b23>] process_one_work+0x24a/0x4ac
> [169125.402631]  [<ffffffff81064285>] worker_thread+0x206/0x2c2
> [169125.403622]  [<ffffffff8106407f>] ? rescuer_thread+0x2cb/0x2cb
> [169125.404693]  [<ffffffff8106904d>] kthread+0xef/0xf7
> [169125.405727]  [<ffffffff81068f5e>] ? kthread_parkme+0x24/0x24
> [169125.406808]  [<ffffffff8147d10f>] ret_from_fork+0x3f/0x70
> [169125.407834]  [<ffffffff81068f5e>] ? kthread_parkme+0x24/0x24
> [169125.408840] ---[ end trace 6ee4342a5722b119 ]---
> [169125.409654] BTRFS: error (device sdc) in
> btrfs_finish_ordered_io:2929: errno=-2 No such entry
>
> So what you have here is racy:
>
> btrfs_finish_ordered_io()
>     joins existing transaction (or starts a new one)
>     insert_reserved_file_extent()
>        btrfs_alloc_reserved_file_extent() --> creates delayed ref
>
>        ******* delayed refs are run, someone called
> btrfs_async_run_delayed_refs() from btrfs_end_transaction(), ref head
> is removed ******
>
>        btrfs_add_delayed_qgroup_reserve() --> does not find delayed ref
> head, returns -ENOENT and finish_ordered_io aborts current
> transaction...
>
> A very tiny race, but...

Oh, abort transaction, quite a big problem.

The original idea to introduce btrfs_add_delayed_qgroup_reserve() is to 
put all related qgroup code into qgroup.c, but truth turned out that is 
too ideal.

I'll add a new patch to modify btrfs_add_delayed_data_ref() function, 
remove the last parameter no_quota and add new reserved parameter, to 
allow reserved bytenr inserted at delayed_ref inserting time.

Thanks
Qu

>
> thanks
>
>
>> +       WARN_ON(ref_head->qgroup_reserved || ref_head->qgroup_ref_root);
>> +       ref_head->qgroup_ref_root = ref_root;
>> +       ref_head->qgroup_reserved = num_bytes;
>> +out:
>> +       spin_unlock(&delayed_refs->lock);
>> +       return ret;
>> +}
>> +
>>   int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>>                                  struct btrfs_trans_handle *trans,
>>                                  u64 bytenr, u64 num_bytes,
>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>> index 13fb5e6..d4c41e2 100644
>> --- a/fs/btrfs/delayed-ref.h
>> +++ b/fs/btrfs/delayed-ref.h
>> @@ -113,6 +113,17 @@ struct btrfs_delayed_ref_head {
>>          int total_ref_mod;
>>
>>          /*
>> +        * For qgroup reserved space freeing.
>> +        *
>> +        * ref_root and reserved will be recorded after
>> +        * BTRFS_ADD_DELAYED_EXTENT is called.
>> +        * And will be used to free reserved qgroup space at
>> +        * run_delayed_refs() time.
>> +        */
>> +       u64 qgroup_ref_root;
>> +       u64 qgroup_reserved;
>> +
>> +       /*
>>           * when a new extent is allocated, it is just reserved in memory
>>           * The actual extent isn't inserted into the extent allocation tree
>>           * until the delayed ref is processed.  must_insert_reserved is
>> @@ -242,6 +253,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>                                 u64 owner, u64 offset, int action,
>>                                 struct btrfs_delayed_extent_op *extent_op,
>>                                 int no_quota);
>> +int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
>> +                                    struct btrfs_trans_handle *trans,
>> +                                    u64 ref_root, u64 bytenr, u64 num_bytes);
>>   int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>>                                  struct btrfs_trans_handle *trans,
>>                                  u64 bytenr, u64 num_bytes,
>> --
>> 2.6.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
