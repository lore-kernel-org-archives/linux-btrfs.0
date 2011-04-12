From: Jan Steffens <jan.steffens@gmail.com>
Subject: Re: Unable to perform online resize
Date: Wed, 13 Apr 2011 00:41:44 +0200
Message-ID: <BANLkTi=1oVQbd3hxiKMXFazipGH6vXRpfg@mail.gmail.com>
References: <BANLkTin8vD6CaxA5SgrpzcCdYpFjSB6LEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTin8vD6CaxA5SgrpzcCdYpFjSB6LEQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 13, 2011 at 12:15 AM, Ali Lown <ali@lown.me.uk> wrote:
> I am using btrfs-progs latest git head in gentoo, along with a 2.6.37=
 kernel.
> I am unable to resize the filesystem online (or offline - though that
> doesn't seem to be an option).
>
> with brtfs:
> ---------------------------------------------------------------------=
------------------------------------------
> alipc-gentoo% sudo btrfs filesystem resize +20g ~/.wine/drive_c
> Resize '/home/ali/.wine/drive_c' of '+20g'
> ERROR: unable to resize '/home/ali/.wine/drive_c'
> ---------------------------------------------------------------------=
------------------------------------------
>
> with btrfs-ctl:
> ---------------------------------------------------------------------=
------------------------------------------
> alipc-gentoo% sudo btrfsctl -r +20g ~/.wine/drive_c
> ioctl:: File too large
> ---------------------------------------------------------------------=
------------------------------------------
>
> fdisk -l of the the drive that partiion is on (sda9 =3D ~/.wine/drive=
_c):
> ---------------------------------------------------------------------=
------------------------------------------
> Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 secto=
rs
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x000e3826
> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A063 =C2=A019=
53520064 =C2=A0 976760001 =C2=A0 =C2=A05 =C2=A0Extended
> /dev/sda5 =C2=A0 =C2=A0 =C2=A01009797705 =C2=A01953520064 =C2=A0 4718=
61180 =C2=A0 83 =C2=A0Linux
> /dev/sda6 =C2=A0 =C2=A0 =C2=A0 642391218 =C2=A01009797704 =C2=A0 1837=
03243+ =C2=A083 =C2=A0Linux
> /dev/sda7 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 189 =C2=A0 =C2=A0=
41945714 =C2=A0 =C2=A020972763 =C2=A0 =C2=A07 =C2=A0HPFS/NTFS
> /dev/sda8 =C2=A0 =C2=A0 =C2=A0 =C2=A041945778 =C2=A0 104856254 =C2=A0=
 =C2=A031455238+ =C2=A083 =C2=A0Linux
> /dev/sda9 =C2=A0 =C2=A0 =C2=A0 104856318 =C2=A0 209712509 =C2=A0 =C2=A0=
52428096 =C2=A0 83 =C2=A0Linux
> /dev/sda10 =C2=A0 =C2=A0 =C2=A0386250858 =C2=A0 468166229 =C2=A0 =C2=A0=
40957686 =C2=A0 83 =C2=A0Linux
> Partition table entries are not in disk order
> ---------------------------------------------------------------------=
------------------------------------------
> For help in comprehending this, here is an image from gparted:
> http://img833.imageshack.us/i/gpartedd.png/
>
> Apart from the hideous numbering and arrangement - I used gparted, an=
d
> made it up gradually, as and when I needed partitions.
> In short for sda9, it is a logical partition inside an extended
> partion (sda1), and has approximately 85GB of unpartioned space
> (inside the extended partition) following it, into which I would like
> to resize it.
> Thanks.
> -Ali
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

btrfs resizing (like resize2fs) does not manipulate the size of partiti=
ons.

=46irst, you need to expand the partition using fdisk or gparted.
Afterwards you can use "btrfs filesystem resize max ~/.wine/drive_c"
to grow the filesystem to the size of the partition.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
