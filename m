Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51128 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbHOEzE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 00:55:04 -0400
Received: from athena.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 90C04ECE6
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 14:54:56 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: lockup
Date: Sat, 15 Aug 2015 14:54:54 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201508151454.54169.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a Xen server with 14 DomUs that are being used for BTRFS and ZFS 
training.  About 5 people are corrupting virtual disks and scrubbing them, 
lots of IO.

All the virtual machine disk images are snapshots of a master image with copy 
on write.  I just had the following error which ended with a NMI.  I copied 
what I could.  It's running the latest Debian/Jessie kernel 3.16.7.

[15780.056002] Code: 44 24 10 e9 1c ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 
66 66 90 41 54 55 48 89 fd 53 4c 8b 67 50 66 66 66 66 90 f0 ff 4d 4c <74> 35 5b 
5d 41 5c c3 48 8b 1d a9 07 07 00 48 85 db 74 1c 48 8b 
[15808.056003] BUG: soft lockup - CPU#1 stuck for 22s! [qemu-system-i38:22730]
[15808.056003] Modules linked in: xt_tcpudp xt_physdev iptable_filter ip_tables 
x_tables xen_netback xen_gntdev xen_evtchn xenfs xen_privcmd nfsd auth_rpcgss 
oid_registry nfs_acl nfs lockd fscache sunrpc bridge stp llc ext4 crc16 
mbcache jbd2 ppdev psmouse serio_raw pcspkr k8temp joydev evdev ipmi_si ns558 
gameport parport_pc parport ipmi_msghandler snd_mpu401_uart snd_rawmidi 
snd_seq_device snd processor button soundcore edac_mce_amd edac_core 
i2c_nforce2 i2c_core shpchp thermal_sys loop autofs4 crc32c_generic btrfs xor 
raid6_pq raid1 md_mod sd_mod crc_t10dif crct10dif_generic crct10dif_common 
hid_generic usbhid hid sg sr_mod cdrom ata_generic ohci_pci mptsas 
scsi_transport_sas mptscsih mptbase e1000 pata_amd ehci_pci ohci_hcd ehci_hcd 
libata forcedeth scsi_mod usbcore usb_common
[15808.056003] CPU: 1 PID: 22730 Comm: qemu-system-i38 Not tainted 3.16.0-4-
amd64 #1 Debian 3.16.7-ckt11-1+deb8u3
[15808.056003] Hardware name: Sun Microsystems Sun Fire X4100 M2/Sun Fire 
X4100 M2                        , BIOS 0ABJX102 11/03/2008
[15808.056003] task: ffff88000012e010 ti: ffff880001e9c000 task.ti: ffff880001e9c000
[15808.056003] RIP: e030:[<ffffffffa024edb9>]  [<ffffffffa024edb9>] 
btrfs_put_ordered_extent+0x19/0xc0 [btrfs]
[15808.056003] RSP: e02b:ffff880001e9fe08  EFLAGS: 00000202
[15808.056003] RAX: 0000000000000583 RBX: ffff88000a4f0580 RCX: 00000000000006a4
[15808.056003] RDX: ffff88000a4f0580 RSI: ffff88000a4f0508 RDI: ffff88000a4f0508
[15808.056003] RBP: ffff88000a4f0508 R08: ffff88000a4f0560 R09: ffff8800502f29b0
[15808.056003] R10: 0000000000007ff0 R11: 0000000000000005 R12: ffff880053821950
[15808.056003] R13: ffff88000a4f0508 R14: ffff880004f7cf00 R15: ffff880001e9fe50
[15808.056003] FS:  00007fdc312f5700(0000) GS:ffff880077440000(0000) 
knlGS:0000000000000000
[15808.056003] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[15808.056003] CR2: 00007f4af0c74000 CR3: 000000002e534000 CR4: 
0000000000000660
[15808.056003] Stack:
[15808.056003]  ffff88000a4f0580 ffff880052d76800 ffff880002503800 ffffffffa02342f4
[15808.056003]  ffff880004f7cfa8 ffff880002503000 0000000000000000 ffffffffa02881e2
[15808.056003]  ffff880000000000 0000000000000000 ffff880052d76800 ffff88000b7f7b18
[15808.056003] Call Trace:
[15808.056003]  [<ffffffffa02342f4>] ? btrfs_wait_pending_ordered+0xc4/0x100 
[btrfs]
[15808.056003]  [<ffffffffa02881e2>] ? __btrfs_run_delayed_items+0xf2/0x1d0 
[btrfs]
[15808.056003]  [<ffffffffa0236356>] ? btrfs_commit_transaction+0x2d6/0xa10 
[btrfs]
[15808.056003]  [<ffffffff810a7a40>] ? prepare_to_wait_event+0xf0/0xf0
[15808.056003]  [<ffffffffa0246529>] ? btrfs_sync_file+0x1c9/0x2f0 [btrfs]
[15808.056003]  [<ffffffff811d53cb>] ? do_fsync+0x4b/0x70
[15808.056003]  [<ffffffff811d564f>] ? SyS_fdatasync+0xf/0x20
[15808.056003]  [<ffffffff8151158d>] ? system_call_fast_compare_end+0x10/0x15
[15808.056003] Code: 44 24 10 e9 1c ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 
66 66 90 41 54 55 48 89 fd 53 4c 8b 67 50 66 66 66 66 90 f0 ff 4d 4c <74> 35 5b 
5d 41 5c c3 48 8b 1d a9 07 07 00 48 85 db 74 1c 48 8b 
[15818.440002] INFO: rcu_sched self-detected stall on CPU { 1}  (t=68266 jiffies 
g=236497 c=236496 q=6784)
[15818.440002] sending NMI to all CPUs:
[15818.440002] NMI backtrace for cpu 1
[15818.440002] CPU: 1 PID: 22730 Comm: qemu-system-i38 Not tainted 3.16.0-4-
amd64 #1 Debian 3.16.7-ckt11-1+deb8u3
[15818.440002] Hardware name: Sun Microsystems Sun Fire X4100 M2/Sun Fire 
X4100 M2                        , BIOS 0ABJX102 11/03/2008
[15818.440002] task: ffff88000012e010 ti: ffff880001e9c000 task.ti: ffff880001e9c000
[15818.440002] RIP: e030:[<ffffffff8100130a>]  [<ffffffff8100130a>] 
xen_hypercall_vcpu_op+0xa/0x20
[15818.440002] RSP: e02b:ffff880077443cc8  EFLAGS: 00000046
[15818.440002] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff8100130a
[15818.440002] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
000000000000000b
[15818.440002] RBP: ffffffff818e2900 R08: ffffffff818e23e0 R09: ffff8800000bcc40
[15818.440002] R10: 0000000000000855 R11: 0000000000000246 R12: ffffffff818e23e0
[15818.440002] R13: 0000000000000005 R14: 0000000000001a80 R15: ffffffff81853680
[15818.440002] FS:  00007fdc312f5700(0000) GS:ffff880077440000(0000) 
knlGS:0000000000000000
[15818.440002] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[15818.440002] CR2: 00007f4af0c74000 CR3: 000000002e534000 CR4: 
0000000000000660
[15818.440002] Stack:
[15818.440002]  ffff880077443a4e 0000000000000001 ffffffff8135840b ffffffff8100f43a
[15818.440002]  ffff88007744d660 ffffffff81853680 0000000000000001 ffffffff818e2940
[15818.440002]  ffffffff81046ab3 ffff88007744d660 ffffffff810c53ca ffffffff818df900
[15818.440002] Call Trace:
[15818.440002]  <IRQ> 

