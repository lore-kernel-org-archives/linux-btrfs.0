From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Sun, 29 Jan 2012 05:40:16 +0000 (UTC)
Message-ID: <pan.2012.01.29.05.40.16@cox.net>
References: <pan.2012.01.26.15.41.32@cox.net>
	<201201281308.52291.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sat, 28 Jan 2012 13:08:52 +0100 as excerpt=
ed:

> Am Donnerstag, 26. Januar 2012 schrieb Duncan:

>> The current layout has a total of 16 physical disk partitions on eac=
h
>> of the four drives, mostly of which are 4-disk md/raid1, but with a
>> couple md/raid1s for local cache of redownloadables, etc, thrown in.
>> Some of the mds are further partitioned (mdp), some not.  A couple a=
re
>> only 2- disk md/raid1 instead of the usual 4-disk.  Most mds have a
>> working and backup copy of exactly the same partitioned size, thus
>> explaining the multitude of partitions, since most of them come in
>> pairs.  No lvm as I'm not running an initrd which meant it couldn't
>> handle root, and I wasn't confident in my ability to recover the sys=
tem
>> in an emergency with lvm either, so I was best off without it.
>=20
> Sounds like a quite complex setup.

It is.  I was actually writing a rather more detailed description, but=20
decided few would care and it'd turn into a tl;dr.  It was I think the=20
4th rewrite that finally got it down to something reasonable while stil=
l=20
hopefully conveying any details that might be corner-cases someone know=
s=20
something about.

>> Three questions:
>>=20
>> 1) My /boot partition and its backup (which I do want to keep separa=
te
>> from root) are only 128 MB each.  The wiki recommends 1 gig sizes
>> minimum, but there's some indication that's dated info due to mixed
>> data/ metadata mode in recent kernels.
>>=20
>> Is a 128 MB btrfs reasonable?  What's the mixed-mode minumum
>> recommended and what is overhead going to look like?
>=20
> I don=C2=B4t know.
>=20
> You could try with a loop device. Just create one and mkfs.btrfs on i=
t,
> mount it and copy your stuff from /boot over to see whether that work=
s
> and how much space is left.

The loop device is a really good idea that hadn't occurred to me.  Than=
ks!

> On BTRFS I recommend using btrfs filesystem df for more exact figures=
 of
> space utilization that df would return.

Yes.  I've read about the various space reports on the wiki so have the=
=20
general idea, but will of course need to review it again after I get=20
something setup so I can actually type in the commands and see for=20
myself.  Still, thanks for the reinforcement.  It certainly won't hurt,=
=20
and of course it's quite possible that others will end up reading this=20
too, so it could end up being a benefit to many people, not just me. =3D=
:^)

> You may try with:
>=20
>        -M, --mixed
>               Mix  data  and  metadata  chunks together for more
>               efficient space utilization.  This feature  incurs a=20
>               performance  penalty in larger filesystems.  It is
>               recommended for use with filesystems of  1  GiB or
>               smaller.
>=20
> for smaller partitions (see manpage of mkfs.btrfs).

I had actually seen that too, but as it's newer there's significantly=20
less mentions of it out there, so the reinforcement is DEFINITELY=20
valued!  I like to have a rather good general sysadmin's idea of what's=
=20
going on and how everything fits together, as opposed to simply followi=
ng=20
instructions by rote, before I'm really comfortable with something as=20
critical as filesystem maintenance (keeping in mind that when one reall=
y=20
tends to need that knowledge is in an already stressful recovery=20
situation, very possibly without all the usual documentation/net-
resources available), and repetition of the basics helps getting=20
comfortable with it, so I'm very happy for it even if it isn't "new" to=
=20
me. =3D:^)  (As mentioned, that was a big reason behind my ultimate=20
rejection of LVM, I simply couldn't get comfortable enough with it to b=
e=20
confident of my ability to recover it in an emergency recovery situatio=
n.)

>> 2)  The wiki indicates that btrfs-raid1 and raid-10 only mirror data=
 2-
