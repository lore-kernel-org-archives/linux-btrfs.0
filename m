From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Setting options permanently?
Date: Sat, 28 Jan 2012 03:32:24 +0000 (UTC)
Message-ID: <pan.2012.01.28.03.32.23@cox.net>
References: <4F22BCCC.5090800@danisch.de>
	<CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
	<4F234616.6020407@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hadmut Danisch posted on Sat, 28 Jan 2012 01:49:26 +0100 as excerpted:

> Am 28.01.2012 00:20, schrieb Chester:
>> It should be okay to mount with compress or without compress. Even i=
f
>> you mount a volume with compressed data without '-o compress' you wi=
ll
>> still be able to correctly read the data (but newly written data wil=
l
>> not be compressed)
>=20
> But having both compressed and uncompressed files in the filesystem i=
s
> exactly what I want to avoid. Not because of reading problems, but to
> avoid wasting disk space. I don't have a reading problem. I have a
> writing problem.

Having a compression flag in the superblock (probably more than one, th=
us=20
allowing indication of compression type, etc), which is I guess what=20
you're suggesting, sounds useful to me too.  Perhaps it'll get it, once=
=20
development settles down a bit and they know enough about what's still=20
missing in the existing superblock to be able to intelligently allocate=
=20
flags, etc, on a priority basis based on what they then know they need.

At this point I can certainly see a reluctance to make that change, tho=
,=20
since it's a rather small change to make on its own, and with continuin=
g=20
tweaks to the compression types and etc, it's worth holding off=20
committing now to what might look like a bad implementation down the=20
line, when it has to continue to be supported.

> I want to pack some data onto USB hard disks, which exceed the plain
> disk capacity. With btrfs it works exactly the way as I need it, exce=
pt
> for the fact that once the compress option was missed the file system=
 is
> =E2=80=9Etainted=E2=80=9D with uncompressed files, thus wasting disk =
capacity and maybe
> cause the files to not fit on the disk anymore.

I'd be a bit leary of your whole idea of using btrfs on external drives=
=20
attached to multiple systems, at this point.  There's still enough chan=
ge=20
going into btrfs that there's a chance that mounting on a system with a=
=20
newer kernel will prevent mounting on a system with an older kernel.

And if you have enough control over kernel versions on all potentially=20
mounting systems to deal with that, then pretty much by definition, you=
=20
also have enough control over them to hack up a solution that, for=20
instance, looks for a file in specific location on all newly mounted=20
partitions (probably using udev/udisks event hooks), and if found, uses=
=20
the content of said file as a cue to remount the filesystem with the=20
options found in said file.

> I currently don't see how to repair this afterwards without removing =
the
> uncompressed files and writing new ones, which on the other hand spoi=
ls
> hte memory saving effect of using snapshots instead of copies.

A rebalance is the usual way of handling such things, since that rewrit=
es=20
every chunk, taking account of current mount options, etc.  If I've bee=
n=20
reading correctly, a defrag should handle it now as well, altho that us=
ed=20
to break snapshots/cow/reflink-copies, but I /think/ I read that with 3=
=2E2=20
(or was it 3.3-rc1) it doesn't, any more.

> It would be much better if there was a way to set options like the
> compression option permanently when initially creating the file syste=
m,
> or later with the btrfs tools.

As hinted above, I'd /guess/ the chances of something like that=20
eventually occurring are reasonably high, but there's just too much goi=
ng=20
on still, to make superblock changes for every little new feature. =20
Better to save them up for one final change before the caution about th=
e=20
on-disk format changes comes off, prioritize the changes then, and do=20
them all at once.  Then test the new format for a kernel cycle or two=20
just to be sure, and remove the format change boilerplate the cycle aft=
er=20
that.

--=20
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
