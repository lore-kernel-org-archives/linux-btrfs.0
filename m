Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:47247 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbeG3GgZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 02:36:25 -0400
Subject: Re: [PATCH v2 00/12] mkfs: Quota support through -R|--runtime quota
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20171107084259.22367-1-wqu@suse.com>
 <c3643f3f-da0b-0e4c-3bb5-35c09962f409@gmx.com>
 <ef21c72b-c0ca-ee15-e245-5598401817ea@gmx.com>
Message-ID: <10cc122a-9bee-fd49-f030-ca5ad65bb330@gmx.com>
Date: Mon, 30 Jul 2018 13:03:00 +0800
MIME-Version: 1.0
In-Reply-To: <ef21c72b-c0ca-ee15-e245-5598401817ea@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uC3Z2GgMjoUjMO8iscTY3EqupB7jy0HIW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uC3Z2GgMjoUjMO8iscTY3EqupB7jy0HIW
Content-Type: multipart/mixed; boundary="y5Xd2EOKN4YgI751zgJbLJDvF0OD7s3nr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <10cc122a-9bee-fd49-f030-ca5ad65bb330@gmx.com>
Subject: Re: [PATCH v2 00/12] mkfs: Quota support through -R|--runtime quota
References: <20171107084259.22367-1-wqu@suse.com>
 <c3643f3f-da0b-0e4c-3bb5-35c09962f409@gmx.com>
 <ef21c72b-c0ca-ee15-e245-5598401817ea@gmx.com>
In-Reply-To: <ef21c72b-c0ca-ee15-e245-5598401817ea@gmx.com>

--y5Xd2EOKN4YgI751zgJbLJDvF0OD7s3nr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Ping the 3rd time?

Or should I just rebase the patchset?

Thanks,
Qu

On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 09:17, Qu Wenruo wrote:
> Ping again.
>=20
> Since David is planning to merge qgroup patchset, this feature would
> greatly improve test coverage.
>=20
> Thanks,
> Qu
>=20
> On 2018=E5=B9=B401=E6=9C=8811=E6=97=A5 14:04, Qu Wenruo wrote:
>> Ping?
>>
>> Or do I need to rebase the patchset?
>>
>> Thanks,
>> Qu
>>
>> On 2017=E5=B9=B411=E6=9C=8807=E6=97=A5 16:42, Qu Wenruo wrote:
>>> Can be fetched from github:
>>> https://github.com/adam900710/btrfs-progs/tree/mkfs_qgroup
>>>
>>> This patchset adds quota support, which means the result fs will have=

>>> quota enabled by default, and its accounting is already consistent, n=
o
>>> manually rescan or quota enable is needed.
>>>
>>> The overall design of such support is:
>>> 1) Create needed tree
>>>    Both btrfs_root and real root item and tree root leaf.
>>>    For this, a new infrastructure, btrfs_create_tree(), is added for
>>>    this.
>>>
>>> 2) Fill quota root with basic skeleton
>>>    Only 3 items are really needed
>>>    a) global quota status item
>>>    b) quota info for specified qgroup
>>>    c) quota limit for specified qgroup
>>>
>>>    Currently only 0/5 qgroup is passed.
>>>    If we're going to support extra subvolume at mkfs time, just pass =
the
>>>    subvolume id into insert_qgroup_items().
>>>
>>>    The content doesn't matter at all.
>>>
>>> 3) Repair qgroups using infrastructure from qgroup-verify
>>>    In fact, qgroup repair is just offline rescan.
>>>    Although the original qgroup-verify infrastructure is mostly noisy=
,
>>>    modify it a little to make it silent to function as offline quota
>>>    rescan.
>>>
>>> And such support is mainly designed for developers and QA guys.
>>>
>>> As to enable quota, before we must normally mount the fs, enable quot=
a
>>> (and rescan if needed).
>>> This ioctl based procedure is not common, and fstests doesn't provide=

