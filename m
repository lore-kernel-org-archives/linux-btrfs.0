From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: replacing failed disks in RAID-1 (kernel BUG)?
Date: Mon, 13 Jul 2009 12:28:09 +0200
Message-ID: <4A5B0C39.5030905@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

How do I replace failed disks in RAID-1 mode?

I followed the http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices, but it triggered a kernel BUG (using 2.6.30.1 kernel):


# mount -o degraded /dev/sdb4 /mnt/btrfs/

# btrfs-vol -r missing /mnt/btrfs/
removing missing devices from /mnt/btrfs/
ioctl returns -1

# dmesg -c
btrfs: unable to go below two devices on raid1

# btrfs-vol -a /dev/sda4 /mnt/btrfs/
Speicherzugriffsfehler

# dmesg
btrfs allocation failed flags 18, wanted 4096
space_info has 8384512 free, is not full
space_info total=8388608, pinned=0, delalloc=0, may_use=0, used=4096
block group 20971520 has 8388608 bytes, 4096 used 0 pinned 0 reserved
entry offset 20975616, bytes 8384512
1 blocks of free space at or bigger than bytes is
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:2930!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
CPU 1
Modules linked in: btrfs zlib_deflate crc32c libcrc32c cpufreq_stats tun af_packet fglrx(P) ipv6 coretemp binfmt_misc loop ext3 jbd joydev dm_mod hid_multilaser usbhid cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table hid kvm_intel kvm snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss snd pcspkr soundcore e1000e iTCO_wdt iTCO_vendor_support serio_raw snd_page_alloc i2c_i801 rtc_cmos i2c_core evdev thermal processor button wmi ehci_hcd uhci_hcd sr_mod sg usbcore ata_piix ahci libata sd_mod scsi_mod crc_t10dif raid1 ext4 jbd2 crc16
Pid: 23996, comm: btrfs-vol Tainted: P           2.6.30.1-desktop-1mnb #1
RIP: 0010:[<ffffffffa06a5426>]  [<ffffffffa06a5426>] __btrfs_reserve_extent+0x296/0x310 [btrfs]
RSP: 0018:ffff8800bb441808  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88023cd9da2c RCX: 000000000001ffff
RDX: 0000000000000000 RSI: 0000000000000246 RDI: 0000000000000246
RBP: ffff8800bb4418b8 R08: 000000000000ddd9 R09: 000000000000000a
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88023d644c68
R13: 0000000000001000 R14: ffff88023d644d30 R15: ffff88023d644d18
FS:  00007ffc25a67740(0000) GS:ffff88002f21b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f0645383ea4 CR3: 00000000be85c000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-vol (pid: 23996, threadinfo ffff8800bb440000, task ffff88013a1a0000)
Stack:
 0000000000000000 ffff8800bb441988 0000000000000000 0000000000000000
 0000000000000012 ffff88023fc016d0 ffff8800bb4418a8 ffff880149532000
 0000000000000000 ffff8800bb441988 ffffffffffffffff 0000000000000000
Call Trace:
 [<ffffffffa06a550e>] btrfs_alloc_extent+0x6e/0x100 [btrfs]
 [<ffffffffa06a5619>] btrfs_alloc_free_block+0x79/0xd0 [btrfs]
 [<ffffffffa0693779>] __btrfs_cow_block+0x199/0x880 [btrfs]
 [<ffffffffa0693f7d>] btrfs_cow_block+0x11d/0x250 [btrfs]
 [<ffffffffa069a9b6>] btrfs_search_slot+0x476/0x8c0 [btrfs]
 [<ffffffffa069b5bd>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
 [<ffffffffa0691718>] ? btrfs_alloc_path+0x28/0x50 [btrfs]
 [<ffffffffa06d8d29>] btrfs_add_device+0x89/0x210 [btrfs]
 [<ffffffff80346db4>] ? kill_bdev+0x44/0x70
 [<ffffffffa06ddc4a>] btrfs_init_new_device+0x65a/0xb20 [btrfs]
 [<ffffffffa06e0b8d>] ? btrfs_ioctl+0x3cd/0x910 [btrfs]
 [<ffffffffa06e0baf>] btrfs_ioctl+0x3ef/0x910 [btrfs]
 [<ffffffff80325680>] vfs_ioctl+0x30/0xd0
 [<ffffffff8034de53>] ? inotify_inode_queue_event+0xf3/0x130
 [<ffffffff80213ece>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff80325e5b>] do_vfs_ioctl+0x31b/0x5b0
 [<ffffffff8027cd6c>] ? up_read+0x1c/0x40
 [<ffffffff80326189>] sys_ioctl+0x99/0xc0
 [<ffffffff80213342>] system_call_fastpath+0x16/0x1b
Code: 4c 8b 63 58 49 81 ec b0 00 00 00 49 8b 84 24 b0 00 00 00 0f 18 08 49 8d 84 24 b0 00 00 00 49 39 c7 75 27 4c 89 f7 e8 2a 79 bd df <0f> 0b eb fe be 5c 0b 00 00 48 c7 c7 9b d2 6e a0 e8 05 5d bb df
RIP  [<ffffffffa06a5426>] __btrfs_reserve_extent+0x296/0x310 [btrfs]
 RSP <ffff8800bb441808>
---[ end trace a51370eaca1eb6d6 ]---


-- 
Tomasz Chmielewski
http://wpkg.org
