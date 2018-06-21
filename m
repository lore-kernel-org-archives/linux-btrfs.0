Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:33933 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754067AbeFUODT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 10:03:19 -0400
Subject: Re: [PATCH] btrfs: check-integrity: Fix NULL pointer dereference for
 degraded mount
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180620073858.10794-1-wqu@suse.com>
 <20180621135809.GQ24375@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c5d09030-cd4f-914a-0d22-689592ba3be5@gmx.com>
Date: Thu, 21 Jun 2018 22:02:53 +0800
MIME-Version: 1.0
In-Reply-To: <20180621135809.GQ24375@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LSOHUUQtXZZShfJbA8H7CVQwuyLSU9LgG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LSOHUUQtXZZShfJbA8H7CVQwuyLSU9LgG
Content-Type: multipart/mixed; boundary="dI20Cd6CzeOgiKlXtBxJdVgSerbqF6niB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c5d09030-cd4f-914a-0d22-689592ba3be5@gmx.com>
Subject: Re: [PATCH] btrfs: check-integrity: Fix NULL pointer dereference for
 degraded mount
References: <20180620073858.10794-1-wqu@suse.com>
 <20180621135809.GQ24375@twin.jikos.cz>
In-Reply-To: <20180621135809.GQ24375@twin.jikos.cz>

--dI20Cd6CzeOgiKlXtBxJdVgSerbqF6niB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8821=E6=97=A5 21:58, David Sterba wrote:
> On Wed, Jun 20, 2018 at 03:38:58PM +0800, Qu Wenruo wrote:
>> Commit f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev=
_t")
>> changed how btrfsic how we index device state hash.
>>
>> Now we need to access device->bdev->bd_dev, while for degraded mount
>> it's completely possible to have device->bdev as NULL, thus it will
>> trigger a NULL pointer dereference at mount time.
>>
>> Fix it by checking if the device is degraded before accessing
>> device->bdev->bd_dev.
>>
>> There are a lot of other places accessing device->bdev->bd_dev, howeve=
r
>> the other call sites have either checked device->bdev, or the
>> device->bdev is passed from btrfsic_map_block(), so it won't cause har=
m.
>>
>> Fixes: f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev=
_t")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Added to misc-next. As it is a fix it could go to 4.18 but I'd rather
> have a good reason for that because it's in a debugging feature.

No need to push it to 4.18.

Indeed it's a debug feature, and furthermore, there are tons of bugs
exposed by fstests, so it's better to fix it as a large serious patchset.=


Thanks,
Qu

>=20
>> ---
>> Please note there are still quite some problem about check-integrity,
>> including:
>> 1) Warning for degraded mount
>> 2) Meaningless empty lines output
>>
>> This patch will only fix the obvious NULL pointer dereference exposed =
by
>> btrfs/027 with "check_int" mount option.
>=20
> Ok.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--dI20Cd6CzeOgiKlXtBxJdVgSerbqF6niB--

--LSOHUUQtXZZShfJbA8H7CVQwuyLSU9LgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsrsA0ACgkQwj2R86El
/qi3lggAjpWkPFad+kFOgz2j1GpqREw0jNp1zNiC7NWO2aq0wk3hh/4oadJvwb95
R8rtz10xq2e6feaVWyDnPgKaWpmzAXFmRG2uQW7H+04Dr3RT1d6FsiVgZhJSW8R2
lNW7zNG2W1xIbJkUCRNYKOanru743oAjZukiCmcE+Fwi07KluEDko6oDKp0meXze
PaYtoYKHY817auwvgeGfOPwmDkX07vGliAbFOFNSounhFyvH3XwNXveXTdkGV0Ec
mgbogowj2NSGEu5ehDYrBhBxm8U+ZO6ZlMaZa8Ih7f7M0xoAjkoW0lZI84UwSkci
SswsX0iKTxB3MyUADF+aI4q8RJX6Bw==
=LDfZ
-----END PGP SIGNATURE-----

--LSOHUUQtXZZShfJbA8H7CVQwuyLSU9LgG--
