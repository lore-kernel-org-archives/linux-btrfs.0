Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:47987 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752411AbeCMLOK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 07:14:10 -0400
Subject: Re: Btrfs remounted read-only due to ENOSPC in btrfs_run_delayed_refs
From: Martin Svec <martin.svec@zoner.cz>
To: Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5a54af49-c18f-3534-7d58-5224363926c7@zoner.cz>
 <3622d05f-b31e-6f3d-a70c-d32c4667ef43@suse.com>
 <7ce06292-6598-2b97-11a3-93174ec597bc@zoner.cz>
 <8b2db87a-681f-d8b5-8b1b-f67ec9ff6917@zoner.cz>
 <9f72fe11-69d4-140e-7895-5cf44ccc526f@suse.com>
 <1cd72f3a-3c29-b7dc-eaed-8a787af43d13@zoner.cz>
Message-ID: <7f1aff14-3e33-51fe-c2d8-d9b398a67a7a@zoner.cz>
Date: Tue, 13 Mar 2018 12:14:08 +0100
MIME-Version: 1.0
In-Reply-To: <1cd72f3a-3c29-b7dc-eaed-8a787af43d13@zoner.cz>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dne 10.3.2018 v 15:51 Martin Svec napsal(a):
> Dne 10.3.2018 v 13:13 Nikolay Borisov napsal(a):
>> <snip>
>>
>>>>> And then report back on the output of the extra debug 
>>>>> statements. 
>>>>>
>>>>> Your global rsv is essentially unused, this means 
>>>>> in the worst case the code should fallback to using the global rsv
>>>>> for satisfying the memory allocation for delayed refs. So we should
>>>>> figure out why this isn't' happening. 
>>>> Patch applied. Thank you very much, Nikolay. I'll let you know as soon as we hit ENOSPC again.
>>> There is the output:
>>>
>>> [24672.573075] BTRFS info (device sdb): space_info 4 has 18446744072971649024 free, is not full
>>> [24672.573077] BTRFS info (device sdb): space_info total=308163903488, used=304593289216, pinned=2321940480, reserved=174800896, may_use=1811644416, readonly=131072
>>> [24672.573079] use_block_rsv: Not using global blockrsv! Current blockrsv->type = 1 blockrsv->space_info = ffff999a57db7000 global_rsv->space_info = ffff999a57db7000
>>> [24672.573083] BTRFS: Transaction aborted (error -28)
>> Bummer, so you are indeed running out of global space reservations in
>> context which can't really use any other reservation type, thus the
>> ENOSPC. Was the stacktrace again during processing of running delayed refs?
> Yes, the stacktrace is below.
>
> [24672.573132] WARNING: CPU: 3 PID: 808 at fs/btrfs/extent-tree.c:3089 btrfs_run_delayed_refs+0x259/0x270 [btrfs]
> [24672.573132] Modules linked in: binfmt_misc xt_comment xt_tcpudp iptable_filter nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack iptable_raw ip6table_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6table_mangle ip6table_raw ip6_tables iptable_mangle intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel snd_pcm aes_x86_64 snd_timer crypto_simd glue_helper snd cryptd soundcore iTCO_wdt intel_cstate joydev iTCO_vendor_support pcspkr dcdbas intel_uncore sg serio_raw evdev lpc_ich mgag200 ttm drm_kms_helper drm i2c_algo_bit shpchp mfd_core i7core_edac ipmi_si ipmi_devintf acpi_power_meter ipmi_msghandler button acpi_cpufreq ip_tables x_tables autofs4 xfs libcrc32c crc32c_generic btrfs xor zstd_decompress zstd_compress
> [24672.573161]  xxhash hid_generic usbhid hid raid6_pq sd_mod crc32c_intel psmouse uhci_hcd ehci_pci ehci_hcd megaraid_sas usbcore scsi_mod bnx2
> [24672.573170] CPU: 3 PID: 808 Comm: btrfs-transacti Tainted: G        W I     4.14.23-znr8+ #73
> [24672.573171] Hardware name: Dell Inc. PowerEdge R510/0DPRKF, BIOS 1.6.3 02/01/2011
> [24672.573172] task: ffff999a23229140 task.stack: ffffa85642094000
> [24672.573186] RIP: 0010:btrfs_run_delayed_refs+0x259/0x270 [btrfs]
> [24672.573187] RSP: 0018:ffffa85642097de0 EFLAGS: 00010282
> [24672.573188] RAX: 0000000000000026 RBX: ffff99975c75c3c0 RCX: 0000000000000006
> [24672.573189] RDX: 0000000000000000 RSI: 0000000000000082 RDI: ffff999a6fcd66f0
> [24672.573190] RBP: ffff999995c24d68 R08: 0000000000000001 R09: 0000000000000479
> [24672.573190] R10: ffff99974b1960e0 R11: 0000000000000479 R12: ffff999a5a650000
> [24672.573191] R13: ffff999a5a6511f0 R14: ffffffffffffffff R15: 0000000000000000
> [24672.573192] FS:  0000000000000000(0000) GS:ffff999a6fcc0000(0000) knlGS:0000000000000000
> [24672.573193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [24672.573194] CR2: 0000558bfd56dfd0 CR3: 000000030a60a005 CR4: 00000000000206e0
> [24672.573195] Call Trace:
> [24672.573215]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
> [24672.573231]  ? start_transaction+0x89/0x410 [btrfs]
> [24672.573246]  transaction_kthread+0x195/0x1b0 [btrfs]
> [24672.573249]  kthread+0xfc/0x130
> [24672.573265]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
> [24672.573266]  ? kthread_create_on_node+0x70/0x70
> [24672.573269]  ret_from_fork+0x35/0x40
> [24672.573270] Code: c7 c6 20 e8 37 c0 48 89 df 44 89 04 24 e8 59 bc 09 00 44 8b 04 24 eb 86 44 89 c6 48 c7 c7 30 58 38 c0 44 89 04 24 e8 82 30 3f cf <0f> 0b 44 8b 04 24 eb c4 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00
> [24672.573292] ---[ end trace b17d927a946cb02e ]---
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Again, another ENOSPC due to lack of global rsv space in the context of delayed refs:

[193381.690347] use_block_rsv: Not using global blockrsv! Current blockrsv->type = 1 blockrsv->space_info = ffff95ff96a9c400 global_rsv->space_info = ffff95ff96a9c400
[193381.690348] BTRFS: Transaction aborted (error -28)
[193381.690371] ------------[ cut here ]------------
[193381.690400] WARNING: CPU: 5 PID: 805 at fs/btrfs/extent-tree.c:7081 __btrfs_free_extent.isra.61+0xaed/0xd30 [btrfs]
[193381.690400] Modules linked in: binfmt_misc xt_comment xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack ip6table_filter iptable_filter iptable_raw ip6table_mangle ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6_tables iptable_mangle intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd glue_helper snd_pcm cryptd snd_timer sg snd intel_cstate soundcore iTCO_wdt iTCO_vendor_support intel_uncore mgag200 ttm drm_kms_helper drm dcdbas pcspkr joydev serio_raw evdev i2c_algo_bit acpi_power_meter shpchp lpc_ich mfd_core ipmi_si ipmi_devintf i7core_edac ipmi_msghandler button acpi_cpufreq ip_tables x_tables autofs4 xfs libcrc32c crc32c_generic btrfs xor zstd_decompress zstd_compress
[193381.690430]  xxhash hid_generic usbhid hid raid6_pq sd_mod crc32c_intel psmouse uhci_hcd ehci_pci ehci_hcd megaraid_sas usbcore scsi_mod bnx2
[193381.690439] CPU: 5 PID: 805 Comm: btrfs-transacti Tainted: G        W I     4.14.23-znr9+ #74
[193381.690440] Hardware name: Dell Inc. PowerEdge R510/0DPRKF, BIOS 1.6.3 02/01/2011
[193381.690441] task: ffff95ff97786340 task.stack: ffffb616c20ec000
[193381.690461] RIP: 0010:__btrfs_free_extent.isra.61+0xaed/0xd30 [btrfs]
[193381.690462] RSP: 0018:ffffb616c20efc30 EFLAGS: 00010286
[193381.690463] RAX: 0000000000000026 RBX: 00001fb6a254c000 RCX: 0000000000000006
[193381.690464] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff95ffafd566f0
[193381.690465] RBP: 00000000ffffffe4 R08: 0000000000000001 R09: 0000000000000e27
[193381.690466] R10: 0000000000000001 R11: 0000000000000e27 R12: ffff95ff9c6d2000
[193381.690466] R13: ffff95fed4905f50 R14: 0000000000000000 R15: 0000000000000002
[193381.690467] FS:  0000000000000000(0000) GS:ffff95ffafd40000(0000) knlGS:0000000000000000
[193381.690468] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[193381.690469] CR2: 00007ffc12da1000 CR3: 000000024de0a001 CR4: 00000000000206e0
[193381.690470] Call Trace:
[193381.690492]  ? btrfs_merge_delayed_refs+0x63/0x560 [btrfs]
[193381.690506]  __btrfs_run_delayed_refs+0x516/0x12a0 [btrfs]
[193381.690520]  btrfs_run_delayed_refs+0x7a/0x270 [btrfs]
[193381.690537]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
[193381.690552]  ? start_transaction+0x89/0x410 [btrfs]
[193381.690568]  transaction_kthread+0x195/0x1b0 [btrfs]
[193381.690571]  kthread+0xfc/0x130
[193381.690586]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[193381.690587]  ? kthread_create_on_node+0x70/0x70
[193381.690590]  ret_from_fork+0x35/0x40
[193381.690591] Code: 33 21 0a 00 e9 39 f9 ff ff 8b 74 24 30 48 c7 c7 30 08 2c c0 e8 80 e5 cb d0 0f 0b eb cc 89 ee 48 c7 c7 30 08 2c c0 e8 6e e5 cb d0 <0f> 0b e9 f9 f8 ff ff 8b 94 24 c0 00 00 00 48 89 c1 49 89 d8 48
[193381.690613] ---[ end trace 4efa15c69c17b2f8 ]---
[193381.690649] BTRFS: error (device sdb) in __btrfs_free_extent:7081: errno=-28 No space left
[193381.690707] BTRFS info (device sdb): forced readonly
[193381.690712] BTRFS: error (device sdb) in btrfs_run_delayed_refs:3089: errno=-28 No space left
[193381.690782] BTRFS warning (device sdb): Skipping commit of aborted transaction.
[193381.690784] BTRFS: error (device sdb) in cleanup_transaction:1873: errno=-28 No space left

Nikolay, do you have any ideas you would like to test on my system now? 
I'm going to remove old backup snapshots so I'll not be able to reproduce
the problem for some time.

Thanks,

Martin



