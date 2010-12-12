From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: ENOSPC on heterogeneous raid 0
Date: Sun, 12 Dec 2010 15:24:59 +0100
Message-ID: <201012121524.59737.hka@qbs.com.pl>
References: <AANLkTikWrcJ+hWr0WS+1eeXdGKce3Xf-aH9k5Fg4x8Z3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: William Sheffler <will@sheffler.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikWrcJ+hWr0WS+1eeXdGKce3Xf-aH9k5Fg4x8Z3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 08 of December 2010 22:53:25 William Sheffler wrote:
> Hello btrfs community.
>=20
> First off, thanks for all your hard work... I have been following
> btrfs with interest for several years now and very much look forward
> to the day it replaces ext4. The real killer feature (of btrfs
> specifically) for me is the ability to add *and remove* devices from =
a
> filesystem, as this allows rolling upgrades of my server's disks. I
> have a 16 port 3ware 1650SE on which I have a number of small raid
> units and it will be fantastic to be able to remove the oldest,
> upgrade, and add the new storage back. I had previously been using
> ZFS, but since ZFS doesn't allow removal of devices, this rolling
> upgrade strategy doesn't work.
>=20
> My question is this: can btrfs handle striping (raid 0) across
> heterogeneous devices? I seem to be losing any capacity on the larger
> disk beyond what is available on the smaller disk. I really hope ther=
e
> is some simple fix!

Yes, it can handle stripping over devices of different size, unfortunat=
ely=20
you're still limited to <size of smallest device>*<number of devices>

if you want to use all the available space use "-d single" when creatin=
g=20
volume

for details, read the recent thread "800GB free, but no space left"

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
