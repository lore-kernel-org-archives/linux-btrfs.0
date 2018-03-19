Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965639AbeCSRwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 13:52:09 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 91A65AE89
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 17:52:07 +0000 (UTC)
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180316183627.15476-1-jeffm@suse.com>
 <20180316201206.GG16736@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <8950172e-98bc-8136-0ce3-aba1c5105c77@suse.com>
Date: Mon, 19 Mar 2018 13:52:05 -0400
MIME-Version: 1.0
In-Reply-To: <20180316201206.GG16736@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8ENL4hgBqxEMt3nM57hXV11uXZokLMtoH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8ENL4hgBqxEMt3nM57hXV11uXZokLMtoH
Content-Type: multipart/mixed; boundary="kqFagwVV76ufGSzBxjRgduvNa3FMmaNUs";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <8950172e-98bc-8136-0ce3-aba1c5105c77@suse.com>
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
References: <20180316183627.15476-1-jeffm@suse.com>
 <20180316201206.GG16736@twin.jikos.cz>
In-Reply-To: <20180316201206.GG16736@twin.jikos.cz>

--kqFagwVV76ufGSzBxjRgduvNa3FMmaNUs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/16/18 4:12 PM, David Sterba wrote:
> On Fri, Mar 16, 2018 at 02:36:27PM -0400, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> While running btrfs/011, I hit the following lockdep splat.
>>
>> This is the important bit:
>>    pcpu_alloc+0x1ac/0x5e0
>>    __percpu_counter_init+0x4e/0xb0
>>    btrfs_init_fs_root+0x99/0x1c0 [btrfs]
>>    btrfs_get_fs_root.part.54+0x5b/0x150 [btrfs]
>>    resolve_indirect_refs+0x130/0x830 [btrfs]
>>    find_parent_nodes+0x69e/0xff0 [btrfs]
>>    btrfs_find_all_roots_safe+0xa0/0x110 [btrfs]
>>    btrfs_find_all_roots+0x50/0x70 [btrfs]
>>    btrfs_qgroup_prepare_account_extents+0x53/0x90 [btrfs]
>>    btrfs_commit_transaction+0x3ce/0x9b0 [btrfs]
>>
>> The percpu_counter_init call in btrfs_alloc_subvolume_writers
>> uses GFP_KERNEL, which we can't do during transaction commit.
>>
>> This switches it to GFP_NOFS.
>=20
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/disk-io.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 21f34ad0d411..eb6bb3169a9e 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1108,7 +1108,7 @@ static struct btrfs_subvolume_writers *btrfs_all=
oc_subvolume_writers(void)
>>  	if (!writers)
>>  		return ERR_PTR(-ENOMEM);
>> =20
>> -	ret =3D percpu_counter_init(&writers->counter, 0, GFP_KERNEL);
>> +	ret =3D percpu_counter_init(&writers->counter, 0, GFP_NOFS);
>=20
> A line above the diff context is another allocation that does GFP_NOFS,=

> so one of the gfp flags were wrong.
>=20
> Looks like there's another instance where percpu allocates with
> GFP_KERNEL: create_space_info that can be called from the path that
> allocates chunks, so this also looks like a NOFS candidate.

We can get rid of this case entirely.  Those call sites should be
removed since the space_infos are all allocated at mount time.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--kqFagwVV76ufGSzBxjRgduvNa3FMmaNUs--

--8ENL4hgBqxEMt3nM57hXV11uXZokLMtoH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqv+MUPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWymJwQAIFS8swFhGT+WCuYGp0vurABaQZkRG3x0HL9
tfj6+sktt4SvRIvQnibVQHzBvH3yK6rPZslDfRIsAJgABPGlRk6lTcAvA497Hs0R
I2VDNBa0K9k7HWPr2QSxUIKTHPtPo2ETc45aBom4ONuyH7GspGSm8nzU4Wzu44JG
bJJ+Zanw5fNKonfeqd9KMsG+CdmQjDQlWGI8fhYEHIlhz3W6gCufWdZxa5/Ryuwz
ThJTm7loLawjS5UO81hNfvAc3eY0WcWmPbSuSMj+IOmcJM/3wZZfB1ZJ2L52dmYf
L+vixl5tXtlitfg4THc/0cs5oAdI+IIn+6XjetLLikS9LBw3WN0rIDLMWFUgoBG5
nTT0BXPWOVzDaCvjByQWiFiFGE12Dk4EqAd3D6wnnpMGWym+rwHFZ5f76xjH5ync
14Wfywyy2O/PQhzYt06ZpsgsjqcWHJyrE6QdN3MGiPdqh+v1UlG+3OnW2Uc6qOKe
kzVAz/UZDTBodU/AVADCd+HHgGA3Sl51zx+WvDTtd22h+jI9MpFfAQsREn7gmRqN
Y7JXS7ti4kNcszAk4j32OZz2bZhONvJtX1X0S2qZJoQcn4firefG5LwYf3foVhZZ
NmMDA7EV7Be+xbycSOep3ds93iTJpK+6Uks2RhyNajpXLP+9F/R61LqGa9nDQMN3
YPTiwqhD
=Ix5U
-----END PGP SIGNATURE-----

--8ENL4hgBqxEMt3nM57hXV11uXZokLMtoH--
