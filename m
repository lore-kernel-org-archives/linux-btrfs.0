Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbcF0C2T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 22:28:19 -0400
Subject: Re: [PATCH 04/31] btrfs: tests, move initialization into tests/
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-5-git-send-email-jeffm@suse.com>
 <ad05794a-c417-ec49-d1b9-22eda06e141e@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <57708F3E.7090205@suse.com>
Date: Sun, 26 Jun 2016 22:28:14 -0400
MIME-Version: 1.0
In-Reply-To: <ad05794a-c417-ec49-d1b9-22eda06e141e@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="44BjaoiUpISQQxqO4bAnLP45h6COoR3wU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--44BjaoiUpISQQxqO4bAnLP45h6COoR3wU
Content-Type: multipart/mixed; boundary="VCVVWJWtpJQeQXsnDLSV1slkwrAmfQ58x"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <57708F3E.7090205@suse.com>
Subject: Re: [PATCH 04/31] btrfs: tests, move initialization into tests/
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-5-git-send-email-jeffm@suse.com>
 <ad05794a-c417-ec49-d1b9-22eda06e141e@cn.fujitsu.com>
In-Reply-To: <ad05794a-c417-ec49-d1b9-22eda06e141e@cn.fujitsu.com>

--VCVVWJWtpJQeQXsnDLSV1slkwrAmfQ58x
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/26/16 10:17 PM, Qu Wenruo wrote:
>=20
>=20
> At 06/25/2016 06:14 AM, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> We have all these stubs that only exist because they're called from
>> btrfs_run_sanity_tests, which is a static inside super.c.  Let's just
>> move it all into tests/btrfs-tests.c and only have one stub.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/super.c             | 43
>> ----------------------------------------
>>  fs/btrfs/tests/btrfs-tests.c | 47
>> ++++++++++++++++++++++++++++++++++++++++++--
>>  fs/btrfs/tests/btrfs-tests.h | 35 +++------------------------------
>>  3 files changed, 48 insertions(+), 77 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index a7b9a15..d8e48bb 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -2323,49 +2323,6 @@ static void btrfs_print_mod_info(void)
>>              btrfs_crc32c_impl());
>>  }
>>
>> -static int btrfs_run_sanity_tests(void)
>> -{
>> -    int ret, i;
>> -    u32 sectorsize, nodesize;
>> -    u32 test_sectorsize[] =3D {
>> -        PAGE_SIZE,
>> -    };
>> -    ret =3D btrfs_init_test_fs();
>> -    if (ret)
>> -        return ret;
>> -    for (i =3D 0; i < ARRAY_SIZE(test_sectorsize); i++) {
>> -        sectorsize =3D test_sectorsize[i];
>> -        for (nodesize =3D sectorsize;
>> -             nodesize <=3D BTRFS_MAX_METADATA_BLOCKSIZE;
>> -             nodesize <<=3D 1) {
>> -            pr_info("BTRFS: selftest: sectorsize: %u  nodesize: %u\n"=
,
>> -                sectorsize, nodesize);
>> -            ret =3D btrfs_test_free_space_cache(sectorsize, nodesize)=
;
>> -            if (ret)
>> -                goto out;
>> -            ret =3D btrfs_test_extent_buffer_operations(sectorsize,
>> -                nodesize);
>> -            if (ret)
>> -                goto out;
>> -            ret =3D btrfs_test_extent_io(sectorsize, nodesize);
>> -            if (ret)
>> -                goto out;
>> -            ret =3D btrfs_test_inodes(sectorsize, nodesize);
>> -            if (ret)
>> -                goto out;
>> -            ret =3D btrfs_test_qgroups(sectorsize, nodesize);
>> -            if (ret)
>> -                goto out;
>> -            ret =3D btrfs_test_free_space_tree(sectorsize, nodesize);=

>> -            if (ret)
>> -                goto out;
>> -        }
>> -    }
>> -out:
>> -    btrfs_destroy_test_fs();
>> -    return ret;
>> -}
>> -
>>  static int __init init_btrfs_fs(void)
>>  {
>>      int err;
>> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests=
=2Ec
>> index 10eb249..d90c951 100644
>> --- a/fs/btrfs/tests/btrfs-tests.c
>> +++ b/fs/btrfs/tests/btrfs-tests.c
>> @@ -54,7 +54,7 @@ struct inode *btrfs_new_test_inode(void)
>>      return new_inode(test_mnt->mnt_sb);
>>  }
>>
>> -int btrfs_init_test_fs(void)
>> +static int btrfs_init_test_fs(void)
>>  {
>>      int ret;
>>
>> @@ -73,7 +73,7 @@ int btrfs_init_test_fs(void)
>>      return 0;
>>  }
>>
>> -void btrfs_destroy_test_fs(void)
>> +static void btrfs_destroy_test_fs(void)
>>  {
>>      kern_unmount(test_mnt);
>>      unregister_filesystem(&test_type);
>> @@ -220,3 +220,46 @@ void btrfs_init_dummy_trans(struct
>> btrfs_trans_handle *trans)
>>      INIT_LIST_HEAD(&trans->qgroup_ref_list);
>>      trans->type =3D __TRANS_DUMMY;
>>  }
>> +
>> +int btrfs_run_sanity_tests(void)
>> +{
>> +    int ret, i;
>> +    u32 sectorsize, nodesize;
>> +    u32 test_sectorsize[] =3D {
>> +        PAGE_SIZE,
>> +    };
>> +    ret =3D btrfs_init_test_fs();
>> +    if (ret)
>> +        return ret;
>> +    for (i =3D 0; i < ARRAY_SIZE(test_sectorsize); i++) {
>> +        sectorsize =3D test_sectorsize[i];
>> +        for (nodesize =3D sectorsize;
>> +             nodesize <=3D BTRFS_MAX_METADATA_BLOCKSIZE;
>> +             nodesize <<=3D 1) {
>> +            pr_info("BTRFS: selftest: sectorsize: %u  nodesize: %u\n"=
,
>> +                sectorsize, nodesize);
>> +            ret =3D btrfs_test_free_space_cache(sectorsize, nodesize)=
;
>> +            if (ret)
>> +                goto out;
>> +            ret =3D btrfs_test_extent_buffer_operations(sectorsize,
>> +                nodesize);
>> +            if (ret)
>> +                goto out;
>> +            ret =3D btrfs_test_extent_io(sectorsize, nodesize);
>> +            if (ret)
>> +                goto out;
>> +            ret =3D btrfs_test_inodes(sectorsize, nodesize);
>> +            if (ret)
>> +                goto out;
>> +            ret =3D btrfs_test_qgroups(sectorsize, nodesize);
>> +            if (ret)
>> +                goto out;
>> +            ret =3D btrfs_test_free_space_tree(sectorsize, nodesize);=

>> +            if (ret)
>> +                goto out;
>> +        }
>> +    }
>> +out:
>> +    btrfs_destroy_test_fs();
>> +    return ret;
>> +}
>> diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests=
=2Eh
>> index 66fb6b70..e7d364f 100644
>> --- a/fs/btrfs/tests/btrfs-tests.h
>> +++ b/fs/btrfs/tests/btrfs-tests.h
>> @@ -20,20 +20,19 @@
>>  #define __BTRFS_TESTS
>>
>>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> +int btrfs_run_sanity_tests(void);
>>
>>  #define test_msg(fmt, ...) pr_info("BTRFS: selftest: " fmt,
>> ##__VA_ARGS__)
>>
>>  struct btrfs_root;
>>  struct btrfs_trans_handle;
>>
>> -int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize);
>>  int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize)=
;
>> +int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize);
>=20
> Anything special for the line move?
> Otherwise it looks good for me.

