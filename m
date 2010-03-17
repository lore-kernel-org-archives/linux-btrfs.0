From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Content based storage
Date: Wed, 17 Mar 2010 01:45:09 +0100
Message-ID: <201003170145.10615.hka@qbs.com.pl>
References: <hnnijd$jol$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: David Brown <david@westcontrol.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <hnnijd$jol$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 16 March 2010 10:21:43 David Brown wrote:
> Hi,
>=20
> I was wondering if there has been any thought or progress in
> content-based storage for btrfs beyond the suggestion in the "Project
> ideas" wiki page?
>=20
> The basic idea, as I understand it, is that a longer data extent
> checksum is used (long enough to make collisions unrealistic), and me=
rge
> data extents with the same checksums.  The result is that "cp foo bar=
"
> will have pretty much the same effect as "cp --reflink foo bar" - the
> two copies will share COW data extents - as long as they remain the
> same, they will share the disk space.  But you can still access each
> file independently, unlike with a traditional hard link.
>=20
> I can see at least three cases where this could be a big win - I'm su=
re
> there are more.
>=20
> Developers often have multiple copies of source code trees as branche=
s,
> snapshots, etc.  For larger projects (I have multiple "buildroot" tre=
es
> for one project) this can take a lot of space.  Content-based storage
> would give the space efficiency of hard links with the independence o=
f
> straight copies.  Using "cp --reflink" would help for the initial
> snapshot or branch, of course, but it could not help after the copy.
>=20
> On servers using lightweight virtual servers such as OpenVZ, you have
> multiple "root" file systems each with their own copy of "/usr", etc.
> With OpenVZ, all the virtual roots are part of the host's file system
> (i.e., not hidden within virtual disks), so content-based storage cou=
ld
> merge these, making them very much more efficient.  Because each of
> these virtual roots can be updated independently, it is not possible =
to
> use "cp --reflink" to keep them merged.
>=20
> For backup systems, you will often have multiple copies of the same
> files.  A common scheme is to use rsync and "cp -al" to make hard-lin=
ked
> (and therefore space-efficient) snapshots of the trees.  But sometime=
s
> these things get out of synchronisation - perhaps your remote rsync d=
ies
> halfway, and you end up with multiple independent copies of the same
> files.  Content-based storage can then re-merge these files.
>=20
>=20
> I would imagine that content-based storage will sometimes be a
> performance win, sometimes a loss.  It would be a win when merging
> results in better use of the file system cache - OpenVZ virtual servi=
ng
> would be an example where you would be using multiple copies of the s=
ame
> file at the same time.  For other uses, such as backups, there would =
be
> no performance gain since you seldom (hopefully!) read the backup fil=
es.
>   But in that situation, speed is not a major issue.
>=20
>=20
> mvh.,
>=20
> David

=46rom what I could read, content based storage is supposed to be in-li=
ne=20
deduplication, there are already plans to do (probably) a userland daem=
on=20
traversing the FS and merging indentical extents -- giving you post-pro=
cess=20
deduplication.

=46or a rather heavy used host (such as a VM host) you'd probably want =
to use=20
post-process dedup -- as the daemon can be easly stopped or be given lo=
wer=20
priority. In line dedup is quite CPU intensive.

In line dedup is very nice for backup though -- you don't need the temp=
orary=20
storage before the (mostly unchanged) data is deduplicated.
--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=F3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
