Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60543 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032474AbeE0CQk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 May 2018 22:16:40 -0400
Subject: Re: RAID-1 refuses to balance large drive
To: Brad Templeton <bradtem@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
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
 <f773a802-67a3-f148-5d36-fa8a9d168e25@gmx.com>
 <CAHz9+EkeAAOXN7K+C0Wtmu-3RPOpTC4a6pK-y5gDQCtdAc8nUA@mail.gmail.com>
 <6dc280f8-3822-078e-9b69-c3203e75ec1e@gmx.com>
 <CAHz9+EkzNkAiP4CSZCiAbTrsKik0SGS9OQ=C4TSfwtB8Rb3zvA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c8077032-58ea-da5b-ea62-6007d837e666@gmx.com>
Date: Sun, 27 May 2018 10:16:31 +0800
MIME-Version: 1.0
In-Reply-To: <CAHz9+EkzNkAiP4CSZCiAbTrsKik0SGS9OQ=C4TSfwtB8Rb3zvA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hAEgQnkdXKqryWRXQCE4O4S1rupiVU9yn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hAEgQnkdXKqryWRXQCE4O4S1rupiVU9yn
Content-Type: multipart/mixed; boundary="MdE6cZkFYoYRGi4xaPynrWpX2XzbNDYsl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Brad Templeton <bradtem@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <c8077032-58ea-da5b-ea62-6007d837e666@gmx.com>
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
 <f773a802-67a3-f148-5d36-fa8a9d168e25@gmx.com>
 <CAHz9+EkeAAOXN7K+C0Wtmu-3RPOpTC4a6pK-y5gDQCtdAc8nUA@mail.gmail.com>
 <6dc280f8-3822-078e-9b69-c3203e75ec1e@gmx.com>
 <CAHz9+EkzNkAiP4CSZCiAbTrsKik0SGS9OQ=C4TSfwtB8Rb3zvA@mail.gmail.com>
In-Reply-To: <CAHz9+EkzNkAiP4CSZCiAbTrsKik0SGS9OQ=C4TSfwtB8Rb3zvA@mail.gmail.com>

--MdE6cZkFYoYRGi4xaPynrWpX2XzbNDYsl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8827=E6=97=A5 10:06, Brad Templeton wrote:
> Thanks.  These are all things which take substantial fractions of a
> day to try, unfortunately.

Normally I would suggest just using VM and several small disks (~10G),
along with fallocate (the fastest way to use space) to get a basic view
of the procedure.

> Last time I ended up fixing it in a
> fairly kluged way, which was to convert from raid-1 to single long
> enough to get enough single blocks that when I converted back to
> raid-1 they got distributed to the right drives.

Yep, that's the ultimate one-fit-all solution.
Also, this reminds me about the fact we could do the
RAID1->Single/DUP->Single downgrade in a much much faster way.
I think it's worthy considering for later enhancement.

>  But this is, aside
> from being a kludge, a procedure with some minor risk.  Of course I am
> taking a backup first, but still...
>=20
> This strikes me as something that should be a fairly common event --
> your raid is filling up, and so you expand it by replacing the oldest
> and smallest drive with a new much bigger one.   In the old days of
> RAID, you could not do that, you had to grow all drives at the same
> time, and this is one of the ways that BTRFS is quite superior.
> When I had MD raid, I went through a strange process of always having
> a raid 5 that consisted of different sized drives.  The raid-5 was
> based on the smallest of the 3 drives, and then the larger ones had
> extra space which could either be in raid-1, or more imply was in solo
> disk mode and used for less critical data (such as backups and old
> archives.)   Slowly, and in a messy way, each time I replaced the
> smallest drive, I could then grow the raid 5.  Yuck.     BTRFS is so
> much better, except for this issue.
>=20
> So if somebody has a thought of a procedure that is fairly sure to
> work and doesn't involve too many copying passes -- copying 4tb is not
> a quick operation -- it is much appreciated and might be a good thing
> to add to a wiki page, which I would be happy to do.

Anyway, "btrfs fi show" and "btrfs fi usage" would help before any
further advice from community.

Thanks,
Qu

>=20
> On Sat, May 26, 2018 at 6:56 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B405=E6=9C=8827=E6=97=A5 09:49, Brad Templeton wrote:
>>> That is what did not work last time.
>>>
>>> I say I think there can be a "fix" because I hope the goal of BTRFS
>>> raid is to be superior to traditional RAID.   That if one replaces a
>>> drive, and asks to balance, it figures out what needs to be done to
>>> make that work.  I understand that the current balance algorithm may
>>> have trouble with that.   In this situation, the ideal result would b=
e
>>> the system would take the 3 drives (4TB and 6TB full, 8TB with 4TB
>>> free) and move extents strictly from the 4TB and 6TB to the 8TB -- ie=

>>> extents which are currently on both the 4TB and 6TB -- by moving only=

>>> one copy.
>>
>> Btrfs can only do balance in a chunk unit.
>> Thus btrfs can only do:
>> 1) Create new chunk
>> 2) Copy data
>> 3) Remove old chunk.
>>
>> So it can't do the way you mentioned.
>> But your purpose sounds pretty valid and maybe we could enhanace btrfs=

