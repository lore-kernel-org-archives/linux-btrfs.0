Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vps89324.tnxip.de ([46.105.16.45]:55045 "EHLO vps89324.tnxip.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbbIASeV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 14:34:21 -0400
Received: from gw.tnxip.de (gateway.lan.tnxip.de [IPv6:fd06:b1f0:4941::1000])
	by vps89324.tnxip.de (Postfix) with ESMTPS id 72FD15C0030
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2015 20:26:15 +0200 (CEST)
Received: from localhost (localhost [IPv6:::1])
	by gw.tnxip.de (Postfix) with ESMTP id E6F5E6441A9
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2015 20:26:14 +0200 (CEST)
Received: from gw.tnxip.de ([IPv6:::1])
	by localhost (gateway.lan.tnxip.de [IPv6:::1]) (amavisd-new, port 10024)
	with LMTP id mUzWUAPaxBtR for <linux-btrfs@vger.kernel.org>;
	Tue,  1 Sep 2015 20:26:01 +0200 (CEST)
Received: from [IPv6:fdc7:1cc3:ec03:1:e968:bdd3:43ce:a4f4] (unknown [IPv6:fdc7:1cc3:ec03:1:e968:bdd3:43ce:a4f4])
	by gw.tnxip.de (Postfix) with ESMTPSA id 1830B644121
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2015 20:26:01 +0200 (CEST)
From: =?UTF-8?Q?Malte_Schr=c3=b6der?= <malte@tnxip.de>
Subject: Kernel 4.2 BUG at fs/btrfs/extent-tree.c:1833 while balancing
To: linux-btrfs@vger.kernel.org
Message-ID: <55E5EDAA.3070409@tnxip.de>
Date: Tue, 1 Sep 2015 20:25:46 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ciIG6o8svNNJdrRVDnCpsU6j91T1v9K2j"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ciIG6o8svNNJdrRVDnCpsU6j91T1v9K2j
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
I just switched to kernel 4.2. I had to replace one drive of a
btrfs-raid5 which was showing SMART errors. So I removed it (btrfs
device delete) while still on 4.1.6. In between kernel 4.2 was released
and I upgraded.
Now I added a replacement drive to the raid5-filesystem. When trying to
balance the fs it does fail with the BUG at the end of the mail.

I will revert to 4.1.6 and try this operation there.


#   uname -a
Linux gateway 4.2.0-gateway #1 SMP Tue Sep 1 15:36:23 CEST 2015 x86_64
GNU/Linux

#   btrfs --version
btrfs-progs v4.1.2

#   btrfs fi show
Label: 'SYSTEM'  uuid: e1c2694b-d33c-45f5-853d-db3ea5ea12cb
        Total devices 2 FS bytes used 211.71GiB
        devid    2 size 248.11GiB used 216.03GiB path /dev/sda2
        devid    3 size 248.11GiB used 216.03GiB path /dev/sdb2

Label: 'HOME'  uuid: 2a07c574-aee8-4744-af3c-43b9bc4ea18e
        Total devices 5 FS bytes used 5.16TiB
        devid    2 size 2.72TiB used 1.77TiB path /dev/sdd1
        devid    3 size 2.72TiB used 1.77TiB path /dev/sdc1
        devid    4 size 2.72TiB used 1.77TiB path /dev/sdg1
        devid    5 size 2.72TiB used 1.77TiB path /dev/sdf1
        devid    6 size 2.72TiB used 18.77GiB path /dev/sde1

btrfs-progs v4.1.2

#   btrfs fi df /home
Data, RAID5: total=3D5.31TiB, used=3D5.15TiB
System, RAID5: total=3D64.00MiB, used=3D404.00KiB
Metadata, RAID5: total=3D11.25GiB, used=3D9.39GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


All I could capture from netconsole:

> [ 3082.493327] BTRFS info (device sdc1): enabling auto defrag
> [ 3082.493390] BTRFS info (device sdc1): disk space caching is enabled
> [ 3082.493469] BTRFS: has skinny extents
> [ 3085.676461] BTRFS: checking UUID tree
> [ 3094.106563] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state r=
ecovery directory
> [ 3094.106628] NFSD: starting 90-second grace period (net ffffffff8379d=
e00)
> [ 3618.865269] BTRFS info (device sdc1): relocating block group 1675745=
32784128 flags 4
> [ 3646.135691] BTRFS info (device sdc1): relocating block group 1675745=
24395520 flags 4
> [ 3677.082739] BTRFS info (device sdc1): relocating block group 1675745=
16006912 flags 4
> [ 3712.037417] BTRFS info (device sdc1): relocating block group 1675745=
07618304 flags 4
> [ 3769.295701] BTRFS info (device sdc1): relocating block group 1675744=
99229696 flags 4
> [ 3788.342267] BTRFS info (device sdc1): relocating block group 1675744=
90841088 flags 4
> [ 3811.008060] BTRFS info (device sdc1): relocating block group 1675744=
82452480 flags 4
> [ 3826.152032] BTRFS info (device sdc1): relocating block group 1675744=
74063872 flags 4
> [ 3838.457233] BTRFS info (device sdc1): relocating block group 1675744=
65675264 flags 4
> [ 3848.820929] BTRFS info (device sdc1): relocating block group 1675744=
57286656 flags 4
> [ 3859.479263] BTRFS info (device sdc1): relocating block group 1675701=
62319360 flags 129
> [ 3898.690126] BTRFS info (device sdc1): found 3280 extents
> [ 3909.669799] ------------[ cut here ]------------
> [ 3909.669839] kernel BUG at fs/btrfs/extent-tree.c:1833!
> [ 3909.669871] invalid opcode: 0000 [#1] SMP=20
> [ 3909.669900] Modules linked in: cpuid netconsole configfs sit tunnel4=
 ip_tunnel rpcsec_gss_krb5 nls_iso8859_1 nls_cp437 nfsd auth_rpcgss nfs_a=
cl lockd vfat fat grace sunrpc msr nf_log_ipv4 xt_REDIRECT nf_nat_redirec=
t ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_log_ipv6 nf_log_common iptable=
_nat nf_nat_ipv4 ipt_REJECT nf_reject_ipv4 xt_recent ip6table_nat nf_nat_=
ipv6 xt_comment ip6t_REJECT nf_reject_ipv6 xt_addrtype xt_policy xt_mark =
ip6table_mangle ip6table_raw nf_conntrack_ipv6 nf_defrag_ipv6 iptable_man=
gle xt_tcpudp xt_CT iptable_raw xt_multiport nf_conntrack_ipv4 nf_defrag_=
ipv4 xt_conntrack nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_=
sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 xt_NFLOG nf_nat_f=
tp xt_LOG nf_nat_amanda nf_nat nf_conntrack_tftp nf_conntrack_sane nf_con=
ntrack_sip nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrac=
k_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_n=
s nf_conntrack_broadcast ts_kmp nf_conntrack_irc n
f_conntrack_amanda nf_conntrack_h323 nf_conntrack_ftp nf_conntrack iptabl=
e_filter binfmt_misc ip_tables ip6table_filter cpufreq_stats ip6_tables x=
_tables tun nfnetlink_log nfnetlink 8021q garp mrp stp llc pl2303 ftdi_si=
o usbserial hid_generic usbhid hid x86_pkg_temp_thermal coretemp kvm_inte=
l kvm crct10dif_pclmul crc32_pclmul crc32c_intel snd_hda_codec_hdmi ghash=
_clmulni_intel snd_hda_codec_realtek snd_hda_codec_generic aesni_intel iT=
CO_wdt iTCO_vendor_support snd_hda_intel i915 aes_x86_64 ehci_pci lrw snd=
_hda_codec xhci_pci xhci_hcd glue_helper ehci_hcd usbcore video snd_hwdep=
 snd_hda_core ablk_helper cryptd evdev snd_pcsp snd_pcm input_leds usb_co=
mmon led_class firewire_ohci firewire_core crc_itu_t sg snd_timer snd bac=
klight soundcore lpc_ich drm_kms_helper drm tpm_tis intel_gtt tpm agpgart=
 mfd_core 8250_pci mei_me mei i2c_i801 8250 serial_core button processor =
efivarfs microcode fan thermal [last unloaded: netconsole]
> [ 3909.689147] CPU: 3 PID: 4302 Comm: kworker/u16:8 Not tainted 4.2.0-g=
ateway #1
> [ 3909.691307] Hardware name: Supermicro X10SAE/X10SAE, BIOS 2.0a 05/09=
/2014
> [ 3909.693492] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
> [ 3909.695686] task: ffff88062d8b3ac0 ti: ffff8806044e0000 task.ti: fff=
f8806044e0000
> [ 3909.697915] RIP: 0010:[<ffffffff831e7e9e>]  [<ffffffff831e7e9e>] ins=
ert_inline_extent_backref+0xde/0xe0
> [ 3909.700194] RSP: 0018:ffff8806044e3b48  EFLAGS: 00010297
> [ 3909.702470] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000=
000000001
> [ 3909.704757] RDX: ffff880000000000 RSI: 0000000000000001 RDI: 0000000=
000000000
> [ 3909.707035] RBP: ffff88057d02d800 R08: 0000000000001000 R09: ffff880=
6044e3a58
> [ 3909.709309] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880=
51fed3e10
> [ 3909.711589] R13: 000000000000773b R14: 0000000000000000 R15: 0000000=
000000000
> [ 3909.713849] FS:  0000000000000000(0000) GS:ffff88081fac0000(0000) kn=
lGS:0000000000000000
> [ 3909.716108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3909.718370] CR2: 00007f5c4c227000 CR3: 0000000003744000 CR4: 0000000=
0001406e0
> [ 3909.720655] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> [ 3909.722945] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> [ 3909.725228] Stack:
> [ 3909.727495]  0000000000000000 000000000000773b 0000000000000002 0000=
000000000000
> [ 3909.729808]  ffff880500000001 ffffffff831dbb3e 0000000000000000 ffff=
ffff831e8ebb
> [ 3909.732125]  0000000000000000 0000000000000e68 ffff88051fed3e10 ffff=
880662cdf000
> [ 3909.734450] Call Trace:
> [ 3909.736768]  [<ffffffff831dbb3e>] ? btrfs_free_path+0xe/0x20
> [ 3909.739097]  [<ffffffff831e8ebb>] ? __btrfs_free_extent.isra.77+0x31=
b/0xd50
> [ 3909.741424]  [<ffffffff831e7f42>] ? __btrfs_inc_extent_ref.isra.61+0=
xa2/0x280
> [ 3909.743761]  [<ffffffff831ecd53>] ? __btrfs_run_delayed_refs+0xb73/0=
xf80
> [ 3909.746101]  [<ffffffff83111cab>] ? __slab_free+0x11b/0x260
> [ 3909.748443]  [<ffffffff8312136d>] ? __sb_start_write+0x3d/0xd0
> [ 3909.750789]  [<ffffffff831efbac>] ? btrfs_run_delayed_refs.part.82+0=
x6c/0x270
> [ 3909.753150]  [<ffffffff831efe33>] ? delayed_ref_async_start+0x73/0x9=
0
> [ 3909.755504]  [<ffffffff8305c7b7>] ? process_one_work+0x127/0x3f0
> [ 3909.757857]  [<ffffffff8305cac2>] ? worker_thread+0x42/0x480
> [ 3909.760199]  [<ffffffff8305ca80>] ? process_one_work+0x3f0/0x3f0
> [ 3909.762555]  [<ffffffff8306192c>] ? kthread+0xbc/0xe0
> [ 3909.764896]  [<ffffffff83061870>] ? kthread_worker_fn+0x140/0x140
> [ 3909.767230]  [<ffffffff83559f4f>] ? ret_from_fork+0x3f/0x70
> [ 3909.769564]  [<ffffffff83061870>] ? kthread_worker_fn+0x140/0x140
> [ 3909.771897] Code: e8 48 8b 84 24 b0 00 00 00 4c 89 f9 4c 89 e6 48 89=
 ef 48 89 44 24 10 8b 84 24 a8 00 00 00 89 44 24 08 e8 c6 d7 ff ff 31 c0 =
eb b3 <0f> 0b 41 57 41 56 4d 89 ce 41 55 4d 89 c5 41 54 55 48 89 fd 53=20
> [ 3909.776864] RIP  [<ffffffff831e7e9e>] insert_inline_extent_backref+0=
xde/0xe0
> [ 3909.779312]  RSP <ffff8806044e3b48>
> [ 3909.796024] ---[ end trace 91ea038bf7079205 ]---
> [ 3909.926250] Kernel panic - not syncing: Fatal exception
> [ 3909.932780] Kernel Offset: 0x2000000 from 0xffffffff81000000 (reloca=
tion range: 0xffffffff80000000-0xffffffffbfffffff)
> [ 3909.936691] drm_kms_helper: panic occurred, switching back to text c=
onsole
> [ 3910.044595] Rebooting in 60 seconds..
> [ 3969.574795] ACPI MEMORY or I/O RESET_REG.
>=20


/Malte


--ciIG6o8svNNJdrRVDnCpsU6j91T1v9K2j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV5e21AAoJEJhhoDgpnptoBrQQAMSDLpjO/IrkIU70KH8W3xz0
rwnqhMofPnZu+wudDYNxcc4tRTJCNUeVe16zWaUuMI8FKtBIAA8dVtW071bUwQYU
4Ra4QArucZdLZIkQDSR0lLSIipSJ7UzDDSofWKk0s+OnqlBqzLlM7OMI7ewNsusv
6pLxDKiRd1xa19eHgJn3cgxua/YaFO6zZmUah0F6/26OoeHgwKMUjLqlW5w8Cw1b
sRzoqfa64foQ3vxi8AksKACvycZHacStczop/ownI7vMBf4ld2zD8b3uOxTd2dE5
8ciiE5c8xdUxaOR7KEa5GrcRwPAgk0Sny9PJXRAkRvFRNVmrm3XNGF1OvF/XRFfq
bd64hIC++ErEwh+AJPHuoMRKfIgnr9nQjDzczu1jNvtj3rP1SrxtA6BeE/WXCxpe
bucSPJF4K8zL3ZWawaMhLOzwRiBOQW8q17l3h9DNQjl/yU8Uaoj3v/SyVqEkZIRr
J2U6YNyuR3mUEtyUwYN58T2NFkDk2XNb+zUynyNPzldmzeIW64b0aW60y+63B1rx
pZ3PXt3Ynnxt+fB+/I8Yy5lcn07+klaaE2ljDf82eYsL/rYKa1bLJD+W6SzP4UQ1
ejRsKnKEKpeAbuapLS2f7cWePFaeGbpBI0NeObfQ73nILGjznZAsz4opdf7xwJJN
h4KhVwGDeoalEJcpAht5
=LYVO
-----END PGP SIGNATURE-----

--ciIG6o8svNNJdrRVDnCpsU6j91T1v9K2j--
