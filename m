Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:38007 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbaESRTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 13:19:34 -0400
Date: Mon, 19 May 2014 23:19:26 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: label should not contain return char
Message-ID: <20140519231926.34e8942c@natsu>
In-Reply-To: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hWtf2OBsrKCtSr+lul4uvjB"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/hWtf2OBsrKCtSr+lul4uvjB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 May 2014 01:04:30 +0800
Anand Jain <anand.jain@oracle.com> wrote:

> From: Anand Jain <Anand.Jain@oracle.com>
>=20
> generally if you use
>   echo "test" > /sys/fs/btrfs/<fsid>/label
> it would introduce return char at the end and it can not
> be part of the label. The correct command is
>   echo -n "test" > /sys/fs/btrfs/<fsid>/label
>=20
> This patch will check for this user error

Maybe instead consider checking for one trailing "\n", and silently remove =
it
if passed, so that both of the mentioned variants of 'echo' can be used?

All other sysfs files do not care if you pass an extra "\n" at the end, e.g.

  echo cfq > /sys/block/sda/queue/scheduler =20

works fine, doesn't require you to use "echo -n cfq".

--=20
With respect,
Roman

--Sig_/hWtf2OBsrKCtSr+lul4uvjB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlN6PR4ACgkQTLKSvz+PZwiFygCeKcIrJE7MxyWnbKUe6OsOPM8T
a/QAn2WW9SZuX1HfzZjdOr9uKP2ADMHP
=GuJt
-----END PGP SIGNATURE-----

--Sig_/hWtf2OBsrKCtSr+lul4uvjB--