[15818.440002]  [<ffffffff8135840b>] ? xen_send_IPI_one+0x3b/0x60
[15818.440002]  [<ffffffff8100f43a>] ? __xen_send_IPI_mask+0x2a/0x50
[15818.440002]  [<ffffffff81046ab3>] ? arch_trigger_all_cpu_backtrace+0xc3/0x140
[15818.440002]  [<ffffffff810c53ca>] ? rcu_check_callbacks+0x3ea/0x630
[15818.440002]  [<ffffffff810c6f15>] ? timekeeping_update.constprop.9+0x35/0x70
[15818.440002]  [<ffffffff81510d13>] ? _raw_spin_unlock_irqrestore+0x13/0x20
[15818.440002]  [<ffffffff810cfde0>] ? tick_sched_handle.isra.16+0x60/0x60
[15818.440002]  [<ffffffff81074ab0>] ? update_process_times+0x40/0x70
[15818.440002]  [<ffffffff810cfda0>] ? tick_sched_handle.isra.16+0x20/0x60
[15818.440002]  [<ffffffff810cfe1c>] ? tick_sched_timer+0x3c/0x60
[15818.440002]  [<ffffffff8108b067>] ? __run_hrtimer+0x67/0x1c0
[15818.440002]  [<ffffffff8108b419>] ? hrtimer_interrupt+0xe9/0x220
[15818.440002]  [<ffffffff81009fda>] ? xen_timer_interrupt+0x2a/0x150
[15818.440002]  [<ffffffff8138fa5d>] ? add_interrupt_randomness+0x3d/0x1f0
[15818.440002]  [<ffffffff810baef5>] ? handle_irq_event_percpu+0x35/0x190
[15818.440002]  [<ffffffff810be38e>] ? handle_percpu_irq+0x3e/0x60
[15818.440002]  [<ffffffff810ba326>] ? generic_handle_irq+0x26/0x40
[15818.440002]  [<ffffffff8135967a>] ? evtchn_fifo_handle_events+0x16a/0x170
[15818.440002]  [<ffffffff8135680f>] ? __xen_evtchn_do_upcall+0x3f/0x70
[15818.440002]  [<ffffffff8135845f>] ? xen_evtchn_do_upcall+0x2f/0x50
[15818.440002]  [<ffffffff8151321e>] ? xen_do_hypervisor_callback+0x1e/0x30
[15818.440002]  <EOI> 

[15818.440002]  [<ffffffff815110a0>] ? _raw_spin_lock_irqsave+0x50/0x50
[15818.440002]  [<ffffffffa02342fc>] ? btrfs_wait_pending_ordered+0xcc/0x100 
[btrfs]
[15818.440002]  [<ffffffffa02881e2>] ? __btrfs_run_delayed_items+0xf2/0x1d0 
[btrfs]
[15818.440002]  [<ffffffffa0236356>] ? btrfs_commit_transaction+0x2d6/0xa10 
[btrfs]
[15818.440002]  [<ffffffff810a7a40>] ? prepare_to_wait_event+0xf0/0xf0
[15818.440002]  [<ffffffffa0246529>] ? btrfs_sync_file+0x1c9/0x2f0 [btrfs]
[15818.440002]  [<ffffffff811d53cb>] ? do_fsync+0x4b/0x70
[15818.440002]  [<ffffffff811d564f>] ? SyS_fdatasync+0xf/0x20
[15818.440002]  [<ffffffff8151158d>] ? system_call_fast_compare_end+0x10/0x15


-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
