Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:36359 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbeHBMok (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 08:44:40 -0400
Subject: Re: BTRFS and databases
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>
Cc: Hugo Mills <hugo@carfax.org.uk>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <20180801085602.GC7524@carfax.org.uk> <2861903.YXSMuvecdq@merkaba>
 <F4227CB0-E722-4CCA-A353-F911BF72CA3B@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0fb66104-2012-93a3-0530-1ed2deaced88@gmx.com>
Date: Thu, 2 Aug 2018 18:53:47 +0800
MIME-Version: 1.0
In-Reply-To: <F4227CB0-E722-4CCA-A353-F911BF72CA3B@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lMLCZEETLQpRiiSuDi1V1M0qGEdTdnADc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lMLCZEETLQpRiiSuDi1V1M0qGEdTdnADc
Content-Type: multipart/mixed; boundary="ywrrdt4ZRMBzjTDlDo3UAez92QzZbBLP3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>,
 Martin Steigerwald <martin@lichtvoll.de>
Cc: Hugo Mills <hugo@carfax.org.uk>, MegaBrutal <megabrutal@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <0fb66104-2012-93a3-0530-1ed2deaced88@gmx.com>
Subject: Re: BTRFS and databases
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <20180801085602.GC7524@carfax.org.uk> <2861903.YXSMuvecdq@merkaba>
 <F4227CB0-E722-4CCA-A353-F911BF72CA3B@gmail.com>
In-Reply-To: <F4227CB0-E722-4CCA-A353-F911BF72CA3B@gmail.com>

--ywrrdt4ZRMBzjTDlDo3UAez92QzZbBLP3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8802=E6=97=A5 18:35, Andrei Borzenkov wrote:
>=20
>=20
> =D0=9E=D1=82=D0=BF=D1=80=D0=B0=D0=B2=D0=BB=D0=B5=D0=BD=D0=BE =D1=81 iPh=
one
>=20
>> 2 =D0=B0=D0=B2=D0=B3. 2018 =D0=B3., =D0=B2 12:16, Martin Steigerwald <=
martin@lichtvoll.de> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>>
>> Hugo Mills - 01.08.18, 10:56:
>>>> On Wed, Aug 01, 2018 at 05:45:15AM +0200, MegaBrutal wrote:
>>>> I know it's a decade-old question, but I'd like to hear your
>>>> thoughts
>>>> of today. By now, I became a heavy BTRFS user. Almost everywhere I
>>>> use BTRFS, except in situations when it is obvious there is no
>>>> benefit (e.g. /var/log, /boot). At home, all my desktop, laptop and
>>>> server computers are mainly running on BTRFS with only a few file
>>>> systems on ext4. I even installed BTRFS in corporate productive
>>>> systems (in those cases, the systems were mainly on ext4; but there
>>>> were some specific file systems those exploited BTRFS features).
>>>>
>>>> But there is still one question that I can't get over: if you store
>>>> a
>>>> database (e.g. MySQL), would you prefer having a BTRFS volume
>>>> mounted
>>>> with nodatacow, or would you just simply use ext4?
>>>
>>>   Personally, I'd start with btrfs with autodefrag. It has some
>>> degree of I/O overhead, but if the database isn't performance-critica=
l
>>> and already near the limits of the hardware, it's unlikely to make
>>> much difference. Autodefrag should keep the fragmentation down to a
>>> minimum.
>>
>> I read that autodefrag would only help with small databases.
>>
>=20
> I wonder if anyone actually=20
>=20
> a) quantified performance impact
> b) analyzed the cause

It's caused by btrfs' poor fsync() performance and lock-hot metadata
operations.

The root cause is how we design btrfs' btree.
For snapshot and only for snapshot, we use one btree for one
*subvolume*, unlike other fses which normally use one btree for one
*inode* (both dir and file).

This means each time we need to modify anything, including updating
EXTENT_DATA pointer, or adding new child inode pointer, we need to do
write lock of the whole subvolume tree root to the leaf.
Which makes the tree root pretty lock hot.

In short, in btrfs we need to lock and race on a big tree, while for
other fses, they only need to lock and race on different small trees.
(And that's why they can't support fast fs level snapshot)

That's the root cause of btrfs' slow metadata performance.
We have a lot of optimization to speedup the process, from delayed-ref
to tree log. But it's still slow compared to other fses.

For fsync() we have log tree optimization, which only logs related data
pointer and inodes updates, and skips some full transaction operations.
It indeeds make fsync() much faster, but still slower than other fses,
due to metadata design.


BTW, nodatacow indeed improves performance, but it's mostly due to the
following factors:
1) No csum calculation
   Although csum calculation can be balanced to multi cpu cores/threads,
   and CRC32 is pretty fast, it still introduces overhead.

2) Some overwrite no longer needs to modify subvolume tree
   If we're doing overwrite, and there is no need to do CoW (for
   snapshot), we can skip updating EXTENT_DATA, and this reduces
   a lot of tree write lock and improve performance.

>=20
> I work with NetApp for a long time and I can say from first hand experi=
ence that fragmentation had zero impact on OLTP workload. It did affect b=
ackup performance as was expected, but this could be fixed by periodic re=
allocation (defragmentation).
>=20
> And even that needed quite some time to observe (years) on pretty high =
 load database with regular backup and replication snapshots.
>=20
> If btrfs is so susceptible to fragmentation, what is the reason for it?=


I heard some reports of fragmentation, but mostly related to extent
booking and ENOSPC, not really related to performance.
And IIRC I did some old performance tests on HDD using btrfs and xfs/ext4=
=2E
Using autodefrag mount option in fact reduces performance on btrfs.

Thanks,
Qu

>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--ywrrdt4ZRMBzjTDlDo3UAez92QzZbBLP3--

--lMLCZEETLQpRiiSuDi1V1M0qGEdTdnADc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlti4rsACgkQwj2R86El
/qiGDgf9FXcqgJLckuKEBR5daHLhQ1fCCj/xCNBdewKOAzu/YPCYNjVssl8PDCvb
DnmrkR7AhYz8XN8VEArOVRdRVbKiLRvptN3IXNOgxoOcIWczVAC8M6cmeUXNaEqg
2S3my22AV1um+PWU4FUodUHv0vXBWVqrR1N8452Taj/oEgYX4DaGP+sB4RlPDe+/
YCje6W62KYe/AHb4p0rnl+5D+DTl2Ifiaf3zMGtmAQqRdI+LC/OW62cvShAN0Eui
8XsDXUabO0CXufxV19lWb8QXvrBevJJGEtPiJQPRrkl70L3vnHSs+E6xt+ZJ8Uc+
ZZmyBvdnlRgivFSNhzmXAh6dlVx5cg==
=BPy2
-----END PGP SIGNATURE-----

--lMLCZEETLQpRiiSuDi1V1M0qGEdTdnADc--
