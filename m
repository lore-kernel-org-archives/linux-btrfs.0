From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH] Btrfs: initial online fsck support
Date: Sat, 2 Jul 2011 13:47:40 +0200
Message-ID: <201107021347.42281.hka@qbs.com.pl>
References: <4E0C4303.1080406@cn.fujitsu.com> <m239ipnb7v.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m239ipnb7v.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 01 of July 2011 19:48:36 Andi Kleen wrote:
> Li Zefan <lizf@cn.fujitsu.com> writes:
> > This is an initial version of online fsck. What it does is:
> >=20
> > - check the dir item and dir index pointing to a file.
> > - check the structure of extents of a file.
> >=20
> > As furthur work, we should consider:
> >=20
> > - fix but not only check the structure of a file.
> > - verify the extent allocation tree on the fly.
>=20
> It's scary to have a fsck in kernel space. Is there no way to do
> this from user space?
>=20
> -Andi

There will be a userspace fsck (Chris Mason is working on it ATM).

The two big features of btrfs are self-healing and online fsck, those h=
ave to=20
be implemented in kernel space.
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
