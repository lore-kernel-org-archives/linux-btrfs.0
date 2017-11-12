Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54794 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752199AbdKLA3L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Nov 2017 19:29:11 -0500
Subject: Re: discard on SSDs quickly causes backup trees to vanish
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
 <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
 <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com>
 <d8bb0868-e969-c83c-0615-838cbc52232f@gmx.com>
 <14623c86-e452-953f-70cd-603a49de4b63@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6c8f20dd-e2b8-3d7c-697a-73d4444ad56b@gmx.com>
Date: Sun, 12 Nov 2017 08:28:57 +0800
MIME-Version: 1.0
In-Reply-To: <14623c86-e452-953f-70cd-603a49de4b63@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qcEm75XHRcbQKGUEHQ2FO5PEimwjTppic"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qcEm75XHRcbQKGUEHQ2FO5PEimwjTppic
Content-Type: multipart/mixed; boundary="uM4cXLP33x5Cl6IaqNW0OjBNjLKMVKPje";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Chris Murphy <chris@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <6c8f20dd-e2b8-3d7c-697a-73d4444ad56b@gmx.com>
Subject: Re: discard on SSDs quickly causes backup trees to vanish
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
 <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
 <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com>
 <d8bb0868-e969-c83c-0615-838cbc52232f@gmx.com>
 <14623c86-e452-953f-70cd-603a49de4b63@mendix.com>
In-Reply-To: <14623c86-e452-953f-70cd-603a49de4b63@mendix.com>

--uM4cXLP33x5Cl6IaqNW0OjBNjLKMVKPje
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8812=E6=97=A5 04:12, Hans van Kranenburg wrote:
> Hi,
>=20
> On 11/11/2017 04:48 AM, Qu Wenruo wrote:
>>
>> On 2017=E5=B9=B411=E6=9C=8811=E6=97=A5 11:13, Hans van Kranenburg wrot=
e:
>>> On 11/11/2017 03:30 AM, Qu Wenruo wrote:
>>>>
>>>
>>>> One more chance to recover is never a bad idea.
>>>
>>> It is a bad idea. The *only* case you can recover from is when you
>>> freeze the filesystem *directly* after writing the superblock. Only i=
n
>>> that case you have both a consistent last committed and previous
>>> transaction on disk.
>>
>> You're talking about the ideal case.
>>
>> The truth is, we're living in a real world where every software has
>> bugs. And that's why sometimes we get transid error.
>>
>> So keeps the backup root still makes sense.
>>
>> And further more, different trees have different update frequency.
>> For root and extent tree, they get updated every transaction, while fo=
r
>> chunk tree it's seldom updated.
>>
>> And backup roots are updated per transaction, which means we may have =
a
>> high chance to recover at least chunk root and to know the chunk map a=
nd
>> possible to grab some data.
>=20
>     That's entirely right yes. But "possible to grab some data" is a
> whole different thing than "getting the filesystem back into a fully
> functional consistent state..."
>=20
>     So it's about expectation management for end users. If the user
> thinks "Ha! A backup! That's nice of btrfs, it keeps them so I can go
> back!.", then the user will get disappointed when the backups are unusa=
ble.

Without discard, user should be able to rollback to previous transaction
(backup_root[0])

The last transaction committed with commit_root and root->node switched,
and as I stated in previous mail, until this swtich, commit_root must be
fully available.

And after the last transaction there is no modification (since the last
trans is for unmount), so backuproot[0] should be fully accessible.

Discard can break it unless we have method to trace tree block space
usage for at least 2 transactions.

>=20
> The design of btrfs is that all metadata tree blocks and data extent
> space that is not used by the last completed transaction are freed to b=
e
> reused, as soon as possible. For cow-only roots (e.g. root tree, extent=

> tree) this is already done immediately in the transaction code after
> writing the super block (btrfs_finish_extent_commit, discard is also
> immediately triggered), and for reference counted roots (subvolume
> roots) the cleaner will asap do it.
>=20
> So, the design gives zero guarantee that following a backup root will
> work. But, it's better than nothing when trying to scrape some data off=

> of the borken filesystem.

Again, only for discard.

>=20
>     Maybe it's enough to change man 5 btrfs with the mount options with=

> a warning for the usebackuproot option to let the user know that doing
> this might result in a mountable filesystem, but that even in case it
> does, the result should only be used to get as much data as possible of=
f
> of it before doing mkfs again. Or, if it succeeds, and if also umountin=
g
> again and running a full btrfsck and scrub to check all metadata and
> data succeeds, the user might be pretty confident that nothing
> referenced by the previous backuproot was already overwritten with new
> data, in which case the filesystem can be continued to be used.
>=20
> But it puts usebackuproot very much in the same department where tools
> like btrfs-restore live.

Isn't it the original design?
No one sane would use it for daily usage and it's original called
"recovery", I don't see any problem here.

Thanks,
Qu

>=20
>>> If you do new writes and then again are able to mount with -o
>>> usebackuproot and if any of the
>>> transaction-before-the-last-committed-transaction blocks are overwrit=
ten
>>> you're in a field of land mines and time bombs. Being able to mount
>>> gives a false sense of recovery to the user in that case, because eit=
her
>>> you're gonna crash into transid problems for metadata, or there are
>>> files in the filesystem in which different data shows up than should,=

>>> potentially allowing users to see data from other users etc... It's j=
ust
>>> dangerous.
>>>
>>>> As you can see, if metadata CoW is completely implemented as designe=
d,
>>>> there will be no report of transid mismatch at all.
>>>> And btrfs should be bullet proof from the very beginning, but none o=
f
>>>> these is true.
>>>
>>> It is, it's not a bug. This is about the backup roots thingie, not ab=
out
>>> the data from the last transaction.
>>
>> Check the original post.
>> It only gives the magic number, it's not saying if it's from backup ro=
ot.
>>
>> If it's dumped from running fs (it's completely possible) then it's th=
e
>> problem I described.
>>
>> Anyway, no matter what you think if it's a bug or not, I'll enhance tr=
ee
>> allocator to do extra check if the result overwrites the commit root.
>>
>> And I strongly suspect transid related problems reported from mail lis=
t
>> has something to do with it.
>=20


--uM4cXLP33x5Cl6IaqNW0OjBNjLKMVKPje--

--qcEm75XHRcbQKGUEHQ2FO5PEimwjTppic
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloHlcoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhfvAf7BgIAXF4FvGnWrGwZ5SOe29ZP
aZbfd9MLmEsyX4DEG673Hsg09nX5aN6r6qEMupGTXStdOpDpQfTbxwF6fWikxi+2
ZMRUy0ypnpGQ0ApXL341OkrnSXciVTckltN68dqqAtivunjz7HCpRL2Zzv+M+i/E
Owg/iRjmqCapm7+AMcBvABx3kbjB4pgy3fw9w6YEUkOG3Sc42ExavFTb3ibBu2mR
D1eVgJ9X2d86nN4I7GPeySJBDA0pC1OKAP+o93jWXdBQhmdSJy2pAUB4wG8YDyNa
31h5BPk5errLZbjmPYsAk3h0U9qTylpE5ZMcFBzIq+1hHQXp+sV+xZPV3aSBtg==
=wYHc
-----END PGP SIGNATURE-----

--qcEm75XHRcbQKGUEHQ2FO5PEimwjTppic--
