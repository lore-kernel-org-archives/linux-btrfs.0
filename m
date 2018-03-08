Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755259AbeCHOZ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:25:57 -0500
Subject: Re: [PATCH 06/20] btrfs-progs: qgroups: add pathname to show output
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-7-jeffm@suse.com>
 <bfc620df-a02e-f57a-8526-67797547db59@gmx.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <b3321d64-0ae4-cff2-d80e-de75d835dd27@suse.com>
Date: Thu, 8 Mar 2018 09:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <bfc620df-a02e-f57a-8526-67797547db59@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yxO5kEV6PfDZjAIFBo38I4bcQa896EkGA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yxO5kEV6PfDZjAIFBo38I4bcQa896EkGA
Content-Type: multipart/mixed; boundary="dpGvPzRRObvpTeFn03hGXQKHc8GhD27Gs";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <b3321d64-0ae4-cff2-d80e-de75d835dd27@suse.com>
Subject: Re: [PATCH 06/20] btrfs-progs: qgroups: add pathname to show output
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-7-jeffm@suse.com>
 <bfc620df-a02e-f57a-8526-67797547db59@gmx.com>
In-Reply-To: <bfc620df-a02e-f57a-8526-67797547db59@gmx.com>

--dpGvPzRRObvpTeFn03hGXQKHc8GhD27Gs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/8/18 12:33 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 10:40, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> The btrfs qgroup show command currently only exports qgroup IDs,
>> forcing the user to resolve which subvolume each corresponds to.
>>
>> This patch adds pathname resolution to qgroup show so that when
>> the -P option is used, the last column contains the pathname of
>> the root of the subvolume it describes.  In the case of nested
>> qgroups, it will show the number of member qgroups or the paths
>> of the members if the -v option is used.
>>
>> Pathname can also be used as a sort parameter.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>=20
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>=20
> Except one nitpick inlined below.
>=20
> [snip]
>>  	}
>> +	if (bq->pathname)
>> +		free((void *)bq->pathname);
>=20
> What about just free(bq->pathname);?
>=20
> Is this (void *) used to get around the const prefix?

Yes.

Thanks,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--dpGvPzRRObvpTeFn03hGXQKHc8GhD27Gs--

--yxO5kEV6PfDZjAIFBo38I4bcQa896EkGA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqhR/EPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyzOcP/i0+2tjRkqWHt1DTzzm23NC44azH/xAf/wnl
6yDacRc4ayQBx4od4rB3B5E9PpICD3U2kL3xL56LJkn8mon+fQkchCafKG8vk+Uf
wUyOXYUeFFVetfbDTaAja33SoK44OEdbm/Rjza3AJ3afUP9yOqErCq+EyTVDTHiW
NVEO+wBpwurdqvQ6/wtliMruXGMgE2ZpNs1F9ih5a2k0PIVFzZji4+Q/Tkmab6N/
XBcOCDslro0YS+HD7ZxnvSep3frjbg9banYP/1FJP+wm3I7LaRnsEI8JsXtrMRCm
4y7ndKlQDcIIDT3CPml7SXGlBqBzERhGSyxjsGhoNBdTYetdygsBATAqjMqlrDgM
NH/i17XxBYIK4LZX9dzmjH+w3srpnCg0tBLpd+g7As+9gDW4s9GLzpiR018ifk4B
3hFrbiKkNe3oyhM0McaFg1lJ0Lf3ZmOahAnfnz/m0DJL3cTjYVBtTaLrIiY8BAis
Nx20BWK+ZomQseZuX2JcTg7Wl45hMUe4RoUNkAX/kx1CmPnXJrKvF1Q2lp4WCRGh
liYPLhLOuVm/tr4e+nGfNeN0tu2i/yABq15MMuRTa6vAN0RE8/KLiI5Z3Y0bJ/0z
nCZ6gnuRfN0THlDFtPzapvDOP4e3QQ7IEcQaRtJRJRbKIM/Z1nDw4U2biV2PPr+Y
fl3sPziG
=EL9Z
-----END PGP SIGNATURE-----

--yxO5kEV6PfDZjAIFBo38I4bcQa896EkGA--
