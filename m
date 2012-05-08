From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Can btrfs silently repair read-error in raid1
Date: Tue, 08 May 2012 23:47:11 +0200
Message-ID: <2557067.fSI13aCqDU@bursa22>
References: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com> <CAG1y0seZD1n5sckdFx=BAJa+KQguKd-Dj9_Ti1EhJRY0bE2B9Q@mail.gmail.com> <CAE5mzvg8HgZPgFmNB3ZeuJTfLtrfeXH417bEVuHFST5z=zOMFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "Fajar A. Nugraha" <list@fajar.net>,
	Clemens Eisserer <linuxhippy@gmail.com>,
	linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvg8HgZPgFmNB3ZeuJTfLtrfeXH417bEVuHFST5z=zOMFw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 08 of May 2012 04:45:51 cwillu wrote:
> On Tue, May 8, 2012 at 1:36 AM, Fajar A. Nugraha <list@fajar.net> wro=
te:
> > On Tue, May 8, 2012 at 2:13 PM, Clemens Eisserer <linuxhippy@gmail.=
com>=20
wrote:
> >> Hi,
> >>=20
> >> I have a quite unreliable SSD here which develops some bad blocks =
from
> >> time to time which result in read-errors.
> >> Once the block is written to again, its remapped internally and
> >> everything is fine again for that block.
> >>=20
> >> Would it be possible to create 2 btrfs partitions on that drive an=
d
> >> use it in RAID1 - with btrfs silently repairing read-errors when t=
hey
> >> occur?
> >> Would it require special settings, to not fallback to read-only mo=
de
> >> when a read-error occurs?
> >=20
> > The problem would be how the SSD (and linux) behaves when it
> > encounters bad blocks (not bad disks, which is easier).
> >=20
> > If it does "oh, I can't read this block. I just return an error
> > immediately", then it's good.
> >=20
> > However, in most situation, it would be like "hmmm, I can't read th=
is
> > block, let me retry that again. What? still error? then lets retry =
it
> > again, and again.", which could take several minutes for a single b=
ad
> > block. And during that time linux (the kernel) would do something l=
ike
> > "hey, the disk is not responding. Why don't we try some stuff? Let'=
s
> > try resetting the link. If it doesn't work, try downgrading the lin=
k
> > speed".
> >=20
> > In short, if you KNOW the SSD is already showing signs of bad block=
s,
> > better just throw it away.
>=20
> The excessive number of retries (basically, the kernel repeating the
> work the drive already attempted) is being addressed in the block
> layer.
>=20
> "[PATCH] libata-eh don't waste time retrying media errors (v3)", I
> believe this is queued for 3.5

I just hope they don't remove retries completely, I've seen the second =
or=20
third try return correct data on multiple disks from different vendors.=
=20
(Which allowed me to use dd to write the data back to force relocation)

But yes, Linux is a bit too overzelous with regards to retries...

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
