Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:57363 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967493AbaLLOhJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 09:37:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 12 Dec 2014 15:37:06 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
In-Reply-To: <438e043f73392614d1453892b7fe225c@admin.virtall.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
 <542EE83D.8050701@fb.com>
 <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
 <438e043f73392614d1453892b7fe225c@admin.virtall.com>
Message-ID: <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI, still seeing this with 3.18 (scrub passes fine on this filesystem).

# time btrfs balance start /mnt/lxc2
Segmentation fault

real    322m32.153s
user    0m0.000s
sys     16m0.930s


[20182.461873] BTRFS info (device sdd1): relocating block group 
6915027369984 flags 17
[20194.050641] BTRFS info (device sdd1): found 4819 extents
[20286.243576] BTRFS info (device sdd1): found 4819 extents
[20287.143471] BTRFS info (device sdd1): relocating block group 
6468350771200 flags 17
[20295.756934] BTRFS info (device sdd1): found 3613 extents
[20306.981773] BTRFS (device sdd1): parent transid verify failed on 
5568935395328 wanted 70315 found 102416
[20306.983962] BTRFS (device sdd1): parent transid verify failed on 
5568935395328 wanted 70315 found 102416
[20307.029841] BTRFS (device sdd1): parent transid verify failed on 
5568935395328 wanted 70315 found 102416
[20307.030037] ------------[ cut here ]------------
[20307.030083] kernel BUG at fs/btrfs/relocation.c:242!
[20307.030130] invalid opcode: 0000 [#1] SMP
[20307.030175] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat 
nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave cpufreq_stats nfsd auth_rpcgss oid_registry exportfs 
nfs_acl nfs lockd grace fscache sunrpc ipv6 btrfs xor raid6_pq 
zlib_deflate coretemp hwmon loop pcspkr i2c_i801 i2c_core lpc_ich 
mfd_core 8250_fintek battery parport_pc parport tpm_infineon tpm_tis tpm 
ehci_pci ehci_hcd video button acpi_cpufreq ext4 crc16 jbd2 mbcache 
raid1 sg sd_mod r8169 mii ahci libahci libata scsi_mod
[20307.030587] CPU: 3 PID: 4218 Comm: btrfs Not tainted 3.18.0 #1
[20307.030634] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[20307.030724] task: ffff8807f2cac830 ti: ffff8807e9198000 task.ti: 
ffff8807e9198000
[20307.030811] RIP: 0010:[<ffffffffa02e8240>]  [<ffffffffa02e8240>] 
relocate_block_group+0x432/0x4de [btrfs]
[20307.030914] RSP: 0018:ffff8807e919bb18  EFLAGS: 00010202
[20307.030960] RAX: ffff8805f06c40f8 RBX: ffff8805f06c4000 RCX: 
0000000180200003
[20307.031008] RDX: ffff8805f06c40d8 RSI: ffff8805f06c40e8 RDI: 
ffff8807ff403900
[20307.031056] RBP: ffff8807e919bb88 R08: 0000000000000001 R09: 
0000000000000000
[20307.031105] R10: 0000000000000003 R11: ffffffffa02e43a6 R12: 
ffff8807e637f090
[20307.031153] R13: ffff8805f06c4108 R14: 00000000fffffff4 R15: 
ffff8805f06c4020
[20307.031201] FS:  00007f1bdb4ba880(0000) GS:ffff88081fac0000(0000) 
knlGS:0000000000000000
[20307.031289] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[20307.031336] CR2: 00007f5672e18070 CR3: 00000007e99cc000 CR4: 
00000000001407e0
[20307.031384] Stack:
[20307.031426]  ffffea0016296680 ffff8805f06c40e8 ffffea0016296380 
0000000000000000
[20307.031515]  ffffea0016296400 00ffea0016296440 a8000005e22b2a30 
0000000000001000
[20307.031604]  ffff8804d86963f0 ffff8805f06c4000 0000000000000000 
ffff8807f2d785a8
[20307.031693] Call Trace:
[20307.031743]  [<ffffffffa02e8444>] 
btrfs_relocate_block_group+0x158/0x278 [btrfs]
[20307.031838]  [<ffffffffa02c5fd4>] 
btrfs_relocate_chunk.isra.70+0x35/0xa5 [btrfs]
[20307.031931]  [<ffffffffa02c75d4>] btrfs_balance+0xa66/0xc6b [btrfs]
[20307.031981]  [<ffffffff810bd63a>] ? 
__alloc_pages_nodemask+0x137/0x702
[20307.032036]  [<ffffffffa02cd485>] btrfs_ioctl_balance+0x220/0x29f 
[btrfs]
[20307.032089]  [<ffffffffa02d2586>] btrfs_ioctl+0x1134/0x22f6 [btrfs]
[20307.032138]  [<ffffffff810d5d83>] ? handle_mm_fault+0x44d/0xa00
[20307.032186]  [<ffffffff81175862>] ? avc_has_perm+0x2e/0xf7
[20307.032234]  [<ffffffff810d889d>] ? __vm_enough_memory+0x25/0x13c
[20307.032282]  [<ffffffff8110f05d>] do_vfs_ioctl+0x3f2/0x43c
[20307.032329]  [<ffffffff8110f0f5>] SyS_ioctl+0x4e/0x7d
[20307.032376]  [<ffffffff81030ab3>] ? do_page_fault+0xc/0x11
[20307.032424]  [<ffffffff813b5992>] system_call_fastpath+0x12/0x17
[20307.032488] Code: 00 00 00 48 39 83 f8 00 00 00 74 02 0f 0b 4c 39 ab 
08 01 00 00 74 02 0f 0b 48 83 7b 20 00 74 02 0f 0b 83 bb 20 01 00 00 00 
74 02 <0f> 0b 83 bb 24 01 00 00 00 74 02 0f 0b 48 8b 73 18 48 8b 7b 08
[20307.032660] RIP  [<ffffffffa02e8240>] 
relocate_block_group+0x432/0x4de [btrfs]
[20307.032754]  RSP <ffff8807e919bb18>
[20307.033068] ---[ end trace 18be77360e49d59d ]---



On 2014-11-25 23:33, Tomasz Chmielewski wrote:
> I'm still seeing this when running balance with 3.18-rc6:
> 
> [95334.066898] BTRFS info (device sdd1): relocating block group
> 6468350771200 flags 17
> [95344.384279] BTRFS info (device sdd1): found 5371 extents
> [95373.555640] BTRFS (device sdd1): parent transid verify failed on
> 5568935395328 wanted 70315 found 89269
> [95373.574208] BTRFS (device sdd1): parent transid verify failed on
> 5568935395328 wanted 70315 found 89269
> [95373.574483] ------------[ cut here ]------------
> [95373.574542] kernel BUG at fs/btrfs/relocation.c:242!
> [95373.574601] invalid opcode: 0000 [#1] SMP
> [95373.574661] Modules linked in: ipt_MASQUERADE
> nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
> nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand
> cpufreq_conservative cpufreq_powersave cpufreq_stats nfsd auth_rpcgss
> oid_registry exportfs nfs_acl nfs lockd grace fscache sunrpc ipv6
> btrfs xor raid6_pq zlib_deflate coretemp hwmon loop pcspkr i2c_i801
> i2c_core battery tpm_infineon tpm_tis tpm 8250_fintek video parport_pc
> parport ehci_pci lpc_ich ehci_hcd mfd_core button acpi_cpufreq ext4
> crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169
> mii
> [95373.576506] CPU: 1 PID: 6089 Comm: btrfs Not tainted 3.18.0-rc6 #1
> [95373.576568] Hardware name: System manufacturer System Product
> Name/P8H77-M PRO, BIOS 1101 02/04/2013
> [95373.576683] task: ffff8807e9b91810 ti: ffff8807da1b8000 task.ti:
> ffff8807da1b8000
> [95373.576794] RIP: 0010:[<ffffffffa0323144>]  [<ffffffffa0323144>]
> relocate_block_group+0x432/0x4de [btrfs]
> [95373.576933] RSP: 0018:ffff8807da1bbb18  EFLAGS: 00010202
> [95373.576993] RAX: ffff8806327a70f8 RBX: ffff8806327a7000 RCX: 
> 0000000180200000
> [95373.577056] RDX: ffff8806327a70d8 RSI: ffff8806327a70e8 RDI: 
> ffff8807ff403900
> [95373.577118] RBP: ffff8807da1bbb88 R08: 0000000000000001 R09: 
> 0000000000000000
> [95373.577181] R10: 0000000000000003 R11: ffffffffa031f2aa R12: 
> ffff8804601de5a0
> [95373.577243] R13: ffff8806327a7108 R14: 00000000fffffff4 R15: 
> ffff8806327a7020
> [95373.577307] FS:  00007f9ccfa99840(0000) GS:ffff88081fa40000(0000)
> knlGS:0000000000000000
> [95373.577418] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [95373.577479] CR2: 00007f98c4133000 CR3: 00000007dd7bf000 CR4: 
> 00000000001407e0
> [95373.577540] Stack:
> [95373.577594]  ffffea0004962e80 ffff8806327a70e8 ffffea000c7fdb80
> 0000000000000000
> [95373.577708]  ffffea000d289600 00ffea000d289640 a8000005e22b2a30
> 0000000000001000
> [95373.577822]  ffff8802eb7b0240 ffff8806327a7000 0000000000000000
> ffff8807f3b5a5a8
> [95373.577937] Call Trace:
> [95373.578009]  [<ffffffffa0323348>]
> btrfs_relocate_block_group+0x158/0x278 [btrfs]
> [95373.578137]  [<ffffffffa0300fd4>]
> btrfs_relocate_chunk.isra.70+0x35/0xa5 [btrfs]
> [95373.578263]  [<ffffffffa03025d4>] btrfs_balance+0xa66/0xc6b [btrfs]
> [95373.578329]  [<ffffffff810bd63a>] ? 
> __alloc_pages_nodemask+0x137/0x702
> [95373.578407]  [<ffffffffa0308485>] btrfs_ioctl_balance+0x220/0x29f 
> [btrfs]
> [95373.578483]  [<ffffffffa030d586>] btrfs_ioctl+0x1134/0x22f6 [btrfs]
> [95373.578547]  [<ffffffff810d5d90>] ? handle_mm_fault+0x44d/0xa00
> [95373.578610]  [<ffffffff81175856>] ? avc_has_perm+0x2e/0xf7
> [95373.578672]  [<ffffffff810d88a9>] ? __vm_enough_memory+0x25/0x13c
> [95373.578736]  [<ffffffff8110f05d>] do_vfs_ioctl+0x3f2/0x43c
> [95373.578798]  [<ffffffff8110f0f5>] SyS_ioctl+0x4e/0x7d
> [95373.578859]  [<ffffffff81030ab3>] ? do_page_fault+0xc/0x11
> [95373.578920]  [<ffffffff813b58d2>] system_call_fastpath+0x12/0x17
> [95373.578981] Code: 00 00 00 48 39 83 f8 00 00 00 74 02 0f 0b 4c 39
> ab 08 01 00 00 74 02 0f 0b 48 83 7b 20 00 74 02 0f 0b 83 bb 20 01 00
> 00 00 74 02 <0f> 0b 83 bb 24 01 00 00 00 74 02 0f 0b 48 8b 73 18 48 8b
> 7b 08
> [95373.579226] RIP  [<ffffffffa0323144>]
> relocate_block_group+0x432/0x4de [btrfs]
> [95373.579352]  RSP <ffff8807da1bbb18>
> 
> 
> 
> 
> On 2014-10-04 00:06, Tomasz Chmielewski wrote:
>> On 2014-10-03 20:17 (Fri), Josef Bacik wrote:
>>> On 10/02/2014 03:27 AM, Tomasz Chmielewski wrote:
>>>> Got this when running balance with 3.17.0-rc7:
>>>> 
>>> 
>>> Give these two patches a try
>>> 
>>> https://patchwork.kernel.org/patch/4938281/
>>> https://patchwork.kernel.org/patch/4939761/
>> 
>> With these two patches applied on top of 3.13-rc7, it BUGs somewhere 
>> else now:
>> 
>> [ 2030.858792] BTRFS info (device sdd1): relocating block group
>> 6469424513024 flags 17
>> [ 2039.674077] BTRFS info (device sdd1): found 20937 extents
>> [ 2066.726661] BTRFS info (device sdd1): found 20937 extents
>> [ 2068.048208] BTRFS info (device sdd1): relocating block group
>> 6468350771200 flags 17
>> [ 2080.796412] BTRFS info (device sdd1): found 46927 extents
>> [ 2092.703850] parent transid verify failed on 5568935395328 wanted
>> 70315 found 71183
>> [ 2092.714622] parent transid verify failed on 5568935395328 wanted
>> 70315 found 71183
>> [ 2092.725269] parent transid verify failed on 5568935395328 wanted
>> 70315 found 71183
>> [ 2092.725680] ------------[ cut here ]------------
>> [ 2092.725740] kernel BUG at fs/btrfs/relocation.c:242!
>> [ 2092.725800] invalid opcode: 0000 [#1] SMP
>> [ 2092.725860] Modules linked in: ipt_MASQUERADE iptable_nat
>> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
>> ip_tables x_tables cpufreq_ondemand cpufreq_conservative
>> cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq
>> zlib_deflate coretemp hwmon loop i2c_i801 parport_pc pcspkr i2c_core
>> parport video battery tpm_infineon tpm_tis tpm lpc_ich mfd_core
>> ehci_pci ehci_hcd acpi_cpufreq button ext4 crc16 jbd2 mbcache raid1 sg
>> sd_mod ahci libahci libata scsi_mod r8169 mii
>> [ 2092.727740] CPU: 3 PID: 3937 Comm: btrfs Not tainted 3.17.0-rc7 #3
>> [ 2092.727801] Hardware name: System manufacturer System Product
>> Name/P8H77-M PRO, BIOS 1101 02/04/2013
>> [ 2092.727917] task: ffff8800c7883020 ti: ffff8800c7d04000 task.ti:
>> ffff8800c7d04000
>> [ 2092.728029] RIP: 0010:[<ffffffffa0322a4a>]  [<ffffffffa0322a4a>]
>> relocate_block_group+0x432/0x4de [btrfs]
>> [ 2092.728169] RSP: 0018:ffff8800c7d07a58  EFLAGS: 00010206
>> [ 2092.728229] RAX: ffff8806c69a18f8 RBX: ffff8806c69a1800 RCX: 
>> 0000000180200000
>> [ 2092.728292] RDX: ffff8806c69a18d8 RSI: ffff8806c69a18e8 RDI: 
>> ffff8807ff403900
>> [ 2092.728356] RBP: ffff8800c7d07ac8 R08: 0000000000000001 R09: 
>> 0000000000000000
>> [ 2092.728419] R10: 0000000000000003 R11: ffffffffa031eb54 R12: 
>> ffff8805d515c240
>> [ 2092.728482] R13: ffff8806c69a1908 R14: 00000000fffffff4 R15: 
>> ffff8806c69a1820
>> [ 2092.728546] FS:  00007f4f251d0840(0000) GS:ffff88081fac0000(0000)
>> knlGS:0000000000000000
>> [ 2092.728660] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 2092.728721] CR2: ffffffffff600400 CR3: 00000000c7fb0000 CR4: 
>> 00000000001407e0
>> [ 2092.728783] Stack:
>> [ 2092.728837]  ffffea0002edf300 ffff8806c69a18e8 ffffea0002edf000
>> 0000000000000000
>> [ 2092.728952]  ffffea0002edf080 00ffea0002edf0c0 a8000005e22b2a30
>> 0000000000001000
>> [ 2092.729067]  ffff8807d969f870 ffff8806c69a1800 0000000000000000
>> ffff8807f3f285b0
>> [ 2092.729183] Call Trace:
>> [ 2092.729256]  [<ffffffffa0322c4e>]
>> btrfs_relocate_block_group+0x158/0x278 [btrfs]
>> [ 2092.729385]  [<ffffffffa02ff79c>]
>> btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
>> [ 2092.729512]  [<ffffffffa030e99f>] ?
>> btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
>> [ 2092.729632]  [<ffffffffa02bfb04>] ? 
>> btrfs_set_path_blocking+0x23/0x54 [btrfs]
>> [ 2092.729704]  [<ffffffffa02c4517>] ? btrfs_search_slot+0x7bc/0x816 
>> [btrfs]
>> [ 2092.729782]  [<ffffffffa02fbc81>] ? free_extent_buffer+0x6f/0x7c 
>> [btrfs]
>> [ 2092.729859]  [<ffffffffa0302679>] btrfs_balance+0xa7b/0xc80 [btrfs]
>> [ 2092.729935]  [<ffffffffa0308177>] btrfs_ioctl_balance+0x220/0x29f 
>> [btrfs]
>> [ 2092.730012]  [<ffffffffa030d1e4>] btrfs_ioctl+0x10bd/0x2281 [btrfs]
>> [ 2092.730076]  [<ffffffff810d5152>] ? handle_mm_fault+0x44d/0xa00
>> [ 2092.730140]  [<ffffffff81173e76>] ? avc_has_perm+0x2e/0xf7
>> [ 2092.730202]  [<ffffffff810d7c6d>] ? __vm_enough_memory+0x25/0x13c
>> [ 2092.730266]  [<ffffffff8110d72d>] do_vfs_ioctl+0x3f2/0x43c
>> [ 2092.730328]  [<ffffffff8110d7c5>] SyS_ioctl+0x4e/0x7d
>> [ 2092.730389]  [<ffffffff81030a71>] ? do_page_fault+0xc/0xf
>> [ 2092.730452]  [<ffffffff813b0652>] system_call_fastpath+0x16/0x1b
>> [ 2092.730512] Code: 00 00 00 48 39 83 f8 00 00 00 74 02 0f 0b 4c 39
>> ab 08 01 00 00 74 02 0f 0b 48 83 7b 20 00 74 02 0f 0b 83 bb 20 01 00
>> 00 00 74 02 <0f> 0b 83 bb 24 01 00 00 00 74 02 0f 0b 48 8b 73 18 48 8b
>> 7b 08
>> [ 2092.730759] RIP  [<ffffffffa0322a4a>]
>> relocate_block_group+0x432/0x4de [btrfs]
>> [ 2092.730885]  RSP <ffff8800c7d07a58>
>> [ 2092.731233] ---[ end trace 16c7709ebf2c379c ]---
> 
> Tomasz Chmielewski
> http://www.sslrack.com
