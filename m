From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Oops with enospc-branch
Date: Mon, 14 Sep 2009 13:26:48 +0200
Message-ID: <200909141326.48354.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With the enospc-branch my system oops with some workload. Netconsole gave me 
this trace:

nc6: using datagram socket
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:2829!
invalid opcode: 0000 [#1]
last sysfs file: 
/sys/devices/pci0000:00/0000:00:06.0/0000:02:05.0/host1/target1:0:0/1:0:0:0/block/sdb/size
CPU 0
Modules linked in: netconsole configfs snd_seq_midi snd_emu10k1_synth 
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss btrfs zlib_deflate crc32c 
libcrc32c aes_x86_64 aes_generic xts gf128mul dm_crypt snd_emu10k1 snd_rawmidi 
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc 
snd_util_mem snd_hwdep sg snd sr_mod ehci_hcd ohci_hcd uhci_hcd
Pid: 2880, comm: ebuild.sh Not tainted 2.6.30-btrfs #3 To Be Filled By O.E.M.
RIP: 0010:[<ffffffffa011f548>]  [<ffffffffa011f548>] 
btrfs_unreserve_metadata_space+0x75/0x89 [btrfs]
RSP: 0018:ffff880044c67c88  EFLAGS: 00010287
RAX: 0000000000000000 RBX: ffff88005e5e0000 RCX: 0000000000001000
RDX: ffff88005e87b900 RSI: ffff88005db93d48 RDI: ffff88005e5e0000
RBP: ffff88005db92000 R08: 0000000000000000 R09: 000000000000002d
R10: 0000000000000246 R11: 0000000000000d28 R12: 0000000000087000
R13: ffff88004b4903b8 R14: 0000000000000000 R15: 000000000000002d
FS:  00007ffcbe66e6f0(0000) GS:ffffffff8060c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b52d8 CR3: 0000000044c6e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ebuild.sh (pid: 2880, threadinfo ffff880044c66000, task ffff88004edd2d00)
Stack:
 ffff88005529e618 ffff88004b490548 ffff88005e5e0000 ffffffffa01300ec
 ffffffffa0144cd8 ffff88005529e618 ffff88004b4903e0 0000000000000021
 0000000000000000 ffffffffa014639f 0000000000000000 0000000000001000
Call Trace:
 [<ffffffffa01300ec>] ? btrfs_clear_bit_hook+0xb4/0x185 [btrfs]
 [<ffffffffa0144cd8>] ? alloc_extent_state+0x12/0x5e [btrfs]
 [<ffffffffa014639f>] ? clear_state_bit+0x7c/0x127 [btrfs]
 [<ffffffffa01466c5>] ? clear_extent_bit+0x27b/0x2f4 [btrfs]
 [<ffffffffa0148900>] ? clear_extent_bits+0x1c/0x21 [btrfs]
 [<ffffffffa0136e63>] ? prepare_pages+0x1c5/0x234 [btrfs]
 [<ffffffffa0137480>] ? btrfs_file_write+0x3c6/0x679 [btrfs]
 [<ffffffff80275ac3>] ? vfs_write+0xa6/0x131
 [<ffffffff80275c04>] ? sys_write+0x45/0x6e
 [<ffffffff8020ac28>] ? system_call_fastpath+0x16/0x1b
Code: 00 00 8b 8b 40 02 00 00 47 8d 24 e4 4d 63 e4 48 6b c0 0e 48 01 c8 4c 0f 
af e0 48 8b 42 40 4c 39 e0 73 0c 48 c7 42 40 00 00 00 00 <0f> 0b eb 0e 4c 29 
e0 48 89 42 40 31 c0 5b 5d 41 5c c3 eb fe 55
RIP  [<ffffffffa011f548>] btrfs_unreserve_metadata_space+0x75/0x89 [btrfs]
 RSP <ffff880044c67c88>
---[ end trace a0e09bb9134da1c7 ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:2829!
invalid opcode: 0000 [#2]
last sysfs file: 
/sys/devices/pci0000:00/0000:00:06.0/0000:02:05.0/host1/target1:0:0/1:0:0:0/block/sdb/size
CPU 0
Modules linked in: netconsole configfs snd_seq_midi snd_emu10k1_synth 
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss btrfs zlib_deflate crc32c 
libcrc32c aes_x86_64 aes_generic xts gf128mul dm_crypt snd_emu10k1 snd_rawmidi 
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc 
snd_util_mem snd_hwdep sg snd sr_mod ehci_hcd ohci_hcd uhci_hcd
Pid: 2529, comm: python2.6 Tainted: G      D    2.6.30-btrfs #3 To Be Filled 
By O.E.M.
RIP: 0010:[<ffffffffa011f548>]  [<ffffffffa011f548>] 
btrfs_unreserve_metadata_space+0x75/0x89 [btrfs]
RSP: 0018:ffff88005a57dc88  EFLAGS: 00010287
RAX: 0000000000000000 RBX: ffff88005e5e0000 RCX: 0000000000001000
RDX: ffff88005e87b900 RSI: ffff88005db93d48 RDI: ffff88005e5e0000
RBP: ffff88005db92000 R08: 0000000000000000 R09: 000000000000002d
R10: 0000000000000246 R11: ffff88004b43b880 R12: 0000000000087000
R13: ffff88004ea9aca0 R14: 0000000000000000 R15: 000000000000002d
FS:  00007f5d02dd56f0(0000) GS:ffffffff8060c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5d02e06000 CR3: 000000005a5ed000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process python2.6 (pid: 2529, threadinfo ffff88005a57c000, task ffff88005a510000)
Stack:
 ffff88004b40b528 ffff88004ea9ae30 ffff88005e5e0000 ffffffffa01300ec
 0000000000000000 ffff88004b40b528 ffff88004ea9acc8 0000000000000021
 0000000000000000 ffffffffa014639f 0000000000000000 0000000000000000
Call Trace:
 [<ffffffffa01300ec>] ? btrfs_clear_bit_hook+0xb4/0x185 [btrfs]
 [<ffffffffa014639f>] ? clear_state_bit+0x7c/0x127 [btrfs]
 [<ffffffffa01466c5>] ? clear_extent_bit+0x27b/0x2f4 [btrfs]
 [<ffffffffa0148900>] ? clear_extent_bits+0x1c/0x21 [btrfs]
 [<ffffffffa0136e63>] ? prepare_pages+0x1c5/0x234 [btrfs]
 [<ffffffffa0137480>] ? btrfs_file_write+0x3c6/0x679 [btrfs]
 [<ffffffff80275ac3>] ? vfs_write+0xa6/0x131
 [<ffffffff80275c04>] ? sys_write+0x45/0x6e
 [<ffffffff8020ac28>] ? system_call_fastpath+0x16/0x1b
Code: 00 00 8b 8b 40 02 00 00 47 8d 24 e4 4d 63 e4 48 6b c0 0e 48 01 c8 4c 0f 
af e0 48 8b 42 40 4c 39 e0 73 0c 48 c7 42 40 00 00 00 00 <0f> 0b eb 0e 4c 29 
e0 48 89 42 40 31 c0 5b 5d 41 5c c3 eb fe 55
RIP  [<ffffffffa011f548>] btrfs_unreserve_metadata_space+0x75/0x89 [btrfs]
 RSP <ffff88005a57dc88>
---[ end trace a0e09bb9134da1c8 ]---
SysRq : Emergency Sync
SysRq : Emergency Remount R/O
SysRq : Resetting


The system is a 64bit gentoo (AMD Opteron 144) with gcc-4.4.1. I was able to 
reproduce the oops simple with 'emerge --oneshot ati-drivers' in this case. 
