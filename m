Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62284 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdJ2X7X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 19:59:23 -0400
Subject: Re: [stable] btrfs name length fixes
To: Ben Hutchings <ben@decadent.org.uk>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, stable <stable@vger.kernel.org>
References: <1509297309.2721.73.camel@decadent.org.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
Date: Mon, 30 Oct 2017 07:59:10 +0800
MIME-Version: 1.0
In-Reply-To: <1509297309.2721.73.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vUEjJQOCv8VntnOU9GpMnC7RW7NV5oXrT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vUEjJQOCv8VntnOU9GpMnC7RW7NV5oXrT
Content-Type: multipart/mixed; boundary="VkOIOjoi6VgpOuEnuncP8MmXSrMOVaePc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ben Hutchings <ben@decadent.org.uk>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, stable <stable@vger.kernel.org>
Message-ID: <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
Subject: Re: [stable] btrfs name length fixes
References: <1509297309.2721.73.camel@decadent.org.uk>
In-Reply-To: <1509297309.2721.73.camel@decadent.org.uk>

--VkOIOjoi6VgpOuEnuncP8MmXSrMOVaePc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 01:15, Ben Hutchings wrote:
> You recently made a number of fixes to validation and use of name
> lengths in btrfs:
>=20
> 286b92f43c0d btrfs: tree-log.c: Wrong printk information about namelen
> 19c6dcbfa746 btrfs: Introduce btrfs_is_name_len_valid to avoid reading =
beyond boundary
> e79a33270d05 btrfs: Check name_len with boundary in verify dir_item
> 26a836cec2ea btrfs: Check name_len on add_inode_ref call path
> 8ee8c2d62d5f btrfs: Verify dir_item in replay_xattr_deletes
> 3c1d41844896 btrfs: Check name_len in btrfs_check_ref_name_override
> 59b0a7f2c7c1 btrfs: Check name_len before read in iterate_dir_item
> 488d7c456653 btrfs: Check name_len before reading btrfs_get_name
> 64c7b01446f4 btrfs: Check name_len before in btrfs_del_root_ref
> fbc326159a01 btrfs: Verify dir_item in iterate_object_props
>=20
> The bugs these are fixing probably should also be fixed on the affected=

> stable branches.  Do you agree?  Can you provide any guidance about how=

> far back these fixes would be needed?

These fixes will soon be replace by centralized tree-checker facilities.

Thanks,
Qu

>=20
> Ben.
>=20


--VkOIOjoi6VgpOuEnuncP8MmXSrMOVaePc--

--vUEjJQOCv8VntnOU9GpMnC7RW7NV5oXrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln2a04XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhBaQf+OVB7FntFd4CQ5rtQ/8JHWll8
O2QDsfI+LQlflL6IJquwA16IcLQS3/fPG6P4YOmeGL0NykAIpQ0IiGi27q7B40PY
zECMwxb0ku3RqRSDOdQ27qD2VHeSw4URg4FlkbkQwSBxUn0GncXG6UuFpgKi8Ift
v7enWG2ioRqJQTZBAB9xNNFKxEDQlmqxiI4oZih74d0xHnzYL7G/vrrm6SdemwT4
FLK1LVI++PO2OZPajWuoi1YS330p75ufx2i59/JNvhQ2rSEpuNiiqfzU4NEeIhs5
QFi6g5BagHt2ES5Z4DWJGZH8pekJSfIPWbz0ffOeyWVe6f7Z77is4imDQrIxSQ==
=7P/l
-----END PGP SIGNATURE-----

--vUEjJQOCv8VntnOU9GpMnC7RW7NV5oXrT--
