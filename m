Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:39321 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932274AbeF1JPY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 05:15:24 -0400
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: remi@georgianit.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
 <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
 <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
Date: Thu, 28 Jun 2018 17:15:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hr1OCG6L5Jbw9z04wtP3k0OyWD2r8G9vy"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hr1OCG6L5Jbw9z04wtP3k0OyWD2r8G9vy
Content-Type: multipart/mixed; boundary="mwBGDtzGWC2KKR2auKds0AryTzyKgVwGQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: remi@georgianit.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
 <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
 <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
In-Reply-To: <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>

--mwBGDtzGWC2KKR2auKds0AryTzyKgVwGQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 16:16, Andrei Borzenkov wrote:
> On Thu, Jun 28, 2018 at 8:39 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 11:14, remi@georgianit.com wrot=
e:
>>>
>>>
>>> On Wed, Jun 27, 2018, at 10:55 PM, Qu Wenruo wrote:
>>>
>>>>
>>>> Please get yourself clear of what other raid1 is doing.
>>>
>>> A drive failure, where the drive is still there when the computer reb=
oots, is a situation that *any* raid 1, (or for that matter, raid 5, raid=
 6, anything but raid 0) will recover from perfectly without raising a sw=
eat. Some will rebuild the array automatically,
>>
>> WOW, that's black magic, at least for RAID1.
>> The whole RAID1 has no idea of which copy is correct unlike btrfs who
>> has datasum.
>>
>> Don't bother other things, just tell me how to determine which one is
>> correct?
>>
>=20
> When one drive fails, it is recorded in meta-data on remaining drives;
> probably configuration generation number is increased. Next time drive
> with older generation is not incorporated. Hardware controllers also
> keep this information in NVRAM and so do not even depend on scanning
> of other disks.

Yep, the only possible way to determine such case is from external info.

For device generation, it's possible to enhance btrfs, but at least we
could start from detect and refuse to RW mount to avoid possible further
corruption.
But anyway, if one really cares about such case, hardware RAID
controller seems to be the only solution as other software may have the
same problem.

And the hardware solution looks pretty interesting, is the write to
NVRAM 100% atomic? Even at power loss?

>=20
>> The only possibility is that, the misbehaved device missed several sup=
er
>> block update so we have a chance to detect it's out-of-date.
>> But that's not always working.
>>
>=20
> Why it should not work as long as any write to array is suspended
> until superblock on remaining devices is updated?

What happens if there is no generation gap in device superblock?

If one device got some of its (nodatacow) data written to disk, while
the other device doesn't get data written, and neither of them reached
super block update, there is no difference in device superblock, thus no
way to detect which is correct.

>=20
>> If you're talking about missing generation check for btrfs, that's
>> valid, but it's far from a "major design flaw", as there are a lot of
>> cases where other RAID1 (mdraid or LVM mirrored) can also be affected
>> (the brain-split case).
>>
>=20
> That's different. Yes, with software-based raid there is usually no
> way to detect outdated copy if no other copies are present. Having
> older valid data is still very different from corrupting newer data.

While for VDI case (or any VM image file format other than raw), older
valid data normally means corruption.
Unless they have their own write-ahead log.

Some file format may detect such problem by themselves if they have
internal checksum, but anyway, older data normally means corruption,
especially when partial new and partial old.

On the other hand, with data COW and csum, btrfs can ensure the whole
filesystem update is atomic (at least for single device).
So the title, especially the "major design flaw" can't be wrong any more.=


>=20
>>> others will automatically kick out the misbehaving drive.  *none* of =
them will take back the the drive with old data and start commingling tha=
t data with good copy.)\ This behaviour from BTRFS is completely abnormal=
=2E. and defeats even the most basic expectations of RAID.
>>
>> RAID1 can only tolerate 1 missing device, it has nothing to do with
>> error detection.
>> And it's impossible to detect such case without extra help.
>>
>> Your expectation is completely wrong.
>>
>=20
> Well ... somehow it is my experience as well ... :)

Acceptable, but not really apply to software based RAID1.

Thanks,
Qu

>=20
>>>
>>> I'm not the one who has to clear his expectations here.
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>


--mwBGDtzGWC2KKR2auKds0AryTzyKgVwGQ--

--hr1OCG6L5Jbw9z04wtP3k0OyWD2r8G9vy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls0pxwACgkQwj2R86El
/qhohQf/dEoFV0Rt8xiNWWk12onq06JheP6TGYnfctFtJM0veDEq+CLtWExvOSOr
N707zQy84opblcZmCLm6tM0WdjUIx4keq1pkVMdnUMhOnGbid1h8kL95Xefrh/de
ZgQ769LJImuBHbwHzr21iYRihsRZrNMwCTn0tm+7n4HIgZJUgV43QRR1byDF2rRi
PaUmfseRJqz/0iWUcTXWcYbshqAnwELX9Vh/s0/uuFS/XmTxT0uJh6A/NTEkF/IQ
GU3vq9x9NuGOyeml9S/YKCyb/0Zdzc1z18PE3fgxUHEl4Q/x8n32XVTF++/8JsjU
jj3efHCu9eBGP3gOQiHTFFv+ivJdEQ==
=u6SH
-----END PGP SIGNATURE-----

--hr1OCG6L5Jbw9z04wtP3k0OyWD2r8G9vy--
