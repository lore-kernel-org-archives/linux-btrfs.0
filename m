Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50290 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751561AbdJaIGE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 04:06:04 -0400
Subject: Re: [PATCH] btrfs-progs: print-tree: Enehance uuid item print
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
References: <20171031040341.18840-1-wqu@suse.com>
 <dcdc0d78-77f9-0e5d-f14a-35d1cb954529@suse.com>
 <e55ba376-1372-d6d1-7726-8d7cb411f20e@suse.com>
 <115279ce-5b4a-692b-7b79-9659a68434f8@gmx.com>
 <b270f6f9-ed84-eadf-8c5b-ec813869dbca@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3fe3028d-a9de-2533-284e-dbd56b3facac@gmx.com>
Date: Tue, 31 Oct 2017 16:05:14 +0800
MIME-Version: 1.0
In-Reply-To: <b270f6f9-ed84-eadf-8c5b-ec813869dbca@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WRHE824hG44R8pag1sqLoX86etId8MkWa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WRHE824hG44R8pag1sqLoX86etId8MkWa
Content-Type: multipart/mixed; boundary="sgEL1MWWKbpn3al3cQILeArw8aQd1V7PM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <3fe3028d-a9de-2533-284e-dbd56b3facac@gmx.com>
Subject: Re: [PATCH] btrfs-progs: print-tree: Enehance uuid item print
References: <20171031040341.18840-1-wqu@suse.com>
 <dcdc0d78-77f9-0e5d-f14a-35d1cb954529@suse.com>
 <e55ba376-1372-d6d1-7726-8d7cb411f20e@suse.com>
 <115279ce-5b4a-692b-7b79-9659a68434f8@gmx.com>
 <b270f6f9-ed84-eadf-8c5b-ec813869dbca@suse.com>
In-Reply-To: <b270f6f9-ed84-eadf-8c5b-ec813869dbca@suse.com>

--sgEL1MWWKbpn3al3cQILeArw8aQd1V7PM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 15:41, Nikolay Borisov wrote:
>=20
>=20
> On 31.10.2017 09:35, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 15:29, Nikolay Borisov wrote:
>>>
>>>
>>> On 31.10.2017 09:15, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 31.10.2017 06:03, Qu Wenruo wrote:
>>>>> For key type BTRFS_UUID_KEY_SUBVOL or BTRFS_UUID_KEY_RECEIVED_SUBVO=
L the
>>>>> key objectid and key offset are just half of the UUID.
>>>>>
>>>>> However we just print the key as %llu, which is converted from litt=
le
>>>>> endian, not byte order for UUID, nor the traditional 36 bytes human=

>>>>> readable uuid format.
>>>>>
>>>>> Although true engineer can easily convert it in their brain, but to=

