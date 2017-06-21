Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45568 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751108AbdFUVIc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:08:32 -0400
Subject: Re: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in
 should_alloc_chunk
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
References: <1497455067-6050-1-git-send-email-jeffm@suse.com>
 <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
 <1988865f-6eb7-bdcf-67eb-51f0d0dbe36e@fb.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <60c34b65-2940-bcfa-db7c-8a384608e083@suse.com>
Date: Wed, 21 Jun 2017 17:08:28 -0400
MIME-Version: 1.0
In-Reply-To: <1988865f-6eb7-bdcf-67eb-51f0d0dbe36e@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hoAosHuFIFW39ToltkaujX4sHW6t1kMF8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hoAosHuFIFW39ToltkaujX4sHW6t1kMF8
Content-Type: multipart/mixed; boundary="rK3Jjq6ucR7Pj3BgGK55074bH40K3jeuS";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Message-ID: <60c34b65-2940-bcfa-db7c-8a384608e083@suse.com>
Subject: Re: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in
 should_alloc_chunk
References: <1497455067-6050-1-git-send-email-jeffm@suse.com>
 <9c76636b-a364-7911-3cdd-08c98b2af188@suse.com>
 <1988865f-6eb7-bdcf-67eb-51f0d0dbe36e@fb.com>
In-Reply-To: <1988865f-6eb7-bdcf-67eb-51f0d0dbe36e@fb.com>

--rK3Jjq6ucR7Pj3BgGK55074bH40K3jeuS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/21/17 4:31 PM, Chris Mason wrote:
> On 06/21/2017 04:14 PM, Jeff Mahoney wrote:
>> On 6/14/17 11:44 AM, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> In a heavy write scenario, we can end up with a large number of pinne=
d
>>> bytes.  This can translate into (very) premature ENOSPC because pinne=
d
>>> bytes must be accounted for when allowing a reservation but aren't
>>> accounted for when deciding whether to create a new chunk.
>>>
>>> This patch adds the accounting to should_alloc_chunk so that we can
>>> create the chunk.
>>>
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>> ---
>>>  fs/btrfs/extent-tree.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index cb0b924..d027807 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -4389,7 +4389,7 @@ static int should_alloc_chunk(struct
>>> btrfs_fs_info *fs_info,
>>>  {
>>>      struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rs=
v;
>>>      u64 num_bytes =3D sinfo->total_bytes - sinfo->bytes_readonly;
>>> -    u64 num_allocated =3D sinfo->bytes_used + sinfo->bytes_reserved;=

>>> +    u64 num_allocated =3D sinfo->bytes_used + sinfo->bytes_reserved =
+
>>> sinfo->bytes_pinned + sinfo->bytes_may_use;
>>>      u64 thresh;
>>>
>>>      if (force =3D=3D CHUNK_ALLOC_FORCE)
>>>
>>
>>
>> Ignore this patch.  It certainly allocates chunks more aggressively, b=
ut
>> it means we end up with a ton of metadata chunks even when we don't ha=
ve
>> much metadata.
>>
>=20
> Josef and I pushed this needle back and forth a bunch of times in the
> early days.  I still think we can allocate a few more chunks than we do=

> now...

I agree.  This patch was to fix an issue that we are seeing during
installation.  It'd stop with ENOSPC with >50GB completely unallocated.
The patch passed the test cases that were failing before but now it's
failing differently.  I was worried this pattern might be the end result:=


Data,single: Size:4.00GiB, Used:3.32GiB
   /dev/vde        4.00GiB

Metadata,DUP: Size:20.00GiB, Used:204.12MiB
   /dev/vde       40.00GiB

System,DUP: Size:8.00MiB, Used:16.00KiB
   /dev/vde       16.00MiB

This is on a fresh file system with just "cp /usr /mnt" executed.

I'm looking into it a bit more now.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--rK3Jjq6ucR7Pj3BgGK55074bH40K3jeuS--

--hoAosHuFIFW39ToltkaujX4sHW6t1kMF8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWUrgTB57S2MheeWyAQj8QA/+MTVV053MBNIwEsf6sIVtk5x5CvXwYLqO
LFVXGJ3hn795/l/7eJlQJhGlQ4EyyBCp2KHoFi5EvTSYkCiziYDewCjQP/kKAqZl
+jh43l3e3xbVHCaJc2LBm4SSn+XOWniUEQ/nL4BMXlPvbkTfZpKaxzoSsIf/OnVp
nBKZQ6lS03cnpNKg0kdmc2ghskFfELBDxvXxDkZ+0eMV/VVhsEShHNPmd3BYuTf3
8S9ExlD2+j6G1Q5FGZ2aLJIuUfEz/esLAOXF0FRl4n0fyRXQzh0SwmL9SK2hzjoE
j6QoRSIjdJzW2qLMt6lFNtbkjiTDqCpcOUvJkgWly23MT3DZeGN66ZE6R9UlDq4S
/hjp5kDfCJe2nRJmRZOAvrzaQ9LKRvbhWaLJdTzLQsIkLQh9yRDRvyEdpoSZhxOo
+QezEvANB/iqNH7dFZsQhHUl93WaUmuTJmn/csUvMTBZ71eZNDIMybUrUA54AFY1
FWuHks2FBXYDxOplkxoqHIeCAX0zA3AM+u52IlzW0pi9j9Xy8QwlWXX+9n5cc8Qm
J8vvzhg+5m/s5PwSVzwjJwattMax2A+TDgsNmOTmsH8kTvrDf6+4WSWNoOyF87Xn
KpZ75mlPRmny8rNo0svcAILuju27/HT/5a5pHcDdxKg7MsRKS586/4ZH/UPPdOhD
clIHIrKSF6w=
=pRNG
-----END PGP SIGNATURE-----

--hoAosHuFIFW39ToltkaujX4sHW6t1kMF8--
