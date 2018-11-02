Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB6BC32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 17:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A9A62081F
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 17:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A9A62081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=oh3mqu.pp.hyper.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbeKCCdi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:33:38 -0400
Received: from titan.hyper.fi ([80.83.3.82]:33394 "EHLO titan.hyper.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbeKCCdi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 22:33:38 -0400
X-Greylist: delayed 1859 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2018 22:33:37 EDT
Received: by titan.hyper.fi (Postfix, from userid 500)
        id A9AF4E7D8C; Fri,  2 Nov 2018 18:54:50 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
        by titan.hyper.fi (Postfix) with ESMTP id A2F35E7D88
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Nov 2018 18:54:50 +0200 (EET)
Date:   Fri, 2 Nov 2018 18:54:50 +0200 (EET)
From:   linux-btrfs@oh3mqu.pp.hyper.fi
X-X-Sender: oh3mqu@titan.hyper.fi
To:     linux-btrfs@vger.kernel.org
Subject: Big amount of snapshots and disk full
Message-ID: <alpine.LFD.2.00.1811021817540.5224@titan.hyper.fi>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hi,

I am doing backups with rsync and do versioning with btrfs snapshots. 
And last week I got file system full.  I googled some and noticed that 
there might be bug in space_cache so I cleared cache and mounted it with 
nospace_cache and system worked about week (managed to delete & create 
tens of snapshots during that time. Before 1st issue system have worked 
without problems over year).  Now I got same issue again.  Any Ideas what 
I should try next?  Disk have never been even half full.

An error occurred when script was creating new snapshot, rsync 
before that was fine.  (And there was another rsync to another destination 
running at same time)

Is there some issue with big amount of snapshots?

I have nearly 50 machines on backup and most of them have less than ten 
versions, so my subvol hierarchy is like this.

data (btrfsroot)
  machine1 (subvol)
   last (subvol)
   [date] (readonly snapshot of last)
   [date2] (readonly snapshot of last)
   ...
  machine2 (subvol)
   last (subvol)
   [date] (readonly snapshot of last)
......


root@backuprasia:~# btrfs sub list /data |wc -l
492


root@backuprasia:~# btrfs fi usage /data
Overall:
     Device size:                  30.00TiB
     Device allocated:             13.62TiB
     Device unallocated:           16.38TiB
     Device missing:                  0.00B
     Used:                         13.59TiB
     Free (estimated):             16.40TiB      (min: 16.40TiB)
     Data ratio:                       1.00
     Metadata ratio:                   1.00
     Global reserve:              512.00MiB      (used: 499.00MiB)

Data,single: Size:13.45TiB, Used:13.43TiB
    /dev/mapper/datavg-backup1     13.45TiB

Metadata,single: Size:172.01GiB, Used:169.20GiB
    /dev/mapper/datavg-backup1    172.01GiB

System,single: Size:4.00MiB, Used:1.62MiB
    /dev/mapper/datavg-backup1      4.00MiB

Unallocated:
    /dev/mapper/datavg-backup1     16.38TiB


root@backuprasia:~# uname -a
Linux backuprasia 4.15.0-38-generic #41~16.04.1-Ubuntu SMP Wed Oct 10 20:16:04 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux


Nov 02 01:58:31 backuprasia kernel: ------------[ cut here ]------------
Nov 02 01:58:31 backuprasia kernel: BTRFS: Transaction aborted (error -28)
Nov 02 01:58:31 backuprasia kernel: WARNING: CPU: 8 PID: 14381 at /build/linux-hwe-4LSUYr/linux-hwe-4.15.0/fs/btrfs/extent-tree.c:3784 btrfs_start_dirty_block_groups+0x260//0x430 [btrfs]
Nov 02 01:58:31 backuprasia kernel: [205245.441842] Modules linked in: ip6table_filter ip6_tables ipt_REJECT nf_reject_ipv4 nf_log_ipv4 nf_log_common xt_LOG xt_limit xt_tcpudp xt_multiport iptable_filter ip_tables x_tables intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass intel_cstate 8021q garp mrp mei_me ipmi_ssif stp intel_rapl_perf llc joydev input_leds lpc_ich mei ioatdma shpchp ipmi_si ipmi_devintf ipmi_msghandler acpi_pad acpi_power_meter mac_hid ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 btrfs zstd_compress ses enclosure raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid0 multipath linear ast i2c_algo_bit ixgbe ttm crct10dif_pclmul crc32_pclmul drm_kms_helper ghash_clmulni_intel syscopyarea
Nov 02 01:58:31 backuprasia kernel: [205245.441911]  pcbc sysfillrect aesni_intel sysimgblt fb_sys_fops aes_x86_64 raid1 hid_generic crypto_simd usbhid dca glue_helper mpt3sas ahci ptp raid_class drm r8169 hid mxm_wmi cryptd libahci pps_core scsi_transport_sas mii mdio wmi
Nov 02 01:58:31 backuprasia kernel:  pcbc sysfillrect aesni_intel sysimgblt fb_sys_fops aes_x86_64 raid1 hid_generic crypto_simd usbhid dca glue_helper mpt3sas ahci ptp rai
Nov 02 01:58:31 backuprasia kernel: CPU: 8 PID: 14381 Comm: btrfs-transacti Not tainted 4.15.0-38-generic #41~16.04.1-Ubuntu
Nov 02 01:58:31 backuprasia kernel: Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 2.1 09/13/2016
Nov 02 01:58:31 backuprasia kernel: RIP: 0010:btrfs_start_dirty_block_groups+0x260/0x430 [btrfs]
Nov 02 01:58:31 backuprasia kernel: RSP: 0018:ffffb7b60efbbdc0 EFLAGS: 00010282
Nov 02 01:58:31 backuprasia kernel: RAX: 0000000000000000 RBX: ffff8bd5d4a1bc30 RCX: 0000000000000006
Nov 02 01:58:31 backuprasia kernel: RDX: 0000000000000007 RSI: 0000000000000092 RDI: ffff8bd77f416490
Nov 02 01:58:31 backuprasia kernel: RBP: ffffb7b60efbbe30 R08: 0000000000000001 R09: 0000000000000539
Nov 02 01:58:31 backuprasia kernel: R10: 0000000000000000 R11: 0000000000000539 R12: ffff8bd60128e800
Nov 02 01:58:31 backuprasia kernel: R13: 0000000000000001 R14: ffff8bd1d1ce32a0 R15: ffff8bd60128e948
Nov 02 01:58:31 backuprasia kernel: FS:  0000000000000000(0000) GS:ffff8bd77f400000(0000) knlGS:0000000000000000
Nov 02 01:58:31 backuprasia kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 02 01:58:31 backuprasia kernel: CR2: 00007fc65cfc6868 CR3: 0000000f8e80a003 CR4: 00000000003606e0
Nov 02 01:58:31 backuprasia kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 02 01:58:31 backuprasia kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Nov 02 01:58:31 backuprasia kernel: Call Trace:
Nov 02 01:58:31 backuprasia kernel:  btrfs_commit_transaction+0x15b/0x930 [btrfs]
Nov 02 01:58:31 backuprasia kernel:  ? start_transaction+0x9b/0x440 [btrfs]
Nov 02 01:58:31 backuprasia kernel:  transaction_kthread+0x1a6/0x1c0 [btrfs]
Nov 02 01:58:31 backuprasia kernel:  kthread+0x105/0x140
Nov 02 01:58:31 backuprasia kernel:  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
Nov 02 01:58:31 backuprasia kernel:  ? kthread_destroy_worker+0x50/0x50
Nov 02 01:58:31 backuprasia kernel:  ? do_syscall_64+0x73/0x130
Nov 02 01:58:31 backuprasia kernel:  ? SyS_exit_group+0x14/0x20
Nov 02 01:58:31 backuprasia kernel:  ret_from_fork+0x35/0x40
Nov 02 01:58:31 backuprasia kernel: Code: ff ff 48 8b 53 60 f0 0f ba aa d8 cd 00 00 02 72 1f 83 f8 fb 0f 84 a9 01 00 00 89 c6 48 c7 c7 58 a6 4a c0 89 45 a8 e8 90 6e 68 d1 <
Nov 02 01:58:31 backuprasia kernel: ---[ end trace eb0162431be8822a ]---


root@backuprasia:~# grep data /etc/fstab
/dev/mapper/datavg-backup1 /data        btrfs   compress=none,nospace_cache,noatime 0 0


-- 
Ari Saastamoinen
