Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53763 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaL0Ky6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 05:54:58 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 11:54:48 +0100
Message-ID: <3538352.CI4nobbHtu@merkaba>
In-Reply-To: <20141227093043.GJ25267@carfax.org.uk>
References: <3738341.y7uRQFcLJH@merkaba> <4232026.31LFOYpm2s@merkaba> <20141227093043.GJ25267@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3582830.MOz6nPftOX"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3582830.MOz6nPftOX
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Samstag, 27. Dezember 2014, 09:30:43 schrieb Hugo Mills:
> On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrote:
> > Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
> > > On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> > > > Hello!
> > > >=20
> > > > First: Have a merry christmas and enjoy a quiet time in these d=
ays.
> > > >=20
> > > > Second: At a time you feel like it, here is a little rant, but =
also a
> > > > bug
> > > > report:
> > > >=20
> > > > I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RA=
ID with
> > > > space_cache, skinny meta data extents =E2=80=93 are these a pro=
blem? =E2=80=93 and
> > >=20
> > > > compress=3Dlzo:
> > > (there is no known problem with skinny metadata, it's actually mo=
re
> > > efficient than the older format. There has been some anecdotes ab=
out
> > > mixing the skinny and fat metadata but nothing has ever been
> > > demonstrated problematic.)
> > >=20
> > > > merkaba:~> btrfs fi sh /home
> > > > Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
> > > >=20
> > > >          Total devices 2 FS bytes used 144.41GiB
> > > >          devid    1 size 160.00GiB used 160.00GiB path
> > > >          /dev/mapper/msata-home
> > > >          devid    2 size 160.00GiB used 160.00GiB path
> > > >          /dev/mapper/sata-home
> > > >=20
> > > > Btrfs v3.17
> > > > merkaba:~> btrfs fi df /home
> > > > Data, RAID1: total=3D154.97GiB, used=3D141.12GiB
> > > > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > > > Metadata, RAID1: total=3D5.00GiB, used=3D3.29GiB
> > > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> > >=20
> > > This filesystem, at the allocation level, is "very full" (see bel=
ow).
> > >=20
> > > > And I had hangs with BTRFS again. This time as I wanted to inst=
all tax
> > > > return software in Virtualbox=C2=B4d Windows XP VM (which I use=
 once a year
> > > > cause I know no tax return software for Linux which would be su=
itable
> > > > for
> > > > Germany and I frankly don=C2=B4t care about the end of security=
 cause all
> > > > surfing and other network access I will do from the Linux box a=
nd I
> > > > only
> > > > run the VM behind a firewall).
> > >=20
> > > > And thus I try the balance dance again:
> > > ITEM: Balance... it doesn't do what you think it does... 8-)
> > >=20
> > > "Balancing" is something you should almost never need to do. It i=
s only
> > > for cases of changing geometry (adding disks, switching RAID leve=
ls,
> > > etc.) of for cases when you've radically changed allocation behav=
iors
> > > (like you decided to remove all your VM's or you've decided to re=
move a
> > > mail spool directory full of thousands of tiny files).
> > >=20
> > > People run balance all the time because they think they should. T=
hey are
> > > _usually_ incorrect in that belief.
> >=20
> > I only see the lockups of BTRFS is the trees *occupy* all space on =
the
> > device.
>    No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored metadata=

> space. What's more, balance does *not* balance the metadata trees. Th=
e
> remaining space -- 154.97 GiB -- is unstructured storage for file
> data, and you have some 13 GiB of that available for use.

Ok, let me rephrase that: Then the space *reserved* for the trees occup=
ies all=20
space on the device. Or okay, when that I see in btrfs fi df as "total"=
 in=20
summary occupies what I see as "size" in btrfs fi sh, i.e. when "used" =
equals=20
space in "btrfs fi sh"

What happened here is this:

I tried

 https://blogs.oracle.com/virtualbox/entry/how_to_compact_your_virtual

in order to regain some space from the Windows XP VDI file. I just want=
ed to=20
get around upsizing the BTRFS again.

And on the defragementation step in Windows it first ran fast. For abou=
t 46-47%=20
there, during that fast phase btrfs fi df showed that BTRFS was quickly=
=20
reserving the remaining free device space for data trees (not metadata)=
.

