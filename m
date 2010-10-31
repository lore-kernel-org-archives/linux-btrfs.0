From: "Helmut Hullen" <Hullen@t-online.de>
Subject: btrfs-convert fails
Date: 31 Oct 2010 16:55:00 +0100
Message-ID: <BZurHFYT1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

I've tried to convert a 12 GByte ext2 partition (nearly full, 280 MByte  
free) with btrfs-convert.

After about 15 minutes (700-MHz-CPU) the system tells

  ...
  creating ext2fs image file
  cleaning up system chunk
  btrfs-convert: extent-tree.c:2529: btrfs_reserve_extent: Assertion
     `!(ret)' failed
  Abgebrochen

"syslogd" tells

Oct 31 17:43:16 ElNath kernel: ------------[ cut here ]------------
Oct 31 17:43:17 ElNath kernel: kernel BUG at fs/btrfs/volumes.c:2831!
Oct 31 17:43:17 ElNath kernel: invalid opcode: 0000 [#1]
Oct 31 17:43:17 ElNath kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:04.0/0000:08:02.0/0000:09:00.0/class
Oct 31 17:43:17 ElNath kernel: Modules linked in: sg nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat xt_DSCP xt_multiport xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter iptable_mangle ip_tables xt_iprange x_tables nfsd exportfs ipv6 8139too 8139cp r8169 savagefb fb_ddc vgastate i2c_piix4 piix e100 mii intel_agp agpgart cmd64x video thermal_sys output ac battery yenta_socket pcmcia_rsrc pcmcia pcmcia_core thinkpad_acpi hwmon led_class nvram fuse
Oct 31 17:43:17 ElNath kernel:
Oct 31 17:43:17 ElNath kernel: Pid: 6396, comm: mount Not tainted 2.6.35.8-h1 #1 26478EG/26478EG
Oct 31 17:43:17 ElNath kernel: EIP: 0060:[<c1231d1a>] EFLAGS: 00010206 CPU: 0
Oct 31 17:43:17 ElNath kernel: EIP is at btrfs_rmap_block+0x3ba/0x3f0
Oct 31 17:43:17 ElNath kernel: EAX: 00000000 EBX: 3df00000 ECX: 00000000 EDX: 00000000
Oct 31 17:43:17 ElNath kernel: ESI: 3df00000 EDI: d7bf76c0 EBP: d1befca8 ESP: d1befc24
Oct 31 17:43:17 ElNath kernel:  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Oct 31 17:43:17 ElNath kernel: Process mount (pid: 6396, ti=d1bee000 task=c23767a0 task.ti=d1bee000)
Oct 31 17:43:17 ElNath kernel: Stack:
Oct 31 17:43:17 ElNath kernel:  00000001 00000000 c10252f8 00000000 00000004 000003fa 00000000 d1befc48
Oct 31 17:43:17 ElNath kernel: <0> c1025383 d1befc80 c1228f3d 00001000 c1b90100 d75bd7e0 00000003 d1befc78
Oct 31 17:43:17 ElNath kernel: <0> 00001000 00000000 00000000 00000000 00000000 00000004 d75bdca8 d1befcb0
Oct 31 17:43:17 ElNath kernel: Call Trace:
Oct 31 17:43:17 ElNath kernel:  [<c10252f8>] ? kmap_atomic_prot+0x48/0xc0
Oct 31 17:43:17 ElNath kernel:  [<c1025383>] ? kmap_atomic+0x13/0x20
Oct 31 17:43:17 ElNath kernel:  [<c1228f3d>] ? map_private_extent_buffer+0x8d/0x120
Oct 31 17:43:17 ElNath kernel:  [<c1229091>] ? map_extent_buffer+0xc1/0xd0
Oct 31 17:43:17 ElNath kernel:  [<c11f13ac>] ? exclude_super_stripes+0xac/0x140
Oct 31 17:43:17 ElNath kernel:  [<c11fa78a>] ? btrfs_read_block_groups+0x4aa/0x700
Oct 31 17:43:17 ElNath kernel:  [<c1205ae5>] ? open_ctree+0xfe5/0x1430
Oct 31 17:43:17 ElNath kernel:  [<c12a0577>] ? strlcpy+0x37/0x60
Oct 31 17:43:17 ElNath kernel:  [<c11e728a>] ? btrfs_get_sb+0x5ca/0x790
Oct 31 17:43:17 ElNath kernel:  [<c10c70e1>] ? dput+0x91/0x120
Oct 31 17:43:17 ElNath kernel:  [<c10bde6e>] ? path_to_nameidata+0x1e/0x50
Oct 31 17:43:17 ElNath kernel:  [<c10cc23d>] ? alloc_vfsmnt+0x6d/0x110
Oct 31 17:43:17 ElNath kernel:  [<c109a093>] ? kstrdup+0x43/0x60
Oct 31 17:43:17 ElNath kernel:  [<c10b7942>] ? vfs_kern_mount+0x72/0x1c0
Oct 31 17:43:17 ElNath kernel:  [<c10ca745>] ? get_fs_type+0x35/0xc0
Oct 31 17:43:17 ElNath kernel:  [<c10b7aee>] ? do_kern_mount+0x3e/0xe0
Oct 31 17:43:17 ElNath kernel:  [<c10cd2a8>] ? do_mount+0x488/0x6d0
Oct 31 17:43:17 ElNath kernel:  [<c1099e72>] ? strndup_user+0x62/0xa0
Oct 31 17:43:17 ElNath kernel:  [<c10cd57c>] ? sys_mount+0x8c/0xb0
Oct 31 17:43:17 ElNath kernel:  [<c17495cc>] ? syscall_call+0x7/0xb
Oct 31 17:43:17 ElNath kernel: Code: 44 8b 55 dc 89 34 da 89 7c da 04 8b 4d d8 83 c3 01 89 5d ec 8b 49 18 89 4d bc e9 70 fd ff ff 89 d0 31 d2 f7 f7 89 d1 89 c6 eb 80 <0f> 0b eb fe 66 90 ba 2c 0b 00 00 b8 a6 a4 87 c1 e8 21 e5 df ff
Oct 31 17:43:17 ElNath kernel: EIP: [<c1231d1a>] btrfs_rmap_block+0x3ba/0x3f0 SS:ESP 0068:d1befc24
Oct 31 17:43:17 ElNath kernel: ---[ end trace f68618b8246ff4aa ]---

What goes wrong?
How much free place needs "btrfs-convert"?

Viele Gruesse!
Helmut
