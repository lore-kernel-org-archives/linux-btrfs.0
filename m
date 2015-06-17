Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:47271 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbbFQNrI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 09:47:08 -0400
Received: from smtp26.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp26.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 4DC8A38036D
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:47:07 -0400 (EDT)
Received: from smtp26.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp26.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 3EB1838032D
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:47:07 -0400 (EDT)
Received: by smtp26.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id 0318938036D
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:47:01 -0400 (EDT)
Content-Type: multipart/signed; boundary="Apple-Mail=_DAC8D7E7-0706-41ED-AE7A-4BA007AB30CD"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: RAID10 Balancing Request for Comments and Advices
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net>
Date: Wed, 17 Jun 2015 09:46:50 -0400
Message-Id: <74449C35-BA4E-4476-9EA1-EFE66312AFFA@up4.com>
References: <1434456557.89597618@apps.rackspace.com> <20150616122545.GI9850@carfax.org.uk> <61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com> <pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_DAC8D7E7-0706-41ED-AE7A-4BA007AB30CD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jun 16, 2015, at 7:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>=20
> Vincent Olivier posted on Tue, 16 Jun 2015 09:34:29 -0400 as =
excerpted:
>=20
>=20
>>> On Jun 16, 2015, at 8:25 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>=20
>>> On Tue, Jun 16, 2015 at 08:09:17AM -0400, Vincent Olivier wrote:
>>>>=20
>>>> My first question is this : is it normal to have =E2=80=9Csingle=E2=80=
=9D blocks ?
>>>> Why not only RAID10? I don=E2=80=99t remember the exact mkfs =
options I used
>>>> but I certainly didn=E2=80=99t ask for =E2=80=9Csingle=E2=80=9D so =
this is unexpected.
>>>=20
>>> Yes. It's an artefact of the way that mkfs works. If you run a
>>> balance on those chunks, they'll go away. (btrfs balance start
>>> -dusage=3D0 -musage=3D0 /mountpoint)
>>=20
>> Thanks! I did and it did go away, except for the "GlobalReserve, =
single:
>> total=3D512.00MiB, used=3D0.00B=E2=80=9D. But I suppose this is a =
permanent fixture,
>> right?
>=20
> Yes.  GlobalReserve is for short-term btrfs-internal use, reserved for
> times when btrfs needs to (temporarily) allocate some space in ordered =
to
> free space, etc.  It's always single, and you'll rarely see anything =
but
> 0 used except perhaps in the middle of a balance or something.


Get it. Thanks.

Is there anyway to put that on another device, say, a SSD? I am thinking =
of backing up this RAID10 on a 2x8TB device-managed SMR RAID1 and I want =
to minimize random write operations (noatime & al.). I will start a new =
thread for that maybe but first, is there something substantial I can =
read about btrfs+SMR? Or should I avoid SMR+btfs ?


>=20
>>> For maintenance, I would suggest running a scrub regularly, to
>>> check for various forms of bitrot. Typical frequencies for a scrub =
are
>>> once a week or once a month -- opinions vary (as do runtimes).
>>=20
>>=20
>> Yes. I cronned it weekly for now. Takes about 5 hours. Is it
>> automatically corrected on RAID10 since a copy of it exist within the
>> filesystem ? What happens for RAID0 ?
>=20
> For raid10 (and the raid1 I use), yes, it's corrected, from the other
> existing copy, assuming it's good, tho if there are metadata checksum
> errors, there may be corresponding unverified checksums as well, where
> the verification couldn't be done because the metadata containing the
> checksums was bad.  Thus, if there are errors found and corrected, and
> you see unverified errors as well, rerun the scrub, so the newly
> corrected metadata can now be used to verify the previously unverified
> errors.


ok then, rule of the thumb re-run the scrub on =E2=80=9Cunverified =
checksum error(s)=E2=80=9D. I have yet to see checksum errors yet but =
will keep it in mind..

