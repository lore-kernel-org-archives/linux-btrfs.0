From: Marcel Runte <marcel.runte@web.de>
Subject: Re: Re: Kernel oops after compile error
Date: Wed, 06 Aug 2008 00:21:27 +0200
Message-ID: <1908993894@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi YZ, hi Chris,

I tried the whole build process on Kubuntu Hardy Heron (kernel 2.6.24-1=
9-generic) and there ist was OK, so I think it has something to do with=
 the difference in include of kernel-headers-2.6.22-15 on Gutsy...

Unfortunately new release leads to same error... But for testing purpos=
e for me its enough that this working on a higher kernel version...

Best regards, Marcel

> -----Urspr=FCngliche Nachricht-----
> Von: "Yan Zheng" <zheng.yan@oracle.com>
> Gesendet: 01.08.08 05:01:13
> An: "Marcel Runte" <marcel.runte@web.de>
> CC: linux-btrfs@vger.kernel.org
> Betreff: Re: Kernel oops after compile error


> 2008/8/1 Marcel Runte <marcel.runte@web.de>:
> > patch described in your link is included in http://www.kernel.org/h=
g/index.cgi/btrfs/kernel/rev/9da425337329, which I used for compilation=
=2E Even putting an alias like "alias gcc =3D 'gcc -DREMOVE_SUID_PATH'"=
 or doing a "CC=3D'gcc -DREMOVE_SUID_PATH'; make"leads to same error me=
ssage when compiling file.c
> >
>=20
> Linux kernel uses its own building system, putting alias has no
> effect. Please try modify the code directly.
>=20
> YZ
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
