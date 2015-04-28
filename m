Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41175 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbbD1H7w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 03:59:52 -0400
Date: Tue, 28 Apr 2015 07:59:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Joshua Schmidlkofer <joshland@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Filesystem with Errors, Unusual behavior
Message-ID: <20150428075951.GE18187@carfax.org.uk>
References: <CAHduLLSZmY8M9_iu==6x5M4meb7poKgir8pjA+gVRCCmzMkJDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1VtFtf1bAEcuptAG"
In-Reply-To: <CAHduLLSZmY8M9_iu==6x5M4meb7poKgir8pjA+gVRCCmzMkJDg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1VtFtf1bAEcuptAG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 27, 2015 at 11:11:36PM -0700, Joshua Schmidlkofer wrote:
> I have a large-ish filesystem, and it's starting to cause problems
> after some SATA errors.
> 
> After scrubs stalled, and reading of people with similar errors, I
> downloaded the latest btrfs-progs and attempted a btrfsck - is
> segfaults.   This is ubuntu 14.04, running the mainline kernel 3.19.5.
> I downloaded, built and ran btrfs-progs v3.19.1
> 
> "enabling repair mode
> Checking filesystem on /dev/sdg1
> UUID: 6d04d7ce-c27d-48c4-b655-2ef30bcb31ba
> checking extents
> bad key ordering 0 1
> bad block 29535579947008
> Errors found in extent allocation tree or chunk allocation
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> bad key ordering 0 1
> The following tree block(s) is corrupted in tree 437:
>         tree block bytenr: 29534473060352, level: 0, node key:
> (33134905409536, 168, 16384)
> Try to repair the btree for root 437
> Segmentation fault (core dumped)"

   I think every single case we've seen of bad key ordering so far has
been as a result of bad RAM. I would strongly recommend running
memtest on your machine.

   That said, the key being quoted isn't obviously the result of a
bitflip: hex(33134905409536) = 0x1e22d2444000.

   Can you show us the result of "btrfs-debug-tree -b 29534473060352"?

   Hugo.


