Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from s17634251.onlinehome-server.info ([87.106.5.14]:47106 "EHLO
        s17634251.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750912AbdIUKHt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 06:07:49 -0400
From: =?ISO-8859-1?Q?Sen=E9n?= Vidal Blanco <senenvidal@sgisoft.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Storage and snapshots as historical yearly
Date: Thu, 21 Sep 2017 12:07:34 +0200
Message-ID: <1889534.fjZkzSksZ3@pcsenen>
In-Reply-To: <d83f3017-ded3-fabf-856c-95e6d71747e2@gmail.com>
References: <9208764.SjP1vfhOIA@pcsenen> <2457840.3HpkerP4PG@pcsenen>
 <d83f3017-ded3-fabf-856c-95e6d71747e2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1943037.QtkT9aZUbU";
 micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1943037.QtkT9aZUbU
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

El martes, 19 de septiembre de 2017 21:33:31 (CEST) Andrei Borzenkov escrib=
i=C3=B3:
> 19.09.2017 14:49, Sen=C3=A9n Vidal Blanco =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Perfect!! Just what I was looking for.
> > Sorry for the delay, because before doing so, I preferred to test to see
> > if it actually worked.
> >=20
> > I have a doubt. The system works perfectly, but at the time of deleting
> > the
> > writing disk and merging the data on the read-only disk I fail to
> > understand the process.
> >=20
> > I have tried to remove the seed bit on disk A and delete the write B as
> > you
> > mention, and so move the data to A, but tells me that disk B does not
> > exist. These are the orders I have made:
> >=20
> > md127-> A
> > md126-> B
> >=20
> > btrfstune -S 0 /dev /md127
> > mount /dev/md127 /mnt (I mount this disk since the md126 gives error)
> > btrfs device delete /dev/md126 /mnt
> > ERROR: error removing device '/dev/md126': No such file or directory
> >=20
> > Another thing I've tried is to remove disk B without removing the seed
> > bit,
> > but it gives me the error:
> >=20
> > ERROR: error removing device '/dev/md126': unable to remove the only
> > writeable device.
> >=20
> > Any ideas about it?
>=20
> Yes, sorry about it. Clearing seed flag on device invalidates
> filesystem. What you can do, is to rotate devices. I.e. remove
> /dev/md126, set seed flag on md127 and add md126 back.
>=20
> I actually tested it and it works for me.
>=20

OK thanks

Now I see how it works :))

With the commands:
mount /dev/md126 /mnt
btrfs device remove /dev/md127 /mnt
We remove the read-only array (A) from the BTRFS system and in doing so pas=
s=20
all the information from (A) to (B) read-write to mix them.

=46rom what I see is not bad since both (A) and (B) are still operational. =
(A)=20
with last year and (B) with everything current.

=46inally with this other commands:
btrfstune -S 1 /dev/md126
mount /dev/md126 /mnt
btrfs device add -f /dev/md127 /mnt
we activate the seed bit in md126 (B) and add the (A) in read-write mode,=20
where the new files will be archived and (B) as store until the following y=
ear=20
and (A) do clean to fill in it new data.

I have tried to rotate twice to see if it goes well and smoothly.

Just comment that I see two small problems to this:

1. The transfer of data from (A) to (B) when removing the read-only disk ta=
kes=20
quite a while and more the more it has stored in the history. It would be n=
ice=20
if the process were reversed, since in (B) there are fewer "data" stored.=20
Also, I could not use it monthly or daily for this reason.

2. My idea was to have a larger A-disk than B where I would save the=20
historical ones, because so in B I could put a smaller disk and something=20
faster. If the decoupling process outside read-write rather than read-only =
and=20
passed the data to A would be ideal for this case.

On the other hand, as an anecdote only, and perhaps for lack of experience =
or=20
knowledge, I have used the entire linux system in BTRFS (@ and @home) forma=
t=20
and a single partition md126 to have the system bootable and running simply=
 by=20
attaching the disk to the computer in degraded mode (swap outside the raid =
,=20
which I'm not so bad: P). This has made that by rotating disks A and B I ha=
ve=20
had some problems with grub and fstab at boot, which I had to overcome by=20
making changes to the boot configurations and some more botches.

I'm going to see a couple more things and if there's any way I can combine=
=20
this with snapshots and see if the bulb will light up. If I do not get it I=
=20
will try with the other filesystems that you have suggested to me. Although=
=20
honestly, I like BTRFS more than the other alternatives, I already use BTRF=
S=20
on 5 computers and it goes very well.

Greetings.

> > Thank you very much for the reply.
> > Greetings.
> >=20
> > El martes, 12 de septiembre de 2017 6:34:15 (CEST) Andrei Borzenkov=20
escribi=C3=B3:
> >> 11.09.2017 21:17, Sen=C3=A9n Vidal Blanco =D0=BF=D0=B8=D1=88=D0=B5=D1=
=82:
> >>> I am trying to implement a system that stores the data in a unit (A)
> >>> with
> >>> BTRFS format that is untouchable and that future files and folders
> >>> created
> >>> or modified are stored in another physical unit (B) with BTRFS format.
> >>> Each year the new files will be moved to store A and start over.
> >>>=20
> >>> The idea is that a duplicate of disk A can be made to keep it in a sa=
fe
> >>> place and that the files stored there can not be modified until the
> >>> mixture of (A) and (B) is made.
> >>=20
> >> This can probably be achieved using seed device. Mark original device =
as
> >> seed and all changes will go to another writable device, similar to
> >> overlay; then remove seed bit from original device, "btrfs device remo=
ve
> >> writable" device and it should relocate its content back. Rinse and
> >> repeat.

=2D-=20
	Sen=C3=A9n Vidal Blanco - SGISoft S.L.
=20
	Tlf.: 986413322 - 660923711
	GPG ID 466431A8AF01F99A
	http://www.sgisoft.com/
=2D-
=20

--nextPart1943037.QtkT9aZUbU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSK7dSjHxedEO9Hp55GZDGorwH5mgUCWcOPZgAKCRBGZDGorwH5
mnxQAJ0SIEBwsGnpAysYyiTOxhUiY6sULwCg47uv2nvn/nPhYVsC/AvbKUpiDEw=
=6srN
-----END PGP SIGNATURE-----

--nextPart1943037.QtkT9aZUbU--

