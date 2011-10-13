From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: is space really freed after deleting large subvolume?
Date: Thu, 13 Oct 2011 22:29:44 +0600
Message-ID: <20111013222944.16efb3f3@natsu>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/C=mYzFShFA8vpUssd=s4hUn"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/C=mYzFShFA8vpUssd=s4hUn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Oct 2011 18:14:03 +0200
"krzf83@gmail.com " <krzf83@gmail.com> wrote:

> I'm wondering is space really freed after deleting large subvolume?
> Will space be immediately available to other data like other
> subvolumes?

Currently there seems to be no way to ensure it is instantly available, or =
to be precise, the only way to get that is to unmount the FS and mount it a=
gain. Not sync, not "btrfs fi sync" ensure that all cleanup is complete bef=
ore they return. Only umount does, and it can take a very long time if you =
have deleted a large (differing a lot) subvolume just before that.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/C=mYzFShFA8vpUssd=s4hUn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6XEfgACgkQTLKSvz+PZwhSvQCdHyTwdYYzkYX6P23o/0FbRF68
/TUAn3BqQul8W7MIg9+J45eqCM8vDIcd
=l3GW
-----END PGP SIGNATURE-----

--Sig_/C=mYzFShFA8vpUssd=s4hUn--
