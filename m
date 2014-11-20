Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51702 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaKTMFO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 07:05:14 -0500
Received: from marcec.fritz.box ([93.181.44.4]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MPqtK-1XwMQX2TJK-0052Lu for
 <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 13:05:11 +0100
Date: Thu, 20 Nov 2014 13:05:03 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send and an existing backup
Message-ID: <20141120130503.79855780@marcec.fritz.box>
In-Reply-To: <o9rujb-sud.ln1@venus.xundeenergie.ssh22.net>
References: <o9rujb-sud.ln1@venus.xundeenergie.ssh22.net>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6YEQKHlAp8odYteagr6T173"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/6YEQKHlAp8odYteagr6T173
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am Wed, 19 Nov 2014 16:58:16 +0100
schrieb Jakob Sch=C3=BCrz <wertstoffe@nurfuerspam.de>:

> Hi there!
>=20
> I'm new on btrfs, and I like it :)

Me too :) . (I've been using it since May.)

> But i have a question. I have a existing backup on an external HDD. This=
=20
> was ext4 before i converted it to btrfs.
> And i installed my debian new on btrfs with some subvolumes. (f.e. home,=
=20
> var, multimedia/Video multimedia/Audio...)
>=20
> On my backup there are no subvolumes.
>=20
> Now i wrote a script to take local snapshots on my laptops HDD an mirror=
=20
> this snapshots with btrfs send/receive to the external HDD.

Yeah, I also recently made the switch to btrfs send/receive, and I just love
being able to do incremental full system backups in less than two minutes (=
it's
also efficient enough that I backup my (borrowed) laptop over WLAN).

So from me a big thanks to the btrfs devs :) !

But to get to the questions:

> An i don't know, how to do, to make the inital snapshot on the external=20
> HDD. I want to use the existing data there, so I don't have to transmit=20
> the whole bunch of data to the external drive, which exists there=20
> already...

Yeah, I had that problem, too, with my old rsync based backups; see below.

> What happens, if i make the same structure on the external drive with=20
> creating subvolumes and =C2=BBcp --reflink=C2=AB, give this subvolumes th=
e correct=20
> names, and fire a =C2=BBbtrfs send=C2=AB?

Do you mean cp --reflink from the original backup to the new structure? That
won't help.  Again, see below.

> Or is the best (ONLY???) way, to make an initial snapshot on the=20
> external drive and delete the old backup there?

I couldn't think of any other way than doing an initial snapshot + send that
transferred the entire subvolumes, then doing incremental sends from there.

Here's my understanding as a complete non-expert:

The problem is that you need a parent snapshot, which needs to be on *both*=
 the
source *and* target volumes, with which to be able to generate and then rec=
eive
the incremental send.  Currently, your source and target volumes are
independent, so btrfs can't infer anything about any differences between th=
em;
that is, while the data may be related, the file systems themselves have
independent "histories", making it impossible to compare them via their data
structures.

This is why you need to make an initial send: to give both volumes a common
frame of reference, so to speak.

So I bit the bullet and went through with it, and am keeping the original
backups until enough snapshots have accumulated in the new backup location
(both of my backups are on the same file system in different subvolumes).

> greetings
> jakob

HTH
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/6YEQKHlAp8odYteagr6T173
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUbdj2AAoJEL/Q5oYsiHj0fG8P/0hqI6PF4vEo4TVVoS9JAKeX
Sq992ZfkLKmpTk8VeX3PYzIv0JwQSWnQ+Xkl9DCrp6htLQw3/f6uAKY/he0U4hXi
HzXhdXAyZA3YRTpRQ2jP2IEtUqd/MPs4GfpChXZIebUr0k5womALVx3OSj3ABpT3
lGqMpPA7gd4OUuLJPzleYvcjD4NyxpD76xVx6DL1AeQCxYP5R8bJy86tX/re4/Af
VJ7TYdZ1a3dBBamYQCiJ0kNvqhPNggKI6APWI2Zjt7SB066K6eMwSJkoMJPManMl
mAVzpR9syFU3iBd8+OqDl8XpmG2+XAXprDxWM8VzTOR14AStwB+Op8cB/LLPoLYT
MQ+XShKcaj+akz6oFsJAsR2r/+cm/ZzjPrtbOCT0I9stBMq0H3Idi1dUDVSIiqHw
pVs7l/ii2PJJgFJwDuypVd931PuNhv5HVTzmSje8ZLRrWpvOTZQ0PYFwF+i1xzxW
8sDmf66jos6VRzn4nDmFRrkYw5n6cJDV3qnnkJIRA3hNVkhYZmjnuEr0iIMaEKPL
5vllDJUtuJGLdOmoHvMmqSFbVJirzFnjVZpHzktZ87dkUtM7gBwGfo3EWUaWEonQ
lv1j7elMMTYiXA+tqnkoHVI9Jm004qqpGCtXtblLhVNVpilRS+Yh7/sZTjEROkgA
4vIIBqLJv87KYrRj5cWh
=Zwxd
-----END PGP SIGNATURE-----

--Sig_/6YEQKHlAp8odYteagr6T173--
