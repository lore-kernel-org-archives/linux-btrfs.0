Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45149 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeCPVVJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 17:21:09 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B1BA8AF0C
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 21:21:07 +0000 (UTC)
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180316183627.15476-1-jeffm@suse.com>
 <20180316201206.GG16736@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <edfe8017-1ec1-cee6-d08b-3899c52fa463@suse.com>
Date: Fri, 16 Mar 2018 17:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <20180316201206.GG16736@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QuFQO9bmLHsusPjZJZmoQ0hCrlrsWeDRX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QuFQO9bmLHsusPjZJZmoQ0hCrlrsWeDRX
Content-Type: multipart/mixed; boundary="iTiJ17U52ny95MzMry5Juk6EJ90OJ6UKn";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <edfe8017-1ec1-cee6-d08b-3899c52fa463@suse.com>
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
References: <20180316183627.15476-1-jeffm@suse.com>
 <20180316201206.GG16736@twin.jikos.cz>
In-Reply-To: <20180316201206.GG16736@twin.jikos.cz>

--iTiJ17U52ny95MzMry5Juk6EJ90OJ6UKn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/16/18 4:12 PM, David Sterba wrote:
> On Fri, Mar 16, 2018 at 02:36:27PM -0400, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> While running btrfs/011, I hit the following lockdep splat.
>>
>> This is the important bit:
>>    pcpu_alloc+0x1ac/0x5e0
>>    __percpu_counter_init+0x4e/0xb0
>>    btrfs_init_fs_root+0x99/0x1c0 [btrfs]
>>    btrfs_get_fs_root.part.54+0x5b/0x150 [btrfs]
>>    resolve_indirect_refs+0x130/0x830 [btrfs]
>>    find_parent_nodes+0x69e/0xff0 [btrfs]
>>    btrfs_find_all_roots_safe+0xa0/0x110 [btrfs]
>>    btrfs_find_all_roots+0x50/0x70 [btrfs]
>>    btrfs_qgroup_prepare_account_extents+0x53/0x90 [btrfs]
>>    btrfs_commit_transaction+0x3ce/0x9b0 [btrfs]
>>
>> The percpu_counter_init call in btrfs_alloc_subvolume_writers
>> uses GFP_KERNEL, which we can't do during transaction commit.
>>
>> This switches it to GFP_NOFS.
>=20
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/disk-io.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 21f34ad0d411..eb6bb3169a9e 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1108,7 +1108,7 @@ static struct btrfs_subvolume_writers *btrfs_all=
oc_subvolume_writers(void)
>>  	if (!writers)
>>  		return ERR_PTR(-ENOMEM);
>> =20
>> -	ret =3D percpu_counter_init(&writers->counter, 0, GFP_KERNEL);
>> +	ret =3D percpu_counter_init(&writers->counter, 0, GFP_NOFS);
>=20
> A line above the diff context is another allocation that does GFP_NOFS,=

> so one of the gfp flags were wrong.

This one was wrong.  It was initially implicitly GFP_KERNEL until Tejun
added the gfp_t argument and used GFP_KERNEL for most of the sites.
Since that was effectively a no-op, it was the right thing for him to do
without asking every subsystem maintainer their preference.

> Looks like there's another instance where percpu allocates with
> GFP_KERNEL: create_space_info that can be called from the path that
> allocates chunks, so this also looks like a NOFS candidate.

That's probably for the same reason.

> And in the same function, there's another indirect and hidden GFP_KERNE=
L
> allocation from kobject_init_and_add. So in this case we can't fix all
> the gfp problems at the call site and will have to use the scoped
> approach eventually.

Yep.  That's not a huge barrier, though.  We can push the kobject_add
into a workqueue pretty easily.

> I haven't found any instance of such lockdep reports in my logs (over a=

> long period), so it's quite unlikely to end up in the recursive
> allocation.
>=20
> Patch added to next, thanks.=20

When hunting to see if this had already been fixed, I did find two
reports.  One from Qu from April of last year and another from Mike
Galbraith in 2016.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--iTiJ17U52ny95MzMry5Juk6EJ90OJ6UKn--

--QuFQO9bmLHsusPjZJZmoQ0hCrlrsWeDRX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqsNUEPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyn30P/22xCrkgXuX38naHDb36ohxWzfHFfWMJl40I
7b5AOOn/GoOyykNV6oLKbXMoHhhpnzQytWx7j0vmUhflY5fClm3h42dCMSm5I358
YncxU7VLz5jbYQytwiWYxA9YB/armjfh8kOi1s9Az8a+2iMeozvDrGh40ck8/0m6
KJNsMONl1QRhUh2lDsOVwb0t7ib0QhEKC3bjTJxKltSA7sQWxN3OZipslUO98+2i
UIw4KbYPRrJ84Vh7rXxCRpygJGgLqCRWysIOk1cvy144Lx7PrjV/JgESg6HHh981
ZpaoiCwmD9cDU/H8XJPZlLk3rkAmuqE/dJ2Ugv2nklqQAdfo4Et/IKzDp/DSXIu+
bnLy1mzXKvHlQGVi+pxm8Gc3JgjtLtwuqR5WvUr5kSjHRT5UWlMVJSpvl8wvG6f0
WlCbk+HzyBGkNUHjdQDfWyw4xVmVj2D6LzE4lrsdiPNmEs36LgfOjp7K2NrMWay3
Q3GL+onhxkRDCdwsXXHmxzr/5yDOYc0Chirsspx8dumbRNehmcQ3dDpy8cBv9Mxv
x/qzuGj9sKYMGXA3xWGjb/ROgH6I49MzA4wdIh8DXCVbRIlMf4/MClbRj1+Kh+Zr
0AAHRYrD3Ls9Bcsl0Fqexe6pjs0bykTLRxl5W2hN1ilM0YILqN+4/QNHaGtdEFwA
2d/P8Kge
=2tGH
-----END PGP SIGNATURE-----

--QuFQO9bmLHsusPjZJZmoQ0hCrlrsWeDRX--
