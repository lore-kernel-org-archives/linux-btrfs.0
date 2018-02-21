Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49801 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750710AbeBUBtd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 20:49:33 -0500
Subject: Re: Status of FST and mount times
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "Ellis H. Wilson III" <ellisw@panasas.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
 <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
 <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4590b70e-2be7-b511-1428-685dcf2c26c6@gmx.com>
Date: Wed, 21 Feb 2018 09:49:10 +0800
MIME-Version: 1.0
In-Reply-To: <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fPz8CLUzlxrtKE8o4ZsN7dme5lDmEhYjd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fPz8CLUzlxrtKE8o4ZsN7dme5lDmEhYjd
Content-Type: multipart/mixed; boundary="lRnKjHQFgffmjNQYBkxcwQuthvsvV08Wn";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 "Ellis H. Wilson III" <ellisw@panasas.com>,
 Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <4590b70e-2be7-b511-1428-685dcf2c26c6@gmx.com>
Subject: Re: Status of FST and mount times
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
 <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
 <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
In-Reply-To: <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>

--lRnKjHQFgffmjNQYBkxcwQuthvsvV08Wn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8820=E6=97=A5 23:41, Austin S. Hemmelgarn wrote:=

> On 2018-02-20 09:59, Ellis H. Wilson III wrote:
>> On 02/16/2018 07:59 PM, Qu Wenruo wrote:
>>> On 2018=E5=B9=B402=E6=9C=8816=E6=97=A5 22:12, Ellis H. Wilson III wro=
te:
>>>> $ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc -l
>>>> 3454
>>>
>>> OK, this explains everything.
>>>
>>> There are too many chunks.
>>> This means at mount you need to search for block group item 3454 time=
s.
>>>
>>> Even each search only needs to iterate 3 tree blocks, multiply it 345=
4
>>> it would still be a big work.
>>> Although some tree blocks like the root node and level 1 nodes can be=

>>> cached, we still need to read about 3500 tree blocks.
>>>
>>> If the fs is created using 16K nodesize, this means you need to do
>>> random read for 54M using 16K blocksize.
>>>
>>> No wonder it will takes some time.
>>>
>>> Normally I would expect 1G chunk for each data and metadata chunk.
>>>
>>> If there is nothing special, it means your filesystem is already larg=
er
>>> than 3T.
>>> If your used space is way smaller (less than 30%) than 3.5T, then thi=
s
>>> means your chunk usage is pretty low, and in that case, balance to
>>> reduce number of chunks (block groups) would reduce mount time.
>>
>> The nodesize is 16K, and the filesystem data is 3.32TiB as reported by=

>> btrfs fi df.=C2=A0 So, from what I am hearing, this mount time is norm=
al
>> for a filesystem this size.=C2=A0 Ignoring a more complex and proper f=
ix
>> like the ones we've been discussing, would bumping the nodesize reduce=

>> the number of chunks, thereby reducing the mount time?
> It would probably not.=C2=A0 Chunk size is only based on the total size=
 of
> the filesystem, with reasonable base values, so you would still need to=

