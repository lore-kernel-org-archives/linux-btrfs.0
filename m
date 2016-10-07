Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:39802 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756195AbcJGIQm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 04:16:42 -0400
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
 <57EBAAF5.10509@cn.fujitsu.com>
 <4f91af54-78ae-5c08-3daa-8a0c16210e5f@profihost.ag>
 <57EBB329.9060009@cn.fujitsu.com>
 <3e429001-020a-748b-c0c5-85b4091599a1@profihost.ag>
 <57ECBAE7.5030807@cn.fujitsu.com>
 <0e556b63-7c85-1e97-00b0-91bfca44e82c@profihost.ag>
 <57ECBF0D.3050609@cn.fujitsu.com>
 <85f85ca6-95c0-1394-9b09-93dcc00c2319@profihost.ag>
 <57F5BF26.9090409@cn.fujitsu.com>
 <23f37454-e24e-5e50-b5dc-99d16c324686@profihost.ag>
 <57F74BF3.9070802@cn.fujitsu.com>
 <fd198a26-2330-3965-94c4-cca0d08a55d8@profihost.ag>
 <57F757AB.4010609@cn.fujitsu.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <e906d5e4-aca8-a9bb-b5f5-697767a2d38d@profihost.ag>
Date: Fri, 7 Oct 2016 10:16:36 +0200
MIME-Version: 1.0
In-Reply-To: <57F757AB.4010609@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 07.10.2016 um 10:07 schrieb Wang Xiaoguang:
> hello,
> 
> On 10/07/2016 04:06 PM, Stefan Priebe - Profihost AG wrote:
>> and it shows:
>>
>> PAG | scan 33829e5  | steal 1968e3  | stall      0  |              |
>>            |               |  swin  257071 |  swout 346960 |
>>
>> but the highest user space prog uses only 190MB.
> If you don't apply my patches, there will be no OOMs in your test
> environment?
> I want to confirm whether this OOM is caused by my patches...

This happens also without your patches. That's what i meant with can't
use v4.8.0.

Is it OK to try v4.7.6?

Greets,
Stefan