Only after a while after it did so, it got slow again, basically the Wi=
ndows=20
defragmentation process stopped at 46-47% altogether and then after a w=
hile=20
even the desktop locked due to processes being blocked in I/O.

I decided to forget about this downsizing of the Virtualbox VDI file, i=
t will=20
extend again on next Windows work and it is already 18 GB of its maximu=
m 20GB,=20
so=E2=80=A6 I dislike the approach anyway, and don=C2=B4t even understa=
nd why the=20
defragmentation step would be necessary as I think Virtualbox can poke =
holes=20
into the file for any space not allocated inside the VM, whether it is=20=

defragmented or not.

>    Now, since you're seeing lockups when the space on your disks is
> all allocated I'd say that's a bug. However, you're the *only* person=

> who's reported this as a regular occurrence. Does this happen with al=
l
> filesystems you have, or just this one?

The *only* person? The compression lockups with 3.15 and 3.16, quite so=
me=20
people saw them, I thought. For me also these lockups only happened wit=
h all=20
space on device allocated.

And these seem to be gone. In regular use it doesn=C2=B4t lockup totall=
y hard. But=20
in the a processes writes a lot into one big no-cowed file case, it see=
ms it=20
can still get into a lockup, but this time one where a kworker thread c=
onsumes=20
100% of CPU for minutes.

> > I *never* so far saw it lockup if there is still space BTRFS can al=
locate
> > from to *extend* a tree.
>=20
>    It's not a tree. It's simply space allocation. It's not even space=

> *usage* you're talking about here -- it's just allocation (i.e. the F=
S
> saying "I'm going to use this piece of disk for this purpose").

Okay, I thought it is the space BTRFS reserves for a tree or well the *=
chunks*=20
the tree manages. I am aware of that it isn=C2=B4t already *used* space=
, its just=20
*reserved*

> > This may be a bug, but this is what I see.
> >=20
> > And no amount of "you should not balance a BTRFS" will make that
> > perception go away.
> >=20
> > See, I see the sun coming out on a morning and you tell me "no, it
> > doesn=C2=B4t". Simply that is not going to match my perception.
>=20
>    Duncan's assertion is correct in its detail. Looking at your space=

> usage, I would not suggest that running a balance is something you
> need to do. Now, since you have these lockups that seem quite
> repeatable, there's probably a lurking bug in there, but hacking
> around with balance every time you hit it isn't going to get the
> problem solved properly.

It was Robert writing this I think.

Well I do not like to balance the FS, but I see the result, I see that =
it=20
helps here. And thats about it.

My theory from watching the Windows XP defragmentation case is this:

=2D For writing into the file BTRFS needs to actually allocate and use fr=
ee space=20
in the current tree allocation, or, as we seem to misunderstood from th=
e words=20
we use, it needs to fit data in

Data, RAID1: total=3D144.98GiB, used=3D140.94GiB

between 144,98 GiB and 140,94 GiB given that total space of this tree, =
or if=20
its not a tree, but the chunks in that the tree manages, in these chunk=
s can=20
*not* be extended anymore.

System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.24GiB

=2D What I see now is as long as it can be extended, BTRFS on this worklo=
ad=20
*happily* does so. *Quickly*. Up to the amount of the free, unreserved =
space=20
of the device. And *even* if in my eyes there is a big enough differenc=
e=20
between total and used in btrfs fi df.

=2D Then as all the device space is *reserved*, BTRFS needs to fit the al=
location=20
within the *existing* chunks instead of reserving a new one and fill th=
e empty=20
one. And I think this is where it gets problems.


I extended both devices of /home by 10 GiB now and I was able to comlet=
e some=20
balance steps with these results.

Original after my last partly failed balance attempts:

Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 144.20GiB
        devid    1 size 170.00GiB used 159.01GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 170.00GiB used 159.01GiB path /dev/mapper/sata-=
home

Btrfs v3.17
merkaba:~> btrfs fi df /home
Data, RAID1: total=3D153.98GiB, used=3D140.95GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.25GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


Then balancing, but not all of them:

