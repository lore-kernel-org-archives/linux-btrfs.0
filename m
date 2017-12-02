Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52255 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751169AbdLBCRf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 21:17:35 -0500
Subject: Re: exclusive subvolume space missing
To: Tomasz Pala <gotar@polanet.pl>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk> <20171202005338.GA20205@polanet.pl>
 <2a14e451-c3fb-1e58-41dd-e98aeb5d24ec@gmx.com>
 <20171202014357.GC20205@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f8b623b6-4ca7-23e9-ac7d-ea9ea2d92620@gmx.com>
Date: Sat, 2 Dec 2017 10:17:27 +0800
MIME-Version: 1.0
In-Reply-To: <20171202014357.GC20205@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Tm5lAxVtg98csS6Mj87SgvUtTpFTkjIsK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tm5lAxVtg98csS6Mj87SgvUtTpFTkjIsK
Content-Type: multipart/mixed; boundary="jix9v5V2c5prM0jced7MPw1IjjDFmkCrC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-ID: <f8b623b6-4ca7-23e9-ac7d-ea9ea2d92620@gmx.com>
Subject: Re: exclusive subvolume space missing
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk> <20171202005338.GA20205@polanet.pl>
 <2a14e451-c3fb-1e58-41dd-e98aeb5d24ec@gmx.com>
 <20171202014357.GC20205@polanet.pl>
In-Reply-To: <20171202014357.GC20205@polanet.pl>

--jix9v5V2c5prM0jced7MPw1IjjDFmkCrC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8802=E6=97=A5 09:43, Tomasz Pala wrote:
> On Sat, Dec 02, 2017 at 09:05:50 +0800, Qu Wenruo wrote:
>=20
>>> qgroupid         rfer         excl=20
>>> --------         ----         ----=20
>>> 0/260        12.25GiB      3.22GiB	from 170712 - first snapshot
>>> 0/312        17.54GiB      4.56GiB	from 170811
>>> 0/366        25.59GiB      2.44GiB	from 171028
>>> 0/370        23.27GiB     59.46MiB 	from 111118 - prev snapshot
>>> 0/388        21.69GiB      7.16GiB	from 171125 - last snapshot
>>> 0/291        24.29GiB      9.77GiB	default subvolume
>>
>> You may need to manually sync the filesystem (trigger a transaction
>> commitment) to update qgroup accounting.
>=20
> The data I've pasted were just calculated.
>=20
>>> # btrfs quota enable /
>>> # btrfs qgroup show /
>>> WARNING: quota disabled, qgroup data may be out of date
>>> [...]
>>> # btrfs quota enable /		- for the second time!
>>> # btrfs qgroup show /
>>> WARNING: qgroup data inconsistent, rescan recommended
>>
>> Please wait the rescan, or any number is not correct.
>=20
> Here I was pointing that first "quota enable" resulted in "quota
> disabled" warning until I've enabled it once again.
>=20
>> It's highly recommended to read btrfs-quota(8) and btrfs-qgroup(8) to
>> ensure you understand all the limitation.
>=20
> I probably won't understand them all, but this is not an issue of my
> concern as I don't use it. There is simply no other way I am aware that=

> could show me per-subvolume stats. Well, straightforward way, as the
> hard way I'm using (btrfs send) confirms the problem.

Unfortunately, send doesn't count everything.

The most common thing is, send doesn't count extent booking space.
Try the following command:

# fallocate -l 1G <tmp_file>
# mkfs.btrfs -f <tmp_file>
# mount <tmp_file> <mnt>
# btrfs subv create <mnt>/subv1
# xfs_io -f -c "pwrite 0 128M" -c "sync" <mnt>/subv1/file1
# xfs_io -f "fpunch 0 127M" -c "sync" <mnt>/subv1/file1
# btrfs subv snapshot -r <mnt>/subv1 <mnt>/snapshot
# btrfs send <mnt>/snapshot

You will only get the 1M data, while it still takes 128M space on-disk.

Btrfs extent book will only free the whole extent if and only if there
is no inode referring *ANY* part of the extent.

Even only 1M of a 128M file extent is used, it will still takes 128M
space on-disk.

And that's what send can't tell you.
And that's also what qgroup can tell you.

That's also why I need *CORRECT* qgroup numbers to further investigate
the problem.

>=20
> You could simply remove all the quota results I've posted and there wil=
l
> be the underlaying problem, that the 25 GB of data I got occupies 52 GB=
=2E

If you only want to know the answer why your "25G" data occupies 52G on
disk, above is one of the possible explanations.

(And I think I should put it into btrfs(5), although I highly doubt if
user will really read them)

You could try to defrag, but I'm not sure if defrag works well in multi
subvolumes case.

> At least one recent snapshot, that was taken after some minor (<100 MB)=
 changes
> from the subvolume, that has undergo some minor changes since then,
> occupied 8 GB during one night when the entire system was idling.

The only possible method to fully isolate all the disturbing factors is
to get rid of snapshot.

Build the subvolume from scratch (even no cp --reflink from other
subvolume), then test what's happening.

Only in that case, you could trust vanilla du (if you don't do any reflin=
k).
Although you can always trust qgroups number, such subvolume built from
scratch will makes exclusive number equals to reference, making
debugging a little easier.

Thanks,
Qu

>=20
> This was crosschecked on files metadata (mtimes compared) and 'du'
> results.
>=20
>=20
> As a last-resort I've rebalanced the disk (once again), this time with
> -dconvert=3Draid1 (to get rid of the single residue).
>=20


--jix9v5V2c5prM0jced7MPw1IjjDFmkCrC--

--Tm5lAxVtg98csS6Mj87SgvUtTpFTkjIsK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloiDTcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg0agf+OkOw7Cjxllq2XwHDwUBJZ8uM
0QpdIFnI42JJAxvD7lm8tvfnWFNYCst5ulwO0cnwxrY4PU/ferMheBhHqOHRpJjc
rlPHTL9tdVmsxGYorakf5Qxn6Yt2rVx7EQB/Pj/IawsEqAZCDUwmB9BULq9eNAwU
GOKZRJELSko6dP2reW+hCBoaCmWIBayyGnxb5wtW7mZ+2E+BXSG+wQdBHYb/YZfM
vuapwQ8yUITgUMrfng1bojZ7qy/YuguM/ehlnp7qYp1pkjFpa82PMcWA7WH8F3NU
vKGS6ukgNYW+uXYOw8skqQTbO7/uCwX2ssK3DBTDA1GCAHmqXmAxdabokzh5fA==
=zncK
-----END PGP SIGNATURE-----

--Tm5lAxVtg98csS6Mj87SgvUtTpFTkjIsK--
