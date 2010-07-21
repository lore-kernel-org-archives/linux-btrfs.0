From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Copy/move btrfs volume
Date: Wed, 21 Jul 2010 17:00:12 +0200
Message-ID: <201007211700.38453.hka@qbs.com.pl>
References: <i0hqkk$r4h$1@dough.gmane.org> <03lj9ujtp4.fsf@msgid.viggen.net> <i0mp3v$q93$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i0mp3v$q93$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 03 July 2010 09:33:19 Lubos Kolouch wrote:
> Oystein Viggen, Fri, 02 Jul 2010 08:15:03 +0200:
> > For btrfs with lots of snapshots, I believe "btrfs device add" of t=
he
> > new device followed by "btrfs device remove" of the old one would b=
e the
> > most convenient.
> >=20
> > =C3=98ystein
>=20
> This solution if very elegant and cool - if you can put the discs int=
o one
> computer.
>=20
> It does not help too much to copy the files over network and preserve=
 the
> snapshots... or can you add like this a network-attached device (sshf=
s) ?

You could also go the totally cool option (albeit a bit creazy) and use=
=20
network block devices and have no downtime...

The overall process will take more time though.

--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=C3=B3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
