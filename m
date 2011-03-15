From: Leon =?iso-8859-15?Q?Me=DFner?= <l.messner@physik.tu-berlin.de>
Subject: btrfs mount segfaults or crashes after powerloss
Date: Tue, 15 Mar 2011 01:28:56 +0100
Message-ID: <20110315002856.GC37926@emmi.physik-pool.tu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: l.messner@physik.tu-berlin.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i'm having a problem with a damaged btrfs after power loss. When i try
to mount the fs mount either segfaults (trace at bottom) or hangs in 
"D" state together with [btrfs-transacti]. I tried to btrfsck the 
filesystem multiple times. It didn't help. Btrfs tools are from todays 
git. The fs got created about half a year ago.

Please CC me as i'm not an the list.

Thanks,
Leon

# btrfsck -s 1 /dev/sdb2
using SB copy 1, bytenr 67108864
root 256 inode 257 errors 800
found 50907959296 bytes used err is 1
total csum bytes: 46730092
total tree bytes: 407293952
total fs tree bytes: 315609088
btree space waste bytes: 111966302
file data blocks allocated: 184320000000
referenced 56142348288
Btrfs v0.19-35-g1b444cd


Btrfs loaded
device label rootext4 devid 1 transid 45010 /dev/sdb2
Btrfs detected SSD devices, enabling SSD mode
------------[ cut here ]------------
kernel BUG at fs/btrfs/tree-log.c:808!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
CPU 0 
Modules linked in: btrfs zlib_deflate crc32c libcrc32c coretemp nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc ipv6 autofs4 fuse loop nvidia(P) snd_hda_codec_analog cpufreq_powersave rt2800usb rt2800lib rt2
x00usb rt2x00lib mac80211 cpufreq_ondemand cfg80211 snd_seq_dummy rfkill acpi_cpufreq snd_seq_oss snd_
seq_midi_event snd_seq snd_seq_device freq_table snd_pcm_oss snd_mixer_oss processor snd_hda_intel sg 
snd_hda_codec pcspkr snd_hwdep snd_pcm snd_timer evdev snd soundcore snd_page_alloc asus_atk0110 firew
ire_ohci firewire_core crc_itu_t floppy mperf iTCO_wdt iTCO_vendor_support intel_agp rt2870sta(C) i2c_
i801 intel_gtt i2c_core shpchp button pci_hotplug crc_ccitt slhc skge usbhid hid ext3 jbd mbcache uhci
_hcd ehci_hcd usbcore sd_mod ata_piix ahci libahci ata_generic sr_mod cdrom pata_marvell pata_acpi lib
ata scsi_mod

Pid: 4876, comm: mount Tainted: P        WC  2.6.37-ARCH #1 P5Q3 DELUXE/P5Q3 DELUXE
RIP: 0010:[<ffffffffa0ccd197>]  [<ffffffffa0ccd197>] add_inode_ref+0x457/0x470 [btrfs]
RSP: 0018:ffff880129ced868  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffff88011f0a4bb8
RDX: 00000000000003e0 RSI: ffffea0003eca3e0 RDI: 0000000000000246
RBP: ffff880129ced928 R08: fec2f5fc4a86de03 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000097
R13: ffff880129cedb18 R14: ffff88011cf52880 R15: 000000000000000c
FS:  00007f3105131740(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fff48f1dba8 CR3: 0000000107f46000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 4876, threadinfo ffff880129cec000, task ffff88012a7e0000)
Stack:
 ffff880121c54030 ffff880129ced868 0000000000000000 0000000200000000
 0000000000000000 ffff88011cf52880 0000000000000000 0000000000000000
 ffff880106632000 ffff88011cf52880 ffff880129ced908 ffff88011f0a4590
Call Trace:
 [<ffffffffa0cbcccc>] ? read_extent_buffer+0xcc/0x1e0 [btrfs]
 [<ffffffffa0cce426>] replay_one_buffer+0x2b6/0x390 [btrfs]
 [<ffffffffa0ccb522>] walk_down_log_tree+0x362/0x540 [btrfs]
 [<ffffffffa0ccb7fd>] walk_log_tree+0xfd/0x270 [btrfs]
 [<ffffffffa0cd0724>] btrfs_recover_log_trees+0x234/0x330 [btrfs]
 [<ffffffffa0cce170>] ? replay_one_buffer+0x0/0x390 [btrfs]
 [<ffffffffa0c9331b>] ? btree_read_extent_buffer_pages.clone.57+0x6b/0xb0 [btrfs]
 [<ffffffffa0c96c77>] open_ctree+0x1547/0x18c0 [btrfs]
 [<ffffffff81198c6f>] ? disk_name+0x5f/0xc0
 [<ffffffffa0c73daa>] btrfs_mount+0x4aa/0x5d0 [btrfs]
 [<ffffffff81137a88>] vfs_kern_mount+0x88/0x250
 [<ffffffff81137cbf>] do_kern_mount+0x4f/0x110
 [<ffffffff81152b03>] do_mount+0x3e3/0x800
 [<ffffffff810fe943>] ? strndup_user+0x53/0x70
 [<ffffffff8115322b>] sys_mount+0x8b/0xe0
 [<ffffffff8100bf12>] system_call_fastpath+0x16/0x1b
Code: 47 e0 48 8b bd 78 ff ff ff e8 16 fb 47 e0 31 c0 48 81 c4 98 00 00 00 5b 41 5c 41 5d 41 5e 41 5f c9 c3 b8 fe ff ff ff eb e7 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 66 66 66 2e 0f 1f 84 00 
RIP  [<ffffffffa0ccd197>] add_inode_ref+0x457/0x470 [btrfs]
 RSP <ffff880129ced868>
---[ end trace 86d34ef0b6071dc9 ]---
