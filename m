Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:33262 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdGHE1M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Jul 2017 00:27:12 -0400
Received: by mail-yw0-f182.google.com with SMTP id x125so20148378ywa.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Jul 2017 21:27:12 -0700 (PDT)
MIME-Version: 1.0
From: Adam Bahe <adambahe@gmail.com>
Date: Fri, 7 Jul 2017 23:26:31 -0500
Message-ID: <CACzgC9j026GHxX9m8=1iaYyV9ejFrzaC3nqwgn+j_awXA7D_Lw@mail.gmail.com>
Subject: raid10 array lost with single disk failure?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I have a 18 device raid10 array that has recently stopped working.
Seems like whenever my array tries to mount, it sits there with all
disks doing I/O but never fully mounts. Eventually after a few minutes
of attempting to mount the entire system locks up. This is as best I
could get out of the logs before it froze up on me:


[  851.358139] BTRFS: device label btrfs_pool1 devid 18 transid 1546569 /dev/sds

[  856.247402] BTRFS info (device sds): disk space caching is enabled

[  856.247405] BTRFS info (device sds): has skinny extents

[  968.236099] perf: interrupt took too long (2524 > 2500), lowering
kernel.perf_event_max_sample_rate to 79000

[  969.375296] BUG: unable to handle kernel NULL pointer dereference
at 00000000000001f0

[  969.376583] IP: can_overcommit+0x1d/0x110 [btrfs]

[  969.377707] PGD 0

[  969.379870] Oops: 0000 [#1] SMP

[  969.380932] Modules linked in: dm_mod 8021q garp mrp rpcrdma
ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi
ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm
ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core ext4 jbd2
mbcache sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_helper cryptd
intel_cstate iTCO_wdt iTCO_vendor_support intel_rapl_perf mei_me ses
lpc_ich pcspkr input_leds joydev enclosure i2c_i801 mfd_core mei sg
ioatdma wmi shpchp ipmi_si ipmi_devintf ipmi_msghandler
acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc
ip_tables btrfs xor raid6_pq mlx4_en sd_mod crc32c_intel mlx4_core ast
i2c_algo_bit drm_kms_helper

[  969.389915]  syscopyarea ata_generic sysfillrect pata_acpi
sysimgblt fb_sys_fops ttm ixgbe drm mdio mpt3sas ptp pps_core
raid_class ata_piix dca scsi_transport_sas libata fjes

[  969.392846] CPU: 35 PID: 20864 Comm: kworker/u97:10 Tainted: G
    I     4.10.6-1.el7.elrepo.x86_64 #1

[  969.394344] Hardware name: Supermicro Super Server/X10DRi-T4+, BIOS
2.0 12/17/2015


I did recently upgrade the kernel a few days ago from
4.8.7-1.el7.elrepo.x86_64 to 4.10.6-1.el7.elrepo.x86_64. I had also
added a new 6TB disk a few days ago but I'm not sure if the balance
finished as it locked up sometime today when I was at work. Any ideas
how I can recover? Even if I have 1 bad disk, raid10 should have kept
my data safe no? Is there anything I can do to recover?
