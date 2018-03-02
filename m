Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55181 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1426714AbeCBK6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 05:58:10 -0500
Subject: Re: [PATCH 5/5] btrfs: Show more accurate max_inline
To: Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-6-wqu@suse.com>
 <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
 <b9f5f159-156d-1346-a4fa-d1eadf3223f4@gmx.com>
 <b87b3090-0edd-1120-19c0-2adcacee6097@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <534c12eb-da90-fd25-cbc0-d35fe8290576@gmx.com>
Date: Fri, 2 Mar 2018 18:57:54 +0800
MIME-Version: 1.0
In-Reply-To: <b87b3090-0edd-1120-19c0-2adcacee6097@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Brtlxs304vVbkqj6KdlMftzsLJpZJ29i0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Brtlxs304vVbkqj6KdlMftzsLJpZJ29i0
Content-Type: multipart/mixed; boundary="9zk0iiibVKVTxlMSifmcpJEPsJArYzScF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>,
 "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <534c12eb-da90-fd25-cbc0-d35fe8290576@gmx.com>
Subject: Re: [PATCH 5/5] btrfs: Show more accurate max_inline
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-6-wqu@suse.com>
 <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
 <b9f5f159-156d-1346-a4fa-d1eadf3223f4@gmx.com>
 <b87b3090-0edd-1120-19c0-2adcacee6097@suse.com>
In-Reply-To: <b87b3090-0edd-1120-19c0-2adcacee6097@suse.com>

--9zk0iiibVKVTxlMSifmcpJEPsJArYzScF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 16:37, Nikolay Borisov wrote:
>=20
>=20
> On  2.03.2018 10:34, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 16:21, Misono, Tomohiro wrote:
>>> On 2018/03/02 14:22, Qu Wenruo wrote:
>>>> Btrfs shows max_inline option into kernel message, but for
>>>> max_inline=3D4096, btrfs won't really inline 4096 bytes inline data =
if
>>>> it's not compressed.
>>>
>>> Hello,
>>> I have a question.
>>>
>>> man mount(8) says:=20
>>>    max_inline=3Dbytes
>>>           Specify  the  maximum  amount  of space, in bytes, that can=
 be
>>>           inlined in a metadata B-tree leaf.  The value is specified =
 in
>>>           bytes,  optionally with a K, M, or G suffix, case insensiti=
ve.
>>>           In practice, this value is limited by the  root  sector  si=
ze,
>>>           with  some  space  unavailable  due to leaf headers.  For a=
 4k
>>>           sectorsize, max inline data is ~3900 bytes.
>>>
>>> So, is the size of 4k-(size of leaf header) actually the maximum valu=
e
>>> of max_inline instead of 4095 for 4k sectorsize?
>>
>> Not exactly.
>>
>> For 4K nodesize, max_inline would be 3960 bytes.
>> As leaf header and EXTENT_ITEM header takes extra bytes.
>>
>> For 16K nodesize (default), we can go up to 4095 bytes then.
>>
>> And that man page needs updated, as it should be 4K *nodesize*.
>=20
> Actually Qu what is preventing the btrfs_drop_extents of dropping inlin=
e
> extents larger than pagesize? This why you are doing this patchset, rig=
ht ?

In fact, current kernel code won't create any inline extent for real
file to cross page boundary.

So kernel itself won't try to call __btrfs_drop_extents() inside inline
extent.

(Although for symbol link, we can still create such large inline extent,
but we won't use __btrfs_drop_extent() in this case).

What I'm doing in this patchset is to fix the confusing behavior related
to inline extents.

=46rom its different behavior between plain and compressed extent to
larger than one page inlined extent used in symbol link.

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>> Thanks,
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--9zk0iiibVKVTxlMSifmcpJEPsJArYzScF--

--Brtlxs304vVbkqj6KdlMftzsLJpZJ29i0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqZLjIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgcuAf8Dv4gaDizpayjwAToY6xFm4SD
MGqCdUwIkIpT7dXAyapf3CgEdsTiBifB1oNppBYxbgGiSFAzukAIgiai1kkcrLgz
+JlC9xdE8AdW/G3Iug1ySRSHdKyjCwFznlnJZe2Px0P2cs7JC28kspPRisFKeWsc
bw1R72/IDC6FhYSLbS16Dl2nxG8qSN1C/jJTqXc8BDUFtvW+bXe7EbKhGoZacsvK
rkquRh7qbcuRHdeCeMuktt0pD039x4Dy7aqYEy19gfQR+gw1/XLAE7KU8cYqPAKX
Y1TX7deemT0ixTuGqAdzWzqhsCErVrg+p7Lw1SwW1WXgEVrP8K2JgRn2eEXY2Q==
=E3OQ
-----END PGP SIGNATURE-----

--Brtlxs304vVbkqj6KdlMftzsLJpZJ29i0--
