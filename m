From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH] Btrfs: initial online fsck support
Date: Sat, 2 Jul 2011 21:06:07 +0200
Message-ID: <201107022106.07938.hka@qbs.com.pl>
References: <4E0C4303.1080406@cn.fujitsu.com> <201107021347.42281.hka@qbs.com.pl> <20110702170443.GI23059@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110702170443.GI23059@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 02 of July 2011 19:04:43 Andi Kleen wrote:
> > The two big features of btrfs are self-healing and online fsck, tho=
se
> > have to
>=20
> Are they?

they are scheduled to be, just like RAID5/6, mixed RAID in single FS...
=20
> > be implemented in kernel space.
>=20
> Why? There have been online fscks in user space in the past,
> e.g. the various schemes using LVM snapshots for ext* and
> other related work on the BSD FFS. I don't see any principal
> reason why it couldn't be done for btrfs either.

Doing a fsck on LVM snapshot of btrfs:
1. is impossible (UUIDs)
2. won't fix errors

I have to note that I don't know how FFS fsck is implemented.
=20
> A good fsck is quite complex and you are unlikely to want all
> that code in kernel space.

complete one, yes, but it's not quite pointless, ZFS does it like this =
and=20
admins rather like it

--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=F3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
