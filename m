Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:33822 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdH1H2J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 03:28:09 -0400
Received: by mail-wr0-f176.google.com with SMTP id z91so15888389wrc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Aug 2017 00:28:08 -0700 (PDT)
Subject: Re: cause of dmesg call traces?
To: Adam Bahe <adambahe@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACzgC9h7xiVQswvLgbSi=7bNyrO=hKV5dxO7yXz4Zy3C5Sdx0g@mail.gmail.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <0252110d-6f07-cabc-823f-c9ab5be07b67@gmail.com>
Date: Mon, 28 Aug 2017 10:28:06 +0300
MIME-Version: 1.0
In-Reply-To: <CACzgC9h7xiVQswvLgbSi=7bNyrO=hKV5dxO7yXz4Zy3C5Sdx0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.08.2017 23:30, Adam Bahe wrote:
> Hello all. Recently I added another 10TB sas drive to my btrfs array
> and I have received the following messages in dmesg during the
> balance. I was hoping someone could clarify what seems to be causing
> this.
> 
> Some additional info, I did a smartctl long test and one of my brand
> new 8TB drives warned me with this:
> 
>     197 Current_Pending_Sector 0x0022 100 100 000 Old_age Always - 136
>     # 5  Extended offline    Completed: servo/seek failure 90%
> 474         0
> 
> Are the messages in dmesg caused by the issues with the hard drive, or
> something else entirely? A few months ago I had a total failure
> requiring a complete nuke and pave so I am trying to track down any
> potential issues aggressively and appreciate any help. Thanks!
> 
> Also, how many current_pending_sectors do you tolerate before you swap
> a drive? I am going to pull this drive as soon as this current balance
> finishes. But for future reference it would be good to keep an eye on.
> 
> 
> 
> [Sat Aug 26 03:01:53 2017] WARNING: CPU: 30 PID: 5516 at
> fs/btrfs/extent-tree.c:3197 btrfs_cross_ref_exist+0xd1/0xf0 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017] Modules linked in: dm_mod rpcrdma ib_isert
> iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt
> target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm
> ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core sb_edac
> edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> irqbypass iTCO_wdt crct10dif_pclmul iTCO_vendor_support crc32_pclmul
> ghash_clmulni_intel pcbc ext4 aesni_intel jbd2 crypto_simd mbcache
> glue_helper cryptd intel_cstate intel_rapl_perf ses enclosure pcspkr
> mei_me lpc_ich input_leds i2c_i801 joydev mfd_core mei sg ioatdma
> shpchp wmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter
> acpi_pad nfsd auth_rpcgss nfs_acl 8021q lockd garp grace mrp sunrpc
> ip_tables btrfs xor raid6_pq mlx4_en sd_mod crc32c_intel mlx4_core ast
> i2c_algo_bit ata_generic
> 
> [Sat Aug 26 03:01:53 2017]  pata_acpi drm_kms_helper syscopyarea
> sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe ata_piix mdio mpt3sas
> ptp raid_class pps_core libata scsi_transport_sas dca fjes
> 
> [Sat Aug 26 03:01:53 2017] CPU: 30 PID: 5516 Comm: kworker/u97:5
> Tainted: G        W       4.10.6-1.el7.elrepo.x86_64 #1

You are not even using upstream kernel, but some redhat-like derivative.
If you'd like to get support on this list, please test with an upstream
kernel otherwise all bets are off what kind of code you might be running.


> 
> [Sat Aug 26 03:01:53 2017] Hardware name: Supermicro Super
> Server/X10DRi-T4+, BIOS 2.0 12/17/2015
> 
> [Sat Aug 26 03:01:53 2017] Workqueue: writeback wb_workfn (flush-btrfs-2)
> 
> [Sat Aug 26 03:01:53 2017] Call Trace:
> 
> [Sat Aug 26 03:01:53 2017]  dump_stack+0x63/0x87
> 
> [Sat Aug 26 03:01:53 2017]  __warn+0xd1/0xf0
> 
> [Sat Aug 26 03:01:53 2017]  warn_slowpath_null+0x1d/0x20
> 
> [Sat Aug 26 03:01:53 2017]  btrfs_cross_ref_exist+0xd1/0xf0 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  run_delalloc_nocow+0x6e7/0xc00 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  ? test_range_bit+0xd0/0x160 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  run_delalloc_range+0x7d/0x3a0 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  ?
> find_lock_delalloc_range.constprop.56+0x1d1/0x200 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  writepage_delalloc.isra.48+0x10c/0x170 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  __extent_writepage+0xd6/0x2e0 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]
> extent_write_cache_pages.isra.44.constprop.59+0x2c4/0x480 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  extent_writepages+0x5c/0x90 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  ? btrfs_submit_direct+0x8b0/0x8b0 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  btrfs_writepages+0x28/0x30 [btrfs]
> 
> [Sat Aug 26 03:01:53 2017]  do_writepages+0x1e/0x30
> 
> [Sat Aug 26 03:01:53 2017]  __writeback_single_inode+0x45/0x330
> 
> [Sat Aug 26 03:01:53 2017]  writeback_sb_inodes+0x280/0x570
> 
> [Sat Aug 26 03:01:53 2017]  __writeback_inodes_wb+0x8c/0xc0
> 
> [Sat Aug 26 03:01:53 2017]  wb_writeback+0x276/0x310
> 
> [Sat Aug 26 03:01:53 2017]  wb_workfn+0x2e1/0x410
> 
> [Sat Aug 26 03:01:53 2017]  process_one_work+0x165/0x410
> 
> [Sat Aug 26 03:01:53 2017]  worker_thread+0x137/0x4c0
> 
> [Sat Aug 26 03:01:53 2017]  kthread+0x101/0x140
> 
> [Sat Aug 26 03:01:53 2017]  ? rescuer_thread+0x3b0/0x3b0
> 
> [Sat Aug 26 03:01:53 2017]  ? kthread_park+0x90/0x90
> 
> [Sat Aug 26 03:01:53 2017]  ret_from_fork+0x2c/0x40
> 
> [Sat Aug 26 03:01:53 2017] ---[ end trace 7ba8e3b5c60c322d ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
