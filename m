Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34377 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbJKQqe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 12:46:34 -0400
Received: by obbda8 with SMTP id da8so93422100obb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 09:46:33 -0700 (PDT)
MIME-Version: 1.0
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Sun, 11 Oct 2015 11:46:14 -0500
Message-ID: <CAC=t97BtYg4W_Jxk6HdxbDmbJ1HFM1BbxTDPr+Y1KOd7M8W4gw@mail.gmail.com>
Subject: filesystem goes ro trying to balance. "cpu stuck"
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel 4.2.2-1.el7.elrepo
btrfs-progs v4.2.1

I'm attempting to convert a filesystem from raid6 to raid10.  I didn't
have any functional problems with it, but performance is abysmal
compared to basically the same arrangement in raid10 so I thought I'd
just get away from raid56 for a while (I also saw something about
parity raid code developed beyond 2-disk parity that was
ignored/thrown away so I'm thinking the devs don't care much about
about parity raid at least for now).

Partway through the balance something goes wrong and filesystem is
forced read-only stopping the balance.

I did a fschk and it didn't complain about/find any errors.  The
drives aren't throwing any errors or incrementing any smart
attributes.  This is a backup array, so it's not the end of the world
if I have to just blow it away and rebuild as raid10 from scratch.

The console prints this error.
NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [btrfs-balance:8015]

Here's the fun stuff out of dmesg

