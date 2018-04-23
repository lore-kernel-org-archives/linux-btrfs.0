Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754478AbeDWIXM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 04:23:12 -0400
Subject: Re: 4.17-rc1 FS went read-only during balance
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, linux-btrfs@vger.kernel.org
References: <20180421175548.4b07dffc@demfloro.ru>
 <5775f38a-5f17-1f6d-a6cd-289e18188a26@gmx.com>
 <20180423080745.5a9dc6be@demfloro.ru>
 <3d2443c8-0b34-2eea-3adc-2f33570f75b1@gmx.com> <20180423105543.43f13e3a@job>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d935c0e0-c2c8-a0ec-bb07-5c3879dd1be0@gmx.com>
Date: Mon, 23 Apr 2018 16:23:04 +0800
MIME-Version: 1.0
In-Reply-To: <20180423105543.43f13e3a@job>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Yu3sHuFtDKwBQ0W5oPVYU2zsKDMA4icmK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Yu3sHuFtDKwBQ0W5oPVYU2zsKDMA4icmK
Content-Type: multipart/mixed; boundary="0bDksxhP76EhYCwxD0nBE3bM94AmoRXY8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, linux-btrfs@vger.kernel.org
Message-ID: <d935c0e0-c2c8-a0ec-bb07-5c3879dd1be0@gmx.com>
Subject: Re: 4.17-rc1 FS went read-only during balance
References: <20180421175548.4b07dffc@demfloro.ru>
 <5775f38a-5f17-1f6d-a6cd-289e18188a26@gmx.com>
 <20180423080745.5a9dc6be@demfloro.ru>
 <3d2443c8-0b34-2eea-3adc-2f33570f75b1@gmx.com> <20180423105543.43f13e3a@job>
In-Reply-To: <20180423105543.43f13e3a@job>

--0bDksxhP76EhYCwxD0nBE3bM94AmoRXY8
Content-Type: multipart/mixed;
 boundary="------------462F1A4A23ED55D2B674B8E9"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------462F1A4A23ED55D2B674B8E9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8823=E6=97=A5 16:04, Dmitrii Tcvetkov wrote:
>>>>> TL;DR It seems as regression in 4.17, but I managed to find a
>>>>> workaround to make filesystem rw mountable again.
>>>>>
>>>>> Kernel built from tag v4.17-rc1
>>>>> btrfs-progs 4.16
>>>>>
>>>>> Tonight two my machines (PC (ECC RAM) and laptop(non-ECC RAM)) were=

>>>>> doing usual weekly balance with this command via cron:
>>>>> btrfs balance start -musage=3D50 -dusage=3D50 <mountpoint>
>>>>> Both machines run same kernel version.=20
>>>>>
>>>>> On PC that caused root and "data" filesystems to go readonly. Root
>>>>> is on an SSD with data single and metadata DUP, "data" filesystem
>>>>> is on 2 HDDs with RAID1 for data and metadata.
>>>>>
>>>>> On laptop only /home went ro, it's on NVMe SSD with data single and=

>>>>> metadata DUP.=20
>>>>>
>>>>> Btrfs check of PC rootfs was without any errors in both modes, I di=
d
>>>>> them once each before reboot on readonly filesystem with --force
>>>>> flag and then from live usb. Same output without any errors.
>>>>>
>>>>> After reboot kernel refused rw mount rootfs with the same error as
>>>>> during cron balance, ro mount was accepted, error during rw mount:
>>>>> BTRFS: error (device dm-17) in merge_reloc_roots:2465: errno=3D-117=
   =20
>>>  =20
>>>> 117 means EUCLEAN, which could be caused by the newly introduced
>>>> first_key and level check. =20
>>>  =20
>>>> Please apply this hotfix to fix it.
>>>> btrfs: Only check first key for committed tree blocks
>>>> (Which is included in latest pull request) =20
>>>  =20
>>>> Also, please consider enable CONFIG_BTRFS_DEBUG to provide extra
>>>> debug info. =20
>>>  =20
>>>> Thanks,
>>>> Qu =20
>>>
>>> I tried 4.17-rc2 (as the pull request was pulled) with
>>> CONFIG_BTRFS_DEBUG on LVM snapshot of laptop home partition (/dev/vdb=
)
>>> in a VM (VM kernel sees only snapshot so no UUID collisions). Dmesg
>>> attached. =20
>>
>> Thanks for the info and your previous btrfs-image.
>>
>> The image itself shows nothing wrong, so it should be runtime problem.=

