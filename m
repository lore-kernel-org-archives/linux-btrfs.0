Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:49813 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932609AbcH2OCi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 10:02:38 -0400
Subject: Re: memory overflow or undeflow in free space tree / space_info?
To: Josef Bacik <jbacik@fb.com>, Omar Sandoval <osandov@osandov.com>
References: <229a1d13-32f1-cd4c-975f-2db6796eb6c7@profihost.ag>
 <20160729191153.GA28505@vader> <20160729191459.GB28505@vader>
 <40a46d57-fe32-e745-9897-8f5c6ca2b33e@fb.com>
 <6c131d33-af2e-61ae-00ed-f65ac35607c2@profihost.ag>
 <265340a5-12d5-f8a0-974f-b0de69b3b243@profihost.ag>
 <5353cc8a-4cdc-165f-2c86-f810148661f1@profihost.ag>
 <c02184e1-4af1-eada-6493-b3f1fc222642@profihost.ag>
 <f519e736-09d3-9dfd-9724-52ab88f13106@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <1425446f-f1d1-136b-893b-a1a99e6af3a3@profihost.ag>
Date: Mon, 29 Aug 2016 16:02:35 +0200
MIME-Version: 1.0
In-Reply-To: <f519e736-09d3-9dfd-9724-52ab88f13106@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

this still hapens with current 4.8-rc* releases. Anything i can do to
debug this? May be insert some code to check for an under or overflow in
the code?

Stefan

