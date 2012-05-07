From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 14:06:00 +0200
Message-ID: <C8PC6cp9CXB@helmut.hullen.de>
References: <CAG1y0sexbX2G0Kmb3RmzJN0hhN-UrE_cUSEUGLT_AYVkMXDgBA@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sexbX2G0Kmb3RmzJN0hhN-UrE_cUSEUGLT_AYVkMXDgBA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Fajar,

Du meintest am 07.05.12:

>> For some months I run btrfs unter kernel 3.2.5 and 3.2.9, without
>> problems.
>>
>> Yesterday I compiled kernel 3.3.4, and this morning I started the
>> machine with this kernel. There may be some ugly problems.


>> Data, RAID0: total=3D5.29TB, used=3D4.29TB

> Raid0? Yaiks!

Why not?
You know the price of 1 3-TByte disk?
The data isn't irreproducible, in this case.

[...]

>> May =A07 07:15:19 Arktur kernel: sd 5:0:0:0: rejecting I/O to offlin=
e
>> device
>> May =A07 07:15:19 Arktur kernel: end_request: I/O error, dev
>> sdf, sector 0
>> May =A07 07:15:19 Arktur kernel: sd 5:0:0:0: rejecting
>> I/O to offline device
>> May =A07 07:15:19 Arktur kernel: lost page write
>> due to I/O error on sdf1


> That looks like a bad disk to me, and it shouldn't be related to the
> kernel version you use.

But why does it happen just when I change the kernel?
(Yes - I know: Murphy works reliable ...)

> Your best chance might be:
> - unmount the fs
> - get another disk to replace /dev/sdf, copy the content over with
> dd_rescue. Ata resets can be a PITA, so you might be better of by
> moving the failed disk to a usb external adapter, and du some
> creative combination of plug-unplug and selectively skip bad sectors
> manually (by passing "-s" to dd_rescue).

Hmmm - I'll take a try ...


> - reboot, with the bad disk unplugged
> - (optional) run "btrfs filesystem scrub" (you might need to build
> btrfs-progs manually from git source).

Last time I'd tried this command (some months ago) it had produced a =20
completely unusable system of disks/partitions ...


> or simply read the entire fs
> (e.g. using tar to /dev/null, or whatever). It should check the
> checksum of all files and print out which files are damaged (either
> in stdout or syslog).

And that's the other try - I had to use it for another disk (also WD, =20
but only 2 TByte - I could watch how it died ...).

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
