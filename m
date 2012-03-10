From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: Can't write much data on a degraded mirror
Date: Sat, 10 Mar 2012 19:18:52 +0100
Message-ID: <4F5B9B0C.3010504@gmail.com>
References: <20268.13021.256682.485482@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Lutz Euler <lutz.euler@freenet.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20268.13021.256682.485482@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
=20
Hi,

Is there any way to willingly write more data to a degraded array? Ther=
e
are other use cases for such a possibility as well. Just think of
migrating from software raid (and lvm) based setup.

Thanks,
Andreas Philipp

On 03.02.2012 20:17, Lutz Euler wrote:
> Hi,
>
> Btrfs seems not to want to allocate new chunks on a degraded mirror,
> severely restricting the amount of new data that can be written to su=
ch
> a filesystem. I hope this is not intentional? It makes mirroring much
> less useful than it could be, at least for me.
>
> My use case: I want to use btrfs with two mirrored disks on a desktop
> machine. Lets say the filesystem is far from full. Assume one disk
> fails, I send it in for RMA and have to wait 6 weeks for a replacemen=
t.
> I could live without the mirror redundancy during this time but not
> without the ability to store more data on the filesystem.
>
> I would prefer if btrfs remembered the size of the missing device and
> allowed to allocate space on the degraded mirror until the capacity i=
s
> reached that the nondegraded mirror had.
>
> Here is how to reproduce the effect:
>
> Create and mount a mirror of two 20 GB devices:
>
> # dd if=3D/dev/zero of=3D/tmp/img0 bs=3D1 count=3D0 seek=3D20G
> # dd if=3D/dev/zero of=3D/tmp/img1 bs=3D1 count=3D0 seek=3D20G
> # losetup -f /tmp/img0
> # losetup -f /tmp/img1
> # losetup -a
> /dev/loop0: [0802]:1441845 (/tmp/img0)
> /dev/loop1: [0802]:1441856 (/tmp/img1)
> # mkfs.btrfs -d raid1 -m raid1 /dev/loop0 /dev/loop1
> # mount /dev/loop0 /mnt
> # df -h /mnt
> Dateisystem Size Used Avail Use% Eingeh=E4ngt auf
> /dev/loop0 40G 56K 38G 1% /mnt
>
> Umount, make one device unavailable and mount degraded:
>
> # umount /mnt
> # losetup -d /dev/loop1
> # mount -o degraded /dev/loop0 /mnt
> # df -h /mnt
> Dateisystem Size Used Avail Use% Eingeh=E4ngt auf
> /dev/loop0 40G 312K 2,0G 1% /mnt
>
> Notice that the "Avail" value has shrunk drastically; it seems
> to show only the space available in already allocated chunks.
> Now, "df" might simply lie, so let's try to put data on the filesyste=
m:
>
> # dd if=3D/dev/zero of=3D/mnt/data bs=3D4K count=3D512K
>
> -> ENOSPC after writing 1.1 GB
>
> The software used is:
>
> Kernel: v3.3-rc1-383-g0a96265
> uname -a: Linux test 3.3.0-rc1 #1 SMP PREEMPT Sun Jan 29 16:06:29 CET
> 2012 x86_64 x86_64 x86_64 GNU/Linux
> btrfs-progs: cloned on 2012-01-25 from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git,
> latest commit is fdb6c0402337d9607c7a39155088eaf033742752.
> OS: Ubuntu 11.04.
>
> Kind regards,
>
> Lutz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
=20
iQEcBAEBAgAGBQJPW5sMAAoJEIW3W1BiBxU7WaQIAI3BgB5zbfxzMKKyhlEzdjwR
2faI539BuTSz3RVpoCn8BMREVJSvfDcdT40uIV+io53IW5/0AgH8y0Tlg5HTmm5V
XtGtbT8MFpnQvSvUoWVJdDiIhlo1BNhL3KBVm5dXHQEkeviQZs1RZ0ndI1IKlnnB
gIZEYRJpb9ig9RI2HKlhKRPWDiTSyWBTEL0HuteY7jmISThCGTvnAq1b6A/mSVq6
CQvHnk7h1LbCvBBUvIxUUJewrfdnspqiGR95hAA9RGSQP7iAu7nMmi1rY0vw3cmF
+aF6r5eljvwmmdB/msDomaBYgWuf6RBV2aMZvmXigeU/g1tSbWRn3El8dBnqDZM=3D
=3Dxi/2
-----END PGP SIGNATURE-----

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
