From: Nik Markovic <nmarkovi.navteq@gmail.com>
Subject: Re: Consistent crash with cp reflink on large files
Date: Mon, 12 Dec 2011 19:22:52 -0600
Message-ID: <CAB3q874C0h1+W7t+8q-QNK7Kb2ujTrtHpD0WZkFaxjYbC9qJfg@mail.gmail.com>
References: <CAB3q875f4HFCaR9=yk0iCy7HF55tpt65q2+-fCuNbkSFHrey_A@mail.gmail.com>
	<4EE69FD5.4040009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE69FD5.4040009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Li Zefan wrote:
>
> Nik Markovic wrote:
> > Hi All,
> >
> > I have been encountering consistent btrfs filesystem crashes when
> > using cp =96reflink=3Dalways on a large file and modifying it. I be=
lieve
> > that the test file needs to be fairly large as I was not able to
> > reproduce with smaller files. The filesystem size is 45GB and file
> > size is 10GB.
> >
>
> It should be fixed in 3.1 by this commit:
>
> commit b6f3409b2197e8fcedb43e6600e37b7cfbe0715b
> Author: Sage Weil <sage@newdream.net>
> Date: =A0 Tue Sep 20 14:48:51 2011 -0400
>
> =A0 =A0Btrfs: reserve sufficient space for ioctl clone
>
> =A0 =A0Fix a crash/BUG_ON in the clone ioctl due to insufficient rese=
rvation. We
> =A0 =A0need to reserve space for:
>
> =A0 =A0 - adjusting the old extent (possibly splitting it)
> =A0 =A0 - adding the new extent
> =A0 =A0 - updating the inode
Thanks Li,

You are probably right. I upgraded to 3.2-rc5 today and was not able
to reproduce with 100k iterations.
Do you think that applying the same patch to 3.0 should fix this issue =
in 3.0?

Nik
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
