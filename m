From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Bug
Date: Fri, 24 Jul 2009 15:28:19 -0500
Message-ID: <4A6A1963.8050102@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Still having issue on the non-raid system. not sure if there is anything 
new in this that can help debug the problem.

Message from syslogd@ at Fri Jul 24 12:34:27 2009 ...
btrfs2 kernel: [ 4543.844556] ------------[ cut here ]------------
Message from syslogd@ at Fri Jul 24 12:34:27 2009 ...
btrfs2 kernel: [ 4543.844635] invalid opcode: 0000 [#1] SMP
Message from syslogd@ at Fri Jul 24 12:34:27 2009 ...
btrfs2 kernel: [ 4543.844635] last sysfs file: 
/sys/devices/pci0000:01/0000:01:01.1/irq
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635] Stack:
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  ffff88013b1c1000 ffff880099cc4760 
000000b221521bd0 ffffffffa036519a
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  000000353b1c1000 ffff880024ddf440 
ffff8800bf8e3ac0 0000000000000001
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635] Call Trace:
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa036519a>] ? 
update_reserved_extents+0xa1/0xb8 [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa036a56e>] 
run_one_delayed_ref+0x385/0x432 [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa036b1f2>] 
run_clustered_refs+0x237/0x2b4 [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa03a011d>] ? 
btrfs_find_ref_cluster+0xdc/0x115 [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa036b31b>] 
btrfs_run_delayed_refs+0xac/0x195 [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa0374b05>] 
__btrfs_end_transaction+0x59/0xfe [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa0374bc5>] 
btrfs_end_transaction+0xb/0xd [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa037a295>] 
btrfs_finish_ordered_io+0x224/0x24d [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa037a2ce>] 
btrfs_writepage_end_io_hook+0x10/0x12 [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa038d6a9>] 
end_bio_extent_writepage+0xa3/0x18f [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffff80242782>] ? 
del_timer_sync+0x14/0x20
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffff802cbc6a>] bio_endio+0x26/0x28
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa0371799>] 
end_workqueue_fn+0x111/0x11e [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa0395274>] 
worker_loop+0x67/0x1ef [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffffa039520d>] ? 
worker_loop+0x0/0x1ef [btrfs]
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffff8024c33c>] kthread+0x56/0x86
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffff8020c9fa>] child_rip+0xa/0x20
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffff8024c2e6>] ? kthread+0x0/0x86
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635]  [<ffffffff8020c9f0>] ? child_rip+0x0/0x20
Message from syslogd@ at Fri Jul 24 12:34:28 2009 ...
btrfs2 kernel: [ 4543.844635] Code: 08 4c 8d 45 d4 41 8d 44 24 18 48 8b 
73 20 48 8b 4d 18 41 b9 01 00 00 00 48 8b 7d b8 4c 89 ea 89 45 d4 e8 8a 
e2 ff ff 85 c0 74 04 <0f> 0b eb fe 49 63 75 40 4d 8b 65 00 49 83 cf 01 
4c 89 e7 48 6b


After this, we seem to get stuck with all threads spinning in 
btrfs_endio_write, 100% cpu witn no IO going on.  dmesg full of softlockups:


Jul 24 15:25:18 btrfs2 kernel: [14789.720395] BUG: soft lockup - CPU#1 
stuck for 61s! [btrfs-endio-wri:16195]
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] Modules linked in: btrfs 
zlib_deflate oprofile autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc dm_mu
ltipath video output sbs sbshc battery ac parport_pc lp parport sg 
joydev serio_raw acpi_memhotplug rtc_cmos rtc_core rtc_lib button tg3 libphy
 i2c_piix4 i2c_core pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash 
dm_log dm_mod lpfc scsi_transport_fc aic94xx libsas libata scsi_transpo
rt_sas sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last 
unloaded: microcode]
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] CPU 1:
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] Modules linked in: btrfs 
zlib_deflate oprofile autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc dm_mu
ltipath video output sbs sbshc battery ac parport_pc lp parport sg 
joydev serio_raw acpi_memhotplug rtc_cmos rtc_core rtc_lib button tg3 libphy
 i2c_piix4 i2c_core pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash 
dm_log dm_mod lpfc scsi_transport_fc aic94xx libsas libata scsi_transpo
rt_sas sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last 
unloaded: microcode]
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] Pid: 16195, comm: 
btrfs-endio-wri Tainted: G      D    2.6.30-autokern1 #1 IBM 
x3950-[88726RU]-
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] RIP: 
0010:[<ffffffff804cdd1d>]  [<ffffffff804cdd1d>] _spin_lock+0x14/0x1a
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] RSP: 
0018:ffff88013ad69a70  EFLAGS: 00000293
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] RAX: 0000000000009d98 RBX: 
ffff88013ad69a70 RCX: 0000000000000000
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] RDX: 0000000000000000 RSI: 
ffff88013b40c000 RDI: ffff8801285fd6b0
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] RBP: ffffffff8020c50e R08: 
000000000000004c R09: 0000000000000001
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] R10: 0000000000000008 R11: 
ffff88013ad69da0 R12: ffff88013ad69a30
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] R13: ffff880100000004 R14: 
ffff88013ad69a50 R15: ffffffffa038ace1
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] FS:  
0000000000000000(0000) GS:ffff88002ba18000(0000) knlGS:0000000000000000
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] CS:  0010 DS: 0018 ES: 
0018 CR0: 000000008005003b
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] CR2: 00007fc84af9f000 CR3: 
000000013e0d4000 CR4: 00000000000006e0
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Jul 24 15:25:18 btrfs2 kernel: [14789.720395] Call Trace:
Jul 24 15:25:18 btrfs2 kernel: [14789.720395]  [<ffffffffa03976b7>] ? 
btrfs_tree_lock+0x54/0x9e [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa039760a>] ? 
btrfs_wake_function+0x0/0x10 [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa035cfa3>] ? 
btrfs_lock_root_node+0x1d/0x4b [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa0362fd6>] ? 
btrfs_search_slot+0xc7/0x76c [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa038ace1>] ? 
map_extent_buffer+0xab/0xbe [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa03643bb>] ? 
btrfs_insert_empty_items+0x5e/0xa9 [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa036a350>] ? 
run_one_delayed_ref+0x167/0x432 [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa036b1f2>] ? 
run_clustered_refs+0x237/0x2b4 [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa03a011d>] ? 
btrfs_find_ref_cluster+0xdc/0x115 [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa036b31b>] ? 
btrfs_run_delayed_refs+0xac/0x195 [btrfs]
Jul 24 15:25:19 btrfs2 kernel: [14789.720395]  [<ffffffffa0374b05>] ? 
__btrfs_end_transaction+0x59/0xfe [btrfs]


Steve




