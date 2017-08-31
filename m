Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:36615 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbdHaLPS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 07:15:18 -0400
Received: by mail-vk0-f51.google.com with SMTP id d124so939665vkf.3
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 04:15:18 -0700 (PDT)
MIME-Version: 1.0
From: George Joseph <g@wxy78.net>
Date: Thu, 31 Aug 2017 05:14:56 -0600
Message-ID: <CAHKv19B1sfw6HFoNnsYbkjp=yH+X1fYZJyZVfYD1i8t2MtXdig@mail.gmail.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm going to pile on this thread because I have the same issue.  I've
seen this twice in just the past 2 days on a filesystem that was
created a few weeks ago.  Un-mounting and mounting again with no
special options gets the filesystem back.


[Aug31 02:59] BTRFS: Transaction aborted (error -17)
[  +0.000057] ------------[ cut here ]------------
[  +0.000021] WARNING: CPU: 4 PID: 21360 at
fs/btrfs/extent-tree.c:2971 btrfs_run_delayed_refs+0x25c/0x260 [btrfs]
[  +0.000001] Modules linked in: vmnet(OE) parport_pc
vmw_vsock_vmci_transport vsock vmw_vmci vmmon(OE) cdc_acm
rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache bnep cfg80211
nfnetlink_queue nfnetlink_log bluetooth ecdh_generic ipt_MASQUERADE
nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype xt_conntrack
nf_nat nf_conntrack libcrc32c br_netfilter bridge target_core_user uio
target_core_pscsi target_core_file target_core_iblock iscsi_target_mod
target_core_mod ppdev parport 8021q garp mrp stp llc fuse uinput
nct6775 hwmon_vid bonding intel_rapl x86_pkg_temp_thermal
intel_powerclamp ib_ipoib uvcvideo rdma_ucm videobuf2_vmalloc
eeepc_wmi asus_wmi videobuf2_memops videobuf2_v4l2 sparse_keymap
videobuf2_core snd_usb_audio coretemp ib_ucm
[  +0.000023]  iTCO_wdt rfkill crct10dif_pclmul crc32_pclmul video
iTCO_vendor_support videodev mxm_wmi snd_usbmidi_lib
ghash_clmulni_intel media snd_rawmidi ib_uverbs snd_hda_codec_realtek
snd_hda_codec_generic ib_umad snd_hda_codec_hdmi joydev snd_hda_intel
rdma_cm snd_hda_codec usblp intel_cstate snd_hda_core snd_hwdep ib_cm
snd_seq snd_seq_device intel_uncore iw_cm snd_pcm snd_timer snd mei_me
intel_rapl_perf i2c_i801 lpc_ich mei soundcore shpchp wmi mlx4_ib
ib_core tpm_tis tpm_tis_core tpm nfsd auth_rpcgss binfmt_misc nfs_acl
lockd grace sunrpc uas usb_storage mlx4_en btrfs xor amdkfd
amd_iommu_v2 radeon mlx4_core i2c_algo_bit e1000e drm_kms_helper ttm
r8169 ptp nvme raid6_pq drm crc32c_intel mii pps_core nvme_core
devlink pcspkr i2c_dev [last unloaded: vboxdrv]
[  +0.000027] CPU: 4 PID: 21360 Comm: btrfs-transacti Tainted: G
 W  OE   4.12.8-200.fc25.x86_64 #1
[  +0.000001] Hardware name: ASUS All Series/SABERTOOTH X99, BIOS 3402
08/18/2016
[  +0.000001] task: ffff9ec6f11f0000 task.stack: ffffb0ab0de2c000
[  +0.000009] RIP: 0010:btrfs_run_delayed_refs+0x25c/0x260 [btrfs]
[  +0.000001] RSP: 0018:ffffb0ab0de2fd28 EFLAGS: 00010282
[  +0.000001] RAX: 0000000000000026 RBX: ffff9ecb65040870 RCX: 0000000000000000
[  +0.000001] RDX: 0000000000000000 RSI: ffff9ecb6f10e128 RDI: ffff9ecb6f10e128
[  +0.000001] RBP: ffffb0ab0de2fd90 R08: 0000000000000001 R09: 0000000000000d20
[  +0.000001] R10: ffffb0ab0de2fc18 R11: 0000000000000d20 R12: ffff9ec493690000
[  +0.000001] R13: 00000000ffffffef R14: 00000000000000c8 R15: ffff9ecaa3a7af40
[  +0.000001] FS:  0000000000000000(0000) GS:ffff9ecb6f100000(0000)
knlGS:0000000000000000
[  +0.000001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000001] CR2: 00007f9512814002 CR3: 0000000336e09000 CR4: 00000000003406e0
[  +0.000001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  +0.000001] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  +0.000000] Call Trace:
[  +0.000013]  ? free_extent_buffer+0x4b/0xa0 [btrfs]
[  +0.000010]  btrfs_start_dirty_block_groups+0x2f1/0x480 [btrfs]
[  +0.000010]  btrfs_commit_transaction+0x130/0x930 [btrfs]
[  +0.000010]  ? start_transaction+0x8d/0x410 [btrfs]
[  +0.000009]  transaction_kthread+0x18c/0x1b0 [btrfs]
[  +0.000003]  kthread+0x109/0x140
[  +0.000009]  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
[  +0.000002]  ? kthread_park+0x60/0x60
[  +0.000002]  ret_from_fork+0x25/0x30
[  +0.000001] Code: 44 89 e9 ba 9b 0b 00 00 48 c7 c6 40 b8 72 c0 48 89
df e8 f8 b9 09 00 e9 ab fe ff ff 44 89 ee 48 c7 c7 58 18 73 c0 e8 db
88 b3 fd <0f> ff eb d1 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 53 48 8b
47
[  +0.000016] ---[ end trace 9a66996bbd24d74d ]---
[  +0.000002] BTRFS: error (device sdg1) in
btrfs_run_delayed_refs:2971: errno=-17 Object already exists
[  +0.000002] BTRFS info (device sdg1): forced readonly
[  +0.001029] BTRFS error (device sdg1): pending csums is 3145728

Label: none  uuid: d4fc5def-8b5c-4953-8d03-984a9d0dfcad
Total devices 4 FS bytes used 543.25GiB
devid    1 size 476.94GiB used 280.51GiB path /dev/sdd1
devid    2 size 476.94GiB used 280.51GiB path /dev/sde1
devid    3 size 476.94GiB used 280.51GiB path /dev/sdf1
devid    4 size 476.94GiB used 280.51GiB path /dev/sdg1

---These are 4 SSDs on the motherboard's X99 SATA-III controller

Data, RAID10: total=554.00GiB, used=538.33GiB
System, RAID10: total=16.00MiB, used=80.00KiB
Metadata, RAID10: total=7.00GiB, used=4.92GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Overall:
    Device size:   1.86TiB
    Device allocated:   1.10TiB
    Device unallocated: 785.72GiB
    Device missing:     0.00B
    Used:   1.06TiB
    Free (estimated): 408.53GiB (min: 408.53GiB)
    Data ratio:      2.00
    Metadata ratio:      2.00
    Global reserve: 512.00MiB (used: 0.00B)