>> way, regardless of the number of devices.  On my now aging disks, I
>> really do NOT like the idea of only 2-copy redundancy.  I'm far happ=
ier
>> with the 4-way redundancy, twice for the important stuff since it's =
in
>> both working and backup mds altho they're on the same 4-disk set (th=
o I
>> do have an external drive backup as well, but it's not kept as
>> current).
>>=20
>> If true that's a real disappointment, as I was looking forward to
>> btrfs- raid1 with checksummed integrity management.
>=20
> I didn=C2=B4t see anything like this.
>=20
> Would be nice to be able to adapt the redundancy degree where possibl=
e.

I posted the wiki reference in reply to someone else recently.  Let's s=
ee=20
if I can find it again...

Here it is.  This is from the bottom of the RAID and data replication=20
section (immediately above "Balancing") on the SysadminGuide page:

>>>>>
With RAID-1 and RAID-10, only two copies of each byte of data are=20
written, regardless of how many block devices are actually in use on th=
e=20
filesystem.=20
<<<<<

But that's one of the bits that I hoped was stale, and that it allowed=20
setting the number of copies for both data and metadata, now.  However,=
 I=20
don't see any options along that line to feed to mkfs.btrfs or btrfs *=20
either one, so it would seem it's not there yet, at least not in btrfs-
tools as built just a couple days ago from the official/mason tree on=20
kernel.org.  I haven't tried the integration tree (aka Hugo Mills' aka=20
darksatanic.net tree).  So I guess that wiki quote is still correct.  O=
h,=20
well... maybe later-this-year/in-a-few-kernel-cycles.

> An idea might be splitting into a delayed synchronisation mirror:
>=20
> Have two BTRFS RAID-1 - original and backup - and have a cronjob with
> rsync mirroring files every hour or so. Later this might be replaced =
by
> btrfs send/receive - or by RAID-1 with higher redundancy.

That's an interesting idea.  However, as I run git kernels and don't=20
accumulate a lot of uptime in any case, what I'd probably do is set up=20
the rsync to be run after a successful boot or mount of the filesystem =
in=20
question.  That way, if it ever failed to boot/mount for whatever reaso=
n,=20
I could be relatively confident that the backup version remained intact=
=20
and usable.

That's actually /quite/ an interesting idea.  While I have working and=20
backup partitions for most stuff now, the process remains a manual one,=
=20
when I think the system is stable enough and enough time has passed sin=
ce=20
the last one, so the backup tends to be weeks or months old as opposed =
to=20
days or hours.  This idea, modified to do it once per boot or mount or=20
whatever, would keep the backups far more current and be much less hass=
le=20
than the manual method I'm using now.  So even if I don't immediately=20
switch to btrfs as I had thought I might, I can implement those scripts=
=20
on the current system now, and then they'll be ready and tested, needin=
g=20
little modification when I switch to btrfs, later.

Thanks for the ideas! =3D:^)

>> 3) How does btrfs space overhead (and ENOSPC issues) compare to
>> reiserfs with its (default) journal and tail-packing?  My existing
>> filesystems are 128 MB and 4 GB at the low end, and 90 GB and 16 GB =
at
>> the high end.  At the same size, can I expect to fit more or less da=
ta
>> on them?  Do the compression options change that by much "IRL"?  Giv=
en
>> that I'm using same- sized partitions for my raid-1s, I guess at lea=
st
>> /that/ angle of it's covered.
>=20
> The efficiency of the compression options depend highly of the kind o=
f
> data you want to store.
>=20
> I tried lzo on a external disk with movies, music files, images and
> software archives. The effect has been minimal, about 3% or so. But f=
or
> unpacked source trees, lots of clear text files, likely also virtual
> machine image files or other nicely compressible data the effect shou=
ld
> be better.

Back in the day, MS-DOS 6.2 on a 130 MB hard drive, I used to run MS=20
Drivespace (which I guess they partnered with Stacker to get the tech=20
for, then dropped the Stacker partnership like a hot potato after they'=
d=20
sucked out all the tech they wanted, killing Stacker in the process...)=
,=20
so I'm familiar with the idea of filesystem or lower integrated=20
compression and realize that it's definitely variable.  I was just=20
wondering what the real-life usage scenarios had come up with, realizin=
g=20
even as I wrote it that the question wasn't one that could be answered =
in=20
anything but general terms.

