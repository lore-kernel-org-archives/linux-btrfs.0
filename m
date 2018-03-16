Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34898 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751524AbeCPSyc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 14:54:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 85728AE14
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 18:54:31 +0000 (UTC)
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180316183627.15476-1-jeffm@suse.com>
 <9739e840-57e5-585f-8248-5d07b93b91ed@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <cbf6cd01-6da1-997c-181e-b29fca8a6089@suse.com>
Date: Fri, 16 Mar 2018 14:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <9739e840-57e5-585f-8248-5d07b93b91ed@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3e3Z5UvL4B8ILzjgvXN1DEFWrmZoxqW5f"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3e3Z5UvL4B8ILzjgvXN1DEFWrmZoxqW5f
Content-Type: multipart/mixed; boundary="DxByfTZbprJZzoRB7LRm41iUuT40VcnEH";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <cbf6cd01-6da1-997c-181e-b29fca8a6089@suse.com>
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
References: <20180316183627.15476-1-jeffm@suse.com>
 <9739e840-57e5-585f-8248-5d07b93b91ed@suse.com>
In-Reply-To: <9739e840-57e5-585f-8248-5d07b93b91ed@suse.com>

--DxByfTZbprJZzoRB7LRm41iUuT40VcnEH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/16/18 2:48 PM, Nikolay Borisov wrote:
>=20
>=20
> On 16.03.2018 20:36, jeffm@suse.com wrote:
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
> Given there is effort underway to actually kill GFP_NOFS and replace it=

> with the context annotation routines, shouldn't instead use those
> routines directly ?

I don't think those have landed yet.  When they do, it should obsolete
the gfp flags here in any context since we can also read roots from code
that doesn't need GFP_NOFS.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--DxByfTZbprJZzoRB7LRm41iUuT40VcnEH--

--3e3Z5UvL4B8ILzjgvXN1DEFWrmZoxqW5f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqsEuQPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyA/IP+gP1+xyZTDoHgupWC+F9kPgS5l0IOBxi6mMX
piC+n2PFgfiSZHvM5+6tK4eyif2s8jGp9qp3AELGaudNtIe9vIgvCR5e3fSlgvLR
2wTcNhwt8n9ZYH5Kna+3GjqwbyPU9eUfblKqxai47SDAdP1Ovaj1O0GDRH+nEcM9
gJqzSVE2CM8tM92bUF0pXNgYC4Hr0IKCqHqidj4zI6iU1vJN/ZQosdwuBffayp5u
kNciIE9/7YbDNLjnBARO1p+KPu50L34MOIEuSHnTRXQfajekVhSIhHGQJrxatn6i
YrZKS8EnAuegxqh9z6mMFc8ksXuPgx9HtKHY1leM9cWi83bBlOQJU+dvpr2O/9nj
juOf/f8/17eCV6UkFVKsSzq2E/tu7VS50sN7KYfbFKWyrILtSAd8wVLVIPKbCyj6
Um/8RX+mU66e6w0SZotD/hg9Hd6wZxNnBsezSGIys6kQDYs3G5xxYnKMfksv2Mz0
nRy6on93tONAu+UVZglBib9kn6s3pVMQ9u3nwc6brIJE2OPIH39xPcDkFcHu5Cqy
ptcWtxJiul3H0o0MObu3HzBYKMCR5k1Da3EVZuSeJJiQeFdcMyZWZZ+cUYTBT4J2
O4EBDEBhbbLAJ1Geuv5XIZg5wWmp7N24NrDdT9VjiadXISy6VN84TNmnHziTXSyj
0SZFu/ux
=ifSi
-----END PGP SIGNATURE-----

--3e3Z5UvL4B8ILzjgvXN1DEFWrmZoxqW5f--
