From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Btrfs system won't start on Ubuntu (relationship problems...)
Date: Sun, 13 Mar 2011 12:46:09 -0400
Message-ID: <AANLkTikTpT8QYiU8MMA=d1Wwr-2g-QCqmJWtc1sq+wiE@mail.gmail.com>
References: <AANLkTi=4VaXSZgeN-DeohPduQ_8FiuEroNpKCD3bTSPK@mail.gmail.com>
 <20110313114616.8860.qmail@stuge.se> <AANLkTimtN0FWG95dzjwzOzZoQaHEzL7t5ffZchR=BZAu@mail.gmail.com>
 <20110313163048.5321.qmail@stuge.se> <AANLkTin9FG5npgKS_Hj16mXFb17ixmM6XddWw45zEW62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin9FG5npgKS_Hj16mXFb17ixmM6XddWw45zEW62@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2011 at 12:30 PM, Peter Stuge <peter@stuge.se> wrote:
>
> J=E9r=F4me Poulin wrote:
> > Never plug a defective drive on USB if it is the source .. else
> > defective sectors get transferred as good filled with random stuff
>
> Interesting! Which USB chipset(s?) have you seen do this?
>

Those I tried and confirmed not working are
CablesToGo:=A0http://www.cablestogo.com/product.asp?cat_id=3D941&sku=3D=
30504
StarTech:=A0http://us.startech.com/product/USB2SATAIDE-USB-20-to-IDE-or=
-SATA-Adapter-Cable

I don't have them handy but I can confirm you the chipset if you'd like=
=2E

As a sidenote USB converters don't have low level access to the disk
so it also makes smartctl and stuff not working at all.
I was not able to find any USB converter which was working correctly
using ddrescue and a defective disk yet.

>
> //Peter
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
