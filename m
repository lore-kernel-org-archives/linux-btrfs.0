Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:37385 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164678AbeE1MVF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 08:21:05 -0400
Subject: Re: [PATCH 0/4] btrfs check --check-data-csum enhancement for
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180227091259.10877-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <47a6d2c5-ca6d-d591-7154-5d5d20e837fa@gmx.com>
Date: Mon, 28 May 2018 20:20:35 +0800
MIME-Version: 1.0
In-Reply-To: <20180227091259.10877-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lvtwmgwEXDWkeQ0M8n3I41wtN9pItgR59"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lvtwmgwEXDWkeQ0M8n3I41wtN9pItgR59
Content-Type: multipart/mixed; boundary="Pk6Srmng9aCg5yqkcTFiEshMxRNanX0NW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <47a6d2c5-ca6d-d591-7154-5d5d20e837fa@gmx.com>
Subject: Re: [PATCH 0/4] btrfs check --check-data-csum enhancement for
References: <20180227091259.10877-1-wqu@suse.com>
In-Reply-To: <20180227091259.10877-1-wqu@suse.com>

--Pk6Srmng9aCg5yqkcTFiEshMxRNanX0NW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping.

Or do I need to rebase the patchset and resend?

Thanks,
Qu

On 2018=E5=B9=B402=E6=9C=8827=E6=97=A5 17:12, Qu Wenruo wrote:
> Log-writes tool from Josef exposed btrfs data corruption.
>=20
> Although still digging, at least enhance --check-data-csum option so
> that log-replay --check can stop exactly at the point where btrfs data
> get corrupted, instead of manually checking the output.
>=20
> Qu Wenruo (4):
>   btrfs-progs: check: Check data csum for all copies
>   btrfs-progs: check: Fix data csum check return value
>   btrfs-progs: check: Continue check even csum error is found
>   btrfs-progs: check: Distingusih csum checking output for
>     --check-data-csum
>=20
>  check/main.c | 93 ++++++++++++++++++++++++++++++++++++----------------=
--------
>  1 file changed, 56 insertions(+), 37 deletions(-)
>=20


--Pk6Srmng9aCg5yqkcTFiEshMxRNanX0NW--

--lvtwmgwEXDWkeQ0M8n3I41wtN9pItgR59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsL9BMACgkQwj2R86El
/qj+lAf/SAl+YwHGp+aysChWDZ50T2fZ2gl3RcZh7/lAgUWjijb9A9ejcLBsjX7P
DBAdWhsx5rPPHQDRirSiGuDI4re4CpmyIGs8zVSfu1i4kIGbFLCh66QSxzm10ZWE
zT9jbmsUxkJh8FYnljPufQKV+LcAff7r9w7SNIFOCiHgIeQadzTBkAFc3MJprkBx
xws6e0IiFJSQKr5USw2AAxHn7ylDuBQwWhZVxaO5j1iHK/4onE0nO2Aw6WsPuzxf
7y2amkEhK4WSbZah5HwYt0j2o0qgcQFS5JHQw4mQFLIbdZxqmRxIAso/QzNpToBW
rA1WFS0G9Tse8FWp50JhTK+NUHduYQ==
=YvOz
-----END PGP SIGNATURE-----

--lvtwmgwEXDWkeQ0M8n3I41wtN9pItgR59--
