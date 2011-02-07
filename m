From: "Robert G." <ruppertus@o2.pl>
Subject: Re: no space left on device
Date: Tue, 8 Feb 2011 00:58:49 +0100
Message-ID: <20110208005849.10464462@leni>
References: <AANLkTi=KNt1JVq82FR-u9CGA1TcXiknz0c3bbD186U43@mail.gmail.com>
	<4D5063B2.4070609@logtenberg.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Erik Logtenberg <erik@logtenberg.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D5063B2.4070609@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I had a similar problem on my Debian (squeeze) about a half year ago.
I've described that on this mailing list. That was a main reason to
migrate from brtfs (-o ssd) to ext4.=20

I know it's a pain for my SSD but I want to revert this fail system
when it will be more stable. Thanks God it was added to Debian 6 and
Ubuntu 10.10. Now there will be even more alpha/beta testers.
And some problems will be noticed more frequently.

When will you change status from experimental to stable in the kernel?

Regards
Robert.

Dnia 2011-02-07, o godz. 22:27:14
Erik Logtenberg <erik@logtenberg.eu> napisa=C5=82(a):

> Hi Leonidas,
>=20
> Please check this:
>=20
> btrfs fi df /home
>=20
> If this shows much of your space used by metadata then please use:
>=20
> btrfs fi balance /home
>=20
> Note that this can take a long (>1 day) time to complete on a big FS.
>=20
>  - Erik
>=20
>=20
>=20
> On 02/07/2011 10:21 PM, Leonidas Spyropoulos wrote:
> > Hey all,
> >=20
> > I run into no space left on device on a virtualbox
> >=20
> > After installing Debian 6 on a virtual machine
> > I tried installing the KDE desktop
> >=20
> > The system HDD is 8Gb
> > Both root (/) and /home are btrfs
> > over LVM.
> >=20
> > While installing the packages I run into:
> >=20
> > no space left, need 4096, 4096 dealloc bytes, 1776283648
> > bytes_used, 0 bytes_reserved,
> > 0 bytes_pinned, 0 bytes_readonly, 0 may use 1776287744 total
> >=20
> > df shows only 74% used space on /
> >=20
> > kernel used: stock debian 6 2.6.32-5-686
> >=20
> > At the moment I cannot access it with normal boot, only recovery
> > mode.
> >=20
> > I can provide whatever info you would like as long as you think of =
a
> > way to load the normal system and not the recovery mode.
> >=20
> >=20
> >=20
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
