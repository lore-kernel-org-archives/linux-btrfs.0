Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:50289 "EHLO
	cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbcG2FoH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 01:44:07 -0400
Subject: Re: ENOSPC / no space on very large devices
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1659eb11-0025-d9d4-c590-2a4d721bb299@profihost.ag>
 <578F29C4.9030808@applied-asynchrony.com>
Cc: Jannik Winkel <j.winkel@profihost.ag>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <5fb0c92a-bdb1-9344-f10b-90069d6a2e1b@profihost.ag>
Date: Fri, 29 Jul 2016 07:44:02 +0200
MIME-Version: 1.0
In-Reply-To: <578F29C4.9030808@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 20.07.2016 um 09:35 schrieb Holger Hoffstätte:
> On 07/20/16 07:31, Stefan Priebe - Profihost AG wrote:
>> Hi list,
>>
>> while i didn't had the problem for some month i'm now getting ENOSPC on
>> a regular basis on one host.
> 
> Well, it's getting better. :)

Again the same problem.

> 
>> if i umount the volume i get traces (i already did a clear_cache 4 days
>> ago to recalculate the space_tree):
>>
>> [545031.675797] ------------[ cut here ]------------
>> [545031.725166] WARNING: CPU: 1 PID: 17711 at
>> fs/btrfs/extent-tree.c:5710 btrfs_free_block_groups+0x35a/0x400 [btrfs]()
> 
> This is "only" a warning, but as we can see below it indicates a real
> problem. The warning was added only recently to for-next by the patch called
> "Btrfs: warn_on for unaccounted spaces" [1], but I've had it in my tree
> forever. Never seen the warning myself.
> 
> (snip)
>> [545037.909700] BTRFS: space_info 4 has 18446743523026157568 free, is
>> not full
> 
> Wow, ~18.4 exabytes really is a lot of free space. :)
> So it looks like something underflowed the space_info and now things are
> confused for about ~550 GB. Unfortunately I have no good idea how to fix
> that. :(

umount triggered this one:
[983102.838217] ------------[ cut here ]------------
[983102.864383] WARNING: CPU: 1 PID: 483 at fs/btrfs/extent-tree.c:5710
btrfs_free_block_groups+0x35a/0x400 [btrfs]()
[983102.894424] Modules linked in: netconsole xt_multiport
iptable_filter ip_tables x_tables 8021q garp bonding usbhid coretemp
loop xhci_pci ehci_pci xhci_hcd ehci_hcd i40e(O) sb_edac vxlan
ip6_udp_tunnel usbcore ipmi_si i2c_i801 shpchp usb_common udp_tunnel
edac_core ipmi_msghandler button btrfs dm_mod raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 md_mod igb
i2c_algo_bit i2c_core sg sd_mod ptp ahci libahci pps_core aacraid
[983103.043010] CPU: 1 PID: 483 Comm: umount Tainted: G           O
4.4.15+43-ph #1
[983103.084441] Hardware name: Supermicro Super Server/X10SRi-F, BIOS
2.0 12/17/2015
[983103.127289]  0000000000000000 ffff880074673cd8 ffffffffad3c712f
0000000000000000
[983103.171816]  ffffffffc0298603 ffff880074673d18 ffffffffad0837e7
0000000b20000000
[983103.216766]  0000000000000000 ffff88103bd7e600 ffff881037c92088
ffff881037c92000
[983103.262776] Call Trace:
[983103.308602]  [<ffffffffad3c712f>] dump_stack+0x63/0x84
[983103.355609]  [<ffffffffad0837e7>] warn_slowpath_common+0x97/0xe0
[983103.403528]  [<ffffffffad08384a>] warn_slowpath_null+0x1a/0x20
[983103.451297]  [<ffffffffc01f617a>]
btrfs_free_block_groups+0x35a/0x400 [btrfs]
[983103.500439]  [<ffffffffc0207a4b>] close_ctree+0x15b/0x330 [btrfs]
[983103.548805]  [<ffffffffc01d51f9>] btrfs_put_super+0x19/0x20 [btrfs]
[983103.597122]  [<ffffffffad1cd33f>] generic_shutdown_super+0x6f/0x100
[983103.645398]  [<ffffffffad1cd866>] kill_anon_super+0x16/0x30
[983103.693384]  [<ffffffffc01db96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
[983103.742430]  [<ffffffffad1cda31>] deactivate_locked_super+0x51/0x90
[983103.791501]  [<ffffffffad1ce42e>] deactivate_super+0x4e/0x70
[983103.839979]  [<ffffffffad1e9373>] cleanup_mnt+0x43/0x90
[983103.889050]  [<ffffffffad1e9412>] __cleanup_mnt+0x12/0x20
[983103.937756]  [<ffffffffad09ef8e>] task_work_run+0x7e/0xa0
[983103.986032]  [<ffffffffad07e550>] exit_to_usermode_loop+0x66/0x95
[983104.035214]  [<ffffffffad002a56>] syscall_return_slowpath+0xa6/0xf0
[983104.084312]  [<ffffffffad6b6f4c>] int_ret_from_sys_call+0x25/0x8f
[983104.134098] ---[ end trace ca97a745adcb888f ]---
[983104.184540] ------------[ cut here ]------------
[983104.235514] WARNING: CPU: 1 PID: 483 at fs/btrfs/extent-tree.c:5711
btrfs_free_block_groups+0x3f4/0x400 [btrfs]()
[983104.290282] Modules linked in: netconsole xt_multiport
iptable_filter ip_tables x_tables 8021q garp bonding usbhid coretemp
loop xhci_pci ehci_pci xhci_hcd ehci_hcd i40e(O) sb_edac vxlan
ip6_udp_tunnel usbcore ipmi_si i2c_i801 shpchp usb_common udp_tunnel
edac_core ipmi_msghandler button btrfs dm_mod raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 md_mod igb
i2c_algo_bit i2c_core sg sd_mod ptp ahci libahci pps_core aacraid
[983104.536076] CPU: 1 PID: 483 Comm: umount Tainted: G        W  O
4.4.15+43-ph #1
[983104.601962] Hardware name: Supermicro Super Server/X10SRi-F, BIOS
2.0 12/17/2015
[983104.669312]  0000000000000000 ffff880074673cd8 ffffffffad3c712f
0000000000000000
[983104.738337]  ffffffffc0298603 ffff880074673d18 ffffffffad0837e7
0000000b20000000
[983104.807874]  0000000000000000 ffff88103bd7e600 ffff881037c92088
ffff881037c92000
[983104.878415] Call Trace:
[983104.948803]  [<ffffffffad3c712f>] dump_stack+0x63/0x84
[983105.020781]  [<ffffffffad0837e7>] warn_slowpath_common+0x97/0xe0
[983105.093734]  [<ffffffffad08384a>] warn_slowpath_null+0x1a/0x20
[983105.166888]  [<ffffffffc01f6214>]
btrfs_free_block_groups+0x3f4/0x400 [btrfs]
[983105.241461]  [<ffffffffc0207a4b>] close_ctree+0x15b/0x330 [btrfs]
[983105.316744]  [<ffffffffc01d51f9>] btrfs_put_super+0x19/0x20 [btrfs]
[983105.392021]  [<ffffffffad1cd33f>] generic_shutdown_super+0x6f/0x100
[983105.465852]  [<ffffffffad1cd866>] kill_anon_super+0x16/0x30
[983105.537829]  [<ffffffffc01db96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
[983105.608078]  [<ffffffffad1cda31>] deactivate_locked_super+0x51/0x90
[983105.676494]  [<ffffffffad1ce42e>] deactivate_super+0x4e/0x70
[983105.742614]  [<ffffffffad1e9373>] cleanup_mnt+0x43/0x90
[983105.807432]  [<ffffffffad1e9412>] __cleanup_mnt+0x12/0x20
[983105.871301]  [<ffffffffad09ef8e>] task_work_run+0x7e/0xa0
[983105.934048]  [<ffffffffad07e550>] exit_to_usermode_loop+0x66/0x95
[983105.997218]  [<ffffffffad002a56>] syscall_return_slowpath+0xa6/0xf0
[983106.060109]  [<ffffffffad6b6f4c>] int_ret_from_sys_call+0x25/0x8f
[983106.122424] ---[ end trace ca97a745adcb8890 ]---
[983106.184587] ------------[ cut here ]------------
[983106.246721] WARNING: CPU: 1 PID: 483 at fs/btrfs/extent-tree.c:9990
btrfs_free_block_groups+0x2a4/0x400 [btrfs]()
[983106.312374] Modules linked in: netconsole xt_multiport
iptable_filter ip_tables x_tables 8021q garp bonding usbhid coretemp
loop xhci_pci ehci_pci xhci_hcd ehci_hcd i40e(O) sb_edac vxlan
ip6_udp_tunnel usbcore ipmi_si i2c_i801 shpchp usb_common udp_tunnel
edac_core ipmi_msghandler button btrfs dm_mod raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 md_mod igb
i2c_algo_bit i2c_core sg sd_mod ptp ahci libahci pps_core aacraid
[983106.594248] CPU: 1 PID: 483 Comm: umount Tainted: G        W  O
4.4.15+43-ph #1
[983106.667057] Hardware name: Supermicro Super Server/X10SRi-F, BIOS
2.0 12/17/2015
[983106.740535]  0000000000000000 ffff880074673cd8 ffffffffad3c712f
0000000000000000
[983106.814853]  ffffffffc0298603 ffff880074673d18 ffffffffad0837e7
ffff88107febe4b0
[983106.889447]  0000000000000038 0000000000000000 ffff88103bd7d688
ffff881037c92000
[983106.964466] Call Trace:
[983107.038878]  [<ffffffffad3c712f>] dump_stack+0x63/0x84
[983107.114585]  [<ffffffffad0837e7>] warn_slowpath_common+0x97/0xe0
[983107.190641]  [<ffffffffad08384a>] warn_slowpath_null+0x1a/0x20
[983107.266153]  [<ffffffffc01f60c4>]
btrfs_free_block_groups+0x2a4/0x400 [btrfs]
[983107.342312]  [<ffffffffc0207a4b>] close_ctree+0x15b/0x330 [btrfs]
[983107.418075]  [<ffffffffc01d51f9>] btrfs_put_super+0x19/0x20 [btrfs]
[983107.494135]  [<ffffffffad1cd33f>] generic_shutdown_super+0x6f/0x100
[983107.568733]  [<ffffffffad1cd866>] kill_anon_super+0x16/0x30
[983107.641401]  [<ffffffffc01db96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
[983107.712357]  [<ffffffffad1cda31>] deactivate_locked_super+0x51/0x90
[983107.781493]  [<ffffffffad1ce42e>] deactivate_super+0x4e/0x70
[983107.848333]  [<ffffffffad1e9373>] cleanup_mnt+0x43/0x90
[983107.913862]  [<ffffffffad1e9412>] __cleanup_mnt+0x12/0x20
[983107.978423]  [<ffffffffad09ef8e>] task_work_run+0x7e/0xa0
[983108.041898]  [<ffffffffad07e550>] exit_to_usermode_loop+0x66/0x95
[983108.105838]  [<ffffffffad002a56>] syscall_return_slowpath+0xa6/0xf0
[983108.169494]  [<ffffffffad6b6f4c>] int_ret_from_sys_call+0x25/0x8f
[983108.232423] ---[ end trace ca97a745adcb8891 ]---
[983108.295201] BTRFS: space_info 4 has 18446741995579113472 free, is
not full
[983108.359167] BTRFS: space_info total=47781511168, used=36823171072,
pinned=0, reserved=0, may_use=2089088778240, readonly=0

> 
>> The kernel is something special - i'm using this one from holger:
>> https://github.com/hhoffstaette/kernel-patches
>>
>> which is basically a 4.4.15 + several patches especially a lot of btrfs
>> patches up to 4.8 i think.
> 
> More like for-next with all the pagesize/sectorsize stuff carefully
> avoided. I'm really looking forward to 4.8, this is becoming unwieldy..
> 
> -h
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git/commit/?h=for-next&id=d555b6c380c644af63dbdaa7cc14bba041a4e4dd
> 
