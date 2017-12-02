Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54975 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751859AbdLBBF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 20:05:58 -0500
Subject: Re: exclusive subvolume space missing
To: Tomasz Pala <gotar@polanet.pl>, Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk> <20171202005338.GA20205@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2a14e451-c3fb-1e58-41dd-e98aeb5d24ec@gmx.com>
Date: Sat, 2 Dec 2017 09:05:50 +0800
MIME-Version: 1.0
In-Reply-To: <20171202005338.GA20205@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7JPSkPtx0fKwIE0Dc6FjMQdNQdLk1BK39"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7JPSkPtx0fKwIE0Dc6FjMQdNQdLk1BK39
Content-Type: multipart/mixed; boundary="AdR4wNruEO3m4irEsWK2Ouxk8OLgvqQB3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>, Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <2a14e451-c3fb-1e58-41dd-e98aeb5d24ec@gmx.com>
Subject: Re: exclusive subvolume space missing
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk> <20171202005338.GA20205@polanet.pl>
In-Reply-To: <20171202005338.GA20205@polanet.pl>

--AdR4wNruEO3m4irEsWK2Ouxk8OLgvqQB3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

>>> Now, the weird part for me is exclusive data count:
>>>
>>> # btrfs sub sh ./snapshot-171125
>>> [...]
>>>         Subvolume ID:           388
>>> # btrfs fi du -s ./snapshot-171125=20
>>>      Total   Exclusive  Set shared  Filename
>>>   21.50GiB    63.35MiB    20.77GiB  snapshot-171125
>>>
>>> How is that possible? This doesn't even remotely relate to 7.15 GiB
>>> from qgroup.~The same amount differs in total: 28.75-21.50=3D7.25 GiB=
=2E
>>> And the same happens with other snapshots, much more exclusive data
>>> shown in qgroup than actually found in files. So if not files, where
>>> is that space wasted? Metadata?
>>
>>    Personally, I'd trust qgroups' output about as far as I could spit
>> Belgium(*).
>=20
> Well, there is something wrong here, as after removing the .ccache
> directories inside all the snapshots the 'excl' values decreased
> ...except for the last snapshot (the list below is short by ~40 snapsho=
ts
> that have 2 GB excl in total):
>=20
> qgroupid         rfer         excl=20
> --------         ----         ----=20
> 0/260        12.25GiB      3.22GiB	from 170712 - first snapshot
> 0/312        17.54GiB      4.56GiB	from 170811
> 0/366        25.59GiB      2.44GiB	from 171028
> 0/370        23.27GiB     59.46MiB 	from 111118 - prev snapshot
> 0/388        21.69GiB      7.16GiB	from 171125 - last snapshot
> 0/291        24.29GiB      9.77GiB	default subvolume

You may need to manually sync the filesystem (trigger a transaction
commitment) to update qgroup accounting.
>=20
>=20
> [~/test/snapshot-171125]#  du -sh .
> 15G     .
>=20
>=20
> After changing back to ro I tested how much data really has changed
> between the previous and last snapshot:
>=20
> [~/test]#  btrfs send -p snapshot-171118 snapshot-171125 | pv > /dev/nu=
ll
> At subvol snapshot-171125
> 74.2MiB 0:00:32 [2.28MiB/s]
>=20
> This means there can't be 7 GiB of exclusive data in the last snapshot.=


Mentioned before, sync the fs first before checking the qgroup numbers.
Or use --sync option along with qgroup show.

