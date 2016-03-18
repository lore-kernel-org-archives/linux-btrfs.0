Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38295 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbcCRJdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 05:33:49 -0400
Received: by mail-wm0-f41.google.com with SMTP id l68so28418221wml.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 02:33:49 -0700 (PDT)
Received: from [192.168.4.43] (dslb-092-077-043-105.092.077.pools.vodafone-ip.de. [92.77.43.105])
        by smtp.googlemail.com with ESMTPSA id jv7sm11441486wjb.36.2016.03.18.02.33.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 18 Mar 2016 02:33:47 -0700 (PDT)
Subject: Re: [4.4.1] btrfs-transacti frequent high CPU usage despite little
 fragmentation
To: linux-btrfs@vger.kernel.org
References: <56E92B38.10605@inoio.de>
 <pan$4920$33ddf09b$49bd87c9$2053e366@cox.net>
From: Ole Langbehn <neurolabs.de@gmail.com>
Message-ID: <56EBCB7A.1010508@gmail.com>
Date: Fri, 18 Mar 2016 10:33:46 +0100
MIME-Version: 1.0
In-Reply-To: <pan$4920$33ddf09b$49bd87c9$2053e366@cox.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tioIwIohMolTQ9lIcKiQIkuCOHMEQD2s0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tioIwIohMolTQ9lIcKiQIkuCOHMEQD2s0
Content-Type: multipart/mixed; boundary="quGdV2GilOq5aCJERne6Xp6rMw7VG7Lj2"
From: Ole Langbehn <neurolabs.de@gmail.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <56EBCB7A.1010508@gmail.com>
Subject: Re: [4.4.1] btrfs-transacti frequent high CPU usage despite little
 fragmentation
References: <56E92B38.10605@inoio.de>
 <pan$4920$33ddf09b$49bd87c9$2053e366@cox.net>
In-Reply-To: <pan$4920$33ddf09b$49bd87c9$2053e366@cox.net>

--quGdV2GilOq5aCJERne6Xp6rMw7VG7Lj2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Duncan,

thanks for your extensive answer.

On 17.03.2016 11:51, Duncan wrote:
> Ole Langbehn posted on Wed, 16 Mar 2016 10:45:28 +0100 as excerpted:
>=20
> Have you tried the autodefrag mount option, then defragging?  That shou=
ld=20
> help keep rewritten files from fragmenting so heavily, at least.  On=20
> spinning rust it doesn't play so well with large (half-gig plus)=20
> databases or VM images, but on ssds it should scale rather larger; on=20
> fast SSDs I'd not expect problems until 1-2 GiB, possibly higher.

Since I do have some big VM images, I never tried autodefrag.

> For large dbs or VM images, too large for autodefrag to handle well, th=
e=20
> nocow attribute is the usual suggestion, but I'll skip the details on=20
> that for now, as you may not need it with autodefrag on an ssd, unless =

> your database and VM files are several gig apiece.

Since posting the original post, I experimented with setting the firefox
places.sqlite to nodatacow (on a new file). 1 extent since, seems to work=
=2E

>> BTW: I did a VACUUM on the sqlite db and afterwards it had 1 extent.
>> Expected, just saying that vacuuming seems to be a good measure for
>> defragmenting sqlite databases.
>=20
> I know the concept, but out of curiousity, what tool do you use for=20
> that?  I imagine my firefox sqlite dbs could use some vacuuming as well=
,=20
> but don't have the foggiest idea how to go about it.

simple call of the command line interface, like with any other SQL DB:

# sqlite3 /path/to/db.sqlite "VACUUM;"

> Of *most* importance, you really *really* need to do something about th=
at=20
> data chunk imbalance, and to a lessor extent that metadata chunk=20
> imbalance, because your unallocated space is well under a gig (306 MiB)=
,=20
> with all that extra space, hundreds of gigs of it, locked up in unused =
or=20
> only partially used chunks.

I'm curious - why is that a bad thing?

