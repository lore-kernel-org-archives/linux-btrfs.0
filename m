Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751689AbdFUVlq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:41:46 -0400
Subject: Re: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in
 should_alloc_chunk
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
References: <1497455067-6050-1-git-send-email-jeffm@suse.com>
 <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
 <1988865f-6eb7-bdcf-67eb-51f0d0dbe36e@fb.com>
 <60c34b65-2940-bcfa-db7c-8a384608e083@suse.com>
 <b06bfd86-6bd4-50eb-0070-22feb5bb7f9e@fb.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a670fe7f-c462-943f-b9b2-25e864686eb5@suse.com>
Date: Wed, 21 Jun 2017 17:41:42 -0400
MIME-Version: 1.0
In-Reply-To: <b06bfd86-6bd4-50eb-0070-22feb5bb7f9e@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fwi2wCKxJhPKPepGAlTrpdftmDdQthluC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fwi2wCKxJhPKPepGAlTrpdftmDdQthluC
Content-Type: multipart/mixed; boundary="Ct80Qb3Ex8Emols4fo4gklVjnh431uSs8";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Message-ID: <a670fe7f-c462-943f-b9b2-25e864686eb5@suse.com>
Subject: Re: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in
 should_alloc_chunk
References: <1497455067-6050-1-git-send-email-jeffm@suse.com>
 <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
 <1988865f-6eb7-bdcf-67eb-51f0d0dbe36e@fb.com>
 <60c34b65-2940-bcfa-db7c-8a384608e083@suse.com>
 <b06bfd86-6bd4-50eb-0070-22feb5bb7f9e@fb.com>
In-Reply-To: <b06bfd86-6bd4-50eb-0070-22feb5bb7f9e@fb.com>

--Ct80Qb3Ex8Emols4fo4gklVjnh431uSs8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/21/17 5:15 PM, Chris Mason wrote:
>=20
>=20
> On 06/21/2017 05:08 PM, Jeff Mahoney wrote:
>> On 6/21/17 4:31 PM, Chris Mason wrote:
>>> On 06/21/2017 04:14 PM, Jeff Mahoney wrote:
>>>> On 6/14/17 11:44 AM, jeffm@suse.com wrote:
>>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>>
>>>>> In a heavy write scenario, we can end up with a large number of pin=
ned
>>>>> bytes.  This can translate into (very) premature ENOSPC because pin=
ned
>>>>> bytes must be accounted for when allowing a reservation but aren't
>>>>> accounted for when deciding whether to create a new chunk.
>>>>>
>>>>> This patch adds the accounting to should_alloc_chunk so that we can=

>>>>> create the chunk.
>>>>>
>>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>>>> ---
>>>>>  fs/btrfs/extent-tree.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>> index cb0b924..d027807 100644
>>>>> --- a/fs/btrfs/extent-tree.c
>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>> @@ -4389,7 +4389,7 @@ static int should_alloc_chunk(struct
>>>>> btrfs_fs_info *fs_info,
>>>>>  {
>>>>>      struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_=
rsv;
>>>>>      u64 num_bytes =3D sinfo->total_bytes - sinfo->bytes_readonly;
>>>>> -    u64 num_allocated =3D sinfo->bytes_used + sinfo->bytes_reserve=
d;
>>>>> +    u64 num_allocated =3D sinfo->bytes_used + sinfo->bytes_reserve=
d +
>>>>> sinfo->bytes_pinned + sinfo->bytes_may_use;
>>>>>      u64 thresh;
>>>>>
>>>>>      if (force =3D=3D CHUNK_ALLOC_FORCE)
>>>>>
>>>>
>>>>
>>>> Ignore this patch.  It certainly allocates chunks more aggressively,=

>>>> but
>>>> it means we end up with a ton of metadata chunks even when we don't
>>>> have
>>>> much metadata.
>>>>
>>>
>>> Josef and I pushed this needle back and forth a bunch of times in the=

>>> early days.  I still think we can allocate a few more chunks than we =
do
>>> now...
>>
>> I agree.  This patch was to fix an issue that we are seeing during
>> installation.  It'd stop with ENOSPC with >50GB completely unallocated=
=2E
>> The patch passed the test cases that were failing before but now it's
>> failing differently.  I was worried this pattern might be the end resu=
lt:
>>
>> Data,single: Size:4.00GiB, Used:3.32GiB
>>    /dev/vde        4.00GiB
>>
>> Metadata,DUP: Size:20.00GiB, Used:204.12MiB
>>    /dev/vde       40.00GiB
>>
>> System,DUP: Size:8.00MiB, Used:16.00KiB
>>    /dev/vde       16.00MiB
>>
>> This is on a fresh file system with just "cp /usr /mnt" executed.
>>
>> I'm looking into it a bit more now.
>=20
> Does this failure still happen with Omar's ENOSPC fix (commit:
> 70e7af244f24c94604ef6eca32ad297632018583)

Nope.  There aren't any warnings either with or without my patch.
Adding Omar's didn't make a difference.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--Ct80Qb3Ex8Emols4fo4gklVjnh431uSs8--

--fwi2wCKxJhPKPepGAlTrpdftmDdQthluC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWUroFh57S2MheeWyAQgUuA/+JmBbpPfxIncGdQfjMI4qWs/RRWMVBmhI
0sdB/uLiIHd0qqFkmTECDIkhcn1Fzw+1MnVyShauSjBUSTycCTEmm6tv5/m21fsN
LPURBl3PKWXbTkJ9fLmsMoru2tfJl5QaAQfuUNAVGM0Qi/uB7geKr/hUYgeeDMA8
FYEF6wAlkqvNBqjcdDHIUCwk114fFEB/BiimHuTql52RoajBI825lrXw+tyjsJlE
ihnwc6quWa1kJu1Wfbf3zM5n+fwBl7dnknTiaeZuvDQoM8TP+yEziTzsihN9D0nT
86eAoGBqFQ7BXaqml0qEBP2xWB3Gb+l4A8rrrVBeDGk+xT1PsgTXCg54YGCXrPWk
vKeyTL2t3Zp3AtjH/okzdQQIhCezmRYSOtMHMoSNJjC76lF5axWBC6liKgTPRpL9
uvaE94HTyC+ZmE2OtmzfDHimHa5D2y9lY6FML+EdS0344jw/MrHG6bPTmois0Glw
/uE6zZzvBXfF2ApyfCmrq/0YOLx4PwktiMLN6nQjjg1r4o1ArTFXGN0/YutqRQtN
1y/BA7MZxFC70FTOOHHnI1MDbjzEuSaV2nWX2M1sABGpGbiBkHGDf9dyPSLHIhg1
/hITPxcxJ9BdaxIe2lvsPOisYIwbrBYGxgiTMO0UJkGCGVaNDKRuNoQwaAO+eIko
8gkxPzzM444=
=Y0Y2
-----END PGP SIGNATURE-----

--fwi2wCKxJhPKPepGAlTrpdftmDdQthluC--
