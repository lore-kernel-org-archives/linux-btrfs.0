From: Grissiom <chaos.proton@gmail.com>
Subject: mount a compressed btrfs without compress cause kernel oops
Date: Thu, 2 Sep 2010 19:52:03 +0800
Message-ID: <AANLkTinBa7XTDD-psu421Ak=mmnjq00AJA6DGF7K7DPH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "chaos.proton" <chaos.proton@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello devs,

I'm a slackware user that tried btrfs recently. My kernel version is
2.6.35.4, btrfs-progs is on the date of 20100902.

I have sdb7 in btrfs. I mounted with compress feature in the past, and
had put some files(~8GB) in it. However, I mount it without compress
feature today. When I rsync on the disk, kernel oops as follows:

lost page write due to I/O error on sdb7
end_request: I/O error, dev sdb, sector 131072
lost page write due to I/O error on sdb7
btrfs: 1 errors while writing supers
------------[ cut here ]------------
kernel BUG at fs/btrfs/disk-io.c:2292!
invalid opcode: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:14.4/0000:08:00.0/ssb1:0/net/eth0/carrier
CPU 1
Modules linked in: btrfs ipv6 radeon ttm drm_kms_helper drm
i2c_algo_bit snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss nls_cp936 vfat fat ext3 jbd
cpufreq_ondemand cpufreq_performance cpufreq_powersave powernow_k8
freq_table mperf agpgart lp ppdev parport_pc parport fuse
snd_hda_codec_idt b43 ohci_hcd snd_hda_intel joydev mac80211
usb_storage b44 snd_hda_codec cfg80211 video ssb thermal snd_hwdep
snd_pcm sdhci_pci sdhci processor snd_timer dell_laptop mmc_core
pcmcia rfkill thermal_sys snd soundcore psmouse rtc_cmos i2c_piix4
battery snd_page_alloc k8temp i2c_core dell_wmi rtc_core button ac mii
led_class wmi pcmcia_core rtc_lib hwmon serio_raw shpchp ehci_hcd
output dcdbas evdev sg ext4 mbcache jbd2

Pid: 17348, comm: btrfs-transacti Not tainted 2.6.35.4 #1 0PR523/Inspiron 1501
RIP: 0010:[<ffffffffa073240c>]  [<ffffffffa073240c>]
write_all_supers+0x25c/0x260 [btrfs]
RSP: 0018:ffff88003e2a1d40  EFLAGS: 00010282
RAX: 000000000000002b RBX: ffff8800498e0de8 RCX: ffffffff8196cf20
RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff8196cdd4
RBP: ffff88003e2a1da0 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8800498e0de8 R14: ffff880047a14000 R15: 0000000000000001
FS:  00007f60561ba740(0000) GS:ffff880001d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000085cd18 CR3: 0000000075d22000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-transacti (pid: 17348, threadinfo ffff88003e2a0000, task
ffff8800396a0000)
Stack:
 ffff8800396b8f4e ffff8800396b8f5e ffff8800498e0d80 0000000000000000
