Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33576 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdGHElB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Jul 2017 00:41:01 -0400
Received: by mail-yw0-f181.google.com with SMTP id x125so20199925ywa.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Jul 2017 21:41:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACzgC9j026GHxX9m8=1iaYyV9ejFrzaC3nqwgn+j_awXA7D_Lw@mail.gmail.com>
References: <CACzgC9j026GHxX9m8=1iaYyV9ejFrzaC3nqwgn+j_awXA7D_Lw@mail.gmail.com>
From: Adam Bahe <adambahe@gmail.com>
Date: Fri, 7 Jul 2017 23:40:20 -0500
Message-ID: <CACzgC9i4Eb2=xKpF02Czr432r1WQkhTx+8tZswsgw5EUfofJsg@mail.gmail.com>
Subject: Re: raid10 array lost with single disk failure?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some additional information. I am running Rockstor just like Daniel
Brady noted in his post just before mine titled "Chunk root problem".
Sorry I am somewhat unfamiliar with newsgroups so I am not sure how to
reply to his thread before I was subscribed. But I am noticing
something in my logs very similar to his, I get:

[  716.902506] BTRFS error (device sdb): failed to read the system array: -5
[  716.918284] BTRFS error (device sdb): open_ctree failed
[  717.004162] BTRFS warning (device sdb): 'recovery' is deprecated,
use 'usebackuproot' instead
[  717.004165] BTRFS info (device sdb): trying to use backup root at mount time
[  717.004167] BTRFS info (device sdb): disk space caching is enabled
[  717.004168] BTRFS info (device sdb): has skinny extents
[  717.005673] BTRFS error (device sdb): failed to read the system array: -5
[  717.020248] BTRFS error (device sdb): open_ctree failed

He also received a similar open_ctree failed message after he upgraded
his kernel on Rockstor to 4.10.6-1.el7.elrepo.x86_64 and
btrfs-progs-4.10.1-0.rockstor.x86_64.

On Fri, Jul 7, 2017 at 11:26 PM, Adam Bahe <adambahe@gmail.com> wrote:
> Hello all,
>
> I have a 18 device raid10 array that has recently stopped working.
> Seems like whenever my array tries to mount, it sits there with all
> disks doing I/O but never fully mounts. Eventually after a few minutes
> of attempting to mount the entire system locks up. This is as best I
> could get out of the logs before it froze up on me:
>
>
> [  851.358139] BTRFS: device label btrfs_pool1 devid 18 transid 1546569 /dev/sds
>
> [  856.247402] BTRFS info (device sds): disk space caching is enabled
>
> [  856.247405] BTRFS info (device sds): has skinny extents
>
> [  968.236099] perf: interrupt took too long (2524 > 2500), lowering
> kernel.perf_event_max_sample_rate to 79000
>
> [  969.375296] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000001f0
>
> [  969.376583] IP: can_overcommit+0x1d/0x110 [btrfs]
>
> [  969.377707] PGD 0
>
> [  969.379870] Oops: 0000 [#1] SMP
>
> [  969.380932] Modules linked in: dm_mod 8021q garp mrp rpcrdma
> ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi
> ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm
> ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core ext4 jbd2
> mbcache sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_helper cryptd
> intel_cstate iTCO_wdt iTCO_vendor_support intel_rapl_perf mei_me ses
> lpc_ich pcspkr input_leds joydev enclosure i2c_i801 mfd_core mei sg
> ioatdma wmi shpchp ipmi_si ipmi_devintf ipmi_msghandler
> acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc
> ip_tables btrfs xor raid6_pq mlx4_en sd_mod crc32c_intel mlx4_core ast
> i2c_algo_bit drm_kms_helper
>
> [  969.389915]  syscopyarea ata_generic sysfillrect pata_acpi
> sysimgblt fb_sys_fops ttm ixgbe drm mdio mpt3sas ptp pps_core
> raid_class ata_piix dca scsi_transport_sas libata fjes
>
> [  969.392846] CPU: 35 PID: 20864 Comm: kworker/u97:10 Tainted: G
>     I     4.10.6-1.el7.elrepo.x86_64 #1
>
> [  969.394344] Hardware name: Supermicro Super Server/X10DRi-T4+, BIOS
> 2.0 12/17/2015
>
>
> I did recently upgrade the kernel a few days ago from
> 4.8.7-1.el7.elrepo.x86_64 to 4.10.6-1.el7.elrepo.x86_64. I had also
> added a new 6TB disk a few days ago but I'm not sure if the balance
> finished as it locked up sometime today when I was at work. Any ideas
> how I can recover? Even if I have 1 bad disk, raid10 should have kept
> my data safe no? Is there anything I can do to recover?
