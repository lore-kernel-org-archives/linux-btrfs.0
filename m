Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41949 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754789AbdJJHG1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 03:06:27 -0400
Subject: Re: WARNING: ... at fs/btrfs/ctree.h:1559
 btrfs_update_device+0x1be/0x1d0 [btrfs]
To: Cloud Admin <admin@cloud.haefemeier.eu>, linux-btrfs@vger.kernel.org
References: <1507569963.2874.2.camel@cloud.haefemeier.eu>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0ec49bbb-7c2e-1436-5134-5734360a6152@suse.com>
Date: Tue, 10 Oct 2017 10:06:24 +0300
MIME-Version: 1.0
In-Reply-To: <1507569963.2874.2.camel@cloud.haefemeier.eu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.10.2017 20:26, Cloud Admin wrote:
> Hi,
> I update kernel from 4.11.10 to 4.13.4 and since that I get the following message in the kernel journal calling 'scrub' or 'balance'. I use Fedora 26 with btrfs-progs v4.9.1.
> What does this mean and (more important) what can I do? 
> Bye
> 	Frank
> 
> BTRFS info (device dm-7): relocating block group 44050690342912 flags system|raid1
> BTRFS info (device dm-7): found 117 extents
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 22095 at fs/btrfs/ctree.h:1559 btrfs_update_device+0x1be/0x1d0 [btrfs]

This is :

WARN_ON(!IS_ALIGNED(val, eb->fs_info->sectorsize)); in
btrfs_set_device_total_bytes. This likely means your device's size isn't
a multiple of sectorsize (4kb). Can you paste the output of

btrfs inspect-internal dump-super /path/to/btrfs/device


What i will advise you to do is to shrink your device to be a multiple
of 4kb.

In any case you can be assured that there is no danger of you losing data.


> Modules linked in: rpcsec_gss_krb5 veth xt_nat xt_addrtype br_netfilter xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun nf_conntrack_sane xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables ftsteutates btrfs xor raid6_pq tda18212 cxd2841er tpm_crb intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt irqbypass iTCO_vendor_support intel_cstate intel_uncore mei_wdt intel_rapl_perf ppdev hci_uart ddbridge dvb_core
> Okt 09 19:08:32 hypercloud.fritz.box kernel:  btbcm btqca btintel mei_me i2c_i801 shpchp bluetooth joydev mei intel_pch_thermal wmi intel_lpss_acpi intel_lpss pinctrl_sunrisepoint fujitsu_laptop parport_pc sparse_keymap ecdh_generic parport tpm_tis pinctrl_intel tpm_tis_core rfkill tpm acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_crypt i915 crct10dif_pclmul i2c_algo_bit crc32_pclmul drm_kms_helper crc32c_intel e1000e drm ghash_clmulni_intel serio_raw ptp pps_core video i2c_hid
> CPU: 3 PID: 22095 Comm: btrfs Tainted: G        W       4.13.4-200.fc26.x86_64 #1
> Hardware name: FUJITSU D3417-B1/D3417-B1, BIOS V5.0.0.11 R1.12.0 for D3417-B1x                    02/09/2016
> task: ffff8ecb59b026c0 task.stack: ffffb805cae90000
> RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
> RSP: 0018:ffffb805cae93ac8 EFLAGS: 00010206
> RAX: 0000000000000fff RBX: ffff8ed094bb11c0 RCX: 0000074702251e00
> RDX: 0000000000000004 RSI: 0000000000003efa RDI: ffff8ec9eb032c08
> RBP: ffffb805cae93b10 R08: 0000000000003efe R09: ffffb805cae93a80
> R10: 0000000000001000 R11: 0000000000000003 R12: ffff8ed0c7a3f000
> R13: 0000000000000000 R14: 0000000000003eda R15: ffff8ec9eb032c08
> FS:  00007f10b256a8c0(0000) GS:ffff8ed0ee4c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f6261c0d5f0 CR3: 00000005cad4c000 CR4: 00000000003406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  btrfs_remove_chunk+0x365/0x870 [btrfs]
>  btrfs_relocate_chunk+0x7e/0xd0 [btrfs]
>  btrfs_balance+0xc07/0x1390 [btrfs]
>  btrfs_ioctl_balance+0x319/0x380 [btrfs]
>  btrfs_ioctl+0x9d5/0x24a0 [btrfs]
>  ? lru_cache_add+0x3a/0x80
>  ? lru_cache_add_active_or_unevictable+0x4c/0xf0
>  ? __handle_mm_fault+0x939/0x10b0
>  do_vfs_ioctl+0xa5/0x600
>  ? do_brk_flags+0x230/0x360
>  ? do_vfs_ioctl+0xa5/0x600
>  SyS_ioctl+0x79/0x90
>  entry_SYSCALL_64_fastpath+0x1a/0xa5
> RIP: 0033:0x7f10b15e65e7
> RSP: 002b:00007ffc9402ebe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000008041 RCX: 00007f10b15e65e7
> RDX: 00007ffc9402ec80 RSI: 00000000c4009420 RDI: 0000000000000003
> RBP: 00007f10b18abae0 R08: 000055b07a3b3010 R09: 0000000000000078
> R10: 00007f10b18abb38 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f10b18abb38 R14: 0000000000008060 R15: 0000000000000000
> Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa 20 ff ff 4c 89 ff e8 72 ef fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9 d0 fe ff ff <0f> ff eb b6 e8 39 fd 78 c6 66 0f 1f 84 00 00 00 00 00 0f 1f 44 
> ---[ end trace d1e1c8aff99bfeb8 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
