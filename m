Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50843 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752170AbdCNAaK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 20:30:10 -0400
Subject: Re: [PATCH v7 1/2] btrfs: Fix metadata underflow caused by
 btrfs_reloc_clone_csum error
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fdmanana@suse.com>
References: <20170308022552.14686-1-quwenruo@cn.fujitsu.com>
 <d4241168-4adf-6f36-af61-0487f7e74f91@profihost.ag>
 <03d57894-e8df-1001-b57a-daa205037f1c@cn.fujitsu.com>
 <899cc443-07ab-eb7a-5658-f68d8b8b3ce7@profihost.ag>
 <9aced194-dcf2-dbda-143b-dbf4b582822e@cn.fujitsu.com>
 <a6594c2f-d842-71af-54e1-f1576441dff4@profihost.ag>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d9d1d430-c8dd-c2ed-6284-c34a764c7596@cn.fujitsu.com>
Date: Tue, 14 Mar 2017 08:30:04 +0800
MIME-Version: 1.0
In-Reply-To: <a6594c2f-d842-71af-54e1-f1576441dff4@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/13/2017 09:26 PM, Stefan Priebe - Profihost AG wrote:
>
> Am 13.03.2017 um 08:39 schrieb Qu Wenruo:
>>
>>
>> At 03/13/2017 03:26 PM, Stefan Priebe - Profihost AG wrote:
>>> Hi Qu,
>>>
>>> Am 13.03.2017 um 02:16 schrieb Qu Wenruo:
>>>>
>>>> At 03/13/2017 04:49 AM, Stefan Priebe - Profihost AG wrote:
>>>>> Hi Qu,
>>>>>
>>>>> while V5 was running fine against the openSUSE-42.2 kernel (based on
>>>>> v4.4).
>>>>
>>>> Thanks for the test.
>>>>
>>>>> V7 results in OOPS to me:
>>>>> BUG: unable to handle kernel NULL pointer dereference at
>>>>> 00000000000001f0
>>>>
>>>> This 0x1f0 is the same as offsetof(struct brrfs_root, fs_info), quite
>>>> nice clue.
>>>>
>>>>> IP: [<ffffffffc03dde23>] __endio_write_update_ordered+0x33/0x140
>>>>> [btrfs]
>>>>
>>>> IP points to:
>>>> ---
>>>> static inline bool btrfs_is_free_space_inode(struct btrfs_inode *inode)
>>>> {
>>>>         struct btrfs_root *root = inode->root; << Either here
>>>>
>>>>         if (root == root->fs_info->tree_root && << Or here
>>>>             btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID)
>>>>
>>>> ---
>>>>
>>>> Taking the above offset into consideration, it's only possible for later
>>>> case.
>>>>
>>>> So here, we have a btrfs_inode whose @root is NULL.
>>>
>>> But wasn't this part of the code identical in V5? Why does it only
>>> happen with V7?
>>
>> There are still difference, but just as you said, the related
>> part(checking if inode is free space cache inode) is identical across v5
>> and v7.
>
> But if i boot v7 it always happens. If i boot v5 it always works. Have
> done 5 repeatet tests.

That's a problem now, I'll dig it further to find out the difference.

Thanks,
Qu

>
>> I'm afraid that's a rare race leading to NULL btrfs_inode->root, which
>> could happen in both v5 and v7.
>>
>> What's the difference between SUSE and mainline kernel?
>
> A lot ;-) But i don't think anything related.
>
>> Maybe some mainline kernel commits have already fixed it?
>
> May be no idea. But i haven't found any reason why v5 works.
>
> Stefan
>
>>
>> Thanks,
>> Qu
>>>
>>>> This can be fixed easily by checking @root inside
>>>> btrfs_is_free_space_inode(), as the backtrace shows that it's only
>>>> happening for DirectIO, and it won't happen for free space cache inode.
>>>>
>>>> But I'm more curious how this happened for a more accurate fix, or we
>>>> could have other NULL pointer access.
>>>>
>>>> Did you have any reproducer for this?
>>>
>>> Sorry no - this is a production MariaDB Server running btrfs with
>>> compress-force=zlib. But if i could test anything i'll do.
>>>
>>> Greets,
>>> Stefan
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> PGD 14e18d4067 PUD 14e1868067 PMD 0
>>>>> Oops: 0000 [#1] SMP
>>>>> Modules linked in: netconsole xt_multiport ipt_REJECT nf_reject_ipv4
>>>>> xt_set iptable_filter ip_tables x_tables ip_set_hash_net ip_set
>>>>> nfnetlink crc32_pclmul button loop btrfs xor usbhid raid6_pq
>>>>> ata_generic
>>>>> virtio_blk virtio_net uhci_hcd ehci_hcd i2c_piix4 usbcore virtio_pci
>>>>> i2c_core usb_common ata_piix floppy
>>>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.52+112-ph #1
>>>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>>>>> 1.7.5-20140722_172050-sagunt 04/01/2014
>>>>> task: ffffffffb4e0f500 ti: ffffffffb4e00000 task.ti: ffffffffb4e00000
>>>>> RIP: 0010:[<ffffffffc03dde23>] [<ffffffffc03dde23>]
>>>>> __endio_write_update_ordered+0x33/0x140 [btrfs]
>>>>> RSP: 0018:ffff8814eae03cd8 EFLAGS: 00010086
>>>>> RAX: 0000000000000000 RBX: ffff8814e8fd5aa8 RCX: 0000000000000001
>>>>> RDX: 0000000000100000 RSI: 0000000000100000 RDI: ffff8814e45885c0
>>>>> RBP: ffff8814eae03d10 R08: ffff8814e8334000 R09: 000000018040003a
>>>>> R10: ffffea00507d8d00 R11: ffff88141f634080 R12: ffff8814e45885c0
>>>>> R13: ffff8814e125d700 R14: 0000000000100000 R15: ffff8800376c6a80
>>>>> FS: 0000000000000000(0000) GS:ffff8814eae00000(0000)
>>>>> knlGS:0000000000000000
>>>>> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> CR2: 00000000000001f0 CR3: 00000014e34c9000 CR4: 00000000001406f0Stack:
>>>>> 0000000000000000 0000000000100000 ffff8814e8fd5aa8 ffff8814e953f3c0
>>>>> ffff8814e125d700 0000000000100000 ffff8800376c6a80 ffff8814eae03d38
>>>>> ffffffffc03ddf67 ffff8814e86b6a80 ffff8814e8fd5aa8 0000000000000001
>>>>> Call Trace:
>>>>> [<ffffffffc03ddf67>] btrfs_endio_direct_write+0x37/0x60 [btrfs]
>>>>> [<ffffffffb438f2f7>] bio_endio+0x57/0x60
>>>>> [<ffffffffc04082c1>] btrfs_end_bio+0xa1/0x140 [btrfs]
>>>>> [<ffffffffb438f2f7>] bio_endio+0x57/0x60
>>>>> [<ffffffffb439763b>] blk_update_request+0x8b/0x330
>>>>> [<ffffffffb43a05ba>] blk_mq_end_request+0x1a/0x70
>>>>> [<ffffffffc039f30f>] virtblk_request_done+0x3f/0x70 [virtio_blk]
>>>>> [<ffffffffb43a0688>] __blk_mq_complete_request+0x78/0xe0
>>>>> [<ffffffffb43a070c>] blk_mq_complete_request+0x1c/0x20
>>>>> [<ffffffffc039f184>] virtblk_done+0x64/0xe0 [virtio_blk]
>>>>> [<ffffffffb446dd2a>] vring_interrupt+0x3a/0x90
>>>>> [<ffffffffb40d3fe9>] __handle_irq_event_percpu+0x89/0x1b0
>>>>> [<ffffffffb40d4133>] handle_irq_event_percpu+0x23/0x60
>>>>> [<ffffffffb40d41ab>] handle_irq_event+0x3b/0x60
>>>>> [<ffffffffb40d74ef>] handle_edge_irq+0x6f/0x150
>>>>> [<ffffffffb4007cad>] handle_irq+0x1d/0x30
>>>>> [<ffffffffb400750b>] do_IRQ+0x4b/0xd0
>>>>> [<ffffffffb46af8cc>] common_interrupt+0x8c/0x8c
>>>>> DWARF2 unwinder stuck at ret_from_intr+0x0/0x1b
>>>>> Leftover inexact backtrace:
>>>>> 2017-03-12 20:33:08     <IRQ><EOI>
>>>>> 2017-03-12 20:33:08      [<ffffffffb404ba46>] ?
>>>>> native_safe_halt+0x6/0x10
>>>>> [<ffffffffb400fa3e>] default_idle+0x1e/0xe0
>>>>> [<ffffffffb401021f>] arch_cpu_idle+0xf/0x20
>>>>> [<ffffffffb40c67eb>] default_idle_call+0x3b/0x40
>>>>> [<ffffffffb40c6a8a>] cpu_startup_entry+0x29a/0x370
>>>>> [<ffffffffb46a358c>] rest_init+0x7c/0x80
>>>>> [<ffffffffb4f67fa5>] start_kernel+0x490/0x49d
>>>>> [<ffffffffb4f67120>] ? early_idt_handler_array+0x120/0x120
>>>>> [<ffffffffb4f674b3>] x86_64_start_reservations+0x2a/0x2c
>>>>> [<ffffffffb4f675f0>] x86_64_start_kernel+0x13b/0x14a
>>>>> Code: e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 83 ec 10 48 8b 87 70 fc
>>>>> ff ff 4c 8b 87 38 fe ff ff 48 c7 45 c8 00 00 00 00 48 89 75 d0 <48> 8b
>>>>> b8 f0 01 00 00 48 3b 47 28 49 8b 84 24 78 fc ff ff 0f 84
>>>>> RIP [<ffffffffc03dde23>] __endio_write_update_ordered+0x33/0x140
>>>>> [btrfs]
>>>>> RSP <ffff8814eae03cd8>
>>>>> CR2: 00000000000001f0
>>>>> ---[ end trace 7529a0652fd7873e ]---
>>>>> Kernel panic - not syncing: Fatal exception in interrupt
>>>>> Kernel Offset: 0x33000000 from 0xffffffff81000000 (relocation range:
>>>>> 0xffffffff80000000-0xffffffffbfffffff)
>>>>>
>>>>> Greets,
>>>>> Stefan
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


