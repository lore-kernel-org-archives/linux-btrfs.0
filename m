Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63154 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbdJaKzB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 06:55:01 -0400
Subject: Re: [PATCH v2] btrfs-progs: print-tree: Enehance uuid item print
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171031082850.19583-1-wqu@suse.com>
 <982545f1-b8ba-a91b-5125-be1fd1cd12bd@suse.com>
 <00492e2f-a7e3-9f10-4f25-6e0c058e3345@gmx.com>
 <0b08e065-31d7-88c2-772f-c14d8dd94413@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1b4e9b7a-7b59-f9a3-1da7-6e640150beb8@gmx.com>
Date: Tue, 31 Oct 2017 18:54:47 +0800
MIME-Version: 1.0
In-Reply-To: <0b08e065-31d7-88c2-772f-c14d8dd94413@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="396vOCJ32MEJLRnwI5jWkkgth0Qj97e80"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--396vOCJ32MEJLRnwI5jWkkgth0Qj97e80
Content-Type: multipart/mixed; boundary="JraP48X8rwetIFFGHhK8NX7wSmiGx5cTm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <1b4e9b7a-7b59-f9a3-1da7-6e640150beb8@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: print-tree: Enehance uuid item print
References: <20171031082850.19583-1-wqu@suse.com>
 <982545f1-b8ba-a91b-5125-be1fd1cd12bd@suse.com>
 <00492e2f-a7e3-9f10-4f25-6e0c058e3345@gmx.com>
 <0b08e065-31d7-88c2-772f-c14d8dd94413@suse.com>
In-Reply-To: <0b08e065-31d7-88c2-772f-c14d8dd94413@suse.com>

--JraP48X8rwetIFFGHhK8NX7wSmiGx5cTm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 18:27, Nikolay Borisov wrote:
>=20
>=20
> On 31.10.2017 12:09, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 16:47, Nikolay Borisov wrote:
>>>
>>>
>>> On 31.10.2017 10:28, Qu Wenruo wrote:
>>>> For key type BTRFS_UUID_KEY_SUBVOL or BTRFS_UUID_KEY_RECEIVED_SUBVOL=
 the
