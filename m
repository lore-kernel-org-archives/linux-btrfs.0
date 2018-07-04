Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:42141 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933470AbeGDMBb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 08:01:31 -0400
Subject: Re: [PATCH] btrfs-progs: Don't BUG_ON() if we failed to load one
 device or one chunk
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180703134040.8108-1-wqu@suse.com>
 <20180704115823.GN3126@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4a6e9f34-d57f-61a8-6ab8-4bd07952d237@gmx.com>
Date: Wed, 4 Jul 2018 20:01:11 +0800
MIME-Version: 1.0
In-Reply-To: <20180704115823.GN3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="taw9FDjKxw0Ae2e6lpYkHiruTnroT7yGK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--taw9FDjKxw0Ae2e6lpYkHiruTnroT7yGK
Content-Type: multipart/mixed; boundary="DwZonxyAOiRdScdWSyviKZlPLXVboZGkq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <4a6e9f34-d57f-61a8-6ab8-4bd07952d237@gmx.com>
Subject: Re: [PATCH] btrfs-progs: Don't BUG_ON() if we failed to load one
 device or one chunk
References: <20180703134040.8108-1-wqu@suse.com>
 <20180704115823.GN3126@twin.jikos.cz>
In-Reply-To: <20180704115823.GN3126@twin.jikos.cz>

--DwZonxyAOiRdScdWSyviKZlPLXVboZGkq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8804=E6=97=A5 19:58, David Sterba wrote:
> On Tue, Jul 03, 2018 at 09:40:40PM +0800, Qu Wenruo wrote:
>> Don't panic for btrfs_read_chunk_tree() if one device or chunk is
>> corrupted.
>> Caller can already handle it pretty well.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D199839
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Applied, thanks.
>=20
> In case there's a fuzzed image, please send it too. There are example
> commits how to name, format and document it. Thanks.

Sorry for forgetting the image.

However, I'm puzzled by the fact that, even for some fuzzed image which
is originally designed to detect kernel misbehavior, it's still added
into btrfs-progs test cases.

Shouldn't such kernel oriented case locate some place else?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--DwZonxyAOiRdScdWSyviKZlPLXVboZGkq--

--taw9FDjKxw0Ae2e6lpYkHiruTnroT7yGK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls8twcACgkQwj2R86El
/qj40QgArN2ntQx+/sIM4ciJTB5cguJJfOYNobrg2aDrlU7rs68wf26HJd9KT2A7
Pf90iuYh1iRq6K5yq7K2GSRnTXvK5yZxV/rRrkNl3kOksm2BvFdS6HoeoJWYV11N
k3yVB9rqFcD7NXZ8r50butKYdeiPPXYTO8PzYu0dwYNgdn4R0205+NVr1sCA708f
+rCbR9cUf7yYmyYtoVN14Xhw8wBpJz3yASR/AmhtntFdxDbBqvX0TCpx/hqP9BWp
yqeBtU8BjUJLi8EaS3wcSKTvDDSTuhL20vtEZdHUAUmo3qys+kOY+2dYqrG/+kwa
i9cOWf+pA6XjFiZtdFM4ybd1ugFF9Q==
=b6UB
-----END PGP SIGNATURE-----

--taw9FDjKxw0Ae2e6lpYkHiruTnroT7yGK--
