Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hera.mpi-sb.mpg.de ([139.19.1.49]:58232 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3J2Nk4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 09:40:56 -0400
Message-ID: <526FBAE1.1070409@mpi-sws.org>
Date: Tue, 29 Oct 2013 14:40:49 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: Null pointer dereference bug in btrfs_find_all_root
References: <526E8A83.4030201@mpi-sws.org> <20131029020554.GA32338@localhost.localdomain> <526F2DBF.4090404@mpi-sws.org> <20131029061724.GB32338@localhost.localdomain>
In-Reply-To: <20131029061724.GB32338@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/29/2013 07:17 AM, Liu Bo wrote:
> On Tue, Oct 29, 2013 at 04:38:39AM +0100, Pedro Fonseca wrote:
>> On 10/29/13 3:05 AM, Liu Bo wrote:
>>> Hi,
>>>
>>> On Mon, Oct 28, 2013 at 05:02:11PM +0100, Pedro Fonseca wrote:
>>>> Hi,
>>>>
>>>> I've encountered a few NULL pointer dereference bugs while running a
>>>> custom test case on btrfs (kernel 3.11.1), inside a QEMU based VM.
>>>>
>>>> Btrfs was statically compiled and the btrfs filesystem was mounted
>>>> on one or two loop devices. All cases occurred during execution of a
>>>> "filesystem balance" operation and while another file system
>>>> operation was concurrently executed. In one case the other operation
>>>> was a "mknod" and in another it was a "filesystem show" operation.
>>> I'm wonderring that if there is anything like 'aborted transaction' in
>>> the dmesg log besides this NULL pointer dereference?
>>>
>>> -liubo
>> No, I didn't find any references to aborted transactions. But I did
>> get a message about "relocation of block groups" and a few other
>> messages caused by resizing operations.
>>
>> These are all the filesystem messages I got before the actual bug report:
>>
>> [  111.836409] loop: module loaded
>> [  112.939586] device fsid acb9f83e-75d7-4177-9f7b-4b7c8e0f53d9
>> devid 1 transid 7 /dev/loop0
>> [  122.328339] btrfs: new size for /dev/loop0 is 311427072
>> [  122.396188] btrfs: new size for /dev/loop0 is 301989888
>> [  122.646333] btrfs: new size for /dev/loop0 is 299892736
>> [  127.788383] btrfs: new size for /dev/loop0 is 305135616
>> [  127.830656] btrfs: relocating block group 20971520 flags 1
> So far we've known the test has mixed operations of 'balance', 'resize' and
> 'show'.  (The stack shows that the test may have made a defrag operation.)
>
> Is it possible to apply any debugging patch on your box?
>
> (I'm also available on IRC #btrfs)
>
> -liubo
>

I think you're right, there was probably a balance operation 
concurrently executed with a defragment.

Bellow I have the trace of FS operations that were executed just before 
the bug report. Note that the trace indicates when an operation started 
on a certain CPU but there's likely to be overlap between operations 
that were executed on different CPUs. The cases 2a, 2b and 2c should 
have executed the exact same operations but with different schedules.

Case 1:
> CPU: 1 Op: truncate
> CPU: 1 Op: creat
> CPU: 1 Op: chown
> CPU: 1 Op: fdatasync
> CPU: 1 Op: chown
> CPU: 1 Op: btrfs_ioctl_filesystem_resize
> CPU: 1 Op: btrfs_subvol_delete
> CPU: 1 Op: rename
> CPU: 1 Op: btrfs_ioctl_filesystem_balance
> CPU: 0 Op: unlink
> CPU: 0 Op: btrfs_ioctl_filesystem_defragment
> CPU: 0 Op: btrfs_subvol_list
> CPU: 0 Op: btrfs_ioctl_filesystem_show
> <bug report>

Case 2a:
> CPU: 0 Op: truncate
> CPU: 0 Op: creat
> CPU: 0 Op: chown
> CPU: 0 Op: fdatasync
> CPU: 0 Op: chown
> CPU: 0 Op: btrfs_ioctl_filesystem_resize
> CPU: 0 Op: btrfs_subvol_delete
> CPU: 0 Op: rename
> CPU: 0 Op: btrfs_ioctl_filesystem_balance
> CPU: 1 Op: chown
> CPU: 1 Op: btrfs_ioctl_filesystem_df
> CPU: 1 Op: symlink
> CPU: 1 Op: chown
> CPU: 1 Op: btrfs_ioctl_filesystem_defragment
> CPU: 1 Op: mknod
> <bug report>

Case 2b:
> CPU: 0 Op: truncate
> CPU: 0 Op: creat
> CPU: 0 Op: chown
> CPU: 0 Op: fdatasync
> CPU: 0 Op: chown
> CPU: 0 Op: btrfs_ioctl_filesystem_resize
> CPU: 0 Op: btrfs_subvol_delete
> CPU: 0 Op: rename
> CPU: 1 Op: chown
> CPU: 1 Op: btrfs_ioctl_filesystem_df
> CPU: 1 Op: symlink
> CPU: 0 Op: btrfs_ioctl_filesystem_balance
> CPU: 1 Op: chown
> CPU: 1 Op: btrfs_ioctl_filesystem_defragment
> CPU: 1 Op: mknod
> <bug report>

Case 2c:
> CPU: 0 Op: truncate
> CPU: 0 Op: creat
> CPU: 0 Op: chown
> CPU: 0 Op: fdatasync
> CPU: 0 Op: chown
> CPU: 0 Op: btrfs_ioctl_filesystem_resize
> CPU: 0 Op: btrfs_subvol_delete
> CPU: 0 Op: rename
> CPU: 0 Op: btrfs_ioctl_filesystem_balance
> CPU: 1 Op: chown
> CPU: 1 Op: btrfs_ioctl_filesystem_df
> CPU: 1 Op: symlink
> CPU: 1 Op: chown
> CPU: 1 Op: btrfs_ioctl_filesystem_defragment
> CPU: 1 Op: mknod
> <bug report>


In case it helps, I also ran btrfsck just before executing the 
operations that I mentioned above and I got the following result:
> btrfsck: fs tree 257 refs 4
>  btrfsck:       unresolved ref root 258 dir 256 index 10 namelen 3 
> name d21 error 600
>  btrfsck:       unresolved ref root 262 dir 256 index 10 namelen 3 
> name d21 error 600
>  btrfsck:       unresolved ref root 263 dir 256 index 10 namelen 3 
> name d21 error 600
>  btrfsck: fs tree 262 refs 2
>  btrfsck:       unresolved ref root 263 dir 256 index 39 namelen 3 
> name da6 error 600
>  btrfsck: found 9863168 bytes used err is 1
>  btrfsck: total csum bytes: 9164
>  btrfsck: total tree bytes: 479232
>  btrfsck: total fs tree bytes: 401408
>  btrfsck: btree space waste bytes: 147323
>  btrfsck: file data blocks allocated: 12320768
>  btrfsck:  referenced 11395072
>  btrfsck: Btrfs Btrfs v0.19


I can apply a patch to it if necessary and I'll be on IRC too.

I tried to get an execution trace for the last few operations that lead 
to the bug but I had some difficulty getting it because the trace 
becomes quite large. I'll let you know if I manage to get it.

Pedro

>>>> In all cases the NULL pointer dereference occurred in the
>>>> "btrfs_find_all_roots" function and all cases produced a bug report
>>>> similar to the one bellow:
>>>>
>>>>> [  138.573390] BUG: unable to handle kernel NULL pointer
>>>>> dereference at   (null)
>>>>> [  138.573390] IP: [<c12feeb3>] ulist_next+0x4/0x26
>>>>> [  138.573390] *pde = 00000000
>>>>> [  138.573390] Oops: 0000 [#1] SMP
>>>>> [  138.573390] Modules linked in: loop rtc_cmos pcspkr tpm_tis
>>>>> freq_table mperf i2c_piix4
>>>>> [  138.573390] CPU: 0 PID: 2794 Comm: btrfs-endio-wri Not tainted
>>>>> 3.11.1 #2
>>>>> [  138.573390] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>>>>> [  138.573390] task: c5dea6b0 ti: c5e12000 task.ti: c5e12000
>>>>> [  138.573390] EIP: 0060:[<c12feeb3>] EFLAGS: 00000246 CPU: 0
>>>>> [  138.573390] EIP is at ulist_next+0x4/0x26
>>>>> [  138.573390] EAX: 00000000 EBX: 00000000 ECX: d9c29e38 EDX: c5e13da4
>>>>> [  138.573390] ESI: 00000000 EDI: c5e13e00 EBP: c5e13d94 ESP: c5e13d90
>>>>> [  138.573390]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>>>>> [  138.573390] CR0: 8005003b CR2: 00000000 CR3: 059d8000 CR4: 00000690
>>>>> [  138.573390] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>>>>> [  138.573390] DR6: 00000000 DR7: 00000000
>>>>> [  138.573390] Stack:
>>>>> [  138.573390]  00000000 c5e13db4 c12fe7b8 de4d1000 d9cead48
>>>>> 00000001 010dd000 deeab810
>>>>> [  138.573390]  00000001 c5e13e10 c12fe8cf 00af2000 00000000
>>>>> 00000000 00000003 c5e13e00
>>>>> [  138.573390]  deeabe00 00000000 00000003 deeab800 de4d1000
>>>>> d9cead48 de4d14b8 de4d14b8
>>>>> [  138.573390] Call Trace:
>>>>> [  138.573390]  [<c12fe7b8>] btrfs_find_all_roots+0x88/0xa6
>>>>> [  138.573390]  [<c12fe8cf>] iterate_extent_inodes+0xf9/0x1b2
>>>>> [  138.573390]  [<c12feba9>] iterate_inodes_from_logical+0x88/0x97
>>>>> [  138.573390]  [<c12b8880>] ? record_extent_backrefs+0x8b/0x8b
>>>>> [  138.573390]  [<c12b8845>] record_extent_backrefs+0x50/0x8b
>>>>> [  138.573390]  [<c12b8880>] ? record_extent_backrefs+0x8b/0x8b
>>>>> [  138.573390]  [<c12c1f8e>] btrfs_finish_ordered_io+0x77e/0x876
>>>>> [  138.573390]  [<c12c2091>] finish_ordered_fn+0xb/0xd
>>>>> [  138.573390]  [<c12db161>] worker_loop+0x111/0x3ec
>>>>> [  138.573390]  [<c104a2c4>] ? default_wake_function+0xb/0xd
>>>>> [  138.573390]  [<c1040c43>] kthread+0x90/0x95
>>>>> [  138.573390]  [<c12db050>] ? btrfs_queue_worker+0x1c8/0x1c8
>>>>> [  138.573390]  [<c176c277>] ret_from_kernel_thread+0x1b/0x28
>>>>> [  138.573390]  [<c1040bb3>] ? kthread_freezable_should_stop+0x4f/0x4f
>>>>> [  138.573390] Code: 5b 5e 5f 5d c3 90 90 90 55 8d 50 10 89 e5 c7
>>>>> 00 00 00 00 00 89 50 08 c7 40 04 10 00 00 00 c7 40 0c 00 00 00 00
>>>>> 5d c3 55 89 e5 53<8b>  08 85 c9 74 15 8b 1a 85 db 78 0f 39 cb 73
>>>>> 0b 6b cb 1c 43 03
>>>>> [  138.573390] EIP: [<c12feeb3>] ulist_next+0x4/0x26 SS:ESP 0068:c5e13d90
>>>>> [  138.573390] CR2: 0000000000000000
>>>>> [  138.573390] ---[ end trace 626899e11111abbe ]---
>>>>> [  138.573390] BUG: unable to handle kernel NULL pointer
>>>>> dereference at   (null)
>>>>> [  138.573390] IP: [<c12feeb3>] ulist_next+0x4/0x26
>>>>> [  138.573390] *pde = 00000000
>>>>> [  138.573390] Oops: 0000 [#2] SMP
>>>>> [  138.573390] Modules linked in: loop rtc_cmos pcspkr tpm_tis
>>>>> freq_table mperf i2c_piix4
>>>>> [  138.573390] CPU: 1 PID: 2793 Comm: btrfs-endio-wri Tainted: G
>>>>> D      3.11.1 #2
>>>>> [  138.573390] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>>>>> [  138.573390] task: c59cc190 ti: dedc8000 task.ti: dedc8000
>>>>> [  138.573390] EIP: 0060:[<c12feeb3>] EFLAGS: 00000246 CPU: 1
>>>>> [  138.573390] EIP is at ulist_next+0x4/0x26
>>>>> [  138.573390] EAX: 00000000 EBX: 00000000 ECX: d9c296c8 EDX: dedc9da4
>>>>> [  138.573390] ESI: 00000000 EDI: dedc9e00 EBP: dedc9d94 ESP: dedc9d90
>>>>> [  138.573390]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>>>>> [  138.573390] CR0: 8005003b CR2: 00000000 CR3: 03ebe000 CR4: 00000690
>>>>> [  138.573390] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>>>>> [  138.573390] DR6: 00000000 DR7: 00000000
>>>>> [  138.573390] Stack:
>>>>> [  138.573390]  00000000 dedc9db4 c12fe7b8 de4d1000 d9ceaf50
>>>>> 00000001 00dea000 de4c6410
>>>>> [  138.573390]  00000001 dedc9e10 c12fe8cf 00af2000 00000000
>>>>> 00000000 00000005 dedc9e00
>>>>> [  138.573390]  de4c6c00 00000000 00000005 de4c6400 de4d1000
>>>>> d9ceaf50 de4d14b8 c5e13de8
>>>>> [  138.573390] Call Trace:
>>>>> [  138.573390]  [<c12fe7b8>] btrfs_find_all_roots+0x88/0xa6
>>>>> [  138.573390]  [<c12fe8cf>] iterate_extent_inodes+0xf9/0x1b2
>>>>> [  138.573390]  [<c12feba9>] iterate_inodes_from_logical+0x88/0x97
>>>>> [  138.573390]  [<c12b8880>] ? record_extent_backrefs+0x8b/0x8b
>>>>> [  138.573390]  [<c12b8845>] record_extent_backrefs+0x50/0x8b
>>>>> [  138.573390]  [<c12b8880>] ? record_extent_backrefs+0x8b/0x8b
>>>>> [  138.573390]  [<c12c1f8e>] btrfs_finish_ordered_io+0x77e/0x876
>>>>> [  138.573390]  [<c12c2091>] finish_ordered_fn+0xb/0xd
>>>>> [  138.573390]  [<c12db161>] worker_loop+0x111/0x3ec
>>>>> [  138.573390]  [<c104a2c4>] ? default_wake_function+0xb/0xd
>>>>> [  138.573390]  [<c1040c43>] kthread+0x90/0x95
>>>>> [  138.573390]  [<c12db050>] ? btrfs_queue_worker+0x1c8/0x1c8
>>>>> [  138.573390]  [<c176c277>] ret_from_kernel_thread+0x1b/0x28
>>>>> [  138.573390]  [<c1040bb3>] ? kthread_freezable_should_stop+0x4f/0x4f
>>>>> [  138.573390] Code: 5b 5e 5f 5d c3 90 90 90 55 8d 50 10 89 e5 c7
>>>>> 00 00 00 00 00 89 50 08 c7 40 04 10 00 00 00 c7 40 0c 00 00 00 00
>>>>> 5d c3 55 89 e5 53<8b>  08 85 c9 74 15 8b 1a 85 db 78 0f 39 cb 73
>>>>> 0b 6b cb 1c 43 03
>>>>> [  138.573390] EIP: [<c12feeb3>] ulist_next+0x4/0x26 SS:ESP 0068:dedc9d90
>>>>> [  138.573390] CR2: 0000000000000000
>>>>> [  138.573390] ---[ end trace 626899e11111abbf ]---
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

