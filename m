From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: kerenl bug after btrfs resize (reduce size)
Date: Mon, 19 Sep 2011 14:24:55 +0200
Message-ID: <CABVOS0_vA_BrA8+3mrgKUWRhmhMBA9bJUGwJvto16k3xM92+DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After running 'btrfs fi resize' I got following error, fortunately, it
looks that filesystem is ok.
I was changing filesystem size from 256 GB to 192 GB (reducing by
64GB), free space was 110GB.

My system is Fedora 14. I'm considering upgrade to Fedora 15, is this
already fixed?

Sep 19 12:58:54 cyro kernel: [13235.702666] new size for
/dev/mapper/VolGroup-btrfs is 206158430208
Sep 19 12:58:54 cyro kernel: [13235.760728] btrfs: relocating block
group 393236971520 flags 1
Sep 19 12:59:31 cyro kernel: [13273.243895] btrfs: found 17209 extents
Sep 19 13:01:05 cyro kernel: [13366.953112] btrfs: unlinked 9 orphans
Sep 19 13:01:50 cyro kernel: [13412.117164] ------------[ cut here ]------------
Sep 19 13:01:50 cyro kernel: [13412.117173] kernel BUG at
fs/btrfs/relocation.c:837!
Sep 19 13:01:50 cyro kernel: [13412.117179] invalid opcode: 0000 [#1] SMP
Sep 19 13:01:50 cyro kernel: [13412.117186] last sysfs file:
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Sep 19 13:01:50 cyro kernel: [13412.117190] Modules linked in: tcp_lp
fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp
llc rfcomm sco bnep l2cap vboxnetadp vboxnetflt vboxdrv
cpufreq_ondemand sunrpc ppdev parport_pc parport acpi_cpufreq mperf
ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 uinput
snd_hda_codec_analog snd_hda_intel arc4 btusb ecb bluetooth iwl3945
snd_hda_codec snd_hwdep snd_seq snd_seq_device iwlcore iTCO_wdt b44
snd_pcm hp_wmi iTCO_vendor_support ssb mac80211 mmc_core snd_timer
cfg80211 wmi mii snd soundcore rfkill microcode snd_page_alloc joydev
serio_raw btrfs zlib_deflate libcrc32c firewire_ohci firewire_core
crc_itu_t yenta_socket i915 drm_kms_helper drm i2c_algo_bit i2c_core
video output [last unloaded: cpufreq_ondemand]
Sep 19 13:01:50 cyro kernel: [13412.117310]
Sep 19 13:01:50 cyro kernel: [13412.117317] Pid: 11791, comm: btrfs
Not tainted 2.6.35.14-96.fc14.i686 #1 30A2/HP Compaq nx7400
(RU430EA#AKR)
Sep 19 13:01:50 cyro kernel: [13412.117324] EIP: 0060:[<f88584af>]
EFLAGS: 00210246 CPU: 1
Sep 19 13:01:50 cyro kernel: [13412.117367] EIP is at
build_backref_tree+0x3de/0xac4 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117373] EAX: cc405420 EBX:
f58367e0 ECX: 0000004b EDX: 4e75f000
Sep 19 13:01:50 cyro kernel: [13412.117379] ESI: cc405420 EDI:
ed5b5180 EBP: f521bc94 ESP: f521bc04
Sep 19 13:01:50 cyro kernel: [13412.117384]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
Sep 19 13:01:50 cyro kernel: [13412.117391] Process btrfs (pid: 11791,
ti=f521a000 task=f5268ca0 task.ti=f521a000)
Sep 19 13:01:50 cyro kernel: [13412.117395] Stack:
Sep 19 13:01:50 cyro kernel: [13412.117398]  00000000 0004064d
c09c9cb0 c1a60ce0 f521bc78 f521bc2c c04cf823 cf436f54
Sep 19 13:01:50 cyro kernel: [13412.117410] <0> f1afe010 f583680c
f58364e0 f1afe098 f1afe094 cc1f3e60 f58364e0 f5e32690
Sep 19 13:01:50 cyro kernel: [13412.117423] <0> 00000000 ed5b5560
f5e32c40 f1afe000 d1314000 f5836ba0 00afe010 4b3ed080
Sep 19 13:01:50 cyro kernel: [13412.117438] Call Trace:
Sep 19 13:01:50 cyro kernel: [13412.117449]  [<c04cf823>] ?
add_partial+0x2b/0x3b
Sep 19 13:01:50 cyro kernel: [13412.117498]  [<f8858cc3>] ?
relocate_tree_blocks+0x12e/0x3d8 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117545]  [<f88599cb>] ?
relocate_block_group+0x1c5/0x441 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117590]  [<f8827289>] ?
btrfs_clean_old_snapshots+0x66/0xbd [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117634]  [<f8859d27>] ?
btrfs_relocate_block_group+0xe0/0x208 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117679]  [<f88442a9>] ?
btrfs_relocate_chunk.clone.34+0x54/0x42d [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117690]  [<c0427a1d>] ?
kmap_atomic+0x13/0x15
Sep 19 13:01:50 cyro kernel: [13412.117735]  [<f8842647>] ?
map_private_extent_buffer+0x94/0xb6 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117778]  [<f88426b8>] ?
map_extent_buffer+0x4f/0x7f [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117787]  [<c0427918>] ?
kunmap_atomic+0x5f/0x85
Sep 19 13:01:50 cyro kernel: [13412.117830]  [<f88426f9>] ?
unmap_extent_buffer+0x11/0x13 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117876]  [<f88382f0>] ?
btrfs_dev_extent_chunk_offset+0xa2/0xae [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117920]  [<f8845edc>] ?
btrfs_shrink_device+0x1dc/0x2f3 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.117964]  [<f88498b3>] ?
btrfs_ioctl_resize+0x274/0x2a9 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.118008]  [<f884bac6>] ?
btrfs_ioctl+0x525/0x7d3 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.118017]  [<c062b02f>] ? pty_write+0x41/0x4f
Sep 19 13:01:50 cyro kernel: [13412.118025]  [<c045ea59>] ?
__raw_local_irq_save+0x19/0x1e
Sep 19 13:01:50 cyro kernel: [13412.118035]  [<c0584118>] ?
file_has_perm+0x8d/0xa7
Sep 19 13:01:50 cyro kernel: [13412.118043]  [<c04e6810>] ? vfs_ioctl+0x33/0x91
Sep 19 13:01:50 cyro kernel: [13412.118047]  [<f884b5a1>] ?
btrfs_ioctl+0x0/0x7d3 [btrfs]
Sep 19 13:01:50 cyro kernel: [13412.118047]  [<c04e7210>] ?
do_vfs_ioctl+0x462/0x48d
Sep 19 13:01:50 cyro kernel: [13412.118047]  [<c058441f>] ?
selinux_file_ioctl+0x43/0x46
Sep 19 13:01:50 cyro kernel: [13412.118047]  [<c04e7281>] ? sys_ioctl+0x46/0x69
Sep 19 13:01:50 cyro kernel: [13412.118047]  [<c07a92dc>] ? syscall_call+0x7/0xb
Sep 19 13:01:50 cyro kernel: [13412.118047] Code: 01 00 00 8b 45 d4 8b
55 d8 89 46 0c 89 56 10 8a 43 44 8d 55 e4 40 88 46 44 8d 47 08 e8 41
c8 ff ff eb 13 f6 40 45 10 89 c6 75 02 <0f> 0b 8d 47 08 89 47 08 89 47
0c 8b 55 94 89 f8 e8 22 c8 ff ff
Sep 19 13:01:50 cyro kernel: [13412.118047] EIP: [<f88584af>]
build_backref_tree+0x3de/0xac4 [btrfs] SS:ESP 0068:f521bc04
Sep 19 13:01:50 cyro kernel: [13412.118281] ---[ end trace 209501ab2f807f91 ]---


Thanks
Roman Kapusta
