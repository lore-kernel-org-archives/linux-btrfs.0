Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35544 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbeCOVWP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 17:22:15 -0400
Received: by mail-oi0-f47.google.com with SMTP id x10so6971567oig.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 14:22:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net> <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Mar 2018 15:22:13 -0600
Message-ID: <CAJCQCtTUsH5ynMCjRRcnGZHAccOcUL4os3GriBb+mwwtR8SC2w@mail.gmail.com>
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 3:07 PM, Mike Stevens <michael.stevens@bayer.com> wrote:

> Mar 15 14:03:06 auswscs9903 kernel: WARNING: CPU: 6 PID: 2720 at fs/btrfs/extent-tree.c:10192 btrfs_create_pending_block_groups+0x1f3/0x260 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: Modules linked in: nfsv3 nfs fscache mpt3sas raid_class mptctl mptbase binfmt_misc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_comment xt_multiport xt_conntrack nf_conntrack libcrc32c iptable_filter dm_mirror dm_region_hash dm_log dm_mod dax iTCO_wdt iTCO_vendor_support btrfs ses enclosure scsi_transport_sas xor zstd_decompress zstd_compress xxhash raid6_pq sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_helper cryptd intel_cstate lpc_ich sg intel_rapl_perf pcspkr joydev input_leds i2c_i801 mfd_core mei_me mei ipmi_si ipmi_devintf shpchp wmi ioatdma ipmi_msghandler acpi_power_meter acpi_pad nfsd nfs_acl lockd grace auth_rpcgss sunrpc ip_tables ext4 mbcache
> Mar 15 14:03:06 auswscs9903 kernel: jbd2 sd_mod crc32c_intel ast drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ahci ttm libahci igb ptp drm pps_core i2c_algo_bit libata myri10ge megaraid_sas dca
> Mar 15 14:03:06 auswscs9903 kernel: CPU: 6 PID: 2720 Comm: btrfs Not tainted 4.15.10-1.el7.elrepo.x86_64 #1
> Mar 15 14:03:06 auswscs9903 kernel: Hardware name: Supermicro Super Server/X10DRL-i, BIOS 1.1b 09/11/2015
> Mar 15 14:03:06 auswscs9903 kernel: RIP: 0010:btrfs_create_pending_block_groups+0x1f3/0x260 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: RSP: 0018:ffffc90009c2fae8 EFLAGS: 00010282
> Mar 15 14:03:06 auswscs9903 kernel: RAX: 0000000000000000 RBX: 00000000ffffffe5 RCX: 0000000000000006
> Mar 15 14:03:06 auswscs9903 kernel: RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff88103f3969d0
> Mar 15 14:03:06 auswscs9903 kernel: RBP: ffffc90009c2fb68 R08: 0000000000000000 R09: 0000000000000525
> Mar 15 14:03:06 auswscs9903 kernel: R10: 0000000000000004 R11: 0000000000000524 R12: ffff88100d7c7000
> Mar 15 14:03:06 auswscs9903 kernel: R13: ffff880fc6985800 R14: ffff88100d7c6f48 R15: ffff880fc6985920
> Mar 15 14:03:06 auswscs9903 kernel: FS:  00007fc1564b6700(0000) GS:ffff88103f380000(0000) knlGS:0000000000000000
> Mar 15 14:03:06 auswscs9903 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Mar 15 14:03:06 auswscs9903 kernel: CR2: 00000000016a5330 CR3: 0000000fc6310005 CR4: 00000000001606e0
> Mar 15 14:03:06 auswscs9903 kernel: Call Trace:
> Mar 15 14:03:06 auswscs9903 kernel: do_chunk_alloc+0x269/0x2e0 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: ? start_transaction+0xa7/0x450 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: btrfs_inc_block_group_ro+0x142/0x160 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: scrub_enumerate_chunks+0x1ad/0x680 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: ? try_to_wake_up+0x59/0x480
> Mar 15 14:03:06 auswscs9903 kernel: btrfs_scrub_dev+0x21d/0x540 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: ? __check_object_size+0x159/0x190
> Mar 15 14:03:06 auswscs9903 kernel: ? _copy_from_user+0x33/0x70
> Mar 15 14:03:06 auswscs9903 kernel: btrfs_ioctl+0xf20/0x2110 [btrfs]
> Mar 15 14:03:06 auswscs9903 kernel: ? audit_filter_rules.isra.9+0x241/0xe80
> Mar 15 14:03:06 auswscs9903 kernel: do_vfs_ioctl+0xaa/0x610
> Mar 15 14:03:06 auswscs9903 kernel: ? __audit_syscall_entry+0xac/0xf0
> Mar 15 14:03:06 auswscs9903 kernel: ? syscall_trace_enter+0x1cd/0x2b0
> Mar 15 14:03:06 auswscs9903 kernel: SyS_ioctl+0x79/0x90
> Mar 15 14:03:06 auswscs9903 kernel: do_syscall_64+0x79/0x1b0
> Mar 15 14:03:06 auswscs9903 kernel: entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Mar 15 14:03:06 auswscs9903 kernel: RIP: 0033:0x7fc1565a6107
> Mar 15 14:03:06 auswscs9903 kernel: RSP: 002b:00007fc1564b5d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> Mar 15 14:03:06 auswscs9903 kernel: RAX: ffffffffffffffda RBX: 000000000168a3a0 RCX: 00007fc1565a6107
> Mar 15 14:03:06 auswscs9903 kernel: RDX: 000000000168a3a0 RSI: 00000000c400941b RDI: 0000000000000003
> Mar 15 14:03:06 auswscs9903 kernel: RBP: 0000000000000000 R08: 00007fc1564b6700 R09: 0000000000000000
> Mar 15 14:03:06 auswscs9903 kernel: R10: 00007fc1564b6700 R11: 0000000000000246 R12: 00007fc1564b64e0
> Mar 15 14:03:06 auswscs9903 kernel: R13: 00007fc1564b69c0 R14: 00007fc1564b6700 R15: 0000000000000001
> Mar 15 14:03:06 auswscs9903 kernel: Code: 00 e9 5d ff ff ff 49 8b 44 24 60 f0 0f ba a8 d8 cd 00 00 02 72 17 83 fb fb 74 2d 89 de 48 c7 c7 d8 68 77 a0 31 c0 e8 cd 8f 9b e0 <0f> 0b 89 d9 ba d0 27 00 00 48 c7 c6 60 f7 76 a0 4c 89 e7 e8 18
>

Can you post a more complete dmesg rather than snipping it? Is there
anything device or Btrfs related in the 5 minutes before this trace
happens? And is it still going read only?

Also hopefully the SCT ERC on all these drives is less than the SCSI
driver's default timeout of 30 seconds. You can check with 'smartctl
-l scterc /dev/' This is critical to ensuring sector failures are
properly fixed up by Btrfs. And honestly I'm not really certain we had
fix up code for raid6 in the 3.18 code, so it's possible some problems
have not been getting fixed up. Any enterprise or NAS drive will have
something like 70 deciseconds for SCT ERC which is fine. Anything less
than 30 seconds is OK. For sure fix up code is in 4.14 (I think it's
since 4.1 or 4.4 for raid56 and since ancient times for other Btrfs
profiles).

Can you do an offline btrfs check without repair? This probably will
take a while... it's a big file system.

This needs to get the attention of a developer though.

-- 
Chris Murphy
