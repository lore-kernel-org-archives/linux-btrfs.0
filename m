Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:32834 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdESMcp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 08:32:45 -0400
Received: by mail-ua0-f169.google.com with SMTP id e28so24933888uah.0
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 05:32:44 -0700 (PDT)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Fri, 19 May 2017 08:32:43 -0400
Message-ID: <CAJtFHURvcTVj=KcmuS40u136FXDyepGg9WQM=N-GbQm2P=nQEQ@mail.gmail.com>
Subject: enospc_debug seems to need more info, or btrfs file usage bug?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

grep btrfs /proc/mounts
/dev/sdb /mirror btrfs
rw,noatime,compress=zlib,space_cache=v2,enospc_debug,subvolid=5,subvol=/
0 0

Filesystem on 4.9.18 went read-only w/ ENOSPC. Now it is close to
full, but can't really tell why it actually filled up at that time.
Here's the dmesg:

[1491582.099306] use_block_rsv: 8 callbacks suppressed
[1491582.101405] ------------[ cut here ]------------
[1491582.103404] WARNING: CPU: 3 PID: 6933 at
/home/zumbi/linux-4.9.18/fs/btrfs/extent-tree.c:8331
btrfs_alloc_tree_block+0x3be/0x4e0 [btrfs]
[1491582.105432] BTRFS: block rsv returned -28
[1491582.105433] Modules linked in: ipmi_si nls_utf8 fuse ufs qnx4
hfsplus hfs minix ntfs vfat msdos fat jfs xfs libcrc32c crc32c_generic
mpt3sas raid_class scsi_transport_sas mptctl mptbase dell_rbu
binfmt_misc rpcsec_gss_krb5 nfsv3 nfsv4 dns_resolver nfsd auth_rpcgss
nfs_acl
sunrpc intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul
crc32_pclmul mgag200 joydev ttm ghash_clmulni_intel intel_cstate
drm_kms_helper drm dcdbas ipmi_devintf iTCO_wdt evdev
iTCO_vendor_support i2c_algo_bit intel_uncore serio_raw button
ipmi_msghandler pcspkr acpi_power_meter i7co
lpc_ich tpm_tis_core mfd_core tpm loop autofs4 ext4 crc16 jbd2
fscrypto mbcache btrfs xor raid6_pq dm_mod hid_generic usbhid hid sg
sd_mod crc32c_intel aesni_intel ehci_pci aes_x86_64
[1491582.116330]  uhci_hcd glue_helper psmouse lrw ehci_hcd gf128mul
ixgbe megaraid_sas ablk_helper cryptd usbcore scsi_mod dca ptp
pps_core usb_common bnx2 mdio [last unloaded: ipmi_si]
[1491582.120924] CPU: 3 PID: 6933 Comm: btrfs-transacti Tainted: G
   W I     4.9.0-0.bpo.2-amd64 #1 Debian 4.9.18-1~bpo8+1
[1491582.132792] Call Trace:
[1491582.135149]  [<ffffffff91129dd5>] ? dump_stack+0x5c/0x77
[1491582.137528]  [<ffffffff90e77934>] ? __warn+0xc4/0xe0
[1491582.139896]  [<ffffffff90e779af>] ? warn_slowpath_fmt+0x5f/0x80
[1491582.142298]  [<ffffffffc07a006e>] ?
btrfs_alloc_tree_block+0x3be/0x4e0 [btrfs]
[1491582.144713]  [<ffffffffc0786599>] ? __btrfs_cow_block+0x149/0x5a0 [btrfs]
[1491582.147141]  [<ffffffffc07ab101>] ? btrfs_commit_super+0x11/0x90 [btrfs]
[1491582.149568]  [<ffffffffc0786b74>] ? btrfs_cow_block+0x104/0x1e0 [btrfs]
[1491582.151990]  [<ffffffffc078a689>] ? btrfs_search_slot+0x1f9/0x9e0 [btrfs]
[1491582.154406]  [<ffffffffc0790abe>] ?
lookup_inline_extent_backref+0xee/0x640 [btrfs]
[1491582.156841]  [<ffffffffc07d2bf9>] ? set_extent_bit+0x29/0x30 [btrfs]
[1491582.159229]  [<ffffffffc0792fc4>] ?
update_block_group.isra.68+0x144/0x410 [btrfs]
[1491582.161582]  [<ffffffffc07933a7>] ?
__btrfs_free_extent.isra.69+0x117/0xd60 [btrfs]
[1491582.163896]  [<ffffffffc0803e99>] ?
btrfs_merge_delayed_refs+0x69/0x600 [btrfs]
[1491582.166159]  [<ffffffffc07982b5>] ?
__btrfs_run_delayed_refs+0xa15/0x1360 [btrfs]
[1491582.168371]  [<ffffffffc079bacf>] ?
btrfs_run_delayed_refs+0x8f/0x2b0 [btrfs]
[1491582.170538]  [<ffffffffc07b291a>] ?
btrfs_commit_transaction+0x43a/0xa40 [btrfs]
[1491582.172656]  [<ffffffffc07b2fbd>] ? start_transaction+0x9d/0x4a0 [btrfs]
[1491582.174723]  [<ffffffffc07ad382>] ? transaction_kthread+0x1b2/0x1f0 [btrfs]
[1491582.176766]  [<ffffffffc07ad1d0>] ?
btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[1491582.178761]  [<ffffffff90e97520>] ? kthread+0xe0/0x100
[1491582.180729]  [<ffffffff90e2476b>] ? __switch_to+0x2bb/0x700
[1491582.182687]  [<ffffffff90e97440>] ? kthread_park+0x60/0x60
[1491582.184631]  [<ffffffff913fc835>] ? ret_from_fork+0x25/0x30
[1491582.186585] ---[ end trace 98e911bbd6a0b34f ]---
[1491582.188576] ------------[ cut here ]------------
[1491582.190523] WARNING: CPU: 3 PID: 6933 at
/home/zumbi/linux-4.9.18/fs/btrfs/extent-tree.c:6961
__btrfs_free_extent.isra.69+0x152/0xd60 [btrfs]
[1491582.192547] BTRFS: Transaction aborted (error -28)
[1491582.208188] CPU: 3 PID: 6933 Comm: btrfs-transacti Tainted: G
   W I     4.9.0-0.bpo.2-amd64 #1 Debian 4.9.18-1~bpo8+1
