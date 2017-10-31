Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54123 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752470AbdJaHgI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 03:36:08 -0400
Subject: Re: [PATCH] btrfs-progs: print-tree: Enehance uuid item print
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
References: <20171031040341.18840-1-wqu@suse.com>
 <dcdc0d78-77f9-0e5d-f14a-35d1cb954529@suse.com>
 <e55ba376-1372-d6d1-7726-8d7cb411f20e@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <115279ce-5b4a-692b-7b79-9659a68434f8@gmx.com>
Date: Tue, 31 Oct 2017 15:35:17 +0800
MIME-Version: 1.0
In-Reply-To: <e55ba376-1372-d6d1-7726-8d7cb411f20e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="79aq0tFaUU5I3CVv5IKUUaWwLnllF6ExC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--79aq0tFaUU5I3CVv5IKUUaWwLnllF6ExC
Content-Type: multipart/mixed; boundary="HJTLorEKamoPjLmknqmov1HquXlt7oCDp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <115279ce-5b4a-692b-7b79-9659a68434f8@gmx.com>
Subject: Re: [PATCH] btrfs-progs: print-tree: Enehance uuid item print
References: <20171031040341.18840-1-wqu@suse.com>
 <dcdc0d78-77f9-0e5d-f14a-35d1cb954529@suse.com>
 <e55ba376-1372-d6d1-7726-8d7cb411f20e@suse.com>
In-Reply-To: <e55ba376-1372-d6d1-7726-8d7cb411f20e@suse.com>

--HJTLorEKamoPjLmknqmov1HquXlt7oCDp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 15:29, Nikolay Borisov wrote:
>=20
>=20
> On 31.10.2017 09:15, Nikolay Borisov wrote:
>>
>>
>> On 31.10.2017 06:03, Qu Wenruo wrote:
>>> For key type BTRFS_UUID_KEY_SUBVOL or BTRFS_UUID_KEY_RECEIVED_SUBVOL =
the
>>> key objectid and key offset are just half of the UUID.
>>>
>>> However we just print the key as %llu, which is converted from little=

>>> endian, not byte order for UUID, nor the traditional 36 bytes human
>>> readable uuid format.
>>>
>>> Although true engineer can easily convert it in their brain, but to
>>> make it easier for search, output the result UUID using the 36 chars =
format.
>>>
>>> Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> Inspired by UUID related work from Misono.
>>> ---
>>>  print-tree.c | 17 ++++++++++++++---
>>>  1 file changed, 14 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/print-tree.c b/print-tree.c
>>> index 3c585e31f1fc..687f871db302 100644
>>> --- a/print-tree.c
>>> +++ b/print-tree.c
>>> @@ -803,14 +803,25 @@ void btrfs_print_key(struct btrfs_disk_key *dis=
k_key)
>>>  	}
>>>  }
>>> =20
>>> -static void print_uuid_item(struct extent_buffer *l, unsigned long o=
ffset,
>>> -			    u32 item_size)
>>> +static void print_uuid_item(struct extent_buffer *l, int slot,
>>> +			    unsigned long offset, u32 item_size)
>>>  {
>>> +	struct btrfs_key key;
>>> +	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>>> +	u8 uuid[BTRFS_UUID_SIZE];
>>> +
>>> +	/* Reassemble the uuid from key.objecitd and key.offset */
>>> +	btrfs_item_key_to_cpu(l, &key, slot);
>>> +	put_unaligned_le64(key.objectid, uuid);
>>> +	put_unaligned_le64(key.offset, uuid + sizeof(u64));
>>
>> I don't think this will work on a BE system. Because
>> btrfs_item_key_to_cpu take the LE representation on-disk and turns it
>> into a cpu representation which might very well be BE. And then you
>> essentially reverse it by using put_unaligned_le64 for x86 it works fi=
ne
>> due to it being a LE system.
>=20
> Ok, so looking at one of your other patches and some digging seems to
> indicate that btrfs explicitly generates LE uuids so your code is
> correct, however it's not obvoious from this patch itself. I suggest to=

> put either a comment above the put_unaligned or a statement in the
> commit message that uuids are always generated in little-endian format

Or just skip the key endian converting.

Since it's byte order to byte order, just memcpy() disk key, with proper
comment seems cleaner.

BTW UUID doesn't get affected by endian. Because UUID is not a u128
value, but just 16 bytes, like checksum.
In csum case, we just use memcpy() and write_extent_buffer() without
doing any converting.

Thanks,
Qu

>=20
>>
>>
>>> +	uuid_unparse(uuid, uuid_str);
>>> +
>>>  	if (item_size & (sizeof(u64) - 1)) {
>>>  		printf("btrfs: uuid item with illegal size %lu!\n",
>>>  		       (unsigned long)item_size);
>>>  		return;
>>>  	}
>>> +	printf("\t\tuuid %s\n", uuid_str);
>>>  	while (item_size) {
>>>  		__le64 subvol_id;
>>> =20
>>> @@ -1297,7 +1308,7 @@ void btrfs_print_leaf(struct btrfs_root *root, =
struct extent_buffer *eb)
>>>  			break;
>>>  		case BTRFS_UUID_KEY_SUBVOL:
>>>  		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
>>> -			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i),
>>> +			print_uuid_item(eb, i, btrfs_item_ptr_offset(eb, i),
>>>  					btrfs_item_size_nr(eb, i));
>>>  			break;
>>>  		case BTRFS_STRING_ITEM_KEY: {
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--HJTLorEKamoPjLmknqmov1HquXlt7oCDp--

--79aq0tFaUU5I3CVv5IKUUaWwLnllF6ExC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln4J7UXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qijIwf7B4Ixy2hN3g9151ifta5Dq4Yd
5NaPoriVAvcnxUY4DXR3FP21LOKnLxgSi66YOAgtZtHo50pCEd7ZMFkr6jq2MPGj
VkGGVs0FEah1bA7VMQXr46yt4kT0uIQtsxCsR6TnWbkWhViOKq7lZZfxxn5edWDy
DOVHpvA/TYt6vOeaKNriGViDQbYx6IpWPzQAfq++cB+rFnr5Ko0jv2jsbOCO5Ezy
cvKV9h3uxUodQ+QuSGH0xnACpa6ZLPZJc4IsdnPaXZmtLSF6Cu4pk64zXN139c9x
MfKU8jwMtAAo6rk8HfkcLNQlQUUu3dUuVXXqJMueaTHZT6sGBpGwUITCg2Tc8w==
=O/QH
-----END PGP SIGNATURE-----

--79aq0tFaUU5I3CVv5IKUUaWwLnllF6ExC--
