Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34118 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbcFXECj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 00:02:39 -0400
Received: by mail-lf0-f67.google.com with SMTP id l184so20343483lfl.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 21:02:38 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>
References: <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org>
Cc: kreijack@inwind.it, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <576CB0DA.6030409@gmail.com>
Date: Fri, 24 Jun 2016 07:02:34 +0300
MIME-Version: 1.0
In-Reply-To: <20160624014752.GB14667@hungrycats.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="raANNWKXgEidkD18J795n0p6aSg6B5ldB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--raANNWKXgEidkD18J795n0p6aSg6B5ldB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

24.06.2016 04:47, Zygo Blaxell =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Thu, Jun 23, 2016 at 06:26:22PM -0600, Chris Murphy wrote:
>> On Thu, Jun 23, 2016 at 1:32 PM, Goffredo Baroncelli <kreijack@inwind.=
it> wrote:
>>> The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to the c=
hecksum.
>>
>> Yeah I'm kinda confused on this point.
>>
>> https://btrfs.wiki.kernel.org/index.php/RAID56
>>
>> It says there is a write hole for Btrfs. But defines it in terms of
>> parity possibly being stale after a crash. I think the term comes not
>> from merely parity being wrong but parity being wrong *and* then being=

>> used to wrongly reconstruct data because it's blindly trusted.
>=20
> I think the opposite is more likely, as the layers above raid56
> seem to check the data against sums before raid56 ever sees it.
> (If those layers seem inverted to you, I agree, but OTOH there are
> probably good reason to do it that way).
>=20

Yes, that's how I read code as well. btrfs layer that does checksumming
is unaware of parity blocks at all; for all practical purposes they do
not exist. What happens is approximately

1. logical extent is allocated and checksum computed
2. it is mapped to physical area(s) on disks, skipping over what would
be parity blocks
3. when these areas are written out, RAID56 parity is computed and filled=
 in

IOW btrfs checksums are for (meta)data and RAID56 parity is not data.

> It looks like uncorrectable failures might occur because parity is
> correct, but the parity checksum is out of date, so the parity checksum=

> doesn't match even though data blindly reconstructed from the parity
> *would* match the data.
>=20

Yep, that is how I read it too. So if your data is checksummed, it
should at least avoid silent corruption.

>> I don't read code well enough, but I'd be surprised if Btrfs
>> reconstructs from parity and doesn't then check the resulting
>> reconstructed data to its EXTENT_CSUM.
>=20
> I wouldn't be surprised if both things happen in different code paths,
> given the number of different paths leading into the raid56 code and
> the number of distinct failure modes it seems to have.
>=20

Well, the problem is that parity block cannot be redirected on write as
data blocks; which makes it impossible to version control it. The only
solution I see is to always use full stripe writes by either wasting
time in fixed width stripe or using variable width, so that every stripe
always gets new version of parity. This makes it possible to keep parity
checksums like data checksums.


--raANNWKXgEidkD18J795n0p6aSg6B5ldB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAldssNoACgkQR6LMutpd94yFDwCfQ3/KAfVYuoXgB/xEYsQsuq8S
438AnRXMcHvIoe6ADkARff77kJYlWkho
=f41e
-----END PGP SIGNATURE-----

--raANNWKXgEidkD18J795n0p6aSg6B5ldB--
