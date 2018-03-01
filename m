Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:38333 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163258AbeCAXoB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Mar 2018 18:44:01 -0500
Subject: Re: [PATCH 1/4] btrfs-progs: Limit inline extent below page size
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, peteryuchuang@gmail.com
References: <20180301024747.26192-1-wqu@suse.com>
 <20180301024747.26192-2-wqu@suse.com>
 <0e1c383c-6d5b-d592-796a-ec78eef3713c@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ddaed6f3-3956-6874-e5c0-2aa03cfcefe9@gmx.com>
Date: Fri, 2 Mar 2018 07:43:44 +0800
MIME-Version: 1.0
In-Reply-To: <0e1c383c-6d5b-d592-796a-ec78eef3713c@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YyIHhX0EEj4eyfhYCDElWbKrSiN4lvipo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YyIHhX0EEj4eyfhYCDElWbKrSiN4lvipo
Content-Type: multipart/mixed; boundary="kbeM5iqdqd5H6Zi7whhITbOrpRj42ec9n";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, peteryuchuang@gmail.com
Message-ID: <ddaed6f3-3956-6874-e5c0-2aa03cfcefe9@gmx.com>
Subject: Re: [PATCH 1/4] btrfs-progs: Limit inline extent below page size
References: <20180301024747.26192-1-wqu@suse.com>
 <20180301024747.26192-2-wqu@suse.com>
 <0e1c383c-6d5b-d592-796a-ec78eef3713c@gmail.com>
In-Reply-To: <0e1c383c-6d5b-d592-796a-ec78eef3713c@gmail.com>

--kbeM5iqdqd5H6Zi7whhITbOrpRj42ec9n
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 01:47, Nikolay Borisov wrote:
>=20
>=20
> On  1.03.2018 04:47, Qu Wenruo wrote:
>> Kernel doesn't support to drop extent inside an inlined extent.
>> And kernel tends to limit inline extent just below sectorsize, so also=

>> limit it in btrfs-progs.
>>
>> This fixes unexpected -EOPNOTSUPP error from __btrfs_drop_extents() on=

>> converted btrfs.
>>
>> Fixes: 806528b8755f ("Add Yan Zheng's ext3->btrfs conversion program")=

>> Reported-by: Peter Y. Chuang <peteryuchuang@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  ctree.h | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/ctree.h b/ctree.h
>> index 17cdac76c58c..0282deef339b 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -20,6 +20,7 @@
>>  #define __BTRFS_CTREE_H__
>> =20
>>  #include <stdbool.h>
>> +#include "internal.h"
>> =20
>>  #if BTRFS_FLAT_INCLUDES
>>  #include "list.h"
>> @@ -1195,8 +1196,14 @@ static inline u32 BTRFS_NODEPTRS_PER_BLOCK(cons=
t struct btrfs_fs_info *info)
>>  	(offsetof(struct btrfs_file_extent_item, disk_bytenr))
>>  static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_in=
fo *info)
>>  {
>> -	return BTRFS_MAX_ITEM_SIZE(info) -
>> -		BTRFS_FILE_EXTENT_INLINE_DATA_START;
>> +	/*
>> +	 * Inline extent larger than pagesize could lead to kernel unexpecte=
d
>> +	 * error when dropping extents, so we need to limit the inline exten=
t
>> +	 * size to less than sectorsize.
>> +	 */
>> +	return min_t(u32, info->sectorsize - 1,
>> +		     BTRFS_MAX_ITEM_SIZE(info) -
>> +		     BTRFS_FILE_EXTENT_INLINE_DATA_START);
>>  }
>=20
> Isn't the same change required in the kernel as well ?

Yep, kernel patch underway.

Although, kernel puts a lot of extra check into cow_file_range_inline()
instead of using the macro directly, I would like to enhance the check
in parse_options() so we could get a correct max_inline prompt.
(Currently we could pass max_inline=3D4096, and kernel prompt also shows
4096, while we can only inline 4095 bytes)

Thanks,
Qu

>=20
>> =20
>>  static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *in=
fo)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--kbeM5iqdqd5H6Zi7whhITbOrpRj42ec9n--

--YyIHhX0EEj4eyfhYCDElWbKrSiN4lvipo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqYkDAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiIgQgAnmkksp2ytZ8DcjfEDtcEFqCd
OTHNcaqNlT+UYcTOXNYpxwtrSTUvONGbo1WWuVKOL+bEPEFPJt8dDyFtYKlK8xBK
rkCDeJtFSJxMJjPqFNjEzkADSd79DOEknMZE+XCYw+TcGOLwAKNN5MeRT5T8F+JQ
+0fPN918Dh6Y4rtnCahzVt44rPo7iMIUmJepnSq5gQ2X+4aQdxuZfkF0TNIDUyDP
JRc0BIPqpN2OPyEyJZJF1cStuSrsjLIGeqVSJznKeEIZAx0m8dJGZMwzx5AT3gaW
bBNFJAaZoyPE5AsiXQPab4tIecVhElkFA1M6jIwQM16Oh8clb2aY/HT7cNyn+w==
=PIs6
-----END PGP SIGNATURE-----

--YyIHhX0EEj4eyfhYCDElWbKrSiN4lvipo--
