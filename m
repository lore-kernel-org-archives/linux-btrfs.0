Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59465 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751399AbdJ0IE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 04:04:59 -0400
Subject: Re: [PATCH] btrfs-progs: reserve < 0 return value for errnos
To: Nikolay Borisov <nborisov@suse.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20171027073133.24874-1-anand.jain@oracle.com>
 <76b167be-990a-c90e-8e14-067d2d07480e@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2aee5088-d26d-1c5e-3aa6-76db7d5cc728@gmx.com>
Date: Fri, 27 Oct 2017 16:04:34 +0800
MIME-Version: 1.0
In-Reply-To: <76b167be-990a-c90e-8e14-067d2d07480e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nXoNqin8SJt2VCOwes64RVAHXRFgcu8Aw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nXoNqin8SJt2VCOwes64RVAHXRFgcu8Aw
Content-Type: multipart/mixed; boundary="oLbmEW8a2oEg8fuLEQncfP37DvRCkam4b";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Anand Jain <anand.jain@oracle.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <2aee5088-d26d-1c5e-3aa6-76db7d5cc728@gmx.com>
Subject: Re: [PATCH] btrfs-progs: reserve < 0 return value for errnos
References: <20171027073133.24874-1-anand.jain@oracle.com>
 <76b167be-990a-c90e-8e14-067d2d07480e@suse.com>
In-Reply-To: <76b167be-990a-c90e-8e14-067d2d07480e@suse.com>

--oLbmEW8a2oEg8fuLEQncfP37DvRCkam4b
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8827=E6=97=A5 15:54, Nikolay Borisov wrote:
>=20
>=20
> On 27.10.2017 10:31, Anand Jain wrote:
>> btrfs_read_dev_super() returns -1 upon not finding a suitable SB,
>> change that to return 1 instead, so that it can reserve the < 0
>> values for the errno communications.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>=20
> I believe this is buggy since it will be masking errors. We call
> btrfs_read_dev_super in open_ctree_with_broken_chunk if the function
> returns 1 we eventually exit as: return ERR_PTR(ret); And then perform
> IS_ERR on the returned value. IS_ERR is essentially:
> ((x) >=3D (unsigned long)-MAX_ERRNO) where x could be 1 and MAX_ERRNO i=
s 4095
>=20
> So you just broke all functions which return the ret of
> btrfs_read_dev_super as ERR_PTR.
>=20
>=20
> NAK

This doesn't looks good to me either.

No suitable superblock is already an error.
Why not just returning -ENOENT and let caller who really needs to
distinguish this to catch that -ENOENT?

Thanks,
Qu

>=20
>> ---
>> An independent patch, not related to any recent patch sent to ML.
>>
>>  disk-io.c | 2 +-
>>  utils.c   | 2 +-
>>  volumes.c | 2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/disk-io.c b/disk-io.c
>> index f5edc4796619..ba87bb4ce6da 100644
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -1491,7 +1491,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_su=
per_block *sb, u64 sb_bytenr,
>>  		}
>>  	}
>> =20
>> -	return transid > 0 ? 0 : -1;
>> +	return transid > 0 ? 0 : 1;
>>  }
>> =20
>>  static int write_dev_supers(struct btrfs_fs_info *fs_info,
>> diff --git a/utils.c b/utils.c
>> index 524f463d3140..7574cda8151c 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1678,7 +1678,7 @@ int get_fs_info(const char *path, struct btrfs_i=
octl_fs_info_args *fi_args,
>>  		disk_super =3D (struct btrfs_super_block *)buf;
>>  		ret =3D btrfs_read_dev_super(fd, disk_super,
>>  					   BTRFS_SUPER_INFO_OFFSET, 0);
>> -		if (ret < 0) {
>> +		if (ret) {
>>  			ret =3D -EIO;
>>  			goto out;
>>  		}
>> diff --git a/volumes.c b/volumes.c
>> index 2209e5a9100b..87008bfdd586 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -268,7 +268,7 @@ int btrfs_scan_one_device(int fd, const char *path=
,
>> =20
>>  	disk_super =3D (struct btrfs_super_block *)buf;
>>  	ret =3D btrfs_read_dev_super(fd, disk_super, super_offset, sbflags);=

>> -	if (ret < 0)
>> +	if (ret)
>>  		return -EIO;
>>  	devid =3D btrfs_stack_device_id(&disk_super->dev_item);
>>  	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--oLbmEW8a2oEg8fuLEQncfP37DvRCkam4b--

--nXoNqin8SJt2VCOwes64RVAHXRFgcu8Aw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlny6JMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qghZgf9GlHGFjQ8llx8t3Z+fTN5dAHb
pjnuz9MzR9smOd32cl+sTokZWOFOr1m7TiTywlRAxTa/fBeUvlUwPS6lA3Oqifgj
15Y+2zaAvALhR2a0/PKvOImq4ufQpvbO7O2NXQue0NCDltITAPbiK3kaGfiVbf1z
mCbeqZkPPpEnIt+RzmQCdp1pPOjMkPGp8fwcQzWIVDhYuaWgJs3sU1GN/Tx9G6gW
1Rlm8l8tEyzFfFz7Wf066x/vozioC/43OfUm/fYtekkkhr/NiPVkZBg0Rl5myS82
Jlvg3d3wZ167U5hUSXPQQtkWokEb9lqwNJ2/Q72KRJAS7BGoJcyUskrJqJD74w==
=MagF
-----END PGP SIGNATURE-----

--nXoNqin8SJt2VCOwes64RVAHXRFgcu8Aw--
