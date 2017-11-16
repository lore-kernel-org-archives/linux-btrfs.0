Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58414 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933564AbdKPIIv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 03:08:51 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
Date: Thu, 16 Nov 2017 16:08:34 +0800
MIME-Version: 1.0
In-Reply-To: <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SlBuokxP34LuI9HNbiaS8A4HLxLQRslkE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SlBuokxP34LuI9HNbiaS8A4HLxLQRslkE
Content-Type: multipart/mixed; boundary="Lr9Xmiom4ekfhU2UqR0NSTDAjeMqiSTVe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
In-Reply-To: <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>

--Lr9Xmiom4ekfhU2UqR0NSTDAjeMqiSTVe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8816=E6=97=A5 15:42, Nikolay Borisov wrote:
>=20
>=20
> On 16.11.2017 09:38, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8816=E6=97=A5 14:54, Nikolay Borisov wrote:
>>>
>>>
>>> On 16.11.2017 04:18, Qu Wenruo wrote:
>>>> Hi all,
>>>>
>>>> [Background]
>>>> Recently I'm considering the possibility to use checksum from filesy=
stem
>>>> to enhance device-mapper raid.
>>>>
>>>> The idea behind it is quite simple, since most modern filesystems ha=
ve
>>>> checksum for their metadata, and even some (btrfs) have checksum for=
 data.
>>>>
>>>> And for btrfs RAID1/10 (just ignore the RAID5/6 for now), at read ti=
me
>>>> it can use the checksum to determine which copy is correct so it can=

>>>> return the correct data even one copy get corrupted.
>>>>
>>>> [Objective]
>>>> The final objective is to allow device mapper to do the checksum
>>>> verification (and repair if possible).
>>>>
>>>> If only for verification, it's not much different from current endio=

>>>> hook method used by most of the fs.
>>>> However if we can move the repair part from filesystem (well, only b=
trfs
>>>> supports it yet), it would benefit all fs.
>>>>
>>>> [What we have]
>>>> The nearest infrastructure I found in kernel is bio_integrity_payloa=
d.
>>>>
>>>> However I found it's bounded to device, as it's designed to support
>>>> SCSI/SATA integrity protocol.
>>>> While for such use case, it's more bounded to filesystem, as fs (or
>>>> higher layer dm device) is the source of integrity data, and device
>>>> (dm-raid) only do the verification and possible repair.
>>>>
>>>> I'm not sure if this is a good idea to reuse or abuse
>>>> bio_integrity_payload for this purpose.
>>>>
>>>> Should we use some new infrastructure or enhance existing
>>>> bio_integrity_payload?
>>>>
>>>> (Or is this a valid idea or just another crazy dream?)
>>>>
>>>
>>> This sounds good in principle, however I think there is one crucial
>>> point which needs to be considered:
>>>
>>> All fs with checksums store those checksums in some specific way, the=
n
>>> when they fetch data from disk they they also know how to acquire the=

>>> respective checksum.
>>
>> Just like integrity payload, we generate READ bio attached with checks=
um
>> hook function and checksum data.
>=20
> So how is this checksum data acquired in the first place?

In btrfs case, through metadata read bio.
Since btrfs put data csum into its csum tree, as metadata.

Pass a READ bio with metadata specific verification function, and empty
verification data.

>=20
>>
>> So for data read, we read checksum first and attach it to data READ bi=
o,
>> then submit it.
>>
>> And for metadata read, in most case the checksum is integrated into
>> metadata header, like what we did in btrfs.
>>
>> In that case we attach empty checksum data to bio, but use metadata
>> specific function hook to handle it.
>>
>>> What you suggest might be doable but it will
>>> require lower layers (dm) be aware of how to acquire the specific
>>> checksum for some data.
>>
>> In above case, dm only needs to call the verification hook function.
>> If verification passed, that's good.
>> If not, try other copy if we have.
>>
>> In this case, I don't think dm layer needs any extra interface to
>> communicate with higher layer.
>=20
>=20
> Well that verification function is the interface I meant, you are
> communicating the checksum out of band essentially (notwithstanding the=

> metadata case, since you said checksum is in the actual metadata header=
)
>=20
> In the end - which problem are you trying to solve, allow for a generic=

> checksumming layer which filesystems may use if they decide to ?

To make it clear, to allow device mapper layer to take use of filesystem
checksum (if they have) when there are multiple copies.

One problem of current dm raid1/10 (and possible raid5/6) is that they
don't have ability to know which copy is correct.
They can only handle device disappear.

Btrfs handles it by verifying data/metadata checksum.
While xfs/ext4 also has checksum for their metadata, why not allowing
device mapper to use such checksum to get the correct copy?

The mechanism is *NOT* a generic checksum layer.
How the csum is stored is determined by fs.
Just allow device mapper layer to be aware of this and make clever decisi=
on.

And more, this only affects READ bio, WRITE bio is not affected at all.
Csum calculation and storing is all handled by filesystem.
Device mapper layer won't need to get involved in that case.

And of course, btrfs can reuse this facility to do something bigger, but
that's another story.

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>> I don't think at this point there is such infra
>>> and frankly I cannot even envision how it will work elegantly. Sure y=
ou
>>> can create a dm-checksum target (which I believe dm-verity is very
>>> similar to) that stores checksums alongside data but at this point th=
e
>>> fs is really out of the picture.
>>>
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Lr9Xmiom4ekfhU2UqR0NSTDAjeMqiSTVe--

--SlBuokxP34LuI9HNbiaS8A4HLxLQRslkE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloNR4IXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgcIQf7BLyb5upnYRLl38k7nueJDv1L
NcFZ2prK8Hk3CBHXTvPtYk/c1tV/pMZXx5Xz75M/fZ/VVSLGFLWAPWOBg3wDp8ng
4LFhsha0zbz4WN2YKrp3iY7zBFij4U1vCa5Y9zghr/2VsS+pOgTkFfVAz0j+n+XV
ZAKK//1HMOCKTY/ppiBp+CcvhzQ+pCWFkfhGATFD2O77xTeUWzwARO9A1JdlRtXi
QdD39ZQ5NbHCSfgEE2WQOOrv/5xGqGxqvsPzdiiUOy8D3BpznK2DAmyU3CgRdHPH
yWCCmZlcGtIehMemVxZNLU64QDAmNe9Fj74dyvf/9lSPGlhMmd3xzt11iEiyRA==
=MZqT
-----END PGP SIGNATURE-----

--SlBuokxP34LuI9HNbiaS8A4HLxLQRslkE--
