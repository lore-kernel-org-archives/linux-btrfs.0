From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: Copy/move btrfs volume
Date: Sat, 3 Jul 2010 07:33:19 +0000 (UTC)
Message-ID: <i0mp3v$q93$1@dough.gmane.org>
References: <i0hqkk$r4h$1@dough.gmane.org>
	<AANLkTin1O6Oa7oq4nFMfNhv4N5FWCko7bcuTMoR5Xkob@mail.gmail.com>
	<i0huf7$98a$1@dough.gmane.org> <4C2D14DA.3040301@gmx.com>
	<03lj9ujtp4.fsf@msgid.viggen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Oystein Viggen, Fri, 02 Jul 2010 08:15:03 +0200:

> For btrfs with lots of snapshots, I believe "btrfs device add" of the
> new device followed by "btrfs device remove" of the old one would be =
the
> most convenient.
>=20
> =C3=98ystein

This solution if very elegant and cool - if you can put the discs into =
one=20
computer.

It does not help too much to copy the files over network and preserve t=
he=20
snapshots... or can you add like this a network-attached device (sshfs)=
 ?

Lubos

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
