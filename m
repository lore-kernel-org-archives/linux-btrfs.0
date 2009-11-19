From: pragnesh radadia <pragnesh.radadia@gmail.com>
Subject: kernel oops when trying to compile kernel on btrfs part
Date: Thu, 19 Nov 2009 18:46:58 +0530
Message-ID: <3fa5c0870911190516q227a65cau20716cc3b425a5f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I got following kernel oops when trying to compile kernel on btrfs
partation on my laptop.

-pragnesh

Nov 19 00:38:53 linux-xfxc kernel: [22504.896045] ------------[ cut
here ]------------
Nov 19 00:38:53 linux-xfxc kernel: [22504.896052] kernel BUG at
/usr/src/packages/BUILD/kernel-desktop-2.6.31.5/linux-2.6.31/fs/btrfs/inode.c:735!
Nov 19 00:38:53 linux-xfxc kernel: [22504.896065] invalid opcode: 0000
[#1] PREEMPT SMP
Nov 19 00:38:53 linux-xfxc kernel: [22504.896074] last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0/charge_full
Nov 19 00:38:53 linux-xfxc kernel: [22504.896085] Modules linked in:
nls_utf8 michael_mic arc4 ecb lib80211_crypt_tkip af_packet
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ed
d i915 drm i2c_algo_bit cpufreq_conservative cpufreq_userspace
cpufreq_powersave acpi_cpufreq speedstep_lib fuse btrfs zlib_deflate
cryptomgr aead pcompress crypto_blkcipher crc32c
 libcrc32c crypto_hash crypto_algapi loop dm_mod b44 snd_intel8x0m ssb
dell_laptop snd_intel8x0 snd_ac97_codec ac97_bus ohci1394 sdhci_pci
sdhci pcmcia yenta_socket ipw2200 rfkill
snd_pcm sr_mod snd_timer iTCO_wdt dcdbas joydev mmc_core
rsrc_nonstatic pcmcia_core ieee1394 libipw pcspkr iTCO_vendor_support
cdrom sg snd snd_page_alloc video ac battery button i
ntel_agp fan processor ide_pci_generic ide_core ata_generic thermal
thermal_sys [last unloaded: preloadtrace]
Nov 19 00:38:53 linux-xfxc kernel: [22504.896212]
Nov 19 00:38:53 linux-xfxc kernel: [22504.896219] Pid: 23, comm:
pdflush Not tainted (2.6.31.5-0.1-desktop #1) Inspiron 6000
Nov 19 00:38:53 linux-xfxc kernel: [22504.896231] EIP:
0060:[<f826e6dd>] EFLAGS: 00010286 CPU: 0
Nov 19 00:38:53 linux-xfxc kernel: [22504.896263] EIP is at
cow_file_range+0x54d/0x570 [btrfs]
Nov 19 00:38:53 linux-xfxc kernel: [22504.896270] EAX: ffffffe4 EBX:
00001000 ECX: c094c6e8 EDX: 00000000
Nov 19 00:38:53 linux-xfxc kernel: [22504.896277] ESI: 00000000 EDI:
ffffffff EBP: f63a5c70 ESP: f63a5bd4
Nov 19 00:38:53 linux-xfxc kernel: [22504.896285]  DS: 007b ES: 007b
FS: 00d8 GS: 00e0 SS: 0068
Nov 19 00:38:53 linux-xfxc kernel: [22504.896293] Process pdflush
(pid: 23, ti=f63a4000 task=f63a2f80 task.ti=f63a4000)
Nov 19 00:38:53 linux-xfxc kernel: [22504.896302] Stack:
Nov 19 00:38:53 linux-xfxc kernel: [22504.896306]  00037000 00000000
00001000 00000000 00000000 00000000 d2bc6000 00000000
Nov 19 00:38:53 linux-xfxc kernel: [22504.896320] <0> ffffffff
ffffffff f63a5c4f 00000001 00000000 cf5c3318 00000001 f6d48ca0
Nov 19 00:38:53 linux-xfxc kernel: [22504.896335] <0> cf5c3314
f3967364 00001000 00000000 f4858000 00037000 00000000 cf5c3310
Nov 19 00:38:53 linux-xfxc kernel: [22504.896351] Call Trace:
Nov 19 00:38:53 linux-xfxc kernel: [22504.896417]  [<f8272c75>]
run_delalloc_range+0xd5/0x120 [btrfs]
Nov 19 00:38:53 linux-xfxc kernel: [22504.896472]  [<f828be27>]
__extent_writepage+0x417/0xad0 [btrfs]
Nov 19 00:38:53 linux-xfxc kernel: [22504.896548]  [<f828c843>]
T.1032+0x163/0x2e0 [btrfs]
Nov 19 00:38:53 linux-xfxc kernel: [22504.896622]  [<f828caf1>]
extent_writepages+0x51/0x80 [btrfs]
Nov 19 00:38:53 linux-xfxc kernel: [22504.896697]  [<f826c48c>]
btrfs_writepages+0x2c/0x50 [btrfs]
Nov 19 00:38:53 linux-xfxc kernel: [22504.896735]  [<c02dc8ae>]
do_writepages+0x2e/0x60
Nov 19 00:38:53 linux-xfxc kernel: [22504.896750]  [<c0337041>]
writeback_single_inode+0x171/0x400
Nov 19 00:38:53 linux-xfxc kernel: [22504.896762]  [<c0337685>]
generic_sync_sb_inodes+0x155/0x4a0
Nov 19 00:38:53 linux-xfxc kernel: [22504.896772]  [<c0337a15>]
sync_sb_inodes+0x45/0x60
Nov 19 00:38:53 linux-xfxc kernel: [22504.896781]  [<c0337b24>]
writeback_inodes+0x54/0xf0
Nov 19 00:38:53 linux-xfxc kernel: [22504.896791]  [<c02dbf22>]
background_writeout+0xa2/0xe0
Nov 19 00:38:53 linux-xfxc kernel: [22504.896801]  [<c02dd719>]
__pdflush+0xf9/0x200
Nov 19 00:38:53 linux-xfxc kernel: [22504.896810]  [<c02dd863>]
pdflush+0x43/0x60
Nov 19 00:38:53 linux-xfxc kernel: [22504.896821]  [<c026e5c4>]
kthread+0x84/0x90
Nov 19 00:38:53 linux-xfxc kernel: [22504.896833]  [<c0204d8b>]
kernel_thread_helper+0x7/0x1c
Nov 19 00:38:53 linux-xfxc kernel: [22504.896842] Code: 00 e8 68 98 01
00 8b 45 d4 8b 55 d8 8b 5d b8 05 00 10 00 00 83 d2 00 0f ac d0 0c 01
03 8b 45 ac c7 00 01 00 00 00 e9 1f fe ff ff <0f> 0b eb fe 0f 0b eb fe
0f 0b eb fe e8 12 2f fe c7 f3 90 8b 4d
Nov 19 00:38:53 linux-xfxc kernel: [22504.896906] EIP: [<f826e6dd>]
cow_file_range+0x54d/0x570 [btrfs] SS:ESP 0068:f63a5bd4
Nov 19 00:38:53 linux-xfxc kernel: [22504.897267] ---[ end trace
79e484a9da539415 ]---