But I run Gentoo and thus deal with a lot of build scripts, etc, plus t=
he=20
usual *ix style plain text config files, etc, so I expect for that=20
compression will be pretty good.  Rather less so on the media and bzip-
tarballed binpkgs partitions, certainly, with the home partition likely=
=20
intermediate since it has a lot of plain text /and/ a lot of pre-
compressed data.

Meanwhile, even without a specific answer, just the discussion is helpi=
ng=20
to clarify my understanding and expectations regarding compression, so=20
thanks.

> Although BTRFS received a lot of fixes for ENOSPC issues I would be a
> bit reluctant with very small filesystems. But that is just a gut
> feeling. So I do not know whether the option -M from above is tested
> widely. I doubt it.

The only real small filesystem/raid I have is /boot, the 128 MB=20
mentioned.  But in thinking it over a bit more since I wrote the initia=
l=20
post, I realized that given the 9-ish gigs of unallocated freespace at=20
the end of the drives and the fact that most of the partitions are at a=
=20
quarter-gig offset due to the 128 MB /boot and the combined 128 MB BIOS=
=20
and UEFI reserved partitions, I have room to expand both by several=20
times, and making the total of all 3 (plus the initial few sectors of=20
unpartitioned boot area) at the beginning of the drive an even 1 gig=20
would give me even gig offsets for all the other partitions/raids as we=
ll.

So I'll almost certainly expand /boot from 1/8 gig to 1/4 gig, and mayb=
e=20
to half or even 3/4 gig, just so the offsets for everything else end up=
=20
at even half or full gig boundaries, instead of the quarter-gig I have=20
now.  Between that and mixed-mode, I think the potential sizing issue o=
f=20
/boot pretty much disappears.  One less problem to worry about. =3D:^)


So the big sticking point now is two-copy-only data on btrfs-raid1,=20
regardless of the number of drives, and sticking that on top of md/raid=
's=20
a workaround, tho obviously I'd much rather a btrfs that could mirror=20
both data and metadata an arbtrary number of ways instead of just two. =
=20
(There's some hints that metadata at least gets mirrored to all drives =
in=20
a btrfs-raid1, tho nothing clearly states it one way or another.  But=20
without data mirrored to all drives as well, I'm just not comfortable.)

But while not ideal, the data integrity checking of two-way btrfs-raid1=
=20
on two-way md/raid1 should at least be better than entirely unverified
4-way md/raid1, and I expect the rest will come over time, so I could=20
simply upgrade anyway.

OTOH, in general as I've looked closer, I've found btrfs to be rather=20
farther away from exiting experimental than the prominent adoption by=20
various distros had led me to believe, and without N-way mirroring raid=
,=20
one of the two big features that I was looking forward to (the other=20
being the data integrity checking) just vaporized in front of my eyes, =
so=20
I may well hold off on upgrading until, potentially, late this year=20
instead of early this year, even if there are workarounds.  I'm just no=
t=20
sure it's worth the cost of dealing with the still experimental aspects=
=2E


Either way, however, this little foray into previously unexplored=20
territory leaves me with a MUCH firmer grasp of btrfs.  It's no longer=20
simply a vague filesystem with some vague features out there.

And now that I'm here, I'll probably stay on the list as well, as I've=20
already answered a number of questions posted by others, based on the=20
material in the wiki and manpages, so I think I have something to=20
contribute, and keeping up with developments will be far easier if I st=
ay=20
involved.


Meanwhile, again and overall, thanks for the answer.  I did have most o=
f=20
the bits of info I needed there floating around, but having someone to=20
discuss my questions with has definitely helped solidify the concepts,=20
and you've given me at least two very good suggestions that were entire=
ly=20
new to me and that would have certainly taken me quite some time to com=
e=20
up with on my own, if I'd been able to do so at all, so thanks, indeed!=
=20
=3D:^)

--=20
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
