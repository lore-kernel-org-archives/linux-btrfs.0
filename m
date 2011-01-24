From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Cannot Create Partition
Date: Mon, 24 Jan 2011 10:07:13 +0700
Message-ID: <AANLkTim6WLvTsZfNH6v8evyrbLT0B46Bg7QmoR=JGjkO@mail.gmail.com>
References: <201101231007.55046.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101231007.55046.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 24, 2011 at 1:07 AM,  <CACook@quantum-sci.com> wrote:
>
> On /dev/sda I have sda1 which is my / bootable filesystem for Debian =
formatted ext4. =A0This is 256MB on a 2TB drive.

Really? How do you know it's 256 MB?

> # fdisk /dev/sda
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util =
fdisk doesn't support GPT. Use GNU Parted.
> WARNING: DOS-compatible mode is deprecated. It's strongly recommended=
 to
> =A0 =A0 =A0 =A0 switch off the mode (command 'c') and change display =
units to
> =A0 =A0 =A0 =A0 sectors (command 'u').
> Command (m for help): p
> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0243202 =A019535145=
83+ =A0ee =A0GPT

=2E.. cause the fdisk output pretty much shows the first partition uses
up all space.
You can check again if you want, using "parted /dev/sda print" (just
in case it's really fdisk problem).

> Maybe it's possible that I just mkfs.btrfs /dev/sda and it will set u=
p -only- the remaining space, but I'm afraid that this may destroy my O=
S.

You might be able to boot using a live CD and use gparted to resize
the current ext4 partition.

>
> Also, what if I want to set up the whole drive as BTRFS? =A0Could thi=
s be bootable, and can the canned Debian kernel load the BTRFS driver f=
or boot at install? =A0Or would I boot to the CD, mkfs.btrfs the drive,=
 then install Debian? =A0Anyone tried this?

Ubuntu Natty's grub2 has btrfs support, but It's still in alpha stage
though. Don't know about Debian.
At this point it's easiest if you use ext3/4 for /boot, and use btrfs
only for "/".

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
