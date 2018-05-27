Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:41621 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032474AbeE0BmE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 May 2018 21:42:04 -0400
Subject: Re: RAID-1 refuses to balance large drive
To: Brad Templeton <bradtem@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
 <56F21FC5.50209@gmail.com>
 <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
 <56F22F80.501@gmail.com>
 <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
 <56F2C991.9080500@gmail.com>
 <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
 <56F2EA25.4070004@gmail.com>
 <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
 <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
 <CAPmG0jbUWiDNSVjv9hMF3rpe0cm4EZWkuRKEgM_t6EuU3sPYFA@mail.gmail.com>
 <CAHz9+Emc4DsXoMLKYrp1TfN+2r2cXxaJmPyTnpeCZF=h0FhtMg@mail.gmail.com>
 <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f773a802-67a3-f148-5d36-fa8a9d168e25@gmx.com>
Date: Sun, 27 May 2018 09:41:56 +0800
MIME-Version: 1.0
In-Reply-To: <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CKs2jR5tZU2ExVmPLqwDkeYaNoZSQftN8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CKs2jR5tZU2ExVmPLqwDkeYaNoZSQftN8
Content-Type: multipart/mixed; boundary="Aobjrh8FTrneUbX6bsIeoocOmU7WaiPvu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Brad Templeton <bradtem@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <f773a802-67a3-f148-5d36-fa8a9d168e25@gmx.com>
Subject: Re: RAID-1 refuses to balance large drive
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
 <56F21FC5.50209@gmail.com>
 <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
 <56F22F80.501@gmail.com>
 <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
 <56F2C991.9080500@gmail.com>
 <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
 <56F2EA25.4070004@gmail.com>
 <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
 <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
 <CAPmG0jbUWiDNSVjv9hMF3rpe0cm4EZWkuRKEgM_t6EuU3sPYFA@mail.gmail.com>
 <CAHz9+Emc4DsXoMLKYrp1TfN+2r2cXxaJmPyTnpeCZF=h0FhtMg@mail.gmail.com>
 <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>
In-Reply-To: <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>

--Aobjrh8FTrneUbX6bsIeoocOmU7WaiPvu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8827=E6=97=A5 09:27, Brad Templeton wrote:
> A few years ago, I encountered an issue (halfway between a bug and a
> problem) with attempting to grow a BTRFS 3 disk Raid 1 which was
> fairly full.   The problem was that after replacing (by add/delete) a
> small drive with a larger one, there were now 2 full drives and one
> new half-full one, and balance was not able to correct this situation
> to produce the desired result, which is 3 drives, each with a roughly
> even amount of free space.  It can't do it because the 2 smaller
> drives are full, and it doesn't realize it could just move one of the
> copies of a block off the smaller drive onto the larger drive to free
> space on the smaller drive, it wants to move them both, and there is
> nowhere to put them both.

It's not that easy.
For balance, btrfs must first find a large enough space to locate both
copy, then copy data.
Or if powerloss happens, it will cause data corruption.

So in your case, btrfs can only find enough space for one copy, thus
unable to relocate any chunk.

>=20
> I'm about to do it again, taking my nearly full array which is 4TB,
> 4TB, 6TB and replacing one of the 4TB with an 8TB.  I don't want to
> repeat the very time consuming situation, so I wanted to find out if
> things were fixed now.   I am running Xenial (kernel 4.4.0) and could
> consider the upgrade to  bionic (4.15) though that adds a lot more to
> my plate before a long trip and I would prefer to avoid if I can.

Since there is nothing to fix, the behavior will not change at all.

>=20
> So what is the best strategy:
>=20
> a) Replace 4TB with 8TB, resize up and balance?  (This is the "basic" s=
trategy)
> b) Add 8TB, balance, remove 4TB (automatic distribution of some blocks
> from 4TB but possibly not enough)
> c) Replace 6TB with 8TB, resize/balance, then replace 4TB with
> recently vacated 6TB -- much longer procedure but possibly better
>=20
> Or has this all been fixed and method A will work fine and get to the
> ideal goal -- 3 drives, with available space suitably distributed to
> allow full utilization over time?

Btrfs chunk allocator is already trying to utilize all drivers for a
long long time.
When allocate chunks, btrfs will choose the device with the most free
space. However the nature of RAID1 needs btrfs to allocate extents from
2 different devices, which makes your replaced 4/4/6 a little complex.
(If your 4/4/6 array is set up and then filled to current stage, btrfs
should be able to utilize all the space)


Personally speaking, if you're confident enough, just add a new device,
and then do balance.
If enough chunks get balanced, there should be enough space freed on
existing disks.
Then remove the newly added device, then btrfs should handle the
remaining space well.

Thanks,
Qu

