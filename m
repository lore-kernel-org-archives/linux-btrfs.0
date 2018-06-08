Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbeFHE5y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 00:57:54 -0400
Subject: Re: [PATCH 0/6] btrfs-progs: Fixes inline ram_bytes related bugs
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <20180606072717.28854-1-wqu@suse.com>
 <d0ab3c91-3f19-49ee-165c-4dd11a74c4de@shaw.ca>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <5bb3beb4-86c9-5c4c-df0d-695e22ffb7a0@suse.de>
Date: Fri, 8 Jun 2018 12:57:43 +0800
MIME-Version: 1.0
In-Reply-To: <d0ab3c91-3f19-49ee-165c-4dd11a74c4de@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YKi2OZjollKH8a3c2oxYcjJaWhN8EFp9H"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YKi2OZjollKH8a3c2oxYcjJaWhN8EFp9H
Content-Type: multipart/mixed; boundary="6bdzo3bLDu50YEy8V89wFhCa1EFWagbfP";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
Message-ID: <5bb3beb4-86c9-5c4c-df0d-695e22ffb7a0@suse.de>
Subject: Re: [PATCH 0/6] btrfs-progs: Fixes inline ram_bytes related bugs
References: <20180606072717.28854-1-wqu@suse.com>
 <d0ab3c91-3f19-49ee-165c-4dd11a74c4de@shaw.ca>
In-Reply-To: <d0ab3c91-3f19-49ee-165c-4dd11a74c4de@shaw.ca>

--6bdzo3bLDu50YEy8V89wFhCa1EFWagbfP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8808=E6=97=A5 12:37, Steve Leung wrote:
> On 06/06/2018 01:27 AM, Qu Wenruo wrote:
>> The patchset can be fetched from github (*):
>> https://github.com/adam900710/btrfs-progs/tree/inline_ram_bytes
>>
>> It's based on David's devel branch, whose HEAD is:
>> commit 0d1c5812e28e286648781c7b35b542311cc01aa4 (david/devel)
>> Author: Matthias Benkard <matthias.benkard@egym.de>
>> Date:=C2=A0=C2=A0 Wed Apr 25 16:34:54 2018 +0200
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 btrfs-progs: mkfs: traverse_directory: Reset =
error code on continue
>>
>> Reported-by Steve Leung <sjleung@shaw.ca>, his old btrfs (at least
>> offending inodes are from 2014) has inline uncompressed extent, while
>> its ram_bytes mismatch with item size.
>=20
> Took a while to run, but:
>=20
> Tested-by: Steve Leung <sjleung@shaw.ca>
>=20
> Verifying everything against backups now, but things look good so far.
>=20
> I'm not 100% sure how to interpret the "btrfs check" output, but it
> sounded like it was going over each subvolume.=C2=A0 And since the corr=
uption
> was referenced by many subvolumes, the same work essentially had to be
> duplicated many times.

Yes, that's the case.

That would be a little like the way we do in kernel balance, thus it's
not implemented in btrfs-progs, so it would take a long time before we
have similar facility to fix it properly.

Or, I could fix it in another way, break the CoW behavior and do
in-place fix.
But if anyone wants to interrupt the fix, it may cause disaster.

>=20
> Is that a correct assessment?=C2=A0 Would it have saved time to remove =
a
> bunch of snapshots first before doing "btrfs check"?

Yep, it would save a lot of time.

Thanks,
Qu

>=20
> Either way, many thanks for getting everything going again!
>=20
> Steve
>=20
>=20
>> Latest kernel tree check catches this bug, while we failed to detect b=
y
>> dump-tree.
>>
>> It turns out that btrfs-progs is doing something evil to avoid reading=

>> ram_bytes from inline uncompressed extent.
>>
>>
>> So this patchset will address all such ram_bytes related problems.
>>
>> The 1st patch is a not-so-relative fix for restore, which is using
>> ram_bytes for decompress. Although thanks to the compression header, w=
e
>> won't read out-of-boundary, but fixing it is never a bad thing.
>>
>> The 2nd patch will get rid of the evil btrfs_file_extent_inline_len()
>> which hides raw ram_bytes from us, and fooling us for a long long time=
=2E
>>
>> The 3rd~5th patches introduce check/repair function for both original
>> and lowmem mode (although lowmem mode can detect it even before this
>> patch).
>>
>> The last one is the test case for it as usual.
>>
>> *: Or should I just migrate to gitlab after M$ acquired github?
>>
>> Qu Wenruo (6):
>> =C2=A0=C2=A0 btrfs-progs: restore: Fix wrong compressed item size for =
decompress()
>> =C2=A0=C2=A0 btrfs-progs: Get rid of the confusing btrfs_file_extent_i=
nline_len()
>> =C2=A0=C2=A0 btrfs-progs: check/original: Detect and repair wrong inli=
ne ram_bytes
>> =C2=A0=C2=A0 btrfs-progs: check/lowmem: Prepare check_file_extent() to=
 handle
>> =C2=A0=C2=A0=C2=A0=C2=A0 repair
>> =C2=A0=C2=A0 btrfs-progs: check/lowmem: Repair wrong inlien ram_bytes =
for
>> =C2=A0=C2=A0=C2=A0=C2=A0 uncompressed extent
>> =C2=A0=C2=A0 btrfs-progs: fsck-tests: Add test case for corrupted inli=
ne ram_bytes
>>
>> =C2=A0 check/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
|=C2=A0 46 ++++++-
>> =C2=A0 check/mode-lowmem.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 120 ++++++++++++++----
>> =C2=A0 check/mode-original.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
>> =C2=A0 cmds-restore.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=
 5 +-
>> =C2=A0 ctree.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 22 ----
>> =C2=A0 file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +-
>> =C2=A0 print-tree.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
|=C2=A0=C2=A0 4 +-
>> =C2=A0 .../offset_by_one.img=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | Bin 0 -> 3072 bytes
>> =C2=A0 .../035-inline-bad-ram-bytes/test.sh=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 11 ++
>> =C2=A0 9 files changed, 157 insertions(+), 55 deletions(-)
>> =C2=A0 create mode 100644
>> tests/fsck-tests/035-inline-bad-ram-bytes/offset_by_one.img
>> =C2=A0 create mode 100755 tests/fsck-tests/035-inline-bad-ram-bytes/te=
st.sh
>>
>=20
>=20


--6bdzo3bLDu50YEy8V89wFhCa1EFWagbfP--

--YKi2OZjollKH8a3c2oxYcjJaWhN8EFp9H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsaDMcACgkQwj2R86El
/qjxSQgAqqzPh/jsNkEmbvvQjO9R8OG0EDpplTC+qgyQN7XhHXZ3zO868eXzDRDP
RUA0nJ2CQ/LzoUH8HYtnPr/aW/yt3+vxJJpJy051Ed1jwbrBqIEh7XrTg80JdHxi
kyBN2nIb9C7O2beG/P32EKXWK6gucTtvID7tEs0FYBv8GuxuijAFuqU2SoEfMEZJ
I2FIj8yw4M/TvZXQ2z20wG4FDkvTmrs6jIlMCMay622jzzVOKwtICdd6APUGjY6p
PFHVRRLcFeMonUJkc/RcOYdybIXoOOK5a6CDkAVrnmCe3rMYM1u61nnwX21xIeuY
fc2WVxAWs9Us5Lrm26/5r2aAxJNLjQ==
=V+85
-----END PGP SIGNATURE-----

--YKi2OZjollKH8a3c2oxYcjJaWhN8EFp9H--
