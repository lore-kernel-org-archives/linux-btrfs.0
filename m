From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: BackupPC, per-dir hard link limit, Debian packaging
Date: Wed, 3 Mar 2010 01:05:48 +0100
Message-ID: <201003030105.49442.hka@qbs.com.pl>
References: <1267496945.9222.155.camel@lifeless-64> <201003021409.22441.hka@qbs.com.pl> <4B8D9DB7.7090207@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org,
	Robert Collins <robertc@robertcollins.net>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B8D9DB7.7090207@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 03 March 2010 00:22:31 jim owens wrote:
> Hubert Kario wrote:
> > On Tuesday 02 March 2010 03:29:05 Robert Collins wrote:
> >> As I say, I realise this is queued to get addressed anyway, but it=
 seems
> >> like a realistic thing for people to do (use BackupPC on btrfs) - =
even
> >> if something better still can be written to replace the BackupPC s=
tore
> >> in the future. I will note though, that simple snapshots won't ach=
ieve
> >> the deduplication level that BackupPC does, because the fils don't=
 start
> >> out as the same: they are identified as being identical post-backu=
p.
> >=20
> > Isn't the main idea behind deduplication to merge identical parts o=
f
> > files together using cow? This way you could have many very similar
> > images of virtual machines, run the deduplication process and reduc=
e
> > massively the space used while maintaining the differences between
> > images.
> >=20
> > If memory serves me right, the plan is to do it in userland on a
> > post-fact filesystem, not when the data is being saved. If such a d=
aemon
> > or program was available you would run it on the system after rsync=
ing
> > the workstations.
> >=20
> > Though the question remains which system would reduce space usage m=
ore in
> > your use case. From my experience, hardlinks take less space on dis=
k, I
> > don't know whatever it could be possible to optimise btrfs cow syst=
em
> > for files that are exactly the same.
>=20
> Space use is not the key difference between these methods.
> The btrfs COW makes data sharing safe.  The hard link method
> means changing a file invalidates the content of all linked files.
>=20
> So a BackupPC output should be read-only.

I know that, but if you're using "dumb" tools to replicate systems (say=
=20
rsync), you don't want them to overwrite different versions of files an=
d you=20
still want to reclaim disk space used by essentially the same data.

My idea behind btrfs as backup storage and using cow not hardlinks for=20
duplicated files comes from need to keep archival copies (something not=
 really=20
possible with hardlinks) in a way similar to rdiff-backup.

As first backup I just rsync to backup server from all workstations.
But on subsequent backups I copy the last version to a .snapshot/todays=
-date =20
directory using cow, rsync from workstations and then run deduplication=
=20
daemon.

This way I get both reduced storage and old copies (handy for user home=
=20
directories...).

With such use-case, the ability to use cow while needing similar amount=
s of=20
space as hardlinks would be at least useful if not very desired.

That's why I asked if it's possible to optimise btrfs cow mechanism for=
=20
identical files.

=46rom my testing (directory 584MiB in size, 17395 files, Arch kernel 2=
=2E6.32.9,=20
coreutils 8.4, btrfs-progs 0.19, 10GiB partition, default mkfs and moun=
t=20
options):
cp -al
free space decrease: 6176KiB

cp -a --reflink=3Dalways
free space decrease: 23296KiB

and in the second run:
cp -al
free space decrease: 6064KiB

cp -a --reflink=3Dalways
free space decrease: 23324KiB

that's nearly 4 times more!
--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=C3=B3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
