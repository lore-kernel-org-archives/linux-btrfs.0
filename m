Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:38884 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2IRETe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 00:19:34 -0400
Date: Tue, 18 Sep 2012 10:19:30 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: miaox@cn.fujitsu.com
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
Message-ID: <20120918101930.6f3edb3c@natsu>
In-Reply-To: <5057DD0D.1070201@cn.fujitsu.com>
References: <5057CDA7.3090201@jp.fujitsu.com>
	<5057CEA9.3070707@jp.fujitsu.com>
	<5057DD0D.1070201@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3DTNEohlbuuFyYBULoPGmAB"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/3DTNEohlbuuFyYBULoPGmAB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Sep 2012 10:31:41 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> On tue, 18 Sep 2012 10:30:17 +0900, Hidetoshi Seto wrote:
> > This patch adds mount-option command.
> > The command can set/get default mount options.
> > Now, the command can set/get 24 options.
> > These options are equal to mount options which store
> > in fs_info/mount-opt.
>=20
> I don't think we need implement a separate command to do this,
> we can add it into btrfstune just like ext3/4. If so, the users
> who used ext3/4 before can be familiar with btrfs command as soon
> as possible.

btrfstune currently only does one thing:

$ sudo btrfstune
usage: btrfstune [options] device
	-S value	enable/disable seeding

To me it'd seem more logical the other way, why not move this operation to =
the
base "btrfs" utility under some command, and remove "btrfstune" completely.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/3DTNEohlbuuFyYBULoPGmAB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBX9lIACgkQTLKSvz+PZwiuwgCcCFQnc+TSab1hyzI7YVpNwCKg
k7YAn3bupXyeDN7JzDPJb5Y3hwfghi/w
=jpqe
-----END PGP SIGNATURE-----

--Sig_/3DTNEohlbuuFyYBULoPGmAB--
