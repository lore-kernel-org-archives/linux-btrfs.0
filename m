Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:34457 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936335AbeF2ARx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 20:17:53 -0400
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
To: Adam Borowski <kilobyte@angband.pl>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <20180628070443.23421-1-wqu@suse.com>
 <20180628143618.dcwakob5jw2ccx4y@angband.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d81d1f3d-135a-4894-119a-f11e6a0674b6@gmx.com>
Date: Fri, 29 Jun 2018 08:17:40 +0800
MIME-Version: 1.0
In-Reply-To: <20180628143618.dcwakob5jw2ccx4y@angband.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qKY5mMkcVluP74ttG6XYknPo9nXWzXPPY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qKY5mMkcVluP74ttG6XYknPo9nXWzXPPY
Content-Type: multipart/mixed; boundary="Qs6xcsUs9qK5lcucfiaFo9NEFqsrmVBmB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Adam Borowski <kilobyte@angband.pl>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <d81d1f3d-135a-4894-119a-f11e6a0674b6@gmx.com>
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
References: <20180628070443.23421-1-wqu@suse.com>
 <20180628143618.dcwakob5jw2ccx4y@angband.pl>
In-Reply-To: <20180628143618.dcwakob5jw2ccx4y@angband.pl>

--Qs6xcsUs9qK5lcucfiaFo9NEFqsrmVBmB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 22:36, Adam Borowski wrote:
> On Thu, Jun 28, 2018 at 03:04:43PM +0800, Qu Wenruo wrote:
>> There is a reporter considering btrfs raid1 has a major design flaw
>> which can't handle nodatasum files.
>>
>> Despite his incorrect expectation, btrfs indeed doesn't handle device
>> generation mismatch well.
>>
>> This means if one devices missed and re-appeared, even its generation
>> no longer matches with the rest device pool, btrfs does nothing to it,=

>> but treat it as normal good device.
>>
>> At least let's detect such generation mismatch and avoid mounting the
>> fs.
>=20
> Uhm, that'd be a nasty regression for the regular (no-nodatacow) case. =

> The vast majority of data is fine, and extents that have been written t=
o
> while a device is missing will be either placed elsewhere (if the files=
ystem
> knew it was degraded) or read one of the copies to notice a wrong check=
sum
> and automatically recover (if the device was still falsely believed to =
be
> good at write time).

Yes, for fs without any nodatasum usage, the behavior is indeed overkille=
d.
But sometimes such overkilled sanity check is really important, as long
as nodatasum is a provided feature.

>=20
> We currently don't have selective scrub yet so resyncing such single-co=
py
> extents is costly, but 1. all will be fine if the data is read, 2. it's=

> possible to add such a smart resync in the future, far better than a
> write-intent bitmap can do.

Well, auto scrub for a device looks not that bad to me.
Since normally scrub is scheduled as normal maintenance work, it should
not be a super expensive work.

We only need to teach btrfs to treat such device as kind of degraded.
Then we can reuse most of the scrub routine to fix it.

>=20
> To do the latter, we can note the last generation the filesystem was kn=
own
> to be fully coherent (ie, all devices were successfully flushed with no=

> mysterious write failures), then run selective scrub (perhaps even
> automatically) when the filesystem is no longer degraded.  There's some=

> extra complexity with 3- or 4-way RAID (multiple levels of degradation)=
 but
> a single number would help even there.
>=20
> But even currently, without the above not-yet-written recovery, it's
> reasonably safe to continue without scrub -- it's a case of running
> partially degraded when the bad copy is already known to be suspicious.=

>=20
> For no-nodatacow data and metadata, that is.
>=20
>> Currently there is no automatic rebuild yet, which means if users find=

>> device generation mismatch error message, they can only mount the fs
>> using "device" and "degraded" mount option (if possible), then replace=

>> the offending device to manually "rebuild" the fs.
>=20
> As nodatacow already means "I don't care about this data, or have anoth=
er
> way of recovering it", I don't quite get why we would drop existing
> auto-recovery for a common transient failure case.

Yep, exactly my understanding of nodatasum behavior.

However in real world, btrfs is the only *linux* fs supports data csum,
and the most widely used fs like ext4 xfs doesn't support data csum.

As the discussion about the behavior goes, I find that LVM/mdraid +
ext4/xfs could do better device missing management than btrfs nodatasum,
this means we need to at least do something that LVM/mdraid could provide=
=2E

>=20
> If you're paranoid, perhaps some bit "this filesystem has some nodataco=
w
> data on it" could warrant such a block, but it would still need to be
> overridable _without_ a need for replace.  There's also the problem tha=
t
> systemd marks its journal nodatacow (despite it having infamously bad
> handling of failures!), and too many distributions infect their default=

> installs with systemd, meaning such a bit would be on in most cases.
>=20
> But why would I put all my other data at risk, just because there's a
> nodatacow file?  There's a big difference between scrubbing when only a=
 few
> transactions worth of data is suspicious and completely throwing away a=

> mostly-good replica to replace it from the now fully degraded copy.
>=20
>> I totally understand that, generation based solution can't handle
>> split-brain case (where 2 RAID1 devices get mounted degraded separatel=
y)
>> at all, but at least let's handle what we can do.
>=20
> Generation can do well at least unless both devices were mounted elsewh=
ere
> and got the exact same number of transactions, the problem is that noda=
tacow
> doesn't bump generation number.

Generation is never a problem, as any metadata change will still bump
generation.

>=20
>> The best way to solve the problem is to make btrfs treat such lower ge=
n
>> devices as some kind of missing device, and queue an automatic scrub f=
or
>> that device.
>> But that's a lot of extra work, at least let's start from detecting su=
ch
>> problem first.
>=20
> I wonder if there's some way to treat problematic nodatacow files as
> degraded only?
>=20
> Nodatacow misses most of btrfs mechanisms, thus to get it done right yo=
u'd
> need to pretty much copy all of md's logic, with a write-intent bitmap =
or an
> equivalent.

At least, let's see what LVM/md is doing, and try to learn something is
never a bad idea.

Thanks,
Qu

>=20
>=20
> Meow!
>=20


--Qs6xcsUs9qK5lcucfiaFo9NEFqsrmVBmB--

--qKY5mMkcVluP74ttG6XYknPo9nXWzXPPY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls1eqQACgkQwj2R86El
/qgS6Af9EPN693U0ZsAJ8uhh2RPu47hTw5oG9nZcL1ii+/+kE8LzpHTcuiChRtoy
rTj+n+v3P3meFKzo0pfF/NYjuCo3D23+19q5jxAL9O80bQmNTNM9D2K/0E7gSFfR
eui4P+2+o+0Pq/V5KaG2hWdEyrpioByf07417Pgw+s4Kz9sNQcF2/AC6Vk9zHeFg
ESFhaGpSO9XlvHAQqETQAINquUNbkaG88Bo7V4GfBvJH41fKZ1x0+iFe41Ab3bNi
V6M+Su7J2+LhFjDX55mffADBbb0oAw6RGrcWWoRjE847MSCrIePxAbRnamQnWiya
omvvEsuQ0/iuPY/9rOuLsAQKonl3Hw==
=VIxv
-----END PGP SIGNATURE-----

--qKY5mMkcVluP74ttG6XYknPo9nXWzXPPY--
