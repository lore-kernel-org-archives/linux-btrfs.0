Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62146 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753498AbdL2CJD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 21:09:03 -0500
Subject: Re: Hand Patching a BTRFS Superblock?
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
 <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
Date: Fri, 29 Dec 2017 10:08:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3uWPYrbF1bH6gRT1uIBSb1t8GKAM2eQe6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3uWPYrbF1bH6gRT1uIBSb1t8GKAM2eQe6
Content-Type: multipart/mixed; boundary="9HTTk01MxsR7KFBeHtJERxoMQOZ5huBiq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
Subject: Re: Hand Patching a BTRFS Superblock?
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
 <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
In-Reply-To: <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>

--9HTTk01MxsR7KFBeHtJERxoMQOZ5huBiq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8829=E6=97=A5 09:41, Stirling Westrup wrote:
> Okay, I ran the command 'btrfs ins dump-super -fa' on each of the four
> drives of the array, which are currently sda, sdb, sdc, and sde, and
> attached the results as log files.
>=20
> As you'll note, the one superblock for sde is an exact copy of the one
> for sdc, as I copy the first 4M of sdc to sde before starting the
> recovery of the bad drive (sde is as much of that drive as I could
> copy, which all my tools claim is close to 99.99% of the original).

Well, from the result of e.log, there are no backup supers at all.

So either there is a offset when the data is recovered, or you lost most
of your data.

The good news is, according to the correct supers of devid 1/3/4, at
least your system and meta profile is RAID1, and they should be at least
RO degraded mountable.


Yes, this means you could get the needed device UUID and hand craft a
superblock.
But I really doubt about the possibility to success.

If you really want to do that, there is needed steps for you:

1) Get device info from your existing fs
   # btrfs ins dump-tree -t chunk </dev/sda>
   And looking for the following thing:
------
       item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16185 itemsize 98
                devid 2 total_bytes 10737418240 bytes_used 289406976
                io_align 4096 io_width 4096 sector_size 4096 type 0
                generation 0 start_offset 0 dev_group 0
                seek_speed 0 bandwidth 0
                uuid f1d9b288-7865-463f-a65c-ca8b1fbde09b
                fsid 1dd513fb-45f8-404f-ae23-979e3acb78ad
------
   Look for the key (DEV_ITEMS DEV_ITEM 2) and grab the "uuid"
   "total_bytes" "bytes_used" (other fields are mostly fixed)

2) Fill the fields of dev_item of a good superblock.
   If you feel it hard, I could help to do it if you provide the binary
   dump of any valid superblock, with above tree dump info.

But as I mentioned before, the disk seems to be heavily damaged or have
an unexpected offset.

Recovery using such method can easily lead to csum error and most (if
not all) RAID0 based data will unable to be read out.

I strongly recommend to do a binary search for magic number "5f42 4852
6653 5f4d" to locate the real offset (if it's offset, not a toasted image=
)

Thanks,
Qu

>=20
>=20
> On Thu, Dec 28, 2017 at 7:22 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8829=E6=97=A5 07:09, Stirling Westrup wrote:
>>> Using "btrfs rescue super-recover" is of no use since there are no
>>> valid superblocks on the disk I need to fix.
>>
>> Btrfs has normally 1 primary superblock and 1 or 2 backup superblocks.=

>>
>> super-recover is going to read the backup superblocks and use them as
>> the base to recover primary superblock.
>>
>> If super-recover can't even find the backups, then the disk is more
>> damaged than you have expected.
>>
>>> In fact, it's even worse,
>>> because the only even partly valid superblock is a copy of the one
>>> from drive sdd, which is a perfectly valid drive. What I need to do
>>> (as far as I can tell) is:
>>>
>>> 1) Patch the UUID_SUB and device number of sdf to make it distinct
>>> from sdd. Or just generate an entirely new superblock for sdf which
>>> indicates it is device 2 in the 4-device BTRFS (rather than device 1
>>> which it now thinks it is).
>>
>> You need your device UUID, which can be found in device tree.
>> (Only if you could mount the fs in RO and degraded mode, then you're
>> still OK to read it out)
>>
>> You're looking for this part of "btrfs ins dump-super" output:
>> ------
>> ...
>> cache_generation        8
>> uuid_tree_generation    8
>> dev_item.uuid           f1d9b288-7865-463f-a65c-ca8b1fbde09b <<<<<
>> dev_item.fsid           1dd513fb-45f8-404f-ae23-979e3acb78ad [match]
>> dev_item.type           0
>> dev_item.total_bytes    10737418240
>> ...
>> ------
>>
>>>
>>> 2) Recover (somehow) whatever other information from the superblock
>>> that is missing.
>>>
>>
>> Just as I said, if your backup super is also corrupted, there is littl=
e
>> chance to recover.
>>
>> To verify if the backups are still alive, please paste the output of
>> "btrfs ins dump-super -fa".
>> (Even you think super-recover is of no use, the output can still help)=

