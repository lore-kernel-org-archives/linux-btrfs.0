Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:49408 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3IAVn4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 17:43:56 -0400
Received: by mail-we0-f177.google.com with SMTP id q55so3155827wes.36
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Sep 2013 14:43:55 -0700 (PDT)
Message-ID: <1378071827.5456.3.camel@pc-steven.LAN>
Subject: Re: Device delete returns "unable to go below four devices on
 raid10" on 5 drive setup
From: Steven Post <redalert.commander@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Sun, 01 Sep 2013 23:43:47 +0200
In-Reply-To: <1378037326.4694.13.camel@pc-steven.LAN>
References: <1377943975.5426.17.camel@pc-steven.LAN>
	 <A4758013-22BA-4552-B391-9492B42D85C5@colorremedies.com>
	 <1377993349.5004.38.camel@pc-steven.LAN>
	 <6E2BF7E8-C893-4B6D-9B50-27434BEABD78@colorremedies.com>
	 <1378037326.4694.13.camel@pc-steven.LAN>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cHNjKrB3QsQoKOKRn1wx"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-cHNjKrB3QsQoKOKRn1wx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-09-01 at 14:08 +0200, Steven Post wrote:
> On Sat, 2013-08-31 at 18:03 -0600, Chris Murphy wrote:
> > On Aug 31, 2013, at 5:55 PM, Steven Post <redalert.commander@gmail.com>=
 wrote:
> >=20
> > > On Sat, 2013-08-31 at 11:42 -0600, Chris Murphy wrote:
> > >>=20
> > >> Yes. It might take a few minutes after the chunks are reallocated fo=
r the device to be removed from the volume. I've had some cases where even =
a reboot was needed for the information in fi sh to refresh.
> > >=20
> > > I see, so that might be normal behaviour.
> >=20
> > No, I think it's expected for deleted devices to not appear in the volu=
me listing anymore, but with older kernels I had that experience. I haven't=
 tried it recently with newer kernels.
>=20
> I might have phrased that a bit incorrectly, with 'normal behaviour' I
> meant it was known to do that and not cause major problems. Of course I
> would expect the entry to just disappear.
> I'll let you know the result of the 'device delete' operation on the
> second machine (3.10.7 kernel).

The 3.10.7 kernel doesn't seem to have this issue, the removed device is
not listed anymore immediately after the 'device delete' command
returns. Although in that instance the array still had 6 drives, not 5
as with the old one.

[...]

Best regards,
Steven

--=-cHNjKrB3QsQoKOKRn1wx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJSI7UTAAoJEEvSpS1Vyfkxh3QIAIiaMpBc/U5jHYjQVfE524RF
kArhnYg1QN7RTUrq0iDVKQZyhu9+7Agb/TtTYb5jzJu+z2AhEXDjRc832c9FTGFV
ITGRI7FINAV4fc7dnkb9vqEu4EQA03FEDzTysBaHtakmRcQA9YXZJnnJOZ/JPYHD
yiZZlvEUl+j86hajjMCc+mpKTfGfBaTF8hgzl6cRX3zcWl0iQGnd1EsetVeSt0Eh
TRrXI5JmFz+Abgw7691hii3Ppt8F5nHKQmdcixfXrg6vNQ1Ft7A9ZIAIPB7gp/Y3
ad4pZbTKsRubyUuPppC8BSgYG5T/DAtXFgNq3Wm6ZI/NMp9R0WWhIIsBmBh+n6g=
=PheH
-----END PGP SIGNATURE-----

--=-cHNjKrB3QsQoKOKRn1wx--

