Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56627 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751429AbdJ3Apv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 20:45:51 -0400
Subject: Re: [stable] btrfs name length fixes
To: Ben Hutchings <ben@decadent.org.uk>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, stable <stable@vger.kernel.org>
References: <1509297309.2721.73.camel@decadent.org.uk>
 <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
 <1509322782.2721.74.camel@decadent.org.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <837a9f6f-adb3-bf63-09db-9f3eb368fca8@gmx.com>
Date: Mon, 30 Oct 2017 08:45:42 +0800
MIME-Version: 1.0
In-Reply-To: <1509322782.2721.74.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gWKuVRlueQ3wv4eJCREWDvn88wu0EKfEJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gWKuVRlueQ3wv4eJCREWDvn88wu0EKfEJ
Content-Type: multipart/mixed; boundary="irKbGUbwahXBulQCqA4DIvLUUEGqiMt9c";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ben Hutchings <ben@decadent.org.uk>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, stable <stable@vger.kernel.org>
Message-ID: <837a9f6f-adb3-bf63-09db-9f3eb368fca8@gmx.com>
Subject: Re: [stable] btrfs name length fixes
References: <1509297309.2721.73.camel@decadent.org.uk>
 <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
 <1509322782.2721.74.camel@decadent.org.uk>
In-Reply-To: <1509322782.2721.74.camel@decadent.org.uk>

--irKbGUbwahXBulQCqA4DIvLUUEGqiMt9c
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 08:19, Ben Hutchings wrote:
> On Mon, 2017-10-30 at 07:59 +0800, Qu Wenruo wrote:
>>
>> On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 01:15, Ben Hutchings wrote:
>>> You recently made a number of fixes to validation and use of name
>>> lengths in btrfs:
>>>
>>> 286b92f43c0d btrfs: tree-log.c: Wrong printk information about namele=
n
>>> 19c6dcbfa746 btrfs: Introduce btrfs_is_name_len_valid to avoid readin=
g beyond boundary
>>> e79a33270d05 btrfs: Check name_len with boundary in verify dir_item
>>> 26a836cec2ea btrfs: Check name_len on add_inode_ref call path
>>> 8ee8c2d62d5f btrfs: Verify dir_item in replay_xattr_deletes
>>> 3c1d41844896 btrfs: Check name_len in btrfs_check_ref_name_override
>>> 59b0a7f2c7c1 btrfs: Check name_len before read in iterate_dir_item
>>> 488d7c456653 btrfs: Check name_len before reading btrfs_get_name
>>> 64c7b01446f4 btrfs: Check name_len before in btrfs_del_root_ref
>>> fbc326159a01 btrfs: Verify dir_item in iterate_object_props
>>>
>>> The bugs these are fixing probably should also be fixed on the affect=
ed
>>> stable branches.  Do you agree?  Can you provide any guidance about h=
ow
>>> far back these fixes would be needed?
>>
>> These fixes will soon be replace by centralized tree-checker facilitie=
s.
>=20
> Is that likely to be a small enough change to be reasonably backport-
> able?

It depends.

Check the thread with the subject "[PATCH v3 0/5] Enhance tree block
validation checker"

----
 fs/btrfs/Makefile       |   2 +-
 fs/btrfs/ctree.h        |   4 +
 fs/btrfs/disk-io.c      | 284 +-------------------------------
 fs/btrfs/tree-checker.c | 429
++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 437 insertions(+), 282 deletions(-)
 create mode 100644 fs/btrfs/tree-checker.c
----

Since it's centralized, most of the modification will be in
tree-checker.c, and make the impact to existing code to minimal.

However that patchset is just the skeleton of the whole thing, name_len
related code is not moved to tree-checker yet.


On the other hand, the whole name_len patchset is just an enhanced
validation checker, I'm not pretty sure if such thing should be back
ported especially when it's just a whack-a-hole solution.

Thanks,
Qu

>=20
> Ben.
>=20


--irKbGUbwahXBulQCqA4DIvLUUEGqiMt9c--

--gWKuVRlueQ3wv4eJCREWDvn88wu0EKfEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln2djYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qisdQf+MPEbngzl5Pa8kk/kdaS3Tq4J
UzXOzwmIlZUOhcF69JJFEro+ebYnTxxaJPc5MVALu9yBRjqPc86qM0wCJB8VpLRM
PfVrveYgF3BRoBT2DT4rpVGTCOLjBsrWsIjj5OTMy5UqRHZUDPAj5ZWWm0jTl/9N
DCrPm8s/uCw1WRk9OOaQfuI+/ip31MNpf2EvM0msC2+xISoxFL9MBEIe9df0BMct
4CXoNqW55he5j1b//z3ib1Oz4KZF4B01PaKdgTD3k9M1/21MmjOhh5J157Gft8Rp
bxw4z3F1NPPEW1TPnkgqsA0dJ7kGHHXMGtAWHpBrVPVUupUxxVZIzMGA3AzHow==
=eTIQ
-----END PGP SIGNATURE-----

--gWKuVRlueQ3wv4eJCREWDvn88wu0EKfEJ--