> The subject says 4.4.1, but it's unclear whether that's your kernel=20
> version or your btrfs-progs userspace version.  If that's your userspac=
e=20
> version and you're running an old kernel, strongly consider upgrading t=
o=20
> the LTS kernel 4.1 or 4.4 series if possible, or at least the LTS serie=
s=20
> before that, 3.18.  Those or the latest couple current kernel series, 4=
=2E5=20
> and 4.4, and 4.3 for the moment as 4.5 is /just/ out, are the recommend=
ed=20
> and best supported versions.

# uname -r
4.4.1-gentoo

# btrfs --version
btrfs-progs v4.4.1

So, both 4.4.1 ;), but I meant userspace.

> Try this:
>=20
> btrfs balance start -dusage=3D0 -musage=3D0.

Did this although I'm reasonably up to date kernel-wise. I am very sure
that the filesystem has never seen <3.18. Took some minutes, ended up wit=
h

# btrfs filesystem usage /
Overall:
    Device size:                 915.32GiB
    Device allocated:            681.32GiB
    Device unallocated:          234.00GiB
    Device missing:                  0.00B
    Used:                        153.80GiB
    Free (estimated):            751.08GiB      (min: 751.08GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:667.31GiB, Used:150.22GiB
   /dev/sda2     667.31GiB

Metadata,single: Size:14.01GiB, Used:3.58GiB
   /dev/sda2      14.01GiB

System,single: Size:4.00MiB, Used:112.00KiB
   /dev/sda2       4.00MiB

Unallocated:
   /dev/sda2     234.00GiB


-> Helped with data, not with metadata.

> Then start with metadata, and up the usage numbers which are percentage=
s,=20
> like this:
>=20
> btrfs balance start -musage=3D5.
>=20
> Then if it works up the number to 10, 20, etc.

upped it up to 70, relocated a total of 13 out of 685 chunks:

Metadata,single: Size:5.00GiB, Used:3.58GiB
   /dev/sda2       5.00GiB

> Once you have several gigs in unallocated, then try the same thing with=
=20
> data:
>=20
> btrfs balance start -musage=3D5
>=20
> And again, increase it in increments of 5 or 10% at a time, to 50 or=20
> 70%.

did

# btrfs balance start -dusage=3D70

straight away, took ages, regularly froze processes for minutes, after
about 8h status is:

# btrfs balance status /
Balance on '/' is paused
192 out of about 595 chunks balanced (194 considered),  68% left
# btrfs filesystem usage /
Overall:
    Device size:                 915.32GiB
    Device allocated:            482.04GiB
    Device unallocated:          433.28GiB
    Device missing:                  0.00B
    Used:                        154.36GiB
    Free (estimated):            759.48GiB      (min: 759.48GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:477.01GiB, Used:150.80GiB
   /dev/sda2     477.01GiB

Metadata,single: Size:5.00GiB, Used:3.56GiB
   /dev/sda2       5.00GiB

System,single: Size:32.00MiB, Used:96.00KiB
   /dev/sda2      32.00MiB

Unallocated:
   /dev/sda2     433.28GiB

-> Looking good. Will proceed when I don't need the box to actually be
responsive.

> Second thing, consider tweaking your trim/discard policy [...]
>=20
> The recommendation is to put fstrim in a cron or systemd timer job,=20
> executing it weekly or similar, preferably at a time when all those=20
> unqueued trims won't affect your normal work.

I have it in cron.weekly, since the creation of the filesystem:

fstrim -v / >> $LOG

Cheers,

Ole




--quGdV2GilOq5aCJERne6Xp6rMw7VG7Lj2--

--tioIwIohMolTQ9lIcKiQIkuCOHMEQD2s0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbry3oACgkQoxgU3D8/uhEfVQCffSOC37Fpsj04mN0DtvAimPpf
32EAoItgmQyXfcd3///e26Z2PBodLGk9
=MWq/
-----END PGP SIGNATURE-----

--tioIwIohMolTQ9lIcKiQIkuCOHMEQD2s0--
