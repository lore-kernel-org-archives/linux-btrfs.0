Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934771AbeCSVP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 17:15:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D3E49ACED
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 21:15:24 +0000 (UTC)
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180316183627.15476-1-jeffm@suse.com>
 <20180316201206.GG16736@twin.jikos.cz>
 <8950172e-98bc-8136-0ce3-aba1c5105c77@suse.com>
 <20180319180859.GJ6955@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <3c1b2143-2fa7-2d2a-bcde-faf141c11857@suse.com>
Date: Mon, 19 Mar 2018 17:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <20180319180859.GJ6955@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zgV8471S3Bhng3uAO3RPEEuqY6t8DiRBF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zgV8471S3Bhng3uAO3RPEEuqY6t8DiRBF
Content-Type: multipart/mixed; boundary="Ht5EvYJjJnJCzDzwvdfuLI24uQb68wpzS";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <3c1b2143-2fa7-2d2a-bcde-faf141c11857@suse.com>
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
References: <20180316183627.15476-1-jeffm@suse.com>
 <20180316201206.GG16736@twin.jikos.cz>
 <8950172e-98bc-8136-0ce3-aba1c5105c77@suse.com>
 <20180319180859.GJ6955@twin.jikos.cz>
In-Reply-To: <20180319180859.GJ6955@twin.jikos.cz>

--Ht5EvYJjJnJCzDzwvdfuLI24uQb68wpzS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/19/18 2:08 PM, David Sterba wrote:
> On Mon, Mar 19, 2018 at 01:52:05PM -0400, Jeff Mahoney wrote:
>> On 3/16/18 4:12 PM, David Sterba wrote:
>>> On Fri, Mar 16, 2018 at 02:36:27PM -0400, jeffm@suse.com wrote:
>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>
>>>> While running btrfs/011, I hit the following lockdep splat.
>>>>
>>>> This is the important bit:
>>>>    pcpu_alloc+0x1ac/0x5e0
>>>>    __percpu_counter_init+0x4e/0xb0
>>>>    btrfs_init_fs_root+0x99/0x1c0 [btrfs]
>>>>    btrfs_get_fs_root.part.54+0x5b/0x150 [btrfs]
>>>>    resolve_indirect_refs+0x130/0x830 [btrfs]
>>>>    find_parent_nodes+0x69e/0xff0 [btrfs]
>>>>    btrfs_find_all_roots_safe+0xa0/0x110 [btrfs]
>>>>    btrfs_find_all_roots+0x50/0x70 [btrfs]
>>>>    btrfs_qgroup_prepare_account_extents+0x53/0x90 [btrfs]
>>>>    btrfs_commit_transaction+0x3ce/0x9b0 [btrfs]
>>>>
>>>> The percpu_counter_init call in btrfs_alloc_subvolume_writers
>>>> uses GFP_KERNEL, which we can't do during transaction commit.
>>>>
>>>> This switches it to GFP_NOFS.
>>>
>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>>> ---
>>>>  fs/btrfs/disk-io.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 21f34ad0d411..eb6bb3169a9e 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -1108,7 +1108,7 @@ static struct btrfs_subvolume_writers *btrfs_a=
lloc_subvolume_writers(void)
>>>>  	if (!writers)
>>>>  		return ERR_PTR(-ENOMEM);
>>>> =20
>>>> -	ret =3D percpu_counter_init(&writers->counter, 0, GFP_KERNEL);
>>>> +	ret =3D percpu_counter_init(&writers->counter, 0, GFP_NOFS);
>>>
>>> A line above the diff context is another allocation that does GFP_NOF=
S,
>>> so one of the gfp flags were wrong.
>>>
>>> Looks like there's another instance where percpu allocates with
>>> GFP_KERNEL: create_space_info that can be called from the path that
>>> allocates chunks, so this also looks like a NOFS candidate.
>>
>> We can get rid of this case entirely.  Those call sites should be
>> removed since the space_infos are all allocated at mount time.
>=20
> That would be great and make a few things simpler. So this means that
> __find_space_info never fails once the space infos are properly
> initialized, right? That was my concern in do_chunk_alloc and
> btrfs_make_block_group (that's called from __btrfs_alloc_chunk).

That's a different case.  The raid levels are added when the first block
group of a particular read level is loaded up.  That can happen when the
block groups are read in initially, where it should be safe to use
GFP_KERNEL or when a chunk of a new type is allocated.  The thing is
that a chunk of a new type will only be allocated when we're converting
via balance, so we may be able to do the kobject_add for the raid level
when we start the balance rather than wait for it to create the block gro=
up.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--Ht5EvYJjJnJCzDzwvdfuLI24uQb68wpzS--

--zgV8471S3Bhng3uAO3RPEEuqY6t8DiRBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqwKGsPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWykFEP/1a0S1Sz53YG8icRCeZRRQgA442EVh2S3m0u
wdDVw85bXlNYiDdf5BFWw9uHyy0NV3Ya52LAlOrFgnrrcw/yka5klZRZjgfbDIdc
ma3dSIIT0Bd2UrQeSi6oIPWCpkpyPQfe1ac0A8M/pqQpBjEUyxVwTRnyCWOx4/76
ShiVG6g00Bsl02vhMX8/R0TWbYWq+NNQRSk+fps9gH3Xk9ybUpyM0ygucHrj49QA
1Rw7SF2zUOJjwvZCt6Wqpn6ti4IP17+0nz4tSpMieLFG8Kjxq8HtQuEgorv1N4VS
XpZbnl40bfJ44k4FkXZFumJGeiv9WQFpMdTi+Kik7F+KQeavNyyiCFo/H+uzo726
pdA005SU6vFs/yR4iUWcKpvc8xMjVAfNqDi1buiF0MVZmkiQhZ45jmOp2XlmKvg7
w1IHr1F71zE3Z4E5T8fWN4rbbjwL5jsuv1JA4KXDpJtA6qPjdgs7DB/ne2BnxrM9
E5aIuuglz5vYMhH45YJ1GH+9GeqnoeZ8RQqv9iqdE0MszUqQH3E/aJCj0tPLI5R6
EJbzeaVbchBfesat1rjV3KsVrNLgddGl83WWH7YpCVtcPzI9wJJ3EJVfHz5ajMAs
5l9eor72vcbkacF9AU+CLC2KsP1UpKLluEdSL7pNsVzZM3LXEqNI98UpI7HjEPPB
5HrTY0Wp
=2TBG
-----END PGP SIGNATURE-----

--zgV8471S3Bhng3uAO3RPEEuqY6t8DiRBF--
