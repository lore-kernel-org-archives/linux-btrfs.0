Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38603 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3E0Rs5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 13:48:57 -0400
Received: by mail-ee0-f45.google.com with SMTP id l10so4134739eei.4
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 10:48:56 -0700 (PDT)
Date: Mon, 27 May 2013 20:47:23 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: =?UTF-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: systemd "journalctl" is 1.89sec on ext4, 1.49 min on btrfs
Message-ID: <20130527204723.573c4e3f@sf>
In-Reply-To: <16735484.PAleCPYpY8@noname>
References: <16735484.PAleCPYpY8@noname>
Reply-To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G_8Oa363m5eUB1Rpm.yYElq"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/G_8Oa363m5eUB1Rpm.yYElq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 27 May 2013 18:21:21 +0200
Sz=C5=91ts =C3=81kos <szotsaki@gmail.com> wrote:

> Dear list,
>=20
> I have two openSUSE 12.3 systems with kernel 3.9. On one of them there's =
an=20
> ext4 partition, while on the other there's a btrfs.
>=20
> I issued a "time journalctl -b --no-pager" command on both systems. This =
shows=20
> the logs from the current boot without passing them to "less".
>=20
> On ext4 (3.9.3):
> real    0m1.898s
> user    0m0.291s
> sys     0m0.105s
>=20
> On btrfs (3.9.2):
> real    1m49.698s
> user    0m0.102s
> sys     0m0.470s
>=20
> Journalctl on btrfs was always this slow, some btrfsck were made on the f=
ile=20
> system too, but I don't think it was corrupted. On just the first run it'=
s=20
> sluggish, after it's fast as the ext4 one.
>=20
> Is it a known issue or can I help somehow debugging this further?

Let's look at your
    /usr/sbin/filefrag /var/log/journal/*/*
on both systems

--=20

  Sergei

--Sig_/G_8Oa363m5eUB1Rpm.yYElq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGjnDEACgkQcaHudmEf86o3gwCePdm3hBeR49Q1v/cbVGxIDxKJ
kfYAnjWN1RSkkaR3r7HsZCJGXuLlPcgw
=oxtN
-----END PGP SIGNATURE-----

--Sig_/G_8Oa363m5eUB1Rpm.yYElq--
