From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Consistent crash with cp reflink on large files
Date: Tue, 13 Dec 2011 08:44:05 +0800
Message-ID: <4EE69FD5.4040009@cn.fujitsu.com>
References: <CAB3q875f4HFCaR9=yk0iCy7HF55tpt65q2+-fCuNbkSFHrey_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
To: Nik Markovic <nmarkovi.navteq@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAB3q875f4HFCaR9=yk0iCy7HF55tpt65q2+-fCuNbkSFHrey_A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Nik Markovic wrote:
> Hi All,
>=20
> I have been encountering consistent btrfs filesystem crashes when
> using cp =96reflink=3Dalways on a large file and modifying it. I beli=
eve
> that the test file needs to be fairly large as I was not able to
> reproduce with smaller files. The filesystem size is 45GB and file
> size is 10GB.
>=20

It should be fixed in 3.1 by this commit:

commit b6f3409b2197e8fcedb43e6600e37b7cfbe0715b
Author: Sage Weil <sage@newdream.net>
Date:   Tue Sep 20 14:48:51 2011 -0400

    Btrfs: reserve sufficient space for ioctl clone
   =20
    Fix a crash/BUG_ON in the clone ioctl due to insufficient reservati=
on. We
    need to reserve space for:
   =20
     - adjusting the old extent (possibly splitting it)
     - adding the new extent
     - updating the inode
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
