Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:60365 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752857AbdAZIJ3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 03:09:29 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <mkl@pengutronix.de>)
        id 1cWf7X-0001P1-97
        for linux-btrfs@vger.kernel.org; Thu, 26 Jan 2017 09:09:27 +0100
Received: from [IPv6:2001:470:7eea:1122:f148:f29b:6cb9:e1f4] (unknown [IPv6:2001:470:7eea:1122:f148:f29b:6cb9:e1f4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (verified OK))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 84A121C031F
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jan 2017 09:08:49 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Marc Kleine-Budde <mkl@pengutronix.de>
Subject: btrfs send | receive: corrupted stack end detected inside scheduler
Message-ID: <688ee9bb-1213-dcd9-1780-7e116a8a075e@pengutronix.de>
Date: Thu, 26 Jan 2017 09:08:39 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ESgsM6LI8fU52Hn5tchvXDPciEEQSXXF8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ESgsM6LI8fU52Hn5tchvXDPciEEQSXXF8
Content-Type: multipart/mixed; boundary="l4NFo53QjWn1V63d9CWI5Re8wOP09xhsL";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-btrfs@vger.kernel.org
Message-ID: <688ee9bb-1213-dcd9-1780-7e116a8a075e@pengutronix.de>
Subject: btrfs send | receive: corrupted stack end detected inside scheduler

--l4NFo53QjWn1V63d9CWI5Re8wOP09xhsL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

during a "btrfs send | btrfs receive" from a raid1 to a single USB
harddrive the kernel oopsed with:

[ 9504.261077] Kernel panic - not syncing: corrupted stack end detected i=
nside scheduler
[ 9504.261077]=20
[ 9504.270410] CPU: 0 PID: 4016 Comm: btrfs Not tainted 4.8.0-2-armmp #1 =
Debian 4.8.15-2
[ 9504.278229] Hardware name: Allwinner sun7i (A20) Family
[ 9504.283484] [<c0114c2c>] (unwind_backtrace) from [<c010ee5c>] (show_st=
ack+0x20/0x24)
[ 9504.291230] [<c010ee5c>] (show_stack) from [<c0402f74>] (dump_stack+0x=
98/0xac)
[ 9504.298455] [<c0402f74>] (dump_stack) from [<c0266cfc>] (panic+0x100/0=
x294)
[ 9504.305421] [<c0266cfc>] (panic) from [<c07d8b00>] (schedule+0x0/0xa8)=

[ 9504.311949] [<c07d8b00>] (schedule) from [<c07d8b50>] (schedule+0x50/0=
xa8)
[ 9504.318822] [<c07d8b50>] (schedule) from [<c07dc1b0>] (schedule_timeou=
t+0x25c/0x3b4)
[ 9504.326562] [<c07dc1b0>] (schedule_timeout) from [<c07d829c>] (io_sche=
dule_timeout+0xc4/0x13c)
[ 9504.335168] [<c07d829c>] (io_schedule_timeout) from [<c07d95dc>] (bit_=
wait_io+0x20/0x6c)
[ 9504.343254] [<c07d95dc>] (bit_wait_io) from [<c07d9054>] (__wait_on_bi=
t+0x94/0xc8)
[ 9504.350820] [<c07d9054>] (__wait_on_bit) from [<c0268414>] (wait_on_pa=
ge_bit+0xf0/0x10c)
[ 9504.359232] [<c0268414>] (wait_on_page_bit) from [<bf3de718>] (read_ex=
tent_buffer_pages+0x354/0x3bc [btrfs])
[ 9504.369333] [<bf3de718>] (read_extent_buffer_pages [btrfs]) from [<bf3=
a8eec>] (btree_read_extent_buffer_pages.constprop.8+0xdc/0x150 [btrfs])
[ 9504.382256] [<bf3a8eec>] (btree_read_extent_buffer_pages.constprop.8 [=
btrfs]) from [<bf3a958c>] (read_tree_block+0x3c/0x58 [btrfs])
[ 9504.394303] [<bf3a958c>] (read_tree_block [btrfs]) from [<bf3831ec>] (=
read_block_for_search+0x14c/0x388 [btrfs])
[ 9504.404699] [<bf3831ec>] (read_block_for_search [btrfs]) from [<bf3852=
38>] (btrfs_search_slot+0x4d0/0x99c [btrfs])
[ 9504.415269] [<bf385238>] (btrfs_search_slot [btrfs]) from [<bf3a3470>]=
 (btrfs_lookup_csum+0x7c/0x1a8 [btrfs])
[ 9504.425406] [<bf3a3470>] (btrfs_lookup_csum [btrfs]) from [<bf3a38fc>]=
 (__btrfs_lookup_bio_sums+0x340/0x654 [btrfs])
[ 9504.436150] [<bf3a38fc>] (__btrfs_lookup_bio_sums [btrfs]) from [<bf3a=
40a4>] (btrfs_lookup_bio_sums+0x34/0x3c [btrfs])
[ 9504.447069] [<bf3a40a4>] (btrfs_lookup_bio_sums [btrfs]) from [<bf3b50=
bc>] (btrfs_submit_bio_hook+0xc4/0x210 [btrfs])
[ 9504.457905] [<bf3b50bc>] (btrfs_submit_bio_hook [btrfs]) from [<bf3d4e=
e4>] (submit_one_bio+0xbc/0xe4 [btrfs])
[ 9504.468141] [<bf3d4ee4>] (submit_one_bio [btrfs]) from [<bf3da660>] (s=
ubmit_extent_page+0xf0/0x234 [btrfs])
[ 9504.478126] [<bf3da660>] (submit_extent_page [btrfs]) from [<bf3db82c>=
] (__do_readpage+0x4a8/0xac4 [btrfs])
[ 9504.488130] [<bf3db82c>] (__do_readpage [btrfs]) from [<bf3dc334>] (__=
extent_readpages.constprop.16+0x3a0/0x3e8 [btrfs])
[ 9504.499231] [<bf3dc334>] (__extent_readpages.constprop.16 [btrfs]) fro=
m [<bf3dcf14>] (extent_readpages+0x140/0x1e4 [btrfs])
[ 9504.510591] [<bf3dcf14>] (extent_readpages [btrfs]) from [<bf3b6618>] =
(btrfs_readpages+0x30/0x38 [btrfs])
[ 9504.520278] [<bf3b6618>] (btrfs_readpages [btrfs]) from [<c02795d4>] (=
__do_page_cache_readahead+0x1b0/0x28c)
[ 9504.530104] [<c02795d4>] (__do_page_cache_readahead) from [<c02797cc>]=
 (ondemand_readahead+0x11c/0x220)
[ 9504.539491] [<c02797cc>] (ondemand_readahead) from [<c0279ad0>] (page_=
cache_sync_readahead+0x5c/0x7c)
[ 9504.548831] [<c0279ad0>] (page_cache_sync_readahead) from [<bf4353c0>]=
 (send_extent_data+0x1a8/0x620 [btrfs])
[ 9504.558978] [<bf4353c0>] (send_extent_data [btrfs]) from [<bf435aac>] =
(process_extent+0x274/0x120c [btrfs])
[ 9504.568949] [<bf435aac>] (process_extent [btrfs]) from [<bf4399d0>] (c=
hanged_cb+0x258/0xb6c [btrfs])
[ 9504.578314] [<bf4399d0>] (changed_cb [btrfs]) from [<bf43b3cc>] (btrfs=
_ioctl_send+0x10e8/0x11cc [btrfs])
[ 9504.588024] [<bf43b3cc>] (btrfs_ioctl_send [btrfs]) from [<bf3f87d4>] =
(btrfs_ioctl+0xdb4/0x270c [btrfs])
[ 9504.597621] [<bf3f87d4>] (btrfs_ioctl [btrfs]) from [<c02e7f50>] (do_v=
fs_ioctl+0xc0/0x990)
[ 9504.605882] [<c02e7f50>] (do_vfs_ioctl) from [<c02e889c>] (SyS_ioctl+0=
x7c/0x8c)
[ 9504.613193] [<c02e889c>] (SyS_ioctl) from [<c0109ea0>] (ret_fast_sysca=
ll+0x0/0x3c)
[ 9504.620790] CPU1: stopping
[ 9504.623517] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.8.0-2-armmp #1=
 Debian 4.8.15-2
[ 9504.631423] Hardware name: Allwinner sun7i (A20) Family
[ 9504.636662] [<c0114c2c>] (unwind_backtrace) from [<c010ee5c>] (show_st=
ack+0x20/0x24)
[ 9504.644408] [<c010ee5c>] (show_stack) from [<c0402f74>] (dump_stack+0x=
98/0xac)
[ 9504.651629] [<c0402f74>] (dump_stack) from [<c01126e8>] (handle_IPI+0x=
2a4/0x2c4)
[ 9504.659022] [<c01126e8>] (handle_IPI) from [<c01017d0>] (gic_handle_ir=
q+0x8c/0x90)
[ 9504.666589] [<c01017d0>] (gic_handle_irq) from [<c07dd58c>] (__irq_svc=
+0x6c/0x90)
[ 9504.674062] Exception stack(0xee957f48 to 0xee957f90)
[ 9504.679111] 7f40:                   00000000 ef6ce478 0038334e c012138=
0 ee956000 c0c03658
[ 9504.687281] 7f60: 10c0387d c0c035ec 00000002 c0c035ec 00000000 ee957fa=
4 ee957fa8 ee957f98
[ 9504.695447] 7f80: c010aa20 c010aa24 60000013 ffffffff
[ 9504.700502] [<c07dd58c>] (__irq_svc) from [<c010aa24>] (arch_cpu_idle+=
0x48/0x4c)
[ 9504.707897] [<c010aa24>] (arch_cpu_idle) from [<c0196268>] (default_id=
le_call+0x30/0x3c)
[ 9504.715983] [<c0196268>] (default_idle_call) from [<c0196490>] (cpu_st=
artup_entry+0x21c/0x278)
[ 9504.724590] [<c0196490>] (cpu_startup_entry) from [<c01121d8>] (second=
ary_start_kernel+0x15c/0x184)
[ 9504.733628] [<c01121d8>] (secondary_start_kernel) from [<40101e2c>] (0=
x40101e2c)
[ 9504.741056] Kernel panic - not syncing: corrupted stack end detected i=
nside scheduler
[ 9504.741056]=20
[ 9504.750359] ---[ end Kernel panic - not syncing: corrupted stack end d=
etected inside scheduler

The hardware is a sunxi armhf SMP with debian's latest v4.8 kernel
(4.8.15-2).

regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--l4NFo53QjWn1V63d9CWI5Re8wOP09xhsL--

--ESgsM6LI8fU52Hn5tchvXDPciEEQSXXF8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEES2FAuYbJvAGobdVQPTuqJaypJWoFAliJrooACgkQPTuqJayp
JWqdHwgAmPmDwjSQj+GZVxjz1GZuaazxfLyv59LOD3M9l2l1WI7ROqZW/60cH/GS
phqBAjFHtytah9/SjogFzbZLD/I/glGN0OzClgRjO6k2i72PVOvmsUhqZYDR3cLM
U/QybBXH1rlSXt4LAGRHNsL/IY/Fmnt3YWOOMce+UjPBioaholK6PF+VIf4Vpw0L
iIan3EO7yospKY2MafEwROW7qXiv/etcFaN0gw2lSm8H0dsT8PprGC9qs8XP1W0C
2DcJ4A7kIllzrndQaMcKfg/K0n957KvJBTwDYQFICOC1lFM46GJ5BvMcFoGjLq1j
U2z1qxX8jiugEAYds3Y7jNBeQevzKA==
=Juek
-----END PGP SIGNATURE-----

--ESgsM6LI8fU52Hn5tchvXDPciEEQSXXF8--