> have at least as many chunks to store the same amount of data (increase=

> the node size too much though, and you will end up with more chunks,
> because you'll have more empty space wasted).

Increasing node size may reduce extent tree size. Although at most
reduce one level AFAIK.

But considering that the higher the node is, the more chance it's
cached, reducing tree height wouldn't bring much performance impact AFAIK=
=2E

If one could do real world benchmark to beat or prove my assumption, it
would be much better though.

>>
>> I don't see why balance would come into play here -- my understanding
>> was that was for aged filesystems.=C2=A0 The only operations I've done=
 on
>> here was:
>> 1. Format filesystem clean
>> 2. Create a subvolume
>> 3. rsync our home directories into that new subvolume
>> 4. Create another subvolume
>> 5. rsync our home directories into that new subvolume
>>
>> Accordingly, zero (or at least, extremely little) data should have
>> been overwritten, so I would expect things to be fairly well allocated=

>> already.=C2=A0 Please correct me if this is naive thinking.
> Your logic is in general correct regarding data, but not necessarily
> metadata.=C2=A0 Assuming you did not use the `--inplace` option for rsy=
nc, it
> had to issue a rename for each individual file that got copied in, and
> as a result there was likely a lot of metadata being rewritten.
>=20
> As far as balance being for aged filesystems, that's not exactly true.
> There are four big reasons you might run a balance:
>=20
> 1. As part of reshaping a volume.=C2=A0 You generally want run a balanc=
e
> whenever the number of disks in a volume permanently increases (it will=

> happen automatically when it permanently decreases, as the device
> deletion operation is a special type of balance under the hood).=C2=A0 =
It's
> also used for converting chunk profiles.
> 2. To free up empty space inside chunks when the filesystem is full at
> the chunk level.
> 3. To redistribute data across multiple disks in a more even manner
> after deleting a lot of data.
> 4. To reduce the likelihood of 2 or 3 being an issue.
>=20
> Reasons 2 and 3 are generally more likely to be needed on old volumes.
> Reason 1 is independent of the age of a volume.=C2=A0 Reason 4 is the r=
eason
> for the regular filtered balances that I and some other people recommen=
d
> be run as part of preventative maintenance, and is also generally
> independent of the age of a volume.
>=20
> Qu's suggestion is actually independent of all the above reasons, but
> does kind of fit in with the fourth as another case of preventative
> maintenance.

My suggestion is to use balance to reduce number of block groups, so we
could do less search at mount time.

It's more like reason 2.

But it only works for case where there are a lot of fragments so a lot
of chunks are not fully utilized.
Unfortunately, that's not the case for OP, so my suggestion doesn't make
sense here.

BTW, if OP still wants to try something to possibly to reduce mount time
with same the fs, I could try some modification to current block group
iteration code to see if it makes sense.

Thanks,
Qu

>>
>>>> I was using btrfs sub del -C for the deletions, so I believe (if tha=
t
>>>> command truly waits for the subvolume to be utterly gone) it capture=
s
>>>> the entirety of the snapshot.
>>>
>>> No, snapshot deletion is completely delayed in background.
>>>
>>> -C only ensures that even a powerloss happen after command return, yo=
u
>>> won't see the snapshot anywhere, but it will still be deleted in
>>> background.
>>
>> Ah, I had no idea.=C2=A0 Thank you!=C2=A0 Is there any way to "encoura=
ge"
>> btrfs-cleaner to run at specific times, which I presume is the
>> snapshot deletion process you are referring to?=C2=A0 If it can be tol=
d to
>> run at a given time, can I throttle how fast it works, such that I
>> avoid some of the high foreground interruption I've seen in the past?
> I don't think there's any way to do this right now (though it would be
> nice if there was).=C2=A0 In theory, you could adjust the priority of t=
he
> kernel thread itself, but messing around with kthread priorities is
> seriously dangerous even if you know exactly what you're doing.
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--lRnKjHQFgffmjNQYBkxcwQuthvsvV08Wn--

--fPz8CLUzlxrtKE8o4ZsN7dme5lDmEhYjd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqM0BYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhBXwgAjf5Kmz/SS8d9QoxaQINX52Nt
O1kHEwvJa/b/avQLCsJ30JZW03xuwZZtKBz/9nbdLaJksRW863qi+1tn7PvvjR97
WXWh2PYlhnLIePntTTf0v30MAhvtns8ta+lJrpFylNVlhZMawfkZkQ7kaCJvFwh1
r5XXYv6DcAaq0Kqg8jFyOVwQ5eHYrUVGWRF97rgQVlJ4cdhNVJyHPJDk40ZeY+Bp
GGdq8wujhmTzO5x+1EYUa7jaThQXDMoC7JzXoq1zU9Zzx82DOIgNvr3m/DY9IHBU
NtW2zVVOOzQQ2mSDrDqKASEcRcaAjOKt7VyCunu16NFncse1ufX2+inyqiTOvA==
=CTBD
-----END PGP SIGNATURE-----

--fPz8CLUzlxrtKE8o4ZsN7dme5lDmEhYjd--
