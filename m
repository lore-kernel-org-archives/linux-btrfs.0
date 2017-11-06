Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv1.gsx.de ([82.165.143.151]:48386 "EHLO srv1.gsx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbdKFJfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 04:35:44 -0500
Received: from srv1.gsx.de (localhost.localdomain [127.0.0.1])
        by srv1.gsx.de (Postfix) with ESMTP id 92F2720194
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 10:35:42 +0100 (CET)
From: "Benedikt Schindler" <benedikt.schindler@owayo.com>
To: <linux-btrfs@vger.kernel.org>
References: 
In-Reply-To: 
Subject: unable to handle kernel NULL pointer dereference
Date: Mon, 6 Nov 2017 10:37:12 +0100
Message-ID: <001f01d356e2$d2b91960$782b4c20$@owayo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_NextPart_000_0020_01D356EB.347D8160"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0020_01D356EB.347D8160
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

i updated our server from kernel 4.7.4 to 4.13.11 .
We have two connected btrfs devcies:
a) a connected hardware raid5 in the machine (/dev/sdb1)=20
b) a IBM Storewize v3700 connected via iSCSI
(/dev/mapper/36005076300808b95c800000000000003-part1)

After restarting the server, the samba services run instable. And in =
dmesg
Oops messages showed up. (See attachment)
So I downgraded to 4.7.4 again, and the system is running stable again.=20

If you can tell me what you need for a good bug report please tell me . =
I
also could give you a better / complete dmesg output.=20
But I used the wrong parameters and the dmesg log was cleared.=20

The server is under full use on weekdays. So i could only do tests and =
new
dmesg etc. on weekends. =A0

Please let me know if some one has a hint what could be the problem, or =
what
you need for a full bug report.=20

Best regards=20
Benedikt



Server data:

btrfs-progs v4.5.3+20160729

Label: 'Data'=A0 uuid: 528c479a-7209-4f64-b862-482475d03a17
=A0=A0=A0=A0=A0=A0=A0 Total devices 1 FS bytes used 2.07TiB
=A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 1 size 10.00TiB used 9.56TiB path =
/dev/sdb1

Label: 'AuwiOrdner'=A0 uuid: 163cceda-5765-483c-9a48-c183acedac5d
=A0=A0=A0=A0=A0=A0=A0 Total devices 1 FS bytes used 10.26TiB
=A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 1 size 14.00TiB used 10.37TiB path
/dev/mapper/36005076300808b95c800000000000003-part1

/dev/sdb1:
Data, single: total=3D9.35TiB, used=3D2.06TiB
System, DUP: total=3D8.00MiB, used=3D1.14MiB
System, single: total=3D4.00MiB, used=3D0.00B
Metadata, DUP: total=3D107.88GiB, used=3D7.51GiB
Metadata, single: total=3D8.00MiB, used=3D0.00B
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

/dev/mapper/36005076300808b95c800000000000003-part1:
Data, single: total=3D10.23TiB, used=3D10.22TiB
System, DUP: total=3D8.00MiB, used=3D1.11MiB
System, single: total=3D4.00MiB, used=3D0.00B
Metadata, DUP: total=3D75.00GiB, used=3D42.57GiB
Metadata, single: total=3D8.00MiB, used=3D0.00B
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B






------=_NextPart_000_0020_01D356EB.347D8160
Content-Type: text/plain;
	name="Kernel Oops BTRFS.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Kernel Oops BTRFS.txt"

BUG: unable to handle kernel NULL pointer dereference at =
0000000000000124
IP: btrfs_root_node+0x7/0x50
PGD 0
P4D 0

