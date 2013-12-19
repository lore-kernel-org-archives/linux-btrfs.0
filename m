Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28966 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab3LSMts (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 07:49:48 -0500
Message-ID: <52B2EB40.5090904@cn.fujitsu.com>
Date: Thu, 19 Dec 2013 20:49:04 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/relocation.c:1062
References: <20131219210941.1065d1b5@virtall.com> <52B2E319.4010706@cn.fujitsu.com> <20131219213019.1f1038f2@virtall.com>
In-Reply-To: <20131219213019.1f1038f2@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2013 08:30 PM, Tomasz Chmielewski wrote:
> It was 3.13.0-rc4.
I take a look at line 1062, this should be a new bug!!!

Thanks,
Wang
>
>
> On Thu, 19 Dec 2013 20:14:17 +0800
> Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
>
>> Hello Tomasz,
>>
>> This seems a known bug that has been fixed by josef, what is your
>> kernel version?
>>
>>
>> Thanks,
>> Wang
>> On 12/19/2013 08:09 PM, Tomasz Chmielewski wrote:
>>> Got this while running balance. Some other operations were running
>>> in parallel (rsync etc.).
>>>
>>> [152727.584641] ------------[ cut here ]------------
>>> [152727.584723] kernel BUG at fs/btrfs/relocation.c:1062!
>>> [152727.584802] invalid opcode: 0000 [#1] SMP
>>> [152727.584943] Modules linked in: veth ipt_MASQUERADE iptable_nat
>>> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
>>> ip_tables x_tables cpufreq_ondemand cpufreq_conservative
>>> cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor
>>> raid6_pq zlib_deflate loop video i2c_i801 i2c_core button
>>> acpi_cpufreq pcspkr ehci_pci ehci_hcd lpc_ich mfd_core ext4 crc16
>>> jbd2 mbcache raid1 sg sd_mod r8169 mii ahci libahci libata scsi_mod
>>> [152727.586767] CPU: 3 PID: 1540 Comm: btrfs Tainted: G        W
>>> 3.13.0-rc4 #1 [152727.586888] Hardware name: System manufacturer
>>> System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
>>> [152727.587011] task: ffff8805bedf9710 ti: ffff8805a9d9a000
>>> task.ti: ffff8805a9d9a000 [152727.587132] RIP:
>>> 0010:[<ffffffffa02ab31f>]  [<ffffffffa02ab31f>]
>>> build_backref_tree+0xb03/0xe7a [btrfs] [152727.587300] RSP:
>>> 0018:ffff8805a9d9b898  EFLAGS: 00010246 [152727.587379] RAX:
>>> ffff8805a9d9b900 RBX: ffff8805a9d9b920 RCX: ffff88055a72fa10
>>> [152727.587499] RDX: ffff88055a72ff50 RSI: ffff88055a72ff80 RDI:
>>> ffff8807e8878600 [152727.587619] RBP: ffff8805a9d9b998 R08:
>>> ffff8807e8878b80 R09: 0000000000001000 [152727.587739] R10:
>>> 0000000000001000 R11: 0000160000000000 R12: 0000000000000000
>>> [152727.587859] R13: ffff88055a72ff90 R14: ffff8805a9d9b930 R15:
>>> ffff88028e648000 [152727.587980] FS:  00007fca66eca840(0000)
>>> GS:ffff88081fac0000(0000) knlGS:0000000000000000 [152727.588101]
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [152727.588180]
>>> CR2: 00007fac0ba80000 CR3: 00000007006d9000 CR4: 00000000001407e0
>>> [152727.588300] Stack: [152727.588374]  ffff8800611992c0
>>> 0000000000000000 ffff8806c99dd500 ffff8807e8878600 [152727.588623]
>>> ffff88055a72fde0 ffff8806c99dd240 ffff88028e648124 ffff88028e648124
>>> [152727.588871]  ffff88028e648120 ffff88028e648020 ffff8807ece02c60
>>> ffff8807ece02a20 [152727.589120] Call Trace: [152727.589205]
>>> [<ffffffffa02ac13a>] relocate_tree_blocks+0x1c0/0x544 [btrfs]
>>> [152727.589292]  [<ffffffffa024f2a9>] ?
>>> btrfs_release_path+0x6b/0x8a [btrfs] [152727.589382]
>>> [<ffffffffa02ad399>] relocate_block_group+0x23f/0x4c7 [btrfs]
>>> [152727.589470]  [<ffffffffa02ad76f>]
>>> btrfs_relocate_block_group+0x14e/0x28d [btrfs] [152727.589598]
>>> [<ffffffffa028c8d2>] btrfs_relocate_chunk.isra.65+0x58/0x60e
>>> [btrfs] [152727.589727]  [<ffffffffa029a1ff>] ?
>>> btrfs_set_lock_blocking_rw+0x89/0xb2 [btrfs] [152727.589853]
>>> [<ffffffffa024f1b7>] ? btrfs_set_path_blocking+0x23/0x54 [btrfs]
>>> [152727.589979]  [<ffffffffa0253a1b>] ?
>>> btrfs_search_slot+0x72f/0x789 [btrfs] [152727.590068]
>>> [<ffffffffa0288be1>] ? free_extent_buffer+0x6f/0x7c [btrfs]
>>> [152727.590157]  [<ffffffffa028f709>] btrfs_balance+0x9fe/0xbe0
>>> [btrfs] [152727.590245]  [<ffffffffa02954c9>]
>>> btrfs_ioctl_balance+0x220/0x29f [btrfs] [152727.590334]
>>> [<ffffffffa0298a66>] btrfs_ioctl+0xfce/0x2128 [btrfs]
>>> [152727.590417]  [<ffffffff810c98c1>] ? handle_mm_fault+0x24f/0x965
>>> [152727.590498]  [<ffffffff810ccc11>] ?
>>> __vm_enough_memory+0x26/0x13d [152727.590581]  [<ffffffff8110219e>]
>>> do_vfs_ioctl+0x3f7/0x441 [152727.590661]  [<ffffffff8110223a>]
>>> SyS_ioctl+0x52/0x80 [152727.590741]  [<ffffffff8138f222>]
>>> system_call_fastpath+0x16/0x1b [152727.590821] Code: 60 71 fd 49 89
>>> 40 50 49 89 40 58 49 8b 40 58 4d 89 68 58 49 83 c0 50 4d 89 45 00
>>> 49 89 45 08 4c 89 28 e9 aa 00 00 00 a8 10 75 02 <0f> 0b 83 e0 01 41
>>> 39 c4 74 02 0f 0b 45 85 e4 75 32 49 8b 70 18 [152727.593073] RIP
>>> [<ffffffffa02ab31f>] build_backref_tree+0xb03/0xe7a [btrfs]
>>> [152727.593194]  RSP <ffff8805a9d9b898> [152727.593290] ---[ end
>>> trace b67170e8ece9f591 ]---
>>>
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

