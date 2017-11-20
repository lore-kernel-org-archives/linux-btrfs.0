Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752552AbdKTUk5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 15:40:57 -0500
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
 <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>
 <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
Message-ID: <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
Date: Mon, 20 Nov 2017 15:40:54 -0500
MIME-Version: 1.0
In-Reply-To: <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CJsccipc6kAshmQMKvPmtKstDQ3WgAhE6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CJsccipc6kAshmQMKvPmtKstDQ3WgAhE6
Content-Type: multipart/mixed; boundary="iQPcpVkmv8Mr0fsRXmvSFJTnDHq2rK4UH";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>,
 Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
 <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>
 <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
In-Reply-To: <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>

--iQPcpVkmv8Mr0fsRXmvSFJTnDHq2rK4UH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/20/17 3:01 PM, Jeff Mahoney wrote:
> On 11/20/17 3:00 PM, Jeff Mahoney wrote:
>> On 11/19/17 4:38 PM, Chris Murphy wrote:
>>> On Sat, Nov 18, 2017 at 11:27 PM, Andrei Borzenkov <arvidjaar@gmail.c=
om> wrote:
>>>> 19.11.2017 09:17, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>>> fstrim should trim free space, but it only trims unallocated. This =
is
>>>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
>>>>> behaved this way with 4.12 also.
>>>>>
>>>>
>>>> Well, I was told it should also trim free space ...
>>>>
>>>> https://www.spinics.net/lists/linux-btrfs/msg61819.html
>>>>
>>>
>>> It definitely isn't. If I do a partial balance, then fstrim, I get a
>>> larger trimmed value, corresponding exactly to unallocated space.
>>
>>
>> I've just tested with 4.14 and it definitely trims within block groups=
=2E
>=20
> Derp.  This should read 4.12.
>=20
>> I've attached my test script and the log of the run.  I'll build and
>> test a 4.14 kernel and see if I can reproduce there.  It may well be
>> that we're just misreporting the bytes trimmed.

I get the same results on v4.14.  I wrote up a little script to parse
the btrfs-debug-tree extent tree dump and the discards that are issued
after the final sync (when the tree is dumped) match.

The script output is also as expected:
/mnt2: 95.1 GiB (102082281472 bytes) trimmed
# remove every other 100MB file, totalling 1.5 GB
+ sync
+ killall blktrace
+ wait
+ echo 'after sync'
+ sleep 1
+ btrace -a discard /dev/loop0
+ fstrim -v /mnt2
/mnt2: 96.6 GiB (103659962368 bytes) trimmed

One thing that may not be apparent is that the byte count is from the
device(s)'s perspective.  If you have a file system with duplicate
chunks or a redundant RAID mode, the numbers will reflect that.

The total byte count should be correct as well.  It's the total number
of bytes that we submit for discard and that were accepted by the block
layer.

Do you have a test case that shows it being wrong and can you provide
the blktrace capture of the device(s) while the fstrim is running?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--iQPcpVkmv8Mr0fsRXmvSFJTnDHq2rK4UH--

--CJsccipc6kAshmQMKvPmtKstDQ3WgAhE6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAloTPdYPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWy1ZgP/jU6fFvEeC6tQWtZfyL2JkXhG9ShfLa3L2NW
aIudhQoMEgKqeLmIVQPqNjj30Oz1jTZ4Uc0n0c26I1+ChQTGc0hZswzc3C+yZmFy
9U1tVNkN31mGVRezJT7Zwfh9jDi6E0Y9gvfpftGL9icLsK/prX+ODlJknpAx9dR1
1UXMPHWjX5dchRAmSbN/KKYanohE/tqNpq6/B+zps/nHhcMWq9b62yBuZawAG0dV
tM9QV0QWZh8Izt39NKHIq8WvonsSBVMPk9XXsrmOMUtjk4PcwooPz8iLUdlH9oyW
AT5TTX6yMW7ruUcbV5atRDS+AslZPL1W72Ul+juD4cyKvj/3wFBGMtN9Sq6+QUQr
Ue2Z4KFWm2sV7TDVHfUAH4/mFGA2rICg3DyPKmYz4F79uNlZ50b6lGp2G/+573Mj
NE4qHQBiv2Odduv6NNzsK9zxdNEnv+xObdGtaKyJ6WQSOmw9bnbokmMexRygfaf6
j3VaWg6zHVf0Ns4x5r6JukeRBh3z7HJRZJZPRXeG60EgOcSrG8l/N3xF7zNVc89H
hlO9XEOLZ9fayrwnKcUfMOXEvbH+Apn5pRVrGkf8xkIpMlBDkdCoMeJ7IOeOhGLL
PbJd+298YFSiwLHcek619HAyYQ8D1B2vftICLH8IEk2CfiLPGup2Lz4onaQCi62K
1Bz2jrJx
=u1m6
-----END PGP SIGNATURE-----

--CJsccipc6kAshmQMKvPmtKstDQ3WgAhE6--
