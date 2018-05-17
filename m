Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:33691 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751892AbeEQJGz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 05:06:55 -0400
Subject: Re: [PATCH v5 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
 <1de3700b-47ef-979a-3c72-8897601b2214@gmx.com>
 <12111e16-91f6-c6e3-338e-0192ad03adad@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <50c51c4d-a80d-aa52-9227-abbfebe89b17@gmx.com>
Date: Thu, 17 May 2018 17:06:44 +0800
MIME-Version: 1.0
In-Reply-To: <12111e16-91f6-c6e3-338e-0192ad03adad@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4OkFZICzRMZz7IsSVBHFZAsdksB7S1pxV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4OkFZICzRMZz7IsSVBHFZAsdksB7S1pxV
Content-Type: multipart/mixed; boundary="Rt952lrPkDoc3dzmS0Lx5BWuuGBIVvxrT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <50c51c4d-a80d-aa52-9227-abbfebe89b17@gmx.com>
Subject: Re: [PATCH v5 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
 <1de3700b-47ef-979a-3c72-8897601b2214@gmx.com>
 <12111e16-91f6-c6e3-338e-0192ad03adad@jp.fujitsu.com>
In-Reply-To: <12111e16-91f6-c6e3-338e-0192ad03adad@jp.fujitsu.com>

--Rt952lrPkDoc3dzmS0Lx5BWuuGBIVvxrT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8817=E6=97=A5 16:25, Misono Tomohiro wrote:
> On 2018/05/17 15:56, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B405=E6=9C=8816=E6=97=A5 13:49, Tomohiro Misono wrote:
>>> [based on current misc-next]
>>>
>>> changelog:
>>> v4 -> v5
>>>   - Update error handling of 1st/2nd patch. See each log for details
>>>   - Fix misspelling
>>> v3 -> v4
>>>   - call btrfs_next_leaf() after btrfs_search_slot() when the slot
>>>     position exceeds the number of items
>>>   - rebased to current misc-next
>>> v2 -> v3
>>>   - fix kbuild test bot warning
>>> v1 -> v2
>>>   - completely reimplement 1st/2nd ioctl to have user friendly api
>>>   - various cleanup, remove unnecessary goto
>>> =3D=3D=3D
>>>
>>> This adds three new unprivileged ioctls:
>>>
>>> 1st patch:
>>>   ioctl which returns subvolume information of ROOT_ITEM and ROOT_BAC=
KREF
>>> 2nd patch:
>>>   ioctl which returns subvolume information of ROOT_REF (without subv=
olume name)
>>
>> First 2 patches looks mostly fine.
>>
>>> 3rd patch:=20
>>>   user version of ino_lookup ioctl which also performs permission che=
ck.
>>
>> I'm a little concerned about this.
>>
>> What will happen in the following scenario?
>> - Environment is container whose rootfs is a subvolume of btrfs
>> - The root and normal use try to call subvolume list on their rootfs
>>
>> Will it leak the real subvolume layout to the container root/normal us=
er?
>>
>> Or it will leak anyway even without the unprivileged ioctl?
>=20
> Hi,
>=20
> I'm not sure about container, but these ioctls searches subvolume (fs t=
ree) of
> fd with witch ioctl is called (i.e. the caller needs to open the subvol=
ume first)
> and cannot search arbitrary tree. So, normal user can only get the info=
rmation
> under the rootfs's subvolume.
>=20
> On the other and, root can use TREE_SEARCH/INO_LOOKUP ioctl too which c=
an search
> arbitrary tree and get all info. So, I think root can get real layout.
>=20
> Does this answer make sense?

Makes sense now.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>> They will be used to implement user version of "subvolume list/show" =
etc.
>>> in user tools.
>>> See each commit log for more detals.
>>>
>>> The implementation of btrfs-progs can be found in the ML titled as fo=
llows:=20
>>>   [PATCH 0/11] btrfs-progs: Rework of "subvolume list/show" and relax=
 the root privileges of them
>>>
>>> Tomohiro Misono (3):
>>>   btrfs: Add unprivileged ioctl which returns subvolume information
>>>   btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
>>>   btrfs: Add unprivileged version of ino_lookup ioctl
>>>
>>>  fs/btrfs/ioctl.c           | 452 +++++++++++++++++++++++++++++++++++=
++++++++++
>>>  include/uapi/linux/btrfs.h |  84 +++++++++
>>>  2 files changed, 536 insertions(+)
>>>
>>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Rt952lrPkDoc3dzmS0Lx5BWuuGBIVvxrT--

--4OkFZICzRMZz7IsSVBHFZAsdksB7S1pxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr9RiQACgkQwj2R86El
/qh2vgf+JGPDQo1aHjRWoexCzCKb1E+lJPGZYR6PjVd6TYCYgeXDxd+oRDeRcws6
HWd+OwYk1AXgyMTrAh/7YfqFzG3topGeagy1PbhA+W6G3YVmV+qUHPvnlX7Q3XGy
VuHwQdyZrRDduwTrj0qn4Yy/RWvKtcr/WOU9H2ypH88GUREslTpEx6y+YOoRucGs
gz5CZpSlpMOPI/de2N8ngtDqv0/noMvPVyhFyHbs1f8ZDfdltIystyij2eRk2e4m
H6myE8YqRzOF6TkvZvT7ZeSNiVAlOpGwd+RDDhgwZQOcri/PAeRS3IzXTV6Q3ooT
m/tQMAj2eOEUWJF6gkyQOpzMDAC7fg==
=ZIiM
-----END PGP SIGNATURE-----

--4OkFZICzRMZz7IsSVBHFZAsdksB7S1pxV--