>>>>> make it easier for search, output the result UUID using the 36 char=
s format.
>>>>>
>>>>> Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>> ---
>>>>> Inspired by UUID related work from Misono.
>>>>> ---
>>>>>  print-tree.c | 17 ++++++++++++++---
>>>>>  1 file changed, 14 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/print-tree.c b/print-tree.c
>>>>> index 3c585e31f1fc..687f871db302 100644
>>>>> --- a/print-tree.c
>>>>> +++ b/print-tree.c
>>>>> @@ -803,14 +803,25 @@ void btrfs_print_key(struct btrfs_disk_key *d=
isk_key)
>>>>>  	}
>>>>>  }
>>>>> =20
>>>>> -static void print_uuid_item(struct extent_buffer *l, unsigned long=
 offset,
>>>>> -			    u32 item_size)
>>>>> +static void print_uuid_item(struct extent_buffer *l, int slot,
>>>>> +			    unsigned long offset, u32 item_size)
>>>>>  {
>>>>> +	struct btrfs_key key;
>>>>> +	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>>>>> +	u8 uuid[BTRFS_UUID_SIZE];
>>>>> +
>>>>> +	/* Reassemble the uuid from key.objecitd and key.offset */
>>>>> +	btrfs_item_key_to_cpu(l, &key, slot);
>>>>> +	put_unaligned_le64(key.objectid, uuid);
>>>>> +	put_unaligned_le64(key.offset, uuid + sizeof(u64));
>>>>
>>>> I don't think this will work on a BE system. Because
>>>> btrfs_item_key_to_cpu take the LE representation on-disk and turns i=
t
>>>> into a cpu representation which might very well be BE. And then you
>>>> essentially reverse it by using put_unaligned_le64 for x86 it works =
fine
>>>> due to it being a LE system.
>>>
>>> Ok, so looking at one of your other patches and some digging seems to=

>>> indicate that btrfs explicitly generates LE uuids so your code is
>>> correct, however it's not obvoious from this patch itself. I suggest =
to
>>> put either a comment above the put_unaligned or a statement in the
>>> commit message that uuids are always generated in little-endian forma=
t
>>
>> Or just skip the key endian converting.
>>
>> Since it's byte order to byte order, just memcpy() disk key, with prop=
er
>> comment seems cleaner.
>>
>> BTW UUID doesn't get affected by endian. Because UUID is not a u128
>> value, but just 16 bytes, like checksum.
>> In csum case, we just use memcpy() and write_extent_buffer() without
>> doing any converting.
>=20
> It does get affected, for more info you can check out commit
> f9727a17db9b ("uuid: rename uuid types").

Indeed, true UUID is not u8[16], but u32 + u16 + u16 + u16 + u48, so
it's affected by endian.

(Well, things in practice sometimes get different from its
original/formal design)

Anyway, I'll extract the key to uuid convert to btrfs_key_to_uuid(), and
add comment in that function so we don't need to bother this tricky part
any longer.

Thanks for the review,
Qu

> It seems after that little
> endian types really refer to guid as per the commit message and the the=

> "one true UUID" is actually BE. Btrfs apparently chose to use little
> endian since the on-disk format uses that. Given this, I do think that
> an explicit statement that btrfs' uuids are LE is necessary.
>=20
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>>
>>>>
>>>>> +	uuid_unparse(uuid, uuid_str);
>>>>> +
>>>>>  	if (item_size & (sizeof(u64) - 1)) {
>>>>>  		printf("btrfs: uuid item with illegal size %lu!\n",
>>>>>  		       (unsigned long)item_size);
>>>>>  		return;
>>>>>  	}
>>>>> +	printf("\t\tuuid %s\n", uuid_str);
>>>>>  	while (item_size) {
>>>>>  		__le64 subvol_id;
>>>>> =20
>>>>> @@ -1297,7 +1308,7 @@ void btrfs_print_leaf(struct btrfs_root *root=
, struct extent_buffer *eb)
>>>>>  			break;
>>>>>  		case BTRFS_UUID_KEY_SUBVOL:
>>>>>  		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
>>>>> -			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i),
>>>>> +			print_uuid_item(eb, i, btrfs_item_ptr_offset(eb, i),
>>>>>  					btrfs_item_size_nr(eb, i));
>>>>>  			break;
>>>>>  		case BTRFS_STRING_ITEM_KEY: {
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>


--sgEL1MWWKbpn3al3cQILeArw8aQd1V7PM--

--WRHE824hG44R8pag1sqLoX86etId8MkWa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln4LroXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgdfgf+NTrXEjsUvpYCOi8ht6VyDRtj
q7WtrXxU2xknpjWwfZU4VAE+lAhIS4QqcCzsgCy5D/uaU9BTtMwpK2xOhBzGonAY
m247ySetp7LO6Ydj49QgbugfmDW1Mq0aHWWagD2BG5rVenyOSWUs/uEXzwYiXDeE
TH8hYoKNtnkiD2nScwWWQvPxvPQJKgmfv3MpFH7CcLPRCho5GLH/RpMN+61JIedR
ttHhmXlBGm5r1rWnrsTEuEACdhu/AMEm7qAwKCZVG/ZzUtJLnFlYerRz92ws/aUN
YMq6Z+lUVIbBwt58K6QFirpuHifKV3X+oOiyav49R7ynzRk3qJ2Kt1PV5TOnqg==
=GLuZ
-----END PGP SIGNATURE-----

--WRHE824hG44R8pag1sqLoX86etId8MkWa--