[1491582.220164] Call Trace:
[1491582.222551]  [<ffffffff91129dd5>] ? dump_stack+0x5c/0x77
[1491582.224943]  [<ffffffff90e77934>] ? __warn+0xc4/0xe0
[1491582.227338]  [<ffffffff90e779af>] ? warn_slowpath_fmt+0x5f/0x80
[1491582.229754]  [<ffffffffc07933e2>] ?
__btrfs_free_extent.isra.69+0x152/0xd60 [btrfs]
[1491582.232192]  [<ffffffffc0803e99>] ?
btrfs_merge_delayed_refs+0x69/0x600 [btrfs]
[1491582.234633]  [<ffffffffc07982b5>] ?
__btrfs_run_delayed_refs+0xa15/0x1360 [btrfs]
[1491582.237081]  [<ffffffffc079bacf>] ?
btrfs_run_delayed_refs+0x8f/0x2b0 [btrfs]
[1491582.239540]  [<ffffffffc07b291a>] ?
btrfs_commit_transaction+0x43a/0xa40 [btrfs]
[1491582.241998]  [<ffffffffc07b2fbd>] ? start_transaction+0x9d/0x4a0 [btrfs]
[1491582.244453]  [<ffffffffc07ad382>] ? transaction_kthread+0x1b2/0x1f0 [btrfs]
[1491582.246910]  [<ffffffffc07ad1d0>] ?
btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[1491582.249319]  [<ffffffff90e97520>] ? kthread+0xe0/0x100
[1491582.251681]  [<ffffffff90e2476b>] ? __switch_to+0x2bb/0x700
[1491582.253984]  [<ffffffff90e97440>] ? kthread_park+0x60/0x60
[1491582.256237]  [<ffffffff913fc835>] ? ret_from_fork+0x25/0x30
[1491582.258439] ---[ end trace 98e911bbd6a0b350 ]---
[1491582.260635] BTRFS: error (device sdb) in __btrfs_free
_extent:6961: errno=-28 No space left
[1491582.262758] BTRFS info (device sdb): forced readonly
[1491582.264843] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2967: errno=-28 No space left
[1491582.266941] BTRFS warning (device sdb): Skipping commit of
aborted transaction.
[1491582.269009] BTRFS: error (device sdb) in
cleanup_transaction:1850: errno=-28 No space left

and yes, it's quite full, but still seems to have both meta-data &
data & unallocated available. Hmm, I say that and see size ==
allocated below, but Unallocated shows 39GB per device but 8MB in the
summary. btrfs --version gives btrfs-progs v4.10.2. Maybe just a
bug/display issue in btrfs file usage?

btrfs file usage -T /mirror
Overall:
    Device size:                 249.22TiB
    Device allocated:            249.22TiB
    Device unallocated:            8.00MiB
    Device missing:                  0.00B
    Used:                        245.06TiB
    Free (estimated):              4.15TiB      (min: 4.15TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 194.00MiB)

            Data      Metadata  System
Id Path     single    RAID10    RAID10   Unallocated
-- -------- --------- --------- -------- -----------
 1 /dev/sdb  29.94TiB  39.76GiB  8.00MiB    39.77GiB
 2 /dev/sdc  29.94TiB  39.76GiB  8.00MiB    39.77GiB
 3 /dev/sdd  39.94TiB  39.76GiB  8.00MiB    39.77GiB
 4 /dev/sde  39.94TiB  39.76GiB  8.00MiB    39.77GiB
 5 /dev/sdf  27.21TiB  39.76GiB  8.00MiB    39.77GiB
 6 /dev/sdg  27.21TiB  39.76GiB  8.00MiB    39.77GiB
 7 /dev/sdh  27.21TiB  39.76GiB  8.00MiB    39.77GiB
 8 /dev/sdi  27.21TiB  39.76GiB  8.00MiB    39.77GiB
-- -------- --------- --------- -------- -----------
   Total    248.60TiB 318.07GiB 64.00MiB   318.14GiB
   Used     244.45TiB 316.37GiB 37.59MiB

FYI, after umount & mount btrfs sub delete seems to be working fine so
overall things are working great.
