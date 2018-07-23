Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbeGWItd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 04:49:33 -0400
Subject: Re: [PATCH v2 2/2] btrfs: fix missing superblock update in the device
 delete commit transaction
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
References: <20180703090724.22023-1-anand.jain@oracle.com>
 <20180703090724.22023-2-anand.jain@oracle.com>
 <20180721060113.GC575@fnst.localdomain>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4eba0d60-ef13-314e-0725-634a6113331a@oracle.com>
Date: Mon, 23 Jul 2018 15:52:59 +0800
MIME-Version: 1.0
In-Reply-To: <20180721060113.GC575@fnst.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/21/2018 02:01 PM, Lu Fengqi wrote:
> On Tue, Jul 03, 2018 at 05:07:24PM +0800, Anand Jain wrote:
>> When a device is deleted, the btrfs_super_block::number_devices is
>> reduced by 1, but we do that after the commit transaction, so this
>> change did not made it to the disk and waits for the next commit
>> transaction whenever it happens.
>>
>> This can be easily demonstrated using the following test case where I
>> use the btrfs device ready cli to read the disk and report.
>>
>>   mkfs.btrfs -fq -dsingle -msingle $dev1 $dev2
>>   mount $dev1 /btrfs
>>   btrfs dev del $dev2 /btrfs
>>   btrfs dev ready $dev1; echo RESULT=$? <-- 1
>>    Without this patch RESULT returns 1, indicating not ready!
>>
>>   Testing with a seed device:
>>
>>   mkfs.btrfs -fq $dev1
>>   btrfstune -S1 $dev1
>>   mount $dev1 /btrfs
>>   btrfs dev add -f $dev2 /btrfs
>>   umount /btrfs
>>   mount $dev2 /btrfs
>>   btrfs dev del $dev1 /btrfs
>>   btrfs dev ready $dev2; echo RESULT=$? <-- 1
>>
>>   Fix this by bringing in the num_devices update with in the
>>   current commit transaction.
>>   Also align the local variable declarations in the function
>>   btrfs_rm_dev_item()
>>   Delete a todo comment about transient inconsistent state
> 
> Hi, Anand
> 
> The btrfs/164 failed when I run xfstests with kdave/misc-next.

  And the
> result of git bisect shows this patch may be the cause. Please see the
> following log and dmesg.
> 
> xfstests log:
> # sudo ./check btrfs/164
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 larch 4.18.0-rc5+
> MKFS_OPTIONS  -- /dev/vdb2
> MOUNT_OPTIONS -- /dev/vdb2 /mnt/scratch
> 
> btrfs/164 14s ... [failed, exit status 1]
> 
> dmesg:
> [  212.009967] general protection fault: 0000 [#1] SMP PTI
> [  212.015834] CPU: 1 PID: 5665 Comm: btrfs Tainted: G           O      4.18.0-rc5+ #2
> [  212.021985] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [  212.031137] RIP: 0010:btrfs_update_commit_device_size+0x74/0xd0 [btrfs]


Thanks for the report.


--------------
void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
{
         struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
         struct btrfs_device *curr, *next;

         if (list_empty(&fs_devices->resized_devices))
                 return;

         mutex_lock(&fs_devices->device_list_mutex);
         mutex_lock(&fs_info->chunk_mutex);
         list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
                                  resized_list) {
                 list_del_init(&curr->resized_list); <----  GPF
                 curr->commit_total_bytes = curr->disk_total_bytes;
         }
         mutex_unlock(&fs_info->chunk_mutex);
         mutex_unlock(&fs_devices->device_list_mutex);
}
--------------


I can't reproduce the issue. Do you reproduce consistently? and I
wonder if your workspace contains the latest changes from
kdave/misc-next? Because last weeks kdave/misc had some issues.
Can you please give a try?

Also I found another issue - if the device being deleted is a seed
device as in btrfs/164, we don't have to call
btrfs_update_commit_device_size() as because we don't write its super.
But this isn't related to this commit nor the GPF that you saw.

Thanks, Anand



