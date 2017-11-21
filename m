Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48494 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752332AbdKUENK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 23:13:10 -0500
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
 <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>
 <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
 <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
 <CAJCQCtQ4uJG-bSQnUOXjBYYqG6Hp6Tf_fHsaoHfKgZ17w6mo0Q@mail.gmail.com>
 <0085a34c-3cf9-bd4c-dd9d-34fb994737a7@suse.com>
 <CAJCQCtTDXfY=2=f+B-w81n7ZOPkLD5DXhwvrO7b4f3-g4RRURg@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <21f8dcf9-bc3c-c356-502a-789545a6f683@suse.com>
Date: Mon, 20 Nov 2017 23:13:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTDXfY=2=f+B-w81n7ZOPkLD5DXhwvrO7b4f3-g4RRURg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A5qqwrlSgUDBQoTmoD9KaeAtqL2JTuE67"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A5qqwrlSgUDBQoTmoD9KaeAtqL2JTuE67
Content-Type: multipart/mixed; boundary="5vWa52SI3enKNvusofvtCXMelts7Px0Hf";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <21f8dcf9-bc3c-c356-502a-789545a6f683@suse.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
 <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>
 <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
 <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
 <CAJCQCtQ4uJG-bSQnUOXjBYYqG6Hp6Tf_fHsaoHfKgZ17w6mo0Q@mail.gmail.com>
 <0085a34c-3cf9-bd4c-dd9d-34fb994737a7@suse.com>
 <CAJCQCtTDXfY=2=f+B-w81n7ZOPkLD5DXhwvrO7b4f3-g4RRURg@mail.gmail.com>
In-Reply-To: <CAJCQCtTDXfY=2=f+B-w81n7ZOPkLD5DXhwvrO7b4f3-g4RRURg@mail.gmail.com>

--5vWa52SI3enKNvusofvtCXMelts7Px0Hf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/20/17 11:04 PM, Chris Murphy wrote:
> On Mon, Nov 20, 2017 at 6:46 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 11/20/17 5:59 PM, Chris Murphy wrote:
>>> On Mon, Nov 20, 2017 at 1:40 PM, Jeff Mahoney <jeffm@suse.com> wrote:=

>>>> On 11/20/17 3:01 PM, Jeff Mahoney wrote:
>>>>> On 11/20/17 3:00 PM, Jeff Mahoney wrote:
>>>>>> On 11/19/17 4:38 PM, Chris Murphy wrote:
>>>>>>> On Sat, Nov 18, 2017 at 11:27 PM, Andrei Borzenkov <arvidjaar@gma=
il.com> wrote:
>>>>>>>> 19.11.2017 09:17, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>>>>>>> fstrim should trim free space, but it only trims unallocated. T=
his is
>>>>>>>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure =
it
>>>>>>>>> behaved this way with 4.12 also.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Well, I was told it should also trim free space ...
>>>>>>>>
>>>>>>>> https://www.spinics.net/lists/linux-btrfs/msg61819.html
>>>>>>>>
>>>>>>>
>>>>>>> It definitely isn't. If I do a partial balance, then fstrim, I ge=
t a
>>>>>>> larger trimmed value, corresponding exactly to unallocated space.=

>>>>>>
>>>>>>
>>>>>> I've just tested with 4.14 and it definitely trims within block gr=
oups.
>>>>>
>>>>> Derp.  This should read 4.12.
>>>>>
>>>>>> I've attached my test script and the log of the run.  I'll build a=
nd
>>>>>> test a 4.14 kernel and see if I can reproduce there.  It may well =
be
>>>>>> that we're just misreporting the bytes trimmed.
>>>>
>>>> I get the same results on v4.14.  I wrote up a little script to pars=
e
>>>> the btrfs-debug-tree extent tree dump and the discards that are issu=
ed
>>>> after the final sync (when the tree is dumped) match.
>>>>
>>>> The script output is also as expected:
>>>> /mnt2: 95.1 GiB (102082281472 bytes) trimmed
>>>> # remove every other 100MB file, totalling 1.5 GB
>>>> + sync
>>>> + killall blktrace
>>>> + wait
>>>> + echo 'after sync'
>>>> + sleep 1
>>>> + btrace -a discard /dev/loop0
>>>> + fstrim -v /mnt2
>>>> /mnt2: 96.6 GiB (103659962368 bytes) trimmed
>>>>
>>>> One thing that may not be apparent is that the byte count is from th=
e
>>>> device(s)'s perspective.  If you have a file system with duplicate
>>>> chunks or a redundant RAID mode, the numbers will reflect that.
>>>>
>>>> The total byte count should be correct as well.  It's the total numb=
er
>>>> of bytes that we submit for discard and that were accepted by the bl=
ock
>>>> layer.
>>>>
>>>> Do you have a test case that shows it being wrong and can you provid=
e
>>>> the blktrace capture of the device(s) while the fstrim is running?
>>>
>>>
>>> Further,
>>>
>>> # fstrim -v /
>>> /: 38 GiB (40767586304 bytes) trimmed
>>>
>>> And then delete 10G worth of files, do not balance, and do nothing fo=
r
>>> a minute before:
>>>
>>> # fstrim -v /
>>> /: 38 GiB (40767586304 bytes) trimmed
>>>
>>> It's the same value. Free space according to fi us is +10 larger than=

