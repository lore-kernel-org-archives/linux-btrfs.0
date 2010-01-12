From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Re: snapshot/subvolume removal
Date: Tue, 12 Jan 2010 10:12:46 +0100
Message-ID: <201001121012.52665@fortytwo.ch>
References: <4B43AC9B.5030109@cs.bgu.ac.il> <4B4BC6D2.6030906@jp.fujitsu.com> <4B4C1FEA.70109@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2569590.3k3qMkPACN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
	linux-btrfs@vger.kernel.org
To: Piavlo <piavka@cs.bgu.ac.il>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4C1FEA.70109@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2569590.3k3qMkPACN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tuesday 12 January 2010 08.08:26 Piavlo wrote:
> Maintaining snapshot hierarchy by  external application is not reliable
> and error prone
> compared to maintaining it withing the btrfs itself,
> probably by adding the parent treeid field for every  shapshot/subvolume.

What should, in your opinion, happen if the parent snapshot is deleted? =20
Orphan? Re-parent to parent of parent?  I guess depending on application,=20
there may be more than one "right" solution.

cheers
=2D- vbi

=2D-=20
When Al sends me patches, I apply them.
I worry what would happen if I didn't.
        -- Linus Torvalds

--nextPart2569590.3k3qMkPACN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAktMPQ5gGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6bOkAoJfqzgx2NtndGLKX7Mmhq+z6
nSeAAJ4uF0enrSAPCLYaA/vbv82SgLWstw==
=hOJI
-----END PGP SIGNATURE-----

--nextPart2569590.3k3qMkPACN--
