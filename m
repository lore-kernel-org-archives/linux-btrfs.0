From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [BUG] btrfs hangup when we run the "sync" command
Date: Wed, 21 Jul 2010 14:36:24 +0200
Message-ID: <201007211436.39693.hka@qbs.com.pl>
References: <4C3E7E1B.5000002@cn.fujitsu.com> <AANLkTinkuiT9tBiALkCIDMs9d9J9FT9sl9GEyRogq09S@mail.gmail.com> <4C3ECFBB.40006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "Yan, Zheng" <zheng.yan@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C3ECFBB.40006@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 15 July 2010 11:07:07 Miao Xie wrote:
> On Thu Jul 15 2010 16:14:31 GMT+0800 (CST), Yan, Zheng wrote:
> > 2010/7/15 Miao Xie<miaox@cn.fujitsu.com>:
> >> Hi, everyone
> >>=20
> >> I found btrfs will hangup when we run the sync command on my
> >> x86_64 box.
> >>=20
> >> The reproduce steps is following:
> >> # mkfs.btrfs -s 8192 -l 8192 -n 8192 /dev/sda1
> >> # mount /dev/sda1 /mnt
> >> # echo 1234567>  /mnt/aaa
> >> # sync
> >> (btrfs hangs up)
> >>=20
> >> It seems that the btrfs doesn't support the sectorsize which is
> >> greater than the page size just like ext2/3/4, though we can use
> >> mkfs.btrfs to make a filesystem with a big sectorsize. Am I right?
> >>=20
> >> If yes, we must do more check in the mkfs.btrfs.
> >=20
> > yes, btrfs doesn't support the sectorsize>  PAGE_size.
>=20
> So we must do more check in the mkfs.btrfs to avoid misuse, and I'll
> add some check of the sectorsize into the mkfs.btrfs.

I don't think that denying of creation of FSs with sectorsize > pagesiz=
e is a=20
good idea. A warning would be better:

Warning: The filesystem you are about to create won't be usable on your=
=20
computer architecture. Do you want to continue? y/n:

Unless the FS created in such way is unusabe in any circumstances...

> BTW, I sent some patches to the btrfs community recently, but I haven=
't
> received any reply. Could you review them for me? though I have teste=
d
> them and everything works well.
>=20
> [PATCH 1/2] btrfs: restructure try_release_extent_buffer()
> [PATCH 2/2] btrfs: fix oops when leafsize is greator than nodesize
> [PATCH] btrfs-progs: fix wrong extent buffer size when reading tree b=
lock
>=20
> Thanks
> Miao Xie

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
