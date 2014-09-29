Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:52337 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaI2MAW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 08:00:22 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id ECB0A448229
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Sep 2014 14:00:18 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 3.17.0-rc6 system freeze
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 29 Sep 2014 14:00:18 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <a02fcec6b3069c7d69e6453725d624e5@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

System froze under 3.17.0-rc6 with btrfs. It had to be hard rebooted.

Sep 29 05:50:21 bkp010 kernel: [559018.459704] NMI watchdog: BUG: soft 
lockup - CPU#6 stuck for 22s! [kworker/u16:24:16872]
Sep 29 05:50:21 bkp010 kernel: [559018.459705] NMI watchdog: BUG: soft 
lockup - CPU#2 stuck for 22s! [kworker/u16:8:17271]
Sep 29 05:50:21 bkp010 kernel: [559018.459707] NMI watchdog: BUG: soft 
lockup - CPU#0 stuck for 22s! [kworker/u16:11:17272]
Sep 29 05:50:21 bkp010 kernel: [559018.459709] Modules linked in:
Sep 29 05:50:21 bkp010 kernel: [559018.459710] Modules linked in:
Sep 29 05:50:21 bkp010 kernel: [559018.459711]  ipt_MASQUERADE
Sep 29 05:50:21 bkp010 kernel: [559018.459711]  ipt_MASQUERADE
Sep 29 05:50:21 bkp010 kernel: [559018.459712]  iptable_nat
Sep 29 05:50:21 bkp010 kernel: [559018.459712]  iptable_nat
Sep 29 05:50:21 bkp010 kernel: [559018.459713]  nf_conntrack_ipv4
Sep 29 05:50:21 bkp010 kernel: [559018.459713]  nf_conntrack_ipv4
Sep 29 05:50:21 bkp010 kernel: [559018.459714]  nf_defrag_ipv4
Sep 29 05:50:21 bkp010 kernel: [559018.459714]  nf_defrag_ipv4
Sep 29 05:50:21 bkp010 kernel: [559018.459714]  nf_nat_ipv4
Sep 29 05:50:21 bkp010 kernel: [559018.459715]  nf_nat_ipv4
Sep 29 05:50:21 bkp010 kernel: [559018.459715]  nf_nat
Sep 29 05:50:21 bkp010 kernel: [559018.459716]  nf_nat
Sep 29 05:50:21 bkp010 kernel: [559018.459716]  nf_conntrack
Sep 29 05:50:21 bkp010 kernel: [559018.459717]  nf_conntrack
Sep 29 05:50:21 bkp010 kernel: [559018.459717]  ip_tables
Sep 29 05:50:21 bkp010 kernel: [559018.459718]  ip_tables
Sep 29 05:50:21 bkp010 kernel: [559018.459718]  x_tables
Sep 29 05:50:21 bkp010 kernel: [559018.459719]  x_tables
Sep 29 05:50:21 bkp010 kernel: [559018.459719]  cpufreq_ondemand
Sep 29 05:50:21 bkp010 kernel: [559018.459720]  cpufreq_ondemand
Sep 29 05:50:21 bkp010 kernel: [559018.459720]  cpufreq_conservative
Sep 29 05:50:21 bkp010 kernel: [559018.459720]  cpufreq_conservative
Sep 29 05:50:21 bkp010 kernel: [559018.459721]  cpufreq_powersave
Sep 29 05:50:21 bkp010 kernel: [559018.459721]  cpufreq_powersave
Sep 29 05:50:21 bkp010 kernel: [559018.459721]  cpufreq_stats
Sep 29 05:50:21 bkp010 kernel: [559018.459722]  cpufreq_stats
Sep 29 05:50:21 bkp010 kernel: [559018.459722]  bridge
Sep 29 05:50:21 bkp010 kernel: [559018.459723]  bridge
Sep 29 05:50:21 bkp010 kernel: [559018.459723]  stp
Sep 29 05:50:21 bkp010 kernel: [559018.459723]  stp
Sep 29 05:50:21 bkp010 kernel: [559018.459724]  llc
Sep 29 05:50:21 bkp010 kernel: [559018.459724]  llc
Sep 29 05:50:21 bkp010 kernel: [559018.459724]  ipv6
Sep 29 05:50:21 bkp010 kernel: [559018.459725]  ipv6
Sep 29 05:50:21 bkp010 kernel: [559018.459725]  btrfs
Sep 29 05:50:21 bkp010 kernel: [559018.459725]  btrfs
Sep 29 05:50:21 bkp010 kernel: [559018.459726]  xor
Sep 29 05:50:21 bkp010 kernel: [559018.459726]  xor
Sep 29 05:50:21 bkp010 kernel: [559018.459726]  raid6_pq
Sep 29 05:50:21 bkp010 kernel: [559018.459727]  raid6_pq
Sep 29 05:50:21 bkp010 kernel: [559018.459727]  zlib_deflate
Sep 29 05:50:21 bkp010 kernel: [559018.459728]  zlib_deflate
Sep 29 05:50:21 bkp010 kernel: [559018.459728]  coretemp
Sep 29 05:50:21 bkp010 kernel: [559018.459728]  coretemp
Sep 29 05:50:21 bkp010 kernel: [559018.459729]  hwmon
Sep 29 05:50:21 bkp010 kernel: [559018.459729]  hwmon
Sep 29 05:50:21 bkp010 kernel: [559018.459729]  loop
Sep 29 05:50:21 bkp010 kernel: [559018.459730]  loop
Sep 29 05:50:21 bkp010 kernel: [559018.459730]  pcspkr
Sep 29 05:50:21 bkp010 kernel: [559018.459731]  pcspkr
Sep 29 05:50:21 bkp010 kernel: [559018.459731]  parport_pc
Sep 29 05:50:21 bkp010 kernel: [559018.459731]  parport_pc
Sep 29 05:50:21 bkp010 kernel: [559018.459732]  parport
Sep 29 05:50:21 bkp010 kernel: [559018.459732]  parport
Sep 29 05:50:21 bkp010 kernel: [559018.459732]  i2c_i801
Sep 29 05:50:21 bkp010 kernel: [559018.459733]  i2c_i801
Sep 29 05:50:21 bkp010 kernel: [559018.459733]  i2ccore
Sep 29 05:50:21 bkp010 kernel: [559018.459733]  i2ccore
Sep 29 05:50:21 bkp010 kernel: [559018.459734]  battery
Sep 29 05:50:21 bkp010 kernel: [559018.459734]  battery
Sep 29 05:50:21 bkp010 kernel: [559018.459734]  tpm_infineon
Sep 29 05:50:21 bkp010 kernel: [559018.459735]  tpm_infineon
Sep 29 05:50:21 bkp010 kernel: [559018.459735]  tpm_tis
Sep 29 05:50:21 bkp010 kernel: [559018.459735]  tpm_tis
Sep 29 05:50:21 bkp010 kernel: [559018.459736]  video
Sep 29 05:50:21 bkp010 kernel: [559018.459736]  video
Sep 29 05:50:21 bkp010 kernel: [559018.459736]  tpm
Sep 29 05:50:21 bkp010 kernel: [559018.459737]  tpm
Sep 29 05:50:21 bkp010 kernel: [559018.459737]  ehci_pci
Sep 29 05:50:21 bkp010 kernel: [559018.459738]  ehci_pci
Sep 29 05:50:21 bkp010 kernel: [559018.459738]  ehci_hcd
Sep 29 05:50:21 bkp010 kernel: [559018.459738]  ehci_hcd
Sep 29 05:50:21 bkp010 kernel: [559018.459739]  lpc_ich
Sep 29 05:50:21 bkp010 kernel: [559018.459739]  lpc_ich
Sep 29 05:50:21 bkp010 kernel: [559018.459739]  mfd_core
Sep 29 05:50:21 bkp010 kernel: [559018.459740]  mfd_core
Sep 29 05:50:21 bkp010 kernel: [559018.459740]  acpi_cpufreq
Sep 29 05:50:21 bkp010 kernel: [559018.459740]  acpi_cpufreq
Sep 29 05:50:21 bkp010 kernel: [559018.459741]  button
Sep 29 05:50:21 bkp010 kernel: [559018.459741]  button
Sep 29 05:50:21 bkp010 kernel: [559018.459741]  ext4
Sep 29 05:50:21 bkp010 kernel: [559018.459742]  ext4
Sep 29 05:50:21 bkp010 kernel: [559018.459742]  crc16
Sep 29 05:50:21 bkp010 kernel: [559018.459743]  crc16
Sep 29 05:50:21 bkp010 kernel: [559018.459743]  jbd2
Sep 29 05:50:21 bkp010 kernel: [559018.459743]  jbd2
Sep 29 05:50:21 bkp010 kernel: [559018.459744]  mbcache
Sep 29 05:50:21 bkp010 kernel: [559018.459744]  mbcache
Sep 29 05:50:21 bkp010 kernel: [559018.459744]  raid1
Sep 29 05:50:21 bkp010 kernel: [559018.459745]  raid1
Sep 29 05:50:21 bkp010 kernel: [559018.459745]  sg
Sep 29 05:50:21 bkp010 kernel: [559018.459745]  sg
Sep 29 05:50:21 bkp010 kernel: [559018.459746]  sd_mod
Sep 29 05:50:21 bkp010 kernel: [559018.459746]  sd_mod
Sep 29 05:50:21 bkp010 kernel: [559018.459746]  ahci
Sep 29 05:50:21 bkp010 kernel: [559018.459747]  ahci
Sep 29 05:50:21 bkp010 kernel: [559018.459747]  libahci
Sep 29 05:50:21 bkp010 kernel: [559018.459748]  libahci
Sep 29 05:50:21 bkp010 kernel: [559018.459748]  libata
Sep 29 05:50:21 bkp010 kernel: [559018.459748]  libata
Sep 29 05:50:21 bkp010 kernel: [559018.459749]  scsi_mod
Sep 29 05:50:21 bkp010 kernel: [559018.459749]  scsi_mod
Sep 29 05:50:21 bkp010 kernel: [559018.459749]  r8169
Sep 29 05:50:21 bkp010 kernel: [559018.459750]  r8169
Sep 29 05:50:21 bkp010 kernel: [559018.459750]  mii
Sep 29 05:50:21 bkp010 kernel: [559018.459750]  mii
Sep 29 05:50:21 bkp010 kernel: [559018.459750]
Sep 29 05:50:21 bkp010 kernel: [559018.459751]
Sep 29 05:50:21 bkp010 kernel: [559018.459752] CPU: 0 PID: 17272 Comm: 
kworker/u16:11 Not tainted 3.17.0-rc6 #1
Sep 29 05:50:21 bkp010 kernel: [559018.459754] CPU: 2 PID: 17271 Comm: 
kworker/u16:8 Not tainted 3.17.0-rc6 #1
Sep 29 05:50:21 bkp010 kernel: [559018.459755] Hardware name: System 
manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Sep 29 05:50:21 bkp010 kernel: [559018.459755] Hardware name: System 
manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Sep 29 05:50:21 bkp010 kernel: [559018.459778] Workqueue: 
btrfs-endio-write btrfs_endio_write_helper [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459779] Workqueue: 
btrfs-endio-write btrfs_endio_write_helper [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459779]
Sep 29 05:50:21 bkp010 kernel: [559018.459779]
Sep 29 05:50:21 bkp010 kernel: [559018.459780] task: ffff8807f1634830 
ti: ffff88006f018000 task.ti: ffff88006f018000
Sep 29 05:50:21 bkp010 kernel: [559018.459780] task: ffff88073fc66040 
ti: ffff880039b90000 task.ti: ffff880039b90000
Sep 29 05:50:21 bkp010 kernel: [559018.459782] RIP: 
0010:[<ffffffff810693cf>]
Sep 29 05:50:21 bkp010 kernel: [559018.459784] RIP: 
0010:[<ffffffff81069417>]
Sep 29 05:50:21 bkp010 kernel: [559018.459784]  [<ffffffff810693cf>] 
queue_write_lock_slowpath+0x5b/0x6b
Sep 29 05:50:21 bkp010 kernel: [559018.459786]  [<ffffffff81069417>] 
queue_read_lock_slowpath+0x38/0x69
Sep 29 05:50:21 bkp010 kernel: [559018.459787] RSP: 
0018:ffff88006f01b9b8  EFLAGS: 00000206
Sep 29 05:50:21 bkp010 kernel: [559018.459787] RSP: 
0018:ffff880039b93998  EFLAGS: 00000282
Sep 29 05:50:21 bkp010 kernel: [559018.459788] RAX: 0000000000000101 
RBX: ffff88073fc66040 RCX: 0000000000000101
Sep 29 05:50:21 bkp010 kernel: [559018.459789] RAX: 00000000000000fd 
RBX: ffffffff8105f355 RCX: 0000000000000009
Sep 29 05:50:21 bkp010 kernel: [559018.459789] RDX: 00000000000000ff 
RSI: 000000000000000a RDI: ffff880220484f78
Sep 29 05:50:21 bkp010 kernel: [559018.459790] RDX: 0000000000000000 
RSI: 000000000000000a RDI: ffff880220484f78
Sep 29 05:50:21 bkp010 kernel: [559018.459790] RBP: ffff88006f01b9b8 
R08: ffff880000000000 R09: 0000000000000485
Sep 29 05:50:21 bkp010 kernel: [559018.459791] RBP: ffff880039b93998 
R08: 00000000ffffffff R09: 0000000000000001
Sep 29 05:50:21 bkp010 kernel: [559018.459791] R10: 0000000000000485 
R11: 0000000000000000 R12: ffff88081fa91630
Sep 29 05:50:21 bkp010 kernel: [559018.459792] R10: ffffffffa02e4943 
R11: 00000000b3fa0000 R12: ffffffff8105cb82
Sep 29 05:50:21 bkp010 kernel: [559018.459792] R13: ffff88081fa915c0 
R14: ffff88073fc660a8 R15: ffff88055cffade0
Sep 29 05:50:21 bkp010 kernel: [559018.459793] R13: ffff880039b93948 
R14: 0000000103550001 R15: ffff88081fa915c0
Sep 29 05:50:21 bkp010 kernel: [559018.459794] FS:  
0000000000000000(0000) GS:ffff88081fa00000(0000) knlGS:0000000000000000
Sep 29 05:50:21 bkp010 kernel: [559018.459795] FS:  
0000000000000000(0000) GS:ffff88081fa80000(0000) knlGS:0000000000000000
Sep 29 05:50:21 bkp010 kernel: [559018.459795] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Sep 29 05:50:21 bkp010 kernel: [559018.459796] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Sep 29 05:50:21 bkp010 kernel: [559018.459797] CR2: ffffffffff600400 
CR3: 0000000001611000 CR4: 00000000001407f0
Sep 29 05:50:21 bkp010 kernel: [559018.459797] CR2: ffffffffff600400 
CR3: 0000000001611000 CR4: 00000000001407e0
Sep 29 05:50:21 bkp010 kernel: [559018.459798] Stack:
Sep 29 05:50:21 bkp010 kernel: [559018.459798] Stack:
Sep 29 05:50:21 bkp010 kernel: [559018.459799]  ffff88006f01b9c8
Sep 29 05:50:21 bkp010 kernel: [559018.459799]  ffff880039b939a8
Sep 29 05:50:21 bkp010 kernel: [559018.459799]  ffffffff813b000e
Sep 29 05:50:21 bkp010 kernel: [559018.459800]  ffffffff813b0165
Sep 29 05:50:21 bkp010 kernel: [559018.459800]  ffff88006f01ba18
Sep 29 05:50:21 bkp010 kernel: [559018.459800]  ffff880039b93a18
Sep 29 05:50:21 bkp010 kernel: [559018.459801]  ffffffffa02fd7a6
Sep 29 05:50:21 bkp010 kernel: [559018.459801]  ffffffffa02fd4c7
Sep 29 05:50:21 bkp010 kernel: [559018.459801]
Sep 29 05:50:21 bkp010 kernel: [559018.459801]
Sep 29 05:50:21 bkp010 kernel: [559018.459803]  0000000000001000
Sep 29 05:50:21 bkp010 kernel: [559018.459803]  ffff8807f4151810
Sep 29 05:50:21 bkp010 kernel: [559018.459803]  0000000000000000
Sep 29 05:50:21 bkp010 kernel: [559018.459804]  ffff88073fc66040
Sep 29 05:50:21 bkp010 kernel: [559018.459804]  ffff88006f01ba08
Sep 29 05:50:21 bkp010 kernel: [559018.459804]  ffff880039b93a58
Sep 29 05:50:21 bkp010 kernel: [559018.459805]  ffff880220484f08
Sep 29 05:50:21 bkp010 kernel: [559018.459805]  ffffffffa02b34ec
Sep 29 05:50:21 bkp010 kernel: [559018.459805]
Sep 29 05:50:21 bkp010 kernel: [559018.459806]
Sep 29 05:50:21 bkp010 kernel: [559018.459806]  ffff8807f1234000
Sep 29 05:50:21 bkp010 kernel: [559018.459806]  0000000000001000
Sep 29 05:50:21 bkp010 kernel: [559018.459807]  ffff8807f1234000
Sep 29 05:50:21 bkp010 kernel: [559018.459807]  0000000000000000
Sep 29 05:50:21 bkp010 kernel: [559018.459808]  ffff880220484f08
Sep 29 05:50:21 bkp010 kernel: [559018.459808]  ffff880039b93a08
Sep 29 05:50:21 bkp010 kernel: [559018.459808]  ffff8807f1234000
Sep 29 05:50:21 bkp010 kernel: [559018.459808]  ffff880220484f08
Sep 29 05:50:21 bkp010 kernel: [559018.459809]
Sep 29 05:50:21 bkp010 kernel: [559018.459809]
Sep 29 05:50:21 bkp010 kernel: [559018.459809] Call Trace:
Sep 29 05:50:21 bkp010 kernel: [559018.459809] Call Trace:
Sep 29 05:50:21 bkp010 kernel: [559018.459812]  [<ffffffff813b000e>] 
_raw_write_lock+0x18/0x1a
Sep 29 05:50:21 bkp010 kernel: [559018.459814]  [<ffffffff813b0165>] 
_raw_read_lock+0x16/0x18
Sep 29 05:50:21 bkp010 kernel: [559018.459822]  [<ffffffffa02fd7a6>] 
btrfs_tree_lock+0xb4/0x1a3 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459831]  [<ffffffffa02fd4c7>] 
btrfs_tree_read_lock+0x49/0xe6 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459835]  [<ffffffffa02aeccb>] 
btrfs_lock_root_node+0x1d/0x3d [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459841]  [<ffffffffa02b34ec>] ? 
btrfs_search_slot+0x791/0x816 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459845]  [<ffffffffa02b2f7d>] 
btrfs_search_slot+0x222/0x816 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459851]  [<ffffffffa02aec8e>] 
btrfs_read_lock_root_node+0x1d/0x3d [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459857]  [<ffffffffa02c5807>] 
btrfs_lookup_file_extent+0x33/0x35 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459863]  [<ffffffffa02b2f21>] 
btrfs_search_slot+0x1c6/0x816 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459870]  [<ffffffffa02df819>] 
__btrfs_drop_extents+0x183/0xb7d [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459878]  [<ffffffffa02c5807>] 
btrfs_lookup_file_extent+0x33/0x35 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459882]  [<ffffffffa02b471f>] ? 
setup_items_for_insert+0x343/0x363 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459893]  [<ffffffffa02df819>] 
__btrfs_drop_extents+0x183/0xb7d [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459897]  [<ffffffffa02aec38>] ? 
btrfs_free_path+0x22/0x26 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459903]  [<ffffffffa02accb0>] ? 
leaf_space_used+0xbb/0xea [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459910]  [<ffffffffa02d3804>] 
insert_reserved_file_extent.constprop.64+0x9a/0x2a5 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459915]  [<ffffffffa02aec38>] ? 
btrfs_free_path+0x22/0x26 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459921]  [<ffffffffa02d6f50>] 
btrfs_finish_ordered_io+0x26b/0x43b [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459930]  [<ffffffffa02d3804>] 
insert_reserved_file_extent.constprop.64+0x9a/0x2a5 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459937]  [<ffffffffa0309ceb>] ? 
end_compressed_bio_write+0x57/0xc6 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459945]  [<ffffffffa02d6f50>] 
btrfs_finish_ordered_io+0x26b/0x43b [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459951]  [<ffffffffa02d7130>] 
finish_ordered_fn+0x10/0x12 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459960]  [<ffffffffa0309ceb>] ? 
end_compressed_bio_write+0x57/0xc6 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459967]  [<ffffffffa02f5de3>] 
normal_work_helper+0xb5/0x16a [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459974]  [<ffffffffa02d7130>] 
finish_ordered_fn+0x10/0x12 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459981]  [<ffffffffa02f5f4a>] 
btrfs_endio_write_helper+0xd/0xf [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459989]  [<ffffffffa02f5de3>] 
normal_work_helper+0xb5/0x16a [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.459990]  [<ffffffff8104aadb>] 
process_one_work+0x188/0x2ab
Sep 29 05:50:21 bkp010 kernel: [559018.459999]  [<ffffffffa02f5f4a>] 
btrfs_endio_write_helper+0xd/0xf [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.460000]  [<ffffffff8104ae89>] 
worker_thread+0x261/0x35e
Sep 29 05:50:21 bkp010 kernel: [559018.460001]  [<ffffffff8104aadb>] 
process_one_work+0x188/0x2ab
Sep 29 05:50:21 bkp010 kernel: [559018.460002]  [<ffffffff8104ac28>] ? 
process_scheduled_works+0x2a/0x2a
Sep 29 05:50:21 bkp010 kernel: [559018.460003]  [<ffffffff8104ae89>] 
worker_thread+0x261/0x35e
Sep 29 05:50:21 bkp010 kernel: [559018.460004]  [<ffffffff8104e993>] 
kthread+0xcd/0xd5
Sep 29 05:50:21 bkp010 kernel: [559018.460006]  [<ffffffff8104ac28>] ? 
process_scheduled_works+0x2a/0x2a
Sep 29 05:50:21 bkp010 kernel: [559018.460007]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
Sep 29 05:50:21 bkp010 kernel: [559018.460008]  [<ffffffff8104e993>] 
kthread+0xcd/0xd5
Sep 29 05:50:21 bkp010 kernel: [559018.460009]  [<ffffffff813b056c>] 
ret_from_fork+0x7c/0xb0
Sep 29 05:50:21 bkp010 kernel: [559018.460011]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
Sep 29 05:50:21 bkp010 kernel: [559018.460012]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
Sep 29 05:50:21 bkp010 kernel: [559018.460013]  [<ffffffff813b056c>] 
ret_from_fork+0x7c/0xb0
Sep 29 05:50:21 bkp010 kernel: [559018.460014] Code:
Sep 29 05:50:21 bkp010 kernel: [559018.460015] 85
Sep 29 05:50:21 bkp010 kernel: [559018.460015]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
Sep 29 05:50:21 bkp010 kernel: [559018.460016] c0 74
Sep 29 05:50:21 bkp010 kernel: [559018.460016] Code:
Sep 29 05:50:21 bkp010 kernel: [559018.460017] 31
Sep 29 05:50:21 bkp010 kernel: [559018.460017] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460017] 8b
Sep 29 05:50:21 bkp010 kernel: [559018.460018] 48
Sep 29 05:50:21 bkp010 kernel: [559018.460018] 17
Sep 29 05:50:21 bkp010 kernel: [559018.460018] 89
Sep 29 05:50:21 bkp010 kernel: [559018.460019] 84
Sep 29 05:50:21 bkp010 kernel: [559018.460019] e5
Sep 29 05:50:21 bkp010 kernel: [559018.460019] d2
Sep 29 05:50:21 bkp010 kernel: [559018.460020] 74
Sep 29 05:50:21 bkp010 kernel: [559018.460020] 75
Sep 29 05:50:21 bkp010 kernel: [559018.460020] 0c
Sep 29 05:50:21 bkp010 kernel: [559018.460021] 0f
Sep 29 05:50:21 bkp010 kernel: [559018.460021] eb
Sep 29 05:50:21 bkp010 kernel: [559018.460021] 89
Sep 29 05:50:21 bkp010 kernel: [559018.460021] 02
Sep 29 05:50:21 bkp010 kernel: [559018.460022] d1
Sep 29 05:50:21 bkp010 kernel: [559018.460022] f3
Sep 29 05:50:21 bkp010 kernel: [559018.460022] 89
Sep 29 05:50:21 bkp010 kernel: [559018.460023] 90
Sep 29 05:50:21 bkp010 kernel: [559018.460023] d0
Sep 29 05:50:21 bkp010 kernel: [559018.460023] 8b
Sep 29 05:50:21 bkp010 kernel: [559018.460024] 83
Sep 29 05:50:21 bkp010 kernel: [559018.460024] 07
Sep 29 05:50:21 bkp010 kernel: [559018.460024] c9
Sep 29 05:50:21 bkp010 kernel: [559018.460025] fe
Sep 29 05:50:21 bkp010 kernel: [559018.460025] 01
Sep 29 05:50:21 bkp010 kernel: [559018.460025] c0
Sep 29 05:50:21 bkp010 kernel: [559018.460026] f0
Sep 29 05:50:21 bkp010 kernel: [559018.460026] 74
Sep 29 05:50:21 bkp010 kernel: [559018.460026] 0f
Sep 29 05:50:21 bkp010 kernel: [559018.460027] f8
Sep 29 05:50:21 bkp010 kernel: [559018.460027] b1
Sep 29 05:50:21 bkp010 kernel: [559018.460027] eb
Sep 29 05:50:21 bkp010 kernel: [559018.460028] 0f
Sep 29 05:50:21 bkp010 kernel: [559018.460028] 45
Sep 29 05:50:21 bkp010 kernel: [559018.460028] 39
Sep 29 05:50:21 bkp010 kernel: [559018.460029] f0
Sep 29 05:50:21 bkp010 kernel: [559018.460029] d0
Sep 29 05:50:21 bkp010 kernel: [559018.460030] 81
Sep 29 05:50:21 bkp010 kernel: [559018.460030] 74
Sep 29 05:50:21 bkp010 kernel: [559018.460030] 2f
Sep 29 05:50:21 bkp010 kernel: [559018.460031] 04
Sep 29 05:50:21 bkp010 kernel: [559018.460031] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460031] f3
Sep 29 05:50:21 bkp010 kernel: [559018.460032] 01
Sep 29 05:50:21 bkp010 kernel: [559018.460032] 90
Sep 29 05:50:21 bkp010 kernel: [559018.460032] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460033] eb
Sep 29 05:50:21 bkp010 kernel: [559018.460033] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460033] e7
Sep 29 05:50:21 bkp010 kernel: [559018.460034] b8
Sep 29 05:50:21 bkp010 kernel: [559018.460034] ba
Sep 29 05:50:21 bkp010 kernel: [559018.460035] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460035] ff
Sep 29 05:50:21 bkp010 kernel: [559018.460035] 01
Sep 29 05:50:21 bkp010 kernel: [559018.460036] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460036] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460037] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460037] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460037] 00
Sep 29 05:50:21 bkp010 kernel: [559018.460037] f0
Sep 29 05:50:21 bkp010 kernel: [559018.460038] 8b
Sep 29 05:50:21 bkp010 kernel: [559018.460038] 66
Sep 29 05:50:21 bkp010 kernel: [559018.460039] 07
Sep 29 05:50:21 bkp010 kernel: [559018.460039] 0f
Sep 29 05:50:21 bkp010 kernel: [559018.460039] 83
Sep 29 05:50:21 bkp010 kernel: [559018.460039] c1
Sep 29 05:50:21 bkp010 kernel: [559018.460040] f8
Sep 29 05:50:21 bkp010 kernel: [559018.460040] 47
Sep 29 05:50:21 bkp010 kernel: [559018.460040] 01
Sep 29 05:50:21 bkp010 kernel: [559018.460041] 04
Sep 29 05:50:21 bkp010 kernel: [559018.460041] 74
Sep 29 05:50:21 bkp010 kernel: [559018.460041] 0f
Sep 29 05:50:21 bkp010 kernel: [559018.460042] 04
Sep 29 05:50:21 bkp010 kernel: [559018.460042] b6
Sep 29 05:50:21 bkp010 kernel: [559018.460042] f3
Sep 29 05:50:21 bkp010 kernel: [559018.460043] d4
Sep 29 05:50:21 bkp010 kernel: [559018.460043] 90
Sep 29 05:50:21 bkp010 kernel: [559018.460043] 38
Sep 29 05:50:21 bkp010 kernel: [559018.460044] <eb>
Sep 29 05:50:21 bkp010 kernel: [559018.460044] c2
Sep 29 05:50:21 bkp010 kernel: [559018.460044] f5
Sep 29 05:50:21 bkp010 kernel: [559018.460044] 74
Sep 29 05:50:21 bkp010 kernel: [559018.460045] f0
Sep 29 05:50:21 bkp010 kernel: [559018.460045] 0b
Sep 29 05:50:21 bkp010 kernel: [559018.460046] 0f
Sep 29 05:50:21 bkp010 kernel: [559018.460046] <8a>
Sep 29 05:50:21 bkp010 kernel: [559018.460046] b1
Sep 29 05:50:21 bkp010 kernel: [559018.460046] 47
Sep 29 05:50:21 bkp010 kernel: [559018.460047] 17
Sep 29 05:50:21 bkp010 kernel: [559018.460047] 04
Sep 29 05:50:21 bkp010 kernel: [559018.460048] ff
Sep 29 05:50:21 bkp010 kernel: [559018.460048] 38
Sep 29 05:50:21 bkp010 kernel: [559018.460048] c8
Sep 29 05:50:21 bkp010 kernel: [559018.460048] d0
Sep 29 05:50:21 bkp010 kernel: [559018.460049] 75
Sep 29 05:50:21 bkp010 kernel: [559018.460049] 74
Sep 29 05:50:21 bkp010 kernel: [559018.460049] f4
Sep 29 05:50:21 bkp010 kernel: [559018.460050] 04
Sep 29 05:50:21 bkp010 kernel: [559018.460050] 80
Sep 29 05:50:21 bkp010 kernel: [559018.460050] f3
Sep 29 05:50:21 bkp010 kernel: [559018.460051] 47
Sep 29 05:50:21 bkp010 kernel: [559018.460051] 90
Sep 29 05:50:21 bkp010 kernel: [559018.460051] 04
Sep 29 05:50:21 bkp010 kernel: [559018.460052] eb
Sep 29 05:50:21 bkp010 kernel: [559018.460052] 01
Sep 29 05:50:21 bkp010 kernel: [559018.460052] f5
Sep 29 05:50:21 bkp010 kernel: [559018.460053] 5d
Sep 29 05:50:21 bkp010 kernel: [559018.460053] eb
Sep 29 05:50:21 bkp010 kernel: [559018.460053] c3
Sep 29 05:50:21 bkp010 kernel: [559018.460054] 02
Sep 29 05:50:21 bkp010 kernel: [559018.460054] 55
Sep 29 05:50:21 bkp010 kernel: [559018.460054] f3
Sep 29 05:50:21 bkp010 kernel: [559018.460055] 65
Sep 29 05:50:21 bkp010 kernel: [559018.460055] 90
Sep 29 05:50:21 bkp010 kernel: [559018.460055] 8b
Sep 29 05:50:21 bkp010 kernel: [559018.460055] 8b
Sep 29 05:50:21 bkp010 kernel: [559018.460056] 04
Sep 29 05:50:21 bkp010 kernel: [559018.460056] 07
Sep 29 05:50:21 bkp010 kernel: [559018.460056] 25
Sep 29 05:50:21 bkp010 kernel: [559018.460057] 84
Sep 29 05:50:21 bkp010 kernel: [559018.460057]
Sep 29 05:50:21 bkp010 kernel: [559018.460058] c0 75 f8
Sep 29 05:50:21 bkp010 kernel: [559018.478275] Modules linked in: 
ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand 
cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 
btrfs xor raid6_pq zlib_deflate coretemp hwmon loop pcspkr parport_pc 
parport i2c_i801 i2ccore battery tpm_infineon tpm_tis video tpm ehci_pci 
ehci_hcd lpc_ich mfd_core acpi_cpufreq button ext4 crc16 jbd2 mbcache 
raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
Sep 29 05:50:21 bkp010 kernel: [559018.478644] CPU: 6 PID: 16872 Comm: 
kworker/u16:24 Tainted: G             L 3.17.0-rc6 #1
Sep 29 05:50:21 bkp010 kernel: [559018.478733] Hardware name: System 
manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Sep 29 05:50:21 bkp010 kernel: [559018.478832] Workqueue: 
btrfs-endio-write btrfs_endio_write_helper [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.478882] task: ffff8807f3ac4830 
ti: ffff8801c8eac000 task.ti: ffff8801c8eac000
Sep 29 05:50:21 bkp010 kernel: [559018.478970] RIP: 
0010:[<ffffffff8106941a>]  [<ffffffff8106941a>] 
queue_read_lock_slowpath+0x3b/0x69
Sep 29 05:50:21 bkp010 kernel: [559018.479062] RSP: 
0018:ffff8801c8eaf978  EFLAGS: 00000297
Sep 29 05:50:21 bkp010 kernel: [559018.479109] RAX: 000000000000fefd 
RBX: ffff8807f1234000 RCX: ffff880000000000
Sep 29 05:50:21 bkp010 kernel: [559018.479197] RDX: 00000000000000fe 
RSI: 0000000000000004 RDI: ffff880220484f78
Sep 29 05:50:21 bkp010 kernel: [559018.479285] RBP: ffff8801c8eaf978 
R08: ffff880535113908 R09: 0000000000000000
Sep 29 05:50:21 bkp010 kernel: [559018.479374] R10: 0000000000000008 
R11: 0000000000000000 R12: 000000000000e2d9
Sep 29 05:50:21 bkp010 kernel: [559018.479462] R13: ffff880036d50198 
R14: ffff8804d63e2de0 R15: ffff8801c8eaf8f8
Sep 29 05:50:21 bkp010 kernel: [559018.479550] FS:  
0000000000000000(0000) GS:ffff88081fb80000(0000) knlGS:0000000000000000
Sep 29 05:50:21 bkp010 kernel: [559018.479639] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Sep 29 05:50:21 bkp010 kernel: [559018.479687] CR2: 00007fffedc105e8 
CR3: 0000000001611000 CR4: 00000000001407e0
Sep 29 05:50:21 bkp010 kernel: [559018.479775] Stack:
Sep 29 05:50:21 bkp010 kernel: [559018.480935]  ffff8801c8eaf988 
ffffffff813b0165 ffff8801c8eaf9a8 ffffffffa02fd430
Sep 29 05:50:21 bkp010 kernel: [559018.481026]  0000000000000002 
ffffffffffffffec ffff8801c8eaf9c8 ffffffffa02aeb59
Sep 29 05:50:21 bkp010 kernel: [559018.481116]  ffff880681c1b090 
0000000000000001 ffff8801c8eafa58 ffffffffa02b3436
Sep 29 05:50:21 bkp010 kernel: [559018.481207] Call Trace:
Sep 29 05:50:21 bkp010 kernel: [559018.481251]  [<ffffffff813b0165>] 
_raw_read_lock+0x16/0x18
Sep 29 05:50:21 bkp010 kernel: [559018.481308]  [<ffffffffa02fd430>] 
btrfs_clear_lock_blocking_rw+0x79/0xc7 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.481403]  [<ffffffffa02aeb59>] 
btrfs_clear_path_blocking+0x24/0x56 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.481496]  [<ffffffffa02b3436>] 
btrfs_search_slot+0x6db/0x816 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.481550]  [<ffffffffa02b59a7>] 
btrfs_next_old_leaf+0xe3/0x3bf [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.481603]  [<ffffffffa02b5c8e>] 
btrfs_next_leaf+0xb/0xd [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.481659]  [<ffffffffa02df8db>] 
__btrfs_drop_extents+0x245/0xb7d [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.481709]  [<ffffffff81063ceb>] ? 
autoremove_wake_function+0xf/0x32
Sep 29 05:50:21 bkp010 kernel: [559018.481765]  [<ffffffffa02d3804>] 
insert_reserved_file_extent.constprop.64+0x9a/0x2a5 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.481862]  [<ffffffffa02d6f50>] 
btrfs_finish_ordered_io+0x26b/0x43b [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.481958]  [<ffffffffa0309ceb>] ? 
end_compressed_bio_write+0x57/0xc6 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.482052]  [<ffffffffa02d7130>] 
finish_ordered_fn+0x10/0x12 [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.482108]  [<ffffffffa02f5de3>] 
normal_work_helper+0xb5/0x16a [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.482164]  [<ffffffffa02f5f4a>] 
btrfs_endio_write_helper+0xd/0xf [btrfs]
Sep 29 05:50:21 bkp010 kernel: [559018.482213]  [<ffffffff8104aadb>] 
process_one_work+0x188/0x2ab
Sep 29 05:50:21 bkp010 kernel: [559018.482262]  [<ffffffff8104ae89>] 
worker_thread+0x261/0x35e
Sep 29 05:50:21 bkp010 kernel: [559018.482310]  [<ffffffff8104ac28>] ? 
process_scheduled_works+0x2a/0x2a
Sep 29 05:50:21 bkp010 kernel: [559018.482359]  [<ffffffff8104e993>] 
kthread+0xcd/0xd5
Sep 29 05:50:21 bkp010 kernel: [559018.482406]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
Sep 29 05:50:21 bkp010 kernel: [559018.482456]  [<ffffffff813b056c>] 
ret_from_fork+0x7c/0xb0
Sep 29 05:50:21 bkp010 kernel: [559018.482504]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
Sep 29 05:50:21 bkp010 kernel: [559018.482553] Code: e5 74 0c eb 02 f3 
90 8b 07 fe c0 74 f8 eb 45 f0 81 2f 00 01 00 00 b8 00 01 00 00 f0 66 0f 
c1 47 04 0f b6 d4 38 c2 74 0b 8a 47 04 <38> d0 74 04 f3 90 eb f5 eb 02 
f3 90 8b 07 84 c0 75 f8 b8 00 01


-- 
Tomasz Chmielewski
http://www.sslrack.com