>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>> On Thu, Dec 28, 2017 at 7:11 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>> On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 19:41, Nikolay Borisov wrote:=

>>>>>
>>>>>
>>>>> On 28.12.2017 03:53, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>> On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 09:46, Stirling Westrup wro=
te:
>>>>>>> Here's my situation: I have a network file server containing a 12=
TB
>>>>>>> BTRFS spread out over four devices (sda-sdd) which I am trying to=

>>>>>>> recover. I do have a backup, but it's about 3 months old, and whi=
le I
>>>>>>> could certainly rebuild everything from that if I really had to, =
I
>>>>>>> would far rather not have to rerip my latest DVDs. So, I am willi=
ng to
>>>>>>> experiment if it might save me a few hundred hours of reconstruct=
ion.
>>>>>>> I don't currently have another 12 TB of space anywhere for making=
 a
>>>>>>> scratch copy.
>>>>>>>
>>>>>>> A few days ago sdb developed hard errors and I can no longer moun=
t the
>>>>>>> filesystem. sdb is no longer even recognized as a valid btrfs dri=
ve.
>>>>>>> However, when I ran ddrescue over the drive I managed to make a c=
lone
>>>>>>> (sdf) which contains all but 12K of the original drive. However, =
those
>>>>>>> missing 12K are all in the various superblocks, so the cloned dri=
ve is
>>>>>>> still unreadable.
>>>>>>>
>>>>>>> In the hopes that I was only missing a few bits of the superblock=
s, I
>>>>>>> started out by dd-ing the first 4M of sdd into sdf in the hopes t=
hat
>>>>>>> ddrescue would overwrite much of the superblocks, and the final b=
its
>>>>>>> from sdd would make things usable.
>>>>>>>
>>>>>>> No such luck. I now have a drive sdf which claims to be identical=
 to
>>>>>>> sdd but which is a clone of sdb. In case it matters, sda and sdc =
are
>>>>>>> each 4TB while sdb and sdd are each 2TB drives; sde is my boot dr=
ive
>>>>>>> and sdf is a 2TB clone of sdb.
>>>>>>>
>>>>>>> What I need to do is to somehow patch sdf's primary superblock so=
 it
>>>>>>> contains the correct device number and UUID_SUB for sdb, so that =
I can
>>>>>>> attempt some sort of recovery. Right now my linux is (understanda=
bly)
>>>>>>> quite confused by the situation:
>>>>>>
>>>>>> Did you tried "btrfs rescue super-recover"?
>>>>>>
>>>>>> Remember to use the devel branch from git, as there is a small bug=

>>>>>> prevent it report correct result.
>>>>>
>>>>> Unforutnately my patchset which fixes super-recover is still not me=
rged,
>>>>> so he needs to grab the patches from the mailing list and compile t=
he
>>>>> btrfs tools himself. The patch in question can be found here:
>>>>>
>>>>> https://patchwork.kernel.org/patch/10092471/
>>>>
>>>> And just in-case, "btrfs insp dump-super -fa" output could greatly h=
elp
>>>> us to check if the backup superblocks are really good.
>>>>
>>>
>>>
>>
>=20
>=20
>=20


--9HTTk01MxsR7KFBeHtJERxoMQOZ5huBiq--

--3uWPYrbF1bH6gRT1uIBSb1t8GKAM2eQe6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFKBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpFo7YXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjJOAf4hOX+2Z/ERK00mpruqp+qWEL2
hagmbxtcZh12CnDZHMz6keGeiYj5DULPlJXcrX2hdfAxOXMStGKT7JZpTy09Ogm9
HwXfuaPd9JMkCK85/CYW0GFyb750dAtwGWof2e30cl1mVd0UfoK5xthQdguLhFbR
seUy6UOOxCCugtJf/dlqtAP30iB7wWPIzYAv19tfKTajossz3k1HoBOG8liLmijY
BlyPNDRDSLU3fy570YJO4kARUeT0QGCSlkjSSCGL+a/7dY1EBuj/eAeNnWOFSyPv
r0yS2XpXNee5JWvbN/camyEDbfeijciXkO8N4R0IyxVuwlOmB+pRuNI3RSWe
=HHBI
-----END PGP SIGNATURE-----

--3uWPYrbF1bH6gRT1uIBSb1t8GKAM2eQe6--
