From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Sat, 28 Jan 2012 13:08:52 +0100
Message-ID: <201201281308.52291.Martin@lichtvoll.de>
References: <pan.2012.01.26.15.41.32@cox.net> (sfid-20120126_174942_231204_14CD6FFC)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.26.15.41.32@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 26. Januar 2012 schrieb Duncan:
> I'm currently researching an upgrade to (raid1-ed) btrfs from mostly
> reiserfs (which I've found quite reliable (even thru a period of bad
> ram and resulting system crashes) since data=3Dordered went in with
> 2.6.16 or whatever it was.  (Thanks, Chris! =3D:^)) on multiple
> md/raid-1s.  I have some questions that don't appear to be addressed
> well on the wiki, yet, or where the wiki info might be dated.
>=20
> Device hardware is 4 now aging 300-gig disks with identical gpt-
> partitioning on all four disks, using multiple 4-way md/raid-1s for
> most of the system.  I'm running gentoo/~amd64 with the linus mainlin=
e
> kernel from git, kernel generally updated 1-2X/wk except during the
> merge window, so I stay reasonably current.  I have btrfs-progs-9999,
> aka the live-git build, kernel.org mason tree, installed.
>=20
> The current layout has a total of 16 physical disk partitions on each
> of the four drives, mostly of which are 4-disk md/raid1, but with a
> couple md/raid1s for local cache of redownloadables, etc, thrown in.=20
> Some of the mds are further partitioned (mdp), some not.  A couple ar=
e
> only 2- disk md/raid1 instead of the usual 4-disk.  Most mds have a
> working and backup copy of exactly the same partitioned size, thus
> explaining the multitude of partitions, since most of them come in
> pairs.  No lvm as I'm not running an initrd which meant it couldn't
> handle root, and I wasn't confident in my ability to recover the
> system in an emergency with lvm either, so I was best off without it.

Sounds like a quite complex setup.

> Three questions:
>=20
> 1) My /boot partition and its backup (which I do want to keep separat=
e
> from root) are only 128 MB each.  The wiki recommends 1 gig sizes
> minimum, but there's some indication that's dated info due to mixed
> data/ metadata mode in recent kernels.
>=20
> Is a 128 MB btrfs reasonable?  What's the mixed-mode minumum
> recommended and what is overhead going to look like?

I don=C2=B4t know.

You could try with a loop device. Just create one and mkfs.btrfs on it,=
=20
mount it and copy your stuff from /boot over to see whether that works =
and=20
how much space is left.

On BTRFS I recommend using btrfs filesystem df for more exact figures o=
f=20
space utilization that df would return.

Likewise for RAID 1, just create 2 or 4 BTRFS image files.

You may try with:

       -M, --mixed
              Mix  data  and  metadata  chunks together for more
              efficient space utilization.  This feature  incurs
              a  performance  penalty in larger filesystems.  It
              is recommended for use with filesystems of  1  GiB
              or smaller.

for smaller partitions (see manpage of mkfs.btrfs).
=20
> 2)  The wiki indicates that btrfs-raid1 and raid-10 only mirror data =
2-
> way, regardless of the number of devices.  On my now aging disks, I
> really do NOT like the idea of only 2-copy redundancy.  I'm far happi=
er
> with the 4-way redundancy, twice for the important stuff since it's i=
n
> both working and backup mds altho they're on the same 4-disk set (tho=
 I
> do have an external drive backup as well, but it's not kept as
> current).
>=20
> If true that's a real disappointment, as I was looking forward to
> btrfs- raid1 with checksummed integrity management.

I didn=C2=B4t see anything like this.

Would be nice to be able to adapt the redundancy degree where possible.

An idea might be splitting into a delayed synchronisation mirror:

Have two BTRFS RAID-1 - original and backup - and have a cronjob with=20
rsync mirroring files every hour or so. Later this might be replaced by=
=20
btrfs send/receive - or by RAID-1 with higher redundancy.

> 3) How does btrfs space overhead (and ENOSPC issues) compare to
> reiserfs with its (default) journal and tail-packing?  My existing
> filesystems are 128 MB and 4 GB at the low end, and 90 GB and 16 GB a=
t
> the high end.  At the same size, can I expect to fit more or less dat=
a
> on them?  Do the compression options change that by much "IRL"?  Give=
n
> that I'm using same- sized partitions for my raid-1s, I guess at leas=
t
> /that/ angle of it's covered.

The efficiency of the compression options depend highly of the kind of =
data=20
you want to store.

I tried lzo on a external disk with movies, music files, images and=20
software archives. The effect has been minimal, about 3% or so. But for=
=20
unpacked source trees, lots of clear text files, likely also virtual=20
machine image files or other nicely compressible data the effect should=
 be=20
better.

Although BTRFS received a lot of fixes for ENOSPC issues I would be a b=
it=20
reluctant with very small filesystems. But that is just a gut feeling. =
So I=20
do not know whether the option -M from above is tested widely. I doubt =
it.

Maybe someone with more in-depth knowledge can shed some light on this.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