>=20
> I'm presently getting a lot of experience with this as one of the ssds =
in
> my raid1 is gradually failing and rewriting sectors.  Generally what
> happens is that the ssd will take too long, triggering a SATA reset =
(30
> second timeout), and btrfs will call that an error.  The scrub then
> rewrites the bad copy on the unreliable device with the good copy from
> the more reliable device, with the write triggering a sector =
relocation
> on the bad device.  The newly written copy then checks out good, but =
if
> it was metadata, it very likely contained checksums for several other
> blocks, which couldn't be verified because the block containing their
> checksums was itself bad.  Typically I'll see dozens to a couple =
hundred
> unverified errors for every bad metadata block rewritten in this way.
> Rerunning the scrub then either verifies or fixes the previously
> unverified blocks, tho sometimes one of those in turn ends up bad and =
if
> it's a metadata block, I may end up rerunning the scrub another time =
or
> two, until everything checks out.
>=20
> FWIW, on the bad device, smartctl -A reports (excerpted):
>=20
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      =
UPDATED  WHEN_FAILED RAW_VALUE
>  5 Reallocated_Sector_Ct   0x0032   098   098   036    Old_age   =
Always       -       259
> 182 Erase_Fail_Count_Total  0x0032   100   100   000    Old_age   =
Always       -       132
>=20
> While on the paired good device:
>=20
>  5 Reallocated_Sector_Ct   0x0032   253   253   036    Old_age   =
Always       -       0
> 182 Erase_Fail_Count_Total  0x0032   253   253   000    Old_age   =
Always       -       0
>=20
> Meanwhile, smartctl -H has already warned once that the device is
> failing, tho it went back to passing status again, but as of now it's
> saying failing, again.  The attribute that actually registers as =
failing,
> again from the bad device, followed by the good, is:
>=20
>  1 Raw_Read_Error_Rate     0x000f   001   001   006    Pre-fail  =
Always   FAILING_NOW 3081
>=20
>  1 Raw_Read_Error_Rate     0x000f   160   159   006    Pre-fail  =
Always       -       41
>=20
> When it's not actually reporting failing, the FAILING_NOW status is
> replaced with IN_THE_PAST.
>=20
> 250 Read_Error_Retry_Rate is the other attribute of interest, with =
values
> of 100 current and worst for both devices, threshold 0, but a raw =
value
> of 2488 for the good device and over 17,000,000 for the failing =
device.
> But with the "cooked" value never moving from 100 and with no real
> guidance on how to interpret the raw values, while it's interesting,
> I am left relying on the others for indicators I can actually =
understand.
>=20
> The 5 and 182 raw counts have been increasing gradually over time, and =
I
> scrub every time I do a major update, with another reallocated sector =
or
> two often appearing.  But as long as the paired good device keeps its =
zero
> count and I have backups (as I do!), btrfs is actually allowing me to
> continue using the unreliable device, relying on btrfs checksums and
> scrubbing to keep it usable.  And FWIW, I do have another device ready =
to
> go in when I decide I've had enough of this, but as long as I have
> backups and btrfs scrub keeps things fixed up, there's no real hurry
> unless I decide I'm tired of dealing with it.  Meanwhile, I'm having a
> bit of morbid fun watching as it slowly decays, getting experience of
> the process in a reasonably controlled setting without serious danger
> to my data, since it is backed up.


You sure have morbid inclinations ! ;-)

Out of curiosity what is the frequency and sequence of smartctl =
long/short tests + btrfs scrubs ? Is it all automated ?


> As for raid0 (and single), there's only one copy.  Btrfs detects =
checksum
> failure as it does above, but since there's only the one copy, if it's
> bad, well, for data you simply can't access that file any longer.  For
> metadata, you can't access whatever directories and files it =
referenced,
> any longer.  (FWIW for the truly desperate who hope that at least some =
of
> it can be recovered even if it's not a bit-perfect match, there's a =
btrfs
> command that wipes the checksum tree, which will let you access the
> previously bad-checksum files again, but it works on the entire
> filesystem so it's all or nothing, and of course with known =
corruption,
> there's no guarantees.)

But is it possible to manually correct the corruption by overwriting the =
corrupted files with a copy from a backup ? I mean is there enough =
information reported in order to do that ?

thanks!

v

--Apple-Mail=_DAC8D7E7-0706-41ED-AE7A-4BA007AB30CD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJVgXpLAAoJEOggPckf4s143gIP/j02VkJI75634jeQ8FwbcZdP
l4bDvMJI1IFweL2TKuTHN9XHYV4TfyqRWyP4FCe3v13uSTHcXzs9Hc4oeIORk7dv
ax8xTYeYsVHOHzV5VJFsKKGAkf2azUUwGQEygznTozGtyUuroJqwE6oBqICh08J3
MsLnW6sisONUDT9JNpkyC944t0y5VK5pWw3x0igEuIA5jSxzKPcu7o3WPegUd2Ix
4es3VqxdErcTEjjcCXpxHmLdcvJcbtb4ivsgYGz2Z01S31crp4liN3nVfxFnseYp
Nv21IkekxIni8wRRTg3EUzkR2/5P+0vA8Mi9IyUtgXMCj1waSpN/40jP3Sl2njLm
3yj3hy6OqF/z1aQsLE6u4S63lRKIOhcZGg03PjJJ25YwY5wqw0TUWccKAeMw0I07
zAXslS5skohw1Q1QidT92dxsk1S9ks/E5Yd2Ga+854RH0MCEGuYTpMZNJOPmbvQW
D5hXyI3WaMLxca60U5dCI5LOC+HpEyux5lTJM1sfArYiNpO+jDmfjH3qCsuDDzx/
cj+JGdq0QD8sQT0hw0ivu/R+dvE6OI4qd93jzhPEEg6gcC4DfJzTy8nZu46UyVZ8
aemjl+9ijpu2R2nxs5FMbGoJN/DrFcGOskr09vDa0SYKG1QrljOYUPYjQnpuTv2e
dgy5fs3+690+Q2C87fOa
=cB05
-----END PGP SIGNATURE-----

--Apple-Mail=_DAC8D7E7-0706-41ED-AE7A-4BA007AB30CD--