No.  It's probably leftover from an earlier revision.  It's not necessary=
=2E

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--VCVVWJWtpJQeQXsnDLSV1slkwrAmfQ58x--

--44BjaoiUpISQQxqO4bAnLP45h6COoR3wU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXcI8+AAoJEB57S2MheeWyNuUP/2+ZX9tTTZrgMeNcZERHeqTK
HI8Q+HvwNOHgcXF+fQkC/ch9z3mSwDEdJGS9BKkxVbzkBH2g6bIfQ0YkmJd1ZvB8
sy/vJsuLoKK85oMj4v6jjNt9ZJvhl5Gzjub5+Bfam2cDjHU3liGdAkYNJ3hikQTa
QnsSDDckLX3TENRtm1JGzx/oo+hhYfKVGk8YxWOE4v1i5fI22yXCeuHOQmUuLFP8
0i+GM3aSBVhc9h6LmbF91GjjIhC4TFzrbUO+uohf/y3YYc5svndAt2UwFvCJ7DQD
t1hrTMSwbIbc+hTT4/SqJmWfe4zxaiGX0oREW4Ec8IX377Nk1Q3otXSvktr+RHBQ
uwwoSrXtbaJRK2Xt+uQfM3AgkDAVFfNPmNPxoNpmKAjetJLLYJOXWx/XNNeHrckI
hu6U7os6wAEUs2iQ2QhiOSZL/NJeCXXDbu74FYkZWpg4br77gCiW7/9co3eBAfv7
CaGo+8TVnA5wHvDIqGk6dMQiJzH5PMM3DZMIrHhp4psq8QBWoPqyzs7PwZe8j1/W
73r5nzif4epKNbvGjxCqDKjPT6f9oc6eXjY4T5qsHKP6Uzh0XLPsW2qeM6Scpfik
c7TCMp8dCqFLmMTJDOuIoYYltwPXdGryeeGJUILEkTlR0bg4l8nhI5ARsNgnFsIQ
iZ9iBRqkIX/SgpxfdsSX
=kBWS
-----END PGP SIGNATURE-----

--44BjaoiUpISQQxqO4bAnLP45h6COoR3wU--
