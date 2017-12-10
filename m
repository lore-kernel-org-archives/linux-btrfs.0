Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62681 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdLJXox (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 18:44:53 -0500
Subject: Re: exclusive subvolume space missing
To: Tomasz Pala <gotar@polanet.pl>, linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
 <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
 <20171210112738.GA24090@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
Date: Mon, 11 Dec 2017 07:44:46 +0800
MIME-Version: 1.0
In-Reply-To: <20171210112738.GA24090@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5cPa5RC4DbDrr0d3wpAtTMGOTXEont2dE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5cPa5RC4DbDrr0d3wpAtTMGOTXEont2dE
Content-Type: multipart/mixed; boundary="AC356Aod5fxOmHuGkHR4ksmN93SLOu98W";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>, linux-btrfs@vger.kernel.org
Message-ID: <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
Subject: Re: exclusive subvolume space missing
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
 <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
 <20171210112738.GA24090@polanet.pl>
In-Reply-To: <20171210112738.GA24090@polanet.pl>

--AC356Aod5fxOmHuGkHR4ksmN93SLOu98W
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8810=E6=97=A5 19:27, Tomasz Pala wrote:
> On Mon, Dec 04, 2017 at 08:34:28 +0800, Qu Wenruo wrote:
>=20
>>> 1. is there any switch resulting in 'defrag only exclusive data'?
>>
>> IIRC, no.
>=20
> I have found a directory - pam_abl databases, which occupy 10 MB (yes,
> TEN MEGAbytes) and released ...8.7 GB (almost NINE GIGAbytes) after
> defrag. After defragging files were not snapshotted again and I've lost=

> 3.6 GB again, so I got this fully reproducible.
> There are 7 files, one of which is 99% of the space (10 MB). None of
> them has nocow set, so they're riding all-btrfs.
>=20
> I could debug something before I'll clean this up, is there anything yo=
u
> want to me to check/know about the files?

fiemap result along with btrfs dump-tree -t2 result.

Both output has nothing related to file name/dir name, but only some
"meaningless" bytenr, so it should be completely OK to share them.

>=20
> The fragmentation impact is HUGE here, 1000-ratio is almost a DoS
> condition which could be triggered by malicious user during a few hours=

> or faster

You won't want to hear this:
The biggest ratio in theory is, 128M / 4K =3D 32768.

> - I've lost 3.6 GB during the night with reasonably small
> amount of writes, I guess it might be possible to trash entire
> filesystem within 10 minutes if doing this on purpose.

That's a little complex.
To get into such situation, snapshot must be used and one must know
which file extent is shared and how it's shared.

But yes, it's possible.

While on the other hand, XFS, which also supports reflink, handles it
quite well, so I'm wondering if it's possible for btrfs to follow its
behavior.

>=20
>>> 3. I guess there aren't, so how could I accomplish my target, i.e.
>>>    reclaiming space that was lost due to fragmentation, without break=
ing
>>>    spanshoted CoW where it would be not only pointless, but actually =
harmful?
>>
>> What about using old kernel, like v4.13?
>=20
> Unfortunately (I guess you had 3.13 on mind), I need the new ones and
> will be pushing towards 4.14.

No, I really mean v4.13.

=46rom btrfs(5):
---
               Warning
               Defragmenting with Linux kernel versions < 3.9 or =E2=89=A5=

3.14-rc2 as
               well as with Linux stable kernel versions =E2=89=A5 3.10.3=
1, =E2=89=A5
3.12.12
               or =E2=89=A5 3.13.4 will break up the ref-links of CoW dat=
a (for
               example files copied with cp --reflink, snapshots or
               de-duplicated data). This may cause considerable increase =
of
               space usage depending on the broken up ref-links.
---

>=20
>>> 4. How can I prevent this from happening again? All the files, that a=
re
>>>    written constantly (stats collector here, PostgreSQL database and
>>>    logs on other machines), are marked with nocow (+C); maybe some ne=
w
>>>    attribute to mark file as autodefrag? +t?
>>
>> Unfortunately, nocow only works if there is no other subvolume/inode
>> referring to it.
>=20
> This shouldn't be my case anymore after defrag (=3D=3Dbreaking links).
> I guess no easy way to check refcounts of the blocks?

No easy way unfortunately.
It's either time consuming (used by qgroup) or complex (manually tree
search and do the backref walk by yourself)

>=20
>> But in my understanding, btrfs is not suitable for such conflicting
>> situation, where you want to have snapshots of frequent partial update=
s.
>>
>> IIRC, btrfs is better for use case where either update is less frequen=
t,
>> or update is replacing the whole file, not just part of it.
>>
>> So btrfs is good for root filesystem like /etc /usr (and /bin /lib whi=
ch
>> is pointing to /usr/bin and /usr/lib) , but not for /var or /run.
>=20
> That is something coherent with my conclusions after 2 years on btrfs,
> however I didn't expect a single file to eat 1000 times more space than=
 it
> should...
>=20
>=20
> I wonder how many other filesystems were trashed like this - I'm short
> of ~10 GB on other system, many other users might be affected by that
> (telling the Internet stories about btrfs running out of space).

Firstly, no other filesystem supports snapshot.
So it's pretty hard to get a baseline.

But as I mentioned, XFS supports reflink, which means file extent can be
shared between several inodes.

=46rom the message I got from XFS guys, they free any unused space of a
file extent, so it should handle it quite well.

But it's quite a hard work to achieve in btrfs, needs years development
at least.

>=20
> It is not a problem that I need to defrag a file, the problem is I don'=
t know:
> 1. whether I need to defrag,
> 2. *what* should I defrag
> nor have a tool that would defrag smart - only the exclusive data or, i=
n
> general, the block that are worth defragging if space released from
> extents is greater than space lost on inter-snapshot duplication.
>=20
> I can't just defrag entire filesystem since it breaks links with snapsh=
ots.
> This change was a real deal-breaker here...

IIRC it's better to add a option to make defrag snapshot-aware.
(Don't break snapshot sharing but only to defrag exclusive data)

Thanks,
Qu

>=20
> Any way to fed the deduplication code with snapshots maybe? There are
> directories and files in the same layout, this could be fast-tracked to=

> check and deduplicate.
>=20


--AC356Aod5fxOmHuGkHR4ksmN93SLOu98W--

--5cPa5RC4DbDrr0d3wpAtTMGOTXEont2dE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlotxu8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhRZgf+L1votwwWCK8GTZWythI9bdyv
FwRfMv3IM5D9UwYFMyGdNQHXaAMJYKFukyZIot5Up7kRhsFspGrCD1uBTFs8hV5x
VIeOUcEhBxaKiuqOp4cFRAsTGiJCrfrkfmnf9cCNvYKTsEkgX4cL57dRbOLZtdMi
NaE0dy3iC8QJz7eUEatrc47UIgQvflnxmiKcei5LflTCXkg7Cg7PMbNpxsiX8xVI
VP7B2N9B/1wPMai/8q+lJuJsXAoF59mN2+SS0iQFTM88Nw0GO30d0HDLu8c1leir
qc8/kBXWyw+vLkOJc2LtKzMMZ1N5Ll6zCWEx2g69xvFUAek7Z1Q+Ft2L4X17DQ==
=eGuA
-----END PGP SIGNATURE-----

--5cPa5RC4DbDrr0d3wpAtTMGOTXEont2dE--
