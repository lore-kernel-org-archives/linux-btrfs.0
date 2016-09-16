Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:33662 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757678AbcIPFrN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 01:47:13 -0400
Date: Fri, 16 Sep 2016 10:47:05 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Dave Chinner <david@fromorbit.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        clm@fb.com, dsterba@suse.cz
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160916104705.6e9b33e1@natsu>
In-Reply-To: <20160916011213.GV22388@dastard>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
        <20160916011213.GV22388@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/yRnvLsiXjHRoykpIiPbVQP."; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/yRnvLsiXjHRoykpIiPbVQP.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2016 11:12:13 +1000
Dave Chinner <david@fromorbit.com> wrote:

> > As of now these patch set supports encryption on per subvolume, as
> > managing properties on per subvolume is a kind of core to btrfs, which =
is
> > easier for data center solution-ing, seamlessly persistent and easy to
> > manage.
>=20
> We've got dmcrypt for this sort of transparent "device level"
> encryption. Do we really need another btrfs layer that re-implements
> generic, robust, widely deployed, stable functionality?

"Btrfs subvolume-level" is far from "device-level", subvolumes are so
lightweight and dynamic that they are akin to regular directories for most
intents and purposes, not devices or partitions.

And yes I'd say (effectively) a directory-level encryption in an FS can be
useful; for example encrypting /home, but not the rest of the filesystem, or
any other scenarios where only some of the stored data needs to be encrypte=
d,
and it's not known in advance what proportion, so it's not convenient to ha=
ve
any static partition or LVM based bounds.

Currently this can be achieved with tools like encfs or ecryptfs -- so it's
those you'd want to measure Btrfs encryption against, not dmcrypt.

--=20
With respect,
Roman

--Sig_/yRnvLsiXjHRoykpIiPbVQP.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfbh1wACgkQTLKSvz+PZwhAVgCeMJLeKN0fndIN+cUEYsW1olI4
BkQAnj57BwV6S3x0jCb/qVH7dAl7LcW/
=4Pal
-----END PGP SIGNATURE-----

--Sig_/yRnvLsiXjHRoykpIiPbVQP.--
