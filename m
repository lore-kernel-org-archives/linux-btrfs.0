Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:38733 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaEVEOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 00:14:39 -0400
Date: Thu, 22 May 2014 10:14:31 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] btrfs: label should not contain return char
Message-ID: <20140522101431.6b2a9ee2@natsu>
In-Reply-To: <537D5D6F.900@redhat.com>
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
	<1400567808-9494-1-git-send-email-anand.jain@oracle.com>
	<537B83AD.5010901@redhat.com>
	<537D5B55.1010207@oracle.com>
	<537D5D6F.900@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jRjoUox6YD1/KPU0A.UVH7W"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/jRjoUox6YD1/KPU0A.UVH7W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 May 2014 21:14:07 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> >> (Random aside: why does btrfs support online fs relabeling, anyway?)
> >>
> >> -Eric
> >=20
> >   Online you mean when mounted ?
>=20
> Yep - I'm just not sure who would ever want to do that.
>=20
> Aren't labels primarly used for mounting, during the mount process?

Well if you want to change the label of your root filesystem, how else would
you go about that? If Btrfs did not support this, then only while booted fr=
om a
rescue LiveCD? That's quite a bit more involved and not even always feasible
in case of remote machines with no IPMI or similar management.

Extfs supports online change of the volume label as well, albeit probably n=
ot
via a sysfs file, but with the tune2fs utility:

  tune2fs -L <name> /dev/blockdevice

--=20
With respect,
Roman

--Sig_/jRjoUox6YD1/KPU0A.UVH7W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlN9eacACgkQTLKSvz+PZwh1lACfengaHCsfFGNgLYt8JHUcLtjm
oRQAoIzPeIH/wgZfQW4/gpy1U7cXE0yP
=DrpC
-----END PGP SIGNATURE-----

--Sig_/jRjoUox6YD1/KPU0A.UVH7W--
