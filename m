From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Single drive volume + second drive -> RAID1?
Date: Thu, 26 Jan 2012 10:27:33 +0000 (UTC)
Message-ID: <pan.2012.01.26.10.27.33@cox.net>
References: <CAEPoJ-1PXu9Pt9E1EEudJ5NN-RunT4POJtjzo=BVRiOn_F97ng@mail.gmail.com>
	<CAEPoJ-34AmiaRpSCk4Whby4gDM6PSKYRyLHmG1my5_WFODaNrQ@mail.gmail.com>
	<20120123092514.GA5531@carfax.org.uk>
	<CAEPoJ-2Sa2wiJf2osak5vPMYg=FtR=2f0M7vKK6cdopqB=aLwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

James posted on Mon, 23 Jan 2012 13:17:53 -0800 as excerpted:

> On Mon, Jan 23, 2012 at 1:25 AM, Hugo Mills <hugo@carfax.org.uk> wrot=
e:
>> =C2=A0 Why not just create the filesystem as RAID-1 in the first pla=
ce?
>>
>> # mkfs.btrfs -d raid1 -m raid1 /dev/sda1 /dev/sdb1
>=20
> As I said, I've only got two working drives large enough at present.
>=20
>> =C2=A0 Then you can restore from your backups. You do have backups, =
right?
>> (Remember, this is a filesystem still marked as "experimental").
>=20
> Yes, I know. :) I just have remote backups,

=46irst post to the list, as I'm just planning my switch to btrfs... du=
e to=20
which I just read much of the wiki and thus have it fresh in mind...

Take a look at the UseCases page on the wiki.  There's several items of=
=20
interest there that should be very useful to you right now.  Here's the=
=20
link altho the below actually has a bit more detail than the wiki (but=20
the wiki obviously has other useful information not apropos to this=20
situation):

https://btrfs.wiki.kernel.org/articles/u/s/e/UseCases_8bd8.html


=46irst:

Creating a btrfs-raid-1 in "degraded mode", that is, with a missing=20
drive, to be added later: Apparently it's not possible to do that=20
directly yet, but there's a trick to work around the issue that sounds=20
like just what you need ATM.

The idea is to create a "small" (the example in the wiki uses 4 GB, I=20
guess I'm getting old as that doesn't seem all that small to me!!) "fak=
e"=20
device using loopback to serve as the "missing" device, create the=20
filesystem specifying raid-1 for both data and metadata (-m raid1 -d=20
raid1) giving mkfs both the real and loopback devices to work with, the=
n=20
delete the loopback device and remove the file backing it, so that all=20
that's left is the single "real" device:

dd if=3D/dev/zero of=3D/tmp/empty bs=3D1 count=3D0 seek=3D4G
losetup /dev/loop1 /tmp/empty
mkfs.btrfs -m raid1 -d raid1 /dev/sda1 /dev/loop1
losetup -d /dev/loop1
rm /tmp/empty

I immediately thought of the possibility of sticking that temporary=20
loopback device file on a USB thumbdrive if necessary...

You should then be able to copy everything over to the new btrfs=20
operating in degraded raid-1.  After testing to ensure it's there and=20
usable (bootable if that's your intention), you can blank the old drive=
=2E =20
Adding it in to complete the raid-1 is then done this way:

mount /dev/sda1 /mnt
btrfs dev add /dev/sdb1 /mnt


Second:

This note might explain why you ended up with raid-0 where you thought=20
you had raid-1:

(kernel 2.6.37) Simply creating the filesystem with too few devices wil=
l=20
result in a RAID-0 filesystem. (This is probably a bug).


Third:

To verify that btrfs is using the raid level you expect:

On a 2.6.37 or later kernel, use

btrfs fi df /mountpoint

The required support was broken accidentally in earlier kernels, but ha=
s=20
now been fixed.


NB:  As I mentioned above I'm only researching btrfs for my systems now=
,=20
so obviously have no clue how the above suggestions work in practice. =20
They're simply off the wiki.


(Now to send this via gmane.org since I'm doing the list as a newsgroup=
=20
thru them, and get the email challenge, so I can post further replies a=
nd=20
questions of my own...)

--=20
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
