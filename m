Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58234 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754380AbcKEQ60 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 5 Nov 2016 12:58:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DECC9ACE1
        for <linux-btrfs@vger.kernel.org>; Sat,  5 Nov 2016 16:58:24 +0000 (UTC)
Subject: Re: [PATCH] btrfs: remove old tree_root dirent processing in
 btrfs_real_readdir()
References: <201611051116.1HL24jql%fengguang.wu@intel.com>
To: linux-btrfs@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <3d03bf21-8795-b175-e1d4-71c5b45f16e1@suse.com>
Date: Sat, 5 Nov 2016 12:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <201611051116.1HL24jql%fengguang.wu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2cATU1vQvPEECjUQCHOOWwpmpdspauaDS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2cATU1vQvPEECjUQCHOOWwpmpdspauaDS
Content-Type: multipart/mixed; boundary="7l5kgqJjuBgA61K1VAvmiNledi5kbeRkC";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <3d03bf21-8795-b175-e1d4-71c5b45f16e1@suse.com>
Subject: Re: [PATCH] btrfs: remove old tree_root dirent processing in
 btrfs_real_readdir()
References: <201611051116.1HL24jql%fengguang.wu@intel.com>
In-Reply-To: <201611051116.1HL24jql%fengguang.wu@intel.com>

--7l5kgqJjuBgA61K1VAvmiNledi5kbeRkC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/4/16 11:24 PM, kbuild test robot wrote:
> Hi Jeff,
>=20
> [auto build test WARNING on btrfs/next]
> [also build test WARNING on v4.9-rc3 next-20161028]
> [if your patch is applied to the wrong git tree, please drop us a note =
to help improve the system]


Whoops.  I cleaned this up in the next patch that I'm still testing.
I'll re-send.

-Jeff

> url:    https://github.com/0day-ci/linux/commits/jeffm-suse-com/btrfs-r=
emove-old-tree_root-dirent-processing-in-btrfs_real_readdir/20161105-1044=
32
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btr=
fs.git next
> config: i386-randconfig-b0-11051048 (attached as .config)
> compiler: gcc-5 (Debian 5.4.1-2) 5.4.1 20160904
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Di386=20
>=20
> All warnings (new ones prefixed by >>):
>=20
>    fs/btrfs/inode.c: In function 'btrfs_real_readdir':
>>> fs/btrfs/inode.c:5754:6: warning: unused variable 'di_len' [-Wunused-=
variable]
>      u32 di_len;
>          ^
>>> fs/btrfs/inode.c:5753:6: warning: unused variable 'di_total' [-Wunuse=
d-variable]
>      u32 di_total;
>          ^
>>> fs/btrfs/inode.c:5752:6: warning: unused variable 'di_cur' [-Wunused-=
variable]
>      u32 di_cur;
>          ^
>=20
> vim +/di_len +5754 fs/btrfs/inode.c
>=20
> 16cdcec7 Miao Xie    2011-04-22  5746  	struct list_head del_list;
> 39279cc3 Chris Mason 2007-06-12  5747  	int ret;
> 5f39d397 Chris Mason 2007-10-15  5748  	struct extent_buffer *leaf;
> 39279cc3 Chris Mason 2007-06-12  5749  	int slot;
> 39279cc3 Chris Mason 2007-06-12  5750  	unsigned char d_type;
> 39279cc3 Chris Mason 2007-06-12  5751  	int over =3D 0;
> 39279cc3 Chris Mason 2007-06-12 @5752  	u32 di_cur;
> 39279cc3 Chris Mason 2007-06-12 @5753  	u32 di_total;
> 39279cc3 Chris Mason 2007-06-12 @5754  	u32 di_len;
> 5f39d397 Chris Mason 2007-10-15  5755  	char tmp_name[32];
> 5f39d397 Chris Mason 2007-10-15  5756  	char *name_ptr;
> 5f39d397 Chris Mason 2007-10-15  5757  	int name_len;
>=20
> :::::: The code at line 5754 was first introduced by commit
> :::::: 39279cc3d2704cfbf9c35dcb5bdd392159ae4625 Btrfs: split up super.c=

>=20
> :::::: TO: Chris Mason <chris.mason@oracle.com>
> :::::: CC: David Woodhouse <dwmw2@hera.kernel.org>
>=20
> ---
> 0-DAY kernel test infrastructure                Open Source Technology =
Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corpo=
ration
>=20


--=20
Jeff Mahoney
SUSE Labs


--7l5kgqJjuBgA61K1VAvmiNledi5kbeRkC--

--2cATU1vQvPEECjUQCHOOWwpmpdspauaDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYHg+uAAoJEB57S2MheeWyfV4QAJegWMo+IKVje6sIFi14fuEu
KUO/VfH5MvDcbFxr4tYGHvfutvP3jB6dslIdVNMZBakEcsxEjwJ51vHgyK09yS7b
AiAA/HcjJyEGoS4qmIUPpVSqbg0HFnu7RaNZVgkGuCch7uczdVEhnmeI0ZvGaQUp
/jnxAmYEstSln2oZIl4tKPbzmQtpo7YkMyKEP/MXOfubk611Nhs/meu1zBTGccO/
Z7PVjDuA73A/qCfoya+zQx6GkOl1afqqlT5iKwPt8ms8vnR9meXogffArOTHiwOc
htIpGXjZhijNopjPN2tISn7feyhZaG8GAzl0VRyUkrRqW7/ch0jsjK08hwYeE+B7
zFq6TQhNpqJNQe0b8ESiw0KrPkoTNJTawoiLoFcKYn+fnIgNRkuTWzUEmxsRDUWa
1V2zobbulU0wkmGuytCpA27HIqzxWM4VxBIPui+QJJJFObik2AK/xpOW8VVikzh6
0i0Gsp2A5hiNs1zc7s8nZlAmzRuZHzR2vmG5ZmXL/JCwGRQD6jnBQpSd0SA3kh2D
73/wX4g2TgnzzqRGF+gyWNwGJNXop6qpeJwpuBhwZiWaTeCROnk+xdvgzCuMkOcu
CJzeCJsUvv8acJYZCy4J4DgvLT0bNaF1+XZ+6Gw/tOhhdG9LXbJF8q3WqZXYYpwI
RvGJeJNlGx+xwW6ANDHd
=7OMV
-----END PGP SIGNATURE-----

--2cATU1vQvPEECjUQCHOOWwpmpdspauaDS--
