Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:39049 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbeCGM3p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 07:29:45 -0500
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
To: Nikolay Borisov <nborisov@suse.com>, robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a1c538b8-859d-f7bc-cc6d-e5aed271b0f6@gmx.com>
Date: Wed, 7 Mar 2018 20:29:24 +0800
MIME-Version: 1.0
In-Reply-To: <a9228371-847b-0ea9-8c5f-230fbdcc350d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TycMbUhdzViUVcdupaxDR7tZpdzpQwbJi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1520410819-32405-3-git-send-email-robbieko@synology.com>
 <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
 <2f3228e8-af87-d0aa-4f35-69e89873026b@gmx.com>
 <25bec3b50fe42a2f816f1391a438f624@synology.com>
 <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>
 <3b241323-0e2d-7428-ac91-1da3b3221c6a@suse.com>
 <e08ae323-c757-ee37-20de-767836b9104b@gmx.com>
 <a9228371-847b-0ea9-8c5f-230fbdcc350d@suse.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TycMbUhdzViUVcdupaxDR7tZpdzpQwbJi
Content-Type: multipart/mixed; boundary="TBGc34s3cnlXxmbstoc7VQKkLEzgO3119";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Message-ID: <a1c538b8-859d-f7bc-cc6d-e5aed271b0f6@gmx.com>
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
 <1520410819-32405-3-git-send-email-robbieko@synology.com>
 <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
 <2f3228e8-af87-d0aa-4f35-69e89873026b@gmx.com>
 <25bec3b50fe42a2f816f1391a438f624@synology.com>
 <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>
 <3b241323-0e2d-7428-ac91-1da3b3221c6a@suse.com>
 <e08ae323-c757-ee37-20de-767836b9104b@gmx.com>
 <a9228371-847b-0ea9-8c5f-230fbdcc350d@suse.com>
In-Reply-To: <a9228371-847b-0ea9-8c5f-230fbdcc350d@suse.com>

--TBGc34s3cnlXxmbstoc7VQKkLEzgO3119
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 20:17, Nikolay Borisov wrote:
>=20
>=20
> On  7.03.2018 14:14, Qu Wenruo wrote:
>>
>>
>=20
> <snip>
>=20
>>>>
>>>> SHARED flag is determined after extent map merge, so here we can't r=
ely
>>>> on em here.
>>>
>>> Shouldn't extent maps correspond to 1:1 disk-state. I.e. they are jus=
t
>>> the memory cache of the extent state. So if we merge them, shouldn't =
we
>>> also merge the on-disk extents as well ?
>>
>> Not 1:1.
>>
>> In memory one is merged maybe to save memory.
>>
>> But on-disk file extents has size limit.
>> For compressed one it's 128K and 128M for uncompressed one.
>=20
> Fair enough, however 4 extents, 16k each should warrant merging on-disk=

> as well, no ?

dd oflag=3Ddsync
That ensures we won't merge on-disk extents.

Thanks,
Qu

>=20
> <snip>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--TBGc34s3cnlXxmbstoc7VQKkLEzgO3119--

--TycMbUhdzViUVcdupaxDR7tZpdzpQwbJi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqf2yQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjA5wf/anwKljn1NZ2gKKEm01y+x+Ha
H7xajs4YDCuY/z19yn5/+8OkMSu6vxXBzosfTcoXp/MB//OEQNbgy2E6+/0GUDO7
axJFANgHo5cW4TX+JHoKXDyRF1ZBveXEVFFpM2870PHWbC+U8F6ZX/qbnrnr2WoA
RfEZhtiUJDY+wlgnMP+Dq+JO4FCrZhPKyTSTsUCg93gN0aa0OYywGfoJM/nRp+v1
0b4TPK+1RKjBlhGaYOk2drMn2dNMdO2oxec3vc8BszVIBabveMlPR6UsR16BUm5A
ymAWIDDYB7gqNHhl+6qxMprVsa6lXHv2FMSx8ylix12oqZh/3l3b6m9IxQLiBw==
=wtZR
-----END PGP SIGNATURE-----

--TycMbUhdzViUVcdupaxDR7tZpdzpQwbJi--
