Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from infao0809.mpi-klsb.mpg.de ([139.19.1.49]:57401 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab3LIUQw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Dec 2013 15:16:52 -0500
Message-ID: <52A6252D.1010304@mpi-sws.org>
Date: Mon, 09 Dec 2013 21:16:45 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: Null pointer oops when deleting item in btrfs_find_all_root()
References: <52A1CAA5.8090302@mpi-sws.org> <20131206135836.GD20595@localhost.localdomain> <52A1DA80.4000203@mpi-sws.org>
In-Reply-To: <52A1DA80.4000203@mpi-sws.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

I ran again the tests on 3.12.2 + patch ("Btrfs: fix a crash when 
running balance and defrag concurrently") but the patch doesn't seem to 
solve the problem I reported earlier. I still get a similar oops [2].

Let me know if you need more information.

Pedro

[2] Oops:
> [  511.822943] btrfs: new size for /dev/loop0 is 305135616
> [  511.822943] btrfs: relocating block group 20971520 flags 1
> [  532.060786] BUG: unable to handle kernel NULL pointer dereference 
> at   (null)
> [  532.060786] IP: [<c127b0a1>] __list_del_entry+0x4/0x71
> [  532.060786] *pde = 00000000
> [  532.060786] Oops: 0000 [#1] SMP
> [  532.060786] Modules linked in: loop rtc_cmos pcspkr tpm_tis i2c_piix4
> [  532.060786] CPU: 0 PID: 2708 Comm: btrfs-endio-wri Not tainted 
> 3.12.2 #2
> [  532.060786] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  532.060786] task: ded30090 ti: deed6000 task.ti: deed6000
> [  532.060786] EIP: 0060:[<c127b0a1>] EFLAGS: 00000207 CPU: 0
> [  532.060786] EIP is at __list_del_entry+0x4/0x71
> [  532.060786] EAX: 00000000 EBX: 00000000 ECX: deed7d18 EDX: d94c0f18
> [  532.060786] ESI: deed7d10 EDI: 00000000 EBP: deed7ca8 ESP: deed7ca4
> [  532.060786]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  532.060786] CR0: 8005003b CR2: 00000000 CR3: 053c8000 CR4: 00000690
> [  532.060786] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  532.060786] DR6: 00000000 DR7: 00000000
> [  532.060786] Stack:
> [  532.060786]  00000000 deed7cb4 c127b119 00000000 deed7d60 c12319a6 
> df6eb160 00000286
> [  532.060786]  d94c0f18 deed7cdc 00000000 00bb9000 c6a97000 00000001 
> d95794c8 00000000
> [  532.060786]  00000000 00000001 deecd800 00000490 d94c0f18 deed7d18 
> 00000000 deed7d18
> [  532.060786] Call Trace:
> [  532.060786]  [<c127b119>] list_del+0xb/0x1b
> [  532.060786]  [<c12319a6>] find_parent_nodes+0xfe6/0x103e
> [  532.060786]  [<c1231a78>] btrfs_find_all_roots+0x67/0xba
> [  532.060786]  [<c1232154>] iterate_extent_inodes+0xfa/0x1b9
> [  532.060786]  [<c1232290>] iterate_inodes_from_logical+0x7d/0x93
> [  532.060786]  [<c11eeb3e>] ? btrfs_clear_bit_hook+0x1f9/0x1f9
> [  532.060786]  [<c11ed6a1>] record_extent_backrefs+0x50/0x8a
> [  532.060786]  [<c11eeb3e>] ? btrfs_clear_bit_hook+0x1f9/0x1f9
> [  532.060786]  [<c11f5ac4>] btrfs_finish_ordered_io+0x7af/0x8ad
> [  532.060786]  [<c11f5bcd>] finish_ordered_fn+0xb/0xd
> [  532.060786]  [<c121003c>] worker_loop+0xf5/0x3d1
> [  532.060786]  [<c120ff47>] ? btrfs_queue_worker+0x1e4/0x1e4
> [  532.060786]  [<c103e612>] kthread+0x6e/0x73
> [  532.060786]  [<c1648877>] ret_from_kernel_thread+0x1b/0x28
> [  532.060786]  [<c103e5a4>] ? __kthread_parkme+0x54/0x54
> [  532.060786] Code: 56 68 e1 76 8b c1 6a 5e 68 8f 76 8b c1 e8 66 06 
> db ff 83 c4 18 89 37 89 5f 04 89 3b 89 7e 04 8d 65 f4 5b 5e 5f 5d c3 
> 55 89 e5 53 <8b> 08 8b 50 04 81 f9 00 01 10 00 75 41 68 00 01 10 00 50 
> 68 32
> [  532.060786] EIP: [<c127b0a1>] __list_del_entry+0x4/0x71 SS:ESP 
> 0068:deed7ca4
> [  532.060786] CR2: 0000000000000000
> [  532.060786] ---[ end trace 39d9898f10bcb730 ]---



On 12/6/13 3:09 PM, Pedro Fonseca wrote:
> On 12/06/2013 02:58 PM, Liu Bo wrote:
>> On Fri, Dec 06, 2013 at 02:01:25PM +0100, Pedro Fonseca wrote:
>>> Hi,
>>>
>>> I've encountered another null pointer bug in btrfs_find_all_root().
>>>
>>> It may be releated to a bug I previously reported to the mailing
>>> list ("Null pointer dereference bug in btrfs_find_all_root"). But
>>> this test ran on kernel version 3.12.2 and the oops was triggered
>>> when deleting an item from the list. The actual workload (i.e. FS
>>> operations) is similar though.
>> Not sure if the following commit[1] has been merged in this 3.12.2,
>> any chance to check it?
>>
>> -liubo
>>
>>
>> [1]:
>> commit 48ec47364b6d493f0a9cdc116977bf3f34e5c3ec
>> Author: Liu Bo<bo.li.liu@oracle.com>
>> Date:   Wed Oct 30 13:25:24 2013 +0800
>>
>>      Btrfs: fix a crash when running balance and defrag concurrently
>>
>
> You're right, that patch didn't make it to 3.12.2.
>
> I'll try to run the tests with the patch.
>
> Pedro
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

