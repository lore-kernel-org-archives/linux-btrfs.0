Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54603 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdLLAuV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 19:50:21 -0500
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
 <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
 <20171211114043.GA5097@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7ea3ab01-eb63-4875-7496-a4ad833c5854@gmx.com>
Date: Tue, 12 Dec 2017 08:50:15 +0800
MIME-Version: 1.0
In-Reply-To: <20171211114043.GA5097@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cKrhjfiXQoeEU5a08m1M6r5neCAlQirLK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cKrhjfiXQoeEU5a08m1M6r5neCAlQirLK
Content-Type: multipart/mixed; boundary="SS9dFUFnlTW0sOWfvUGBHTEVgEXFaKCX9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>, linux-btrfs@vger.kernel.org
Message-ID: <7ea3ab01-eb63-4875-7496-a4ad833c5854@gmx.com>
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
 <f9d281bb-e8a9-77c3-ab29-6fda9e5228ab@gmx.com>
 <20171211114043.GA5097@polanet.pl>
In-Reply-To: <20171211114043.GA5097@polanet.pl>

--SS9dFUFnlTW0sOWfvUGBHTEVgEXFaKCX9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8811=E6=97=A5 19:40, Tomasz Pala wrote:
> On Mon, Dec 11, 2017 at 07:44:46 +0800, Qu Wenruo wrote:
>=20
>>> I could debug something before I'll clean this up, is there anything =
you
>>> want to me to check/know about the files?
>>
>> fiemap result along with btrfs dump-tree -t2 result.
>=20
> fiemap attached, but dump-tree requires unmounted fs, doesn't it?

It doesn't.

You can dump your tree with fs mounted, although it may affect the accura=
cy.

The good news is, in your case, it doesn't really need extent tree, as
there is no shared extent here.

>=20
>>> - I've lost 3.6 GB during the night with reasonably small
>>> amount of writes, I guess it might be possible to trash entire
>>> filesystem within 10 minutes if doing this on purpose.
>>
>> That's a little complex.
>> To get into such situation, snapshot must be used and one must know
>> which file extent is shared and how it's shared.
>=20
> Hostile user might assume that any of his own files old enough were
> being snapshotted. Unless snapshots are not used at all...
>=20
> The 'obvious' solution would be for quotas to limit the data size inclu=
ding
> extents lost due to fragmentation, but this is not the real solution as=

> users don't care about fragmentation. So we're back to square one.
>=20
>> But as I mentioned, XFS supports reflink, which means file extent can =
be
>> shared between several inodes.
>>
>> From the message I got from XFS guys, they free any unused space of a
>> file extent, so it should handle it quite well.
>=20
> Forgive my ignorance, as I'm not familiar with details, but isn't the
> problem 'solvable' by reusing space freed from the same extent for any
> single (i.e. the same) inode?

Not that easy.

The extent tree design makes it a little tricky to do that.
So btrfs use the current extent booking, the laziest way to delete extent=
=2E

> This would certainly increase
> fragmentation of a file, but reduce extent usage significially.
>=20
>=20
> Still, I don't comprehend the cause of my situation. If - after doing a=

> defrag (after snapshotting whatever there were already trashed) btrfs
> decides to allocate new extents for the file, why doesn't is use them
> efficiently as long as I'm not doing snapshots anymore?

Even without snapshot, things can easily go crazy.

This will write 128M file (max btrfs file extent size) and write it to di=
sk.
# xfs_io -f -c "pwrite 0 128M" -c "sync" /mnt/btrfs/file

Then, overwrite the 1~128M range.
# xfs_io -f -c "pwrite 1M 127M" -c "sync" /mnt/btrfs/file

Guess your real disk usage, it's 127M + 128M =3D 255M.

The point here, if there is any reference of a file extent, the whole
extent won't be freed, even it's only 1M of a 128M extent.

While defrag will basically read out the whole 128M file, and rewrite it.=

Basically the same as:

# dd if=3D/mnt/btrfs/file of=3D/mnt/btrfs/file2
# rm /mnt/btrfs/file

In this case, it will cause a new 128M file extent, while old 128M+127M
extents lost all their reference so they are freed.
As a result, it frees 127M.



> I'm attaching the second fiemap, the same file from last snapshot taken=
=2E
> According to this one-liner:
>=20
> for i in `awk '{print $3}' fiemap`; do grep $i fiemap_old; done
>=20
> current file doesn't share any physical locations with the old one.
> But still grows, so what does this situation have with snapshots anyway=
?

In your fiemap, all your file extent is exclusive, so not really related
to snapshot.

But the file is very fragmented.
Most of them is 4K sized, several 8K sized.
And the final extent is 220K sized.

Are you pre-allocating the file before write using tools like dd?
If so, just as I explained above, it will at least *DOUBLE* on-disk
space usage, and cause tons of fragment.

It's recommended to use fallocate to prealloc file instead of things
like dd.
(preallocated range acts must like nocow, although only for first write)

And if possible, use nocow for this file.


>=20
> Oh, and BTW - 900+ extents for ~5 GB taken means there is about 5.5 MB
> occupied per extent. How is that possible?

Appending small write and frequently fsync or small random DIO.

Avoid such pattern or at least use nocow.
Also avoid using dd to preallocate file.

Another solution is autodefrag, but I doubt the effect.

Thanks,
Qu

>=20


--SS9dFUFnlTW0sOWfvUGBHTEVgEXFaKCX9--

--cKrhjfiXQoeEU5a08m1M6r5neCAlQirLK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlovJ8cXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhKKAf+K9D8wbKn6CX1HONsIsGP5uRQ
4DLrQjXlGkvY21IEtJX4jraIpKX0aSFsoxqF9IVIiCgn65MoTHylhMbqB1Qc6guZ
jyiKxoYDsnXRezu66bY4fla9fHJdDTGCLjkzQbjAmIaqG3OARkDxSSQlJQeoIpz+
su73SNUDIxWDHKAGqxfJ2SnYWWrLwVjF7gw8lU87039LDu4rynDs2yb/WE3vX0RW
RiEanG+41quI9/Jpq7ymabOFi2BL4y8yagabM18mmoVHIAXhCGIHjBjBmDJid5Xn
uWeYg5GPyYPYZrpARkbF5r0fWxN7/bqDo5XK/mFZoW8VGaIxMoB1lu6nqqtQOA==
=mUm4
-----END PGP SIGNATURE-----

--cKrhjfiXQoeEU5a08m1M6r5neCAlQirLK--
