Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:54716 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754805AbeBOHRm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 02:17:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 15 Feb 2018 16:17:39 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
In-Reply-To: <57960c49a431cdfdb4c659d0a9b40856@virtall.com>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
 <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
 <f77a1a28c2cbf08efd24577088a29de0@virtall.com>
 <58ea1e02-6f38-97f7-34aa-e993a1aa261b@gmx.com>
 <57960c49a431cdfdb4c659d0a9b40856@virtall.com>
Message-ID: <c20bd378f5c9684f45fab80a234888bc@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-15 16:02, Tomasz Chmielewski wrote:
> On 2018-02-15 13:32, Qu Wenruo wrote:
> 
>> Is there any kernel message like kernel warning or backtrace?
> 
> I see there was this one:
> 
> Feb 13 13:53:32 lxd01 kernel: [9351710.878404] ------------[ cut here
> ]------------
> Feb 13 13:53:32 lxd01 kernel: [9351710.878430] WARNING: CPU: 9 PID:
> 7780 at /home/kernel/COD/linux/fs/btrfs/tree-log.c:3361
> log_dir_items+0x54b/0x560 [btrfs]
(...)
> Feb 13 13:53:32 lxd01 kernel: [9351710.878707] ---[ end trace
> 81aeb3fb0c68ce00 ]---
> 
> 
> BTW we've updated to the latest 4.15 kernel after that.

Also, we were just running a balance there and it printed this in dmesg.

Not sure if it's something serious or not. The filesystem still runs 
correctly.

[60082.349447] WARNING: CPU: 2 PID: 780 at 
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:124 
btrfs_put_block_group+0x4f/0x60 [btrfs]
[60082.349449] Modules linked in: xt_nat xt_REDIRECT nf_nat_redirect 
tcp_diag inet_diag sunrpc xt_NFLOG cfg80211 xt_conntrack nfnetlink_log 
nfnetlink ipt_REJECT nf_reject_ipv4 binfmt_misc veth ebtable_filter 
ebtables ip6t_MASQUERADE nf_nat_masquerade_ipv6 ip6table_nat 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 xt_comment nf_log_ipv4 
nf_log_common xt_LOG ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_vs nf_conntrack 
ip6table_filter ip6_tables iptable_filter xt_CHECKSUM xt_tcpudp 
iptable_mangle ip_tables x_tables intel_rapl sb_edac 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel btrfs bridge pcbc 
zstd_compress stp llc aesni_intel aes_x86_64 crypto_simd glue_helper 
input_leds
[60082.349471]  cryptd intel_cstate intel_rapl_perf serio_raw shpchp 
lpc_ich acpi_pad mac_hid autofs4 raid10 raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 
raid0 multipath linear ttm drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops igb drm dca ahci ptp libahci pps_core i2c_algo_bit 
wmi
[60082.349488] CPU: 2 PID: 780 Comm: btrfs-cleaner Tainted: G        W   
      4.15.3-041503-generic #201802120730
[60082.349489] Hardware name: ASUSTeK COMPUTER INC. Z10PA-U8 
Series/Z10PA-U8 Series, BIOS 0601 06/26/2015
[60082.349497] RIP: 0010:btrfs_put_block_group+0x4f/0x60 [btrfs]
[60082.349497] RSP: 0018:ffffc1468d3afe48 EFLAGS: 00010206
[60082.349498] RAX: 0000000000000000 RBX: ffff9d072f740000 RCX: 
0000000000000000
[60082.349499] RDX: 0000000000000001 RSI: 0000000000000246 RDI: 
ffff9d072bcb8c00
[60082.349499] RBP: ffffc1468d3afe50 R08: ffff9d072bcbfc00 R09: 
0000000180200019
[60082.349500] R10: ffffc1468d3afe38 R11: 0000000000000100 R12: 
ffff9d072b87ce00
[60082.349500] R13: ffff9d072bcb8c00 R14: ffff9d072b87ced0 R15: 
ffff9d072bcb8d20
[60082.349501] FS:  0000000000000000(0000) GS:ffff9d073f280000(0000) 
knlGS:0000000000000000
[60082.349502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[60082.349502] CR2: 00007f9221375000 CR3: 00000019a660a005 CR4: 
00000000001606e0
[60082.349503] Call Trace:
[60082.349513]  btrfs_delete_unused_bgs+0x243/0x3c0 [btrfs]
[60082.349521]  cleaner_kthread+0x159/0x170 [btrfs]
[60082.349524]  kthread+0x121/0x140
[60082.349531]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[60082.349533]  ? kthread_create_worker_on_cpu+0x70/0x70
[60082.349535]  ret_from_fork+0x35/0x40
[60082.349536] Code: e8 01 00 00 48 85 c0 75 1a 48 89 fb 48 8b bf d8 00 
00 00 e8 14 3a 66 d7 48 89 df e8 0c 3a 66 d7 5b 5d c3 0f ff eb e2 0f ff 
eb cb <0f> ff eb ce 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
[60082.349554] ---[ end trace 9492ee1b902c858d ]---


Tomasz Chmielewski
https://lxadm.com
