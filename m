Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hera.mpi-sb.mpg.de ([139.19.1.49]:47853 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KSKE3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 05:04:29 -0500
Message-ID: <528B390E.6060107@mpi-sws.org>
Date: Tue, 19 Nov 2013 11:10:22 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: Sync() causes null pointer dereference and warning message in
 run_clustered_refs()
References: <527E714A.3040206@mpi-sws.org> <20131114024603.GB12933@localhost.localdomain>
In-Reply-To: <20131114024603.GB12933@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

Sorry, somehow I missed your email.

Let me know if you need additional information. Here's the result of "objdump -d -S" nearby "run_clustered_refs+0x877":

> c12a854f:   83 c4 0c                add    $0xc,%esp
> c12a8552:   eb 3f                   jmp    c12a8593 <run_clustered_refs+0x8a6>
>  * a node might live in a head or a regular ref, this lets you
>  * test for the proper type to use.
>  */
> static int btrfs_delayed_ref_is_head(struct btrfs_delayed_ref_node *node)
> {
>     return node->is_head;
> c12a8554:   f6 43 2e 01             testb  $0x1,0x2e(%ebx)
> c12a8558:   74 1a                   je     c12a8574 <run_clustered_refs+0x887>
>          * have been dealt with, and we will pick the next head to deal
>          * with, so we must unlock the head and drop it from the cluster
>          * list before we release it.         */
>         if (btrfs_delayed_ref_is_head(ref)) {
>             list_del_init(&locked_ref->cluster);
> c12a855a:   8d 77 48                lea    0x48(%edi),%esi
>  * list_del_init - deletes entry from list and reinitialize it.
>  * @entry: the element to delete from the list.
>  */
> static inline void list_del_init(struct list_head *entry)
> {
>     __list_del_entry(entry);
> c12a855d:   89 f0                   mov    %esi,%eax
> c12a855f:   e8 c9 fd 0d 00          call   c138832d <__list_del_entry>
> btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
> int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
>                struct btrfs_delayed_ref_head *head);
> static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
> {
>     mutex_unlock(&head->mutex);
> c12a8564:   8d 47 30                lea    0x30(%edi),%eax
> #define LIST_HEAD(name) \
>     struct list_head name = LIST_HEAD_INIT(name)
>
> static inline void INIT_LIST_HEAD(struct list_head *list)
> {
>     list->next = list;
> c12a8567:   89 77 48                mov    %esi,0x48(%edi)
>     list->prev = list;
> c12a856a:   89 77 4c                mov    %esi,0x4c(%edi)
> c12a856d:   31 ff                   xor    %edi,%edi
> c12a856f:   e8 1f 0f 4c 00          call   c1769493 <mutex_unlock>


Pedro



On 11/14/13 03:46 , Liu Bo wrote:
> On Sat, Nov 09, 2013 at 09:30:50AM -0800, Pedro Fonseca wrote:
>> Hi,
>>
>> I've encountered a bug that triggers a warning message ("list_del
>> corruption. next->prev should be d9d0ae28, but was d9d5d5e8") and
>> subsequently causes a null pointer dereference while running a
>> custom test case on btrfs (kernel 3.11.1), inside a QEMU based VM.
>>
>> The bug was triggered during the execution of two concurrent sync() calls.
>>
>> Here's the list of FS operations executed immediately before the crash:
>>> CPU: 0 Op: fdatasync
>>> CPU: 0 Op: btrfs_ioctl_device_delete
>>> CPU: 0 Op: rename (file: "d16/da6/l131" renamed to "d16/d21/d38/l13b")
>>> CPU: 0 Op: btrfs_subvol_snapshot
>>>          CPU: 1 Op: fdatasync
>>>          CPU: 1 Op: btrfs_ioctl_device_delete
>>>          CPU: 1 Op: rename (file: "d16/da6/l131" renamed to
>>> "d16/d21/d38/l13b")
>>>          CPU: 1 Op: btrfs_subvol_snapshot
>>> CPU: 0 Op: dwrite (file: "d16/d21/f51")
>>> CPU: 0 Op: chown (file: "d16/da6/f114")
>>> CPU: 0 Op: write (file: "d16/d21/f107")
>>> CPU: 0 Op: sync
>>>          CPU: 1 Op: dwrite (file: "d16/d21/f51")
>>>          CPU: 1 Op: chown (file: "d16/c1c")
>>>          CPU: 1 Op: write (file: "d16/d21/f107")
>>>          CPU: 1 Op: sync
>> (Note that the entries in this log refer to the moment when the
>> operations were initiated, i.e., operations on different CPUs may
>> overlap):
>>
>>
>> And here's the system log output:
>>> [  127.830656] ------------[ cut here ]------------
>>> [  127.830656] WARNING: CPU: 0 PID: 2791 at /local/pfonseca/piking/kernel-build/linux-3.11.1-fs-static/lib/list_debug.c:62
>>> __list_del_entry+0x62/0x71()
>>> [  127.830656] list_del corruption. next->prev should be d9d0ae28,
>>> but was d9d5d5e8
>>> [  127.830656] Modules linked in: loop rtc_cmos pcspkr tpm_tis
>>> freq_table mperf i2c_piix4
>>> [  127.830656] CPU: 0 PID: 2791 Comm: fsstress Not tainted 3.11.1 #2
>>> [  127.830656] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>>> [  127.830656]  0000003e c4027dd8 c176917a c1a13c6e c4027df0
>>> c102d1c0 c138838f d9d0ae28
>>> [  127.830656]  d9d0ae28 d9d0ade0 c4027e08 c102d23b 00000009
>>> c4027e00 c1a13dad c4027e1c
>>> [  127.830656]  c4027e28 c138838f c1a13c6e 0000003e c1a13dad
>>> d9d0ae28 d9d5d5e8 d9d0ade0
>>> [  127.830656] Call Trace:
>>> [  127.830656]  [<c176917a>] dump_stack+0x41/0x57
>>> [  127.830656]  [<c102d1c0>] warn_slowpath_common+0x5e/0x75
>>> [  127.830656]  [<c138838f>] ? __list_del_entry+0x62/0x71
>>> [  127.830656]  [<c102d23b>] warn_slowpath_fmt+0x26/0x2a
>>> [  127.830656]  [<c138838f>] __list_del_entry+0x62/0x71
>>> [  127.830656]  [<c12a8564>] run_clustered_refs+0x877/0x8b0
>
>
> Could you please show what run_clustered_refs+0x877 refers to?
>
> Something like,
> gdb> l *run_clustered_refs+0x877
>
> -liubo
>
>>> [  127.830656]  [<c12eed36>] ? btrfs_find_ref_cluster+0xc9/0x10e
>>> [  127.830656]  [<c12a878f>] btrfs_run_delayed_refs+0x1f2/0x35b
>>> [  127.830656]  [<c1075d14>] ? __delayacct_blkio_end+0x30/0x36
>>> [  127.830656]  [<c12b56b9>] btrfs_commit_transaction+0x60/0x986
>>> [  127.830656]  [<c12b6657>] ? start_transaction+0x320/0x3cd
>>> [  127.830656]  [<c12b671b>] ? btrfs_attach_transaction_barrier+0x17/0x3c
>>> [  127.830656]  [<c1295b1a>] btrfs_sync_fs+0x4c/0x53
>>> [  127.830656]  [<c10c6f1b>] sync_fs_one_sb+0x17/0x19
>>> [  127.830656]  [<c10acab0>] iterate_supers+0x54/0x95
>>> [  127.830656]  [<c10c6f04>] ? SyS_splice+0x455/0x455
>>> [  127.830656]  [<c10c72dd>] sys_sync+0x46/0x70
>>> [  127.830656]  [<c176c2fe>] sysenter_do_call+0x12/0x26
>>> [  127.830656] ---[ end trace 626899e11111abbe ]---
>>> [  127.830656] BUG: unable to handle kernel NULL pointer
>>> dereference at   (null)
>>> [  127.830656] IP: [<c137ed3d>] rb_erase+0x177/0x236
>>> [  127.830656] *pde = 00000000
>>> [  127.830656] Oops: 0000 [#1] SMP
>>> [  127.830656] Modules linked in: loop rtc_cmos pcspkr tpm_tis
>>> freq_table mperf i2c_piix4
>>> [  127.830656] CPU: 0 PID: 2791 Comm: fsstress Tainted: G W    3.11.1 #2
>>> [  127.830656] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>>> [  127.830656] task: de60efc0 ti: c4026000 task.ti: c4026000
>>> [  127.830656] EIP: 0060:[<c137ed3d>] EFLAGS: 00000246 CPU: 0
>>> [  127.830656] EIP is at rb_erase+0x177/0x236
>>> [  127.830656] EAX: 00000000 EBX: 00000000 ECX: d9d0d180 EDX: d9cebddc
>>> [  127.830656] ESI: 00000001 EDI: d9d0ade0 EBP: c4027e28 ESP: c4027e18
>>> [  127.830656]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>>> [  127.830656] CR0: 8005003b CR2: 00000000 CR3: 059d8000 CR4: 00000690
>>> [  127.830656] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>>> [  127.830656] DR6: 00000000 DR7: 00000000
>>> [  127.830656] Stack:
>>> [  127.830656]  d9d0ade0 d9d0ade0 00000000 d9d0ade0 c4027eb8
>>> c12a7fe0 00000000 00000001
>>> [  127.830656]  00000000 00000002 00000000 c4027f0c 00cc9a28
>>> d9cebddc de4d1000 0000095c
>>> [  127.830656]  de4d1000 00000007 00000000 0000001e d9cebd60
>>> 00000000 00000000 d9cebde0
>>> [  127.830656] Call Trace:
>>> [  127.830656]  [<c12a7fe0>] run_clustered_refs+0x2f3/0x8b0
>>> [  127.830656]  [<c12eed36>] ? btrfs_find_ref_cluster+0xc9/0x10e
>>> [  127.830656]  [<c12a878f>] btrfs_run_delayed_refs+0x1f2/0x35b
>>> [  127.830656]  [<c1075d14>] ? __delayacct_blkio_end+0x30/0x36
>>> [  127.830656]  [<c12b56b9>] btrfs_commit_transaction+0x60/0x986
>>> [  127.830656]  [<c12b6657>] ? start_transaction+0x320/0x3cd
>>> [  127.830656]  [<c12b671b>] ? btrfs_attach_transaction_barrier+0x17/0x3c
>>> [  127.830656]  [<c1295b1a>] btrfs_sync_fs+0x4c/0x53
>>> [  127.830656]  [<c10c6f1b>] sync_fs_one_sb+0x17/0x19
>>> [  127.830656]  [<c10acab0>] iterate_supers+0x54/0x95
>>> [  127.830656]  [<c10c6f04>] ? SyS_splice+0x455/0x455
>>> [  127.830656]  [<c10c72dd>] sys_sync+0x46/0x70
>>> [  127.830656]  [<c176c2fe>] sysenter_do_call+0x12/0x26
>>> [  127.830656] Code: 73 04 85 f6 89 70 08 89 43 04 89 59 04 74 07
>>> 89 c7 83 cf 01 89 3e 89 c6 89 d8 8b 58 08 89 59 04 89 48 08 e9 8c
>>> 00 00 00 8b 41 08 <f6> 00 01 75 2e 8b 58 04 89 ce 83 ce 01 89 59
>>> 08 89 48 04 89 33
>>> [  127.830656] EIP: [<c137ed3d>] rb_erase+0x177/0x236 SS:ESP 0068:c4027e18
>>> [  127.830656] CR2: 0000000000000000
>>> [  127.830656] ---[ end trace 626899e11111abbf ]---
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