merkaba:~#1> btrfs balance start -dusage=3D70 /home
Done, had to relocate 9 out of 162 chunks
merkaba:~> btrfs fi df /home                  =20
Data, RAID1: total=3D146.98GiB, used=3D140.95GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.25GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
merkaba:~> btrfs balance start -dusage=3D80 /home
Done, had to relocate 9 out of 155 chunks
merkaba:~> btrfs fi df /home                  =20
Data, RAID1: total=3D144.98GiB, used=3D140.94GiB
System, RAID1: total=3D32.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.24GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 144.19GiB
        devid    1 size 170.00GiB used 150.01GiB path /dev/mapper/msata=
=2Dhome
        devid    2 size 170.00GiB used 150.01GiB path /dev/mapper/sata-=
home

Btrfs v3.17


This is a situation where I do not see any slowdowns with BTRFS.

As far as I understand the balance commands I used I told BTRFS the fol=
lowing:

=2D go and balance all chunks that has 70% or less used
=2D go and balance all chunks that have 80% or less used

I rarely see any chunks that have 60% or less used and get something li=
ke this=20
if I try:

merkaba:~> btrfs balance start -dusage=3D60 /home
Done, had to relocate 0 out of 153 chunks



Now my idea is this: BTRFS will need to satisfy the allocations it need=
 to do=20
for writing heavily into a cow=C2=B4ed file from the already reserved s=
pace. Yet if=20
I have lots of chunks that are filled between 60-70% it needs to spread=
 the=20
allocations in the 40-30% of the chunk that are not yet used.

My theory is this: If BTRFS needs to do this *heavily*, it at some time=
 gets=20
problems while doing so. Apparently it seems *easier* to just reserve a=
 new=20
chunk and fill the fresh chunk then. Otherwise I don=C2=B4t know why BT=
RFS is doing=20
it like this. It prefers to reserve free device space on this defragmen=
tation=20
inside VM then.

And these issues may be due to an inefficient implementation or bug.

Now if no one else if ever having this, this may be a speciality with m=
y=20
filesystem and heck I can recreate it from scratch if need be. Yet I wo=
uld=20
prefer to find out what is happening here.


>    I think I would suggest the following:
>=20
>  - make sure you have some way of logging your dmesg permanently (use=

>    a different filesystem for /var/log, or a serial console, or a
>    netconsole)
>=20
>  - when the lockup happens, hit Alt-SysRq-t a few times
>=20
>  - send the dmesg output here, or post to bugzilla.kernel.org
>=20
>    That's probably going to give enough information to the developers=

> to work out where the lockup is happening, and is clearly the way
> forward here.

Thanks, I think this seems to be a way to go.

Actually the logging should be safe I=C2=B4d say, cause it wents into a=
 different=20
BTRFS. The BTRFS for /, which is also a RAID 1 and which didn=C2=B4t sh=
ow this=20
behavior yet, although it has also all space reserved since quite some =
time:

merkaba:~> btrfs fi sh /                      =20
Label: 'debian'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 17.79GiB
        devid    1 size 30.00GiB used 30.00GiB path /dev/mapper/sata-de=
bian
        devid    2 size 30.00GiB used 30.00GiB path /dev/mapper/msata-d=
ebian

Btrfs v3.17
merkaba:~> btrfs fi df /
Data, RAID1: total=3D27.99GiB, used=3D17.21GiB
System, RAID1: total=3D8.00MiB, used=3D16.00KiB
Metadata, RAID1: total=3D2.00GiB, used=3D596.12MiB
GlobalReserve, single: total=3D208.00MiB, used=3D0.00B


*Unlike* if one BTRFS locks up the other will also lock up, logging sho=
uld be=20
safe.

Actually I got the last task hung messages as I posted them here. So I =
may=20
just try to reproduce this and trigger

echo "t" > /proc/sysrq-trigger

this gives

[32459.707323] systemd-journald[314]: /dev/kmsg buffer overrun, some me=
ssages=20
lost.

but I bet rsyslog will capture it just nice. I may even disable journal=
d to=20
reduce writes to / during reproducing the bug.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart3582830.MOz6nPftOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSej/wACgkQmRvqrKWZhMd6dQCfelrhojE8Jkdp3lAZ/ZXT2aIB
s8YAn3eh/caxqi4UUQbpBDrYfgZTeLTh
=SSav
-----END PGP SIGNATURE-----

--nextPart3582830.MOz6nPftOX--

