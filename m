Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44113 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3JNHsN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 03:48:13 -0400
Date: Mon, 14 Oct 2013 08:48:06 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Many questions from a potential btrfs user
Message-ID: <20131014074806.GD28147@carfax.org.uk>
References: <CAOtrxKPU4QBQzXoZO4Jii2n8xdW0vxpYNO5aPD1va8iUBP9nkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tRjCiSMHexiP9I5N"
In-Reply-To: <CAOtrxKPU4QBQzXoZO4Jii2n8xdW0vxpYNO5aPD1va8iUBP9nkg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tRjCiSMHexiP9I5N
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 13, 2013 at 11:54:42PM -0300, Rog=E9rio Brito wrote:
> Hi.
>=20
> I am seriously considering employing btrfs on my systems, particularly due
> to some space-saving features that it has (namely, deduplication and
> compression).
>=20
> In fact, I was (a few moments ago) trying to back up some of my systems t=
o a
> 2TB HD that has an ext4 filesystem and, in the middle of the last one, I =
got
> the error message that the backup HD was full.
>=20
> Given that what I backup there are systems where I have some of the data
> present multiple times (e.g., my mailbox that is sync'ed via offlineimap,=
 or
> videos that I download from online learning sites) and that such data
> consists of many small files that are highly compressible (the e-mails) or
> large files (the videos), I would like to employ btrfs.
>=20
> So, after reading the documentation on https://btrfs.wiki.kernel.org/, I =
am
> still unsure of some points and I would like to have some clarifications
> and/or expectations set straight.
>=20
>=20
> * I understand that I can convert an ext4 filesystem to btrfs. Will such
>   conversion work with an almost full ext4 filesystem? How much overhead
>   will be needed to perform the conversion? I can (temporarily) remove so=
me
>   files that already are on this backup.

   I don't think we've ever explored the bounds of exactly how much
space you need for conversion. It'll be an absolute minimum of 0.1% of
the data used, probably quite a bit more, for the metadata.

> * Is it possible to deduplicate the files that are already in it? As
>   mentioned before, there are likely to be many, and some of them are on =
the
>   order of 1 to 2GBs.

   Yes, there's an out-of-band deduplicator. I'll have to go and look
it up to work out exactly what tools you need to make it work. :)

> * Doing a defragmentation with the filesystem mounted with compression wi=
ll
>   recompress the files (if they are deemed compressible by the
>   filesystem). Is that understanding correct?  Will compressed blocks amo=
ng
>   many files also be deduplicated?

   You'll probably need to add -c to the defrag command, but yes, you
can persuade the FS to recompress files. I'm not sure how this affects
deduplication.

> * How exactly do the recently merged offline deduplication features in the
>   kernel interfere with what was (in my limited understanding) already
>   possible with userspace tools like <https://github.com/g2p/bedup>?  Are
>   such third-party tools likely to be integrated into btrfs-progs? Are th=
ey
>   supposed to be kept separate?

   The out-of-band (rather than offline) dedup kernel features simply
give a more reliable API call for merging identical extents, as it
allows them to be locked during the process -- without that API call,
there's a race condition that could potentially lead to data loss.

> * Does this change the on-disk format? Putting it another way, will it be
>   safe to possibly go back to a previous kernel, if there is some problem
>   with the current kernels? (Not that I necessarily want to go back to a
>   previous kernel, but, sometimes, one would need to, say, git bisect the
>   kernel).

   No, that feature doesn't change the on-disk format.

> * I most likely *don't* want to use online deduplication (given my bad
>   experiences with ZFS).  With that in mind, is the current userspace
>   deduplicaton intended to be run as a cron job? Is the offline
>   deduplication too memory intensive?  How much RAM would it be needed fo=
r a
>   2TB filesystem? Are 2GB enough? How about 4GB?

   Out-of-band dedup is indeed the kind of thing you'd run as a cron
job. However, there's a couple of better approaches you can use. I
don't know about RAM usage, I'm afraid.

   If you use rsync for backups, then you can keep one subvolume as
the "current" version of the backups, and use the --in-place option of
rsync. Then, immediately after finishing a backup run, you can
snapshot that subvolume to give yourself a read-only historical
record. This will ensure that the maximum quantity of data is shared
between the individual backups without having to use OOB dedup.

   If your source FS is btrfs as well, you can do pretty much the same
thing (it's a little more complicated to set up) with btrfs
send/receive, which uses the inherent knowledge of the FS to work out
the differences more efficiently than rsync.

> * Will further runs of the offline deduplication be "incremental" in some
>   imprecise sense of the word? That is, if I run the deduplication once a=
nd
>   immediately run it again (supposing nothing changes), will the 2nd time=
 be
>   faster than the first?  (If the disk caches are dropped?)

   I don't know, but probably (since it should be able to tell that
the extents are already CoW copies).

> * Will I be able to add further HDs to my btrfs filesystem, once I get so=
me
>   more money to run something like a RAID0 configuration? If I get more H=
Ds
>   later, will I be able to change the configuration to, say, RAID5 or RAI=
D6?
>   I don't intend to use lvm, unless I have to.

   Yes, you can change RAID levels on the fly, while the FS is mounted.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- I can resist everything except temptation ---           =20

--tRjCiSMHexiP9I5N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUluhtVheFHXiqx3kAQKalQ/9EVx/MFK9WQ544LepUOEhwugPefCZ5/9B
ITdXnpwkORm+PpzEbCHxnf53O1z3iMDLJME7mRhCBbH8jcNT7s8o8U037pyZSCY3
6xaMtn09ZSZMCq9Me04lXVJu8E3oxVlGlXWbs5KUia9qAoIrcXaMXKEfKUMbC3th
odcUtO7i2zcJzrjU5xCy/2ceMB3zwTYDi9OTQAXqx0dcRHgaDjm9DeLVSAdXmJ/q
ESdyjHeKW0l4KKMJbNmtXvazb/PudqxIDlD2vXskx3it9w+fBJ7fa9KgkAhlp2+F
ZmPBHx46NICqaZRULV13uJA2yyW+aciEj5qVnytbQbxFNq58PAoNngtn8J2W+UwT
3jGr/QrmGGIuR3iMKZRL5eH2Je8hwMjGXT+nVzIouDTkyREpRH4A5cewOS5RfIoV
J5jx9pvPbrZSJoz0nSFFypUvlwmCDyoPqaQmloUq4fYU/z28msEvF4GVIiRIqslk
njq55CyW6FLKfHPUK03BawmyfgHayWbB90vi3kKDgW4aKmbD3bUOkPdCOgXhdbW8
LRIy0XrbSvz1XSFE5A8gk5CXOBKE5M1sLBHQ2qAd2La7gjbuwyOIQP4LXzqMX9re
OzFP81TtEGFrEhuyDWfq73oYimc8rxkfbH2I9lua/w5YG/WjucZzI5zcg4XTapNq
XphA3Rc3T9c=
=a3pZ
-----END PGP SIGNATURE-----

--tRjCiSMHexiP9I5N--
