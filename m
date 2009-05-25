From: Quentin Godfroy <godfroy@clipper.ens.fr>
Subject: Ooops on system.posix_acl_access xattr deletion, btrfs from 2.6.29
Date: Mon, 25 May 2009 22:23:45 +0200
Message-ID: <20090525202345.GC2779@goelette.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list

I seem to have a bug with acl deletions.

I have a filsesystem where doing

$touch test
$setfacl -m user:david:rw test
$setfattr -x system.posix_acl_access test

generates an oops, and an unusable-fs-until-reboot afterwards.

I checked briefly on git and on the mailing list, but I didn't see anything
which would be like this.

Regards,
Quentin Godfroy

dmesg trace follows:

[ 1096.922243] device label tmp devid 3 transid 117 /dev/sdc7
[ 1096.922311] device label tmp devid 2 transid 117 /dev/sdb7
[ 1096.922378] device label tmp devid 1 transid 117 /dev/sda7
[ 1398.104928] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
[ 1398.104937] IP: [<ffffffff802f5610>] posix_acl_equiv_mode+0x0/0x95
[ 1398.104948] PGD 211d01067 PUD 21c455067 PMD 0 
[ 1398.104953] Oops: 0000 [#1] SMP 
[ 1398.104957] last sysfs file: /sys/devices/pci0000:00/0000:00:06.0/0000:02:00.0/irq
[ 1398.104961] CPU 3 
[ 1398.104964] Modules linked in: kvm_amd kvm powernow_k8 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ipv6 ext2 fuse loop raid0 raid1 it87 hwmon_vid btrfs zlib_deflate zlib_inflate crc32c libcrc32c ext4 mbcache jbd2 crc16 snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_hwdep snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event i2c_piix4 snd_seq snd_timer snd_seq_device psmouse i2c_core evdev pcspkr serio_raw snd soundcore button snd_page_alloc jfs nls_base usbhid hid raid456 md_mod async_xor async_memcpy async_tx xor ide_cd_mod cdrom sd_mod crc_t10dif ide_pci_generic ata_generic ahci ohci_hcd libata atiixp ide_core ehci_hcd atl1 scsi_mod mii thermal processor fan thermal_sys
[ 1398.105045] Pid: 4516, comm: setfattr Not tainted 2.6.29-2-amd64 #1 System Product Name
[ 1398.105049] RIP: 0010:[<ffffffff802f5610>]  [<ffffffff802f5610>] posix_acl_equiv_mode+0x0/0x95
[ 1398.105056] RSP: 0018:ffff8802131f5d70  EFLAGS: 00010246
[ 1398.105059] RAX: 00000000000081b4 RBX: 0000000000000000 RCX: 0000000000000000
[ 1398.105062] RDX: 0000000000008000 RSI: ffff8802131f5d9c RDI: 0000000000000000
[ 1398.105066] RBP: 0000000000008000 R08: 0000000000000002 R09: ffffffffa0387d70
[ 1398.105069] R10: 0000000000000011 R11: ffffffffa037209a R12: 0000000000008000
[ 1398.105073] R13: 0000000000000000 R14: ffff88022adafcb0 R15: 0000000000000000
[ 1398.105077] FS:  00007f8441fb56f0(0000) GS:ffff88022eae0a40(0000) knlGS:0000000000000000
[ 1398.105081] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1398.105084] CR2: 0000000000000004 CR3: 00000002131f8000 CR4: 00000000000006e0
[ 1398.105087] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1398.105091] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1398.105095] Process setfattr (pid: 4516, threadinfo ffff8802131f4000, task ffff88022bc2a660)
[ 1398.105098] Stack:
[ 1398.105100]  ffffffffa0371f47 ffff88022bd332c0 ffff8802131f5e98 ffff8802131f5dd8
[ 1398.105106]  ffffffff802c4384 000081b413070000 0000000000000000 0000000000000000
[ 1398.105111]  0000000000008000 ffff88022adafcb0 ffff88021ddf6e00 0000000000000000
[ 1398.105118] Call Trace:
[ 1398.105121]  [<ffffffffa0371f47>] ? btrfs_set_acl+0x5a/0x155 [btrfs]
[ 1398.105159]  [<ffffffff802c4384>] ? path_to_nameidata+0x15/0x37
[ 1398.105166]  [<ffffffffa0372086>] ? btrfs_xattr_set_acl+0x44/0x58 [btrfs]
[ 1398.105197]  [<ffffffff802d3c39>] ? vfs_removexattr+0x71/0x92
[ 1398.105204]  [<ffffffff802d3c94>] ? removexattr+0x3a/0x46
[ 1398.105209]  [<ffffffff802c7aa1>] ? user_path_at+0x52/0x79
[ 1398.105215]  [<ffffffff802a7eb1>] ? do_brk+0x2ed/0x34e
[ 1398.105219]  [<ffffffff80227dbc>] ? default_spin_lock_flags+0x5/0x9
[ 1398.105225]  [<ffffffff80479d3c>] ? _spin_lock_irqsave+0x24/0x2c
[ 1398.105231]  [<ffffffff80479de2>] ? _spin_lock+0x5/0x7
[ 1398.105235]  [<ffffffff802d0675>] ? mnt_want_write+0x74/0x86
[ 1398.105240]  [<ffffffff802d3da7>] ? sys_removexattr+0x41/0x61
[ 1398.105245]  [<ffffffff802110aa>] ? system_call_fastpath+0x16/0x1b
[ 1398.105253] Code: eb 10 83 fa 20 74 09 83 fa 08 75 19 85 ff 75 15 30 d2 48 83 c1 08 4c 39 c1 0f 82 6a ff ff ff 31 c0 85 d2 74 05 b8 ea ff ff ff c3 <8b> 47 04 48 8d 4f 08 31 d2 4c 8d 44 c7 08 31 ff eb 6b 66 8b 01 
[ 1398.105294] RIP  [<ffffffff802f5610>] posix_acl_equiv_mode+0x0/0x95
[ 1398.105299]  RSP <ffff8802131f5d70>
[ 1398.105301] CR2: 0000000000000004
[ 1398.105305] ---[ end trace 85756724ad8730d7 ]---

