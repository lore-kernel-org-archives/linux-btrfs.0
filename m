Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:33283 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932537AbeCSKvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 06:51:07 -0400
Subject: Re: [PATCH] btrfs-progs: print-tree: Do correct offset output for
 ROOT_ITEM
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180319102810.24356-1-wqu@suse.com>
 <d1fa813b-814c-21ff-4cc7-f6ba38399f9d@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f14d629e-4174-9fea-9440-fd7d9b8dd5d7@gmx.com>
Date: Mon, 19 Mar 2018 18:50:52 +0800
MIME-Version: 1.0
In-Reply-To: <d1fa813b-814c-21ff-4cc7-f6ba38399f9d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3RgIGdO5WuP1ajvU3Ze3mntNpH9pvb28f"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3RgIGdO5WuP1ajvU3Ze3mntNpH9pvb28f
Content-Type: multipart/mixed; boundary="u9V6N0axFd8qDxaEWkdQpSF4jHazfb8pQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <f14d629e-4174-9fea-9440-fd7d9b8dd5d7@gmx.com>
Subject: Re: [PATCH] btrfs-progs: print-tree: Do correct offset output for
 ROOT_ITEM
References: <20180319102810.24356-1-wqu@suse.com>
 <d1fa813b-814c-21ff-4cc7-f6ba38399f9d@suse.com>
In-Reply-To: <d1fa813b-814c-21ff-4cc7-f6ba38399f9d@suse.com>

--u9V6N0axFd8qDxaEWkdQpSF4jHazfb8pQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8819=E6=97=A5 18:46, Nikolay Borisov wrote:
>=20
>=20
> On 19.03.2018 12:28, Qu Wenruo wrote:
>> Commit Fixes: 8c36786c8198 ("btrfs-progs: print-tree: Print offset as =
tree objectid for ROOT_ITEM")
>> changes how we translate offset of ROOT_ITEM.
>>
>> However the fact is, even for ROOT_ITEM, we have different meaning of
>> offset.
>>
>> For tree reloc tree, it's indeed subvolume id.
>> But for other trees, it's the transid of when it's created.
>>
>> Fix it.
>>
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  print-tree.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/print-tree.c b/print-tree.c
>> index 45350fea0963..848e296c4e67 100644
>> --- a/print-tree.c
>> +++ b/print-tree.c
>> @@ -834,7 +834,16 @@ void btrfs_print_key(struct btrfs_disk_key *disk_=
key)
>>  	 */
>>  	case BTRFS_ROOT_ITEM_KEY:
>>  		printf(" ");
>> -		print_objectid(stdout, offset, type);
>> +		/*
>> +		 * Normally offset of ROOT_ITEM should presents the generation
>> +		 * when this root is created.
>> +		 * However if this is tree reloc tree, offset is the subvolume
>> +		 * id of its source. Here we do extra check on this.
>> +		 */
>> +		if (objectid =3D=3D BTRFS_TREE_RELOC_OBJECTID)
>> +			print_objectid(stdout, offset, type);
>=20
> Do we even have to do this for the reloc tree. If the offset is just a
> numeric id tied to a subvolume then the only possible value different
> than a numerci value is FS_TREE (in case we have 5 as the source subvol=
)
> but even this is not very informative. I'd suggest just leaving it as a=

> numeric value.

What about this value?
18446744073709551607

It's data reloc tree objectid.
And it's pretty long since it's -9ULL.

At least this makes 2 objectid more readable.

Thanks,
Qu

>=20
>> +		else
>> +			printf("%lld", offset);
>>  		printf(")");
>>  		break;
>>  	default:
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--u9V6N0axFd8qDxaEWkdQpSF4jHazfb8pQ--

--3RgIGdO5WuP1ajvU3Ze3mntNpH9pvb28f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqvlg0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg/OwgAnaelK9MXK90LCUdDutIu5KDP
GosfvgFVq8JV/Bo95LXNgk1joJkxJBo82yWIZ0iYgP6kFu0Kro76q1SJ6veu/CVp
/gjvc73zLTu1K/R7Zo0Mb8InfXwnNAWU+j488hkMvmIQ3n3L0L8qIgUoz6TKzH35
ufWpsNlv7LZ4tiNCMKkvsp4u7PITREdPfvGzFZfu188pNWhPD1AeCoMsmS5EgjpL
NKVnf8cc5ByVJxUjKkXPVmCf/1fjMLgLS31zfgnbCYy6FimeZjbkdOPiBDNXGi+D
iZb9ewjGpwxXDDwifW4jC+uzRwgWgoWr9LAiH8VVZtaL3ZSqA/Evo7oSDiQiUw==
=LkMl
-----END PGP SIGNATURE-----

--3RgIGdO5WuP1ajvU3Ze3mntNpH9pvb28f--
