Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40845 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753132AbdF0UJj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 16:09:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4B34AC14
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 20:09:37 +0000 (UTC)
Subject: Re: [PATCH 08/13] btrfs: convert prelimary reference tracking to use
 rbtrees
From: Jeff Mahoney <jeffm@suse.com>
To: Edmund Nadolski <enadolski@suse.com>, linux-btrfs@vger.kernel.org
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-9-enadolski@suse.com>
 <be7f16ca-6a91-1e3b-cc5a-6e5454c6c3cc@suse.com>
Message-ID: <e3778e1b-c1c1-03b9-5abe-e70cc2c19f6c@suse.com>
Date: Tue, 27 Jun 2017 16:09:34 -0400
MIME-Version: 1.0
In-Reply-To: <be7f16ca-6a91-1e3b-cc5a-6e5454c6c3cc@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6to922UbhkBStibIaL3NmcJr5vr9WsrV5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6to922UbhkBStibIaL3NmcJr5vr9WsrV5
Content-Type: multipart/mixed; boundary="l5URhHQ1LH9XuuqKcTdfKEVN0aUKt2Q14";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Edmund Nadolski <enadolski@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <e3778e1b-c1c1-03b9-5abe-e70cc2c19f6c@suse.com>
Subject: Re: [PATCH 08/13] btrfs: convert prelimary reference tracking to use
 rbtrees
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-9-enadolski@suse.com>
 <be7f16ca-6a91-1e3b-cc5a-6e5454c6c3cc@suse.com>
In-Reply-To: <be7f16ca-6a91-1e3b-cc5a-6e5454c6c3cc@suse.com>

--l5URhHQ1LH9XuuqKcTdfKEVN0aUKt2Q14
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/26/17 1:07 PM, Jeff Mahoney wrote:
> On 6/20/17 12:06 PM, Edmund Nadolski wrote:
>> It's been known for a while that the use of multiple lists
>> that are periodically merged was an algorithmic problem within
>> btrfs.  There are several workloads that don't complete in any
>> reasonable amount of time (e.g. btrfs/130) and others that cause
>> soft lockups.
>>
>> The solution is to use a pair of rbtrees that do insertion merging
>> for both indirect and direct refs, with the former converting
>> refs into the latter.  The result is a btrfs/130 workload that
>> used to take several hours now takes about half of that. This
>> runtime still isn't acceptable and a future patch will address that
>> by moving the rbtrees higher in the stack so the lookups can be
>> shared across multiple calls to find_parent_nodes.
>>
>> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> [...]
>=20
>> @@ -504,37 +665,22 @@ static int resolve_indirect_refs(struct btrfs_fs=
_info *fs_info,
>>  	return ret;
>>  }
>> =20
>> -static inline int ref_for_same_block(struct prelim_ref *ref1,
>> -				     struct prelim_ref *ref2)
>> -{
>> -	if (ref1->level !=3D ref2->level)
>> -		return 0;
>> -	if (ref1->root_id !=3D ref2->root_id)
>> -		return 0;
>> -	if (ref1->key_for_search.type !=3D ref2->key_for_search.type)
>> -		return 0;
>> -	if (ref1->key_for_search.objectid !=3D ref2->key_for_search.objectid=
)
>> -		return 0;
>> -	if (ref1->key_for_search.offset !=3D ref2->key_for_search.offset)
>> -		return 0;
>> -	if (ref1->parent !=3D ref2->parent)
>> -		return 0;
>> -
>> -	return 1;
>> -}
>> -
>>  /*
>>   * read tree blocks and add keys where required.
>>   */
>>  static int add_missing_keys(struct btrfs_fs_info *fs_info,
>> -			    struct list_head *head)
>> +			    struct preftrees *preftrees)
>>  {
>>  	struct prelim_ref *ref;
>>  	struct extent_buffer *eb;
>> +	struct rb_node *node =3D rb_first(&preftrees->indirect.root);
>> +
>> +	while (node) {
>> +		ref =3D rb_entry(node, struct prelim_ref, rbnode);
>> +		node =3D rb_next(&ref->rbnode);
>> +		if (WARN(ref->parent, "BUG: direct ref found in indirect tree"))
>> +			return -EINVAL;
>> =20
>> -	list_for_each_entry(ref, head, list) {
>> -		if (ref->parent)
>> -			continue;
>>  		if (ref->key_for_search.type)
>>  			continue;
>>  		BUG_ON(!ref->wanted_disk_byte);
>=20
> Hi Ed -
>=20
> I missed this in earlier review, but this can't work.  We're modifying
> the ref in a way that the comparator will care about -- so the node
> would move in the tree.
>=20
> It's not a fatal flaw and, in fact, leaves us an opening to fix a
> separate locking issue.

Ed and I discussed this offline.  It turns out that this is a code bug
but not a functional bug.  Once we hit add_missing_keys, we don't do any
more inserts or searches.  We only iterate over every node and remove
each as we go, so the tree order doesn't matter.  I'll post a fix shortly=
=2E

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--l5URhHQ1LH9XuuqKcTdfKEVN0aUKt2Q14--

--6to922UbhkBStibIaL3NmcJr5vr9WsrV5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWVK7fx57S2MheeWyAQj/+Q//UNnTIe1eOygbg47dKnqL82DFePRlITuh
WSyU5Q/ugJE0IyRSy1MJtHILEn4DlIEhUWZt+WLSN+odopdjwbqh6fiXNFDSL2L/
g9jRKeqeq0IoJg2NmSxPKyL+U4H+K4cLKaj+feqQ7hjZjaNFSujL9XaYU5ExVJtE
iNOpmh7DD+fC6rdpN3byKE+4ZmgvKQjbOPxSlVELc+uGFktTUYuA0MvhEtAfPstF
Pvya5CZQvY7bwPUWfdhqvCIdnLbhDYdU8OGUr56QsGo1w45Vu9ioGaWpFBqsjrkr
2X34qh5TpA/klR/cHHbcAF+T/BuFK1lrLXLh/KD1O4PypsiNkAtV7O5awT3HMqgQ
fwNhq3HKnmvSSrDddqGgMv6A6GFbixwGYijOdjxYZeinXyDjXUusjX9u3zF67IZk
4+CzeiTFle8Fu01BPZ3h+bIwnfEIot/NZqqYy1mLvw+YLfcSwT6EacqUzMujElXN
RWhSe1tRWj87kl+WrT3BkHXFFc/J9ZfkdKYXs5kocHtLGZVZH9UloX4k+b0ZPi9m
+ZOBEbUQAdT3I7egMPYotzUesGMWGMgnMQBpf6VRA2xgQsESK6jiaoCI4+iVEe/J
6aQWsd/9YgIAdMM9G+ibxSKeM4H7GAxQ71IW72DXcLwRT04fQvLD8Dl+ij486umJ
Tlyu18OniIQ=
=3zsU
-----END PGP SIGNATURE-----

--6to922UbhkBStibIaL3NmcJr5vr9WsrV5--
