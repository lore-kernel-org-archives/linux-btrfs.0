From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Fri, 02 Mar 2012 06:50:41 -0500
Message-ID: <jiqc6i$e2$1@dough.gmane.org>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com> <20120226110044.GA18898@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBC7740FDCD39000EBA3CFD7E"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120226110044.GA18898@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBC7740FDCD39000EBA3CFD7E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-02-26 06:00 AM, Hugo Mills wrote:
>=20
>    The option that nobody's mentioned yet is to use mixed mode. This
> is the -M or --mixed option when you create the filesystem. It's
> designed specifically for small filesystems, and removes the
> data/metadata split for more efficient packing.

Cool.

>    As mentioned before, you probably need to upgrade to 3.2 or 3.3-rc5
> anyway. There were quite a few fixes in the ENOSPC/allocation area
> since then.

I've upgraded to the Ubuntu Precise kernel which looks to be 3.2.6 with
btrfs-tools 0.19+20100601-3ubuntu3 so that would look like a btrfs-progs
snapshot from 2010-06-01 and (unsurprisingly) I don't see the -M option
in mkfs.btrfs.

So I went digging and I just wanted to verify what I think I am seeing.

Looking at

http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dc=
ommit;h=3D67377734fd24c32cbdfeb697c2e2bd7fed519e75

it would appear that the mixed data+metadata code landed in the kernel
back in Sep, of 2010, is that correct?

And looking at

http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-progs.git;a=3Dcom=
mit;h=3Db8802ae3fa0c70d4cfc3287ed07479925973b0ac

the userspace support for this landed in Dec. of 2010, is that right?

If my archeology is correct, then I only need to update my btrfs-tools,
yes?  Is  2010-06-01 really the last time the tools were considered
stable or are Ubuntu just being conservative and/or lazy about updating?

Cheers,
b.


--------------enigBC7740FDCD39000EBA3CFD7E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9QtBIACgkQl3EQlGLyuXBWVACgk6dPyq8maq+LxD9xw4sOLfwI
wzkAnjQUN2myefxtM5b0VivEFrSfKBXd
=KaRm
-----END PGP SIGNATURE-----

--------------enigBC7740FDCD39000EBA3CFD7E--

