Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751101AbdFZRHv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 13:07:51 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95A79AAB6
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jun 2017 17:07:49 +0000 (UTC)
Subject: Re: [PATCH 08/13] btrfs: convert prelimary reference tracking to use
 rbtrees
To: Edmund Nadolski <enadolski@suse.com>, linux-btrfs@vger.kernel.org
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-9-enadolski@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <be7f16ca-6a91-1e3b-cc5a-6e5454c6c3cc@suse.com>
Date: Mon, 26 Jun 2017 13:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <20170620160653.19907-9-enadolski@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jFAh9ANFw7XuplU5plE0Rw68sQh3mxRR3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jFAh9ANFw7XuplU5plE0Rw68sQh3mxRR3
Content-Type: multipart/mixed; boundary="RRS0grqMkHs6mWSFCVHxnEL0SBhiW1r3j";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Edmund Nadolski <enadolski@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <be7f16ca-6a91-1e3b-cc5a-6e5454c6c3cc@suse.com>
Subject: Re: [PATCH 08/13] btrfs: convert prelimary reference tracking to use
 rbtrees
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-9-enadolski@suse.com>
In-Reply-To: <20170620160653.19907-9-enadolski@suse.com>

--RRS0grqMkHs6mWSFCVHxnEL0SBhiW1r3j
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/20/17 12:06 PM, Edmund Nadolski wrote:
> It's been known for a while that the use of multiple lists
> that are periodically merged was an algorithmic problem within
> btrfs.  There are several workloads that don't complete in any
> reasonable amount of time (e.g. btrfs/130) and others that cause
> soft lockups.
>=20
> The solution is to use a pair of rbtrees that do insertion merging
> for both indirect and direct refs, with the former converting
> refs into the latter.  The result is a btrfs/130 workload that
> used to take several hours now takes about half of that. This
> runtime still isn't acceptable and a future patch will address that
> by moving the rbtrees higher in the stack so the lookups can be
> shared across multiple calls to find_parent_nodes.
>=20
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
[...]

> @@ -504,37 +665,22 @@ static int resolve_indirect_refs(struct btrfs_fs_=
info *fs_info,
>  	return ret;
>  }
> =20
> -static inline int ref_for_same_block(struct prelim_ref *ref1,
> -				     struct prelim_ref *ref2)
> -{
> -	if (ref1->level !=3D ref2->level)
> -		return 0;
> -	if (ref1->root_id !=3D ref2->root_id)
> -		return 0;
> -	if (ref1->key_for_search.type !=3D ref2->key_for_search.type)
> -		return 0;
> -	if (ref1->key_for_search.objectid !=3D ref2->key_for_search.objectid)=

> -		return 0;
> -	if (ref1->key_for_search.offset !=3D ref2->key_for_search.offset)
> -		return 0;
> -	if (ref1->parent !=3D ref2->parent)
> -		return 0;
> -
> -	return 1;
> -}
> -
>  /*
>   * read tree blocks and add keys where required.
>   */
>  static int add_missing_keys(struct btrfs_fs_info *fs_info,
> -			    struct list_head *head)
> +			    struct preftrees *preftrees)
>  {
>  	struct prelim_ref *ref;
>  	struct extent_buffer *eb;
> +	struct rb_node *node =3D rb_first(&preftrees->indirect.root);
> +
> +	while (node) {
> +		ref =3D rb_entry(node, struct prelim_ref, rbnode);
> +		node =3D rb_next(&ref->rbnode);
> +		if (WARN(ref->parent, "BUG: direct ref found in indirect tree"))
> +			return -EINVAL;
> =20
> -	list_for_each_entry(ref, head, list) {
> -		if (ref->parent)
> -			continue;
>  		if (ref->key_for_search.type)
>  			continue;
>  		BUG_ON(!ref->wanted_disk_byte);

Hi Ed -

I missed this in earlier review, but this can't work.  We're modifying
the ref in a way that the comparator will care about -- so the node
would move in the tree.

It's not a fatal flaw and, in fact, leaves us an opening to fix a
separate locking issue.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--RRS0grqMkHs6mWSFCVHxnEL0SBhiW1r3j--

--jFAh9ANFw7XuplU5plE0Rw68sQh3mxRR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWVE/Yx57S2MheeWyAQg3uQ//YzyRV8brWAProFysemkbHJhe9YqipVn3
xSaXlYlMdDMzkoPLSYOA5Y1fODeZVwRb4XlWNZo4Zu0t8oazwIOWoR+4PHyG4aEl
CAeo2RGXcUYhHpNIibkr8hRJEto/0Kr2gjnRridCNbqUmtPGsIE1eXQYuhbhg/ms
ClGvEOJKSm/XChkB2JFtwXjnOtsZ/on8PPu4N+8dITu7xEca8HCqWZYlvxmUyLtZ
vJcHA4OW1NqLFVocoIBGJ8RYwEzB7IJj75gPNHmhTjKIukkmNXX4hL5+DEriabHM
klH4oL4/Dj2x9ls/gMY6dmkoRttJ9lxkyhBM1QBTMybORzwBhf0CY7d7OJh3q+Bz
XVEItl+te+7n+GeIvlGDe1VJMyr1c1R7hhIoEHiQqRFp+35ikWP03463Gi6mS30x
OpLwRdeB63lw+jCe3n7kuaHhu6gg3IpnvhMSrMk9qqXy+4kR7NrCVy4PuvrPnJJg
OigWhSEmadPxtP/42uCfbP9NCbrEGMQJq9qq/bcEQgxAZ8QaOj0+nCo1FmGj3hm9
41gBfr6bfM/sf9Le7KDh7CSp18QuKXcdj9m9Ss/k6jhTZs7xnGRroKZMk1TQQJrM
YRuJ4KkFfQNSHxtTZ17j64NyhkcfLkMSXXDT+t42ywoEtzlZAuzjoiJbbZh2oKMb
tIchOQeoEpg=
=0+gX
-----END PGP SIGNATURE-----

--jFAh9ANFw7XuplU5plE0Rw68sQh3mxRR3--
