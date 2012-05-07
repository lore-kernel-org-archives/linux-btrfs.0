From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 7 May 2012 17:58:13 +0700
Message-ID: <CAG1y0sexbX2G0Kmb3RmzJN0hhN-UrE_cUSEUGLT_AYVkMXDgBA@mail.gmail.com>
References: <C8PBkd9uCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PBkd9uCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 7, 2012 at 5:46 PM, Helmut Hullen <Hullen@t-online.de> wrot=
e:

> For some months I run btrfs unter kernel 3.2.5 and 3.2.9, without
> problems.
>
> Yesterday I compiled kernel 3.3.4, and this morning I started the
> machine with this kernel. There may be some ugly problems.


> Data, RAID0: total=3D5.29TB, used=3D4.29TB

Raid0? Yaiks!

> System, RAID1: total=3D8.00MB, used=3D352.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, RAID1: total=3D149.00GB, used=3D5.00GB
>
> Label: 'MMedia' =A0uuid: 9adfdc84-0fbe-431b-bcb1-cabb6a915e91
> =A0 =A0 =A0 =A0Total devices 3 FS bytes used 4.29TB
> =A0 =A0 =A0 =A0devid =A0 =A03 size 2.73TB used 1.98TB path /dev/sdi1
> =A0 =A0 =A0 =A0devid =A0 =A02 size 2.73TB used 1.94TB path /dev/sdf1
> =A0 =A0 =A0 =A0devid =A0 =A01 size 1.82TB used 1.63TB path /dev/sdc1
>


> May =A07 06:55:26 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0 =
SErr 0x10000 action 0xe frozen
> May =A07 06:55:26 Arktur kernel: ata5: SError: { PHYRdyChg }
> May =A07 06:55:26 Arktur kernel: ata5: hard resetting link
> May =A07 06:55:31 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
> May =A07 06:55:31 Arktur kernel: ata5: reset failed (errno=3D-19), re=
trying in 6 secs


> May =A07 07:15:19 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline=
 device
> May =A07 07:15:19 Arktur kernel: end_request: I/O error, dev sdf, sec=
tor 0
> May =A07 07:15:19 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline=
 device
> May =A07 07:15:19 Arktur kernel: lost page write due to I/O error on =
sdf1


That looks like a bad disk to me, and it shouldn't be related to ther
kernel version you use.

Your best chance might be:
- unmount the fs
- get another disk to replace /dev/sdf, copy the content over with
dd_rescue. Ata resets can be a PITA, so you might be better of by
moving the failed disk to a usb external adapter, and du some creative
combination of plug-unplug and selectively skip bad sectors manually
(by passing "-s" to dd_rescue).
- reboot, with the bad disk unplugged
- (optional) run "btrfs filesystem scrub" (you might need to build
btrfs-progs manually from git source). or simply read the entire fs
(e.g. using tar to /dev/null, or whatever). It should check the
checksum of all files and print out which files are damaged (either in
stdout or syslog).

I don't think there's anything you can do to recover the damaged files
(other than restore from backup), but at least you know which files
are NOT damaged.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