> 
> Regards,
> Xiaoguang Wang
> 
>>
>> greets,
>> Stefan
>>
>> Am 07.10.2016 um 09:17 schrieb Wang Xiaoguang:
>>> Hi,
>>>
>>> On 10/07/2016 03:03 PM, Stefan Priebe - Profihost AG wrote:
>>>> Dear Wang,
>>>>
>>>> can't use v4.8.0 as i always get OOMs and total machine crashes.
>>>>
>>>> Complete traces with your patch and some more btrfs patches applied (in
>>>> the hope in fixes the OOM but it did not):
>>>> http://pastebin.com/raw/6vmRSDm1
>>> I didn't see any such OOMs...
>>> Can you try holger's tree with my patches.
>>>
>>> Regards,
>>> Xiaoguang Wang
>>>> Greets,
>>>> Stefan
>>>> Am 06.10.2016 um 05:04 schrieb Wang Xiaoguang:
>>>>> Hi,
>>>>>
>>>>> On 09/29/2016 03:27 PM, Stefan Priebe - Profihost AG wrote:
>>>>>> Am 29.09.2016 um 09:13 schrieb Wang Xiaoguang:
>>>>>>>>> I found that compress sometime report ENOSPC error even in
>>>>>>>>> 4.8-rc8,
>>>>>>>>> currently
>>>>>>>> I cannot confirm that as i do not have anough space to test this
>>>>>>>> without
>>>>>>>> compression ;-( But yes i've compression enabled.
>>>>>>> I might not get you, my poor english :)
>>>>>>> You mean that you only get ENOSPC error when compression is enabled?
>>>>>>>
>>>>>>> And when compression is not enabled, you do not get ENOSPC error?
>>>>>> I can't tell you. I cannot test with compression not enabled. I do
>>>>>> not
>>>>>> have anough free space on this disk.
>>>>> I had just sent two patches to fix false enospc error for compression,
>>>>> please have a try, they fix false enospc error in my test environment.
>>>>>           btrfs: fix false enospc for compression
>>>>>           btrfs: improve inode's outstanding_extents computation
>>>>>
>>>>> I apply these two patchs in linux upstream tree, the latest commit
>>>>> is 41844e36206be90cd4d962ea49b0abc3612a99d0.
>>>>>
>>>>> Regards,
>>>>> Xiaoguang Wang
>>>>>
>>>>>>>>> I'm trying to fix it.
>>>>>>>> That sounds good but do you also get the
>>>>>>>> BTRFS: space_info 4 has 18446742286429913088 free, is not full
>>>>>>>>
>>>>>>>> kernel messages on umount? if not you might have found another
>>>>>>>> problem.
>>>>>>> Yes, I seem similar messages, you can paste you whole dmesg info
>>>>>>> here.
>>>>>> ------------[ cut here ]------------
>>>>>> WARNING: CPU: 2 PID: 5187 at fs/btrfs/extent-tree.c:5790
>>>>>> btrfs_free_block_groups+0x346/0x430 [btrfs]()
>>>>>> Modules linked in: netconsole xt_multiport iptable_filter ip_tables
>>>>>> x_tables 8021q garp bonding x86_pkg_temp_thermal coretemp
>>>>>> kvm_intel kvm
>>>>>> irqbypass sb_edac crc32_pclmul edac_core i2c_i801 i40e(O) vxlan
>>>>>> ip6_udp_tunnel udp_tunnel shpchp ipmi_si ipmi_msghandler button loop
>>>>>> btrfs dm_mod raid10 raid0 multipath linear raid456 async_raid6_recov
>>>>>> async_memcpy async_pq async_xor async_tx xor raid6_pq igb
>>>>>> i2c_algo_bit
>>>>>> i2c_core usbhid raid1 md_mod xhci_pci sg ehci_pci xhci_hcd ehci_hcd
>>>>>> sd_mod ahci usbcore ptp libahci usb_common pps_core aacraid
>>>>>> CPU: 2 PID: 5187 Comm: umount Tainted: G O 4.4.22+63-ph #1
>>>>>> Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0 12/17/2015
>>>>>> 0000000000000000 ffff880fda777d00 ffffffff813b69c3 0000000000000000
>>>>>> ffffffffc067a099 ffff880fda777d38 ffffffff810821c6 0000000000000000
>>>>>> ffff880074bf0a00 ffff88103c10c088 ffff88103c10c000 ffff88103c10c098
>>>>>> Call Trace:
>>>>>> [<ffffffff813b69c3>] dump_stack+0x63/0x90
>>>>>> [<ffffffff810821c6>] warn_slowpath_common+0x86/0xc0
>>>>>> [<ffffffff810822ba>] warn_slowpath_null+0x1a/0x20
>>>>>> [<ffffffffc05de9a6>] btrfs_free_block_groups+0x346/0x430 [btrfs]
>>>>>> [<ffffffffc05f0bad>] close_ctree+0x15d/0x330 [btrfs]
>>>>>> [<ffffffffc05bf409>] btrfs_put_super+0x19/0x20 [btrfs]
>>>>>> [<ffffffff811c85af>] generic_shutdown_super+0x6f/0x100
>>>>>> [<ffffffff811c8652>] kill_anon_super+0x12/0x20
>>>>>> [<ffffffffc05c0376>] btrfs_kill_super+0x16/0xa0 [btrfs]
>>>>>> [<ffffffff811c7ff3>] deactivate_locked_super+0x43/0x70
>>>>>> [<ffffffff811c807c>] deactivate_super+0x5c/0x60
>>>>>> [<ffffffff811e3b5f>] cleanup_mnt+0x3f/0x90
>>>>>> [<ffffffff811e3bf2>] __cleanup_mnt+0x12/0x20
>>>>>> [<ffffffff8109dad1>] task_work_run+0x81/0xa0
>>>>>> [<ffffffff810021c0>] exit_to_usermode_loop+0xb0/0xc0
>>>>>> [<ffffffff81002b44>] syscall_return_slowpath+0xd4/0x130
>>>>>> [<ffffffff8169dc0c>] int_ret_from_sys_call+0x25/0x8f
>>>>>> ---[ end trace cee6ace13018e13e ]---
>>>>>> ------------[ cut here ]------------
>>>>>> WARNING: CPU: 2 PID: 5187 at fs/btrfs/extent-tree.c:5791
>>>>>> btrfs_free_block_groups+0x365/0x430 [btrfs]()
>>>>>> Modules linked in: netconsole xt_multiport iptable_filter ip_tables
>>>>>> x_tables 8021q garp bonding x86_pkg_temp_thermal coretemp
>>>>>> kvm_intel kvm
>>>>>> irqbypass sb_edac crc32_pclmul edac_core i2c_i801 i40e(O) vxlan
>>>>>> ip6_udp_tunnel udp_tunnel shpchp ipmi_si ipmi_msghandler button loop
>>>>>> btrfs dm_mod raid10 raid0 multipath linear raid456 async_raid6_recov
>>>>>> async_memcpy async_pq async_xor async_tx xor raid6_pq igb
>>>>>> i2c_algo_bit
>>>>>> i2c_core usbhid raid1 md_mod xhci_pci sg ehci_pci xhci_hcd ehci_hcd
>>>>>> sd_mod ahci usbcore ptp libahci usb_common pps_core aacraid
>>>>>> CPU: 2 PID: 5187 Comm: umount Tainted: G W O 4.4.22+63-ph #1
>>>>>> Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0 12/17/2015
>>>>>> 0000000000000000 ffff880fda777d00 ffffffff813b69c3 0000000000000000
>>>>>> ffffffffc067a099 ffff880fda777d38 ffffffff810821c6 0000000000000000
>>>>>> ffff880074bf0a00 ffff88103c10c088 ffff88103c10c000 ffff88103c10c098
>>>>>> Call Trace:
>>>>>> [<ffffffff813b69c3>] dump_stack+0x63/0x90
>>>>>> [<ffffffff810821c6>] warn_slowpath_common+0x86/0xc0
>>>>>> [<ffffffff810822ba>] warn_slowpath_null+0x1a/0x20
>>>>>> [<ffffffffc05de9c5>] btrfs_free_block_groups+0x365/0x430 [btrfs]
>>>>>> [<ffffffffc05f0bad>] close_ctree+0x15d/0x330 [btrfs]
>>>>>> [<ffffffffc05bf409>] btrfs_put_super+0x19/0x20 [btrfs]
>>>>>> [<ffffffff811c85af>] generic_shutdown_super+0x6f/0x100
>>>>>> [<ffffffff811c8652>] kill_anon_super+0x12/0x20
>>>>>> [<ffffffffc05c0376>] btrfs_kill_super+0x16/0xa0 [btrfs]
>>>>>> [<ffffffff811c7ff3>] deactivate_locked_super+0x43/0x70
>>>>>> [<ffffffff811c807c>] deactivate_super+0x5c/0x60
>>>>>> [<ffffffff811e3b5f>] cleanup_mnt+0x3f/0x90
>>>>>> [<ffffffff811e3bf2>] __cleanup_mnt+0x12/0x20
>>>>>> [<ffffffff8109dad1>] task_work_run+0x81/0xa0
>>>>>> [<ffffffff810021c0>] exit_to_usermode_loop+0xb0/0xc0
>>>>>> [<ffffffff81002b44>] syscall_return_slowpath+0xd4/0x130
>>>>>> [<ffffffff8169dc0c>] int_ret_from_sys_call+0x25/0x8f
>>>>>> ---[ end trace cee6ace13018e13f ]---
>>>>>> ------------[ cut here ]------------
>>>>>> WARNING: CPU: 2 PID: 5187 at fs/btrfs/extent-tree.c:10151
>>>>>> btrfs_free_block_groups+0x291/0x430 [btrfs]()
>>>>>> Modules linked in: netconsole xt_multiport iptable_filter ip_tables
>>>>>> x_tables 8021q garp bonding x86_pkg_temp_thermal coretemp
>>>>>> kvm_intel kvm
>>>>>> irqbypass sb_edac crc32_pclmul edac_core i2c_i801 i40e(O) vxlan
>>>>>> ip6_udp_tunnel udp_tunnel shpchp ipmi_si ipmi_msghandler button loop
>>>>>> btrfs dm_mod raid10 raid0 multipath linear raid456 async_raid6_recov
>>>>>> async_memcpy async_pq async_xor async_tx xor raid6_pq igb
>>>>>> i2c_algo_bit
>>>>>> i2c_core usbhid raid1 md_mod xhci_pci sg ehci_pci xhci_hcd ehci_hcd
>>>>>> sd_mod ahci usbcore ptp libahci usb_common pps_core aacraid
>>>>>> CPU: 2 PID: 5187 Comm: umount Tainted: G W O 4.4.22+63-ph #1
>>>>>> Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0 12/17/2015
>>>>>> 0000000000000000 ffff880fda777d00 ffffffff813b69c3 0000000000000000
>>>>>> ffffffffc067a099 ffff880fda777d38 ffffffff810821c6 ffff880074bf0000
>>>>>> ffff880074bf0088 ffff880074bf0df8 ffff88103c10c000 0000000000000000
>>>>>> Call Trace:
>>>>>> [<ffffffff813b69c3>] dump_stack+0x63/0x90
>>>>>> [<ffffffff810821c6>] warn_slowpath_common+0x86/0xc0
>>>>>> [<ffffffff810822ba>] warn_slowpath_null+0x1a/0x20
>>>>>> [<ffffffffc05de8f1>] btrfs_free_block_groups+0x291/0x430 [btrfs]
>>>>>> [<ffffffffc05f0bad>] close_ctree+0x15d/0x330 [btrfs]
>>>>>> [<ffffffffc05bf409>] btrfs_put_super+0x19/0x20 [btrfs]
>>>>>> [<ffffffff811c85af>] generic_shutdown_super+0x6f/0x100
>>>>>> [<ffffffff811c8652>] kill_anon_super+0x12/0x20
>>>>>> [<ffffffffc05c0376>] btrfs_kill_super+0x16/0xa0 [btrfs]
>>>>>> [<ffffffff811c7ff3>] deactivate_locked_super+0x43/0x70
>>>>>> [<ffffffff811c807c>] deactivate_super+0x5c/0x60
>>>>>> [<ffffffff811e3b5f>] cleanup_mnt+0x3f/0x90
>>>>>> [<ffffffff811e3bf2>] __cleanup_mnt+0x12/0x20
>>>>>> [<ffffffff8109dad1>] task_work_run+0x81/0xa0
>>>>>> [<ffffffff810021c0>] exit_to_usermode_loop+0xb0/0xc0
>>>>>> [<ffffffff81002b44>] syscall_return_slowpath+0xd4/0x130
>>>>>> [<ffffffff8169dc0c>] int_ret_from_sys_call+0x25/0x8f
>>>>>> ---[ end trace cee6ace13018e140 ]---
>>>>>> BTRFS: space_info 4 has 18446742182612910080 free, is not full
>>>>>> BTRFS: space_info total=82678120448, used=64784695296, pinned=0,
>>>>>> reserved=0, may_use=1908990066688, readonly=0
>>>>>>
>>>>>> Greets,
>>>>>> Stefan
>>>>>>
>>>>>>> Regards,
>>>>>>> Xiaoguang Wang
>>>>>>>
>>>>>>>> Stefan
>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>> Xiaoguang Wang
>>>>>>>>>
>>>>>>>>>> I tried hard to reproduce it but i can't get it to reproduce
>>>>>>>>>> with a
>>>>>>>>>> test
>>>>>>>>>> script. Any ideas?
>>>>>>>>>>
>>>>>>>>>> Stefan
>>>>>>>>>>
>>>>>>>>>>> Reagrds,
>>>>>>>>>>> Xiaoguang Wang
>>>>>>>>>>>
>>>>>>>>>>>> Greets,
>>>>>>>>>>>> Stefan
>>>>>>>>>>>>
>>>>>>>>>>>>> Regards,
>>>>>>>>>>>>> Xiaoguang Wang
>>>>>>>>>>>>>> Greets,
>>>>>>>>>>>>>> Stefan
>>>>>>>>>>>>>> -- 
>>>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>>>>>>> linux-btrfs" in
>>>>>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>>>>>> More majordomo info at
>>>>>>>>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>
>>>
>>>
>>
> 
> 
> 
