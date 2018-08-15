Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:33255 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbeHOROu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 13:14:50 -0400
Subject: Re: [PATCH v5] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
To: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
 <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>
 <20180815130605.GO24025@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <71fcde19-f61c-7618-17f6-da3b77a59cf2@gmx.com>
Date: Wed, 15 Aug 2018 22:22:13 +0800
MIME-Version: 1.0
In-Reply-To: <20180815130605.GO24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="u7f4b3lkevvJ130uoTpqOKE7kWkicESTq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--u7f4b3lkevvJ130uoTpqOKE7kWkicESTq
Content-Type: multipart/mixed; boundary="rG2H7TPhguv2MvDSpb1LMzTJFC4q0aJbm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <71fcde19-f61c-7618-17f6-da3b77a59cf2@gmx.com>
Subject: Re: [PATCH v5] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
 <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>
 <20180815130605.GO24025@twin.jikos.cz>
In-Reply-To: <20180815130605.GO24025@twin.jikos.cz>

--rG2H7TPhguv2MvDSpb1LMzTJFC4q0aJbm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/15 =E4=B8=8B=E5=8D=889:06, David Sterba wrote:
> On Thu, Aug 09, 2018 at 04:05:36PM +0900, Misono Tomohiro wrote:
>> When qgroup is on, subvolume deletion does not remove qgroup items
>> of the subvolume (qgroup info, limit, relation) from quota tree and
>> they need to get removed manually by "btrfs qgroup destroy".
>>
>> Since level 0 qgroup cannot be used/inherited by any other subvolume,
>> let's remove them automatically when subvolume is deleted
>> (to be precise, when the subvolume root is dropped).
>=20
> Please note that dropping the 0-level qgroup has user-visible impact
> that needs to be evaluated.

I wonder if this is the case.

Normal btrfs subvolume creation using the highest objectid available in
root tree, thus later subvolume won't take the id of the to-be-deleted
subvolume.

Further more, this auto-removal only happens when the to-be-deleted
subvolume get completely removed, thus there should be no way to access
the subvolume already before we hit the branch in this patch.

So yes, the level 0 qgroup auto-removal is bringing a user visible
change, but user can't do anything anyway, and the result should just
save some "btrfs qgroup destroy/remove" calls.

Or did I miss something?

Thanks,
Qu


> I don't see anything like that in the
> changelog.
> If there's a potential or actual breakage after this patch,
> it needs to be addressed in some way.
>=20
> This is not the first time somebody proposes to do the auto deletion.
> While I'm not against it, it still has to be done the right way.
> Anything that touches user interfaces must get extra care, and review
> bandwidth for that is unfortunatelly extra low. I can't give you an ETA=

> or merge target for this patch.
>=20


--rG2H7TPhguv2MvDSpb1LMzTJFC4q0aJbm--

--u7f4b3lkevvJ130uoTpqOKE7kWkicESTq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt0NxUACgkQwj2R86El
/qjkzwgAjUWEMsuhgwcGBk9s/m8RoDKy/0BVw5KP9XKo5KVVpwj85RT5ELijFsGx
JrPFCtmIauB4IkctvF2Z7EJUfEA6wdS7mCqJ3NSsf+CYnAqWcxdu+Iw1w2K8qp/W
y2Y3w35qEisxHqUnCka6CC8ma5FUZpGwtyBJp75qcHHwzIvpXQ0hVxUsY7uMVgsE
6KEIndEfLhBHvWkuXmqjdA/nQ8KmRASIrB7VWQxkXS2rO/k2IKz69sh8+t9Ibf5S
CkYhaJleljGJz966x1FNdxgaGL1sGTBd9JBsmRxV193G1mABGWZ7MswLu7qG9Ayb
JehdfbDq9zziv0naZI2s/xaPFoOsEw==
=VVeD
-----END PGP SIGNATURE-----

--u7f4b3lkevvJ130uoTpqOKE7kWkicESTq--