>> to do such thing.
>> (Currently only replace can behave like that)
>>
>>> It is not strictly a "bug" in that the code is operating
>>> as designed, but it is an undesired function.
>>>
>>> The problem is the approach you describe did not work in the prior up=
grade.
>>
>> Would you please try 4/4/6 + 4 or 4/4/6 + 2 and then balance?
>> And before/after balance, "btrfs fi usage" and "btrfs fi show" output
>> could also help.
>>
>> Thanks,
>> Qu
>>
>>>
>>> On Sat, May 26, 2018 at 6:41 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>> On 2018=E5=B9=B405=E6=9C=8827=E6=97=A5 09:27, Brad Templeton wrote:
>>>>> A few years ago, I encountered an issue (halfway between a bug and =
a
>>>>> problem) with attempting to grow a BTRFS 3 disk Raid 1 which was
>>>>> fairly full.   The problem was that after replacing (by add/delete)=
 a
>>>>> small drive with a larger one, there were now 2 full drives and one=

>>>>> new half-full one, and balance was not able to correct this situati=
on
>>>>> to produce the desired result, which is 3 drives, each with a rough=
ly
>>>>> even amount of free space.  It can't do it because the 2 smaller
>>>>> drives are full, and it doesn't realize it could just move one of t=
he
>>>>> copies of a block off the smaller drive onto the larger drive to fr=
ee
>>>>> space on the smaller drive, it wants to move them both, and there i=
s
>>>>> nowhere to put them both.
>>>>
>>>> It's not that easy.
>>>> For balance, btrfs must first find a large enough space to locate bo=
th
>>>> copy, then copy data.
>>>> Or if powerloss happens, it will cause data corruption.
>>>>
>>>> So in your case, btrfs can only find enough space for one copy, thus=

>>>> unable to relocate any chunk.
>>>>
>>>>>
>>>>> I'm about to do it again, taking my nearly full array which is 4TB,=

>>>>> 4TB, 6TB and replacing one of the 4TB with an 8TB.  I don't want to=

>>>>> repeat the very time consuming situation, so I wanted to find out i=
f
>>>>> things were fixed now.   I am running Xenial (kernel 4.4.0) and cou=
ld
>>>>> consider the upgrade to  bionic (4.15) though that adds a lot more =
to
>>>>> my plate before a long trip and I would prefer to avoid if I can.
>>>>
>>>> Since there is nothing to fix, the behavior will not change at all.
>>>>
>>>>>
>>>>> So what is the best strategy:
>>>>>
>>>>> a) Replace 4TB with 8TB, resize up and balance?  (This is the "basi=
c" strategy)
>>>>> b) Add 8TB, balance, remove 4TB (automatic distribution of some blo=
cks
>>>>> from 4TB but possibly not enough)
>>>>> c) Replace 6TB with 8TB, resize/balance, then replace 4TB with
>>>>> recently vacated 6TB -- much longer procedure but possibly better
>>>>>
>>>>> Or has this all been fixed and method A will work fine and get to t=
he
>>>>> ideal goal -- 3 drives, with available space suitably distributed t=
o
>>>>> allow full utilization over time?
>>>>
>>>> Btrfs chunk allocator is already trying to utilize all drivers for a=

>>>> long long time.
>>>> When allocate chunks, btrfs will choose the device with the most fre=
e
>>>> space. However the nature of RAID1 needs btrfs to allocate extents f=
rom
>>>> 2 different devices, which makes your replaced 4/4/6 a little comple=
x.
>>>> (If your 4/4/6 array is set up and then filled to current stage, btr=
fs
>>>> should be able to utilize all the space)
>>>>
>>>>
>>>> Personally speaking, if you're confident enough, just add a new devi=
ce,
>>>> and then do balance.
>>>> If enough chunks get balanced, there should be enough space freed on=

>>>> existing disks.
>>>> Then remove the newly added device, then btrfs should handle the
>>>> remaining space well.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> On Sat, May 26, 2018 at 6:24 PM, Brad Templeton <bradtem@gmail.com>=
 wrote:
>>>>>> A few years ago, I encountered an issue (halfway between a bug and=
 a
>>>>>> problem) with attempting to grow a BTRFS 3 disk Raid 1 which was f=
airly
>>>>>> full.   The problem was that after replacing (by add/delete) a sma=
ll drive
>>>>>> with a larger one, there were now 2 full drives and one new half-f=
ull one,
>>>>>> and balance was not able to correct this situation to produce the =
desired
>>>>>> result, which is 3 drives, each with a roughly even amount of free=
 space.
