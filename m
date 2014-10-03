Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40805 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557AbaJCWJp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 18:09:45 -0400
From: Josef Bacik <jbacik@fb.com>
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.17.0-rc7: kernel BUG at fs/btrfs/relocation.c:931!
Date: Fri, 3 Oct 2014 22:09:41 +0000
Message-ID: <igsuij8fl8nu41ovutsy9bir.1412374179559@email.android.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
 <542EE83D.8050701@fb.com>,<999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
In-Reply-To: <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can you make a btrfs-image of this fs and send it to me?  Thanks,

Josef

Tomasz Chmielewski <tch@virtall.com> wrote:


On 2014-10-03 20:17 (Fri), Josef Bacik wrote:
> On 10/02/2014 03:27 AM, Tomasz Chmielewski wrote:
>> Got this when running balance with 3.17.0-rc7:
>>
>
> Give these two patches a try
>
> https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/4938281/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=zoOEeHoPSaWycUnRMebS4NI5cEnXmHt7kS4QG2us9Mk%3D%0A&s=dc71db2c3614702306e4085366f39b206c2b93859afded8030aea69d56f570f7
> https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/4939761/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=zoOEeHoPSaWycUnRMebS4NI5cEnXmHt7kS4QG2us9Mk%3D%0A&s=d9f61fcd6ba68d21f5180b30ffafed66471754728c5e46f70a2010c13ca48726

With these two patches applied on top of 3.13-rc7, it BUGs somewhere
else now:

