Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57919 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbdKKCay (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 21:30:54 -0500
Subject: Re: discard on SSDs quickly causes backup trees to vanish
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
Date: Sat, 11 Nov 2017 10:30:42 +0800
MIME-Version: 1.0
In-Reply-To: <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uuDEgALgsji01ULBk6CI56L9DF46rAJ0b"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uuDEgALgsji01ULBk6CI56L9DF46rAJ0b
Content-Type: multipart/mixed; boundary="FpGbAchCinmLHIKQlaakKEUKvdNFraJeQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Chris Murphy <chris@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
Subject: Re: discard on SSDs quickly causes backup trees to vanish
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
In-Reply-To: <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>

--FpGbAchCinmLHIKQlaakKEUKvdNFraJeQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8811=E6=97=A5 09:54, Hans van Kranenburg wrote:
> On 11/11/2017 12:52 AM, Chris Murphy wrote:
>> Hardware:
>> HP Spectre which contains a SAMSUNG MZVLV256HCHP-000H1, which is an NV=
Me drive.
>>
>> Kernels:
>> various but definitely 4.12.0 through 4.13.10
>>
>> Problem:
>> Within seconds of the super being updated to point to a new root tree,=

>> the old root tree cannot be read with btrfs-debug-tree.
>=20
> Is this a problem, or is this just expected, by design?

It is a problem.

By design, tree block should only be discarded after no one is referring
to it. Note: commit root (last committed transaction) also counts.

So that's to say, last committed transaction must be alive, until
current transaction is committed.

If tree block is discarded during a uncommitted transaction, and power
loss happened, the fs can not be mounted any more (if a vital tree is
corrupted).

Even after transaction commitment, discard a tree block of last
transaction can lead to recovery problem (e.g. rollback the fs to
previous trans using backup roots)
>=20
>> Example:
>>
>>
>> $ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
>> btrfs-progs v4.13.3
>> node 84258750464 level 1 items 2 free 491 generation 200994 owner 1
>> fs uuid 2662057f-e6c7-47fa-8af9-ad933a22f6ec
>> chunk uuid 1df72dcf-f515-404a-894a-f7345f988793
>>     key (EXTENT_TREE ROOT_ITEM 0) block 84258783232 (5142748) gen 2009=
94
>>     key (452 INODE_ITEM 0) block 84258881536 (5142754) gen 200994
>>
>> (wait 10-40 seconds while file system is in use)
>=20
> After the superblock is written, this space is freed up to be
> overwritten by new writes immediately...

Nope, this should not be the case.

The correct behavior is, new write should *never* overwrite tree blocks
used by commit_root (last committed transaction).

Or there is nothing to protect btrfs from power loss.
(Btrfs doesn't use journal, but completely rely metadata CoW to handle
power loss)

>=20
>> $ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
>> btrfs-progs v4.13
>> checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
>> bytenr mismatch, want=3D84258750464, have=3D0
>> ERROR: failed to read 84258750464
>> [chris@f26h ~]$
>=20
> Even when not using discard, there might be new data in that place now,=

> when the file system is in use...

As explained above, btrfs use CoW to survive power loss, especially for
metadata, so tree blocks of last committed transaction should not be
touched at all.

So, this is a problem, and I think that's why discard is not recommended
for btrfs (yet).
And we should have more runtime checks to ensure we won't allocate any
space used by committed transaction.

>=20
>> This suggests a problem for any kind of automatic recovery, should it
>> be needed at next mount time, following a crash or power failure, as
>> well as rendering the usebackuproot useless.
>=20
> Maybe the name backuproot is useless, because it's not a backup at all.=


Most of the backup root is more or less useless, if and only if metadata
CoW is done completely as design.

One more chance to recover is never a bad idea.
As you can see, if metadata CoW is completely implemented as designed,
there will be no report of transid mismatch at all.
And btrfs should be bullet proof from the very beginning, but none of
these is true.

Thanks,
Qu

>=20
> Only the most recent previous one is if you have to mount a filesystem
> directly after some bug hosed your tree of trees during a final commit
> when umounting just before?
>=20
>> I think until discard mount option has some kind of delay (generation
>> based perhaps), so that at least the various backup trees, in
>> particular the root tree, is not immediately subject to discard, that
>> the Btrfs wiki needs to suggest the discard mount option is unsafe on
>> SSD.
>>
>> While I have not experienced any other problems in roughly a year of
>> using discard and Btrfs on this hardware, if I had needed a rollback
>> offered by use of a backup tree, they simply wouldn't have been
>> available, and I'd have been hosed.
>> (Needs testing on LVM thinp to see if discard causes a similar problem=

>> with Btrfs on LVM thinly provisioned volumes, even with hard drives.)
>=20
> I actually start wondering why this option exists at all. I mean, even
> when it seems you get a working filesystem back with it, there can be
> metadata and data in all corners of the filesystem that already has bee=
n
> overwritten?
>=20
> It was introduced in commit af31f5e5b "Btrfs: add a log of past tree
> roots" and the only information we get is "just in case we somehow lose=

> the roots", which is an explanation for adding this feature that does
> not really tell me much about it.
>=20


--FpGbAchCinmLHIKQlaakKEUKvdNFraJeQ--

--uuDEgALgsji01ULBk6CI56L9DF46rAJ0b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloGYNIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjC7Af/f5y3/EhVMz53wfmgClB1Rwqn
E+DRk2aQwFzEFR2/Zl+c/bQJ1kha58XKJXyT3++u+stjDG4g8FYRodF5TKKrBdRt
7lKCxhWKg9xKjYEBW6jVpYp3DRCLcEq5EC3gS31tOBY9tBDZMSclczezYaxMyGVB
u2c+JKKUvyaW/0YqP6AU0dmfSuv7Ex95q54Q07dbiT1GFffiIRvebWaUlgwW7eTV
GwmsEiEeYc0XMAoMBeUZ0CuT0wsrooUNtg0Lr3HqbzJLDEGO66QGv1PanUbCoS5I
D77d26otWUWg9B8I2kahkv9mZ1/U7xEDdVs+rHspw9Km/72OzNQrXlYrtLDDlw==
=v38+
-----END PGP SIGNATURE-----

--uuDEgALgsji01ULBk6CI56L9DF46rAJ0b--
