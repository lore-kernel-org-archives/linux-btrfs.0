Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49029 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752617AbeF2AHk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 20:07:40 -0400
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
 <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
 <4e3c9723-c20a-2cc9-845e-af61934b16e6@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <98025ccd-b8d9-73f1-2aca-81c572a9457d@gmx.com>
Date: Fri, 29 Jun 2018 08:07:25 +0800
MIME-Version: 1.0
In-Reply-To: <4e3c9723-c20a-2cc9-845e-af61934b16e6@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KhYgr58zfcYNGTFSHFAeUgwLWFFbyvgV5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KhYgr58zfcYNGTFSHFAeUgwLWFFbyvgV5
Content-Type: multipart/mixed; boundary="OONqTOf8LCi1XKp8DpXoXzaA28bBIKkmf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: remi@georgianit.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <98025ccd-b8d9-73f1-2aca-81c572a9457d@gmx.com>
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
 <4e3c9723-c20a-2cc9-845e-af61934b16e6@gmail.com>
In-Reply-To: <4e3c9723-c20a-2cc9-845e-af61934b16e6@gmail.com>

--OONqTOf8LCi1XKp8DpXoXzaA28bBIKkmf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8829=E6=97=A5 01:10, Andrei Borzenkov wrote:
> 28.06.2018 12:15, Qu Wenruo =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 16:16, Andrei Borzenkov wrote:
>>> On Thu, Jun 28, 2018 at 8:39 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 11:14, remi@georgianit.com wr=
ote:
>>>>>
>>>>>
>>>>> On Wed, Jun 27, 2018, at 10:55 PM, Qu Wenruo wrote:
>>>>>
>>>>>>
>>>>>> Please get yourself clear of what other raid1 is doing.
>>>>>
>>>>> A drive failure, where the drive is still there when the computer r=
eboots, is a situation that *any* raid 1, (or for that matter, raid 5, ra=
id 6, anything but raid 0) will recover from perfectly without raising a =
sweat. Some will rebuild the array automatically,
>>>>
>>>> WOW, that's black magic, at least for RAID1.
>>>> The whole RAID1 has no idea of which copy is correct unlike btrfs wh=
o
>>>> has datasum.
>>>>
>>>> Don't bother other things, just tell me how to determine which one i=
s
>>>> correct?
>>>>
>>>
>>> When one drive fails, it is recorded in meta-data on remaining drives=
;
>>> probably configuration generation number is increased. Next time driv=
e
>>> with older generation is not incorporated. Hardware controllers also
>>> keep this information in NVRAM and so do not even depend on scanning
>>> of other disks.
>>
>> Yep, the only possible way to determine such case is from external inf=
o.
>>
>> For device generation, it's possible to enhance btrfs, but at least we=

>> could start from detect and refuse to RW mount to avoid possible furth=
er
>> corruption.
>> But anyway, if one really cares about such case, hardware RAID
>> controller seems to be the only solution as other software may have th=
e
>> same problem.
>>
>> And the hardware solution looks pretty interesting, is the write to
>> NVRAM 100% atomic? Even at power loss?
>>
>>>
>>>> The only possibility is that, the misbehaved device missed several s=
uper
>>>> block update so we have a chance to detect it's out-of-date.
>>>> But that's not always working.
>>>>
>>>
>>> Why it should not work as long as any write to array is suspended
>>> until superblock on remaining devices is updated?
>>
>> What happens if there is no generation gap in device superblock?
>>
>=20
> Well, you use "generation" in strict btrfs sense, I use "generation"
> generically. That is exactly what btrfs apparently lacks currently -
> some monotonic counter that is used to record such event.

Indeed, btrfs doesn't have any way to record which device get degraded
at all.
The usage of btrfs device generation is already kind of workaround.

So to keep the same behavior of mdraid/lvm, each time btrfs detects a
device missing/fatal command (flush/fua) not executed correctly, btrfs
needs to record it, maybe into its device item, and commit it to disk.

In short, the btrfs csum makes us a little conceited about such device
missing case, normally csum will tell us which data is wrong so we could
avoid complex device status tracking.
But apparently, if nodatasum is involved, everything just goes out of
our expectation.

>=20
>> If one device got some of its (nodatacow) data written to disk, while
>> the other device doesn't get data written, and neither of them reached=

>> super block update, there is no difference in device superblock, thus =
no
>> way to detect which is correct.
>>
>=20
> Again, the very fact that device failed should have triggered update of=

> superblock to record this information which presumably should increase
> some counter.

Indeed.

>=20
>>>
>>>> If you're talking about missing generation check for btrfs, that's
>>>> valid, but it's far from a "major design flaw", as there are a lot o=
f
>>>> cases where other RAID1 (mdraid or LVM mirrored) can also be affecte=
d
>>>> (the brain-split case).
>>>>
>>>
>>> That's different. Yes, with software-based raid there is usually no
>>> way to detect outdated copy if no other copies are present. Having
>>> older valid data is still very different from corrupting newer data.
>>
>> While for VDI case (or any VM image file format other than raw), older=

>> valid data normally means corruption.
>> Unless they have their own write-ahead log.
>>> Some file format may detect such problem by themselves if they have
>> internal checksum, but anyway, older data normally means corruption,
>> especially when partial new and partial old.
>>
>=20
> Yes, that's true. But there is really nothing that can be done here,
> even theoretically; it hardly a reason to not do what looks possible.

Well, theoretically, you can just use datasum and datacow :)

Thanks,
Qu

>=20
>> On the other hand, with data COW and csum, btrfs can ensure the whole
>> filesystem update is atomic (at least for single device).
>> So the title, especially the "major design flaw" can't be wrong any mo=
re.
>>
>>>
>>>>> others will automatically kick out the misbehaving drive.  *none* o=
f them will take back the the drive with old data and start commingling t=
hat data with good copy.)\ This behaviour from BTRFS is completely abnorm=
al.. and defeats even the most basic expectations of RAID.
>>>>
>>>> RAID1 can only tolerate 1 missing device, it has nothing to do with
>>>> error detection.
>>>> And it's impossible to detect such case without extra help.
>>>>
>>>> Your expectation is completely wrong.
>>>>
>>>
>>> Well ... somehow it is my experience as well ... :)
>>
>> Acceptable, but not really apply to software based RAID1.
>>
>> Thanks,
>> Qu
>>
>>>
>>>>>
>>>>> I'm not the one who has to clear his expectations here.
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>
>=20
>=20


--OONqTOf8LCi1XKp8DpXoXzaA28bBIKkmf--

--KhYgr58zfcYNGTFSHFAeUgwLWFFbyvgV5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls1eD0ACgkQwj2R86El
/qjUWAgAkttej0wLHUyo33MIj5awSj32wBdPXsR5HxNZsdvv+7H1o88Qhk2IAi9J
u0Eq/7+gWqPtQd2d7clEliAQ5kjz8lIfabh6dHKu4TjWgrLX7KVyZdz6WOqvlhJc
d4a2Ri18GbImXK8d09lHXkeGYH+EMDjuhpSkyBfbUsHJc0wfO+skuJWpWga3JqK8
cS10FU03XZwEu+W2iJNjkZq6mnLomnNSNOyecKp1mFC+VMyo7xQUiu7iyoU4QudW
NJKQmbMEINje5Z3PdRiCG+V9LEXW+y+SsKVjIhafGnjxnjEskOMZlHFRLk9mThFr
QOyszRqZ0zo3FPv0ZUJcWoJ51XZ+HA==
=mzig
-----END PGP SIGNATURE-----

--KhYgr58zfcYNGTFSHFAeUgwLWFFbyvgV5--