>=20
> On Sat, May 26, 2018 at 6:24 PM, Brad Templeton <bradtem@gmail.com> wro=
te:
>> A few years ago, I encountered an issue (halfway between a bug and a
>> problem) with attempting to grow a BTRFS 3 disk Raid 1 which was fairl=
y
>> full.   The problem was that after replacing (by add/delete) a small d=
rive
>> with a larger one, there were now 2 full drives and one new half-full =
one,
>> and balance was not able to correct this situation to produce the desi=
red
>> result, which is 3 drives, each with a roughly even amount of free spa=
ce.
>> It can't do it because the 2 smaller drives are full, and it doesn't r=
ealize
>> it could just move one of the copies of a block off the smaller drive =
onto
>> the larger drive to free space on the smaller drive, it wants to move =
them
>> both, and there is nowhere to put them both.
>>
>> I'm about to do it again, taking my nearly full array which is 4TB, 4T=
B, 6TB
>> and replacing one of the 4TB with an 8TB.  I don't want to repeat the =
very
>> time consuming situation, so I wanted to find out if things were fixed=
 now.
>> I am running Xenial (kernel 4.4.0) and could consider the upgrade to  =
bionic
>> (4.15) though that adds a lot more to my plate before a long trip and =
I
>> would prefer to avoid if I can.
>>
>> So what is the best strategy:
>>
>> a) Replace 4TB with 8TB, resize up and balance?  (This is the "basic"
>> strategy)
>> b) Add 8TB, balance, remove 4TB (automatic distribution of some blocks=
 from
>> 4TB but possibly not enough)
>> c) Replace 6TB with 8TB, resize/balance, then replace 4TB with recentl=
y
>> vacated 6TB -- much longer procedure but possibly better
>>
>> Or has this all been fixed and method A will work fine and get to the =
ideal
>> goal -- 3 drives, with available space suitably distributed to allow f=
ull
>> utilization over time?
>>
>> On Fri, Mar 25, 2016 at 7:35 AM, Henk Slager <eye1tm@gmail.com> wrote:=

>>>
>>> On Fri, Mar 25, 2016 at 2:16 PM, Patrik Lundquist
>>> <patrik.lundquist@gmail.com> wrote:
>>>> On 23 March 2016 at 20:33, Chris Murphy <lists@colorremedies.com> wr=
ote:
>>>>>
>>>>> On Wed, Mar 23, 2016 at 1:10 PM, Brad Templeton <bradtem@gmail.com>=

>>>>> wrote:
>>>>>>
>>>>>> I am surprised to hear it said that having the mixed sizes is an o=
dd
>>>>>> case.
>>>>>
>>>>> Not odd as in wrong, just uncommon compared to other arrangements b=
eing
>>>>> tested.
>>>>
>>>> I think mixed drive sizes in raid1 is a killer feature for a home NA=
S,
>>>> where you replace an old smaller drive with the latest and largest
>>>> when you need more storage.
>>>>
>>>> My raid1 currently consists of 6TB+3TB+3*2TB.
>>>
>>> For the original OP situation, with chunks all filled op with extents=

>>> and devices all filled up with chunks, 'integrating' a new 6TB drive
>>> in an 4TB+3TG+2TB raid1 array could probably be done in a bit unusual=

>>> way in order to avoid immediate balancing needs:
>>> - 'plug-in' the 6TB
>>> - btrfs-replace  4TB by 6TB
>>> - btrfs fi resize max 6TB_devID
>>> - btrfs-replace  2TB by 4TB
>>> - btrfs fi resize max 4TB_devID
>>> - 'unplug' the 2TB
>>>
>>> So then there would be 2 devices with roughly 2TB space available, so=

>>> good for continued btrfs raid1 writes.
>>>
>>> An offline variant with dd instead of btrfs-replace could also be don=
e
>>> (I used to do that sometimes when btrfs-replace was not implemented).=

>>> My experience is that btrfs-replace speed is roughly at max speed (so=

>>> harddisk magnetic media transferspeed) during the whole replace
>>> process and it does in a more direct way what you actually want. So i=
n
>>> total mostly way faster device replace/upgrade than with the
>>> add+delete method. And raid1 redundancy is active all the time. Of
>>> course it means first make sure the system runs up-to-date/latest
>>> kernel+tools.
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Aobjrh8FTrneUbX6bsIeoocOmU7WaiPvu--

--CKs2jR5tZU2ExVmPLqwDkeYaNoZSQftN8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsKDOQACgkQwj2R86El
/qjNGAf+I3WId/jrJqQp/MT+dIrGO25NMNd47esH0Nus9FJ1PvG+nCP171PNH2Rr
3nNTFZw0+AAw99np5aWez5YdFQ8CTxYr0sJ68HtGm+VPkgi7pibz8vjvGMNpR9Ng
LC0jb9Wc7ht8i7Mprz9FPjbR55CsfNNJ0gAz4ixqBS0gYyV9HrOCf86NUvSUJigX
kB3tq6cLSdoVpt0Xlqnh3rb0/ZMAu2XNHH/JDeE+31/1tbDAt148+F4JalvXSfiF
t9f8WohyD9MFEMWdAKiQMCCdF8FKkKMhLcqxMj/fK82ZJt5jl0u54owtLcm7qAJ/
bAu2YAsWk/8nfNfU8fo01RhQKIH+7A==
=568D
-----END PGP SIGNATURE-----

--CKs2jR5tZU2ExVmPLqwDkeYaNoZSQftN8--
