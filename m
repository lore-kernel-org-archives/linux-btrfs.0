From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: btrfs-convert fails
Date: Mon, 1 Nov 2010 10:49:43 +0100
Message-ID: <20101101104943.00007ff9@unknown>
References: <AANLkTimFGe1PSbns4ps_wGSpSVMNhWehd=zoA8XnAu5_@mail.gmail.com>
	<B$1sRYTD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B$1sRYTD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Helmut,

don't use btrfs for important files if you got no backup yet. It's
quite stable and a lot of ppl don't have problem with it, but there are
some cases where it could be very ugly, like a powerloss while writing
etc.


Regards,
=46elix

Am 01 Nov 2010 09:02:00 +0100
schrieb "Helmut Hullen" <Hullen@t-online.de>:

> Hallo, Yan,
>=20
> Du meintest am 01.11.10:
>=20
> >> I've tried to convert a 12 GByte ext2 partition (nearly full, 280
> >> MByte free) with btrfs-convert.
> >>
> >> After about 15 minutes (700-MHz-CPU) the system tells
> >>
> >> =A0...
> >> =A0creating ext2fs image file
> >> =A0cleaning up system chunk
> >> =A0btrfs-convert: extent-tree.c:2529: btrfs_reserve_extent: Assert=
ion
> >> =A0 =A0 `!(ret)' failed
> >> =A0Abgebrochen
>=20
> > Try btrfs-convert -r /dev/xxx, hopefully it will recover your ext2.
>=20
> Restoring is (now) no problem, I'm still testing. But in some days
> (or weeks) I want to convert a partition with 1,5 TByte (which has
> no backup) ...
>=20
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
