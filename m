Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35521 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761066AbcLPPZW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 10:25:22 -0500
Subject: Re: [PATCH] btrfs: fix dereference on inode->i_sb before inode null
 check
To: Jeff Mahoney <jeffm@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20161216122056.20607-1-colin.king@canonical.com>
 <bdfa5c0f-758c-ad90-37b8-4d14516d5cdc@suse.com>
Cc: linux-kernel@vger.kernel.org
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <2d2ef70f-c07d-8062-924d-e7d88b8d98fa@canonical.com>
Date: Fri, 16 Dec 2016 15:24:41 +0000
MIME-Version: 1.0
In-Reply-To: <bdfa5c0f-758c-ad90-37b8-4d14516d5cdc@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EPcwLoED3gL5GF3jDbJldK8gbqkD7eH0h"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EPcwLoED3gL5GF3jDbJldK8gbqkD7eH0h
Content-Type: multipart/mixed; boundary="VpkxnFAQF3pIpG7HxgAmhvQuaIq6aQjQj";
 protected-headers="v1"
From: Colin Ian King <colin.king@canonical.com>
To: Jeff Mahoney <jeffm@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <2d2ef70f-c07d-8062-924d-e7d88b8d98fa@canonical.com>
Subject: Re: [PATCH] btrfs: fix dereference on inode->i_sb before inode null
 check
References: <20161216122056.20607-1-colin.king@canonical.com>
 <bdfa5c0f-758c-ad90-37b8-4d14516d5cdc@suse.com>
In-Reply-To: <bdfa5c0f-758c-ad90-37b8-4d14516d5cdc@suse.com>

--VpkxnFAQF3pIpG7HxgAmhvQuaIq6aQjQj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 16/12/16 15:03, Jeff Mahoney wrote:
> On 12/16/16 7:20 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> inode is being deferenced and then inode is checked to see if it
>> is null, implying we potentially could have a null pointer deference
>> on inode.
>>
>> Found with static analysis by CoverityScan, CID 1389472
>>
>> Fix this by dereferencing inode only after the inode null check.
>>
>> Fixes: 0b246afa62b0cf5 ("btrfs: root->fs_info cleanup, add fs_info con=
venience variables")
>=20
> Hi Colin -
>=20
> Thanks for the review.  The right fix here is to eliminate the tests fo=
r
> inode =3D=3D NULL entirely.  This is a callback for exportfs, which wil=
l
> itself crash if dentry->d_inode or parent->d_inode is NULL.  Removing
> the tests would be consistent with other file systems.

Ah, thanks for pointing that out. New patch on it's way soon.

Colin

>=20
> -Jeff
>=20
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  fs/btrfs/export.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
>> index 340d907..b746d2b 100644
>> --- a/fs/btrfs/export.c
>> +++ b/fs/btrfs/export.c
>> @@ -223,7 +223,7 @@ static int btrfs_get_name(struct dentry *parent, c=
har *name,
>>  {
>>  	struct inode *inode =3D d_inode(child);
>>  	struct inode *dir =3D d_inode(parent);
>> -	struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->i_sb);
>> +	struct btrfs_fs_info *fs_info;
>>  	struct btrfs_path *path;
>>  	struct btrfs_root *root =3D BTRFS_I(dir)->root;
>>  	struct btrfs_inode_ref *iref;
>> @@ -241,6 +241,7 @@ static int btrfs_get_name(struct dentry *parent, c=
har *name,
>>  	if (!S_ISDIR(dir->i_mode))
>>  		return -EINVAL;
>> =20
>> +	fs_info =3D btrfs_sb(inode->i_sb);
>>  	ino =3D btrfs_ino(inode);
>> =20
>>  	path =3D btrfs_alloc_path();
>>
>=20
>=20



--VpkxnFAQF3pIpG7HxgAmhvQuaIq6aQjQj--

--EPcwLoED3gL5GF3jDbJldK8gbqkD7eH0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQI2BAEBCAAgBQJYVAc5GRxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20ACgkQaMKH
38aoAibtThAAgtSKghMRolz6ctN4bD60srn8dcyJt+WlPGlrz0D18uSrzgLYreJa
IHvOHW3wUiOwl/xW/ZcRPDcu0+Rkoest3S9Vzouqgy+SSLyFXERD8fZnnEJ4NW1w
z8eocYtleBHW9x+IW7ij0M7w5CLIP8d9gtmIi6uVT3wvcMNU7AQnWb0CuYbi3kyS
C+SdeoQ+zegOo1j3gmsqRS3TUE8n8u5n9wr2V1KCda7Xcr2UGaHic8A5njsFdiuG
/aXZvzi8CAnd67AvCuX3K3H1uKEXoENlNlPYoXztPV7Tzg/kANsiGIhzyRa0jC/E
UHBdw883CTi1Ov2EbdVMWmH/5TFZaGexMXp2lk396q32zQp1OwyueBYuwnahAbuy
PcLU5F1RzNEsDfUPWua4FJtTXTCeS4lU8AcpIdCRsDFuL1pKnclyQ4wuyKm1oMtk
YdthFcXn4n+yCoXTaUep8oORo0njcD80soS6xi1Qy6WFUwKRIF/v4ED1+5vOSp/S
1nOuJmbTrDkzz0zPKDiSk5WqAiGVUviHg+dRXJkMjIyTUgddzwRvdhSfm0L4SlmT
nY9tWyD7HF3ySzBLcgyuqRw7X0yueeHJtDQAuf1OxEgfZAc/lPNgBg6ro4/ZdDzA
BlygaiBB8/3WaxhgjHaLkGErmjENzMEkwxvIVFP7+JcyGwNcksS0mfM=
=qaF8
-----END PGP SIGNATURE-----

--EPcwLoED3gL5GF3jDbJldK8gbqkD7eH0h--
