Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:44791 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752918AbeGCBAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 21:00:36 -0400
Subject: Re: [PATCH v2 1/2] btrfs-progs: Fix wrong optind re-initialization to
 allow mixed option and non-option
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Paul Jones <paul@pauljones.id.au>, Hugo Mills <hugo@carfax.org.uk>
References: <20180620003839.10629-1-wqu@suse.com>
 <20180702221217.GD3126@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bc9453e7-3c17-6bc9-613c-af672e030eb5@gmx.com>
Date: Tue, 3 Jul 2018 09:00:09 +0800
MIME-Version: 1.0
In-Reply-To: <20180702221217.GD3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZuiQ0CRiSHvSPFMchKt978Bf4ATuhreOa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZuiQ0CRiSHvSPFMchKt978Bf4ATuhreOa
Content-Type: multipart/mixed; boundary="qx7ud7IAc4mydqhvDryBYxQCKuWU415ib";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Paul Jones <paul@pauljones.id.au>, Hugo Mills <hugo@carfax.org.uk>
Message-ID: <bc9453e7-3c17-6bc9-613c-af672e030eb5@gmx.com>
Subject: Re: [PATCH v2 1/2] btrfs-progs: Fix wrong optind re-initialization to
 allow mixed option and non-option
References: <20180620003839.10629-1-wqu@suse.com>
 <20180702221217.GD3126@twin.jikos.cz>
In-Reply-To: <20180702221217.GD3126@twin.jikos.cz>

--qx7ud7IAc4mydqhvDryBYxQCKuWU415ib
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8803=E6=97=A5 06:12, David Sterba wrote:
> On Wed, Jun 20, 2018 at 08:38:38AM +0800, Qu Wenruo wrote:
>> In function handle_global_options(), we reset @optind to 1.
>> However according to man page of getopt(3) NOTES section, if we need t=
o
>> rescan options later, @optind should be reset to 0 to initialize the
>> internal variables correctly.
>>
>> This explains the reason why in cmd_check(), getopt_long() doesn't
>> handle the following command correctly:
>> "btrfs check /dev/data/btrfs --check-data-csum"
>>
>> While mkfs.btrfs handles mixed non-option and option correctly:
>> "mkfs.btrfs -f /dev/data/disk1 --data raid1 /dev/data/disk2"
>>
>> Cc: Paul Jones <paul@pauljones.id.au>
>> Cc: Hugo Mills <hugo@carfax.org.uk>
>> Fixes: 010ceab56e06 ("btrfs-progs: rework option parser to use getopt =
for global options")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> changelog:
>> v2:
>>   Instead of resetting @optind at handle_global_options(), reset @opti=
nd
>>   before each later getopt() call. Since there are cases uses @optind =
and
>>   expects it to be starting from 1.
>=20
> So it's not possible to set it once before the callbacks are called in
> btrfs.c:main() due to the exceptions that need it to be set to 1. Ok,
> can you please send a separate patch that makes the optind =3D 1 explic=
it?

It's already done in handle_global_options(), so every subcommand is
getting @optind set to 1 already.

Thanks,
Qu

> Even it might be redundant in the context, it's a way to document the
> expected behaviour of getopt and also we would not have to think if the=

> optind setting is missing or not before the getopts. Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--qx7ud7IAc4mydqhvDryBYxQCKuWU415ib--

--ZuiQ0CRiSHvSPFMchKt978Bf4ATuhreOa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls6ypkACgkQwj2R86El
/qjzzQf8DxZoQ+ZdPEcFDPErwpEIazB++64EUEpsadH/RXWnTt8f6xUsaPlDyV9c
uON7Vu4SMW5Y0RqSEjVF7Ue19xAr7ekxZNaeFe0SNPt/Z+6NLL+OMuBAdmK8Sp7U
jnhL0RPRJq/in68OUa/AzGcXVOdHmD/4/hQLvy1FR6TDZcOfdx14/IqNtbAUqevh
JBxsAh7Jvbbgpi+lykd4vkFdUVZQg+JDG6xh2jEJgYsHO7KLUlNRZr6bhTv+klP4
ZJFf3tBdAksVJ3Ie/aJEvRj9/rhuQZlRf3V3v9dHFCGegLKu20XVpTq12+0wmLaD
lypVmQxdzlq8nQgo+r+z7nBOn3pxaw==
=Vy3w
-----END PGP SIGNATURE-----

--ZuiQ0CRiSHvSPFMchKt978Bf4ATuhreOa--
