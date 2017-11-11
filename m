Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54400 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754179AbdKKDtH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 22:49:07 -0500
Subject: Re: discard on SSDs quickly causes backup trees to vanish
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
 <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
 <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d8bb0868-e969-c83c-0615-838cbc52232f@gmx.com>
Date: Sat, 11 Nov 2017 11:48:54 +0800
MIME-Version: 1.0
In-Reply-To: <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iqswOg0x1THbQoqiJqEIbOQXWiRIuwG2g"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iqswOg0x1THbQoqiJqEIbOQXWiRIuwG2g
Content-Type: multipart/mixed; boundary="CvPK6n3hfr7sNNqOjPpt74UVW3KP623JW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Chris Murphy <chris@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <d8bb0868-e969-c83c-0615-838cbc52232f@gmx.com>
Subject: Re: discard on SSDs quickly causes backup trees to vanish
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
 <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
 <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com>
In-Reply-To: <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com>

--CvPK6n3hfr7sNNqOjPpt74UVW3KP623JW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8811=E6=97=A5 11:13, Hans van Kranenburg wrote:
> On 11/11/2017 03:30 AM, Qu Wenruo wrote:
>>
>> On 2017=E5=B9=B411=E6=9C=8811=E6=97=A5 09:54, Hans van Kranenburg wrot=
e:
>>> On 11/11/2017 12:52 AM, Chris Murphy wrote:
>>>> Hardware:
>>>> HP Spectre which contains a SAMSUNG MZVLV256HCHP-000H1, which is an =
NVMe drive.
>>>>
>>>> Kernels:
>>>> various but definitely 4.12.0 through 4.13.10
>>>>
>>>> Problem:
>>>> Within seconds of the super being updated to point to a new root tre=
e,
>>>> the old root tree cannot be read with btrfs-debug-tree.
>>>
>>> Is this a problem, or is this just expected, by design?
>>
>> It is a problem.
>>
>> By design, tree block should only be discarded after no one is referri=
ng
>> to it. Note: commit root (last committed transaction) also counts.
>>
>> So that's to say, last committed transaction must be alive, until
>> current transaction is committed.
>=20
> Yes, well, that's no different than what I was saying.
>=20
>> If tree block is discarded during a uncommitted transaction, and power=

>> loss happened, the fs can not be mounted any more (if a vital tree is
>> corrupted).
>>
>> Even after transaction commitment, discard a tree block of last
>> transaction can lead to recovery problem (e.g. rollback the fs to
>> previous trans using backup roots)
>>>
>>>> Example:
>>>>
>>>>
>>>> $ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
>>>> btrfs-progs v4.13.3
>>>> node 84258750464 level 1 items 2 free 491 generation 200994 owner 1
>>>> fs uuid 2662057f-e6c7-47fa-8af9-ad933a22f6ec
>>>> chunk uuid 1df72dcf-f515-404a-894a-f7345f988793
>>>>     key (EXTENT_TREE ROOT_ITEM 0) block 84258783232 (5142748) gen 20=
0994
>>>>     key (452 INODE_ITEM 0) block 84258881536 (5142754) gen 200994
>>>>
>>>> (wait 10-40 seconds while file system is in use)
>>>
>>> After the superblock is written, this space is freed up to be
>>> overwritten by new writes immediately...
>>
>> Nope, this should not be the case.
>=20
> The example is a block from a "backup root". It's ok to be overwritten.=

>=20
>> The correct behavior is, new write should *never* overwrite tree block=
s
>> used by commit_root (last committed transaction).
>>
>> Or there is nothing to protect btrfs from power loss.
>> (Btrfs doesn't use journal, but completely rely metadata CoW to handle=

>> power loss)
>>
>>>
>>>> $ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
>>>> btrfs-progs v4.13
>>>> checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000=

>>>> checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000=

>>>> bytenr mismatch, want=3D84258750464, have=3D0
>>>> ERROR: failed to read 84258750464
>>>> [chris@f26h ~]$
>>>
>>> Even when not using discard, there might be new data in that place no=
w,
>>> when the file system is in use...
>>
>> As explained above, btrfs use CoW to survive power loss, especially fo=
r
>> metadata, so tree blocks of last committed transaction should not be
>> touched at all.
>>
>> So, this is a problem, and I think that's why discard is not recommend=
ed
>> for btrfs (yet).
>> And we should have more runtime checks to ensure we won't allocate any=

>> space used by committed transaction.
>>
>>>
>>>> This suggests a problem for any kind of automatic recovery, should i=
t
>>>> be needed at next mount time, following a crash or power failure, as=

