Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:51458 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbcDOQ6t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 12:58:49 -0400
Date: Fri, 15 Apr 2016 21:58:39 +0500
From: Roman Mamedov <rm@romanrm.net>
To: =?UTF-8?B?TmljY29sw7I=?= Belli <darkbasic@linuxsystems.it>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Uncorrectable errors after rebooting with Magic Sysrq Keys
Message-ID: <20160415215839.7754f866@natsu>
In-Reply-To: <30940bf0-924b-4ad7-a3d8-24b980ba46f4@linuxsystems.it>
References: <b4f09d8b-baac-4182-81b1-1ba9f5e4195b@linuxsystems.it>
	<5710B4B8.9020002@cn.fujitsu.com>
	<30940bf0-924b-4ad7-a3d8-24b980ba46f4@linuxsystems.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//lIUiZ8IzTr9/3aag4y2V9J"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//lIUiZ8IzTr9/3aag4y2V9J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Apr 2016 17:42:21 +0200
Niccol=C3=B2 Belli <darkbasic@linuxsystems.it> wrote:

> Hi,
> Is it 100% safe to run a btrfs check without --repair?
> Because otherwise I will have to wait for my new external drive to arrive=
=20
> and make a backup first.

In cases like these remember that you can use "blockdev --setro /dev/sdX", =
to
ensure that any program (even the root user with 'dd') can't write anything
to the block device anymore even if tried.

Use "blockdev --setrw /dev/sdX" after you finished.

--=20
With respect,
Roman

--Sig_//lIUiZ8IzTr9/3aag4y2V9J
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlcRHcIACgkQTLKSvz+PZwj8OwCfQsLRGSSeR2H1CQz7b9jjSZ9B
R1wAn3butBtAFwpl4JMlhA8EcXeUhvjP
=l+yZ
-----END PGP SIGNATURE-----

--Sig_//lIUiZ8IzTr9/3aag4y2V9J--
