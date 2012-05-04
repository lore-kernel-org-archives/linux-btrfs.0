From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs scrub  BUG: unable to handle kernel NULL pointer dereference
Date: Fri, 04 May 2012 12:08:46 +0200
Message-ID: <11836133.i1tyM0nCej@bursa01>
References: <4FA34AD7.3000008@intellasoft.net> <4FA3709B.5080409@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Mark Murawski <markm-lists@intellasoft.net>,
	linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA3709B.5080409@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 04 of May 2012 08:00:59 Arne Jansen wrote:
> On 04.05.2012 05:19, Mark Murawski wrote:
> > I think I have some failing hard drives, they are disconnected for =
now.
> >=20
> > stan {~} root# btrfs filesystem show
> > Label: none  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
> >=20
> >         Total devices 2 FS bytes used 6.27GB
> >         devid    1 size 9.31GB used 8.16GB path /dev/sde6
> >         *** Some devices missing
> >=20
> > Label: none  uuid: b142f575-df1c-4a57-8846-a43b979e2e09
> >=20
> >         Total devices 8 FS bytes used 1.35TB
> >         devid    3 size 149.05GB used 119.01GB path /dev/sdf
> >         devid    6 size 920.34GB used 408.00GB path /dev/sde7
> >         devid    7 size 1.36TB used 885.00GB path /dev/sdd
> >         devid    4 size 149.05GB used 119.01GB path /dev/sdc
> >         devid    2 size 465.76GB used 435.00GB path /dev/sdb
> >         devid    8 size 1.36TB used 885.00GB path /dev/sda
> >         *** Some devices missing
> >=20
> > stan {~} root# btrfs scrub status /storage
> > Killed
>=20
> This is probably the same issue this patch fixes:
>=20
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16302
>=20
> It is included in a recent RC.

OK, that will teach me to write more descriptive commit comments:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15856
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15857

Sill, is the first one patching a real vulnerability?

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
