From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs volume backup
Date: Fri, 18 Feb 2011 17:44:16 +0100
Message-ID: <201102181744.16718.hka@qbs.com.pl>
References: <20110218122424.de09f5e8.wavexx@users.sf.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yuri D'Elia" <wavexx@users.sf.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110218122424.de09f5e8.wavexx@users.sf.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, February 18, 2011 12:24:24 Yuri D'Elia wrote:
> Is there a way to backup/restore a btrfs volume without losing all th=
e
> associated metadata? (something like xfsdump/restore?)
>=20
> brtfs-image looks somewhat what one would need, except that it clears=
 the
> actual data (for debugging purposes I guess?). I guess it also doesn'=
t
> work on a mounted filesystem, so fixing btrfs-image would be of limit=
ed
> use right now.
>=20
There's nothing like it right now, the only way to backup whole btrfs v=
olume=20
is to use dd.

something like "zfs send" is in the plans though

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
