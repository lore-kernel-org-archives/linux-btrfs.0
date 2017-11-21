Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdKUBqX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 20:46:23 -0500
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
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <0085a34c-3cf9-bd4c-dd9d-34fb994737a7@suse.com>
Date: Mon, 20 Nov 2017 20:46:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ4uJG-bSQnUOXjBYYqG6Hp6Tf_fHsaoHfKgZ17w6mo0Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RJNktIdR0w7n8PsOSKPnoLEOkG0PU1Est"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RJNktIdR0w7n8PsOSKPnoLEOkG0PU1Est
Content-Type: multipart/mixed; boundary="wiHjo2xXQcsskU2pNGUD56peXfWeeR9K1";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <0085a34c-3cf9-bd4c-dd9d-34fb994737a7@suse.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
 <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>
 <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
 <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
 <CAJCQCtQ4uJG-bSQnUOXjBYYqG6Hp6Tf_fHsaoHfKgZ17w6mo0Q@mail.gmail.com>
In-Reply-To: <CAJCQCtQ4uJG-bSQnUOXjBYYqG6Hp6Tf_fHsaoHfKgZ17w6mo0Q@mail.gmail.com>

--wiHjo2xXQcsskU2pNGUD56peXfWeeR9K1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/20/17 5:59 PM, Chris Murphy wrote:
> On Mon, Nov 20, 2017 at 1:40 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 11/20/17 3:01 PM, Jeff Mahoney wrote:
>>> On 11/20/17 3:00 PM, Jeff Mahoney wrote:
>>>> On 11/19/17 4:38 PM, Chris Murphy wrote:
>>>>> On Sat, Nov 18, 2017 at 11:27 PM, Andrei Borzenkov <arvidjaar@gmail=
=2Ecom> wrote:
>>>>>> 19.11.2017 09:17, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>>>>> fstrim should trim free space, but it only trims unallocated. Thi=
s is
>>>>>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it=

>>>>>>> behaved this way with 4.12 also.
>>>>>>>
>>>>>>
>>>>>> Well, I was told it should also trim free space ...
>>>>>>
>>>>>> https://www.spinics.net/lists/linux-btrfs/msg61819.html
>>>>>>
>>>>>
>>>>> It definitely isn't. If I do a partial balance, then fstrim, I get =
a
>>>>> larger trimmed value, corresponding exactly to unallocated space.
>>>>
>>>>
>>>> I've just tested with 4.14 and it definitely trims within block grou=
ps.
>>>
>>> Derp.  This should read 4.12.
>>>
>>>> I've attached my test script and the log of the run.  I'll build and=

>>>> test a 4.14 kernel and see if I can reproduce there.  It may well be=

>>>> that we're just misreporting the bytes trimmed.
>>
>> I get the same results on v4.14.  I wrote up a little script to parse
>> the btrfs-debug-tree extent tree dump and the discards that are issued=

>> after the final sync (when the tree is dumped) match.
>>
>> The script output is also as expected:
>> /mnt2: 95.1 GiB (102082281472 bytes) trimmed
>> # remove every other 100MB file, totalling 1.5 GB
>> + sync
>> + killall blktrace
>> + wait
>> + echo 'after sync'
>> + sleep 1
>> + btrace -a discard /dev/loop0
>> + fstrim -v /mnt2
>> /mnt2: 96.6 GiB (103659962368 bytes) trimmed
>>
>> One thing that may not be apparent is that the byte count is from the
>> device(s)'s perspective.  If you have a file system with duplicate
>> chunks or a redundant RAID mode, the numbers will reflect that.
>>
>> The total byte count should be correct as well.  It's the total number=

>> of bytes that we submit for discard and that were accepted by the bloc=
k
>> layer.
>>
>> Do you have a test case that shows it being wrong and can you provide
>> the blktrace capture of the device(s) while the fstrim is running?
>=20
>=20
> Further,
>=20
> # fstrim -v /
> /: 38 GiB (40767586304 bytes) trimmed
>=20
> And then delete 10G worth of files, do not balance, and do nothing for
> a minute before:
>=20
> # fstrim -v /
> /: 38 GiB (40767586304 bytes) trimmed
>=20
> It's the same value. Free space according to fi us is +10 larger than
> before, and yet nothing additional is trimmed than before. So I don't
> know what's going on but it's not working for me.

What happens if you sync before doing the fstrim again?  The code is
there to drop extents within block groups.  It works for me.  The big
thing is that the space must be freed entirely before we can trim.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--wiHjo2xXQcsskU2pNGUD56peXfWeeR9K1--

--RJNktIdR0w7n8PsOSKPnoLEOkG0PU1Est
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAloThWsPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyZ+gQAIIWE33gG/JHeVkhfnflV4Ln/fcAfZnoxN/n
nWOu3FdB0faZIhyC2OzI/mpEDEej6Rxa03LYW4HQPv0T/ITS4i5fdqWK5GARgKXv
Brdsnmt3oAhvZgYILwW+2/wL97moIsilzmDMgv2TZBXhbIZASSMf8eycotsKY1go
rRik1oQXmajF+DjJzqaIH9t1KUduEzsV7XLjbIprgh9Xi5ETLN2ZkwJ1i4YZ5nd7
NENIrMpHHCMAAlLxePO+fEmi+VsvnCk1kFGxCDnRojXV61HHS2oMgextRGC3r9Ma
wlMY7kNghMKPTj8oT27xRKwZitV8Q/i1nZqu2OWgXagtOxwDuY0GIPqxZ09GtmD+
HGPTDLnZsy0T9h84ndjZIsZkSJu9IGvuSJf+ueNWRa6hb0vcLJkqIfi6v0rUBHKB
Nox44peggaqHn1MkRT8S+UnMckcVJuKDK0upKreRoezf+mFZACsAB90EGgmeUuv0
vX7GJ9op2QXAM4u2Z8TpYpKiF5Tm6p4kWN0Itu9PDvihr+TNtGUECdZ3SKfxVm3L
9fjsyhAfzS2mNmLNvwLE7UCuk1mNrUSqT80dZ5w6linqmpr0gF/qA4BsabiTVpaU
g0v2k3dHy+QLJJVvnCwYLkfl1yHahzGm9c73VQkA1rTh27K0I0G9J1jDcpCVdYBO
J8kkgKhN
=+uc8
-----END PGP SIGNATURE-----

--RJNktIdR0w7n8PsOSKPnoLEOkG0PU1Est--