>>>> well as rendering the usebackuproot useless.
>>>
>>> Maybe the name backuproot is useless, because it's not a backup at al=
l.
>>
>> Most of the backup root is more or less useless, if and only if metada=
ta
>> CoW is done completely as design.
>=20
> Is there an 'unless' missing here?
>=20
>> One more chance to recover is never a bad idea.
>=20
> It is a bad idea. The *only* case you can recover from is when you
> freeze the filesystem *directly* after writing the superblock. Only in
> that case you have both a consistent last committed and previous
> transaction on disk.

You're talking about the ideal case.

The truth is, we're living in a real world where every software has
bugs. And that's why sometimes we get transid error.

So keeps the backup root still makes sense.

And further more, different trees have different update frequency.
For root and extent tree, they get updated every transaction, while for
chunk tree it's seldom updated.

And backup roots are updated per transaction, which means we may have a
high chance to recover at least chunk root and to know the chunk map and
possible to grab some data.

>=20
> If you do new writes and then again are able to mount with -o
> usebackuproot and if any of the
> transaction-before-the-last-committed-transaction blocks are overwritte=
n
> you're in a field of land mines and time bombs. Being able to mount
> gives a false sense of recovery to the user in that case, because eithe=
r
> you're gonna crash into transid problems for metadata, or there are
> files in the filesystem in which different data shows up than should,
> potentially allowing users to see data from other users etc... It's jus=
t
> dangerous.
>=20
>> As you can see, if metadata CoW is completely implemented as designed,=

>> there will be no report of transid mismatch at all.
>> And btrfs should be bullet proof from the very beginning, but none of
>> these is true.
>=20
> It is, it's not a bug. This is about the backup roots thingie, not abou=
t
> the data from the last transaction.

Check the original post.
It only gives the magic number, it's not saying if it's from backup root.=


If it's dumped from running fs (it's completely possible) then it's the
problem I described.

Anyway, no matter what you think if it's a bug or not, I'll enhance tree
allocator to do extra check if the result overwrites the commit root.

And I strongly suspect transid related problems reported from mail list
has something to do with it.

Thanks,
Qu
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>> Only the most recent previous one is if you have to mount a filesyste=
m
>>> directly after some bug hosed your tree of trees during a final commi=
t
>>> when umounting just before?
>>>
>>>> I think until discard mount option has some kind of delay (generatio=
n
>>>> based perhaps), so that at least the various backup trees, in
>>>> particular the root tree, is not immediately subject to discard, tha=
t
>>>> the Btrfs wiki needs to suggest the discard mount option is unsafe o=
n
>>>> SSD.
>>>>
>>>> While I have not experienced any other problems in roughly a year of=

>>>> using discard and Btrfs on this hardware, if I had needed a rollback=

>>>> offered by use of a backup tree, they simply wouldn't have been
>>>> available, and I'd have been hosed.
>>>> (Needs testing on LVM thinp to see if discard causes a similar probl=
em
>>>> with Btrfs on LVM thinly provisioned volumes, even with hard drives.=
)
>>>
>>> I actually start wondering why this option exists at all. I mean, eve=
n
>>> when it seems you get a working filesystem back with it, there can be=

>>> metadata and data in all corners of the filesystem that already has b=
een
>>> overwritten?
>>>
>>> It was introduced in commit af31f5e5b "Btrfs: add a log of past tree
>>> roots" and the only information we get is "just in case we somehow lo=
se
>>> the roots", which is an explanation for adding this feature that does=

>>> not really tell me much about it.
>>>
>=20
>=20


--CvPK6n3hfr7sNNqOjPpt74UVW3KP623JW--

--iqswOg0x1THbQoqiJqEIbOQXWiRIuwG2g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloGcyYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjm1Qf/VTrpQ8tzb5Lm/+KQsGYbW7Ss
Zg5JU+t70tSnxsdK/rWxhlXIfWnN5F6KpJH4FKLT6O71KTvHEtODBgdCPJUTJCh7
3nyHBIRu1oCGyF3I7LtpuPGTJ9puysjFtiS06yU8wKwpwemUl+kAYl9A/spXO4Na
Ml8uK4tAR9ZZ+S2NNHXUKaQEoZ+r7P0BfgMIrtMEs9NXD2zlR7yaCwipsCSW3/wg
9o25UJVBm+2RjnzuX7qkldKuRtVM9XM5QOleYbTEUhyViSG/KElQRn20DBc92UKO
FCYuOIRV8BdmXx3bsba5IvqerNQdTOszy6MVJaE9E9Rlv667ZwtIEmqGy4u7ew==
=I26w
-----END PGP SIGNATURE-----

--iqswOg0x1THbQoqiJqEIbOQXWiRIuwG2g--
