From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: btrfs not iSCSI-target safe?
Date: Wed, 22 Jul 2009 13:27:06 +0200
Message-ID: <20090722112706.GA7374@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


  Hi,

I tried to export file from btrfs volume using iSCSI target.
As soon as some initiator have read it over network, server
oopsed: http://www.kerneloops.org/submitresult.php?number=557979
 Kernel is Fedora's 2.6.29.6-213.fc11.x86_64. I'm aware that
target iSCSI functionality is out-of-tree (I'm using iscsitarget-0.4.17-3),
so it may not be safe. But is there any known incompatibility
between iscsi-target and btrfs?

  Full oops follows:
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
PGD 311fb067 PUD 31d8d067 PMD 0 
Oops: 0010 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/sda2/stat
CPU 1 
Modules linked in: iscsi_trgt fuse tun sit tunnel4 sco bridge stp llc bnep l2cap bluetooth sunrpc nf_conntrack_ftp nf_conntrack_netbios_ns ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand acpi_cpufreq freq_table btrfs zlib_deflate libcrc32c dm_multipath uinput ppdev dcdbas snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer i2c_i801 snd pcspkr serio_raw iTCO_wdt soundcore snd_page_alloc e100 iTCO_vendor_support mii parport_pc parport tg3 joydev ata_generic pata_acpi sha256_generic cbc aes_x86_64 aes_generic dm_crypt i915 drm i2c_algo_bit i2c_core video output [last unloaded: iscsi_trgt]
Pid: 5278, comm: istiod1 Not tainted 2.6.29.6-213.fc11.x86_64 #1 OptiPlex GX620               
RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
RSP: 0018:ffff8800bf4e1c98  EFLAGS: 00010286
RAX: ffffffffa01e5d20 RBX: ffff8800bf4e1ca0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff8800bf4e1d90 RDI: ffff8800bf4e1ca0
RBP: ffff8800bf4e1dc0 R08: ffff8800bf4e0000 R09: ffff880001035d00
R10: 000000c601b64c57 R11: ffff880062489dc0 R12: ffff8800bf4e1df8
R13: ffff88003103df00 R14: ffff8800bf4e1d90 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8800dde99100(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000008296e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process istiod1 (pid: 5278, threadinfo ffff8800bf4e0000, task ffff880047450000)
Stack:
 ffffffff810d4eee ffffffff81038bc0 ffff8800626f0038 0000000000000000
 ffffffff00000001 ffff88003103df00 0000000000000000 0000000000000000
 0000000000000000 0000000000000000 ffff880047450000 0000000000000000
Call Trace:
 [<ffffffff810d4eee>] ? do_sync_write+0xe8/0x125
 [<ffffffff81038bc0>] ? wakeup_preempt_entity+0x3d/0x49
 [<ffffffff8105c8d7>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8103a0e9>] ? __dequeue_entity+0x33/0x38
 [<ffffffffa03bc024>] fileio_make_request+0x14b/0x1dd [iscsi_trgt]
 [<ffffffffa03b511e>] tio_write+0x4f/0x51 [iscsi_trgt]
 [<ffffffffa03bc93a>] build_write_response+0x97/0xb5 [iscsi_trgt]
 [<ffffffffa03b81f6>] send_scsi_rsp+0x15/0xaf [iscsi_trgt]
 [<ffffffffa03bc7f2>] disk_execute_cmnd+0x171/0x19b [iscsi_trgt]
 [<ffffffffa03b9909>] worker_thread+0xb5/0x183 [iscsi_trgt]
 [<ffffffff8104057d>] ? default_wake_function+0x0/0x14
 [<ffffffffa03b9854>] ? worker_thread+0x0/0x183 [iscsi_trgt]
 [<ffffffff8105c541>] kthread+0x4d/0x78
 [<ffffffff8101264a>] child_rip+0xa/0x20
 [<ffffffff81011f67>] ? restore_args+0x0/0x30
 [<ffffffff8105c4f4>] ? kthread+0x0/0x78
 [<ffffffff81012640>] ? child_rip+0x0/0x20
Code:  Bad RIP value.
RIP  [<(null)>] (null)
 RSP <ffff8800bf4e1c98>
CR2: 0000000000000000
---[ end trace 9e41df932c81a801 ]---

-- 
Tomasz Torcz               "Never underestimate the bandwidth of a station
xmpp: zdzichubg@chrome.pl    wagon filled with backup tapes." -- Jim Gray

