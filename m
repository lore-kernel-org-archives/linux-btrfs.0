Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:38566 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967135AbeF1RKs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 13:10:48 -0400
Received: by mail-lf0-f44.google.com with SMTP id a4-v6so4766767lff.5
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 10:10:47 -0700 (PDT)
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: remi@georgianit.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
 <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
 <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
 <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <4e3c9723-c20a-2cc9-845e-af61934b16e6@gmail.com>
Date: Thu, 28 Jun 2018 20:10:40 +0300
MIME-Version: 1.0
In-Reply-To: <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="8ahvjYyKljas1ghWsYXnas2y2PYKHTVTO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8ahvjYyKljas1ghWsYXnas2y2PYKHTVTO
Content-Type: multipart/mixed; boundary="tfOxwEq6C0YuLTV5oCXuiGmlqo9XoUlFN";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: remi@georgianit.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <4e3c9723-c20a-2cc9-845e-af61934b16e6@gmail.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
 <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
 <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
 <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
In-Reply-To: <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>

--tfOxwEq6C0YuLTV5oCXuiGmlqo9XoUlFN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

28.06.2018 12:15, Qu Wenruo =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>=20
>=20
> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 16:16, Andrei Borzenkov wrote:
>> On Thu, Jun 28, 2018 at 8:39 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>>
>>>
>>> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 11:14, remi@georgianit.com wro=
te:
>>>>
>>>>
>>>> On Wed, Jun 27, 2018, at 10:55 PM, Qu Wenruo wrote:
>>>>
>>>>>
>>>>> Please get yourself clear of what other raid1 is doing.
>>>>
>>>> A drive failure, where the drive is still there when the computer re=
boots, is a situation that *any* raid 1, (or for that matter, raid 5, rai=
d 6, anything but raid 0) will recover from perfectly without raising a s=
weat. Some will rebuild the array automatically,
>>>
>>> WOW, that's black magic, at least for RAID1.
>>> The whole RAID1 has no idea of which copy is correct unlike btrfs who=

>>> has datasum.
>>>
>>> Don't bother other things, just tell me how to determine which one is=

>>> correct?
>>>
>>
>> When one drive fails, it is recorded in meta-data on remaining drives;=

>> probably configuration generation number is increased. Next time drive=

>> with older generation is not incorporated. Hardware controllers also
>> keep this information in NVRAM and so do not even depend on scanning
>> of other disks.
>=20
> Yep, the only possible way to determine such case is from external info=
=2E
>=20
> For device generation, it's possible to enhance btrfs, but at least we
> could start from detect and refuse to RW mount to avoid possible furthe=
r
> corruption.
> But anyway, if one really cares about such case, hardware RAID
> controller seems to be the only solution as other software may have the=

> same problem.
>=20
> And the hardware solution looks pretty interesting, is the write to
> NVRAM 100% atomic? Even at power loss?
>=20
>>
>>> The only possibility is that, the misbehaved device missed several su=
per
>>> block update so we have a chance to detect it's out-of-date.
>>> But that's not always working.
>>>
>>
>> Why it should not work as long as any write to array is suspended
>> until superblock on remaining devices is updated?
>=20
> What happens if there is no generation gap in device superblock?
>=20

Well, you use "generation" in strict btrfs sense, I use "generation"
generically. That is exactly what btrfs apparently lacks currently -
some monotonic counter that is used to record such event.

> If one device got some of its (nodatacow) data written to disk, while
> the other device doesn't get data written, and neither of them reached
> super block update, there is no difference in device superblock, thus n=
o
> way to detect which is correct.
>=20

Again, the very fact that device failed should have triggered update of
superblock to record this information which presumably should increase
some counter.

>>
>>> If you're talking about missing generation check for btrfs, that's
>>> valid, but it's far from a "major design flaw", as there are a lot of=

>>> cases where other RAID1 (mdraid or LVM mirrored) can also be affected=

>>> (the brain-split case).
>>>
>>
>> That's different. Yes, with software-based raid there is usually no
>> way to detect outdated copy if no other copies are present. Having
>> older valid data is still very different from corrupting newer data.
>=20
> While for VDI case (or any VM image file format other than raw), older
> valid data normally means corruption.
> Unless they have their own write-ahead log.
>> Some file format may detect such problem by themselves if they have
> internal checksum, but anyway, older data normally means corruption,
> especially when partial new and partial old.
>

Yes, that's true. But there is really nothing that can be done here,
even theoretically; it hardly a reason to not do what looks possible.

> On the other hand, with data COW and csum, btrfs can ensure the whole
> filesystem update is atomic (at least for single device).
> So the title, especially the "major design flaw" can't be wrong any mor=
e.
>=20
>>
>>>> others will automatically kick out the misbehaving drive.  *none* of=
 them will take back the the drive with old data and start commingling th=
at data with good copy.)\ This behaviour from BTRFS is completely abnorma=
l.. and defeats even the most basic expectations of RAID.
>>>
>>> RAID1 can only tolerate 1 missing device, it has nothing to do with
>>> error detection.
>>> And it's impossible to detect such case without extra help.
>>>
>>> Your expectation is completely wrong.
>>>
>>
>> Well ... somehow it is my experience as well ... :)
>=20
> Acceptable, but not really apply to software based RAID1.
>=20
> Thanks,
> Qu
>=20
>>
>>>>
>>>> I'm not the one who has to clear his expectations here.
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>=20



--tfOxwEq6C0YuLTV5oCXuiGmlqo9XoUlFN--

--8ahvjYyKljas1ghWsYXnas2y2PYKHTVTO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAls1FpQACgkQR6LMutpd94zJEwCdEvQBH3DUq+Eh1yHYai/FNIkE
cwUAoJu2VLSLpAXc0ZJmEG+rh2rY1nlD
=Ii/W
-----END PGP SIGNATURE-----

--8ahvjYyKljas1ghWsYXnas2y2PYKHTVTO--