<0> ffff8800396b8e43 0000000100000001 ffff88003e2a1da0 ffff880047a14000
<0> ffff88003908c0e8 ffff88003e2a1df0 ffff88003908c158 0000000000000001
Call Trace:
 [<ffffffffa0732423>] write_ctree_super+0x13/0x20 [btrfs]
 [<ffffffffa07374ab>] btrfs_commit_transaction+0x4cb/0x6f0 [btrfs]
 [<ffffffff810665a0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa0731923>] transaction_kthread+0x263/0x270 [btrfs]
 [<ffffffffa07316c0>] ? transaction_kthread+0x0/0x270 [btrfs]
 [<ffffffff81066096>] kthread+0x96/0xa0
 [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066000>] ? kthread+0x0/0xa0
 [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
Code: 5e 41 5f c9 c3 44 89 fe 48 c7 c7 f8 d6 77 a0 31 c0 e8 f8 14 d4
e0 0f 0b eb fe 44 89 e6 48 c7 c7 f8 d6 77 a0 31 c0 e8 e3 14 d4 e0 <0f>
0b eb fe 55 48 89 e5 0f 1f 44 00 00 48 89 f7 89 d6 e8 8d fd
RIP  [<ffffffffa073240c>] write_all_supers+0x25c/0x260 [btrfs]
 RSP <ffff88003e2a1d40>
---[ end trace 854c315770163d00 ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:247!
invalid opcode: 0000 [#2] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:14.4/0000:08:00.0/ssb1:0/net/eth0/carrier
CPU 1
Modules linked in: btrfs ipv6 radeon ttm drm_kms_helper drm
i2c_algo_bit snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss nls_cp936 vfat fat ext3 jbd
cpufreq_ondemand cpufreq_performance cpufreq_powersave powernow_k8
freq_table mperf agpgart lp ppdev parport_pc parport fuse
snd_hda_codec_idt b43 ohci_hcd snd_hda_intel joydev mac80211
usb_storage b44 snd_hda_codec cfg80211 video ssb thermal snd_hwdep
snd_pcm sdhci_pci sdhci processor snd_timer dell_laptop mmc_core
pcmcia rfkill thermal_sys snd soundcore psmouse rtc_cmos i2c_piix4
battery snd_page_alloc k8temp i2c_core dell_wmi rtc_core button ac mii
led_class wmi pcmcia_core rtc_lib hwmon serio_raw shpchp ehci_hcd
output dcdbas evdev sg ext4 mbcache jbd2

Pid: 17414, comm: flush-btrfs-4 Tainted: G      D     2.6.35.4 #1
0PR523/Inspiron 1501
RIP: 0010:[<ffffffffa073b51d>]  [<ffffffffa073b51d>]
cow_file_range_inline+0x16d/0x180 [btrfs]
RSP: 0018:ffff880038f63790  EFLAGS: 00010282
RAX: 00000000fffffffb RBX: 0000000000000000 RCX: ffff880022e7a510
RDX: ffff880001d1b800 RSI: 0000000000000000 RDI: ffff880022e7ab40
RBP: ffff880038f63800 R08: 0000000000000001 R09: 0000000000000000
R10: 000000000000009e R11: ffff88004025a840 R12: ffff88002779f800
R13: ffff880024bc0938 R14: 000000000000009e R15: 0000000000001000
FS:  00007f4dbb8a1700(0000) GS:ffff880001d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007faabc0b0fc4 CR3: 00000000276cc000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-btrfs-4 (pid: 17414, threadinfo ffff880038f62000, task
ffff8800396a0ce0)
Stack:
 ffff880038f637f0 ffffffffa0737ada ffff88004025a840 000000000000009e
<0> 0000000000001000 000000000000009e ffff880038f637f0 0000000000000fff
<0> 0000000000000000 0000000000000fff 0000000000000000 ffff880038f63a60
Call Trace:
 [<ffffffffa0737ada>] ? start_transaction+0x1aa/0x230 [btrfs]
 [<ffffffffa073b7ef>] cow_file_range+0x2bf/0x340 [btrfs]
 [<ffffffffa07549c9>] ? set_extent_bit+0x149/0x4e0 [btrfs]
 [<ffffffffa07408bb>] run_delalloc_range+0x33b/0x3d0 [btrfs]
 [<ffffffffa0758bbd>] __extent_writepage+0x56d/0x6c0 [btrfs]
 [<ffffffffa0755540>] ? end_bio_extent_writepage+0x0/0x180 [btrfs]
 [<ffffffffa0759068>] T.879+0x1f8/0x360 [btrfs]
 [<ffffffffa07393e0>] ? btrfs_submit_bio_hook+0xf0/0x130 [btrfs]
 [<ffffffffa0739440>] ? __btrfs_submit_bio_start+0x0/0x30 [btrfs]
 [<ffffffffa0739420>] ? __btrfs_submit_bio_done+0x0/0x20 [btrfs]
 [<ffffffffa07592e4>] extent_writepages+0x44/0x60 [btrfs]
 [<ffffffffa0742060>] ? btrfs_get_extent+0x0/0x8b0 [btrfs]
 [<ffffffff81066464>] ? bit_waitqueue+0x14/0xd0
 [<ffffffffa0739dc7>] btrfs_writepages+0x27/0x30 [btrfs]
 [<ffffffff810cee11>] do_writepages+0x21/0x40
 [<ffffffff81120476>] writeback_single_inode+0xd6/0x3c0
 [<ffffffff81120bac>] writeback_sb_inodes+0x17c/0x260
 [<ffffffff81121317>] writeback_inodes_wb+0x97/0x190
 [<ffffffff81121643>] wb_writeback+0x233/0x2a0
 [<ffffffff81058442>] ? del_timer_sync+0x22/0x30
 [<ffffffff81121846>] wb_do_writeback+0x196/0x1a0
 [<ffffffff81057a50>] ? process_timeout+0x0/0x10
 [<ffffffff8112189f>] bdi_writeback_task+0x4f/0x160
 [<ffffffff81066467>] ? bit_waitqueue+0x17/0xd0
 [<ffffffff810dcc40>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff810dccb1>] bdi_start_fn+0x71/0xe0
 [<ffffffff810dcc40>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff81066096>] kthread+0x96/0xa0
 [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066000>] ? kthread+0x0/0xa0
 [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
Code: 00 00 00 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b
7d f8 c9 c3 0f 1f 44 00 00 4d 39 f2 4d 0f 46 f2 4c 89 75 b8 eb 8a <0f>
0b eb fe 0f 0b eb fe 66 66 2e 0f 1f 84 00 00 00 00 00 55 48
RIP  [<ffffffffa073b51d>] cow_file_range_inline+0x16d/0x180 [btrfs]
 RSP <ffff880038f63790>
---[ end trace 854c315770163d01 ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:2871!
invalid opcode: 0000 [#3] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:14.4/0000:08:00.0/ssb1:0/net/eth0/carrier
CPU 1
Modules linked in: btrfs ipv6 radeon ttm drm_kms_helper drm
i2c_algo_bit snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss nls_cp936 vfat fat ext3 jbd
cpufreq_ondemand cpufreq_performance cpufreq_powersave powernow_k8
freq_table mperf agpgart lp ppdev parport_pc parport fuse
snd_hda_codec_idt b43 ohci_hcd snd_hda_intel joydev mac80211
usb_storage b44 snd_hda_codec cfg80211 video ssb thermal snd_hwdep
snd_pcm sdhci_pci sdhci processor snd_timer dell_laptop mmc_core
pcmcia rfkill thermal_sys snd soundcore psmouse rtc_cmos i2c_piix4
battery snd_page_alloc k8temp i2c_core dell_wmi rtc_core button ac mii
led_class wmi pcmcia_core rtc_lib hwmon serio_raw shpchp ehci_hcd
output dcdbas evdev sg ext4 mbcache jbd2

Pid: 17579, comm: rsync Tainted: G      D     2.6.35.4 #1 0PR523/Inspiron 1501
RIP: 0010:[<ffffffffa073c7a3>]  [<ffffffffa073c7a3>]
btrfs_unlink+0x103/0x110 [btrfs]
RSP: 0018:ffff8800223dde38  EFLAGS: 00010282
RAX: 00000000fffffffb RBX: ffff88004025a900 RCX: ffff880022e7aea0
RDX: ffff880001d1b800 RSI: 0000000000000000 RDI: ffff880022e7a510
RBP: ffff8800223dde68 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000fffffffb
R13: ffff880030986fa8 R14: ffff88002779f800 R15: ffff880030ac27f8
FS:  00007f4dbb8a1700(0000) GS:ffff880001d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f4dbb0053b0 CR3: 00000000276cc000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rsync (pid: 17579, threadinfo ffff8800223dc000, task ffff8800777853b0)
Stack:
 ffff8800223dde68 ffff880077366540 ffff880030986fa8 ffff880030ac27f8
<0> 0000000000000000 00007fff92404860 ffff8800223dde98 ffffffff8110ab78
<0> ffff8800223dde98 ffffffff8110b565 ffff8800223ddea8 ffff880077366540
Call Trace:
 [<ffffffff8110ab78>] vfs_unlink+0x98/0xf0
 [<ffffffff8110b565>] ? lookup_hash+0x35/0x50
 [<ffffffff8110cf83>] do_unlinkat+0x183/0x1c0
 [<ffffffff8102b9a6>] ? do_page_fault+0x136/0x280
 [<ffffffff8110cfd6>] sys_unlink+0x16/0x20
 [<ffffffff810027db>] system_call_fastpath+0x16/0x1b
Code: 8b 90 04 22 00 00 85 d2 74 2a c7 80 04 22 00 00 00 00 00 00 eb
b6 66 90 4c 89 fe 48 89 df e8 65 d9 ff ff 85 c0 74 8d 0f 0b eb fe <0f>
0b eb fe 41 89 c4 eb ae 0f 0b eb fe 55 48 89 e5 41 57 41 56
RIP  [<ffffffffa073c7a3>] btrfs_unlink+0x103/0x110 [btrfs]
 RSP <ffff8800223dde38>
---[ end trace 854c315770163d02 ]---

I hope this debug info could help you some. Also, my sdb5 is btrfs
too. After the above event, I run a btrfsck on it, it yeilds:

# btrfsck /dev/sdb5
root 5 inode 164968 errors 2000
root 5 inode 406295 errors 2000
root 5 inode 409945 errors 2000
root 5 inode 409946 errors 2000
root 5 inode 409947 errors 2000
root 5 inode 409948 errors 2000
root 5 inode 409949 errors 2000
root 5 inode 409950 errors 2000
root 5 inode 409952 errors 2000
root 5 inode 409953 errors 2000
root 5 inode 409955 errors 2000
root 5 inode 409956 errors 2000
root 5 inode 409957 errors 2000
root 5 inode 409958 errors 2000
root 5 inode 409959 errors 2000
root 5 inode 409960 errors 2000
root 5 inode 409961 errors 2000
root 5 inode 409962 errors 2000
root 5 inode 409963 errors 2000
root 5 inode 409964 errors 2000
root 5 inode 409965 errors 2000
root 5 inode 409966 errors 2000
root 5 inode 409967 errors 2000
root 5 inode 409968 errors 2000
root 5 inode 409969 errors 2000
root 5 inode 409970 errors 2000
root 5 inode 409971 errors 2000
root 5 inode 409972 errors 2000
root 5 inode 409973 errors 2000
root 5 inode 409974 errors 2000
root 5 inode 409975 errors 2000
root 5 inode 409976 errors 2000
root 5 inode 409977 errors 2000
root 5 inode 409978 errors 2000
root 5 inode 409979 errors 2000
root 5 inode 409980 errors 2000
root 5 inode 409981 errors 2000
root 5 inode 409982 errors 2000
root 5 inode 409983 errors 2000
root 5 inode 409984 errors 2000
root 5 inode 409985 errors 2000
root 5 inode 409986 errors 2000
root 5 inode 409988 errors 2000
root 5 inode 409989 errors 2000
root 5 inode 409990 errors 2000
root 5 inode 409991 errors 2000
root 5 inode 409992 errors 2000
root 5 inode 409993 errors 2000
root 5 inode 409994 errors 2000
root 5 inode 409995 errors 2000
root 5 inode 409996 errors 2000
root 5 inode 409997 errors 2000
root 5 inode 409998 errors 2000
root 5 inode 409999 errors 2000
root 5 inode 410000 errors 2000
root 5 inode 410001 errors 2000
root 5 inode 410002 errors 2000
root 5 inode 410003 errors 2000
root 5 inode 410004 errors 2000
root 5 inode 410005 errors 2000
root 5 inode 410006 errors 2000
root 5 inode 410007 errors 2000
root 5 inode 410008 errors 2000
root 5 inode 410009 errors 2000
root 5 inode 410010 errors 2000
root 5 inode 410011 errors 2000
root 5 inode 410012 errors 2000
root 5 inode 410013 errors 2000
root 5 inode 410014 errors 2000
root 5 inode 410015 errors 2000
root 5 inode 410016 errors 2000
root 5 inode 410017 errors 2000
root 5 inode 410018 errors 2000
root 5 inode 410019 errors 2000
root 5 inode 410020 errors 2000
root 5 inode 410021 errors 2000
root 5 inode 410022 errors 2000
root 5 inode 410023 errors 2000
root 5 inode 410024 errors 2000
root 5 inode 410025 errors 2000
root 5 inode 410026 errors 2000
root 5 inode 410027 errors 2000
root 5 inode 410028 errors 2000
root 5 inode 410029 errors 2000
root 5 inode 410030 errors 2000
root 5 inode 410031 errors 2000
root 5 inode 410033 errors 2000
root 5 inode 410034 errors 2000
root 5 inode 410035 errors 2000
root 5 inode 410036 errors 2000
root 5 inode 410037 errors 2000
root 5 inode 410038 errors 2000
root 5 inode 410039 errors 2000
root 5 inode 410040 errors 2000
root 5 inode 410041 errors 2000
root 5 inode 410042 errors 2000
root 5 inode 410043 errors 2000
root 5 inode 410044 errors 2000
root 5 inode 410045 errors 2000
root 5 inode 410046 errors 2000
root 5 inode 410047 errors 2000
root 5 inode 410048 errors 2000
root 5 inode 410049 errors 2000
root 5 inode 410050 errors 2000
root 5 inode 410051 errors 2000
root 5 inode 410052 errors 2000
root 5 inode 410053 errors 2000
root 5 inode 410054 errors 2000
root 5 inode 410055 errors 2000
root 5 inode 410056 errors 2000
root 5 inode 410057 errors 2000
root 5 inode 410058 errors 2000
root 5 inode 410059 errors 2000
root 5 inode 410060 errors 2000
root 5 inode 410061 errors 2000
root 5 inode 410062 errors 2000
root 5 inode 410065 errors 2000
root 5 inode 410066 errors 2000
root 5 inode 410067 errors 2000
root 5 inode 410068 errors 2000
root 5 inode 410069 errors 2000
root 5 inode 410070 errors 2000
root 5 inode 410071 errors 2000
root 5 inode 410072 errors 2000
root 5 inode 410073 errors 2000
root 5 inode 410074 errors 2000
root 5 inode 410075 errors 2000
root 5 inode 410076 errors 2000
root 5 inode 410077 errors 2000
root 5 inode 410078 errors 2000
root 5 inode 410079 errors 2000
root 5 inode 410080 errors 2000
root 5 inode 410081 errors 2000
root 5 inode 410082 errors 2000
root 5 inode 410083 errors 2000
root 5 inode 410084 errors 2000
root 5 inode 410085 errors 2000
root 5 inode 410086 errors 2000
root 5 inode 410089 errors 2000
root 5 inode 410090 errors 2000
root 5 inode 410091 errors 2000
root 5 inode 410092 errors 2000
root 5 inode 410093 errors 2000
root 5 inode 410094 errors 2000
root 5 inode 410095 errors 2000
root 5 inode 410096 errors 2000
root 5 inode 410097 errors 2000
root 5 inode 410098 errors 2000
root 5 inode 410099 errors 2000
root 5 inode 410100 errors 2000
root 5 inode 410101 errors 2000
root 5 inode 410102 errors 2000
root 5 inode 410103 errors 2000
root 5 inode 410104 errors 2000
root 5 inode 410105 errors 2000
root 5 inode 410106 errors 2000
root 5 inode 410107 errors 2000
root 5 inode 410108 errors 2000
root 5 inode 410109 errors 2000
root 5 inode 410110 errors 2000
root 5 inode 410111 errors 2000
root 5 inode 410112 errors 2000
root 5 inode 410113 errors 2000
root 5 inode 410114 errors 2000
root 5 inode 410115 errors 2000
root 5 inode 410116 errors 2000
root 5 inode 410118 errors 2000
root 5 inode 410119 errors 2000
root 5 inode 410121 errors 2000
root 5 inode 410122 errors 2000
root 5 inode 410124 errors 2000
root 5 inode 410125 errors 2000
root 5 inode 410127 errors 2000
root 5 inode 410128 errors 2000
root 5 inode 410129 errors 2000
root 5 inode 410133 errors 2000
root 5 inode 410134 errors 2000
root 5 inode 410135 errors 2000
root 5 inode 410136 errors 2000
root 5 inode 410137 errors 2000
root 5 inode 410138 errors 2000
root 5 inode 410139 errors 2000
root 5 inode 410140 errors 2000
root 5 inode 410141 errors 2000
root 5 inode 410142 errors 2000
root 5 inode 410143 errors 2000
root 5 inode 410144 errors 2000
root 5 inode 410145 errors 2000
root 5 inode 410148 errors 2000
root 5 inode 410149 errors 2000
root 5 inode 410150 errors 2000
root 257 inode 164968 errors 2000
root 257 inode 406295 errors 2000
root 257 inode 409945 errors 2000
root 257 inode 409946 errors 2000
root 257 inode 409947 errors 2000
root 257 inode 409948 errors 2000
root 257 inode 409949 errors 2000
root 257 inode 409950 errors 2000
root 257 inode 409952 errors 2000
root 257 inode 409953 errors 2000
root 257 inode 409955 errors 2000
root 257 inode 409956 errors 2000
root 257 inode 409957 errors 2000
root 257 inode 409958 errors 2000
root 257 inode 409959 errors 2000
root 257 inode 409960 errors 2000
root 257 inode 409961 errors 2000
root 257 inode 409962 errors 2000
root 257 inode 409963 errors 2000
root 257 inode 409964 errors 2000
root 257 inode 409965 errors 2000
root 257 inode 409966 errors 2000
root 257 inode 409967 errors 2000
root 257 inode 409968 errors 2000
root 257 inode 409969 errors 2000
root 257 inode 409970 errors 2000
root 257 inode 409971 errors 2000
root 257 inode 409972 errors 2000
root 257 inode 409973 errors 2000
root 257 inode 409974 errors 2000
root 257 inode 409975 errors 2000
root 257 inode 409976 errors 2000
root 257 inode 409977 errors 2000
root 257 inode 409978 errors 2000
root 257 inode 409979 errors 2000
root 257 inode 409980 errors 2000
root 257 inode 409981 errors 2000
root 257 inode 409982 errors 2000
root 257 inode 409983 errors 2000
root 257 inode 409984 errors 2000
root 257 inode 409985 errors 2000
root 257 inode 409986 errors 2000
root 257 inode 409988 errors 2000
root 257 inode 409989 errors 2000
root 257 inode 409990 errors 2000
root 257 inode 409991 errors 2000
root 257 inode 409992 errors 2000
root 257 inode 409993 errors 2000
root 257 inode 409994 errors 2000
root 257 inode 409995 errors 2000
root 257 inode 409996 errors 2000
root 257 inode 409997 errors 2000
root 257 inode 409998 errors 2000
root 257 inode 409999 errors 2000
root 257 inode 410000 errors 2000
root 257 inode 410001 errors 2000
root 257 inode 410002 errors 2000
root 257 inode 410003 errors 2000
root 257 inode 410004 errors 2000
root 257 inode 410005 errors 2000
root 257 inode 410006 errors 2000
root 257 inode 410007 errors 2000
root 257 inode 410008 errors 2000
root 257 inode 410009 errors 2000
root 257 inode 410010 errors 2000
root 257 inode 410011 errors 2000
root 257 inode 410012 errors 2000
root 257 inode 410013 errors 2000
root 257 inode 410014 errors 2000
root 257 inode 410015 errors 2000
root 257 inode 410016 errors 2000
root 257 inode 410017 errors 2000
root 257 inode 410018 errors 2000
root 257 inode 410019 errors 2000
root 257 inode 410020 errors 2000
root 257 inode 410021 errors 2000
root 257 inode 410022 errors 2000
root 257 inode 410023 errors 2000
root 257 inode 410024 errors 2000
root 257 inode 410025 errors 2000
root 257 inode 410026 errors 2000
root 257 inode 410027 errors 2000
root 257 inode 410028 errors 2000
root 257 inode 410029 errors 2000
root 257 inode 410030 errors 2000
root 257 inode 410031 errors 2000
root 257 inode 410033 errors 2000
root 257 inode 410034 errors 2000
root 257 inode 410035 errors 2000
root 257 inode 410036 errors 2000
root 257 inode 410037 errors 2000
root 257 inode 410038 errors 2000
root 257 inode 410039 errors 2000
root 257 inode 410040 errors 2000
root 257 inode 410041 errors 2000
root 257 inode 410042 errors 2000
root 257 inode 410043 errors 2000
root 257 inode 410044 errors 2000
root 257 inode 410045 errors 2000
root 257 inode 410046 errors 2000
root 257 inode 410047 errors 2000
root 257 inode 410048 errors 2000
root 257 inode 410049 errors 2000
root 257 inode 410050 errors 2000
root 257 inode 410051 errors 2000
root 257 inode 410052 errors 2000
root 257 inode 410053 errors 2000
root 257 inode 410054 errors 2000
root 257 inode 410055 errors 2000
root 257 inode 410056 errors 2000
root 257 inode 410057 errors 2000
root 257 inode 410058 errors 2000
root 257 inode 410059 errors 2000
root 257 inode 410060 errors 2000
root 257 inode 410061 errors 2000
root 257 inode 410062 errors 2000
root 257 inode 410065 errors 2000
root 257 inode 410066 errors 2000
root 257 inode 410067 errors 2000
root 257 inode 410068 errors 2000
root 257 inode 410069 errors 2000
root 257 inode 410070 errors 2000
root 257 inode 410071 errors 2000
root 257 inode 410072 errors 2000
root 257 inode 410073 errors 2000
root 257 inode 410074 errors 2000
root 257 inode 410075 errors 2000
root 257 inode 410076 errors 2000
root 257 inode 410077 errors 2000
root 257 inode 410078 errors 2000
root 257 inode 410079 errors 2000
root 257 inode 410080 errors 2000
root 257 inode 410081 errors 2000
root 257 inode 410082 errors 2000
root 257 inode 410083 errors 2000
root 257 inode 410084 errors 2000
root 257 inode 410085 errors 2000
root 257 inode 410086 errors 2000
root 257 inode 410089 errors 2000
root 257 inode 410090 errors 2000
root 257 inode 410091 errors 2000
root 257 inode 410092 errors 2000
root 257 inode 410093 errors 2000
root 257 inode 410094 errors 2000
root 257 inode 410095 errors 2000
root 257 inode 410096 errors 2000
root 257 inode 410097 errors 2000
root 257 inode 410098 errors 2000
root 257 inode 410099 errors 2000
root 257 inode 410100 errors 2000
root 257 inode 410101 errors 2000
root 257 inode 410102 errors 2000
root 257 inode 410103 errors 2000
root 257 inode 410104 errors 2000
root 257 inode 410105 errors 2000
root 257 inode 410106 errors 2000
root 257 inode 410107 errors 2000
root 257 inode 410108 errors 2000
root 257 inode 410109 errors 2000
root 257 inode 410110 errors 2000
root 257 inode 410111 errors 2000
root 257 inode 410112 errors 2000
root 257 inode 410113 errors 2000
root 257 inode 410114 errors 2000
root 257 inode 410115 errors 2000
root 257 inode 410116 errors 2000
root 257 inode 410118 errors 2000
root 257 inode 410119 errors 2000
root 257 inode 410121 errors 2000
root 257 inode 410122 errors 2000
root 257 inode 410124 errors 2000
root 257 inode 410125 errors 2000
root 257 inode 410127 errors 2000
root 257 inode 410128 errors 2000
root 257 inode 410129 errors 2000
root 257 inode 410133 errors 2000
root 257 inode 410134 errors 2000
root 257 inode 410135 errors 2000
root 257 inode 410136 errors 2000
root 257 inode 410137 errors 2000
root 257 inode 410138 errors 2000
root 257 inode 410139 errors 2000
root 257 inode 410140 errors 2000
root 257 inode 410141 errors 2000
root 257 inode 410142 errors 2000
root 257 inode 410143 errors 2000
root 257 inode 410144 errors 2000
root 257 inode 410145 errors 2000
root 257 inode 410148 errors 2000
root 257 inode 410149 errors 2000
root 257 inode 410150 errors 2000
found 5536120832 bytes used err is 1
total csum bytes: 4890036
total tree bytes: 528723968
total fs tree bytes: 497389568
btree space waste bytes: 156484000
file data blocks allocated: 5645668352
 referenced 4998328320
Btrfs Btrfs v0.19

I never checked sdb5 before and I'm not sure whether this is caused by
the first failure. sdb6 is ext4 and is fine(according to fsck.ext4)

I'm not in the list so please CC me.

Thanks very much!

-- 
Cheers,
Grissiom
