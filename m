From: Peter Stuge <peter@stuge.se>
Subject: Re: Btrfs system won't start on Ubuntu (relationship problems...)
Date: Sun, 13 Mar 2011 17:53:44 +0100
Message-ID: <20110313165344.7651.qmail@stuge.se>
References: <AANLkTi=4VaXSZgeN-DeohPduQ_8FiuEroNpKCD3bTSPK@mail.gmail.com> <20110313114616.8860.qmail@stuge.se> <AANLkTimtN0FWG95dzjwzOzZoQaHEzL7t5ffZchR=BZAu@mail.gmail.com> <20110313163048.5321.qmail@stuge.se> <AANLkTin9FG5npgKS_Hj16mXFb17ixmM6XddWw45zEW62@mail.gmail.com> <AANLkTikTpT8QYiU8MMA=d1Wwr-2g-QCqmJWtc1sq+wiE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?utf-8?B?SsOpcsO0bWU=?= Poulin <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikTpT8QYiU8MMA=d1Wwr-2g-QCqmJWtc1sq+wiE@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

J=C3=A9r=C3=B4me Poulin wrote:
> Those I tried and confirmed not working are
> CablesToGo:=C2=A0http://www.cablestogo.com/product.asp?cat_id=3D941&s=
ku=3D30504
> StarTech:=C2=A0http://us.startech.com/product/USB2SATAIDE-USB-20-to-I=
DE-or-SATA-Adapter-Cable
>=20
> I don't have them handy but I can confirm you the chipset if you'd li=
ke.

Please do! I'm very interested to know which ones to avoid.


> As a sidenote USB converters don't have low level access to the disk

Actually they do. The disk plugs in to the controller chip, and ATA
commands are sent over USB. (See the Mass Storage USB Device Class
Specification at usb.org.)


> so it also makes smartctl and stuff not working at all.

Maybe some ATA commands are eaten along the way, again possibly only
with particular chipsets. It would be interesting to gather a bit of
information on this as well.


//Peter
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
