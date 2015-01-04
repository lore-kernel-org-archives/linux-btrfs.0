Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48392 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbbADDyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 22:54:09 -0500
Date: Sun, 4 Jan 2015 03:54:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: I need to P. are we almost there yet?
Message-ID: <20150104035406.GC32182@carfax.org.uk>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
 <54A7D3D1.10508@shiftmail.org>
 <pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
 <CAAe=sHXzrAoFr9wPUk49F5kV6knpWM7PtdxfNWBRXvpU0b+PgQ@mail.gmail.com>
 <pan$1d2cd$b8c74fee$d1b247b8$e5de75c@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
In-Reply-To: <pan$1d2cd$b8c74fee$d1b247b8$e5de75c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 04, 2015 at 03:22:53AM +0000, Duncan wrote:
> sys.syphus posted on Sat, 03 Jan 2015 12:55:27 -0600 as excerpted:
> 
> >> But btrfs raid56 mode should be complete with kernel 3.19 and
> >> presumably btrfs-progs 3.19 tho I'd give it a kernel or two to mature
> >> to be sure. N-way-mirroring (my particular hotly awaited feature) is
> >> next up, but given the time raid56 took, I don't think anybody's
> >> predicting when it'll be actually in-tree and ready for use.
> >>
> >>
> > is that the feature where you say i want x copies of this file and y
> > copies of this other file? e.g. raid at the file level, with the ability
> > to adjust redundancy by file?
> 
> Per-file isn't available yet, tho at least per-subvolume is roadmapped, 
> and now that we have the properties framework working via xattr for files 
> as well, at least in theory, there is AFAIK no reason to limit it to per-
> subvolume, as per-file should be about as easy once the code that 
> currently limits it to per-filesystem is rewritten.

   "roadmapped" --> "fond wish".

   Also, per-file is a bit bloody awkward to get working. Having sat
and thought about it hard for a while, I'm not convinced that it would
actually be worth the implementation effort.

   Certainly, nobody should be thinking about having (say) a different
RAID config for every file -- that way lies madness. I would expect,
at most, "small integers" (<=3) of different profiles for data in any
given filesystem, with the majority of data being of one particular
profile. Anything trying to get more spohisticated than that is likely
asking for intractable space-allocation problems. Think, "requiring
regular full-balance operations".

   The behaviour of the chunk allocator in the presence of merely two
allocation profiles (data/metadata) is awkward enough. Introducing
more of them is something that will require a separate research
programme to understand fully.

   I will probably have an opportunity to discuss the basics of
multiple allocations schemes with someone more qualified than I am on
Tuesday, but I doubt that we'll reach any firm conclusion for many
months at best (if ever). The formal maths involved gets quite nasty,
quite quickly.

   Hugo.

> But actually fully working per-filesystem raid56 is enough for a lot of 
> people, and actually working per-filesystem N-way-mirroring is what I'm 
> after, since I already setup multiple filesystems in ordered to keep my 
> data eggs from all being in the same filesystem basket.
> 

-- 
Hugo Mills             | If it's December 1941 in Casablanca, what time is it
hugo@... carfax.org.uk | in New York?
http://carfax.org.uk/  |
PGP: 65E74AC0          |                               Rick Blaine, Casablanca

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUqLleAAoJEFheFHXiqx3kSjUP+wdCDi6V1VySQEdk3sDVT6rJ
WoOM/CZpJYMt8wSaIlXPSQNeRBmfRzueG7rMHwIl+5JE3swe3dcXZi9mNU4sOF0q
NOl1NUaBY4d2HmvZTX65Msq6kd7HF0ifIkR+VhYoZPTd/qDU7LvfQvfbuN9VoTFi
Bc2fjKKpw25ZaV0+h8t9gaxQM5U6A4WwLGFI/NqKE5CQvE9DPdxwRjMtj/Ut7Sqg
IShviHhJL/q+srIYytfAx7AVS+9ZA/P7dHOOr6zF1ApVs7uV2qd/BjWQaAyCJ+/S
lx3yoceeU44WaAavafg4uG16sxR7NS9icLBW5FSc+OcqGQ4WThbOi1iWmFidtfRW
U+b4VsnV1UsCu7tdIljTW7FOS7DVMYOxUqPcpgNJv1DPua5gw3TrMrrjKQV4g6xi
O/uLLb5+QTOjYwjbvZT/2kAvdNGcSengsNjXZT7sPtREVwtws+VIiHEqEXbcZdBF
afdXFQuGD0cvASdPDReFefkuc7Vjci7E1idFbsD4HpaJ5UHe3WdVKs01DGL95jZ8
IdCFlHLEAIv0h2IWR8x2Xvtj8gYY/ocoAxXTZbtJxmXKAICWtCBlv165qItxhVt2
/u4SAqyO9hVbjMoR+bR9ecVoObKGs4tXM/bnPQqEqO7AGBluvX9Z52uTsoVO5v6T
VjxFNHLAbvXHY0dVadV4
=MbHX
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