>=20
> Well, even btrfs send -p snapshot-170712 snapshot-171125 | pv > /dev/nu=
ll
> 5.68GiB 0:03:23 [28.6MiB/s]
>=20
> I've created a new snapshot right now to compare it with 171125:
> 75.5MiB 0:00:43 [1.73MiB/s]
>=20
>=20
> OK, I could even compare all the snapshots in sequence:
>=20
> # for i in snapshot-17*; btrfs prop set $i ro true
> # p=3D''; for i in snapshot-17*; do [ -n "$p" ] && btrfs send -p "$p" "=
$i" | pv > /dev/null; p=3D"$i" done
>  1.7GiB 0:00:15 [ 114MiB/s]
> 1.03GiB 0:00:38 [27.2MiB/s]
>  155MiB 0:00:08 [19.1MiB/s]
> 1.08GiB 0:00:47 [23.3MiB/s]
>  294MiB 0:00:29 [ 9.9MiB/s]
>  324MiB 0:00:42 [7.69MiB/s]
> 82.8MiB 0:00:06 [12.7MiB/s]
> 64.3MiB 0:00:05 [11.6MiB/s]
>  137MiB 0:00:07 [19.3MiB/s]
> 85.3MiB 0:00:13 [6.18MiB/s]
> 62.8MiB 0:00:19 [3.21MiB/s]
>  132MiB 0:00:42 [3.15MiB/s]
>  102MiB 0:00:42 [2.42MiB/s]
>  197MiB 0:00:50 [3.91MiB/s]
>  321MiB 0:01:01 [5.21MiB/s]
>  229MiB 0:00:18 [12.3MiB/s]
>  109MiB 0:00:11 [ 9.7MiB/s]
>  139MiB 0:00:14 [9.32MiB/s]
>  573MiB 0:00:35 [15.9MiB/s]
> 64.1MiB 0:00:30 [2.11MiB/s]
>  172MiB 0:00:11 [14.9MiB/s]
> 98.9MiB 0:00:07 [14.1MiB/s]
>   54MiB 0:00:08 [6.17MiB/s]
> 78.6MiB 0:00:02 [32.1MiB/s]
> 15.1MiB 0:00:01 [12.5MiB/s]
> 20.6MiB 0:00:00 [  23MiB/s]
> 20.3MiB 0:00:00 [  23MiB/s]
>  110MiB 0:00:14 [7.39MiB/s]
> 62.6MiB 0:00:11 [5.67MiB/s]
> 65.7MiB 0:00:08 [7.58MiB/s]
>  731MiB 0:00:42 [  17MiB/s]
> 73.7MiB 0:00:29 [ 2.5MiB/s]
>  322MiB 0:00:53 [6.04MiB/s]
>  105MiB 0:00:35 [2.95MiB/s]
> 95.2MiB 0:00:36 [2.58MiB/s]
> 74.2MiB 0:00:30 [2.43MiB/s]
> 75.5MiB 0:00:46 [1.61MiB/s]
>=20
> This is 9.3 GB of total diffs between all the snapshots I got.
> Plus 15 GB of initial snapshot means there is about 25 GB used,
> while df reports twice the amount, way too much for overhead:
> /dev/sda2        64G   52G   11G  84% /
>=20
>=20
> # btrfs quota enable /
> # btrfs qgroup show /
> WARNING: quota disabled, qgroup data may be out of date
> [...]
> # btrfs quota enable /		- for the second time!
> # btrfs qgroup show /
> WARNING: qgroup data inconsistent, rescan recommended

Please wait the rescan, or any number is not correct.
(Although it will only be less than actual occupied space)

It's highly recommended to read btrfs-quota(8) and btrfs-qgroup(8) to
ensure you understand all the limitation.

> [...]
> 0/428        15.96GiB     19.23MiB 	newly created (now) snapshot
>=20
>=20
>=20
> Assuming the qgroups output is bugus and the space isn't physically
> occupied (which is coherent with btrfs fi du output and my expectation)=

> the question remains: why is that bogus-excl removed from available
> space as reported by df or btrfs fi df/usage? And how to reclaim it?

Already explained the difference in another thread.

Thanks,
Qu

>=20
>=20
> [~/test]#  btrfs device usage /
> /dev/sda2, ID: 1
>    Device size:            64.00GiB
>    Device slack:              0.00B
>    Data,single:             1.07GiB
>    Data,RAID1:             55.97GiB
>    Metadata,RAID1:          2.00GiB
>    System,RAID1:           32.00MiB
>    Unallocated:             4.93GiB
>=20
> /dev/sdb2, ID: 2
>    Device size:            64.00GiB
>    Device slack:              0.00B
>    Data,single:           132.00MiB
>    Data,RAID1:             55.97GiB
>    Metadata,RAID1:          2.00GiB
>    System,RAID1:           32.00MiB
>    Unallocated:             5.87GiB
>=20


--AdR4wNruEO3m4irEsWK2Ouxk8OLgvqQB3--

--7JPSkPtx0fKwIE0Dc6FjMQdNQdLk1BK39
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloh/G4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjlywf+MIumMxOG6Iyzr0WqVdH77ZRO
kd4dTJGWCerXCI6IJQSEtHzWU0rTTWA9nzBxNOXmligIV/YV3Mpa8i2s4dIxxE29
LagusyvJZmNesPu2CHCjQIKYFh2oGmlf4grcx3WefGME7OuNLdVPHWcwsPoJyiQg
FysbXLfXHBKouhjnYdIG9cz04lZd04uQi6Qfc0SDMo+nc1tWghsjKpugqkXcB9Yr
le8rcyqoPd6DloB07BiS6vL27aC/vjYf7nZNQSzhM6uSZOM3Eb4YEwVZcafr8AIp
Mi1lZzHGZsiK8aPHTGnOefsFIfLazJcV5C623UwsL1X9K9yfDthlWL+2cfrYwA==
=413h
-----END PGP SIGNATURE-----

--7JPSkPtx0fKwIE0Dc6FjMQdNQdLk1BK39--
