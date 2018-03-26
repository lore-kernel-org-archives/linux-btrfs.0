Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:48439 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751124AbeCZXtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 19:49:18 -0400
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        jeffm@suse.com
References: <20171212073436.16447-1-wqu@suse.com>
 <20171212211209.GB3553@twin.jikos.cz>
 <645e99a8-67ee-b3ce-89cc-e60a481f4bc5@gmx.com>
 <20180326141008.GO6955@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <521fafd5-a927-b68d-8b6d-6c29ca5c34e5@gmx.com>
Date: Tue, 27 Mar 2018 07:49:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180326141008.GO6955@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mUSLTNq6Zxmny02TvE1YWRLmG6cbVdgA0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mUSLTNq6Zxmny02TvE1YWRLmG6cbVdgA0
Content-Type: multipart/mixed; boundary="Q7mRVYFk82B7iU7ZvT4rdJPggkFjyrwlE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 jeffm@suse.com
Message-ID: <521fafd5-a927-b68d-8b6d-6c29ca5c34e5@gmx.com>
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
References: <20171212073436.16447-1-wqu@suse.com>
 <20171212211209.GB3553@twin.jikos.cz>
 <645e99a8-67ee-b3ce-89cc-e60a481f4bc5@gmx.com>
 <20180326141008.GO6955@twin.jikos.cz>
In-Reply-To: <20180326141008.GO6955@twin.jikos.cz>

--Q7mRVYFk82B7iU7ZvT4rdJPggkFjyrwlE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8826=E6=97=A5 22:10, David Sterba wrote:
> On Wed, Dec 13, 2017 at 08:55:21AM +0800, Qu Wenruo wrote:
>> On 2017=E5=B9=B412=E6=9C=8813=E6=97=A5 05:12, David Sterba wrote:
>>> On Tue, Dec 12, 2017 at 03:34:22PM +0800, Qu Wenruo wrote:
>>>> The patch is consist of 2 main parts:
>>>> 1) Type based qgroup reservation
>>>>    The original patchset is sent several months ago.
>>>>    Nothing is modified at all, just rebased. And not conflict at all=
=2E
>>>>
>>>>    It's from patch 1 to patch 6.
>>>>
>>>> 2) Split meta qgroup reservation into per-trans and prealloc sub typ=
es
>>>>    The real work to address metadata underflow.
>>>>    Due to the over-reserve problem, this part is still in RFC state.=

>>>>    But the framework should mostly be fine, only needs extra fine-tu=
ning
>>>>    to get more accurate qgroup rsv to avoid too early limit.
>>>>
>>>>    It's from patch 7 to 14.
>>>
>>> I'm going to add the whole patchset to next, the first part has been
>>> there for some time and no test failures were reported. I optimistica=
lly
>>> expect that the second part will also be fine.
>>
>> The type based reservation is completely fine, since it doesn't
>> introduce anything new, just a preparation for the incoming meta rewor=
k.
>>
>> However I prefer not to push the whole patchset to upstream until
>> over-reserve behavior is solved.
>> Since it breaks quite some test cases with small limit.
>=20
> Merging plan for this patchset from last week was to postpone until
> 4.18 due to lack of final testing here. I've tried to run this with
> quotas enabled an fstests that led to warnings in the power failure
> simulation tests.

Which test case?

>=20
> As there's going to be one more rc, this gives us one more week to
> decide if its' ok-ish to merge this patch and fix the fallouts during
> the normal cycle.
>=20
> Given that this patchset has been in for-next for a long time, I'd do
> the merge now and focus on testing for that patchset as the rest of
> devel patches looks good.
>=20
> Please let me know if you have objections.

I'm completely fine with the decision.

Thanks,
Qu

>=20


--Q7mRVYFk82B7iU7ZvT4rdJPggkFjyrwlE--

--mUSLTNq6Zxmny02TvE1YWRLmG6cbVdgA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq5hu8ACgkQwj2R86El
/qhKzwf+J3tPOTP3W2YeQPn7WjVxmV0+tQehjdUEo9EzOVlaKDuDnHo8P1qN7zAp
/hCYJenwZLHZurI2waUyVxwSsUif1gnhfgLcHmNmKc46tF+kAgIQxfkXf3KUOeXg
W0lLMDJD+6Ybm2hT6lQwehcOdc4V0jOYKm8L1TyFUv+lwbslVF0QkM8WZXGgLj/R
Qjs6IkVXRsm+Mm99O512xi5l3zvlrE3KcBH5lUhvDTBdR3nqh4CoyAwSovSaU7Pr
l/3R5CuBklpkr2JPf/oXnPkgMnr/YcT+PJOZ0lTxd8Z1GoY/O4yQ0uOCpt17tdDn
/kfnmlyPGgP4J47gf9GWo8iGAawjog==
=1p5z
-----END PGP SIGNATURE-----

--mUSLTNq6Zxmny02TvE1YWRLmG6cbVdgA0--
