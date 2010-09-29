From: Francis Galiegue <fgaliegue@gmail.com>
Subject: Re: Another checksum error bugreport
Date: Wed, 29 Sep 2010 13:12:28 +0200
Message-ID: <AANLkTinqsjRZ8uGpz_xmVHCLLaqC1rO_uE=KFcfMMaW0@mail.gmail.com>
References: <AANLkTi=vHyE+epYixXgu5ju_JfjWdU+xghL-PLo60ktu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=vHyE+epYixXgu5ju_JfjWdU+xghL-PLo60ktu@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 12:48, Sebastian 'gonX' Jensen
<gonx@overclocked.net> wrote:
> Hey guys,
>
> Today I experienced my first checksum error just out of the blue - an=
d
> it's not just the 'csum + 1 =3D private' issue, it's a completely
> different one. Because of this, I am unable to retrieve the data off
> the drive, even with nodatasum enabled - I simply get an I/O error.
> Here's the dmesg output:
>
> [149423.845177] btrfs: setting nodatasum
> [149423.850339] Btrfs detected SSD devices, enabling SSD mode
> [149432.094728] btrfs csum failed ino 259 off 26701824 csum 387586704=
1
> private 371726550
> [149432.117938] btrfs csum failed ino 259 off 26701824 csum 387586704=
1
> private 371726550
> [149432.118340] btrfs csum failed ino 259 off 26701824 csum 387586704=
1
> private 371726550
> [149432.125671] btrfs csum failed ino 259 off 26701824 csum 387586704=
1
> private 371726550
> [149432.126075] btrfs csum failed ino 259 off 26701824 csum 387586704=
1
> private 371726550
> [149432.135671] btrfs csum failed ino 259 off 26701824 csum 387586704=
1
> private 371726550
>
> I would really like to have the files on the drive retrieved in their
> entirety, but if that is not possible then that is also OK. Consider
> this a bugreport and a question on how to retrieve the data now.
>

Which kernel is that?

A patch made it in 2.6.36-rc6 which fixed an important bug in the bdi
code, wherein write requests and discard requests were merged,
transforming all requests in discard requests.

And you use an SSD... Hmmm.

--=20
=46rancis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (St=C3=A9phane Faroult, in "Th=
e
Art of SQL", ISBN 0-596-00894-5)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