> The filesystem mounts,but device sdi has errors and persistent issues.
> I get these in dmesg:
> "
> [12241.912137] BTRFS warning (device sdi1): page private not zero on
> page 25047644831744
> [12241.912143] BTRFS warning (device sdi1): page private not zero on
> page 25047644835840
> [12241.912146] BTRFS warning (device sdi1): page private not zero on
> page 25047644839936
> [12241.912148] BTRFS warning (device sdi1): page private not zero on
> page 25047644844032
> [12241.912165] BTRFS warning (device sdi1): page private not zero on
> page 25047695720448
> [12241.912167] BTRFS warning (device sdi1): page private not zero on
> page 25047695724544
> [12241.912170] BTRFS warning (device sdi1): page private not zero on
> page 25047695728640
> [12241.912172] BTRFS warning (device sdi1): page private not zero on
> page 25047695732736
> [12241.912175] BTRFS warning (device sdi1): page private not zero on
> page 25048245633024
> [12241.912177] BTRFS warning (device sdi1): page private not zero on
> page 25048245637120
> [12241.912180] BTRFS warning (device sdi1): page private not zero on
> page 25048245641216
> [12241.912182] BTRFS warning (device sdi1): page private not zero on
> page 25048245645312
> [12241.912185] BTRFS warning (device sdi1): page private not zero on
> page 25048247353344
> [12241.912187] BTRFS warning (device sdi1): page private not zero on
> page 25048247357440
> [12241.912194] BTRFS warning (device sdi1): page private not zero on
> page 25048247361536
> [12241.912197] BTRFS warning (device sdi1): page private not zero on
> page 25048247365632
> [12241.912201] BTRFS warning (device sdi1): page private not zero on
> page 27051485708288
> [12241.912204] BTRFS warning (device sdi1): page private not zero on
> page 27051485712384
> [12241.912206] BTRFS warning (device sdi1): page private not zero on
> page 27051485716480
> [12241.912208] BTRFS warning (device sdi1): page private not zero on
> page 27051485720576
> "
> 
> It continues to attempt restarting the balance which was running when
> the error cropped up:
> 
> "
> [12972.887417] BTRFS: checking UUID tree
> [12972.887468] BTRFS info (device sdi1): continuing balance
> [12973.480650] BTRFS info (device sdi1): relocating block group
> 35081624223744 flags 68
> [13002.058463] BTRFS critical (device sdi1): corrupt leaf, bad key
> order: block=29534473060352,root=1, slot=0
> [13002.059204] BTRFS critical (device sdi1): corrupt leaf, bad key
> order: block=29534473060352,root=1, slot=0
> [13002.059233] ------------[ cut here ]------------
> [13002.059269] WARNING: CPU: 5 PID: 9506 at
> /home/kernel/COD/linux/fs/btrfs/super.c:260
> __btrfs_abort_transaction+0x5f/0x140 [btrfs]()
> [13002.059272] BTRFS: Transaction aborted (error -5)
> [13002.059274] Modules linked in: rfcomm bnep bluetooth nfsd
> auth_rpcgss nfs_acl nfs bridge binfmt_misc lockd stp llc grace sunrpc
> fscache snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
> snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq_midi
> snd_seq_midi_event snd_rawmidi gpio_ich snd_seq coretemp kvm_intel
> nouveau kvm snd_seq_device snd_timer mxm_wmi snd video serio_raw ttm
> drm_kms_helper i7core_edac soundcore lpc_ich drm edac_core
> i2c_algo_bit wmi mac_hid shpchp parport_pc ppdev lp parport tcp_htcp
> btrfs uas raid10 raid456 async_raid6_recov async_memcpy async_pq
> async_xor async_tx xor raid6_pq firewire_ohci raid1 raid0 e1000e
> pata_acpi firewire_core ahci multipath ptp pata_jmicron usb_storage
> libahci pps_core crc_itu_t linear
> [13002.059340] CPU: 5 PID: 9506 Comm: kworker/u32:7 Tainted: G
> W      3.19.5-031905-generic #201504211114
> [13002.059342] Hardware name: Gigabyte Technology Co., Ltd.
> X58A-UD3R/X58A-UD3R, BIOS FB 08/24/2010
> [13002.059367] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
> [13002.059369]  0000000000000104 ffff8803b904bc18 ffffffff817c6f17
> 0000000000000007
> [13002.059372]  ffff8803b904bc68 ffff8803b904bc58 ffffffff81076e17
> ffff8803b904bc58
> [13002.059375]  ffff88040c270580 ffff8803a096b000 00000000fffffffb
> 0000000000000ae8
> [13002.059379] Call Trace:
> [13002.059386]  [<ffffffff817c6f17>] dump_stack+0x45/0x57
> [13002.059392]  [<ffffffff81076e17>] warn_slowpath_common+0x97/0xe0
> [13002.059397]  [<ffffffff81076f16>] warn_slowpath_fmt+0x46/0x50
> [13002.059411]  [<ffffffffc04665cf>]
> __btrfs_abort_transaction+0x5f/0x140 [btrfs]
> [13002.059428]  [<ffffffffc04840b5>]
> btrfs_run_delayed_refs.part.82+0x175/0x290 [btrfs]
> [13002.059445]  [<ffffffffc04841e7>] btrfs_run_delayed_refs+0x17/0x20 [btrfs]
> [13002.059462]  [<ffffffffc04844b7>] delayed_ref_async_start+0x37/0x90 [btrfs]
> [13002.059485]  [<ffffffffc04c616e>] normal_work_helper+0x7e/0x1b0 [btrfs]
> [13002.059508]  [<ffffffffc04c64d2>] btrfs_extent_refs_helper+0x12/0x20 [btrfs]
> [13002.059513]  [<ffffffff8108f6b4>] process_one_work+0x144/0x470
> [13002.059516]  [<ffffffff810900fe>] worker_thread+0x11e/0x450
> [13002.059520]  [<ffffffff8108ffe0>] ? create_worker+0x1f0/0x1f0
> [13002.059524]  [<ffffffff81095e29>] kthread+0xc9/0xe0
> [13002.059528]  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
> [13002.059532]  [<ffffffff817d3958>] ret_from_fork+0x58/0x90
> [13002.059535]  [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
> [13002.059538] ---[ end trace 525f91ec70905a5c ]---
> [13002.059541] BTRFS: error (device sdi1) in
> btrfs_run_delayed_refs:2792: errno=-5 IO failure
> [13002.059544] BTRFS info (device sdi1): forced readonly
> "
> 
> Addtional Commands:
> 
> root@phoenix:/usr/src/btrfs-progs# ./btrfs --version
> btrfs-progs v3.19.1
> 
> root@phoenix:/usr/src/btrfs-progs# ./btrfs fi show
> Label: 'root'  uuid: 0b762c31-e52b-449b-ba35-2bbbc08e931a
> Total devices 1 FS bytes used 75.41GiB
> devid    1 size 111.46GiB used 111.46GiB path /dev/mapper/phoenixroot-root
> 
> Label: 'media2015'  uuid: 6d04d7ce-c27d-48c4-b655-2ef30bcb31ba
> Total devices 8 FS bytes used 9.18TiB
> devid    1 size 3.64TiB used 3.15TiB path /dev/sdg1
> devid    2 size 3.64TiB used 3.15TiB path /dev/sdi1
> devid    3 size 3.64TiB used 3.15TiB path /dev/sde1
> devid    4 size 3.64TiB used 3.15TiB path /dev/sdf1
> devid    6 size 2.73TiB used 2.13TiB path /dev/sdh1
> devid    7 size 2.73TiB used 2.13TiB path /dev/sdd1
> devid    8 size 2.73TiB used 774.75GiB path /dev/sdc1
> devid    9 size 3.64TiB used 774.75GiB path /dev/sdb1
> 
> btrfs-progs v3.19.1
> 
> root@phoenix:/usr/src/btrfs-progs# ./btrfs fi df /media2015 # Replace
> /home with the mount point of your btrfs-filesystem
> Data, RAID10: total=9.17TiB, used=9.17TiB
> System, RAID10: total=96.00MiB, used=880.00KiB
> Metadata, RAID10: total=13.28GiB, used=11.98GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

-- 
Hugo Mills             | Quantum est ille canis in fenestra?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--1VtFtf1bAEcuptAG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVPz33AAoJEFheFHXiqx3kHQwP/2FB2wcYhPNDw0NClvvhc0S3
Q6yehMp8hiDBI2JW1hmYfI9AFk4eEpulurnKotfslUdaTphocth14/8gHCIe5rIB
2bhXcbxVcdLT4gPKvcnVYBnoAjeMy29swghltfAolLe0hOZIAdQbGEWSCGmDNa45
mHoTevyywdDDEXdrd7JZZcrka1YqdoopF0mYlEAzKSXKGc8blE5JXl/BWhBUitQ7
BfzyWfKWe1Ja4kw6A5/l6Ahj+GwHcgYk69X7TD7f55X0I+Mlrrxm6Zd5KOS2lDwb
sNO6wnTlur8wVPFPx4/2iChV8fLtin0VxNkqsItsbd+t2HEBN2Wx5PEk3dEgD7/5
SFu8Z0jlsYaXkZeD31941kisFt37BSq/4I7SeuitcXssJC7PAplDI2gP1VHzyt/J
w4EWw6v0jcSh4rCCg2b1gc2kI+9qrUANZyRl1Nj/eFnZ6X/stJziU2w5uGo9f2xc
DJcp9HrwT9f5TbSHr9AhLubfi963Tw7kRiz1YynzO2AGZ1mnc4opHKHGFiHyeDGW
U5bAeEhzTJwNgqz8XXHMwH7+gX/VGKsibUTPZ4xXc0+uKxSecmfYn/wBZysSK2AP
gVP9jO49v5DbYxSsKzUPWRGEISLdMhPULwpQT2taSio9pQO/F/7DxAfZaEU5ESi6
MGhN1S5yp2UJJ2Vfq2Jx
=50V/
-----END PGP SIGNATURE-----

--1VtFtf1bAEcuptAG--
