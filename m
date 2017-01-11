Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33253 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdAKUfN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 15:35:13 -0500
Received: by mail-it0-f65.google.com with SMTP id c20so342079itb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 12:35:12 -0800 (PST)
Subject: Re: [LSF/MM TOPIC] sharing pages between mappings
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_24F3C8FA-2453-4243-89D1-AB7658AA1EF6"; protocol="application/pgp-signature"; micalg=pgp-sha256
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CAJfpegv9EhT4Y3QjTZBHoMKSiVGtfmTGPhJp_rh3a7=rFCHu5A@mail.gmail.com>
Date: Wed, 11 Jan 2017 13:35:02 -0700
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Message-Id: <F2092AFE-A2C8-438E-A8AA-4D74509344F5@dilger.ca>
References: <CAJfpegv9EhT4Y3QjTZBHoMKSiVGtfmTGPhJp_rh3a7=rFCHu5A@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_24F3C8FA-2453-4243-89D1-AB7658AA1EF6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 11, 2017, at 3:29 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>=20
> I know there's work on this for xfs, but could this be done in generic =
mm code?
>=20
> What are the obstacles?  page->mapping and page->index are the obvious =
ones.
>=20
> If that's too difficult is it maybe enough to share mappings between
> files while they are completely identical and clone the mapping when
> necessary?
>=20
> All COW filesystems would benefit, as well as layered ones: lots of
> fuse fs, and in some cases overlayfs too.

For layered filesystems it would also be useful to have an API to move
pages between mappings easily.

> Related:  what can DAX do in the presence of cloned block?
>=20
> Thanks,
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_24F3C8FA-2453-4243-89D1-AB7658AA1EF6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWHaW+nKl2rkXzB/gAQjc7w//a18EVoNWjZcRbvDR7W+hTNBjQcM4gkpZ
8sh3xLTjApmxTp6CLpp1EdEGqHemyvuPlweFR/Yc5kKnqhHV7pP2PkRuUf42M2bd
KGZ6DSD1z+hjdLJ9/gAotWEWUOlU9ou4UyEeHsRrv+upZv65/DrXsvkLfZr9Ych4
yDCtPWI1AT47p3S7huGTAnsK+XJLfGsDVfwEuTp7QbJ1k/NsrVDNBAoV6ikhjKnr
a9KfMCKrRnvb6HRVy/PaOZfUWF7JhRRSCxiTBxBSbwaQRXIjRQ0H/J5EaRalruQ9
Y5dPsL80pe1tM9cDj1nyAFfgqHWJOKgdTN9cS8wH3/2OUwB3gyZyqrkMgqsRLW4q
wztLpwO65Z+rdmp4k13EB0UuxNHg2wh3hX991aD+wztahN/dhfxeqAE7sCttO9tC
S+6rj/9twfyUdOjpLxu31chowUgcNKMZespczTMLz0yIe6NFS7WI1vAfNFxtmhvn
1D6f51F4bpEAtih9PzoxL3rN+qmENW+TO6LFpgTYhSw5iXy8QmfyS4Iz6DGfec+8
NpuWZ8mp+Ak+NVTDH450T4yblKq9/3MCIXlPnHeethrYYwZrYvN5Q28Znfc5zNlQ
KXOjP9pzgwOzjq1Rp0Uv1MWv4pbvTFgTA4Zimejx64mGU3PTRX7Noe4UdCvdV5mB
OA/ov38SKWE=
=EwIV
-----END PGP SIGNATURE-----

--Apple-Mail=_24F3C8FA-2453-4243-89D1-AB7658AA1EF6--
