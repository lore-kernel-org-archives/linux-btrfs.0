Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65054 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbbAYPXx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Jan 2015 10:23:53 -0500
Received: from marcec.fritz.box ([93.181.44.4]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MD9q8-1YTkWh0kEW-00GUz6 for
 <linux-btrfs@vger.kernel.org>; Sun, 25 Jan 2015 16:23:51 +0100
Date: Sun, 25 Jan 2015 16:23:44 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs convert running out of space
Message-ID: <20150125162344.299c3661@marcec.fritz.box>
In-Reply-To: <pan$40d11$63f07406$84874b72$fbf45436@cox.net>
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
 <20150123085441.79265c9a@marcec.fritz.box>
 <pan$40d11$63f07406$84874b72$fbf45436@cox.net>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/LCvI0cHcS2R4oRnabVTJeBh"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LCvI0cHcS2R4oRnabVTJeBh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Fri, 23 Jan 2015 08:46:23 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Marc Joliet posted on Fri, 23 Jan 2015 08:54:41 +0100 as excerpted:
>=20
> > Am Fri, 23 Jan 2015 04:34:19 +0000 (UTC)
> > schrieb Duncan <1i5t5.duncan@cox.net>:
> >=20
> >> Gareth Pye posted on Fri, 23 Jan 2015 08:58:08 +1100 as excerpted:
> >>=20
> >> > What are the chances that splitting all the large files up into sub
> >> > gig pieces, finish convert, then recombine them all will work?
> >>=20
> > [...]
> >> Option 2: Since new files should be created using the desired target
> >> mode (raid1 IIRC), you may actually be able to move them off and
> >> immediately back on, so they appear as new files and thus get created
> >> in the desired mode.
> >=20
> > With current coreutils, wouldn't that also work if he moves the files to
> > another (temporary) subvolume? (And with future coreutils, by copying
> > the files without using reflinks and then removing the originals.)
>=20
> If done correctly, yes.
>=20
> However, "off the filesystem" is far simpler to explain over email or the=
=20
> like, and is much less ambiguous in terms of "OK, but did you do it=20
> 'correctly'" if it doesn't end up helping.  If it doesn't work, it=20
> doesn't work.  If "move to a different subvolume under specific=20
> conditions in terms of reflinking and the like" doesn't work, there's=20
> always the question of whether it /really/ didn't work, or if somehow the=
=20
> instructions weren't clear enough and thus failure was simply the result=
=20
> of a failure to fully meet the technical requirements.
>=20
> Of course if I was doing it myself, and if I was absolutely sure of the=20
> technical details in terms of what command I had to use to be /sure/ it=20
> didn't simply reflink and thus defeat the whole exercise, I'd likely use=
=20
> the shortcut.  But in reality, if it didn't work I'd be second-guessing=20
> myself and would probably move everything entirely off and back on to be=
=20
> sure, and knowing that, I'd probably do it the /sure/ way in the first=20
> place, avoiding the chance of having to redo it to prove to myself that=20
> I'd done it correctly.
>=20
> Of course, having demonstrated to myself that it worked, if I ever had=20
> the problem again, I might try the shortcut, just to demonstrate to my=20
> own satisfaction the full theory that the effect of the shortcut was the=
=20
> same as the effect of doing it the longer and more fool-proof way.  But=20
> of course I'd rather not have the opportunity to try that second-half=20
> proof. =3D:^)
>=20
> Make sense? =3D:^)

I was going to argue that my suggestion was hardly difficult to get right, =
but
then I read that cp defaults to --reflink=3Dalways and that it is not possi=
ble to
turn off reflinks (i.e., there is no --reflink=3Dnever).

So then would have to consider alternatives like dd, and, well, you are rig=
ht,
I suppose :) .

(Of course, with the *current* version of coreutils, the simple "mv somefile
tmp_subvol/; mv tmp_subvol/somefile ." will still work.)

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/LCvI0cHcS2R4oRnabVTJeBh
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxQqFAAoJEL/Q5oYsiHj0k10QAJnJyJQhckkqOut6AuYpFIUj
exGNX99PUcb4cYOcNW9uD9LJHHTqPAb/bbhM5cSHUM9g1X1ySTXegPgKpPiNLr5L
FwE7XwuuXnBpmhX7Nsxwor3cfYD2CNjRlS9gBuKsVQHRQsqr//91tZlsJgYeX2MJ
EQBEdkVOFB/RsQ6LDeG3DJV7sF3+5RcCzGk+nDNhwJn4djMgyAaYlUtWGFc70rhG
n5PwIGYbgkFKqu/f2vKMACPdlGYfiK8ADo0iE/JKWslWQpgk2dNPT2mdOTp6UW8J
HVSBWhlqmYVSOOL/XNey6GGKvgakJbQKsk7ah+cVtNlu5cwbTwY1rkJpvJdt1ymT
Cs6u7Mh4bErGwt/HmhHZEXVU7JoEy93wqjdf0GB7zbqJ0PL8pZH/cNvZN1DOxS/Q
FxpZY/po4qUCsTzNHhur4nnC9G5kqnxnnecUyYV7pJN5sWqHo6VmCNt3UpBXkP08
7vxXF7hp6SH/S58uhwciaot8RgUNY59tUlhI7KdkQFCdofkzw8WxBJqKQkr0v0Er
Zy2cqAMJTm0Ot3Yu4v1GRKX9a3MQ/nT6+nAQsKT6SIJE+OVUEMIwpVlX+MmKYz8w
z/fNkbFKr6KyUZmCEo1b5vBp4vY1F7XprWlDI0xzGJFwBSgfXflZzp7Ma5KZ+c/1
5B3ceGXP4HlR/Zc6+Y7J
=NsP3
-----END PGP SIGNATURE-----

--Sig_/LCvI0cHcS2R4oRnabVTJeBh--
