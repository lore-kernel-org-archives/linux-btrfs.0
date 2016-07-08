Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:37592 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbcGHLTU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 07:19:20 -0400
Subject: Re: kdave/for-next commit 26112f7f472
To: Jeff Mahoney <jeffm@suse.com>, David Sterba <DSterba@suse.com>,
        Josef Bacik <jbacik@fb.com>
References: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <577F8C2E.3@applied-asynchrony.com>
Date: Fri, 8 Jul 2016 13:19:10 +0200
MIME-Version: 1.0
In-Reply-To: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VmdmOva4eWJLeXgcHhragrw1gUoLfXbFv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VmdmOva4eWJLeXgcHhragrw1gUoLfXbFv
Content-Type: multipart/mixed; boundary="KHRjaVdslasoadQsM6LNNvcbSj7crfSq4"
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To: Jeff Mahoney <jeffm@suse.com>, David Sterba <DSterba@suse.com>,
 Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <577F8C2E.3@applied-asynchrony.com>
Subject: Re: kdave/for-next commit 26112f7f472
References: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
In-Reply-To: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>

--KHRjaVdslasoadQsM6LNNvcbSj7crfSq4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/08/16 06:24, Jeff Mahoney wrote:
> Hi Dave -
>=20
> This commit introduces a bug.  I ran across it when running xfstests
> against my own integrated branch.

I can't find that commit id anywhere...?

> The problem is that btrfs_calc_reclaim_metadata_size didn't used to be
> called from recovery, so it was safe to use fs_info->fs_root.  With
> commit 7c83c6a09 (Btrfs: don't bother kicking async if there's nothing
> to reclaim) we do call it from recovery context and fs_info->fs_root is=

> NULL.
>=20
> The fix is to just not switch btrfs_calc_reclaim_metadata_size to take
> an fs_info.  All the other call sites were using fs_info->fs_root
> anyway, so it's not like we're pinning a root somewhere just for this c=
all.

I've had this patch from last October in my 4.4.x tree forever:
http://www.spinics.net/lists/linux-btrfs/msg48457.html

Apparently it fell off the table. Shouldn't that fix it?

-h



--KHRjaVdslasoadQsM6LNNvcbSj7crfSq4--

--VmdmOva4eWJLeXgcHhragrw1gUoLfXbFv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iGUEARECACUFAld/jDUeHGhvbGdlckBhcHBsaWVkLWFzeW5jaHJvbnkuY29tAAoJ
EA+BNAnY3O7NkQ4An39QxaCYh0XnGTR19FzZvqo/E6BWAKCxqRwiKIfZjvV/t9cR
OWKjHeS3Cw==
=lP8p
-----END PGP SIGNATURE-----

--VmdmOva4eWJLeXgcHhragrw1gUoLfXbFv--