> [  212.036659] Code: ef e8 60 cc 72 e1 49 8b 96 08 01 00 00 48 8b 0a 48 8d 82 d8 fe ff ff 48 8d b1 d8 fe ff ff 49 39 d4 74 47 48 8b b8 30 01 00 00 <48> 89 79 08 48 89 0f 48 89 90 28 01 00 00 48 89 90 30 01 00 00 48
> [  212.052862] RSP: 0018:ffffc90000c3bbc0 EFLAGS: 00010202
> [  212.057537] RAX: ffff88004d45ea88 RBX: ffff88005f246820 RCX: 6b6b6b6b6b6b6b6b
> [  212.066491] RDX: ffff88004d45ebb0 RSI: 6b6b6b6b6b6b6a43 RDI: 6b6b6b6b6b6b6b6b
> [  212.072735] RBP: ffffc90000c3bbe0 R08: 0000000000000000 R09: 0000000000000001
> [  212.078961] R10: ffffc90000c3bbb0 R11: ffffffff82ea2800 R12: ffff88005f2468d0
> [  212.084967] R13: ffff880066e4c910 R14: ffff88005f2467c8 R15: ffff880066e4d138
> [  212.093457] FS:  00007fca3f6e08c0(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
> [  212.099305] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  212.103643] CR2: 00007fdd21385f88 CR3: 0000000075c4e000 CR4: 00000000000006e0
> [  212.108514] Call Trace:
> [  212.110829]  btrfs_commit_transaction+0x525/0x980 [btrfs]
> [  212.114745]  btrfs_rm_device+0x527/0x560 [btrfs]
> [  212.118082]  btrfs_ioctl+0x2e99/0x31e0 [btrfs]
> [  212.123417]  ? __lock_acquire+0x396/0x1910
> [  212.126360]  ? __might_fault+0x3e/0x90
> [  212.128924]  ? __might_fault+0x85/0x90
> [  212.131398]  ? _copy_to_user+0x65/0x80
> [  212.133870]  ? cp_new_stat+0x120/0x150
> [  212.136354]  ? native_sched_clock+0x3e/0xa0
> [  212.138825]  do_vfs_ioctl+0xa9/0x6c0
> [  212.141175]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
> [  212.144476]  ? do_vfs_ioctl+0xa9/0x6c0
> [  212.146889]  ? trace_hardirqs_on+0xd/0x10
> [  212.149210]  ksys_ioctl+0x67/0x90
> [  212.151499]  __x64_sys_ioctl+0x1a/0x20
> [  212.154064]  do_syscall_64+0x6d/0x690
> [  212.156146]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [  212.158720]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  212.161363] RIP: 0033:0x7fca3e4c1667
> [  212.163437] Code: 00 00 90 48 8b 05 e9 67 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b9 67 2c 00 f7 d8 64 89 01 48
> [  212.172921] RSP: 002b:00007ffffaf1ba08 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
> [  212.176599] RAX: ffffffffffffffda RBX: 00007ffffaf1dbd0 RCX: 00007fca3e4c1667
> [  212.179912] RDX: 00007ffffaf1ca30 RSI: 000000005000943a RDI: 0000000000000003
> [  212.184742] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [  212.188250] R10: fffffffffffff807 R11: 0000000000000202 R12: 00007ffffaf1dbd0
> [  212.191810] R13: 0000000000000000 R14: 0000000000000003 R15: 00007ffffaf1dbd8
> [  212.195309] Modules linked in: btrfs(O) xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs virtio_scsi [last unloaded: xor]
> [  212.201294] ---[ end trace d9007c0cfa00d04e ]---
> [  212.203760] RIP: 0010:btrfs_update_commit_device_size+0x74/0xd0 [btrfs]
> [  212.207008] Code: ef e8 60 cc 72 e1 49 8b 96 08 01 00 00 48 8b 0a 48 8d 82 d8 fe ff ff 48 8d b1 d8 fe ff ff 49 39 d4 74 47 48 8b b8 30 01 00 00 <48> 89 79 08 48 89 0f 48 89 90 28 01 00 00 48 89 90 30 01 00 00 48
> [  212.221356] RSP: 0018:ffffc90000c3bbc0 EFLAGS: 00010202
> [  212.224982] RAX: ffff88004d45ea88 RBX: ffff88005f246820 RCX: 6b6b6b6b6b6b6b6b
> [  212.229116] RDX: ffff88004d45ebb0 RSI: 6b6b6b6b6b6b6a43 RDI: 6b6b6b6b6b6b6b6b
> [  212.233170] RBP: ffffc90000c3bbe0 R08: 0000000000000000 R09: 0000000000000001
> [  212.237057] R10: ffffc90000c3bbb0 R11: ffffffff82ea2800 R12: ffff88005f2468d0
> [  212.240578] R13: ffff880066e4c910 R14: ffff88005f2467c8 R15: ffff880066e4d138
> [  212.244531] FS:  00007fca3f6e08c0(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
> [  212.249183] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  212.252270] CR2: 00007fdd21385f88 CR3: 0000000075c4e000 CR4: 00000000000006e0
> [  513.015417] kworker/dying (7) used greatest stack depth: 10056 bytes left
> 
