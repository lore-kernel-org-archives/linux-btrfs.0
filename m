From: Jan Engelhardt <jengelh@medozas.de>
Subject: Shrinking oops
Date: Wed, 18 Nov 2009 22:20:29 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911182213360.29660@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


the following testcase, if I remember the afternoon correctly, caused an 
oops on 2.6.31.6:

>some.vol; # aka truncate -s 0
truncate -s $[10*1048576*1024] some.vol;
mkfs.btrfs some.vol;
mount some.vol /some.where -oloop;
truncate -s $[30*1048576*1024] some.vol;
btrfsctl -r 30G /some.where;
btrfsctl -r 10G /some.where;
btrfsctl -r 20G /some.where;
btrfsctl -r 30G /some.where;
btrfsctl -r 1G /some.where; # boom

Note this is an empty volume.

[ 3627.519720] device fsid a742885255bd6e00-2fd1e3197d00e798 devid 1 transid 11
/dev/loop0
[ 3651.513332] new size for /dev/loop0 is 32212254720
[ 3655.055563] new size for /dev/loop0 is 10737418240
[ 3659.072409] new size for /dev/loop0 is 21474836480
[ 3660.791631] new size for /dev/loop0 is 32212254720
[ 3664.624302] new size for /dev/loop0 is 1073741824
[ 3664.624383] btrfs allocation failed flags 36, wanted 4096
[ 3664.624411] space_info has 1073717248 free, is full
[ 3664.624415] space_info total=1073741824, pinned=0, delalloc=0, may_use=0,
used=24576
[ 3664.624420] block group 29360128 has 1073741824 bytes, 24576 used 0 pinned 0
reserved
[ 3664.624425] entry offset 29360128, bytes 40960, bitmap yes
[ 3664.624436] entry offset 58785792, bytes 1044316160, bitmap no
[ 3664.624447] block group has cluster?: yes
[ 3664.624450] 2 blocks of free space at or bigger than bytes is
[ 3664.624576] ------------[ cut here ]------------
[ 3664.624589] kernel BUG at
/usr/src/packages/BUILD/kernel-rt-2.6.31.6/linux-2.6.31/fs/btrfs/relocation.c:3408!
[ 3664.624608] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 3664.624622] last sysfs file: /sys/devices/virtual/block/loop0/range
[ 3664.624635] Modules linked in: btrfs zlib_deflate crc32c libcrc32c af_packet
nfsd lockd nfs_acl auth_rpcgss sunrpc tun sit tunnel4 snd_cs46xx snd_pcm_oss
snd_mixer_oss vmnet vmblock vmci vmmon xt_limit xt_DELUDE xt_TARPIT ipt_REJECT
xt_CHAOS compat_xtables xt_condition xt_multiport iptable_filter xt_MASQUERADE
iptable_nat nf_nat xt_quota2 nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT
xt_mac xt_tcpudp xt_dscp nf_conntrack_ipv6 xt_connmark xt_conntrack xt_CONNMARK
nf_conntrack xt_mark iptable_mangle ip6table_filter ip_tables ip6_tables
x_tables fuse sha256_generic cbc dm_crypt nls_iso8859_1 nls_cp437 vfat fat loop
tcp_veno aes_i586 aes_generic dm_mod mousedev gameport snd_rawmidi
snd_seq_device snd_ac97_codec psmouse processor sr_mod ppdev pcspkr serio_raw
thermal_sys parport_pc nvidia(P) sis900 cdrom ac97_bus 8139too evdev parport
sis_agp mii snd_pcm pci_hotplug i2c_core agpgart snd_timer sg snd soundcore
hwmon snd_page_alloc usbhid hid ohci_hcd usbcore nls_base xfs exportfs pata_sis
[last unloaded: snd_cs46xx]
[ 3664.624887] 
[ 3664.624897] Pid: 7534, comm: btrfsctl Tainted: P
(2.6.31.6-jen92-rt #1) L7S7A2
[ 3664.624914] EIP: 0060:[<f0f83d69>] EFLAGS: 00210286 CPU: 0
[ 3664.624987] EIP is at create_reloc_inode+0x1f9/0x210 [btrfs]
[ 3664.624999] EAX: ffffffe4 EBX: e7750000 ECX: d7bf10d0 EDX: b180ec40
[ 3664.625012] ESI: d743c424 EDI: e6cb2b80 EBP: ce86bd84 ESP: ce86bd10
[ 3664.625016]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 preempt:00000000
[ 3664.625016] Process btrfsctl (pid: 7534, ti=ce86a000 task=d7bf10d0
task.ti=ce86a000)
[ 3664.625016] Stack:
[ 3664.625016]  00000101 00000000 40000000 00000000 00000000 ce84a000 00000000
dd20a000
[ 3664.625016] <0> e7698990 ce86bd3c f0f4ac5a ce86bd78 f0f3b0b7 40200000
00000000 00000024
[ 3664.625016] <0> 00000000 00000001 e7698960 00000000 40000000 00000000
ce86bd78 f0f38238
[ 3664.625016] Call Trace:
[ 3664.625016]  [<f0f89272>] btrfs_relocate_block_group+0xd2/0x3b4 [btrfs]
[ 3664.625016]  [<f0f708f2>] btrfs_relocate_chunk+0x42/0x310 [btrfs]
[ 3664.625016]  [<f0f7106f>] btrfs_shrink_device+0x2ff/0x330 [btrfs]
[ 3664.625016]  [<f0f75e40>] btrfs_ioctl_resize+0x2b0/0x320 [btrfs]
[ 3664.625016]  [<f0f76c15>] btrfs_ioctl+0x135/0x3c0 [btrfs]
[ 3664.625016]  [<b02eca4c>] vfs_ioctl+0x1c/0x90
[ 3664.625016]  [<b02eccf1>] do_vfs_ioctl+0x71/0x2f0
[ 3664.625016]  [<b02ecfcf>] sys_ioctl+0x5f/0x80
[ 3664.625016]  [<b0203b0c>] sysenter_do_call+0x12/0x28
[ 3664.625016]  [<a7876424>] 0xa7876424
[ 3664.625016] Code: c3 90 89 da 89 f0 8b 7e 0c 89 4d d0 e8 01 6f fc ff 89 d8
89 fa e8 a8 25 fc ff 8b 4d d0 eb d6 0f 0b eb fe 0f 0b eb fe 89 c7 eb cc <0f> 0b
eb fe 0f 0b eb fe eb 0d 90 90 90 90 90 90 90 90 90 90 90 
[ 3664.625016] EIP: [<f0f83d69>] create_reloc_inode+0x1f9/0x210 [btrfs] SS:ESP
0068:ce86bd10
[ 3664.628049] ---[ end trace 12c13c3446a3d8ab ]---
