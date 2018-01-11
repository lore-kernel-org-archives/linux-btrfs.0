Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59389 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750892AbeAKGFZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 01:05:25 -0500
Subject: Re: [PATCH v2 00/12] mkfs: Quota support through -R|--runtime quota
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171107084259.22367-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c3643f3f-da0b-0e4c-3bb5-35c09962f409@gmx.com>
Date: Thu, 11 Jan 2018 14:04:39 +0800
MIME-Version: 1.0
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0zkRSLHsM9CtHI9tdlVdFStJynn2d2a0N"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0zkRSLHsM9CtHI9tdlVdFStJynn2d2a0N
Content-Type: multipart/mixed; boundary="KAjTQOvkQWPB1g1pV4QnRaiqN6li0Epus";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <c3643f3f-da0b-0e4c-3bb5-35c09962f409@gmx.com>
Subject: Re: [PATCH v2 00/12] mkfs: Quota support through -R|--runtime quota
References: <20171107084259.22367-1-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>

--KAjTQOvkQWPB1g1pV4QnRaiqN6li0Epus
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Ping?

Or do I need to rebase the patchset?

Thanks,
Qu

On 2017=E5=B9=B411=E6=9C=8807=E6=97=A5 16:42, Qu Wenruo wrote:
> Can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/mkfs_qgroup
>=20
> This patchset adds quota support, which means the result fs will have
> quota enabled by default, and its accounting is already consistent, no
> manually rescan or quota enable is needed.
>=20
> The overall design of such support is:
> 1) Create needed tree
>    Both btrfs_root and real root item and tree root leaf.
>    For this, a new infrastructure, btrfs_create_tree(), is added for
>    this.
>=20
> 2) Fill quota root with basic skeleton
>    Only 3 items are really needed
>    a) global quota status item
>    b) quota info for specified qgroup
>    c) quota limit for specified qgroup
>=20
>    Currently only 0/5 qgroup is passed.
>    If we're going to support extra subvolume at mkfs time, just pass th=
e
>    subvolume id into insert_qgroup_items().
>=20
>    The content doesn't matter at all.
>=20
> 3) Repair qgroups using infrastructure from qgroup-verify
>    In fact, qgroup repair is just offline rescan.
>    Although the original qgroup-verify infrastructure is mostly noisy,
>    modify it a little to make it silent to function as offline quota
>    rescan.
>=20
> And such support is mainly designed for developers and QA guys.
>=20
> As to enable quota, before we must normally mount the fs, enable quota
> (and rescan if needed).
> This ioctl based procedure is not common, and fstests doesn't provide
> such support.
>=20
> There are several attempts to make fstests to support it, but due to
> different reasons, all these attempts failed.
>=20
> To make it easier to test all existing test cases with btrfs quota
> enabled, the current best method is to support quota at mkfs time, and
> here comes the patchset.
>=20
>=20
> BTW with -R|--runtime-features, we have several possible target to add.=

> Not limited to such ioctl based operation, but also mount option based
> ones.
> Like space-cache-tree (space_cache=3Dv2).
>=20
>=20
> Qu Wenruo (12):
>   btrfs-progs: qgroup-verify: Also repair qgroup status version
>   btrfs-progs: qgroup-verify: Use fs_info->readonly to check if we
>     should repair qgroups
>   btrfs-progs: qgroup-verify: Move qgroup classification out of
>     report_qgroups
>   btrfs-progs: qgroup-verify: Allow repair_qgroups function to do silen=
t
>     repair
>   btrfs-progs: ctree: Introduce function to create an empty tree
>   btrfs-progs: mkfs: Introduce function to insert qgroup info and limit=

>     items
>=20
>   ^^^ Above patches are not modified at all ^^^
>   vvv Modification starts below vvv
>=20
>   btrfs-progs: mkfs: Introduce function to setup quota root and rescan
>   btrfs-progs: fsfeatures: Introduce a new set of features,
>     runtime_features
>   btrfs-progs: mkfs: Introduce --runtime-features option
>   btrfs-progs: mkfs: Introduce quota runtime feature
>   btrfs-progs: test/mkfs: Add test case for -R quota option
>   btrfs-progs: test/mkfs: Add test case for --rootdir and -R quota
>=20
>  Documentation/mkfs.btrfs.asciidoc              |  23 +++
>  cmds-check.c                                   |   2 +-
>  convert/main.c                                 |   4 +-
>  ctree.c                                        | 109 ++++++++++++++
>  ctree.h                                        |   3 +
>  fsfeatures.c                                   | 131 ++++++++++++++---=

>  fsfeatures.h                                   |  10 +-
>  mkfs/main.c                                    | 194 +++++++++++++++++=
+++++---
>  qgroup-verify.c                                |  51 +++++--
>  qgroup-verify.h                                |   2 +-
>  tests/mkfs-tests/001-basic-profiles/test.sh    |  10 ++
>  tests/mkfs-tests/010-rootdir-and-quota/test.sh |  51 +++++++
>  12 files changed, 529 insertions(+), 61 deletions(-)
>  create mode 100755 tests/mkfs-tests/010-rootdir-and-quota/test.sh
>=20


--KAjTQOvkQWPB1g1pV4QnRaiqN6li0Epus--

--0zkRSLHsM9CtHI9tdlVdFStJynn2d2a0N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpW/ncXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qir5wgAmEKn7+9EDCaLqgjcW95wzJ4F
lOBFXle9hU2swuN9hO9Q5fy4ow3Sjdw1ErllJqf8cvbT8EUCcJfC1VD/pmtrHpYA
vc935B+6owqMNrIkxYsrqTio3L6xzy+Ogj7VzZ4lYo+0N35UUVGHrA3ElAuzQXOu
UztQmbT2UVfaPm0C2FWJFnUzIZcVmXE8p9kOXcB8XLYc9aaed57ldmWpyw2ZNrfK
4XDcHCT55fCG969yn8YtETl7i0vz48cgt4UobOo6E0B+XQjHloPZaknfiEcxKWc3
RZlkq3UlvIUAqkwnjpM93FFxIQYLHTl+Bml/EwwIECiYMrWlxB+/E1eSlwUypA==
=MJsy
-----END PGP SIGNATURE-----

--0zkRSLHsM9CtHI9tdlVdFStJynn2d2a0N--
