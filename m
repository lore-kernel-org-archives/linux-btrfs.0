Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:49247 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751558AbdAYPtT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 10:49:19 -0500
Subject: Re: NULL pointer dereference in btrfs_async_reclaim_metadata_space
To: bo.li.liu@oracle.com
References: <29d12d8d-30f6-f0d4-847e-d11edf7aa9f5@pengutronix.de>
 <20170125154325.GA13419@dhcp-amer-vpn-adc-anyconnect-10-154-187-238.vpn.oracle.com>
Cc: linux-btrfs@vger.kernel.org
From: Marc Kleine-Budde <mkl@pengutronix.de>
Message-ID: <0981ebaa-1f22-6586-a450-c0e6f689901e@pengutronix.de>
Date: Wed, 25 Jan 2017 16:47:19 +0100
MIME-Version: 1.0
In-Reply-To: <20170125154325.GA13419@dhcp-amer-vpn-adc-anyconnect-10-154-187-238.vpn.oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="SIdoN441tn5WcM2mSE19l2cF45p1kw183"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SIdoN441tn5WcM2mSE19l2cF45p1kw183
Content-Type: multipart/mixed; boundary="E8IhMVbGriJ8rOr9wjVoFe9XhNFmpNS1g";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <0981ebaa-1f22-6586-a450-c0e6f689901e@pengutronix.de>
Subject: Re: NULL pointer dereference in btrfs_async_reclaim_metadata_space
References: <29d12d8d-30f6-f0d4-847e-d11edf7aa9f5@pengutronix.de>
 <20170125154325.GA13419@dhcp-amer-vpn-adc-anyconnect-10-154-187-238.vpn.oracle.com>
In-Reply-To: <20170125154325.GA13419@dhcp-amer-vpn-adc-anyconnect-10-154-187-238.vpn.oracle.com>

--E8IhMVbGriJ8rOr9wjVoFe9XhNFmpNS1g
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/25/2017 04:43 PM, Liu Bo wrote:
> On Wed, Jan 25, 2017 at 10:31:32AM +0100, Marc Kleine-Budde wrote:
>> Hello,
>>
>> I'm using debian's latest 4.9 Kernel on a 32bit armhf SMP board. The
>> filesystem is in raid1 mode using two harddrives. After the system
>> crashed (for yet unknown reason) the mounting of the raid1 failed
>> with the following backtrace:
>=20
> Since this was happening at mount stage, it seems like our fs_root is
> not set up yet, could you please try this debugging one?

Since this is my production system, I've mounted the FS in the mean time
on an amd64 (debian kernel v4.8.15-2) and it worked without problems.

I'll try to compile a kernel with your patch for the affected systemm
though.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--E8IhMVbGriJ8rOr9wjVoFe9XhNFmpNS1g--

--SIdoN441tn5WcM2mSE19l2cF45p1kw183
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEES2FAuYbJvAGobdVQPTuqJaypJWoFAliIyIcACgkQPTuqJayp
JWozMgf9ENej4VGWa7xJgHP10Q9zctu1E/PlVD7doomLbERtJ4N/cIxoxeFrQqTb
Xq/TM6DrwKlNP/bsUMlNgw5/PbxFyT2V+joezpA8Nf1XdjRjLeUfxGOK7W8m6m21
ohpdIdWU+8j+FXfx+KbBCZdWW3nusX8HoI/ngf/vgaMpAB5OS55PrFKsD6/rRVzJ
q6JFfk1O7miewrnRndTYg9V4M7AiLhkxpKFLNYx3r2phF685OModbTFIALilCFEw
cUTYChItIGEV87pjJyOW4zNqQceheg24UjIgPs8ENwOqY5iLhQYUDaWPPipc7mQi
M46oi8/HuriW7mFdEv1kv/ZpluSX2w==
=yYtK
-----END PGP SIGNATURE-----

--SIdoN441tn5WcM2mSE19l2cF45p1kw183--