>>> such support.
>>>
>>> There are several attempts to make fstests to support it, but due to
>>> different reasons, all these attempts failed.
>>>
>>> To make it easier to test all existing test cases with btrfs quota
>>> enabled, the current best method is to support quota at mkfs time, an=
d
>>> here comes the patchset.
>>>
>>>
>>> BTW with -R|--runtime-features, we have several possible target to ad=
d.
>>> Not limited to such ioctl based operation, but also mount option base=
d
>>> ones.
>>> Like space-cache-tree (space_cache=3Dv2).
>>>
>>>
>>> Qu Wenruo (12):
>>>   btrfs-progs: qgroup-verify: Also repair qgroup status version
>>>   btrfs-progs: qgroup-verify: Use fs_info->readonly to check if we
>>>     should repair qgroups
>>>   btrfs-progs: qgroup-verify: Move qgroup classification out of
>>>     report_qgroups
>>>   btrfs-progs: qgroup-verify: Allow repair_qgroups function to do sil=
ent
>>>     repair
>>>   btrfs-progs: ctree: Introduce function to create an empty tree
>>>   btrfs-progs: mkfs: Introduce function to insert qgroup info and lim=
it
>>>     items
>>>
>>>   ^^^ Above patches are not modified at all ^^^
>>>   vvv Modification starts below vvv
>>>
>>>   btrfs-progs: mkfs: Introduce function to setup quota root and resca=
n
>>>   btrfs-progs: fsfeatures: Introduce a new set of features,
>>>     runtime_features
>>>   btrfs-progs: mkfs: Introduce --runtime-features option
>>>   btrfs-progs: mkfs: Introduce quota runtime feature
>>>   btrfs-progs: test/mkfs: Add test case for -R quota option
>>>   btrfs-progs: test/mkfs: Add test case for --rootdir and -R quota
>>>
>>>  Documentation/mkfs.btrfs.asciidoc              |  23 +++
>>>  cmds-check.c                                   |   2 +-
>>>  convert/main.c                                 |   4 +-
>>>  ctree.c                                        | 109 ++++++++++++++
>>>  ctree.h                                        |   3 +
>>>  fsfeatures.c                                   | 131 ++++++++++++++-=
--
>>>  fsfeatures.h                                   |  10 +-
>>>  mkfs/main.c                                    | 194 +++++++++++++++=
+++++++---
>>>  qgroup-verify.c                                |  51 +++++--
>>>  qgroup-verify.h                                |   2 +-
>>>  tests/mkfs-tests/001-basic-profiles/test.sh    |  10 ++
>>>  tests/mkfs-tests/010-rootdir-and-quota/test.sh |  51 +++++++
>>>  12 files changed, 529 insertions(+), 61 deletions(-)
>>>  create mode 100755 tests/mkfs-tests/010-rootdir-and-quota/test.sh
>>>
>>
>=20


--y5Xd2EOKN4YgI751zgJbLJDvF0OD7s3nr--

--uC3Z2GgMjoUjMO8iscTY3EqupB7jy0HIW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltenAQACgkQwj2R86El
/qjsMQgAoLvfdZ6XtkoGzSHQnZm9is3hrgTUVfvJMOu0q80iO/ZnRJeCDoQ9yyE1
n21KufDAuucwv4CZS3LcNlFsbbYkHi+dZnCirFCHpXG6UGB9yzGRqBgQJQY2OPcv
fF1LKR/ylbaXrYVanpwi4w3rH9l8njvDaBiOtWMnSnqmxu38krYHLiGCCh2ARL7M
GWlHNu1BPGcLP5RPGn6KgmnEzZrHcAT6EU/sTLxecF20bwPz3dytmno8G0CjCtQc
KYHVKGQmbNEitMzEeUprkbaU32+RDj2kngvVq9pbXsZlewQ83bIGfwUBL7Iox/qN
0aKCqNEi2ZnN+YXVyrujEnskxJqwKg==
=j7SW
-----END PGP SIGNATURE-----

--uC3Z2GgMjoUjMO8iscTY3EqupB7jy0HIW--