>>>> key objectid and key offset is just half of the UUID.
>>>>
>>>> However we just print the key as %llu, which is converted from littl=
e
>>>> endian, not byte order for UUID, nor the traditional 36 bytes human
>>>> readable uuid format.
>>>>
>>>> Although true engineer can easily handle it by convert it in their
>>>> brain, but to make it easier for search, output the result UUID usin=
g
>>>> the 36 chars format.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>> Inspired by UUID related work from Misono-san.
>>>> v2:
>>>>   Use explicit btrfs_key_to_uuid() function to do the convert, and a=
dd
>>>>   more comment why we should do that. Suggested by Nikolay.
>>>> ---
>>>>  print-tree.c | 34 +++++++++++++++++++++++++++++++---
>>>>  1 file changed, 31 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/print-tree.c b/print-tree.c
>>>> index 3c585e31f1fc..ab6f6c392519 100644
>>>> --- a/print-tree.c
>>>> +++ b/print-tree.c
>>>> @@ -803,14 +803,42 @@ void btrfs_print_key(struct btrfs_disk_key *di=
sk_key)
>>>>  	}
>>>>  }
>>>> =20
>>>> -static void print_uuid_item(struct extent_buffer *l, unsigned long =
offset,
>>>> -			    u32 item_size)
>>>> +static void btrfs_key_to_uuid(struct btrfs_key *key, u8 *uuid)
>>>>  {
>>>> +	/*
>>>> +	 * UUID we use is in byte order, which means:
>>> "byte order" term per-se doesn't really say anything about how bytes =
are
>>> stored, we either have little endian or big endian. So this sentence
>>> needs to be more explicit "BTRFS always represents uuid in little end=
ian"
>>
>> Well, it turned out that I get confused with the term "byte order" and=

>> "network order", and in this case I mean "network order" which is also=
 BE.
>>
>> And just in case, if you're referring the UUID as u128, then it's
>> definitely big endian.
>>
>>>
>>>> +	 *          0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
>>>> +	 * UUID:0x 12 34 56-78 90-ab cd-ef 12-34 56 78 90 ab cd ef
>>>> +	 *
>>>> +	 * And we store them as is in btrfs_*disk*_key:
>>> This could be "BTRFS' on-disk format also uses little-endian so the
>>> in-memory uuid is stored on-disk without any change to endiannes"
>>
>> While I'm always confused by your mention of endian in this case.
>>
>> Here UUID is just 16 bytes, why endian is envolved? (We're not talking=

>> about true UUID)
>> Isn't endian only affecting structure over 1 byte?
>>
>> Here is just a stream of bytes, why endian is affected in UUID?
>> We didn't even trust uuid as u128 at all.
>>
>> To me, only when we access things like key->objectid/offset we cares
>> about endian. For key->type and CSUM, there is no endian at all as we
>> are just accessing bytes. (Unless we convert them into u32/u64/u128)
>=20
> I don't understand where your confusion arises from but here is how I
> understand things.
>=20
> Btrfs generates uids by invoking uuid_le_gen (which actually calls
> guid_gen). guid_gen in turn generates a 128 bit LE value, consisting of=

> 16 bytes.

Here, just 16 bytes, an array of bytes, no endian involved at all.

> Then in order to add this uuid to the uuid tree we actually
> split those 16 bytes into 2 u64 values by calling btrfs_uuid_to_key and=

> assigne them to the objectid/offset members of the btrfs key.

Only at this specially timing we need to care about endian.

Because we are converting an array to u32, which is larger than one
byte, we need to consider endian.

And what we do is, forcing the 8 bytes array to be treated as u64 native
endian. And then convert native endian u64 to LE64.

The only endian like problem I can think of here is, which
(object/offset) represents the leading half (offset +0).

> At this
> point the endiannes of each of these 2 values is important since they
> are being treated as u64.

If kernel code is changed to things like:
---
memcpy(&disk_key.objectid, uuid , 8);
memcpy(&disk_key.offset, uuid + 8, 8);
---

Maybe it's easier for both us to understand each other.

>=20
> So actually order is important and btrfs chose to work with LE values
> explicitly so what I'm asking is to document this fact explicitly in th=
e
> code handling this otherwise one has to go and dig around the code to
> figure out why you are doing an on-disk (LE)  -> host cpu(could be LE o=
r
> BE) -> LE conversion.

But since UUID is just an array of bytes, what ever the endian btrfs
choose doesn't affect the UUID at all.

Even we choose on-disk BE, it doesn't matter at all.
We only needs to get an array of bytes.

Just like what we treat the uuid in root_item, just
memcpy()/write_extent_buffer(), no one really cares about endian at all,
since it's just an array of bytes, not affected at all.


So here my point is, there is no endian for BTRFS uuid.

And in fact CPU native endian is not even involved at all.
We only need to recover an array of bytes, and no matter what endian
we're using, we will get the same array of bytes, both in memory and on
disk.
Just like what we did by calling
memcpy()/write_extent_buffer()/read_extent_buffer() and without even
thinking about endian.

That's also why I want to get rid of the put_unaligned_u64() and just
put a memcpy().

Thanks,
Qu

>=20
> I hope this makes things clear
>=20
>=20
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>> +	 *
>>>> +	 *         Low bit        High bit|Low bit        High bit
>>>> +	 * LE64:0x 12 34 56-78 90-ab cd-ef|12-34 56 78 90 ab cd ef
>>>> +	 *             key.objectid       |     key.offset
>>>> +	 *
>>>> +	 * So here we just need to convert from native endian to LE to
>>>> +	 * get the byte order UUID.
>>>> +	 */
>>>> +	put_unaligned_le64(key->objectid, uuid);
>>>> +	put_unaligned_le64(key->offset, uuid + sizeof(u64));
>>>> +}
>>>> +
>>>> +static void print_uuid_item(struct extent_buffer *l, int slot,
>>>> +			    unsigned long offset, u32 item_size)
>>>> +{
>>>> +	struct btrfs_key key;
>>>> +	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>>>> +	u8 uuid[BTRFS_UUID_SIZE];
>>>> +
>>>> +	btrfs_item_key_to_cpu(l, &key, slot);
>>>> +	btrfs_key_to_uuid(&key, uuid);
>>>> +	uuid_unparse(uuid, uuid_str);
>>>>  	if (item_size & (sizeof(u64) - 1)) {
>>>>  		printf("btrfs: uuid item with illegal size %lu!\n",
>>>>  		       (unsigned long)item_size);
>>>>  		return;
>>>>  	}
>>>> +	printf("\t\tuuid %s\n", uuid_str);
>>>>  	while (item_size) {
>>>>  		__le64 subvol_id;
>>>> =20
>>>> @@ -1297,7 +1325,7 @@ void btrfs_print_leaf(struct btrfs_root *root,=
 struct extent_buffer *eb)
>>>>  			break;
>>>>  		case BTRFS_UUID_KEY_SUBVOL:
>>>>  		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
>>>> -			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i),
>>>> +			print_uuid_item(eb, i, btrfs_item_ptr_offset(eb, i),
>>>>  					btrfs_item_size_nr(eb, i));
>>>>  			break;
>>>>  		case BTRFS_STRING_ITEM_KEY: {
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--JraP48X8rwetIFFGHhK8NX7wSmiGx5cTm--

--396vOCJ32MEJLRnwI5jWkkgth0Qj97e80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln4VncXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhXugf/cTushBNe6b/Yh4WycmhHN1w+
3krGmvqcDtfA2I6wFrqJSgpSqj1chGeZt1xzGSllGovPREK6GDrZin/pptKDn7DL
FDj/jxcmkCGPGA/cplHCpi0jfHTOlz6lov8XLyX1OUH0fEQ1XoChznTrzEIXglBi
SFG7Woh4YgqEeESqze/+4lGkEOMWIIihBxi9Q5uU/9yY/aBbKvFA6qAuZgl5DkNz
A1fE/Uik0WLYI5+NygbGgH34JUCVmbNPRRA51GP4sgvdZUg7JG3s26MdMCf8UTaO
gZ4MnDeOnFuuqbEifXdTMPgUMi3VdAU83lcKLfJjj9NcB1nkkvC0Y5xjpvysNg==
=gFCE
-----END PGP SIGNATURE-----

--396vOCJ32MEJLRnwI5jWkkgth0Qj97e80--
