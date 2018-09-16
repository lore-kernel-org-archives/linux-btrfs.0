Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55611 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbeIPGyp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 02:54:45 -0400
Subject: Re: state of btrfs snapshot limitations?
To: "James A. Robinson" <jim.robinson@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8958eae5-dd35-66e3-3b21-d4d70ae93d15@gmx.com>
Date: Sun, 16 Sep 2018 09:33:28 +0800
MIME-Version: 1.0
In-Reply-To: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AjlAFklFBtk13xUJ737nEJ9ZVeqlsIJN7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AjlAFklFBtk13xUJ737nEJ9ZVeqlsIJN7
Content-Type: multipart/mixed; boundary="mqSJQYhGdDMZ1FYdFJ8jjcE7lmBbo48oS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "James A. Robinson" <jim.robinson@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <8958eae5-dd35-66e3-3b21-d4d70ae93d15@gmx.com>
Subject: Re: state of btrfs snapshot limitations?
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
In-Reply-To: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>

--mqSJQYhGdDMZ1FYdFJ8jjcE7lmBbo48oS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/15 =E4=B8=8A=E5=8D=885:05, James A. Robinson wrote:
> The mail archive seems to indicate this list is appropriate
> for not only the technical coding issues, but also for user
> questions, so I wanted to pose a question here.  If I'm
> wrong about that, I apologize in advance.
>=20
> The page
>=20
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
>=20
> talks about the basic snapshot capabilities of btrfs and led
> me to look up what, if any, limits might apply.  I find some
> threads from a few years ago that talk about limiting the
> number of snapshots for a volume to 100.

This is mostly related to send and quota, and maybe for
snapshot/subvolume removal.
(Any personally I would recommend only 20 snapshots)

Both of them needs to do backref walk in their core functionality.
Increased number of reference introduced by snapshots could bring a huge
impact to quota especially.

We have some plan to enhance it, but for now if send/quota is important
to you, it's highly recommend to limit number of snapshots to a
reasonable number.

>=20
> The reason I'm curious is I wanted to try and use the
> snapshot capability as a way of keeping a 'history' of a
> backup volume I maintain.  The backup doesn't change a
> lot overtime, but small changes are made to files within
> it daily.

Then normally it could lead to some dilemma.

Currently the mostly common way to know how much exclusively used space
one snapshot uses is btrfs quota (qgroup).
But a lot of snapshots bring tons of performance impact, sometimes even
unacceptable.

If one don't need to account how much space a snapshot really take, it
won't be a problem though.


Despite above things, I'd like to point out that, snapshot is not backup
(which I believe everyone should have already known).

And further more for btrfs specifically, since file trees (snapshots and
subvolumes) still share the same chunk/extent/csum trees, if one of such
essential trees gets corrupted (especially for extent tree), you may not
be able to mount the fs (at least unable to do RW mount).

So it's still pretty important to take real backup.

Thanks,
Qu

>=20
> The Plan 9 OS has a nice archival filesystem that lets you
> easily maintain snapshots, and has various tools that make
> it simple to keep a /snapshot/yyyy/mmdd snapshot going back
> for the life of the filesystem.
>=20
> I wanted to try and replicate the basic functionality of
> that history using a non-plan-9 filesystem.  At first I
> tried rsnapshot but I find its technique of rotating and
> deleting backups is thrashing the disks to the point that it
> can't keep up with the rotations (the cp -al is fast, but
> the periodic rm -rf of older snapshots kills the disk).
>=20
> With btrfs I was thinking perhaps I could more efficiently
> maintain the archive of changes over time using a snapshot.
> If this is an awful thought and I should just go away,
> please let me know.
>=20
> If the limit is 100 or less I'd need use a more complicated
> rotation scheme.  For example with a layout like the
> following:
>=20
> min/<mm>
> hour/<hh>
> day/<dd>
> month/<mm>
> year/<yyy>
>=20
> The idea being each bucket, min, hour, day, month, would
> be capped and older snapshots would be removed and replaced
> with newer ones over time.
>=20
> so with a 15-minute snapshot cycle I'd end up with
>=20
> min/[00,15,30,45]
> hour/[00-23]
> day/[01-31]
> month/[01-12]
> year/[2018,2019,...]
>=20
> (72+ snapshots with room for a few years worth of yearly's).
>=20
> But if things have changed with btrfs over the past few
> years and number of snapshots scales much higher, I would
> use the easier scheme:
>=20
> /min/[00,15,30,45]
> /hourly/[00-23]
> /daily/<yyyy>/<mmdd>
>=20
> with 365 snapshots added per additional year.
>=20


--mqSJQYhGdDMZ1FYdFJ8jjcE7lmBbo48oS--

--AjlAFklFBtk13xUJ737nEJ9ZVeqlsIJN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAludsugACgkQwj2R86El
/qifEQf/V07NuS8BbhrvfSFMWn0kbxxFqLPYhO/FUZwxaYRbAZxpvjMucYb5Nol6
JzTpzXn49NqQsxWZmu767XrUDfmGKEo9az+9I3aUcvc7uP77eQju8Vr7jW+qw7Tb
DfRHLKL0cV4Rpq526wiwtwSOUAxXSlpxwFyfNwjsuNY5Ivgf+fG5zDow1VfGOzWp
oZVEbU7urwOJOYVrSNNls9leS+kIL8UgX3eukjt19SPlUHmuJHX9f7RbqNsfdnao
QxiyeDyVRZCuv+wWSSDZiShkb4lKB2zYP76qeC0ptjY46BnESAP3X5OVFs61tIDe
hK431uxremtRiSSPQnZsPUeZFnFtOg==
=tRGy
-----END PGP SIGNATURE-----

--AjlAFklFBtk13xUJ737nEJ9ZVeqlsIJN7--
