From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Strangeness on btrfs balance..
Date: 05 Feb 2011 12:34:00 +0100
Message-ID: <BfIFFcRi1uB@helmut.hullen.de>
References: <AANLkTin=G4c90Ew44gg=4E4joJPf6wizww=jqS0g8o1D@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin=G4c90Ew44gg=4E4joJPf6wizww=jqS0g8o1D@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Evert,

Du meintest am 05.02.11:

> I have kernel version 2.6.36.3, compiled with gcc 4.4.5, btrfstools
> version 0.19+20101101

> I have a btrfs filesystem (/data) consisting of two 1TB hard disks,
> raid0.

> I added in another 1TB hard drive.

> root@X86-64:~# btrfs filesystem show
> failed to read /dev/sdh
> failed to read /dev/sdg
> failed to read /dev/sdf
> failed to read /dev/sde
> failed to read /dev/sr0
> failed to read /dev/fd0u800
> failed to read /dev/fd0

That's a "well known" error; the fix isn't yet implemented.

> Any idea of why this is happening?
> Last few lines of dmesg:
> floppy0: disk absent or changed during operation
> end_request: I/O error, dev fd0, sector 128
> end_request: I/O error, dev fd0, sector 0

May be that's another "well known" error; there is a fix too ...


> btrfs: found 69 extents
> btrfs: relocating block group 1897465380864 flags 9
> btrfs: found 95 extents
> btrfs: found 95 extents
> btrfs: relocating block group 1895317897216 flags 9
> btrfs: found 81 extents
> btrfs: found 81 extents

Just wait some time.
When I remember correctly: the "relocating" message appears every minute  
(slightly rounded).
In your example there's a difference of about 1/1000, you have to wait  
about 1000 minutes.

Viele Gruesse!
Helmut
