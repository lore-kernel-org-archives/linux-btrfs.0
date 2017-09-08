Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:47914 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751088AbdIHE47 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 00:56:59 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id BBDBBA5488E
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 04:56:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 04:56:52 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 08 Sep 2017 13:56:50 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 4.13: No space left with plenty of free space
 (/home/kernel/COD/linux/fs/btrfs/extent-tree.c:6989
 __btrfs_free_extent.isra.62+0xc2c/0xdb0)
In-Reply-To: <7459bb074e417c066b525d832d8006ca@wpkg.org>
References: <7459bb074e417c066b525d832d8006ca@wpkg.org>
Message-ID: <409e33c45cf1defe5c582381f00fa562@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-08 13:33, Tomasz Chmielewski wrote:
> Just got this one in dmesg with btrfs RAID-1 on top of Linux software 
> RAID-5.

Should say: with btrfs _single_ on top of Linux software RAID-5.



> Why does it say "No space left" if we have 9 TB free there?
> 
> [233787.920933] BTRFS: Transaction aborted (error -28)
> [233787.920953] ------------[ cut here ]------------
> [233787.920971] WARNING: CPU: 1 PID: 2235 at
> /home/kernel/COD/linux/fs/btrfs/extent-tree.c:6989
> __btrfs_free_extent.isra.62+0xc2c/0xdb0 [btrfs]
> [233787.920971] Modules linked in: nf_conntrack_ipv6 nf_defrag_ipv6
> xt_NFLOG xt_conntrack ip6table_filter ip6_tables xt_CHECKSUM
> iptable_mangle xt_tcpudp ipt_MASQUERADE nf_nat_masquerade_ipv4
> xt_comment iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
> nf_nat nf_conntrack iptable_filter ip_tables x_tables nfnetlink_log
> nfnetlink rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd grace fscache
> sunrpc bluetooth ecdh_generic binfmt_misc veth bridge stp llc btrfs
> intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
> kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
> ppdev aesni_intel aes_x86_64 crypto_simd glue_helper cryptd eeepc_wmi
> intel_cstate intel_rapl_perf input_leds asus_wmi sparse_keymap
> serio_raw wmi_bmof parport_pc shpchp ie31200_edac tpm_infineon lpc_ich
> parport
> [233787.920992]  mac_hid autofs4 raid0 multipath linear raid456
> async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid10
> raid6_pq libcrc32c raid1 ahci r8169 libahci mii wmi video
> [233787.921001] CPU: 1 PID: 2235 Comm: btrfs-transacti Not tainted
> 4.13.0-041300-generic #201709031731
> [233787.921002] Hardware name: System manufacturer System Product
> Name/P8H77-M PRO, BIOS 9002 05/30/2014
> [233787.921002] task: ffff943b0a779740 task.stack: ffffb1c4491a4000
> [233787.921012] RIP: 0010:__btrfs_free_extent.isra.62+0xc2c/0xdb0 
> [btrfs]
> [233787.921013] RSP: 0018:ffffb1c4491a7b08 EFLAGS: 00010286
> [233787.921013] RAX: 0000000000000026 RBX: 00000cdf3dddc000 RCX:
> 0000000000000000
> [233787.921014] RDX: 0000000000000000 RSI: ffff943b5fa4dc78 RDI:
> ffff943b5fa4dc78
> [233787.921014] RBP: ffffb1c4491a7bb0 R08: 0000000000000001 R09:
> 00000000000004c5
> [233787.921015] R10: 00000013dd7ec000 R11: 0000000000000000 R12:
> ffff943b0d1c0000
> [233787.921015] R13: 00000000ffffffe4 R14: 0000000000000000 R15:
> ffff943b0cadcee0
> [233787.921016] FS:  0000000000000000(0000) GS:ffff943b5fa40000(0000)
> knlGS:0000000000000000
> [233787.921016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [233787.921017] CR2: 00007ffc9230dde8 CR3: 000000075a009000 CR4:
> 00000000001406e0
> [233787.921018] Call Trace:
> [233787.921031]  ? btrfs_merge_delayed_refs+0x62/0x550 [btrfs]
> [233787.921039]  __btrfs_run_delayed_refs+0x6f0/0x1380 [btrfs]
> [233787.921047]  btrfs_run_delayed_refs+0x6b/0x250 [btrfs]
> [233787.921054]  btrfs_write_dirty_block_groups+0x158/0x390 [btrfs]
> [233787.921063]  commit_cowonly_roots+0x221/0x2c0 [btrfs]
> [233787.921071]  btrfs_commit_transaction+0x46e/0x8d0 [btrfs]
> [233787.921079]  transaction_kthread+0x1a2/0x1c0 [btrfs]
> [233787.921081]  kthread+0x125/0x140
> [233787.921088]  ? btrfs_cleanup_transaction+0x500/0x500 [btrfs]
> [233787.921089]  ? kthread_create_on_node+0x70/0x70
> [233787.921091]  ret_from_fork+0x25/0x30
> [233787.921092] Code: 3e d3 0f ff eb d0 44 89 ee 48 c7 c7 40 53 7a c0
> e8 0b ba 3e d3 0f ff e9 76 fb ff ff 44 89 ee 48 c7 c7 40 53 7a c0 e8
> f5 b9 3e d3 <0f> ff e9 f7 f4 ff ff 8b 55 20 48 89 c1 49 89 d8 48 c7 c6
> 20 54
> [233787.921107] ---[ end trace f4e71e70fbc200d2 ]---
> [233787.921132] BTRFS: error (device md2) in __btrfs_free_extent:6989:
> errno=-28 No space left
> [233787.921189] BTRFS info (device md2): forced readonly
> [233787.921191] BTRFS: error (device md2) in
> btrfs_run_delayed_refs:3009: errno=-28 No space left
> [233789.507669] BTRFS warning (device md2): Skipping commit of aborted
> transaction.
> [233789.507672] BTRFS: error (device md2) in cleanup_transaction:1873:
> errno=-28 No space left
> 
> 
> 
> 
> # df -h /data
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md2         17T  7.3T  9.1T  45% /data
> 
> 
> # btrfs fi show /data
> Label: 'data'  uuid: fddbd057-4fa6-4b2e-a9ca-993829bab4b9
>         Total devices 1 FS bytes used 7.21TiB
>         devid    1 size 16.30TiB used 12.99TiB path /dev/md2
> 
> # btrfs fi df /data
> Data, single: total=12.84TiB, used=7.13TiB
> System, DUP: total=8.00MiB, used=1.48MiB
> Metadata, DUP: total=79.00GiB, used=77.87GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> root@srv8 ~ # btrfs fi usage /data
> Overall:
>     Device size:                  16.30TiB
>     Device allocated:             12.99TiB
>     Device unallocated:            3.31TiB
>     Device missing:                  0.00B
>     Used:                          7.29TiB
>     Free (estimated):              9.01TiB      (min: 7.36TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:12.84TiB, Used:7.13TiB
>    /dev/md2       12.84TiB
> 
> Metadata,DUP: Size:79.00GiB, Used:77.87GiB
>    /dev/md2      158.00GiB
> 
> System,DUP: Size:8.00MiB, Used:1.48MiB
>    /dev/md2       16.00MiB
> 
> Unallocated:
>    /dev/md2        3.31TiB
> 
> 
> 
> Tomasz Chmielewski
> https://lxadm.com
