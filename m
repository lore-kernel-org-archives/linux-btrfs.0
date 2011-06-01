From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs error after using kernel 3.0-rc1
Date: Wed, 1 Jun 2011 12:22:40 +0000
Message-ID: <BANLkTinP-Rit3tc2HRDx4d2WArkxqUBuug@mail.gmail.com>
References: <BANLkTimGPgn9CERxCNQPqJLTiRkFUc03OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimGPgn9CERxCNQPqJLTiRkFUc03OA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 1, 2011 at 6:06 AM, Fajar A. Nugraha <list@fajar.net> wrote=
:
> While using btrfs as root on kernel 3.0-rc1, there was some errors (I
> wasn't able to capture the error) that forced me to do hard reset.
>
> Now during startup system drops to busybox shell because it's unable
> to mount root partition.
> Is there a way to recover the data, as at least grub2 was still happy
> enough to load kernel and initrd (both of which located on the same
> btrfs partition)?
>
> This is what dmesg says
>
> [ =A0 =A04.536798] device label SSD-ROOT devid 1 transid 38245 /dev/s=
da2
> [ =A0 =A09.552086] device label SSD-ROOT devid 1 transid 38245
> /dev/disk/by-label/SSD-ROOT
> [ =A0 =A09.554563] btrfs: disk space caching is enabled
> [ =A0 =A09.564301] parent transid verify failed on 44040192 wanted 38=
240 found 32526
> [ =A0 =A09.564535] parent transid verify failed on 44040192 wanted 38=
240 found 32526
> [ =A0 =A09.564778] parent transid verify failed on 44040192 wanted 38=
240 found 32526
> [ =A0 =A09.575679] parent transid verify failed on 44052480 wanted 38=
240 found 31547
> [ =A0 =A09.575904] parent transid verify failed on 44052480 wanted 38=
240 found 31547
> [ =A0 =A09.576176] parent transid verify failed on 44052480 wanted 38=
240 found 31547
> [ =A0 =A09.586121] parent transid verify failed on 44064768 wanted 38=
240 found 34145
> [ =A0 =A09.586319] parent transid verify failed on 44064768 wanted 38=
240 found 34145
> [ =A0 =A09.586515] parent transid verify failed on 44064768 wanted 38=
240 found 34145
> [ =A0 =A09.587027] parent transid verify failed on 44068864 wanted 38=
240 found 34476
> [ =A0 =A09.589732] Btrfs detected SSD devices, enabling SSD mode
> [ =A0 =A09.592923] block group 29360128 has an wrong amount of free s=
pace
> [ =A0 =A09.592959] btrfs: failed to load free space cache for block g=
roup 29360128


=46or anyone who got the same problem,

I was finally able to mount the fs using Ubuntu Natty's
2.6.38-8-generic (the one on live CD).
Previously I tried using 2.6.38-9-generic and and 3.0-rc1, none works.
Now I'm copying the files somewhere else before reinstalling this
system.

On another note, does anybody know how btrfs allocates ID for subvols?
It doesn't seem to reuse deleted subvol's ID. What happens when the
last subvol ID is 999?

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