>> Would you please apply these two debug patches?
>> https://patchwork.kernel.org/patch/10335133/
>> https://patchwork.kernel.org/patch/10335135/
>>
>> And the attached diff file?
>>
>> My guess is the parent node is not initialized correctly in this case.=

>>
>> Thanks,
>> Qu
>=20
> Dmesg from kernel with all three patches applied attached.
>=20
Thanks for the debug info, it really helps a lot!

It turns out that I'm just a super idiot, a typo in replace_path()
caused this, and it could not be trigger unless we enter it from
relocation recovery.

Please try the attached patch to see if it solves the problem.

Thanks,
Qu

--------------462F1A4A23ED55D2B674B8E9
Content-Type: text/x-patch;
 name="0001-btrfs-Fix-wrong-first_key-parameter-in-replace_path.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-btrfs-Fix-wrong-first_key-parameter-in-replace_path.pat";
 filename*1="ch"

=46rom 4b70eb864192ec5cf54a7e67e2957ddf0e5c0f6f Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Mon, 23 Apr 2018 16:13:55 +0800
Subject: [PATCH] btrfs: Fix wrong first_key parameter in replace_path

Commit 581c1760415c ("btrfs: Validate child tree block's level and first
key") introduced new @first_key parameter for read_tree_block(), however
caller in replace_path() is parasing wrong key to read_tree_block().

It should use parameter @first_key other than @key.

Normally it won't expose problem as @key is normally initialzied to the
same value of @first_key we expect.
However in relocation recovery case, @key can be set to (0, 0, 0), and
since no valid key in relocation tree can be (0, 0, 0), it will cause
read_tree_block() to return -EUCLEAN and interrupt relocation recovery.

Fix it by setting @first_key correctly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 00b7d3231821..b041b945a7ae 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1841,7 +1841,7 @@ int replace_path(struct btrfs_trans_handle *trans,
 		old_bytenr =3D btrfs_node_blockptr(parent, slot);
 		blocksize =3D fs_info->nodesize;
 		old_ptr_gen =3D btrfs_node_ptr_generation(parent, slot);
-		btrfs_node_key_to_cpu(parent, &key, slot);
+		btrfs_node_key_to_cpu(parent, &first_key, slot);
=20
 		if (level <=3D max_level) {
 			eb =3D path->nodes[level];
--=20
2.17.0


--------------462F1A4A23ED55D2B674B8E9--

--0bDksxhP76EhYCwxD0nBE3bM94AmoRXY8--

--Yu3sHuFtDKwBQ0W5oPVYU2zsKDMA4icmK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrdl+gACgkQwj2R86El
/qh/ywf/RMkSrgvOVR1EtlfNOtv24Qef/nIg2vzouPhuw4iMoBcGTQdEPXcsJHOX
iLpxA1OA+HyATZFSqrY+clzYAJX2hfP6bXJiDXlu1Mqa+HRyHJspFTI8i9bIfq08
cKxEr+CF4bfjjxw+r3m2gPumaJm2wxc3la9O9AT3MVFIFaTHHCcGpRMYqvSK60W2
PHFiSF+lEuzoVzM70i5+yhv12ik7JmeH25LUyVR+bAgN71lHnEw2ADlZl991guex
gijFW4WuK2O14N5wWVGJgArUmsmr2ur/Yj+DLAx202o2SfEAZC3+4CuBxRLRU9oS
UZCfsV+6aqbOUM+K9UzkuZlSQM/Pbg==
=Atz9
-----END PGP SIGNATURE-----

--Yu3sHuFtDKwBQ0W5oPVYU2zsKDMA4icmK--