>>>>>> It can't do it because the 2 smaller drives are full, and it doesn=
't realize
>>>>>> it could just move one of the copies of a block off the smaller dr=
ive onto
>>>>>> the larger drive to free space on the smaller drive, it wants to m=
ove them
>>>>>> both, and there is nowhere to put them both.
>>>>>>
>>>>>> I'm about to do it again, taking my nearly full array which is 4TB=
, 4TB, 6TB
>>>>>> and replacing one of the 4TB with an 8TB.  I don't want to repeat =
the very
>>>>>> time consuming situation, so I wanted to find out if things were f=
ixed now.
>>>>>> I am running Xenial (kernel 4.4.0) and could consider the upgrade =
to  bionic
>>>>>> (4.15) though that adds a lot more to my plate before a long trip =
and I
>>>>>> would prefer to avoid if I can.
>>>>>>
>>>>>> So what is the best strategy:
>>>>>>
>>>>>> a) Replace 4TB with 8TB, resize up and balance?  (This is the "bas=
ic"
>>>>>> strategy)
>>>>>> b) Add 8TB, balance, remove 4TB (automatic distribution of some bl=
ocks from
>>>>>> 4TB but possibly not enough)
>>>>>> c) Replace 6TB with 8TB, resize/balance, then replace 4TB with rec=
ently
>>>>>> vacated 6TB -- much longer procedure but possibly better
>>>>>>
>>>>>> Or has this all been fixed and method A will work fine and get to =
the ideal
>>>>>> goal -- 3 drives, with available space suitably distributed to all=
ow full
>>>>>> utilization over time?
>>>>>>
>>>>>> On Fri, Mar 25, 2016 at 7:35 AM, Henk Slager <eye1tm@gmail.com> wr=
ote:
>>>>>>>
>>>>>>> On Fri, Mar 25, 2016 at 2:16 PM, Patrik Lundquist
>>>>>>> <patrik.lundquist@gmail.com> wrote:
>>>>>>>> On 23 March 2016 at 20:33, Chris Murphy <lists@colorremedies.com=
> wrote:
>>>>>>>>>
>>>>>>>>> On Wed, Mar 23, 2016 at 1:10 PM, Brad Templeton <bradtem@gmail.=
com>
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>> I am surprised to hear it said that having the mixed sizes is =
an odd
>>>>>>>>>> case.
>>>>>>>>>
>>>>>>>>> Not odd as in wrong, just uncommon compared to other arrangemen=
ts being
>>>>>>>>> tested.
>>>>>>>>
>>>>>>>> I think mixed drive sizes in raid1 is a killer feature for a hom=
e NAS,
>>>>>>>> where you replace an old smaller drive with the latest and large=
st
>>>>>>>> when you need more storage.
>>>>>>>>
>>>>>>>> My raid1 currently consists of 6TB+3TB+3*2TB.
>>>>>>>
>>>>>>> For the original OP situation, with chunks all filled op with ext=
ents
>>>>>>> and devices all filled up with chunks, 'integrating' a new 6TB dr=
ive
>>>>>>> in an 4TB+3TG+2TB raid1 array could probably be done in a bit unu=
sual
>>>>>>> way in order to avoid immediate balancing needs:
>>>>>>> - 'plug-in' the 6TB
>>>>>>> - btrfs-replace  4TB by 6TB
>>>>>>> - btrfs fi resize max 6TB_devID
>>>>>>> - btrfs-replace  2TB by 4TB
>>>>>>> - btrfs fi resize max 4TB_devID
>>>>>>> - 'unplug' the 2TB
>>>>>>>
>>>>>>> So then there would be 2 devices with roughly 2TB space available=
, so
>>>>>>> good for continued btrfs raid1 writes.
>>>>>>>
>>>>>>> An offline variant with dd instead of btrfs-replace could also be=
 done
>>>>>>> (I used to do that sometimes when btrfs-replace was not implement=
ed).
>>>>>>> My experience is that btrfs-replace speed is roughly at max speed=
 (so
>>>>>>> harddisk magnetic media transferspeed) during the whole replace
>>>>>>> process and it does in a more direct way what you actually want. =
So in
>>>>>>> total mostly way faster device replace/upgrade than with the
>>>>>>> add+delete method. And raid1 redundancy is active all the time. O=
f
>>>>>>> course it means first make sure the system runs up-to-date/latest=

>>>>>>> kernel+tools.
>>>>>>
>>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--MdE6cZkFYoYRGi4xaPynrWpX2XzbNDYsl--

--hAEgQnkdXKqryWRXQCE4O4S1rupiVU9yn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsKFP8ACgkQwj2R86El
/qg09gf7Bwh2zGywghPpZ1q+ujBPFMHKITPC0taau5LAbU8QUmx6AW+JlDoP7Kg2
rJmIyCan6HZ5mq+xkXmsOHnKkgvQjIE89/eTGIP7J2886O3CVTBgUdYTBWk7xA1z
fT0cQdY9rJnV28qPSILe9M0Ek97fCBqxoYKVP2huE5wUDqhh+DpK8i7CSX9dUEGs
NcagA4bB9M49Rgm1EVGk0SnvDjpO6vgAMykiqVJKZtaT2otyiziiKzT5UlJvFMjF
9/aI4C9e6OWWM7SIYE7PchG5DlDcdUpBhhz0AklQFQB8aZIJCQ2Fv9WzBLi48+Dp
iiqha/I1YBNqOE1LLzQwJn3Qu9+KGg==
=AcSV
-----END PGP SIGNATURE-----

--hAEgQnkdXKqryWRXQCE4O4S1rupiVU9yn--
