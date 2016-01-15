Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43605 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbcAOVSo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 16:18:44 -0500
Date: Fri, 15 Jan 2016 21:18:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: copy the certain type of item if min_type equals
 to max_type
Message-ID: <20160115211841.GO422@carfax.org.uk>
References: <1452891148-7738-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hXth9cGL35Nvpk4x"
In-Reply-To: <1452891148-7738-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hXth9cGL35Nvpk4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 15, 2016 at 12:52:28PM -0800, Liu Bo wrote:
> Some tools in btrfs-progs utilize ioctl 'BTRFS_IOC_TREE_SEARCH' and
> ioctl 'BTRFS_IOC_TREE_SEARCH_V2' to look up metadata btree for what
> they want, and several tools in fact only look for one certain type,
> where they set a certain value for both 'sk->min_type' and 'sk->max_type'.
> 
> For example,
> if we want to get the information of block groups, the current btrfs
> searches extent_tree and returns not only block groups's items, but also
> EXTENT_ITEM's items which could cost a large amount of user's buffer,
> and tools then needs to read the buffer and spends several loops to
> pick up what they want.
> 
> This lets the above two ioctl only return the certain type of items
> that tools wants.

   This changes the semantics of the ioctl in a subtle and
incompatible way.

   The keyspace used by btrfs trees can be viewed in two different and
semantically incompatible ways. A key is an (Ob, T, Of) tuple. The
first way of looking at this is as a one-dimensional keyspace, ordered
lexically, as Ob+T+Of. This is what btrfs uses internally, and it's
the way that the TREE_SEARCH ioctl works. A search simply returns a
linear subset of the keys between the minimum and the maximum.

   The other view of the keyspace, which is more useful in some
circumstances, is of a 3-dimensional keyspace, with the obvious
lattice-like ordering, where K1 <= K2 iff Ob1 <= Ob2 and T1 <= T2 and
Of1 <= Of2. This offers a very different interpretation of searching,
where you are carving out a rectangular block of the 3-dimensional
keyspace. This is the behaviour you're trying to impose on the search
ioctl for a specific special case of search.

   I would argue that if you want to have the second form of search
(and it's a useful one, certainly), you should implement an
alternative search ioctl, rather than trying to retrofit that
behaviour on something with very different, already well-defined
semantics.

   In other words, this change makes for an awkward and confusing
interface, and I think it shouldn't be done this way.

   Hugo.

> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ioctl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index da94138..f795423 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1911,6 +1911,10 @@ static noinline int key_in_sk(struct btrfs_key *key,
>  	struct btrfs_key test;
>  	int ret;
>  
> +	/* All we want is this type of key. */
> +	if (sk->min_type == sk->max_type && key->type != sk->min_type)
> +		return 0;
> +
>  	test.objectid = sk->min_objectid;
>  	test.type = sk->min_type;
>  	test.offset = sk->min_offset;

-- 
Hugo Mills             | "He's a nutcase, you know. There's no getting away
hugo@... carfax.org.uk | from it -- he'll end up with a knighthood"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                         Lexy, The League of Gentlemen

--hXth9cGL35Nvpk4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWmWIwAAoJEFheFHXiqx3kenQP/inMt2/jyUXNsdGTfZ55Nc6k
BhjQ7W6n1ifWFK/Kq5iXBzFML03VUKG5FACXy5Es5gyx4UuQMQKCJu9JiupdNtC8
DWnpKpoAwG38bL4jaKgyvjPwjIQqw+HlOyPH+w96KjBBWjamIWU01EHsIQZ0YrWU
fAAMENKViMzMXzuR6SwGAD6qDtNdMkD3Z9PcuV59CV1zMgHicweDDW1QmC9wd7vm
aVlB+K+tCr66FOpc3ONZCOtGgt3jR0V96he4ugr5gsPFUo73ULVeTn5R0yYJs9ro
LwIYW0RVJNXCWc6+WVLlU1Bh70mv1u5XadLIa3nbHAoxkciDAotAEw1FyAk21hrC
BJhM6jVbIOSctFbLO0xOTu8hIRtBmK2Ns8tyYIWJAnH8OVqCSTOt061x10K2g/bo
Vgpqlz6xqpTAR9vrpi1tsdN1wRzdUzatSb0VfmTLUTHsBPIS2zG7NTAiesArzuF2
sDt8zgVGSbGz2LQGonMpX1nsQEAawZBljLYh6TSTxLNci9v+yo0ZIZHrL03K+HqT
nr7MfzBYB9Z/5z8kE3XBSv3NxHQlOdlEKfy1TLldbRVPiohj6B6w3n/R9YpOEq7R
ucd17jEYJ4CLAxU9l4NgxFriJGkNTqGdgLpKX/f5AV8nMoLLITLzHKdP8OPJ0EcY
CUl5FYi05OqMG0jLRfYQ
=vVe8
-----END PGP SIGNATURE-----

--hXth9cGL35Nvpk4x--
