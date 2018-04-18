Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60443 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbeDRBIW (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Apr 2018 21:08:22 -0400
Subject: Re: [PATCH] btrfs: delayed-inode: Remove wrong qgroup meta
 reservation calls
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180417085245.6303-1-wqu@suse.com>
 <20180417151846.GE21272@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <f24b9eb9-5774-45b5-876b-0795e773e131@suse.com>
Date: Wed, 18 Apr 2018 09:08:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180417151846.GE21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OOGmtfzux6SFE8ylE8Ah4aowYm8cQhaae"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OOGmtfzux6SFE8ylE8Ah4aowYm8cQhaae
Content-Type: multipart/mixed; boundary="cErTnvRrbX0XmQAgAEroFw57rVErcMojG";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <f24b9eb9-5774-45b5-876b-0795e773e131@suse.com>
Subject: Re: [PATCH] btrfs: delayed-inode: Remove wrong qgroup meta
 reservation calls
References: <20180417085245.6303-1-wqu@suse.com>
 <20180417151846.GE21272@twin.jikos.cz>
In-Reply-To: <20180417151846.GE21272@twin.jikos.cz>

--cErTnvRrbX0XmQAgAEroFw57rVErcMojG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8817=E6=97=A5 23:18, David Sterba wrote:
> On Tue, Apr 17, 2018 at 04:52:45PM +0800, Qu Wenruo wrote:
>> Commit 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv fo=
r
>> delayed inode and item") merged into mainline is not the updated versi=
on
>> submitted to the mail list in Dec 2017.
>>
>> Which lacks the following fixes:
>>
>> 1) Remove btrfs_qgroup_convert_reserved_meta() call in
>>    btrfs_delayed_item_release_metadata()
>> 2) Remove btrfs_qgroup_reserve_meta_prealloc() call in
>>    btrfs_delayed_inode_reserve_metadata()
>>
>> Those fixes will resolve unexpected EDQUOT problems.
>>
>> Fixes: 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv fo=
r delayed inode and item")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Added to 4.17 queue, thanks.
>=20
>> @@ -569,6 +569,12 @@ static int btrfs_delayed_item_reserve_metadata(st=
ruct btrfs_trans_handle *trans,
>>  	dst_rsv =3D &fs_info->delayed_block_rsv;
>> =20
>>  	num_bytes =3D btrfs_calc_trans_metadata_size(fs_info, 1);
>> +
>> +	/*
>> +	 * Here we migrate space rsv from transaction rsv, since have
>> +	 * already reserved space when starting a transaction.
>> +	 * So no need to reserve qgroup space here.
>> +	 */
>=20
> Please format the comments to the full line width.

Right, the already can go previous line without exceeding 80 chars.

But the "So no need to..." line is a new line so it will not take up any
space of previous line anyway.

>=20
>> @@ -647,7 +657,9 @@ static int btrfs_delayed_inode_reserve_metadata(
>>  						      "delayed_inode",
>>  						      btrfs_ino(inode),
>>  						      num_bytes, 1);
>> -		}
>> +		} else
>> +			btrfs_qgroup_free_meta_prealloc(root,
>> +							fs_info->nodesize);
>=20
> Please don't diverge from the coding style, I'm fixing such issues but,=

> you know.

For this, did you mean the bracket for else branch?

Thanks,
Qu


--cErTnvRrbX0XmQAgAEroFw57rVErcMojG--

--OOGmtfzux6SFE8ylE8Ah4aowYm8cQhaae
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrWmnoACgkQwj2R86El
/qihcwgAjPXeI7M7htLv2vyRhQQErlBDycRcWbImv47noBgXnmV5q0s/xDhaOnPh
L6zLdfNHCcyGqGAMAmwEP+AmjFINHT+p3ny38y3j1CLqBLFWzYshrYNMg4xAMGkH
B6fPZVdA0AVkZITe4RZHYTse6NztQQrd+U9Rcc9MuleRScuoCp6EAiq76KcoMoQb
lV0Q50YgKGY41ObhkL5XUc0gxQoQKd6yhTFBtoYNaBKSzGjoB0CILfNGL4VI3n1R
sIWFl7YHnS/b4JTQ/EgeEHuaOIyM/4RmQ7twbi/pL2yNZyjLL01oCkAUToR7K+P/
WuhFRlxvsJfwhxZ9QpQ2Y2BIu9rSdw==
=s4s/
-----END PGP SIGNATURE-----

--OOGmtfzux6SFE8ylE8Ah4aowYm8cQhaae--
