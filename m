Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:48921 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeELAJJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 20:09:09 -0400
Subject: Re: [PATCH] btrfs: qgroup: Search commit root for rescan to avoid
 missing extent
To: Jeff Mahoney <jeffm@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180503072052.22002-1-wqu@suse.com>
 <45b3b2f9-2133-bbb6-0806-6582c2cd64cd@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <093b2ecf-7254-3403-06b8-982a27f27051@gmx.com>
Date: Sat, 12 May 2018 08:08:57 +0800
MIME-Version: 1.0
In-Reply-To: <45b3b2f9-2133-bbb6-0806-6582c2cd64cd@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Sk1sSVfixINC5asCHBXOL9MDBi2Gwg3yb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Sk1sSVfixINC5asCHBXOL9MDBi2Gwg3yb
Content-Type: multipart/mixed; boundary="70bvlTVmH8lAJ4VfjaQh4AZ2KWgy5VxV9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jeff Mahoney <jeffm@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <093b2ecf-7254-3403-06b8-982a27f27051@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Search commit root for rescan to avoid
 missing extent
References: <20180503072052.22002-1-wqu@suse.com>
 <45b3b2f9-2133-bbb6-0806-6582c2cd64cd@suse.com>
In-Reply-To: <45b3b2f9-2133-bbb6-0806-6582c2cd64cd@suse.com>

--70bvlTVmH8lAJ4VfjaQh4AZ2KWgy5VxV9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8812=E6=97=A5 01:08, Jeff Mahoney wrote:
> On 5/3/18 3:20 AM, Qu Wenruo wrote:
>> When doing qgroup rescan using the following script (modified from
>> btrfs/017 test case), we can sometimes hit qgroup corruption.
>>
>> ------
>> umount $dev &> /dev/null
>> umount $mnt &> /dev/null
>>
>> mkfs.btrfs -f -n 64k $dev
>> mount $dev $mnt
>>
>> extent_size=3D8192
>>
>> xfs_io -f -d -c "pwrite 0 $extent_size" $mnt/foo > /dev/null
>> btrfs subvolume snapshot $mnt $mnt/snap
>>
>> xfs_io -f -c "reflink $mnt/foo" $mnt/foo-reflink > /dev/null
>> xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink > /dev/null
>> xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink2 > /dev/unll
>> btrfs quota enable $mnt
>>
>>  # -W is the new option to only wait rescan while not starting new one=

>> btrfs quota rescan -W $mnt
>> btrfs qgroup show -prce $mnt
>>
>>  # Need to patch btrfs-progs to report qgroup mismatch as error
>> btrfs check $dev || _fail
>> ------
>>
>> For fast machine, we can hit some corruption which missed accounting
>> tree blocks:
>> ------
>> qgroupid         rfer         excl     max_rfer     max_excl parent  c=
hild
>> --------         ----         ----     --------     -------- ------  -=
----
>> 0/5           8.00KiB        0.00B         none         none ---     -=
--
>> 0/257         8.00KiB        0.00B         none         none ---     -=
--
>> ------
>>
>> This is due to the fact that we're always searching commit root for
>> btrfs_find_all_roots() at qgroup_rescan_leaf(), but the leaf we get is=

>> from current transaction, not commit root.
>>
>> And if our tree blocks get modified in current transaction, we won't
>> find any owner in commit root, thus causing the corruption.
>>
>> Fix it by searching commit root for extent tree for
>> qgroup_rescan_leaf().
>>
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>
>> Please keep in mind that it is possible to hit another type of race
>> which double accounting tree blocks:
>> ------
>> qgroupid         rfer         excl     max_rfer     max_excl parent  c=
hild
>> --------         ----         ----     --------     -------- ------  -=
----
>> 0/5          136.00KiB     128.00KiB         none         none ---    =
 ---
>> 0/257        136.00KiB     128.00KiB         none         none ---    =
 ---
>> ------
>> For this type of corruption, this patch could reduce the possibility,
>> but the root cause is race between transaction commit and qgroup resca=
n,
>> which needs to be addressed in another patch.
>> ---
>>  fs/btrfs/qgroup.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 4baa4ba2d630..829e8fe5c97e 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2681,6 +2681,11 @@ static void btrfs_qgroup_rescan_worker(struct b=
trfs_work *work)
>>  	path =3D btrfs_alloc_path();
>>  	if (!path)
>>  		goto out;
>> +	/*
>> +	 * Rescan should only search for commit root, and any later differen=
ce
>> +	 * should be recorded by qgroup
>> +	 */
>> +	path->search_commit_root =3D 1;
>> =20
>>  	err =3D 0;
>>  	while (!err && !btrfs_fs_closing(fs_info)) {
>>
>=20
> If we're searching the commit root here, do we need the tree mod
> sequence number dance in qgroup_rescan_leaf anymore?

No, so I'll remove it in next version.

Thanks for pointing this out,
Qu

>=20
> -Jeff
>=20


--70bvlTVmH8lAJ4VfjaQh4AZ2KWgy5VxV9--

--Sk1sSVfixINC5asCHBXOL9MDBi2Gwg3yb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr2MJkACgkQwj2R86El
/qjSdQgAhqD89JqEhsQAMaPAQg6oAIKNvQL/HmhLciWHpxP71NJULYCalwpW1ck3
OA3y9Ad97u7uGem63aJlOfdvpsJJQAWgj6rf/srnkc5GLtd2MJdl0iNqhYBqiehf
0afIAlwaIQPg58ViOZX16SxuxBEEWx184upGFIKQdgV0LDFNPEtlv4ykrvU1g5XZ
tcMINs5pH/CY+bWnO0ucQhalmVj0ckPc5+D49uFiIe7y4kJ51D2zteEyQZyM92p7
lnNmYIf/9qA0u8hbrpoAhkhQt6yCkYJVezynnZ65tbcXdmGrleea6OBCyqLe32XA
emkC9Q9g0R137c7joTfgsTcWBIVvpg==
=5NbX
-----END PGP SIGNATURE-----

--Sk1sSVfixINC5asCHBXOL9MDBi2Gwg3yb--
