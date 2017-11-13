Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62666 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbdKMBZS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 20:25:18 -0500
Subject: Re: Theoretical Question about commit=n
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Robert White <rwhite@pobox.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b845c5b3-1241-723d-c7a9-ddfe4a550d8d@pobox.com>
 <dacaa3b1-d6c1-44d3-4fef-28db73af3e90@mendix.com>
 <c768fcf7-f206-2667-ce0e-b7f5deaff1e4@gmx.com>
 <98b94ef2-4744-7481-8866-cd0f2b8a9d68@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <da4030b3-1bbe-ca37-eb85-3a82047f59cd@gmx.com>
Date: Mon, 13 Nov 2017 09:25:07 +0800
MIME-Version: 1.0
In-Reply-To: <98b94ef2-4744-7481-8866-cd0f2b8a9d68@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DSTaVK4Worgj8mhKAmGj8xhG60dKrqgN1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DSTaVK4Worgj8mhKAmGj8xhG60dKrqgN1
Content-Type: multipart/mixed; boundary="6u0FqoOiRq8GAnba9hAUiaLjbohSD917T";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Robert White <rwhite@pobox.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <da4030b3-1bbe-ca37-eb85-3a82047f59cd@gmx.com>
Subject: Re: Theoretical Question about commit=n
References: <b845c5b3-1241-723d-c7a9-ddfe4a550d8d@pobox.com>
 <dacaa3b1-d6c1-44d3-4fef-28db73af3e90@mendix.com>
 <c768fcf7-f206-2667-ce0e-b7f5deaff1e4@gmx.com>
 <98b94ef2-4744-7481-8866-cd0f2b8a9d68@mendix.com>
In-Reply-To: <98b94ef2-4744-7481-8866-cd0f2b8a9d68@mendix.com>

--6u0FqoOiRq8GAnba9hAUiaLjbohSD917T
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8813=E6=97=A5 09:17, Hans van Kranenburg wrote:
> On 11/13/2017 01:41 AM, Qu Wenruo wrote:
>>
>> On 2017=E5=B9=B411=E6=9C=8813=E6=97=A5 06:01, Hans van Kranenburg wrot=
e:
>>> On 11/12/2017 09:58 PM, Robert White wrote:
>>>> Is the commit interval monotonic, or is it seconds after sync?
>>>>
>>>> What I mean is that if I manually call sync(2) does the commit timer=

>>>> reset? I'm thinking it does not, but I can imagine a workload where =
it
>>>> ideally would.
>>>
>>> The magic happens inside the transaction kernel thread:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/fs/btrfs/disk-io.c?h=3Dv4.14#n1925
>>>
>>> You can see the delay being computed:
>>>     delay =3D HZ * fs_info->commit_interval;
>>>
>>> Almost at the end of the function, you see:
>>>     schedule_timeout(delay)
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/kernel/time/timer.c?h=3Dv4.14#n1676
>>>
>>> This schedule_timeout function sets a timer and then the thread goes =
to
>>> sleep. If nothing happens, the kernel will wake up the thread after t=
he
>>> timer expires (can be later, but not earlier) and then it will redo t=
he
>>> loop.
>>>
>>> If something else wakes up the transaction thread, the timer is
>>> discarded if it's not expired yet.
>>
>> So far so good.
>>
>>>
>>> So it works like you would want.
>>
>> Not exactly.
>=20
> Ah, interesting.
>=20
>> Sync or commit_transaction won't wake up transaction_kthread.
>>
>> transaction_kthread will mostly be woken by trans error, remount or
>> under certain case of btrfs_end_transaction.
>>
>> So manually sync will not (at least not always) interrupt commit inter=
val.
>=20
> The fun thing is, when I just do sync, I see that the time it takes for=

> a next generation bump to happen is reset (while doing something simple=

> like touch x in a loop in another terminal).

Maybe something else is related.

You could dig it a little further by tracking which caller committed the
transaction, and I can totally be wrong about this.

>=20
>> And even more, transaction_kthread will only commit transaction, which=

