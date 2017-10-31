Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52481 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751658AbdJaH2P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 03:28:15 -0400
Subject: Re: [PATCH] btrfs-progs: print-tree: Enehance uuid item print
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
References: <20171031040341.18840-1-wqu@suse.com>
 <dcdc0d78-77f9-0e5d-f14a-35d1cb954529@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ef87c57c-f0f7-aad5-bea2-e000da69c667@gmx.com>
Date: Tue, 31 Oct 2017 15:27:55 +0800
MIME-Version: 1.0
In-Reply-To: <dcdc0d78-77f9-0e5d-f14a-35d1cb954529@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lvTbRLV86CvaBKNLTGxkGLvMLp3wbD6bB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lvTbRLV86CvaBKNLTGxkGLvMLp3wbD6bB
Content-Type: multipart/mixed; boundary="AfurNKoRxcdXtInG6ALPjEiO72xPgwwLr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <ef87c57c-f0f7-aad5-bea2-e000da69c667@gmx.com>
Subject: Re: [PATCH] btrfs-progs: print-tree: Enehance uuid item print
References: <20171031040341.18840-1-wqu@suse.com>
 <dcdc0d78-77f9-0e5d-f14a-35d1cb954529@suse.com>
In-Reply-To: <dcdc0d78-77f9-0e5d-f14a-35d1cb954529@suse.com>

--AfurNKoRxcdXtInG6ALPjEiO72xPgwwLr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 15:15, Nikolay Borisov wrote:
>=20
>=20
> On 31.10.2017 06:03, Qu Wenruo wrote:
>> For key type BTRFS_UUID_KEY_SUBVOL or BTRFS_UUID_KEY_RECEIVED_SUBVOL t=
he
>> key objectid and key offset are just half of the UUID.
>>
>> However we just print the key as %llu, which is converted from little
>> endian, not byte order for UUID, nor the traditional 36 bytes human
>> readable uuid format.
>>
>> Although true engineer can easily convert it in their brain, but to
>> make it easier for search, output the result UUID using the 36 chars f=
ormat.
>>
>> Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Inspired by UUID related work from Misono.
>> ---
>>  print-tree.c | 17 ++++++++++++++---
>>  1 file changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/print-tree.c b/print-tree.c
>> index 3c585e31f1fc..687f871db302 100644
>> --- a/print-tree.c
>> +++ b/print-tree.c
>> @@ -803,14 +803,25 @@ void btrfs_print_key(struct btrfs_disk_key *disk=
_key)
>>  	}
>>  }
>> =20
>> -static void print_uuid_item(struct extent_buffer *l, unsigned long of=
fset,
>> -			    u32 item_size)
>> +static void print_uuid_item(struct extent_buffer *l, int slot,
>> +			    unsigned long offset, u32 item_size)
>>  {
>> +	struct btrfs_key key;
>> +	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>> +	u8 uuid[BTRFS_UUID_SIZE];
>> +
>> +	/* Reassemble the uuid from key.objecitd and key.offset */
>> +	btrfs_item_key_to_cpu(l, &key, slot);
>> +	put_unaligned_le64(key.objectid, uuid);
>> +	put_unaligned_le64(key.offset, uuid + sizeof(u64));
>=20
> I don't think this will work on a BE system. Because
> btrfs_item_key_to_cpu take the LE representation on-disk and turns it
> into a cpu representation which might very well be BE. And then you
> essentially reverse it by using put_unaligned_le64 for x86 it works fin=
e
> due to it being a LE system.

I know this can be tricky, let's assume the following case:

UUID: 0x0123456789abcdef0123456789abcdef (byte order, no endian)
              Low bit          high bit
Key objectid: 0x0123456789abcdef (LE on-disk)

              0xefcdab8967452301 (u64)  <- CPU key.objectid

              Low bit         hight bit
key.offset:   0x123456789abcdef (LE on-disk)
              0xefcdab8967452301 (u64)  <- CPU key.offset

put_unaligned_le64 will convert CPU key.objectid/offset to LE on-disk
again, so we get
              Low bit                  high bit
              0x01    23456789abcd     ef (LE on-disk)
              uuid[0]      ...         uuid[7]

And that's what we need.

We did the LE->native and native->LE, so the result is not changed at all=
=2E
And we just need byte order, so the result is correct.

Just like what kernel did.

Thanks,
Qu
>=20
>=20
>> +	uuid_unparse(uuid, uuid_str);
>> +
>>  	if (item_size & (sizeof(u64) - 1)) {
>>  		printf("btrfs: uuid item with illegal size %lu!\n",
>>  		       (unsigned long)item_size);
>>  		return;
>>  	}
>> +	printf("\t\tuuid %s\n", uuid_str);
>>  	while (item_size) {
>>  		__le64 subvol_id;
>> =20
>> @@ -1297,7 +1308,7 @@ void btrfs_print_leaf(struct btrfs_root *root, s=
truct extent_buffer *eb)
>>  			break;
>>  		case BTRFS_UUID_KEY_SUBVOL:
>>  		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
>> -			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i),
>> +			print_uuid_item(eb, i, btrfs_item_ptr_offset(eb, i),
>>  					btrfs_item_size_nr(eb, i));
>>  			break;
>>  		case BTRFS_STRING_ITEM_KEY: {
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--AfurNKoRxcdXtInG6ALPjEiO72xPgwwLr--

--lvTbRLV86CvaBKNLTGxkGLvMLp3wbD6bB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln4JfsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj9Ggf/c2KfluYNYaTK5SYDg2nnI0LZ
pf8sA5o0YuHYBl5p6u5p88X/IySgmsfNEcz7qkrVLjfv2fs+Ms4eKMzrcMKKfLsj
D/0GCd08NRVd1/vFivWn3Rl6ZOfRSIk8LSjezGCuvKuPHSSqmOfIf59yZ+UuTlpj
iobM2Y+OaevU7GubU8akpvS/53pzPSzX/ivPUfV8zfSPRQCcr2fGt6+VSfv2l7lX
DUKGzYniP2QpRSBwJYKjOFAJp7c+D4d15W3Ku9bmx0BPDtTqwXGk72JmSnKc5CTq
zacPr7L6bgIZ/BfpjJ5Fhm2rlzCTn0IwnL/1JbCFly/XrC39lfVOGKMwboVO2A==
=MuvL
-----END PGP SIGNATURE-----

--lvTbRLV86CvaBKNLTGxkGLvMLp3wbD6bB--
