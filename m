From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: BUG ON linux/ppc 2.6.24.
Date: Thu, 5 Jun 2008 22:16:51 +0100
Message-ID: <f058a9c30806051416g11216654m34b6c8e2b72b3395@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

Running ubuntu 8.04 on ibook.
Linux newton 2.6.24-17-powerpc #1 Thu May 1 13:56:51 UTC 2008 ppc GNU/Linux

a fresh hg pull of btrfs0.15, with btrfs on a lvm.

btrfsck is clean.

creation of files and dirs work, but a simple echo "a" > a, or a cp, tar ..etc..
result in segfault/core dump of application and this is what I get from dmesg:


[ 2833.269499] scan one opens /dev/mapper/p0-test
[ 2833.272348] found device 1 on /dev/mapper/p0-test
[ 2833.273081] scan one closes bdev /dev/mapper/p0-test
[ 2833.273430] opening /dev/mapper/p0-test devid 1
[ 2833.273439] lowest bdev /dev/mapper/p0-test
[ 2862.236037] Unable to handle kernel paging request for data at
address 0x00000010
[ 2862.236070] Faulting instruction address: 0xc007bd04
[ 2862.236084] Oops: Kernel access of bad area, sig: 11 [#5]
[ 2862.236090] PowerMac
[ 2862.236093] Modules linked in: btrfs libcrc32c af_packet radeon drm
uinput ipv6 cpufreq_ondemand cpufreq_conservative cpufreq_userspace
cpufreq_powersave cpufreq_stats iptable_filter ip_tables x_tables
snd_powermac sbp2 scsi_mod loop apm_emu apm_emulation snd_aoa_i2sbus
snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
pmac_zilog serial_core snd_timer snd_seq_device snd soundcore
snd_aoa_soundbus airport orinoco hermes evdev uninorth_agp agpgart
ext3 jbd mbcache ide_cd cdrom ide_disk ohci_hcd ohci1394 sungem
sungem_phy ieee1394 usbcore dm_mirror dm_snapshot dm_mod windfarm_core
fuse
[ 2862.236186] NIP: c007bd04 LR: c007bd74 CTR: c007bd58
[ 2862.236196] REGS: e6275d60 TRAP: 0300   Tainted: G      D
(2.6.24-17-powerpc)
[ 2862.236202] MSR: 00009032 <EE,ME,IR,DR>  CR: 24442424  XER: 00000000
[ 2862.236215] DAR: 00000010, DSISR: 40000000
[ 2862.236221] TASK = e5d99980[9650] 'cp' THREAD: e6274000
[ 2862.236226] GPR00: c007bd74 e6275e10 e5d99980 00000008 00000000
e6275e70 00002000 e5d538c0
[ 2862.236239] GPR08: ffffffff 00000000 00002000 c007bd58 ffffffff
10029b34 00000000 bfe8e348
[ 2862.236252] GPR16: 000081a0 00000003 00000000 e5d538c0 00000004
bfe8e54a 00000000 00002000
[ 2862.236265] GPR24: 10028178 bfe8ea7e c7b3b548 e6275f20 1002b000
e5d538c0 00002000 c7b40100
[ 2862.236279] NIP [c007bd04] should_remove_suid+0x10/0x64
[ 2862.236302] LR [c007bd74] remove_suid+0x1c/0x8c
[ 2862.236310] Call Trace:
[ 2862.236314] [e6275e10] [bfe8ea7e] 0xbfe8ea7e (unreliable)
[ 2862.236325] [e6275e20] [c007bd74] remove_suid+0x1c/0x8c
[ 2862.236333] [e6275e30] [e9ab4a84] btrfs_file_write+0x1a0/0x8e4 [btrfs]
[ 2862.236453] [e6275ef0] [c00a81c4] vfs_write+0xd8/0x1c0
[ 2862.236474] [e6275f10] [c00a88f0] sys_write+0x4c/0x90
[ 2862.236484] [e6275f40] [c00140f4] ret_from_syscall+0x0/0x38
[ 2862.236508] --- Exception: c01 at 0xfee7404
[ 2862.236518]     LR = 0x1000cbb0
[ 2862.236521] Instruction dump:
[ 2862.236527] 80830000 80630004 90010008 48045211 80010044 38210040
7c0803a6 4e800020
[ 2862.236540] 9421fff0 7c0802a6 93e1000c 90010014 <81230008> a009006a
700b0408 541f0528
[ 2862.236606] ---[ end trace 1600f28a1862972d ]---


Kind regards!

-- 
Miguel Sousa Filipe
