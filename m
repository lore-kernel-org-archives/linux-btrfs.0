From: Sean Reifschneider <jafo@tummy.com>
Subject: Re: btrstress caused kernel oops after 8-ish days.
Date: Tue, 27 Apr 2010 19:30:51 -0600
Message-ID: <4BD78FCB.3050707@tummy.com>
References: <4BD6C712.6090202@tummy.com> <20100427114628.GC6513@think>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8176B01E60F2C2A5DAB4F7C8"
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100427114628.GC6513@think>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8176B01E60F2C2A5DAB4F7C8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/27/2010 05:46 AM, Chris Mason wrote:
> This oops is fixed in later kernels, and it's why things stopped.

Thanks for the reply.  I'm not sure I have the time to give this with
respect to following the trunk kernel right now.  If the btrfs project
doesn't have test machines that could be set up for longer-term testing o=
f
something like btrstress, let me know and I'll look at it when I have som=
e
more time in the future.

Thanks,
Sean
--=20
Sean Reifschneider, Member of Technical Staff <jafo@tummy.com>
tummy.com, ltd. - Linux Consulting since 1995: Ask me about High Availabi=
lity


--------------enig8176B01E60F2C2A5DAB4F7C8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iD8DBQFL14/LxUhyMYEjVX0RAk1uAJ9MDVXQU4UITJi1OoayQsx1SWNYvQCeMQ+s
kv55Wi0rKjsKagRhvgB5c3Y=
=GaUn
-----END PGP SIGNATURE-----

--------------enig8176B01E60F2C2A5DAB4F7C8--
