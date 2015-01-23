Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50482 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbbAWHzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 02:55:17 -0500
Received: from marcec.fritz.box ([93.181.44.4]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0Ltqb7-1XX9IV3SEf-011Cqs for
 <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 08:55:14 +0100
Date: Fri, 23 Jan 2015 08:54:41 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs convert running out of space
Message-ID: <20150123085441.79265c9a@marcec.fritz.box>
In-Reply-To: <pan$92dfe$2be12b41$73cefff0$d3e7dbcf@cox.net>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
	<CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
	<CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
	<CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
	<CA+WRLO89nFArYhRgjqPBruW0avExOZcf9iZgvusLAr_+4ddxoQ@mail.gmail.com>
	<CAJCQCtTiboWRVkZLE2Te9Kb00SXxUk0_AwE5xv-vTHxrpaDCqA@mail.gmail.com>
	<CA+WRLO-oUUQhfJ_LnwaQmr_-sJK_oTCE89R11N3kM-vj-Gv6Wg@mail.gmail.com>
	<CAJCQCtRZy3Pi5CF4a9CfQSzmFm9poumJhBZaSRixRrpqsBPk_g@mail.gmail.com>
	<CA+WRLO_Yu6nqkhVP6YyxwvrzK8LCtSUMB7XL_ki0+LJiZHkS8w@mail.gmail.com>
	<pan$92dfe$2be12b41$73cefff0$d3e7dbcf@cox.net>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Poeh8c.Ce/zN/JvzixkQyQJ"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Poeh8c.Ce/zN/JvzixkQyQJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Fri, 23 Jan 2015 04:34:19 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Gareth Pye posted on Fri, 23 Jan 2015 08:58:08 +1100 as excerpted:
>=20
> > What are the chances that splitting all the large files up into sub gig
> > pieces, finish convert, then recombine them all will work?
>=20
[...]
> Option 2: Since new files should be created using the desired target mode=
=20
> (raid1 IIRC), you may actually be able to move them off and immediately=20
> back on, so they appear as new files and thus get created in the desired=
=20
> mode.  Of course the success here depends on how many you have to move=20
> vs. the amount of free space available that will be used when you do so,=
=20
> but with enough space, it should "just work".
>
> Note that with this method, if the files are small enough to entirely fit=
=20
> one-at-a-time or a-few-at-a-time in memory (I have 16 gig RAM, for=20
> instance, and don't tend to use more than a gig or two for apps, so could=
=20
> in theory do 12-14 gig at a time for this), you can even use a tmpfs as=20
> the temporary storage before moving them back to the target filesystem. =
=20
> That should be pretty fast since the one side is all memory.

With current coreutils, wouldn't that also work if he moves the files to
another (temporary) subvolume? (And with future coreutils, by copying the f=
iles
without using reflinks and then removing the originals.)

[...]
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/Poeh8c.Ce/zN/JvzixkQyQJ
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUwf5hAAoJEL/Q5oYsiHj0akgP/1nHYRmp20zC0YJrHxKlO9sp
pLMhDwpMD/mbi7/0f2w3C97xCHGtXx3PolRa220glwwwx8woQd8AofnJWLaUbw75
ssNkoNpKn1V4A7Hikp5NYFiH/qJvjmQByoif13lrENB84JbBVymlXsJ4Kvq6jkQw
f+dddJ4y2xQQj5Eoh02sXJBd4jSWJkL+VBzNYHbJBIw2JLAtXTc+ri+Pq0pXcgQ5
dmArNatGuHlCLy/hz9ztmAgmW38LJ/Vmm7Dx6ALIMHpHO2sP1d+HQoS417yKa5B5
9NHFy+CFNhq7hqaBOlAOkG9JysT6sN9Z1njSCXW/B7HB7MexFL5tFiz39/vOj732
a9YZwcY2ARiXkVeqFYOuk9zJlwSHdDrBapl2hsySga2G3SeKIhSprgde05kfIVSd
grHWKPZJ2WFVod2VrAfXykDnUlX8/J/lE/PrFjWks3TAJoFYZU6FZQ5yfmstkDJX
656hFO2G5jc+Jg27/f2ZuTOMCVrIczB4jw2TBAlBRPRtVUPglXEtbCOwsNRH7kVl
RtVGpB4N5T5wxs+u4rIjJkYDdzArNoECjiEHm8HzZPOmVJ7UcGfGGhthodbZppCX
ZXSSTh7N7dRbl8tgt5oKGeFc8JJur5G+MWf/jsp9A/W4b5DMu1+iALLpxKSG3XPl
FW6+9wFfCtLYrRxqmyu8
=PlNt
-----END PGP SIGNATURE-----

--Sig_/Poeh8c.Ce/zN/JvzixkQyQJ--
