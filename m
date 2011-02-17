From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Space used by snapshot
Date: Thu, 17 Feb 2011 12:54:37 +0100
Message-ID: <201102171254.37670.hka@qbs.com.pl>
References: <AANLkTi=LE2poDR5sNyPJF6rQ_TpLv5pjgHRQXG0Wpt-i@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Roman Kapusta <roman.kapusta@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=LE2poDR5sNyPJF6rQ_TpLv5pjgHRQXG0Wpt-i@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, February 17, 2011 12:13:53 Roman Kapusta wrote:
> Hello all,
>=20
> Is there any way how to obtain information how much space is
> physically allocated by given subvolume?
> I cannot find any. I'm interested in two values:
>=20
> - physical space allocated by SUBVOLUME INCLUDING all space shared by
> other subvolumes

That's the space reported by `du -hs /mnt/btrfs/subvolume`

>=20
> - physical space allocated by SUBVOLUME EXCLUDING all space shared by
> other subvolumes

That's not implemented right now
=20
> Currently I can use only du, which is not reporting what I want to kn=
ow.
>=20
> Regards
>=20
> Roman Kapusta

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
