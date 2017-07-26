Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750882AbdGZNVM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 09:21:12 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D0AD5AC2F
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 13:21:10 +0000 (UTC)
Subject: Re: [PATCH 3/7] btrfs-progs: extent-cache: actually cache extent
 buffers
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-3-jeffm@suse.com>
 <cea9bb4c-d1f8-521e-d649-550da4892169@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <d0775d9d-cdf5-8e0b-b628-dd23ac5befd1@suse.com>
Date: Wed, 26 Jul 2017 09:21:04 -0400
MIME-Version: 1.0
In-Reply-To: <cea9bb4c-d1f8-521e-d649-550da4892169@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RqPbP6N83OTpO5rJGIWRe0xE1MNBmgx97"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RqPbP6N83OTpO5rJGIWRe0xE1MNBmgx97
Content-Type: multipart/mixed; boundary="3GDleB41hvu03PaP9xmxTCmMxxkMSulk7";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <d0775d9d-cdf5-8e0b-b628-dd23ac5befd1@suse.com>
Subject: Re: [PATCH 3/7] btrfs-progs: extent-cache: actually cache extent
 buffers
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-3-jeffm@suse.com>
 <cea9bb4c-d1f8-521e-d649-550da4892169@suse.com>
In-Reply-To: <cea9bb4c-d1f8-521e-d649-550da4892169@suse.com>

--3GDleB41hvu03PaP9xmxTCmMxxkMSulk7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/26/17 3:00 AM, Nikolay Borisov wrote:
>=20
>=20
> On 25.07.2017 23:51, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> We have the infrastructure to cache extent buffers but we don't actual=
ly
>> do the caching.  As soon as the last reference is dropped, the buffer
>> is dropped.  This patch keeps the extent buffers around until the max
>> cache size is reached (defaults to 25% of memory) and then it drops
>> the last 10% of the LRU to free up cache space for reallocation.  The
>> cache size is configurable (for use by e.g. lowmem) when the cache is
>> initialized.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

>> @@ -567,7 +580,21 @@ struct extent_buffer *btrfs_clone_extent_buffer(s=
truct extent_buffer *src)
>>  	return new;
>>  }
>> =20
>> -void free_extent_buffer(struct extent_buffer *eb)
>> +static void free_extent_buffer_final(struct extent_buffer *eb)
>> +{
>> +	struct extent_io_tree *tree =3D eb->tree;
>> +
>> +	BUG_ON(eb->refs);
>> +	BUG_ON(tree->cache_size < eb->len);
>> +	list_del_init(&eb->lru);
>> +	if (!(eb->flags & EXTENT_BUFFER_DUMMY)) {
>> +		remove_cache_extent(&tree->cache, &eb->cache_node);
>> +		tree->cache_size -=3D eb->len;
>> +	}
>> +	free(eb);
>> +}
>> +
>> +static void free_extent_buffer_internal(struct extent_buffer *eb, int=
 free_now)
>=20
> nit: free_ow -> boolean

Ack.  There should be a bunch of int -> bool conversions elsewhere too.

>> @@ -619,6 +650,21 @@ struct extent_buffer *find_first_extent_buffer(st=
ruct extent_io_tree *tree,
>>  	return eb;
>>  }
>> =20
>> +static void
>> +trim_extent_buffer_cache(struct extent_io_tree *tree)
>> +{
>> +	struct extent_buffer *eb, *tmp;
>> +	u64 count =3D 0;
>=20
> count seems to be a leftover from something, so you could remove it

Yep, that was during debugging.  Removed.

>> @@ -2521,3 +2522,14 @@ u8 rand_u8(void)
>>  void btrfs_config_init(void)
>>  {
>>  }
>> +
>> +unsigned long total_memory(void)
>=20
> perhaps rename to total_memory_bytes and return the memory size in
> bytes. Returning them in kilobytes seems rather arbitrary. That way
> you'd save the constant *1024 to turn the kbs in bytes in the callers
> (currently only in extent_io_tree_init())
>=20

Ack.

Thanks,

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--3GDleB41hvu03PaP9xmxTCmMxxkMSulk7--

--RqPbP6N83OTpO5rJGIWRe0xE1MNBmgx97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWXiXRB57S2MheeWyAQgHRQ//UYie8VY8AJgj5V2Q6Ehg6RB64nerg4tM
JGkm8kgfE7ZFL8aiAd34G94ekVp/3CyZwYwDleeYn04Bwutqu3bbwXlg3U6KRbkZ
UeAWoNwdulSsIolj8SLBL6JyP9SvLoXkRLJNvinqKGbLm+LnSTiqzMBQqowQpWP4
o8LUrlzdN2271ICR36JZXW6WGahwk8wJArM/jovMpMDIriRNsO7vS7PTffLS1iZw
vEr+kYZyxjna/u8h3Oqf7Ncz7qtpa+nKyXFP6lUVKkFwRWDsC0NdmuqV5h+Av9rP
revh9bL56gPJA76RJ8PubpHpGTVt6YW6Psg7JTx2U11EJDEJGBbAikLadR0TGDRB
X2vH6GuvQX9uy9sxr0nA/jwcoG77XVWonHLtbDre4TkEJdUOeUlOyS8rKUWLYezv
Nmb2aK+qSkpZn8zk/QZOUjshYoEi40+57ky3sz0mT5eQcm3t3yRevXx7vDMmwwEH
7wfzykR3J7stDj0w6YkZcG7Ebsb67r0vmJr46nb+O0/0CooiguiHXTvCYYhGOsHs
GEBinN0f5P/JFFyoXTfEC7Agx+n9hhf/V80jltifsnGjmwpIcRO5p3d8Uo43UEnP
Ch6XwvlvNH2Mcb6ZQxH48O54K6PVBQdbZpA7gxW4sOlDAzF8KFGhqofBNVSTdw5o
VP6t91VbVPY=
=hDTD
-----END PGP SIGNATURE-----

--RqPbP6N83OTpO5rJGIWRe0xE1MNBmgx97--
