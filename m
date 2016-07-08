Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbcGHEZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 00:25:05 -0400
To: David Sterba <DSterba@suse.com>, Josef Bacik <jbacik@fb.com>
From: Jeff Mahoney <jeffm@suse.com>
Subject: kdave/for-next commit 26112f7f472
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
Date: Fri, 8 Jul 2016 00:24:59 -0400
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Xb0IJvvdKxhtfSo8r2tslwoNLr120aWke"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Xb0IJvvdKxhtfSo8r2tslwoNLr120aWke
Content-Type: multipart/mixed; boundary="FQRObQhxnVbHJB0iUkdnUveC5caVfSimr"
From: Jeff Mahoney <jeffm@suse.com>
To: David Sterba <DSterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
Subject: kdave/for-next commit 26112f7f472

--FQRObQhxnVbHJB0iUkdnUveC5caVfSimr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Dave -

This commit introduces a bug.  I ran across it when running xfstests
against my own integrated branch.

The problem is that btrfs_calc_reclaim_metadata_size didn't used to be
called from recovery, so it was safe to use fs_info->fs_root.  With
commit 7c83c6a09 (Btrfs: don't bother kicking async if there's nothing
to reclaim) we do call it from recovery context and fs_info->fs_root is
NULL.

The fix is to just not switch btrfs_calc_reclaim_metadata_size to take
an fs_info.  All the other call sites were using fs_info->fs_root
anyway, so it's not like we're pinning a root somewhere just for this cal=
l.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--FQRObQhxnVbHJB0iUkdnUveC5caVfSimr--

--Xb0IJvvdKxhtfSo8r2tslwoNLr120aWke
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXfysbAAoJEB57S2MheeWyrNcQAKt37YAN3B/eOxTakrdM7S5d
0+TGkBgkK1P84nLubbEdjQdJcRxb2x8/jS2XKMSMzozP/A6ZhE5zu+c5fLgvvkSK
yWgv+rGY6/ketBlj9oISwNKfhpC9LZviSBi5osX95KRB8IaWg3q/hU/I20LTVgiz
RVA669LAsa+24t9LeaBL8hQlzq9LAk4ZxzkoOfwzlQbGqLnQO9hY1n6cFI9thi6A
8Uld/ENlhIUbiYhPZxC9cro1SCotGbwGM2qyZsHPOmZB8+Ni+82uzmBD/1xMTtrE
bykJ69z2nJzf7uBInNTqDWhdlqFI5RDIlLBiexmNdGykWGVQlYpgom5uxZHa8Iwb
iWrL7DC8b7X635I30ZLW3hqsXRVoeZBlCbfLfJzg6qklPb6Yjpu0TsL3EXcwTnSX
2yj6trzCX5tWsulKVeh0ivWhN8t463gkLOidWnzD7Cb/OIJVKUea5bcVtmB0W8t8
XV8/nDjBZNOZ4lc7OM+twul+xlu1ilQcFiNeSSsJwSs6qUmnpYRHnu9O48zPRsSu
ggzirXytZ2BAmp6t1/F+XWUwvhTYRqNovgZdNCLJJyz3xTRl6t4bxnPpUmigrGFO
5PmUXLkyNHE3J/Ej4SqoglA8/fNbMSbOr7jxvzlhLXQCnf/QBQSXAM3/S6Z9WTSU
ofZGpWP0Lrpa3TQhC1rs
=hA1A
-----END PGP SIGNATURE-----

--Xb0IJvvdKxhtfSo8r2tslwoNLr120aWke--