[ 2030.858792] BTRFS info (device sdd1): relocating block group
6469424513024 flags 17
[ 2039.674077] BTRFS info (device sdd1): found 20937 extents
[ 2066.726661] BTRFS info (device sdd1): found 20937 extents
[ 2068.048208] BTRFS info (device sdd1): relocating block group
6468350771200 flags 17
[ 2080.796412] BTRFS info (device sdd1): found 46927 extents
[ 2092.703850] parent transid verify failed on 5568935395328 wanted
70315 found 71183
[ 2092.714622] parent transid verify failed on 5568935395328 wanted
70315 found 71183
[ 2092.725269] parent transid verify failed on 5568935395328 wanted
70315 found 71183
[ 2092.725680] ------------[ cut here ]------------
[ 2092.725740] kernel BUG at fs/btrfs/relocation.c:242!
[ 2092.725800] invalid opcode: 0000 [#1] SMP
[ 2092.725860] Modules linked in: ipt_MASQUERADE iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
ip_tables x_tables cpufreq_ondemand cpufreq_conservative
cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq
zlib_deflate coretemp hwmon loop i2c_i801 parport_pc pcspkr i2c_core
parport video battery tpm_infineon tpm_tis tpm lpc_ich mfd_core ehci_pci
ehci_hcd acpi_cpufreq button ext4 crc16 jbd2 mbcache raid1 sg sd_mod
ahci libahci libata scsi_mod r8169 mii
[ 2092.727740] CPU: 3 PID: 3937 Comm: btrfs Not tainted 3.17.0-rc7 #3
[ 2092.727801] Hardware name: System manufacturer System Product
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 2092.727917] task: ffff8800c7883020 ti: ffff8800c7d04000 task.ti:
ffff8800c7d04000
[ 2092.728029] RIP: 0010:[<ffffffffa0322a4a>]  [<ffffffffa0322a4a>]
relocate_block_group+0x432/0x4de [btrfs]
[ 2092.728169] RSP: 0018:ffff8800c7d07a58  EFLAGS: 00010206
[ 2092.728229] RAX: ffff8806c69a18f8 RBX: ffff8806c69a1800 RCX:
0000000180200000
[ 2092.728292] RDX: ffff8806c69a18d8 RSI: ffff8806c69a18e8 RDI:
ffff8807ff403900
[ 2092.728356] RBP: ffff8800c7d07ac8 R08: 0000000000000001 R09:
0000000000000000
[ 2092.728419] R10: 0000000000000003 R11: ffffffffa031eb54 R12:
ffff8805d515c240
[ 2092.728482] R13: ffff8806c69a1908 R14: 00000000fffffff4 R15:
ffff8806c69a1820
[ 2092.728546] FS:  00007f4f251d0840(0000) GS:ffff88081fac0000(0000)
knlGS:0000000000000000
[ 2092.728660] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2092.728721] CR2: ffffffffff600400 CR3: 00000000c7fb0000 CR4:
00000000001407e0
[ 2092.728783] Stack:
[ 2092.728837]  ffffea0002edf300 ffff8806c69a18e8 ffffea0002edf000
0000000000000000
[ 2092.728952]  ffffea0002edf080 00ffea0002edf0c0 a8000005e22b2a30
0000000000001000
[ 2092.729067]  ffff8807d969f870 ffff8806c69a1800 0000000000000000
ffff8807f3f285b0
[ 2092.729183] Call Trace:
[ 2092.729256]  [<ffffffffa0322c4e>]
btrfs_relocate_block_group+0x158/0x278 [btrfs]
[ 2092.729385]  [<ffffffffa02ff79c>]
btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
[ 2092.729512]  [<ffffffffa030e99f>] ?
btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
[ 2092.729632]  [<ffffffffa02bfb04>] ? btrfs_set_path_blocking+0x23/0x54
[btrfs]
[ 2092.729704]  [<ffffffffa02c4517>] ? btrfs_search_slot+0x7bc/0x816
[btrfs]
[ 2092.729782]  [<ffffffffa02fbc81>] ? free_extent_buffer+0x6f/0x7c
[btrfs]
[ 2092.729859]  [<ffffffffa0302679>] btrfs_balance+0xa7b/0xc80 [btrfs]
[ 2092.729935]  [<ffffffffa0308177>] btrfs_ioctl_balance+0x220/0x29f
[btrfs]
[ 2092.730012]  [<ffffffffa030d1e4>] btrfs_ioctl+0x10bd/0x2281 [btrfs]
[ 2092.730076]  [<ffffffff810d5152>] ? handle_mm_fault+0x44d/0xa00
[ 2092.730140]  [<ffffffff81173e76>] ? avc_has_perm+0x2e/0xf7
[ 2092.730202]  [<ffffffff810d7c6d>] ? __vm_enough_memory+0x25/0x13c
[ 2092.730266]  [<ffffffff8110d72d>] do_vfs_ioctl+0x3f2/0x43c
[ 2092.730328]  [<ffffffff8110d7c5>] SyS_ioctl+0x4e/0x7d
[ 2092.730389]  [<ffffffff81030a71>] ? do_page_fault+0xc/0xf
[ 2092.730452]  [<ffffffff813b0652>] system_call_fastpath+0x16/0x1b
[ 2092.730512] Code: 00 00 00 48 39 83 f8 00 00 00 74 02 0f 0b 4c 39 ab
08 01 00 00 74 02 0f 0b 48 83 7b 20 00 74 02 0f 0b 83 bb 20 01 00 00 00
74 02 <0f> 0b 83 bb 24 01 00 00 00 74 02 0f 0b 48 8b 73 18 48 8b 7b 08
[ 2092.730759] RIP  [<ffffffffa0322a4a>]
relocate_block_group+0x432/0x4de [btrfs]
[ 2092.730885]  RSP <ffff8800c7d07a58>
[ 2092.731233] ---[ end trace 16c7709ebf2c379c ]---


--
Tomasz Chmielewski
https://urldefense.proofpoint.com/v1/url?u=http://www.sslrack.com/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=zoOEeHoPSaWycUnRMebS4NI5cEnXmHt7kS4QG2us9Mk%3D%0A&s=0d4fcb8f56e098c3b7b558e37ba28198826f35c0563f25d96663ff7c30c20149

