Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:39910 "EHLO
	corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbcDUNBs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 09:01:48 -0400
Received: from imap33.zoner.com (imap33.zoner.com [217.198.123.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by corp-mailer.zoner.com (Postfix) with ESMTPS id A975D1E850
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 14:53:42 +0200 (CEST)
Received: from [10.1.0.143] (gw-sady.zoner.com [217.198.112.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: martin.svec@zoner.com)
	by imap33.zoner.com (Postfix) with ESMTPSA id A3F89180059F06
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 14:53:42 +0200 (CEST)
From: Martin Svec <martin.svec@zoner.cz>
Subject: btrfs forced readonly + errno=-28 No space left
To: linux-btrfs@vger.kernel.org
Message-ID: <022276ed-577c-5616-abc0-3e1a7644f31e@zoner.cz>
Date: Thu, 21 Apr 2016 14:53:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

we use btrfs subvolumes for rsync-based backups. During backups btrfs often fails with "No space
left" error and goes to readonly mode (dmesg output is below) while there's still plenty of
unallocated space:

$ btrfs fi df /backup
Data, single: total=15.75TiB, used=15.72TiB
System, DUP: total=8.00MiB, used=1.91MiB
Metadata, DUP: total=148.00GiB, used=146.20GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

$ btrfs fi show /dev/md2
Label: none  uuid: 32892e65-f78d-45a3-a7c4-980fedc14e63
        Total devices 1 FS bytes used 15.86TiB
        devid    1 size 21.83TiB used 16.03TiB path /dev/md2

$ btrfs file usage /backup
Overall:
    Device size:                  21.83TiB
    Device allocated:             16.02TiB
    Device unallocated:            5.81TiB
    Device missing:                  0.00B
    Used:                         15.94TiB
    Free (estimated):              5.89TiB      (min: 2.98TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 296.64MiB)
Data,single: Size:15.73TiB, Used:15.65TiB
   /dev/md2       15.73TiB
Metadata,DUP: Size:148.00GiB, Used:146.07GiB
   /dev/md2      296.00GiB
System,DUP: Size:8.00MiB, Used:1.91MiB
   /dev/md2       16.00MiB
Unallocated:
   /dev/md2        5.81TiB

It usually helps to rebalance 100% of metadata but the error reappears again after few days or
weeks. I also tried "btrfs check --repair" but it requires approx. 45 GB of RAM/swap and crashes
after several days of swapping.

Btrfs runs on top of a single MD RAID1 device and is mounted with the following options:

$ cat /proc/mounts
/dev/md2 /backup btrfs
rw,noatime,compress=lzo,space_cache,clear_cache,enospc_debug,subvolid=5,subvol=/ 0 0

Kernel version: 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.3-7~bpo8+1 (2016-01-19) x86_64 GNU/Linux
(jessie-backports)

[2151517.510044] BTRFS info (device md2): disk space caching is enabled
[2151517.510047] BTRFS: has skinny extents
[2266753.904426] use_block_rsv: 307 callbacks suppressed
[2266753.904430] ------------[ cut here ]------------
[2266753.904453] WARNING: CPU: 7 PID: 17513 at
/build/linux-kTc2b3/linux-4.3.3/fs/btrfs/extent-tree.c:7637 btrfs_alloc_tree_block+0x107/0x480 [btrfs]()
[2266753.904481] BTRFS: block rsv returned -28
[2266753.904483] Modules linked in: binfmt_misc xt_comment xt_tcpudp nf_conntrack_ipv6
nf_defrag_ipv6 iptable_filter xt_conntrack iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter ip6table_mangle ip6table_raw iptable_mangle
ip6_tables ip_tables x_tables nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc
intel_powerc lamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul iTCO_wdt iTCO_vendor_support
sha256_ssse3 sha256_generic hmac drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd ast ttm drm_kms_helper drm i2c_ismt i2c_i801 joydev evdev tpm_tis ipmi_si tpm
serio_raw acpi_cpufreq ipmi_msghandler 8250_fintek lpc_ich mfd_core shpchp pcspkr processor button
autofs4 xfs libcrc32c btrfs xor raid6_pq dm_mod
[2266753.904552]  raid10 raid1 hid_generic usbhid hid md_mod sg sd_mod ahci libahci crc32c_intel
ehci_pci mpt2sas ehci_hcd raid_class libata scsi_transport_sas igb i2c_algo_bit usbcore dca ptp
usb_common scsi_mod pps_core
[2266753.904574] CPU: 7 PID: 17513 Comm: kworker/u16:10 Tainted: G        W      
4.3.0-0.bpo.1-amd64 #1 Debian 4.3.3-7~bpo8+1
[2266753.904576] Hardware name: Supermicro SSG-5018A-AR12L/A1SA7, BIOS 1.0a 07/09/2014
[2266753.904597] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[2266753.904600]  0000000000000000 00000000071448ef ffffffff812e1889 ffff880003637868
[2266753.904604]  ffffffff81074451 ffff880265c3e000 ffff8800036378c0 0000000000004000
[2266753.904608]  ffff880339498970 0000000000000001 ffffffff810744dc ffffffffa0341c18
[2266753.904612] Call Trace:
[2266753.904620]  [<ffffffff812e1889>] ? dump_stack+0x40/0x57
[2266753.904625]  [<ffffffff81074451>] ? warn_slowpath_common+0x81/0xb0
[2266753.904629]  [<ffffffff810744dc>] ? warn_slowpath_fmt+0x5c/0x80
[2266753.904643]  [<ffffffffa02b06d7>] ? btrfs_alloc_tree_block+0x107/0x480 [btrfs]
[2266753.904649]  [<ffffffff8101472c>] ? __switch_to+0x25c/0x590
[2266753.904662]  [<ffffffffa0298645>] ? __btrfs_cow_block+0x145/0x5e0 [btrfs]
[2266753.904674]  [<ffffffffa0298c6f>] ? btrfs_cow_block+0x10f/0x1b0 [btrfs]
[2266753.904687]  [<ffffffffa029c86d>] ? btrfs_search_slot+0x1fd/0xa30 [btrfs]
[2266753.904705]  [<ffffffffa02deefd>] ? insert_state+0xbd/0x130 [btrfs]
[2266753.904718]  [<ffffffffa02a2f5e>] ? lookup_inline_extent_backref+0xee/0x650 [btrfs]
[2266753.904723]  [<ffffffff8116b801>] ? __set_page_dirty_nobuffers+0xe1/0x140
[2266753.904728]  [<ffffffff811b76dc>] ? kmem_cache_alloc+0x21c/0x440
[2266753.904741]  [<ffffffffa02a5bcd>] ? __btrfs_free_extent.isra.66+0x11d/0xd60 [btrfs]
[2266753.904754]  [<ffffffffa02a5887>] ? update_block_group.isra.65+0x127/0x350 [btrfs]
[2266753.904773]  [<ffffffffa030bde6>] ? btrfs_merge_delayed_refs+0x66/0x5e0 [btrfs]
[2266753.904787]  [<ffffffffa02a9e31>] ? __btrfs_run_delayed_refs+0x8b1/0x1080 [btrfs]
[2266753.904801]  [<ffffffffa02ad2c8>] ? btrfs_run_delayed_refs+0x78/0x2b0 [btrfs]
[2266753.904815]  [<ffffffffa02ad532>] ? delayed_ref_async_start+0x32/0x80 [btrfs]
[2266753.904833]  [<ffffffffa02f288c>] ? normal_work_helper+0xbc/0x240 [btrfs]
[2266753.904837]  [<ffffffff8108c53a>] ? process_one_work+0x14a/0x3d0
[2266753.904841]  [<ffffffff8108cf75>] ? worker_thread+0x65/0x460
[2266753.904844]  [<ffffffff8108cf10>] ? rescuer_thread+0x310/0x310
[2266753.904847]  [<ffffffff8109222f>] ? kthread+0xdf/0x100
[2266753.904851]  [<ffffffff81092150>] ? kthread_park+0x50/0x50
[2266753.904856]  [<ffffffff8158a79f>] ? ret_from_fork+0x3f/0x70
[2266753.904860]  [<ffffffff81092150>] ? kthread_park+0x50/0x50
[2266753.904862] ---[ end trace 42f58946d98c8b1f ]---
[2266753.904870] ------------[ cut here ]------------
[2266753.904884] WARNING: CPU: 7 PID: 17513 at
/build/linux-kTc2b3/linux-4.3.3/fs/btrfs/extent-tree.c:6362 __btrfs_free_extent.isra.66+0x15b/0xd60
[btrfs]()
[2266753.904886] BTRFS: Transaction aborted (error -28)
[2266753.904888] Modules linked in: binfmt_misc
[2266753.904894] BTRFS: error (device md2) in __btrfs_free_extent:6362: errno=-28 No space left
[2266753.904898] BTRFS info (device md2): forced readonly
[2266753.904900] BTRFS: error (device md2) in btrfs_run_delayed_refs:2858: errno=-28 No space left
[2266753.905033]  xt_comment xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 iptable_filter xt_conntrack
iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
ip6table_filter ip6table_mangle ip6table_raw iptable_mangle ip6_tables ip_tables x_tables nfsd
auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc intel_powerclamp coretemp kvm_intel
kvm cr ct10dif_pclmul crc32_pclmul iTCO_wdt iTCO_vendor_support sha256_ssse3 sha256_generic hmac
drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ast ttm
drm_kms_helper drm i2c_ismt i2c_i801 joydev evdev tpm_tis ipmi_si tpm serio_raw acpi_cpufreq
ipmi_msghandler 8250_fintek lpc_ich mfd_core shpchp pcspkr processor button autofs4 xfs libcrc32c
btrfs xor raid6_pq dm_mod raid10 raid1 hid_generic
[2266753.905083]  usbhid hid md_mod sg sd_mod ahci libahci crc32c_intel ehci_pci mpt2sas ehci_hcd
raid_class libata scsi_transport_sas igb i2c_algo_bit usbcore dca ptp usb_common scsi_mod pps_core
[2266753.905098] CPU: 7 PID: 17513 Comm: kworker/u16:10 Tainted: G        W      
4.3.0-0.bpo.1-amd64 #1 Debian 4.3.3-7~bpo8+1
[2266753.905101] Hardware name: Supermicro SSG-5018A-AR12L/A1SA7, BIOS 1.0a 07/09/2014
[2266753.905119] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[2266753.905121]  0000000000000000 00000000071448ef ffffffff812e1889 ffff880003637b20
[2266753.905125]  ffffffff81074451 00000eed78f28000 ffff880003637b78 ffff880265c3e000
[2266753.905129]  ffff880468aa2000 0000000000000000 ffffffff810744dc ffffffffa03417e8
[2266753.905133] Call Trace:
[2266753.905137]  [<ffffffff812e1889>] ? dump_stack+0x40/0x57
[2266753.905140]  [<ffffffff81074451>] ? warn_slowpath_common+0x81/0xb0
[2266753.905144]  [<ffffffff810744dc>] ? warn_slowpath_fmt+0x5c/0x80
[2266753.905158]  [<ffffffffa02a5c0b>] ? __btrfs_free_extent.isra.66+0x15b/0xd60 [btrfs]
[2266753.905171]  [<ffffffffa02a5887>] ? update_block_group.isra.65+0x127/0x350 [btrfs]
[2266753.905189]  [<ffffffffa030bde6>] ? btrfs_merge_delayed_refs+0x66/0x5e0 [btrfs]
[2266753.905203]  [<ffffffffa02a9e31>] ? __btrfs_run_delayed_refs+0x8b1/0x1080 [btrfs]
[2266753.905217]  [<ffffffffa02ad2c8>] ? btrfs_run_delayed_refs+0x78/0x2b0 [btrfs]
[2266753.905231]  [<ffffffffa02ad532>] ? delayed_ref_async_start+0x32/0x80 [btrfs]
[2266753.905249]  [<ffffffffa02f288c>] ? normal_work_helper+0xbc/0x240 [btrfs]
[2266753.905253]  [<ffffffff8108c53a>] ? process_one_work+0x14a/0x3d0
[2266753.905256]  [<ffffffff8108cf75>] ? worker_thread+0x65/0x460
[2266753.905259]  [<ffffffff8108cf10>] ? rescuer_thread+0x310/0x310
[2266753.905263]  [<ffffffff8109222f>] ? kthread+0xdf/0x100
[2266753.905266]  [<ffffffff81092150>] ? kthread_park+0x50/0x50
[2266753.905270]  [<ffffffff8158a79f>] ? ret_from_fork+0x3f/0x70
[2266753.905273]  [<ffffffff81092150>] ? kthread_park+0x50/0x50
[2266753.905276] ---[ end trace 42f58946d98c8b20 ]---
[2266753.905280] BTRFS: error (device md2) in __btrfs_free_extent:6362: errno=-28 No space left
[2266753.905348] BTRFS: error (device md2) in btrfs_run_delayed_refs:2858: errno=-28 No space left
[2266766.878029] pending csums is 786432

The same or similar error seems to be reported multiple times:
https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg48061.html
https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg47355.html


Best regards

Martin Svec


