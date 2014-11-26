Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13923 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbaKZQcR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 11:32:17 -0500
Message-ID: <54760089.7020608@fb.com>
Date: Wed, 26 Nov 2014 11:32:09 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 6/6] Btrfs: make btrfs_abort_transaction consider existence
 of new block groups
References: <1417015735-8581-1-git-send-email-fdmanana@suse.com>	<1417015735-8581-7-git-send-email-fdmanana@suse.com>	<5475FAA9.7080507@fb.com>	<CAL3q7H64Y_94sbe+j3WsK6P9XUZ3xyAH4J=4q-Pyn8YSQbT=QA@mail.gmail.com>	<5475FD8A.2000602@fb.com> <CAL3q7H4B09vss8jQWFFBnwfpmhV9fT153zJfS1g=+2D69NTdWg@mail.gmail.com>
In-Reply-To: <CAL3q7H4B09vss8jQWFFBnwfpmhV9fT153zJfS1g=+2D69NTdWg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2014 11:29 AM, Filipe David Manana wrote:
> On Wed, Nov 26, 2014 at 4:19 PM, Josef Bacik <jbacik@fb.com> wrote:
>> On 11/26/2014 11:15 AM, Filipe David Manana wrote:
>>>
>>> On Wed, Nov 26, 2014 at 4:07 PM, Josef Bacik <jbacik@fb.com> wrote:
>>>>
>>>> On 11/26/2014 10:28 AM, Filipe Manana wrote:
>>>>>
>>>>>
>>>>> If the transaction handle doesn't have used blocks but has created new
>>>>> block
>>>>> groups make sure we turn the fs into readonly mode too. This is because
>>>>> the
>>>>> new block groups didn't get all their metadata persisted into the chunk
>>>>> and
>>>>> device trees, and therefore if a subsequent transaction starts,
>>>>> allocates
>>>>> space from the new block groups, writes data or metadata into that
>>>>> space,
>>>>> commits successfully and then after we unmount and mount the filesystem
>>>>> again, the same space can be allocated again for a new block group,
>>>>> resulting in file data or metadata corruption.
>>>>>
>>>>> Example where we don't abort the transaction when we fail to finish the
>>>>> chunk allocation (add items to the chunk and device trees) and later a
>>>>> future transaction where the block group is removed fails because it
>>>>> can't
>>>>> find the chunk item in the chunk tree:
>>>>>
>>>>> [25230.404300] WARNING: CPU: 0 PID: 7721 at fs/btrfs/super.c:260
>>>>> __btrfs_abort_transaction+0x50/0xfc [btrfs]()
>>>>> [25230.404301] BTRFS: Transaction aborted (error -28)
>>>>> [25230.404302] Modules linked in: btrfs dm_flakey nls_utf8 fuse xor
>>>>> raid6_pq ntfs vfat msdos fat xfs crc32c_generic libcrc32c ext3 jbd ext2
>>>>> dm_mod nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc
>>>>> loop
>>>>> psmouse i2c_piix4 i2ccore parport_pc parport processor button pcspkr
>>>>> serio_raw thermal_sys evdev microcode ext4 crc16 jbd2 mbcache sr_mod
>>>>> cdrom
>>>>> ata_generic sg sd_mod crc_t10dif crct10dif_generic crct10dif_common
>>>>> virtio_scsi floppy e1000 ata_piix libata virtio_pci virtio_ring scsi_mod
>>>>> virtio [last unloaded: btrfs]
>>>>> [25230.404325] CPU: 0 PID: 7721 Comm: xfs_io Not tainted
>>>>> 3.17.0-rc5-btrfs-next-1+ #1
>>>>> [25230.404326] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>>>>> BIOS
>>>>> rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>>>>> [25230.404328]  0000000000000000 ffff88004581bb08 ffffffff813e7a13
>>>>> ffff88004581bb50
>>>>> [25230.404330]  ffff88004581bb40 ffffffff810423aa ffffffffa049386a
>>>>> 00000000ffffffe4
>>>>> [25230.404332]  ffffffffa05214c0 000000000000240c ffff88010fc8f800
>>>>> ffff88004581bba8
>>>>> [25230.404334] Call Trace:
>>>>> [25230.404338]  [<ffffffff813e7a13>] dump_stack+0x45/0x56
>>>>> [25230.404342]  [<ffffffff810423aa>] warn_slowpath_common+0x7f/0x98
>>>>> [25230.404351]  [<ffffffffa049386a>] ?
>>>>> __btrfs_abort_transaction+0x50/0xfc
>>>>> [btrfs]
>>>>> [25230.404353]  [<ffffffff8104240b>] warn_slowpath_fmt+0x48/0x50
>>>>> [25230.404362]  [<ffffffffa049386a>] __btrfs_abort_transaction+0x50/0xfc
>>>>> [btrfs]
>>>>> [25230.404374]  [<ffffffffa04a8c43>]
>>>>> btrfs_create_pending_block_groups+0x10c/0x135 [btrfs]
>>>>> [25230.404387]  [<ffffffffa04b77fd>] __btrfs_end_transaction+0x7e/0x2de
>>>>> [btrfs]
>>>>> [25230.404398]  [<ffffffffa04b7a6d>] btrfs_end_transaction+0x10/0x12
>>>>> [btrfs]
>>>>> [25230.404408]  [<ffffffffa04a3d64>]
>>>>> btrfs_check_data_free_space+0x111/0x1f0 [btrfs]
>>>>> [25230.404421]  [<ffffffffa04c53bd>] __btrfs_buffered_write+0x160/0x48d
>>>>> [btrfs]
>>>>> [25230.404425]  [<ffffffff811a9268>] ? cap_inode_need_killpriv+0x2d/0x37
>>>>> [25230.404429]  [<ffffffff810f6501>] ? get_page+0x1a/0x2b
>>>>> [25230.404441]  [<ffffffffa04c7c95>] btrfs_file_write_iter+0x321/0x42f
>>>>> [btrfs]
>>>>> [25230.404443]  [<ffffffff8110f5d9>] ? handle_mm_fault+0x7f3/0x846
>>>>> [25230.404446]  [<ffffffff813e98c5>] ? mutex_unlock+0x16/0x18
>>>>> [25230.404449]  [<ffffffff81138d68>] new_sync_write+0x7c/0xa0
>>>>> [25230.404450]  [<ffffffff81139401>] vfs_write+0xb0/0x112
>>>>> [25230.404452]  [<ffffffff81139c9d>] SyS_pwrite64+0x66/0x84
>>>>> [25230.404454]  [<ffffffff813ebf52>] system_call_fastpath+0x16/0x1b
>>>>> [25230.404455] ---[ end trace 5aa5684fdf47ab38 ]---
>>>>> [25230.404458] BTRFS warning (device sdc):
>>>>> btrfs_create_pending_block_groups:9228: Aborting unused transaction(No
>>>>> space
>>>>> left).
>>>>> [25288.084814] BTRFS: error (device sdc) in btrfs_free_chunk:2509:
>>>>> errno=-2 No such entry (Failed lookup while freeing chunk.)
>>>>>
>>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>>> ---
>>>>>     fs/btrfs/extent-tree.c | 5 +++--
>>>>>     fs/btrfs/super.c       | 2 +-
>>>>>     2 files changed, 4 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>> index 4bf8f02..0a5e770 100644
>>>>> --- a/fs/btrfs/extent-tree.c
>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>> @@ -9209,9 +9209,8 @@ void btrfs_create_pending_block_groups(struct
>>>>> btrfs_trans_handle *trans,
>>>>>           int ret = 0;
>>>>>
>>>>>           list_for_each_entry_safe(block_group, tmp, &trans->new_bgs,
>>>>> bg_list) {
>>>>> -               list_del_init(&block_group->bg_list);
>>>>>                   if (ret)
>>>>> -                       continue;
>>>>> +                       goto next;
>>>>>
>>>>>                   spin_lock(&block_group->lock);
>>>>>                   memcpy(&item, &block_group->item, sizeof(item));
>>>>> @@ -9226,6 +9225,8 @@ void btrfs_create_pending_block_groups(struct
>>>>> btrfs_trans_handle *trans,
>>>>>                                                  key.objectid,
>>>>> key.offset);
>>>>>                   if (ret)
>>>>>                           btrfs_abort_transaction(trans, extent_root,
>>>>> ret);
>>>>> +next:
>>>>> +               list_del_init(&block_group->bg_list);
>>>>>           }
>>>>>     }
>>>>>
>>>>
>>>> I don't understand this change, logically it seems the same as what we
>>>> had
>>>> before.  Thanks,
>>>
>>>
>>> It isn't. Before we would not turn the fs readonly if the transaction
>>> had no blocks used but had new block groups. This change just makes it
>>> turn into readonly mode if it has new block groups (even if no blocks
>>> were used).
>>> See the trace in the log where it shows we failed to finish the chunk
>>> allocation but the transaction was aborted and didn't turn the fs into
>>> readonly mode.
>>>
>>
>> Yeah the bit below makes sense, its the above change that is the same.
>> Before we deleted the entry from the list and then if there is an error we
>> just continue, now if there is an error you go to next and delete the entry
>> and continue, which is the same thing.  Thanks,
>
> I don't see how it's the same.
> Before if we had a single new block group, when we called
> abort_transaction the list of block groups was empty because we
> removed the bg from the list before calling abort_transaction. This
> change just ensures that for the single new block group case
> abort_transaction sees there's a new block group and takes the action
> of making the fs readonly.
>

Oooooh Jesus I see it now, sorry

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

