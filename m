From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: kernel bug
Date: Sat, 24 Sep 2011 21:26:21 +0200
Message-ID: <CABVOS0-ELuCKZ5PGvMuZ=RO+V81LPPKXTwDPVEBGtZ=sWKOWvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Segfault and kernel bug after reflinking several files (20-30 files)
each of size around 1GB through following command:

cp -r --reflink sorce_dir .
Segmentation fault

I'm on Fedora 15, kernel 3.0.4
# uname -a
Linux bruno.localdomain 2.6.40.4-5.fc15.i686.PAE #1 SMP Tue Aug 30 14:43:52 UTC
2011 i686 i686 i386 GNU/Linux

[ 4982.973679] ------------[ cut here ]------------
[ 4982.973691] kernel BUG at fs/btrfs/delayed-inode.c:1693!
[ 4982.973697] invalid opcode: 0000 [#1] SMP
[ 4982.973703] Modules linked in: btrfs zlib_deflate libcrc32c sha256_generic dm
_crypt fuse vboxpci vboxnetadp vboxnetflt vboxdrv 8021q cpufreq_ondemand garp st
p llc powernow_k8 mperf nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_REJE
CT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_fi
lter ip6_tables xt_state nf_conntrack bnep bluetooth w83627ehf hwmon_vid snd_hda
_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc eeepc_wmi asus_wmi
 sparse_keymap rfkill sp5100_tco r8169 mii microcode serio_raw fglrx(P) k10temp
i2c_piix4 i2c_core ipv6 firewire_ohci firewire_core crc_itu_t wmi [last unloaded
: scsi_wait_scan]
[ 4982.973779]
[ 4982.973786] Pid: 10895, comm: cp Tainted: P            2.6.40.4-5.fc15.i686.P
AE #1 System manufacturer System Product Name/E35M1-M
[ 4982.973795] EIP: 0060:[<fa48b15c>] EFLAGS: 00010286 CPU: 0
[ 4982.973847] EIP is at btrfs_delayed_update_inode+0xdf/0xe1 [btrfs]
[ 4982.973853] EAX: ffffffe4 EBX: e3456c98 ECX: 00018000 EDX: 00000000
[ 4982.973858] ESI: eac03c60 EDI: ea7e4800 EBP: e69ebd80 ESP: e69ebd60
[ 4982.973863]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4982.973869] Process cp (pid: 10895, ti=e69ea000 task=e8b01940 task.ti=e69ea00
0)
[ 4982.973873] Stack:
[ 4982.973876]  00018000 00000000 00018000 e3456cc4 e34c901c e34c901c ea7e4800 e
a7e4800
[ 4982.973888]  e69ebda4 fa452f21 00000000 e69ebd94 eac03c60 e69ebda4 e34c901c e
a7e4800
[ 4982.973898]  00000000 e69ebe88 fa4751ff a1c00000 0000002f 2bbe9000 00000000 0
0000000
[ 4982.973908] Call Trace:
[ 4982.973954]  [<fa452f21>] btrfs_update_inode+0x40/0x12c [btrfs]
[ 4982.973997]  [<fa4751ff>] btrfs_ioctl_clone+0xa38/0xb27 [btrfs]
[ 4982.974010]  [<fa47761e>] ? btrfs_ioctl_trans_end+0x52/0x52 [btrfs]
[ 4982.974010]  [<fa477f56>] btrfs_ioctl+0x938/0xbda [btrfs]
[ 4982.974010]  [<c05a8f88>] ? inode_has_perm+0x3f/0x46
[ 4982.974010]  [<c05a9031>] ? file_has_perm+0xa2/0xbb
[ 4982.974010]  [<fa47761e>] ? btrfs_ioctl_trans_end+0x52/0x52 [btrfs]
[ 4982.974010]  [<c05009d7>] do_vfs_ioctl+0x428/0x488
[ 4982.974010]  [<c05aa90b>] ? selinux_file_ioctl+0xac/0xb0
[ 4982.974010]  [<c0500a7f>] sys_ioctl+0x48/0x69
[ 4982.974010]  [<c08028df>] sysenter_do_call+0x12/0x28
[ 4982.974010] Code: 10 01 00 00 8b 80 e8 1f 00 00 83 c0 14 e8 39 e3 ff ff 8b 45
 ec e8 77 0c 37 c6 89 d8 e8 5c ea ff ff 31 c0 83 c4 14 5b 5e 5f 5d c3 <0f> 0b 55
 89 e5 53 3e 8d 74 26 00 e8 8a e4 ff ff 85 c0 89 c3 74
[ 4982.974010] EIP: [<fa48b15c>] btrfs_delayed_update_inode+0xdf/0xe1 [btrfs] SS
:ESP 0068:e69ebd60
[ 4982.974411] ---[ end trace 9cf7abc81c235a01 ]---


Thanks

Roman Kapusta