>> means it will only ensure metadata consistent.
>>
>> It won't ensure buffered write to reach disk if its extent is not
>> allocated yet (delalloc).
>=20
> Hm, I have seen things like that in BTRFS_IOC_SYNC...
>=20
> Actually, I first responded on the timer reset question, because that
> one was easy to answer. I don't know if I want to descend the path
> further into (f)sync. I heard it can get really messy down there. :]

Yep, very messy.
Not messy within btrfs itself, but also related to kernel memory manageme=
nt.

And welcome to the hell of filesystem development.

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>>
>>> You can test this yourself by looking at the "generation" number of y=
our
>>> filesystem. It's in the output of btrfs inspect dump-super:
>>>
>>> This is the little test filesystem I just used:
>>>
>>> -# btrfs inspect dump-super /dev/dorothy/mekker | grep ^generation
>>> generation		35
>>>
>>> If you print the number in a loop, like every second, you can see it
>>> going up after a transaction happened. Now play around with other thi=
ngs
>>> and see when it changes.
>>>
>>>> (Again, this is purely theoretical, I have no such workload as I am
>>>> about to describe.)
>>>>
>>>> So suppose I have some sort of system, like a database, that I know =
will
>>>> do scattered writes and extends through some files and then call som=
e
>>>> variant of sync(2). And I know that those sync() calls will be every=

>>>> forty-to-sixty seconds because of reasons. It would be "neat" to be =
able
>>>> to set the commit=3Dn to some high value, like 90, and then "normall=
y" the
>>>> sync() behaviours would follow the application instead of the larger=

>>>> commit interval.
>>>>
>>>> The value would be that the file system would tend _not_ to go into =
sync
>>>> while the application was still skittering about in the various file=
s.
>>>>
>>>> Of course any other applications could call sync from their own cont=
exts
>>>> for their own reasons. And there's an implicit fsync() on just about=
 any
>>>> close() (at least if everything is doing its business "correctly")
>>>>
>>>> It may be a strange idea but I can think of some near realtime
>>>> applications might be able to leverage a modicum of control over the=

>>>> sync event. There is no API, and not strong reason to desire one, fo=
r
>>>> controlling the commit via (low privelege) applications.
>>>>
>>>> But if the plumbing exists, then having a mode where sync() or fsync=
()
>>>> (which I think causes a general sync because of the journal) resets =
the
>>>> commit timer could be really interesting.
>>>>
>>>> With any kind of delayed block choice/mapping it could actually redu=
ce
>>>> the entropy of the individual files for repeated random small writes=
=2E
>>>> The application would have to be reasonably aware, of course.
>>>>
>>>> Since something is causing a sync() the commit=3DN guarantee is stil=
l
>>>> being met for the whole system for any N, but applications could ten=
d to
>>>> avoid mid-write commits by planing their sync()s.
>>>>
>>>> Just a thought.
>>>
>>>
>=20
>=20


--6u0FqoOiRq8GAnba9hAUiaLjbohSD917T--

--DSTaVK4Worgj8mhKAmGj8xhG60dKrqgN1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloI9HMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgRowgAjWoDOmoakPIiCIw4xEMK/Vzn
ujoOqbWJRgvqLfrPmf9Crh3gxRv/gDsUXYOUinmFsgHM+h2EDfgsqy5fD4yJLJHh
29YR5XBLijrkfmvK0I49FQ3kw8to/JdPW7D8L4VCx94h70zzuGtmTCv1PhVTisjR
/96W37sQW7rRxHOCVCHLYBZ6Vgd7pcJfmfw3bh+A8zhnV5ENF0FkRHrLYX14jtmm
0mJb5aj4a7gL7B7f9gPxju6G3MovzU5pHLBpR/12ldjS2AMZbPVsJtZwI92mFrSt
oncGObniS1dSUCM2LqCcwkI32RITlBCzvgGYdESrOBWsjAIWf9cuZWI6fQ3kBw==
=yFi7
-----END PGP SIGNATURE-----

--DSTaVK4Worgj8mhKAmGj8xhG60dKrqgN1--
