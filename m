Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:34203 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725749AbeHPLEi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 07:04:38 -0400
Subject: Re: Transaction aborted - 4.16.17 kernel
To: David Goodwin <david@codepoets.co.uk>, linux-btrfs@vger.kernel.org
References: <8226e7cc-3831-de01-0682-cf57e7aa3adb@codepoets.co.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8fb26836-6245-b062-7899-23741e6eb359@gmx.com>
Date: Thu, 16 Aug 2018 16:07:45 +0800
MIME-Version: 1.0
In-Reply-To: <8226e7cc-3831-de01-0682-cf57e7aa3adb@codepoets.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="STzh8WaM3RURNtCJZuxRTmtdRBgdBmu2s"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--STzh8WaM3RURNtCJZuxRTmtdRBgdBmu2s
Content-Type: multipart/mixed; boundary="PeysSx6OBzkb7Yo36908UXwkgL0Mbmiqy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Goodwin <david@codepoets.co.uk>, linux-btrfs@vger.kernel.org
Message-ID: <8fb26836-6245-b062-7899-23741e6eb359@gmx.com>
Subject: Re: Transaction aborted - 4.16.17 kernel
References: <8226e7cc-3831-de01-0682-cf57e7aa3adb@codepoets.co.uk>
In-Reply-To: <8226e7cc-3831-de01-0682-cf57e7aa3adb@codepoets.co.uk>

--PeysSx6OBzkb7Yo36908UXwkgL0Mbmiqy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/16 =E4=B8=8B=E5=8D=883:51, David Goodwin wrote:
> I've just spotted this on one server.
>=20
> Running : umount /backups && mount /backups
>=20
> seems to allow it to become r/w again, but it does write :
>=20
> BTRFS error (device xvdj): cleaner transaction attach returned -30
>=20
> to 'dmesg'.
>=20
>=20
> David.
>=20
> ------------[ cut here ]------------
>=20
> BTRFS: Transaction aborted (error -28)
> WARNING: CPU: 3 PID: 992 at fs/btrfs/extent-tree.c:7004

Looks like some tree block backref mismatch.

Would you please try "btrfs check --readonly <device>" to see if it
reports any error?

Thanks,
Qu

> __btrfs_free_extent.isra.63+0x3d2/0xd20
> Modules linked in: dm_mod dax ipt_REJECT nf_reject_ipv4 nfsv3
> ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat_ftp nf_conntrack_ftp nf_nat
> nf_conntrack libcrc32c xt_multiport iptable_filter ip_tables x_tables
> autofs4 nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc
> intel_rapl crct10dif_pclmul crc32_pclmul ghash_clmulni_intel evdev pcbc=

> snd_pcsp snd_pcm aesni_intel snd_timer aes_x86_64 crypto_simd snd
> glue_helper cryptd soundcore xen_netfront xen_blkfront crc32c_intel
> CPU: 3 PID: 992 Comm: btrfs-transacti Not tainted 4.16.17-dg1 #1
> RIP: e030:__btrfs_free_extent.isra.63+0x3d2/0xd20
> RSP: e02b:ffffc9004290bc68 EFLAGS: 00010292
> RAX: 0000000000000026 RBX: 00000180c5538000 RCX: 0000000000000006
> RDX: 0000000000000007 RSI: 0000000000000001 RDI: ffff88039a996650
> RBP: 00000000ffffffe4 R08: 0000000000000001 R09: 0000000000001d80
> R10: 0000000000000001 R11: 0000000000001d80 R12: ffff880392d64000
> R13: ffff880251fedcb0 R14: 0000000000000000 R15: 0000000000000002
> FS:=C2=A0 0000000000000000(0000) GS:ffff88039a980000(0000)
> knlGS:0000000000000000
> CS:=C2=A0 e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fdee11425c0 CR3: 00000002d3700000 CR4: 0000000000000660
> Call Trace:
> =C2=A0? btrfs_merge_delayed_refs+0x23c/0x3c0
> =C2=A0__btrfs_run_delayed_refs+0x320/0x1180
> =C2=A0btrfs_run_delayed_refs+0x105/0x1c0
> =C2=A0btrfs_commit_transaction+0x393/0x8a0
> =C2=A0? wait_woken+0x80/0x80
> =C2=A0transaction_kthread+0x195/0x1b0
> =C2=A0kthread+0xf8/0x130
> =C2=A0? btrfs_cleanup_transaction+0x540/0x540
> =C2=A0? kthread_create_worker_on_cpu+0x50/0x50
> =C2=A0ret_from_fork+0x35/0x40
> Code: 48 8b 04 24 48 8b 40 50 f0 48 0f ba a8 d0 16 00 00 02 72 19 83 fd=

> fb 0f 84 07 03 00 00 89 ee 48 c7 c7 30 f3 d9 81 e8 2e a6 d7 ff <0f> 0b
> 48 8b 3c 24 89 e9 ba 5c 1b 00 00 48 c7 c6 80 86 c3 81 e8
> ---[ end trace c83740faa277d833 ]---


--PeysSx6OBzkb7Yo36908UXwkgL0Mbmiqy--

--STzh8WaM3RURNtCJZuxRTmtdRBgdBmu2s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt1MNEACgkQwj2R86El
/qhoQQf/WdxLMSGq/Znxo97Ous+kWFZaXj9qQ0mUze9cpXmFOjuvTQgN/25hfgbp
Tuwwp+5+Kh8emwQRmnMvqOngqeZSvUwj04MQQOE4VaBunpmUH0Qzkm0rpnIkK6Xb
X3ZvSJ1UJRymy+KlOy5Pyr6twKHhYDRMXFyrT4NHymF4hH0tvDa7t+uHkZ6oPGlA
mi/ocS3bgTSjv++HxcZJEkO4v+vnv5Wg6cDP5/RlqQld5yBpCRcmEVfdzYpQOsQn
pnYvDQW84MvTtPACRwImwLCaDavtt3ZuIXiEZu6l0FJRc6izbxb9Yr7oLOedUf63
ESQ0CBh2FF4v11pHOX5SAjWzf6GXig==
=rfUd
-----END PGP SIGNATURE-----

--STzh8WaM3RURNtCJZuxRTmtdRBgdBmu2s--