>>> before, and yet nothing additional is trimmed than before. So I don't=

>>> know what's going on but it's not working for me.
>>
>> What happens if you sync before doing the fstrim again?  The code is
>> there to drop extents within block groups.  It works for me.  The big
>> thing is that the space must be freed entirely before we can trim.
>=20
> I've sync'd and I've also rebooted, it's the same.
>=20
> [root@f27h ~]# fstrim -v /
> /: 38 GiB (40767586304 bytes) trimmed
> [root@f27h ~]# btrfs fi us /
> Overall:
>     Device size:          70.00GiB
>     Device allocated:          32.03GiB
>     Device unallocated:          37.97GiB
>     Device missing:             0.00B
>     Used:              15.50GiB
>     Free (estimated):          52.93GiB    (min: 52.93GiB)
>     Data ratio:                  1.00
>     Metadata ratio:              1.00
>     Global reserve:          53.97MiB    (used: 192.00KiB)
>=20
> Data,single: Size:30.00GiB, Used:15.04GiB
>    /dev/nvme0n1p8      30.00GiB
>=20
> Metadata,single: Size:2.00GiB, Used:473.34MiB
>    /dev/nvme0n1p8       2.00GiB
>=20
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/nvme0n1p8      32.00MiB
>=20
> Unallocated:
>    /dev/nvme0n1p8      37.97GiB
> [root@f27h ~]#

What's the discard granularity on that device?

grep . /sys/block/nvme0n1/queue/discard_*
cat /sys/block/nvme0n1/discard*

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--5vWa52SI3enKNvusofvtCXMelts7Px0Hf--

--A5qqwrlSgUDBQoTmoD9KaeAtqL2JTuE67
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAloTp9IACgkQHntLYyF5
5bIwjxAAxd+n/ZnQLtJX1qvXQ3umDB/GqAiLnKhjuy5riC7Z2avqjViN1GV5nhAX
17iReTcK2QOTor0P5p+uZrdhUHZi3FJ2EfltHNwQVr5LmizXHL9POhcePzpEEEpp
nKEwXhrIh+IFHjohbThatsNCY6ANDnxeLV+aHD2waAqsazm2GFR9PKe87HHKSmB1
g46qXTaZCRTGfYsMaF3+1DfTfbDtaFzRToVxT7roxqHr1CoBgZQYyG3LoOdaS052
VV2ZSNxtD8/ETcix9NWojdOFzBaGxdJfAh633505mqkQFJ8W4ZF2FuxSHaSjb2jD
pzhBhKzcDQm3gaEhKXlK3kBEmNzd79sTjuKiAC/+XOO8mHZbtVOQKcxNzTaNxK6W
kBPSvHQc1vFeM0ldYGwns/JwiR/HpUoZrCBWSPnyPSVKeWEfHEVnlNZRy3Uzw8z+
OWPzGHjHZee5OAA2vb2lkxv+Isvt/lQF0KdZ/Bn+gbdkC5clXbZBdQ83vm9oYuT7
ef8KzpgtI0SCnaLchkpPbmRapTAB/nGTvucsdlJPuwrLAXS/OVJYhpXzskQ8Zbaj
aXyEtGHDiLbXPpdx5bl2TiXTRh9jwY+jDuPkveiQdWUcHiZRqrxUfyZoA/+rIW4P
O6iR7iiuf1q8uPZ2zUrLcGBOfOZWkxg03Y7F0ftWqkLdbuWPBCo=
=tDhV
-----END PGP SIGNATURE-----

--A5qqwrlSgUDBQoTmoD9KaeAtqL2JTuE67--