Oops: 0000 [#81] SMP
Modules linked in: dm_service_time iscsi_tcp libiscsi_tcp libiscsi =
scsi_transpor                                                            =
                            t_iscsi af_packet 8021q garp stp llc bonding =
iscsi_ibft iscsi_boot_sysfs coretem                                      =
                                                  p crc32c_intel =
ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd crypt        =
                                                                         =
       d iTCO_wdt iTCO_vendor_support glue_helper lpc_ich e1000e =
mfd_core ptp osst pps_                                                   =
                                     core i2c_i801 ioatdma i7core_edac =
ipmi_si dca ipmi_devintf button acpi_cpufreq i                           =
                                                             =
pmi_msghandler serio_raw pm80xx libsas dm_multipath dm_mod dax =
scsi_dh_rdac scsi                                                        =
                                _dh_emc scsi_dh_alua autofs4
CPU: 2 PID: 24528 Comm: smbd Tainted: G      D         4.13.11-gsx #1
Hardware name: Lenovo 10461AG/Tyan Tank GT20-B7002LNV, BIOS 'V2.7  =
04.07.2011 '                                                             =
                            04/07/2011
task: ffff88062433e180 task.stack: ffffc9000a1b4000
RIP: 0010:btrfs_root_node+0x7/0x50
RSP: 0018:ffffc9000a1b7830 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880c24d6b800 RCX: ffff8804e58f1bd0
RDX: 0000000000000100 RSI: ffff880c24d6b800 RDI: ffff880c24d6b800
RBP: ffff880c24d6b800 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880000000000
R13: ffff880c24d6b800 R14: 6db6db6db6db6db7 R15: 0000160000000000
FS:  00007f52d6362840(0000) GS:ffff88063fc80000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000124 CR3: 000000047e7d3000 CR4: 00000000000006e0
Call Trace:
 ? btrfs_read_lock_root_node+0x1f/0x40
 ? btrfs_search_slot+0x56b/0xa10
 ? submit_extent_page.isra.53+0x13f/0x210
 ? btrfs_lookup_ordered_extent+0x4d/0xb0
 ? btrfs_lookup_csum+0x3d/0x130
 ? __btrfs_lookup_bio_sums+0x2f3/0x6a0
 ? btrfs_submit_bio_hook+0xb3/0x180
 ? submit_one_bio+0x56/0x80
 ? extent_readpages+0x122/0x1c0
 ? btrfs_endio_direct_read+0xe0/0xe0
 ? inet6_csk_route_socket+0x100/0x1c0
 ? __alloc_pages_nodemask+0xd0/0x180
 ? __do_page_cache_readahead+0x169/0x220
 ? ondemand_readahead+0x165/0x290
 ? pagecache_get_page+0x21/0x220
 ? generic_file_read_iter+0x70a/0x980
 ? walk_component+0x33/0x230
 ? generic_file_splice_read+0xaa/0x120
 ? splice_direct_to_actor+0xd5/0x1d0
 ? generic_pipe_buf_nosteal+0x10/0x10
 ? do_splice_direct+0x74/0xa0
 ? do_sendfile+0x195/0x370
 ? SyS_sendfile64+0x43/0x90
 ? do_syscall_64+0x56/0x130
 ? entry_SYSCALL64_slow_path+0x25/0x25
Code: 00 00 00 00 48 85 ff 53 48 89 fb 74 15 e8 62 ff ff ff 48 89 de 48 =
8b 3d 58                                                                 =
                        82 c3 00 5b e9 02 31 f2 ff 5b c3 53 48 89 fb 48 =
8b 13 <8b> 42 24 85 c0 74 18 8d                                          =
                                               48 01 48 8d 72 24 f0 0f =
b1 4a 24 0f 94
RIP: btrfs_root_node+0x7/0x50 RSP: ffffc9000a1b7830
CR2: 0000000000000124
---[ end trace 4ada6453733af411 ]---
BUG: unable to handle kernel NULL pointer dereference at =
0000000000000124
IP: btrfs_root_node+0x7/0x50
PGD 0
P4D 0

Oops: 0000 [#82] SMP
Modules linked in: dm_service_time iscsi_tcp libiscsi_tcp libiscsi =
scsi_transpor                                                            =
                            t_iscsi af_packet 8021q garp stp llc bonding =
iscsi_ibft iscsi_boot_sysfs coretem                                      =
                                                  p crc32c_intel =
ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd crypt        =
                                                                         =
       d iTCO_wdt iTCO_vendor_support glue_helper lpc_ich e1000e =
mfd_core ptp osst pps_                                                   =
                                     core i2c_i801 ioatdma i7core_edac =
ipmi_si dca ipmi_devintf button acpi_cpufreq i                           =
                                                             =
pmi_msghandler serio_raw pm80xx libsas dm_multipath dm_mod dax =
scsi_dh_rdac scsi                                                        =
                                _dh_emc scsi_dh_alua autofs4
CPU: 2 PID: 24533 Comm: smbd Tainted: G      D         4.13.11-gsx #1
Hardware name: Lenovo 10461AG/Tyan Tank GT20-B7002LNV, BIOS 'V2.7  =
04.07.2011 '                                                             =
                            04/07/2011
task: ffff88047a4cadc0 task.stack: ffffc9000a1dc000
RIP: 0010:btrfs_root_node+0x7/0x50
RSP: 0018:ffffc9000a1df830 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880c24d6b800 RCX: ffff8804e58f1700
RDX: 0000000000000100 RSI: ffff880c24d6b800 RDI: ffff880c24d6b800
RBP: ffff880c24d6b800 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880000000000
R13: ffff880c24d6b800 R14: 6db6db6db6db6db7 R15: 0000160000000000
FS:  00007f52d6362840(0000) GS:ffff88063fc80000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000124 CR3: 000000047755f000 CR4: 00000000000006e0
Call Trace:
 ? btrfs_read_lock_root_node+0x1f/0x40
 ? btrfs_search_slot+0x56b/0xa10
 ? submit_extent_page.isra.53+0x13f/0x210
 ? btrfs_lookup_ordered_extent+0x4d/0xb0
 ? btrfs_lookup_csum+0x3d/0x130
 ? __btrfs_lookup_bio_sums+0x2f3/0x6a0
 ? btrfs_submit_bio_hook+0xb3/0x180
 ? submit_one_bio+0x56/0x80
 ? extent_readpages+0x122/0x1c0
 ? btrfs_endio_direct_read+0xe0/0xe0
 ? __sk_dst_check+0x30/0x80
 ? __alloc_pages_nodemask+0xd0/0x180
 ? __do_page_cache_readahead+0x169/0x220
 ? ondemand_readahead+0x165/0x290
 ? pagecache_get_page+0x21/0x220
 ? generic_file_read_iter+0x70a/0x980
 ? walk_component+0x33/0x230
 ? generic_file_splice_read+0xaa/0x120
 ? splice_direct_to_actor+0xd5/0x1d0
 ? generic_pipe_buf_nosteal+0x10/0x10
 ? do_splice_direct+0x74/0xa0
 ? do_sendfile+0x195/0x370
 ? SyS_sendfile64+0x43/0x90
 ? do_syscall_64+0x56/0x130
 ? entry_SYSCALL64_slow_path+0x25/0x25
Code: 00 00 00 00 48 85 ff 53 48 89 fb 74 15 e8 62 ff ff ff 48 89 de 48 =
8b 3d 58                                                                 =
                        82 c3 00 5b e9 02 31 f2 ff 5b c3 53 48 89 fb 48 =
8b 13 <8b> 42 24 85 c0 74 18 8d                                          =
                                               48 01 48 8d 72 24 f0 0f =
b1 4a 24 0f 94
RIP: btrfs_root_node+0x7/0x50 RSP: ffffc9000a1df830
CR2: 0000000000000124
---[ end trace 4ada6453733af412 ]---

------=_NextPart_000_0020_01D356EB.347D8160--

