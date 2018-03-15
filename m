Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpmx03.bayer.de ([212.64.225.222]:18195 "EHLO
        smtpmx03.bayer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbeCOUC0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 16:02:26 -0400
From: Mike Stevens <michael.stevens@bayer.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Crashes running btrfs scrub
Date: Thu, 15 Mar 2018 18:58:17 +0000
Message-ID: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First, the required information
 
~ $ uname -a
Linux auswscs9903 3.10.0-693.21.1.el7.x86_64 #1 SMP Wed Mar 7 19:03:37 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
 ~ $ btrfs --version
btrfs-progs v4.9.1
 ~ $ sudo btrfs fi show
Label: none  uuid: 77afc2bb-f7a8-4ce9-9047-c031f7571150
        Total devices 34 FS bytes used 89.06TiB
        devid    1 size 5.46TiB used 4.72TiB path /dev/sdb
        devid    2 size 5.46TiB used 4.72TiB path /dev/sda
        devid    3 size 5.46TiB used 4.72TiB path /dev/sdx
        devid    4 size 5.46TiB used 4.72TiB path /dev/sdt
        devid    5 size 5.46TiB used 4.72TiB path /dev/sdz
        devid    6 size 5.46TiB used 4.72TiB path /dev/sdv
        devid    7 size 5.46TiB used 4.72TiB path /dev/sdab
        devid    8 size 5.46TiB used 4.72TiB path /dev/sdw
        devid    9 size 5.46TiB used 4.72TiB path /dev/sdad
        devid   10 size 5.46TiB used 4.72TiB path /dev/sdaa
        devid   11 size 5.46TiB used 4.72TiB path /dev/sdr
        devid   12 size 5.46TiB used 4.72TiB path /dev/sdy
        devid   13 size 5.46TiB used 4.72TiB path /dev/sdj
        devid   14 size 5.46TiB used 4.72TiB path /dev/sdaf
        devid   15 size 5.46TiB used 4.72TiB path /dev/sdag
        devid   16 size 5.46TiB used 4.72TiB path /dev/sdh
        devid   17 size 5.46TiB used 4.72TiB path /dev/sdu
        devid   18 size 5.46TiB used 4.72TiB path /dev/sdac
        devid   19 size 5.46TiB used 4.72TiB path /dev/sdk
        devid   20 size 5.46TiB used 4.72TiB path /dev/sdah
        devid   21 size 5.46TiB used 4.72TiB path /dev/sdp
        devid   22 size 5.46TiB used 4.72TiB path /dev/sdae
        devid   23 size 5.46TiB used 4.72TiB path /dev/sdc
        devid   24 size 5.46TiB used 4.72TiB path /dev/sdl
        devid   25 size 5.46TiB used 4.72TiB path /dev/sdo
        devid   26 size 5.46TiB used 4.72TiB path /dev/sdd
        devid   27 size 5.46TiB used 4.72TiB path /dev/sdi
        devid   28 size 5.46TiB used 4.72TiB path /dev/sdn
        devid   29 size 5.46TiB used 4.72TiB path /dev/sds
        devid   30 size 5.46TiB used 4.72TiB path /dev/sdm
        devid   31 size 5.46TiB used 4.72TiB path /dev/sdf
        devid   32 size 5.46TiB used 4.72TiB path /dev/sdq
        devid   33 size 5.46TiB used 4.72TiB path /dev/sdg
        devid   34 size 5.46TiB used 4.72TiB path /dev/sde

 ~ $ sudo btrfs fi df /gpfs_backups
Data, RAID6: total=150.82TiB, used=88.88TiB
System, RAID6: total=512.00MiB, used=19.08MiB
Metadata, RAID6: total=191.00GiB, used=187.38GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

I was running a btrfs balance, which crashed.  Since then, I cannot do anything on the filesystems that does any real i/o, or it quickly goes read only.  Running btrfs scrub results in this crash:

Mar 15 11:10:43 auswscs9903 kernel: WARNING: CPU: 1 PID: 4588 at fs/btrfs/extent-tree.c:10367 btrfs_create_pending_block_groups+0x23e/0x240 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: Modules linked in: nfsv3 nfs fscache mpt3sas mpt2sas raid_class mptctl mptbase binfmt_misc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_comment xt_multiport xt_conntrack nf_conntrack libcrc32c iptable_filter dm_mirror dm_region_hash dm_log dm_mod iTCO_wdt iTCO_vendor_support btrfs sb_edac edac_core intel_powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd raid6_pq xor pcspkr joydev ses enclosure scsi_transport_sas sg mei_me i2c_i801 mei lpc_ich ioatdma shpchp wmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad nfsd nfs_acl lockd auth_rpcgss grace sunrpc ip_tables ext4 mbcache jbd2 sd_mod crc_t10dif crct10dif_generic ast drm_kms_helper syscopyarea sysfillrect
Mar 15 11:10:43 auswscs9903 kernel: sysimgblt fb_sys_fops ttm drm ahci igb libahci libata crct10dif_pclmul crct10dif_common crc32c_intel megaraid_sas ptp pps_core i2c_algo_bit myri10ge i2c_core dca
Mar 15 11:10:43 auswscs9903 kernel: CPU: 1 PID: 4588 Comm: btrfs Tainted: G        W      ------------   3.10.0-693.21.1.el7.x86_64 #1
Mar 15 11:10:43 auswscs9903 kernel: Hardware name: Supermicro Super Server/X10DRL-i, BIOS 1.1b 09/11/2015
Mar 15 11:10:43 auswscs9903 kernel: Call Trace:
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff816ae7c8>] dump_stack+0x19/0x1b
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff8108ae58>] __warn+0xd8/0x100
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff8108aedf>] warn_slowpath_fmt+0x5f/0x80
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0ac2fd2>] ? btrfs_finish_chunk_alloc+0x222/0x5e0 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0a7cb7e>] btrfs_create_pending_block_groups+0x23e/0x240 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0a7d215>] do_chunk_alloc+0x2f5/0x330 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0a816ee>] btrfs_inc_block_group_ro+0x18e/0x1b0 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0afad47>] scrub_enumerate_chunks+0x207/0x6a0 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff810c79ec>] ? try_to_wake_up+0x18c/0x350
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff816b2c00>] ? __ww_mutex_lock+0x40/0xa0
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0afc5f3>] btrfs_scrub_dev+0x233/0x5a0 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0ad2a00>] ? btrfs_ioctl+0xdc0/0x2d30 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0ad2a59>] btrfs_ioctl+0xe19/0x2d30 [btrfs]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc026b1f1>] ? ext4_filemap_fault+0x41/0x50 [ext4]
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff81186deb>] ? unlock_page+0x2b/0x30
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff811b1f16>] ? do_read_fault.isra.44+0xe6/0x130
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff811e4629>] ? kmem_cache_alloc_node+0x109/0x200
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff811b6781>] ? handle_mm_fault+0x691/0xfa0
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff81121930>] ? audit_filter_rules.isra.8+0x280/0xf90
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff81219e90>] do_vfs_ioctl+0x350/0x560
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff8121a141>] SyS_ioctl+0xa1/0xc0
Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff816c0715>] system_call_fastpath+0x1c/0x21

As far as I can tell the hardware seem fine.  I've updated from CentOS 7.2 to the most current version, but the problem persists.  How best to address this problem?

Freundliche Grüße / Best regards,
 
Mike Stevens
Senior Systems Administrator - SC3


________________________________________________________________________
The information contained in this e-mail is for the exclusive use of the 
intended recipient(s) and may be confidential, proprietary, and/or 
legally privileged.  Inadvertent disclosure of this message does not 
constitute a waiver of any privilege.  If you receive this message in 
error, please do not directly or indirectly use, print, copy, forward,
or disclose any part of this message.  Please also delete this e-mail 
and all copies and notify the sender.  Thank you. 
________________________________________________________________________
