From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: is space really freed after deleting large subvolume?
Date: Fri, 14 Oct 2011 11:12:29 -0600
Message-ID: <20111014171229.GA7528@untroubled.org>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
 <CAJ1PRSk0BVoYw89C0RYejbRF-4QdrKkA_J94Kf+Y7r-u=w+aHA@mail.gmail.com>
 <20111014084504.GI21931@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111014084504.GI21931@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2011 at 09:45:05AM +0100, Hugo Mills wrote:
>  Updating and checking the reference count is the thing
> that takes time, and can't really be short-circuited.

I'm curious if you know how ZFS does this.  My boss has used a set of
ZFS systems for backup, and indicates that deleting a snapshot is
instant, and free space is updated immediately with no apparent
background I/O.  I know ZFS only has read-only snapshots, but I would
think it would have some of the same reference counting challenges.

I see reading one of the ZFS presentations that it uses a "birth time"
in each block pointer.  This lets it optimizes the deletion by walking
only a partial set of the nodes.  Still, for any non-trivial deletion it
would have to walk enough nodes to keep the delete from being as quick
as is claimed.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJOmG19AAoJEFFRvcnBTTxnic8P/2S45H9mi7egxBB/NRVLZ2X/
xUEJs0gYueiQfw+SMohl+fSd9285/njL8m/JN1moLS7Mn6Nc1VUVehC7zxFHkL1+
1Be79H59hCu8aG3IoTjSjUsyjFD6iIhxnbdn73FXIr5tkHVzux6MQUisxA0x6TNV
BJnCHNQ/sJVzIs5XghRGk6tJEoZU51pp+VYL1fvzvAc/Zqk62nTYPrH2N2yCeQdF
GaCQyTAdUAqmsgw4Omxt2byFPrXv8wRl6zKN4oFwX1gokIwxpTWuEiCrrjkQ2vRU
xM7wRlu+OgTwkKjqd1x5LPD2L6azeZOWC/QJTPpcHjzpI5meCof1GVpnZAweMrm6
WKXYb9jvxkqJc6X7s6+E50alDQQdvxVfcEFDEyZp3zs821sOVRv6zqfkIK/mvFrp
q5oMgZLlYjqfOFt184z4W5V0sSg8j+0l20i8RgK6wVRkpurneyADPHDd05tPRHf3
U0aYPHUzbWdZzd9Aj8k4c2QXd0vWPNOm3h9VWtQTPmhCUQKZBTXF4n+bkNGIGfCq
VKeVAw4a/bAOs1U3I07Q2Z+HrSh9tH++64stZOB+XzXUaLckRHUXfZSdY9S7Y0bu
3G185FGrAXnXwlOQP3s+qrxojOVTFDUQEqHHyFCVXxRj6UVTrpDL7J2ntOHByFhB
rAkjuJgXJR9tEAFfRhly
=IkUo
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
