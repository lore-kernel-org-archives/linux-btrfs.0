From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sat, 25 Feb 2012 22:57:17 -0500
Message-ID: <jicait$grq$1@dough.gmane.org>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com> <jic4m8$j6g$1@dough.gmane.org> <4F499AE4.80908@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig79D12DE75B9633C0E60FD3CE"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F499AE4.80908@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig79D12DE75B9633C0E60FD3CE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-02-25 09:37 PM, Fahrzin Hemmati wrote:
>
> Nope, still in heavy development, though you should upgrade to 3.2.

I recall being told I should upgrade to 2.6.36 (or was it .37 or .38) at
one time.  Seems like one should always upgrade.  :-/

> Also, the devs mentioned in several places it's not friendly to small
> drives, and I'm pretty sure 5GB is considered tiny.

But it won't ever get taken serious if it can't be used on "regular"
filesystems.  I shouldn't have to allocate an 80G filesystem for 3G of
data just so that the filesystem isn't "tiny".

> I don't think you need to separate /usr out to it's own disk. You could=

> instead create a single drive with multiple subvolumes for /, /var,
> /usr, etc.

The point is to separate filesystems which can easily fill with
application data growth from filesystems that can have more fatal
effects by being filled.

That said, I don't think having /var as a subvolume in the same pool as
/ and /usr achieves that usage isolation, does it?  Isn't /var still
allowed to consume all of the space that it, / and /usr share with them
all being subvolumes in the same pool?

> When you have Ubuntu use btrfs for /, it creates @ and @home
> for / and /home, respectively,

Yes, I had noticed that.  I also didn't immediately see anything that
prevents /home from filling / as I describe above.

Cheers,
b.


--------------enig79D12DE75B9633C0E60FD3CE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9JrZ0ACgkQl3EQlGLyuXCpCACffAThAeipf7rPfu818bLIu2AR
iYoAnibexcxyzJOArRyR1GPZkReD2idg
=ioVN
-----END PGP SIGNATURE-----

--------------enig79D12DE75B9633C0E60FD3CE--

