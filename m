From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: mount command not honoring rootflags passed
Date: Fri, 22 Jan 2010 09:59:42 +0100
Message-ID: <23a15591001220059y4d3c41c0k1ade5c4da358cb66@mail.gmail.com>
References: <D31BF6EF-2E01-434F-BA36-B3939DC5F9EE@kupper.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Kupper <thomas@kupper.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <D31BF6EF-2E01-434F-BA36-B3939DC5F9EE@kupper.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2010 at 12:55 AM, Thomas Kupper <thomas@kupper.org> wro=
te:
> Using btrfs as the root filesystem on my Ubuntu 9.10 powered laptop I=
 discoverd that mount is not showing the actual passed rootflags=3D but=
 shows what is put in the /etc/fstab.
>
> First of all, I'm not sure if that is an intended behavior and if not=
, if it's a problem of mount or btrfs.
>
> Example:
> Following Goffredo's example there's a subvolume called rootfs which =
is - surprisingly ;) - the root of the linux. The corresponding line in=
 fstab is
>
> $ cat /etc/fstab
> [...]
> # / was on /dev/sda3 during installation
> UUID=3D<some-scary-UUID> =A0 / =A0 btrfs =A0 subvol=3Drootfs =A0 0 =A0=
 1
>
> $ mount
> [...]
> /dev/sda3 on / type btrfs (rw,subvol=3Drootfs)
>
> I create a snapshot of the rootfs called rootfs-snap-001 and create i=
t in the / of the btrfs volume itself. Not modifying grub2, I just edit=
 grub on the go. While booting I edit the /linux-kernel... entry and re=
place rootflags=3Dsubvol=3Drootfs with rootflags=3Dsubvol=3Drootfs-snap=
-001. That boots up just fine but the mount output still is
>
> $ mount
> [...]
> /dev/sda3 on / type btrfs (rw,subvol=3Drootfs)
>
> ... and /etc/mtab is indeed
>
> $ cat /etc/mtab
> [...]
> /dev/sda3 / btrfs rw,subvol=3Drootfs 0 0
>
> shouldn't mount and /etc/mtab reflect the parameters in use?
>

No. The same thing happens with whatever filesystem you use for rootfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
