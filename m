Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44966 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3IAMJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 08:09:00 -0400
Received: by mail-wg0-f47.google.com with SMTP id f12so328622wgh.2
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Sep 2013 05:08:59 -0700 (PDT)
Message-ID: <1378037326.4694.13.camel@pc-steven.LAN>
Subject: Re: Device delete returns "unable to go below four devices on
 raid10" on 5 drive setup
From: Steven Post <redalert.commander@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Date: Sun, 01 Sep 2013 14:08:46 +0200
In-Reply-To: <6E2BF7E8-C893-4B6D-9B50-27434BEABD78@colorremedies.com>
References: <1377943975.5426.17.camel@pc-steven.LAN>
	 <A4758013-22BA-4552-B391-9492B42D85C5@colorremedies.com>
	 <1377993349.5004.38.camel@pc-steven.LAN>
	 <6E2BF7E8-C893-4B6D-9B50-27434BEABD78@colorremedies.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bbrPtBs/uTwRJT3Nxfpl"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-bbrPtBs/uTwRJT3Nxfpl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-08-31 at 18:03 -0600, Chris Murphy wrote:
> On Aug 31, 2013, at 5:55 PM, Steven Post <redalert.commander@gmail.com> w=
rote:
>=20
> > On Sat, 2013-08-31 at 11:42 -0600, Chris Murphy wrote:
> >>=20
> >> Yes. It might take a few minutes after the chunks are reallocated for =
the device to be removed from the volume. I've had some cases where even a =
reboot was needed for the information in fi sh to refresh.
> >=20
> > I see, so that might be normal behaviour.
>=20
> No, I think it's expected for deleted devices to not appear in the volume=
 listing anymore, but with older kernels I had that experience. I haven't t=
ried it recently with newer kernels.

I might have phrased that a bit incorrectly, with 'normal behaviour' I
meant it was known to do that and not cause major problems. Of course I
would expect the entry to just disappear.
I'll let you know the result of the 'device delete' operation on the
second machine (3.10.7 kernel).

Back on the 3.2 kernel, the "filesystem show" command still showed the
removed device, but still with less used space that the others after the
balance. Shutdown + physical removal + boot didn't produce any error,
since this array is used as the root filesystem I think I would have
noticed a serious problem by now. I successfully added the 1 TB drive to
the array (after partitioning).
So it seems it's just the output of the 'filesystem show' command that
is lagging behind, even after a reboot and a 20 hour idle period.

>=20
> >=20
> > As an aside, I'd rather not recreate the arrays if it can be done
> > without recreating.
>=20
> It should work. But it's an experimental file system. I'd at least make a=
 backup if you're going to do this with the device add/remove method.

Naturally, all important files have a backup, but for the rest of the
volume I can live with the fact that it would be lost. Also if every one
created a new filesystem instead of using device add/delete, this code
wouldn't get much testing ;)

Best regards,
Steven

--=-bbrPtBs/uTwRJT3Nxfpl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJSIy5OAAoJEEvSpS1VyfkxGfwH/3fGCpubLsmwh+DgCO9TMRVN
S1D8APL0iAq24/1/OTOtr4T2IXgcM4DuR7A2k+aHyDPrm/VxXbom9aBjANiqKUKx
DnDNDqcneOzrU6voQDXAc12T9gn42ZOHK4w6MYUSfa5PD0PHKppTkuoOlocrcEMN
KwprnyElDqnZK688deexiwksc/g7cNoNYamA0Is3VIfX9YdTEuTXWhSP0we3hn8f
rzmM9Vwfj2yGR8l1u4zvT/LqkMBqH/F8c/iF5SPWhQXJzmDy7sL/fMsJEH7imxxo
+uMn3Ks+q5asrmJy3VKbBij4kuy1nG8qitQ8I0KP53UupZnfai31NAfVNaAfIqU=
=dQRB
-----END PGP SIGNATURE-----

--=-bbrPtBs/uTwRJT3Nxfpl--

