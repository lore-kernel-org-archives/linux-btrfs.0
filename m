Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:34401 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752351AbeF1LqW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 07:46:22 -0400
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: remi@georgianit.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
 <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
 <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
 <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
 <3adf52c1-735d-9e0c-52a5-107e2d88af8f@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e6fca2e3-4126-5a3d-7c7d-9b274742f639@gmx.com>
Date: Thu, 28 Jun 2018 19:46:10 +0800
MIME-Version: 1.0
In-Reply-To: <3adf52c1-735d-9e0c-52a5-107e2d88af8f@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RCcrrWw1NRAu5AFNLJ9FkSd312QrvBJ35"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RCcrrWw1NRAu5AFNLJ9FkSd312QrvBJ35
Content-Type: multipart/mixed; boundary="MCGUk68QDW0R0PCGGoSjJ5o0wzb6E2e7O";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Andrei Borzenkov <arvidjaar@gmail.com>
Cc: remi@georgianit.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <e6fca2e3-4126-5a3d-7c7d-9b274742f639@gmx.com>
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
 <3adf52c1-735d-9e0c-52a5-107e2d88af8f@gmail.com>
In-Reply-To: <3adf52c1-735d-9e0c-52a5-107e2d88af8f@gmail.com>

--MCGUk68QDW0R0PCGGoSjJ5o0wzb6E2e7O
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 19:12, Austin S. Hemmelgarn wrote:=

> On 2018-06-28 05:15, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 16:16, Andrei Borzenkov wrote:
>>> On Thu, Jun 28, 2018 at 8:39 AM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>> wrote:
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
>>>>> A drive failure, where the drive is still there when the computer
>>>>> reboots, is a situation that *any* raid 1, (or for that matter,
>>>>> raid 5, raid 6, anything but raid 0) will recover from perfectly
>>>>> without raising a sweat. Some will rebuild the array automatically,=

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
> LVM doesn't.=C2=A0 It detects that one of the devices was gone for some=

> period of time and marks the volume as degraded (and _might_, depending=

> on how you have things configured, automatically re-sync).=C2=A0 Not su=
re
> about MD, but I am willing to bet it properly detects this type of
> situation too.
>>
>> And the hardware solution looks pretty interesting, is the write to
>> NVRAM 100% atomic? Even at power loss?
> On a proper RAID controller, it's battery backed, and that battery
> backing provides enough power to also make sure that the state change i=
s
> properly recorded in the event of power loss.

Well, that explains a lot of thing.

So hardware RAID controller can be considered having a special battery
(always atomic) journal device.
If we can't provide UPS for the whole system, a battery powered journal
device indeed makes sense.

>>
>>>
>>>> The only possibility is that, the misbehaved device missed several
>>>> super
>>>> block update so we have a chance to detect it's out-of-date.
>>>> But that's not always working.
>>>>
>>>
>>> Why it should not work as long as any write to array is suspended
>>> until superblock on remaining devices is updated?
>>
>> What happens if there is no generation gap in device superblock?
>>
>> If one device got some of its (nodatacow) data written to disk, while
>> the other device doesn't get data written, and neither of them reached=

>> super block update, there is no difference in device superblock, thus =
no
>> way to detect which is correct.
> Yes, but that should be a very small window (at least, once we finally
> quit serializing writes across devices), and it's a problem on existing=

> RAID1 implementations too (and therefore isn't something we should be
> using as an excuse for not doing this).
>>
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
>>
>> Some file format may detect such problem by themselves if they have
>> internal checksum, but anyway, older data normally means corruption,
>> especially when partial new and partial old.
>>
>> On the other hand, with data COW and csum, btrfs can ensure the whole
>> filesystem update is atomic (at least for single device).
>> So the title, especially the "major design flaw" can't be wrong any mo=
re.
> The title is excessive, but I'd agree it's a design flaw that BTRFS
> doesn't at least notice that the generation ID's are different and
> preferentially trust the device with the newer generation ID.

Well, a design flaw should be something that can't be easily fixed
without *huge* on-disk format or behavior change.
Flaw in btrfs' one-subvolume-per-tree metadata design or current extent
booking behavior could be called design flaw.

While for things like this, just as the submitted RFC patch, less than
100 lines could change the behavior.

> The only
> special handling I can see that would be needed is around volumes
> mounted with the `nodatacow` option, which may not see generation
> changes for a very long time otherwise.

Nodatacow shouldn't cause much difference.
We still have commit interval, and metadata CoW.
Any btrfs metadata change or filesystem metadata change (inode change
etc) will still leads to a new generation.

Thanks,
Qu

>>
>>>
>>>>> others will automatically kick out the misbehaving drive.=C2=A0 *no=
ne*
>>>>> of them will take back the the drive with old data and start
>>>>> commingling that data with good copy.)\ This behaviour from BTRFS
>>>>> is completely abnormal.. and defeats even the most basic
>>>>> expectations of RAID.
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


--MCGUk68QDW0R0PCGGoSjJ5o0wzb6E2e7O--

--RCcrrWw1NRAu5AFNLJ9FkSd312QrvBJ35
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls0yoIACgkQwj2R86El
/qgK0Qf/TXTTYNpAYRz5UxAmdJZKuHe4Ta7mPKa2+p7z0pRUB8g2Lwn4P2+Vbjw6
yRj8ONU24rnljFiwaRtSl1m12rxGc3yHgK7SYoYLRfPzvetG57BvAzRWACckqMd/
h5OmfI/YSEVxupyTY4dYlvoJvsaBSEaw13AX1437KGHVIRokcTNJR4Os1UrbF2p7
6r2bvQ6Wy1Vgcz15xReJ3krVRUUt4olkz0c2rZ2A+dKgw7y8+aPq7pIfs869xMdU
4tCgzhCfTM3WeWYmz0wh04B+eUcarfmeRP7VkpNoXdNtGoxM7gMjuyfdHRYU3vcQ
1+ZNLoWaESSucfge6VLaf8biCighqg==
=8yUa
-----END PGP SIGNATURE-----

--RCcrrWw1NRAu5AFNLJ9FkSd312QrvBJ35--
