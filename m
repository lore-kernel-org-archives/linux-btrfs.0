From: Kjetil Oftedal <oftedal@gmail.com>
Subject: Re: Warning when mounting btrfs partition, kernel unaligned access
Date: Wed, 13 Apr 2011 07:21:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1104130649440.18912@oizys.tordivel.org>
References: <4DA4DA5C.3050703@frankengul.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="16875264-385522397-1302672108=:18912"
Cc: linux-btrfs@vger.kernel.org, sparclinux@vger.kernel.org,
	debian-sparc@lists.debian.org
To: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <seb@frankengul.org>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <4DA4DA5C.3050703@frankengul.org>
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--16875264-385522397-1302672108=:18912
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 13 Apr 2011, S=E9bastien Bernard wrote:

> I played a little with btrfs on debian sparc64 (V240).
> I created a LV from my volumegroup and mounted it.
> At this moment I got a warning from the kernel as follow:
> [  624.857466] device fsid 5defc44f31f449af-b797a325301d119a devid 1 tran=
sid
> 502 /dev/mapper/vgsys-debian64
> [  624.983823] ------------[ cut here ]------------
> [  625.044657] WARNING: at
> /build/buildd-linux-2.6_2.6.38-3-sparc-675DHN/linux-2.6-2.6.38/debian/bui=
ld/source_sparc_none/fs/btrfs/extent_io.c:3787
> write_extent_buffer+0xc8/0x128 [btrfs]()
> [  625.260939] Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl
> auth_rpcgss sunrpc ext2 loop flash ext4 mbcache jbd2 crc16 dm_mod raid1 m=
d_mod
> btrfs lzo_compress zlib_deflate crc32c libcrc32c ide_cd_mod cdrom ata_gen=
eric
> libata ide_pci_generic sd_mod crc_t10dif qla1280 ohci_hcd ehci_hcd tg3
> sym53c8xx scsi_transport_spi scsi_mod usbcore libphy alim15x3 nls_base [l=
ast
> unloaded: scsi_wait_scan]
> [  625.725351] Call Trace:
> [  625.757411]  [00000000103f5cbc] write_extent_buffer+0xc8/0x128 [btrfs]
> [  625.843302]  [00000000103fd7b4] btrfs_read_sys_array+0x3c/0x314 [btrfs=
]
> [  625.930333]  [00000000103c65e0] open_ctree+0xf28/0x1884 [btrfs]
> [  626.008199]  [000000001039d01c] btrfs_mount+0x238/0x43c [btrfs]
> [  626.086068]  [0000000000514db8] vfs_kern_mount+0x98/0x1fc
> [  626.157071]  [0000000000514f5c] do_kern_mount+0x24/0xbc
> [  626.225696]  [000000000052d718] do_mount+0x830/0x898
> [  626.290889]  [000000000054ed68] compat_sys_mount+0x1c8/0x204
> [  626.365229]  [0000000000406114] linux_sparc_syscall32+0x34/0x40
> [  626.442999] ---[ end trace 1a1c133a476942b9 ]---
>=20
> Then, after writing on the disk, I got a lot of warning:
> [  822.515875] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  825.897439] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  826.030575] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  826.565416] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  826.692390] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  841.631005] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  841.736359] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  846.774635] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  846.880038] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  847.018567] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  847.157098] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  847.262536] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  851.884641] log_unaligned: 127 callbacks suppressed
> [  851.948889] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  852.054307] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  852.227997] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
> [  852.333491] Kernel unaligned access at TPC[103c2204]
> btrfs_csum_final+0x38/0x3c [btrfs]
>=20
> I peeked a look at the btrf_csum_final and here's the function :
> void btrfs_csum_final(u32 crc, char *result)
> {
>         *(__le32 *)result =3D ~cpu_to_le32(crc);
> }
>=20
> I know that this problem is certainly an alignment problem and that the s=
parc
> is prone to that kind of problem.
> If someone could explain what's wrong with it?
>=20
>=20
> S. Bernard
> --

On SPARC memory alignment is required. I.e. bytes can be written to any=20
address. 32 bit words on the other hand must be written to an address on=20
a 4 byte boundary, 64 bit words on 8 byte boundaries and so on.

The problem with the csum function is that it casts the result byte pointer=
=20
to a 32 bits pointer. This pointer might not point to an aligned memory=20
position for 32 bits operations.

Either the function must handle unaligned result pointers internally, or=20
you must guarantee that the result pointer is always aligned. Which would=
=20
increase performance slightly on most architectures, as those architectures=
=20
that allow unaligned memory accesses often do it at a cost in memory access=
=20
time.

Kjetil Oftedal

--16875264-385522397-1302672108=:18912--