[183120.853367] INFO: rcu_sched self-detected stall on CPU { 0}
(t=7620235 jiffies g=3046202 c=3046201 q=0)
[183120.856391] INFO: rcu_sched detected stalls on CPUs/tasks: { 0}
(detected by 3, t=7620238 jiffies, g=3046202, c=3046201, q=0)
[183120.856393] Task dump for CPU 0:
[183120.856401] btrfs-balance   R  running task        0  8015      2 0x00000088
[183120.856407]  ffff8800d8a6f8f8 ffffffff816c9b6f ffffffff81a2b500
ffff880036f40000
[183120.856411]  ffff88040d0d5140 ffff8800d8a70000 ffff8804094c4620
ffff8804094c4618
[183120.856414]  ffff880036f40000 ffff8800d0e8b1a0 ffff8800d8a6f918
ffffffff816ca177
[183120.856416] Call Trace:
[183120.856428]  [<ffffffff816c9b6f>] ? __schedule+0x2af/0x880
[183120.856435]  [<ffffffff816ca177>] schedule+0x37/0x80
[183120.856441]  [<ffffffff816cce01>] schedule_timeout+0x201/0x2a0
[183120.856448]  [<ffffffff8108e814>] ? wake_up_worker+0x24/0x30
[183120.856451]  [<ffffffff8108f672>] ? insert_work+0x62/0xa0
[183120.856457]  [<ffffffff81181b17>] ? __set_page_dirty_nobuffers+0xe7/0x140
[183120.856463]  [<ffffffff81333401>] ? list_del+0x11/0x40
[183120.856468]  [<ffffffff816cac71>] wait_for_completion+0x111/0x130
[183120.856474]  [<ffffffff810a3d90>] ? wake_up_q+0x80/0x80
[183120.856522]  [<ffffffffa0517963>]
btrfs_async_run_delayed_refs+0x133/0x150 [btrfs]
[183120.856527]  [<ffffffff816c4888>] ? __slab_free+0x11f/0x217
[183120.856573]  [<ffffffffa0582099>] ?
invalidate_extent_cache+0x49/0x1a0 [btrfs]
[183120.856579]  [<ffffffff811d00e8>] ? kmem_cache_alloc+0x1c8/0x1f0
[183120.856615]  [<ffffffffa051b44c>] ? btrfs_drop_snapshot+0x6c/0x850 [btrfs]
[183120.856658]  [<ffffffffa0580ca9>] ? __del_reloc_root+0xb9/0xf0 [btrfs]
[183120.856700]  [<ffffffffa0580c31>] ? __del_reloc_root+0x41/0xf0 [btrfs]
[183120.856742]  [<ffffffffa0580c20>] ? __del_reloc_root+0x30/0xf0 [btrfs]
[183120.856783]  [<ffffffffa0580d05>] ? free_reloc_roots+0x25/0x40 [btrfs]
[183120.856825]  [<ffffffffa0587433>] ? merge_reloc_roots+0x173/0x240 [btrfs]
[183120.856869]  [<ffffffffa0587765>] ? relocate_block_group+0x265/0x640 [btrfs]
[183120.856912]  [<ffffffffa0587d03>] ?
btrfs_relocate_block_group+0x1c3/0x2d0 [btrfs]
[183120.856957]  [<ffffffffa055a75e>] ?
btrfs_relocate_chunk.isra.39+0x3e/0xc0 [btrfs]
[183120.857001]  [<ffffffffa055bcae>] ? __btrfs_balance+0x49e/0x8e0 [btrfs]
[183120.857046]  [<ffffffffa055c46d>] ? btrfs_balance+0x37d/0x650 [btrfs]
[183120.857090]  [<ffffffffa055c79d>] ? balance_kthread+0x5d/0x80 [btrfs]
[183120.857134]  [<ffffffffa055c740>] ? btrfs_balance+0x650/0x650 [btrfs]
[183120.857140]  [<ffffffff81097d08>] ? kthread+0xd8/0xf0
[183120.857146]  [<ffffffff81097c30>] ? kthread_create_on_node+0x1b0/0x1b0
[183120.857150]  [<ffffffff816ce05f>] ? ret_from_fork+0x3f/0x70
[183120.857155]  [<ffffffff81097c30>] ? kthread_create_on_node+0x1b0/0x1b0
[183120.882383] Task dump for CPU 0:
[183120.882385] btrfs-balance   R  running task        0  8015      2 0x00000088
[183120.882387]  ffff880036f40000 00000000d292fc58 ffff88041fc03d78
ffffffff810a636f
[183120.882390]  0000000000000000 ffffffff81a75300 ffff88041fc03d98
ffffffff810a8c4d
[183120.882392]  0000000000000083 0000000000000001 ffff88041fc03dc8
ffffffff810da114
[183120.882394] Call Trace:
[183120.882396]  <IRQ>  [<ffffffff810a636f>] sched_show_task+0xaf/0x110
[183120.882400]  [<ffffffff810a8c4d>] dump_cpu_task+0x3d/0x50
[183120.882404]  [<ffffffff810da114>] rcu_dump_cpu_stacks+0x84/0xc0
[183120.882406]  [<ffffffff810ddd52>] rcu_check_callbacks+0x4c2/0x7b0
[183120.882409]  [<ffffffff811315dc>] ? acct_account_cputime+0x1c/0x20
[183120.882412]  [<ffffffff810a9813>] ? account_system_time+0x83/0x120
[183120.882414]  [<ffffffff810f2590>] ? tick_sched_do_timer+0x50/0x50
[183120.882417]  [<ffffffff810e3009>] update_process_times+0x39/0x60
[183120.882420]  [<ffffffff810f2345>] tick_sched_handle.isra.17+0x25/0x60
[183120.882422]  [<ffffffff810f25d4>] tick_sched_timer+0x44/0x80
[183120.882425]  [<ffffffff810e3bb3>] __hrtimer_run_queues+0xf3/0x220
[183120.882428]  [<ffffffff810e4018>] hrtimer_interrupt+0xa8/0x1a0
[183120.882430]  [<ffffffff8104fbf9>] local_apic_timer_interrupt+0x39/0x60
[183120.882433]  [<ffffffff816d0975>] smp_apic_timer_interrupt+0x45/0x60
[183120.882436]  [<ffffffff816ceb0b>] apic_timer_interrupt+0x6b/0x70
[183120.882437]  <EOI>  [<ffffffffa0580ca9>] ?
__del_reloc_root+0xb9/0xf0 [btrfs]
[183120.882471]  [<ffffffffa0580c31>] ? __del_reloc_root+0x41/0xf0 [btrfs]
[183120.882488]  [<ffffffffa0580c20>] ? __del_reloc_root+0x30/0xf0 [btrfs]
[183120.882505]  [<ffffffffa0580d05>] free_reloc_roots+0x25/0x40 [btrfs]
[183120.882521]  [<ffffffffa0587433>] merge_reloc_roots+0x173/0x240 [btrfs]
[183120.882539]  [<ffffffffa0587765>] relocate_block_group+0x265/0x640 [btrfs]
[183120.882556]  [<ffffffffa0587d03>]
btrfs_relocate_block_group+0x1c3/0x2d0 [btrfs]
[183120.882574]  [<ffffffffa055a75e>]
btrfs_relocate_chunk.isra.39+0x3e/0xc0 [btrfs]
[183120.882591]  [<ffffffffa055bcae>] __btrfs_balance+0x49e/0x8e0 [btrfs]
[183120.882609]  [<ffffffffa055c46d>] btrfs_balance+0x37d/0x650 [btrfs]
[183120.882627]  [<ffffffffa055c79d>] balance_kthread+0x5d/0x80 [btrfs]
[183120.882644]  [<ffffffffa055c740>] ? btrfs_balance+0x650/0x650 [btrfs]
[183120.882647]  [<ffffffff81097d08>] kthread+0xd8/0xf0
[183120.882650]  [<ffffffff81097c30>] ? kthread_create_on_node+0x1b0/0x1b0
[183120.882653]  [<ffffffff816ce05f>] ret_from_fork+0x3f/0x70
[183120.882655]  [<ffffffff81097c30>] ? kthread_create_on_node+0x1b0/0x1b0
[183145.314520] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
[btrfs-balance:8015]
[183145.329314] Modules linked in: ext4 mbcache jbd2
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device kvm_amd
ppdev edac_mce_amd snd_pcm sp5100_tco snd_timer kvm serio_raw pcspkr
snd i2c_piix4 k10temp edac_core soundcore ses enclosure input_leds
8250_fintek parport_pc tpm_infineon shpchp parport acpi_cpufreq nfsd
auth_rpcgss nfs_acl lockd grace sunrpc btrfs xor raid6_pq ata_generic
pata_acpi sd_mod nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm
drm pata_atiixp firewire_ohci lpfc ahci libahci scsi_transport_fc
pata_jmicron firewire_core crc_itu_t libata r8169 mii mpt2sas
raid_class scsi_transport_sas wmi
[183145.329352] CPU: 0 PID: 8015 Comm: btrfs-balance Tainted: G
W    L  4.2.2-1.el7.elrepo.x86_64 #1
[183145.329353] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD
MS-7577/790FX-GD70(MS-7577), BIOS V1.16 12/01/2010
[183145.329355] task: ffff880036f40000 ti: ffff8800d8a6c000 task.ti:
ffff8800d8a6c000
[183145.329357] RIP: 0010:[<ffffffffa0580c45>]  [<ffffffffa0580c45>]
__del_reloc_root+0x55/0xf0 [btrfs]
[183145.329375] RSP: 0018:ffff8800d8a6fb78  EFLAGS: 00000246
[183145.329377] RAX: ffff88001d0daf50 RBX: 00000000ffffffe2 RCX:
0000000180400035
[183145.329379] RDX: 000004c82b518000 RSI: ffffea000e787780 RDI:
ffff88001b8d5570
[183145.329381] RBP: ffff8800d8a6fb98 R08: ffff88039e1de980 R09:
0000000180400035
[183145.329382] R10: ffffea000e787780 R11: ffffffffa0580ca9 R12:
000000001b8d5001
[183145.329384] R13: ffff8800990e7000 R14: 0000000180400035 R15:
ffffffffa051b44c
[183145.329386] FS:  00007f10362a3700(0000) GS:ffff88041fc00000(0000)
knlGS:0000000000000000
[183145.329387] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[183145.329389] CR2: 00007fc759fae000 CR3: 0000000001a24000 CR4:
00000000000006f0
[183145.329390] Stack:
[183145.329391]  ffff8800d8a6fbe0 ffff880003f80800 ffff88001b8d5000
ffff8800d8a6fbe0
[183145.329394]  ffff8800d8a6fbb8 ffffffffa0580d05 ffff8800990e7000
ffff8800990e7000
[183145.329396]  ffff8800d8a6fc28 ffffffffa0587433 ffff88001b8d5578
ffffffe21b8d5578
[183145.329398] Call Trace:
[183145.329416]  [<ffffffffa0580d05>] free_reloc_roots+0x25/0x40 [btrfs]
[183145.329433]  [<ffffffffa0587433>] merge_reloc_roots+0x173/0x240 [btrfs]
[183145.329450]  [<ffffffffa0587765>] relocate_block_group+0x265/0x640 [btrfs]
[183145.329467]  [<ffffffffa0587d03>]
btrfs_relocate_block_group+0x1c3/0x2d0 [btrfs]
[183145.329485]  [<ffffffffa055a75e>]
btrfs_relocate_chunk.isra.39+0x3e/0xc0 [btrfs]
[183145.329503]  [<ffffffffa055bcae>] __btrfs_balance+0x49e/0x8e0 [btrfs]
[183145.329521]  [<ffffffffa055c46d>] btrfs_balance+0x37d/0x650 [btrfs]
[183145.329539]  [<ffffffffa055c79d>] balance_kthread+0x5d/0x80 [btrfs]
[183145.329556]  [<ffffffffa055c740>] ? btrfs_balance+0x650/0x650 [btrfs]
[183145.329559]  [<ffffffff81097d08>] kthread+0xd8/0xf0
[183145.329562]  [<ffffffff81097c30>] ? kthread_create_on_node+0x1b0/0x1b0
[183145.329565]  [<ffffffff816ce05f>] ret_from_fork+0x3f/0x70
[183145.329567]  [<ffffffff81097c30>] ? kthread_create_on_node+0x1b0/0x1b0
[183145.329569] Code: f7 e8 90 cc 14 e1 49 8b 04 24 49 8b 9d 68 05 00
00 48 8b 10 48 85 db 74 0f 48 3b 53 18 73 79 48 8b 5b 10 48 85 db 75
f1 4c 89 f7 <c6> 07 00 0f 1f 40 00 48 85 db 74 58 4c 3b 63 20 75 7a 49
8b 84
