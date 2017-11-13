Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61434 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdKMAlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 19:41:20 -0500
Subject: Re: Theoretical Question about commit=n
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Robert White <rwhite@pobox.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b845c5b3-1241-723d-c7a9-ddfe4a550d8d@pobox.com>
 <dacaa3b1-d6c1-44d3-4fef-28db73af3e90@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c768fcf7-f206-2667-ce0e-b7f5deaff1e4@gmx.com>
Date: Mon, 13 Nov 2017 08:41:07 +0800
MIME-Version: 1.0
In-Reply-To: <dacaa3b1-d6c1-44d3-4fef-28db73af3e90@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PxB6V3lmj4Bm6MBQ66aHT2BvLqBQvkBfq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PxB6V3lmj4Bm6MBQ66aHT2BvLqBQvkBfq
Content-Type: multipart/mixed; boundary="CGkRiGfS5wQVRGot1LH5P5hGW70cdDkmj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Robert White <rwhite@pobox.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <c768fcf7-f206-2667-ce0e-b7f5deaff1e4@gmx.com>
Subject: Re: Theoretical Question about commit=n
References: <b845c5b3-1241-723d-c7a9-ddfe4a550d8d@pobox.com>
 <dacaa3b1-d6c1-44d3-4fef-28db73af3e90@mendix.com>
In-Reply-To: <dacaa3b1-d6c1-44d3-4fef-28db73af3e90@mendix.com>

--CGkRiGfS5wQVRGot1LH5P5hGW70cdDkmj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8813=E6=97=A5 06:01, Hans van Kranenburg wrote:
> On 11/12/2017 09:58 PM, Robert White wrote:
>> Is the commit interval monotonic, or is it seconds after sync?
>>
>> What I mean is that if I manually call sync(2) does the commit timer
>> reset? I'm thinking it does not, but I can imagine a workload where it=

>> ideally would.
>=20
> The magic happens inside the transaction kernel thread:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/fs/btrfs/disk-io.c?h=3Dv4.14#n1925
>=20
> You can see the delay being computed:
>     delay =3D HZ * fs_info->commit_interval;
>=20
> Almost at the end of the function, you see:
>     schedule_timeout(delay)
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/kernel/time/timer.c?h=3Dv4.14#n1676
>=20
> This schedule_timeout function sets a timer and then the thread goes to=

> sleep. If nothing happens, the kernel will wake up the thread after the=

> timer expires (can be later, but not earlier) and then it will redo the=

> loop.
>=20
> If something else wakes up the transaction thread, the timer is
> discarded if it's not expired yet.

So far so good.

>=20
> So it works like you would want.

Not exactly.

Sync or commit_transaction won't wake up transaction_kthread.

transaction_kthread will mostly be woken by trans error, remount or
under certain case of btrfs_end_transaction.

So manually sync will not (at least not always) interrupt commit interval=
=2E

And even more, transaction_kthread will only commit transaction, which
means it will only ensure metadata consistent.

It won't ensure buffered write to reach disk if its extent is not
allocated yet (delalloc).

Thanks,
Qu
>=20
> You can test this yourself by looking at the "generation" number of you=
r
> filesystem. It's in the output of btrfs inspect dump-super:
>=20
> This is the little test filesystem I just used:
>=20
> -# btrfs inspect dump-super /dev/dorothy/mekker | grep ^generation
> generation		35
>=20
> If you print the number in a loop, like every second, you can see it
> going up after a transaction happened. Now play around with other thing=
s
> and see when it changes.
>=20
>> (Again, this is purely theoretical, I have no such workload as I am
>> about to describe.)
>>
>> So suppose I have some sort of system, like a database, that I know wi=
ll
>> do scattered writes and extends through some files and then call some
>> variant of sync(2). And I know that those sync() calls will be every
>> forty-to-sixty seconds because of reasons. It would be "neat" to be ab=
le
>> to set the commit=3Dn to some high value, like 90, and then "normally"=
 the
>> sync() behaviours would follow the application instead of the larger
>> commit interval.
>>
>> The value would be that the file system would tend _not_ to go into sy=
nc
>> while the application was still skittering about in the various files.=

>>
>> Of course any other applications could call sync from their own contex=
ts
>> for their own reasons. And there's an implicit fsync() on just about a=
ny
>> close() (at least if everything is doing its business "correctly")
>>
>> It may be a strange idea but I can think of some near realtime
>> applications might be able to leverage a modicum of control over the
>> sync event. There is no API, and not strong reason to desire one, for
>> controlling the commit via (low privelege) applications.
>>
>> But if the plumbing exists, then having a mode where sync() or fsync()=

>> (which I think causes a general sync because of the journal) resets th=
e
>> commit timer could be really interesting.
>>
>> With any kind of delayed block choice/mapping it could actually reduce=

>> the entropy of the individual files for repeated random small writes.
>> The application would have to be reasonably aware, of course.
>>
>> Since something is causing a sync() the commit=3DN guarantee is still
>> being met for the whole system for any N, but applications could tend =
to
>> avoid mid-write commits by planing their sync()s.
>>
>> Just a thought.
>=20
>=20


--CGkRiGfS5wQVRGot1LH5P5hGW70cdDkmj--

--PxB6V3lmj4Bm6MBQ66aHT2BvLqBQvkBfq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloI6iQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgXpggAgoXUOVj2nYBK7g35RCCXNCMR
ZPO/Ypu6GZsOsEqISD1sfncw2klamKz46ZvfK6RPf/edlaHvmc5ECOlfd+feABcB
xITW3vSbm3njZuM0CecpNX4+bVqKQQ1OeMUYmUhVnMNdpgiyaFPewnelqe+5DHOL
2lIWfpYnVS9TyXr+p2akhQjpdko+qlRHM0438WagKfJYhvavaDgiUDsPjKnF/HO8
mjbpTnatvuw/1ZofZxAvUCY63mf6U5PAtSd5II7BhjTs1+wNv3FKMPYalt7Kww8w
+rxhnXgX9JymFWcug3bmLX4H8fx2Svotvbt7M37yJ80+ESIuUAJh0p/CO6h19Q==
=KZua
-----END PGP SIGNATURE-----

--PxB6V3lmj4Bm6MBQ66aHT2BvLqBQvkBfq--