Am 14.08.2016 um 17:22 schrieb Stefan Priebe - Profihost AG:
> Hi Josef,
> 
> anything i could do or test? Results with a vanilla next branch are the
> same.
> 
> Stefan
> 
> Am 11.08.2016 um 08:09 schrieb Stefan Priebe - Profihost AG:
>> Hello,
>>
>> the backtrace and info on umount looks the same:
>>
>> [241910.341124] ------------[ cut here ]------------
>> [241910.379991] WARNING: CPU: 1 PID: 26664 at
>> fs/btrfs/extent-tree.c:5701 btrfs_free_block_groups+0x370/0x410 [btrfs]
>> [241910.422099] Modules linked in: netconsole mpt3sas ipt_REJECT
>> raid_class nf_reject_ipv4 scsi_transport_sas xt_multiport 8021q garp
>> iptable_filter ip_tables x_tables bonding coretemp loop usbhid ehci_pci
>> i2c_i801 ehci_hcd usbcore i2c_core shpchp usb_common ipmi_si
>> ipmi_msghandler button btrfs dm_mod raid1 raid456 async_raid6_recov
>> async_memcpy async_pq async_xor async_tx xor raid6_pq md_mod sg sd_mod
>> ixgbe i40e mdio ptp ahci libahci pps_core megaraid_sas
>> [241910.616845] CPU: 1 PID: 26664 Comm: umount Not tainted
>> 4.7.0-rc6-29043-g8b8b08c #1
>> [241910.669646] Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c
>> 02/18/2015
>> [241910.723716]  0000000000000000 ffff8808d104bca8 ffffffffbd3d83cf
>> 0000000000000000
>> [241910.779309]  0000000000000000 ffff8808d104bcf8 ffffffffbd085615
>> ffff8808d104bd08
>> [241910.835143]  000016455a3410a8 00000047a0000000 0000000000000000
>> ffff8808469e2088
>> [241910.891882] Call Trace:
>> [241910.947624]  [<ffffffffbd3d83cf>] dump_stack+0x63/0x84
>> [241911.003714]  [<ffffffffbd085615>] __warn+0xe5/0x100
>> [241911.060167]  [<ffffffffbd08564d>] warn_slowpath_null+0x1d/0x20
>> [241911.117422]  [<ffffffffc058ca90>]
>> btrfs_free_block_groups+0x370/0x410 [btrfs]
>> [241911.175975]  [<ffffffffc059e7ab>] close_ctree+0x15b/0x330 [btrfs]
>> [241911.235170]  [<ffffffffc056f089>] btrfs_put_super+0x19/0x20 [btrfs]
>> [241911.294638]  [<ffffffffbd1deaff>] generic_shutdown_super+0x6f/0x100
>> [241911.353005]  [<ffffffffbd1df026>] kill_anon_super+0x16/0x30
>> [241911.409832]  [<ffffffffc05720fa>] btrfs_kill_super+0x1a/0xb0 [btrfs]
>> [241911.466467]  [<ffffffffbd1df1f1>] deactivate_locked_super+0x51/0x90
>> [241911.522602]  [<ffffffffbd1dfb8e>] deactivate_super+0x4e/0x70
>> [241911.577979]  [<ffffffffbd1fba73>] cleanup_mnt+0x43/0x90
>> [241911.633188]  [<ffffffffbd1fbb12>] __cleanup_mnt+0x12/0x20
>> [241911.688146]  [<ffffffffbd0a1f61>] task_work_run+0x81/0xb0
>> [241911.742740]  [<ffffffffbd07ffcd>] exit_to_usermode_loop+0x66/0x95
>> [241911.797039]  [<ffffffffbd002a7d>] do_syscall_64+0x10d/0x150
>> [241911.850750]  [<ffffffffbd6d9ca1>] entry_SYSCALL64_slow_path+0x25/0x25
>> [241911.903564] ---[ end trace fae017546778f2b0 ]---
>> [241911.955332] ------------[ cut here ]------------
>> [241912.006262] WARNING: CPU: 1 PID: 26664 at
>> fs/btrfs/extent-tree.c:5702 btrfs_free_block_groups+0x40a/0x410 [btrfs]
>> [241912.059326] Modules linked in: netconsole mpt3sas ipt_REJECT
>> raid_class nf_reject_ipv4 scsi_transport_sas xt_multiport 8021q garp
>> iptable_filter ip_tables x_tables bonding coretemp loop usbhid ehci_pci
>> i2c_i801 ehci_hcd usbcore i2c_core shpchp usb_common ipmi_si
>> ipmi_msghandler button btrfs dm_mod raid1 raid456 async_raid6_recov
>> async_memcpy async_pq async_xor async_tx xor raid6_pq md_mod sg sd_mod
>> ixgbe i40e mdio ptp ahci libahci pps_core megaraid_sas
>> [241912.298666] CPU: 1 PID: 26664 Comm: umount Tainted: G        W
>> 4.7.0-rc6-29043-g8b8b08c #1
>> [241912.363401] Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c
>> 02/18/2015
>> [241912.429395]  0000000000000000 ffff8808d104bca8 ffffffffbd3d83cf
>> 0000000000000000
>> [241912.497080]  0000000000000000 ffff8808d104bcf8 ffffffffbd085615
>> ffff8808d104bd08
>> [241912.565113]  000016465a3410a8 00000047a0000000 0000000000000000
>> ffff8808469e2088
>> [241912.634105] Call Trace:
>> [241912.702992]  [<ffffffffbd3d83cf>] dump_stack+0x63/0x84
>> [241912.773473]  [<ffffffffbd085615>] __warn+0xe5/0x100
>> [241912.844339]  [<ffffffffbd08564d>] warn_slowpath_null+0x1d/0x20
>> [241912.916083]  [<ffffffffc058cb2a>]
>> btrfs_free_block_groups+0x40a/0x410 [btrfs]
>> [241912.989103]  [<ffffffffc059e7ab>] close_ctree+0x15b/0x330 [btrfs]
>> [241913.062672]  [<ffffffffc056f089>] btrfs_put_super+0x19/0x20 [btrfs]
>> [241913.136364]  [<ffffffffbd1deaff>] generic_shutdown_super+0x6f/0x100
>> [241913.208701]  [<ffffffffbd1df026>] kill_anon_super+0x16/0x30
>> [241913.279194]  [<ffffffffc05720fa>] btrfs_kill_super+0x1a/0xb0 [btrfs]
>> [241913.348065]  [<ffffffffbd1df1f1>] deactivate_locked_super+0x51/0x90
>> [241913.415082]  [<ffffffffbd1dfb8e>] deactivate_super+0x4e/0x70
>> [241913.479841]  [<ffffffffbd1fba73>] cleanup_mnt+0x43/0x90
>> [241913.543353]  [<ffffffffbd1fbb12>] __cleanup_mnt+0x12/0x20
>> [241913.605959]  [<ffffffffbd0a1f61>] task_work_run+0x81/0xb0
>> [241913.667542]  [<ffffffffbd07ffcd>] exit_to_usermode_loop+0x66/0x95
>> [241913.729612]  [<ffffffffbd002a7d>] do_syscall_64+0x10d/0x150
>> [241913.791203]  [<ffffffffbd6d9ca1>] entry_SYSCALL64_slow_path+0x25/0x25
>> [241913.852485] ---[ end trace fae017546778f2b1 ]---
>> [241913.913638] ------------[ cut here ]------------
>> [241913.974871] WARNING: CPU: 1 PID: 26664 at
>> fs/btrfs/extent-tree.c:10013 btrfs_free_block_groups+0x2ba/0x410 [btrfs]
>> [241914.039315] Modules linked in: netconsole mpt3sas ipt_REJECT
>> raid_class nf_reject_ipv4 scsi_transport_sas xt_multiport 8021q garp
>> iptable_filter ip_tables x_tables bonding coretemp loop usbhid ehci_pci
>> i2c_i801 ehci_hcd usbcore i2c_core shpchp usb_common ipmi_si
>> ipmi_msghandler button btrfs dm_mod raid1 raid456 async_raid6_recov
>> async_memcpy async_pq async_xor async_tx xor raid6_pq md_mod sg sd_mod
>> ixgbe i40e mdio ptp ahci libahci pps_core megaraid_sas
>> [241914.315918] CPU: 1 PID: 26664 Comm: umount Tainted: G        W
>> 4.7.0-rc6-29043-g8b8b08c #1
>> [241914.388096] Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c
>> 02/18/2015
>> [241914.460679]  0000000000000000 ffff8808d104bca8 ffffffffbd3d83cf
>> 0000000000000000
>> [241914.534126]  0000000000000000 ffff8808d104bcf8 ffffffffbd085615
>> ffff8808d104bce8
>> [241914.607523]  0000271dbd3dac8c ffff88085184aac8 0000000000000038
>> 0000000000000000
>> [241914.681318] Call Trace:
>> [241914.754437]  [<ffffffffbd3d83cf>] dump_stack+0x63/0x84
>> [241914.828796]  [<ffffffffbd085615>] __warn+0xe5/0x100
>> [241914.902953]  [<ffffffffbd08564d>] warn_slowpath_null+0x1d/0x20
>> [241914.977271]  [<ffffffffc058c9da>]
>> btrfs_free_block_groups+0x2ba/0x410 [btrfs]
>> [241915.052041]  [<ffffffffc059e7ab>] close_ctree+0x15b/0x330 [btrfs]
>> [241915.126282]  [<ffffffffc056f089>] btrfs_put_super+0x19/0x20 [btrfs]
>> [241915.200758]  [<ffffffffbd1deaff>] generic_shutdown_super+0x6f/0x100
>> [241915.273872]  [<ffffffffbd1df026>] kill_anon_super+0x16/0x30
>> [241915.345132]  [<ffffffffc05720fa>] btrfs_kill_super+0x1a/0xb0 [btrfs]
>> [241915.414703]  [<ffffffffbd1df1f1>] deactivate_locked_super+0x51/0x90
>> [241915.482488]  [<ffffffffbd1dfb8e>] deactivate_super+0x4e/0x70
>> [241915.547994]  [<ffffffffbd1fba73>] cleanup_mnt+0x43/0x90
>> [241915.611962]  [<ffffffffbd1fbb12>] __cleanup_mnt+0x12/0x20
>> [241915.674717]  [<ffffffffbd0a1f61>] task_work_run+0x81/0xb0
>> [241915.736398]  [<ffffffffbd07ffcd>] exit_to_usermode_loop+0x66/0x95
>> [241915.798592]  [<ffffffffbd002a7d>] do_syscall_64+0x10d/0x150
>> [241915.860295]  [<ffffffffbd6d9ca1>] entry_SYSCALL64_slow_path+0x25/0x25
>> [241915.921642] ---[ end trace fae017546778f2b2 ]---
>> [241915.982893] BTRFS: space_info 4 has 114577997824 free, is not full
>> [241916.045103] BTRFS: space_info total=307627032576, used=193048903680,
>> pinned=0, reserved=0, may_use=688537059328, readonly=131072
>>
>> Greets,
>> Stefan
>>
>> Am 10.08.2016 um 23:31 schrieb Stefan Priebe - Profihost AG:
>>> Hi Josef,
>>>
>>> same again with chris next branch:
>>>
>>> ERROR: error during balancing '/vmbackup/': No space left on device
>>> There may be more info in syslog - try dmesg | tail
>>> Dumping filters: flags 0x7, state 0x0, force is off
>>>   DATA (flags 0x2): balancing, usage=5
>>>   METADATA (flags 0x2): balancing, usage=5
>>>   SYSTEM (flags 0x2): balancing, usage=5
>>>
>>> dmesg:
>>> [203784.411189] BTRFS info (device dm-0): 114 enospc errors during balance
>>>
>>> uname -r 4.7.0-rc6-29043-g8b8b08c
>>>
>>> Greets,
>>> Stefan
>>>
>>> Am 08.08.2016 um 08:17 schrieb Stefan Priebe - Profihost AG:
>>>> Am 04.08.2016 um 13:40 schrieb Stefan Priebe - Profihost AG:
>>>>> Am 29.07.2016 um 23:03 schrieb Josef Bacik:
>>>>>> On 07/29/2016 03:14 PM, Omar Sandoval wrote:
>>>>>>> On Fri, Jul 29, 2016 at 12:11:53PM -0700, Omar Sandoval wrote:
>>>>>>>> On Fri, Jul 29, 2016 at 08:40:26PM +0200, Stefan Priebe - Profihost
>>>>>>>> AG wrote:
>>>>>>>>> Dear list,
>>>>>>>>>
>>>>>>>>> i'm seeing btrfs no space messages frequently on big filesystems (>
>>>>>>>>> 30TB).
>>>>>>>>>
>>>>>>>>> In all cases i'm getting a trace like this one a space_info warning.
>>>>>>>>> (since commit [1]). Could someone please be so kind and help me
>>>>>>>>> debugging / fixing this bug? I'm using space_cache=v2 on all those
>>>>>>>>> systems.
>>>>>>>>
>>>>>>>> Hm, so I think this indicates a bug in space accounting somewhere else
>>>>>>>> rather than the free space tree itself. I haven't debugged one of these
>>>>>>>> issues before, I'll see if I can reproduce it. Cc'ing Josef, too.
>>>>>>>
>>>>>>> I should've asked, what sort of filesystem activity triggers this?
>>>>>>>
>>>>>>
>>>>>> Chris just fixed this I think, try his next branch from his git tree
>>>>>>
>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
>>>>>
>>>>> Thanks now running a 4.4 with those patches backported. If that still
>>>>> shows an error i will try that vanilla tree.
>>>>
>>>> OK this didn't work. I'll start / try using the linux-btrfs next branch
>>>> and look if this helps.
>>>>
>>>> Greets,
>>>> Stefan
>>>>
>>>>>
>>>>> Thanks!
>>>>>
>>>>> Stefan
>>>>>
>>>>>> and see if it still happens.  Thanks,
>>>>>>
>>>>>> Josef
