Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755244AbdCXXNr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 19:13:47 -0400
Subject: Re: __link_block_group uses GFP_KERNEL
To: Denis Kirjanov <dkirjanov@cloudlinux.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, chris.mason@fusionio.com
References: <CABxMtgcGod=FvgHagua07bzPjc7cy_+v0hkbTvwH_7GggOh9Ow@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a43bf7e1-36fe-cb49-d0ba-697ddaf1a14e@suse.com>
Date: Fri, 24 Mar 2017 19:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <CABxMtgcGod=FvgHagua07bzPjc7cy_+v0hkbTvwH_7GggOh9Ow@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RuNodO2Vv8cH59h1pckIvnnRFIm22DKvU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RuNodO2Vv8cH59h1pckIvnnRFIm22DKvU
Content-Type: multipart/mixed; boundary="CNLOir1TAj8Dk0FjebjhqCEwseKe3BPf0";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Denis Kirjanov <dkirjanov@cloudlinux.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, chris.mason@fusionio.com
Message-ID: <a43bf7e1-36fe-cb49-d0ba-697ddaf1a14e@suse.com>
Subject: Re: __link_block_group uses GFP_KERNEL
References: <CABxMtgcGod=FvgHagua07bzPjc7cy_+v0hkbTvwH_7GggOh9Ow@mail.gmail.com>
In-Reply-To: <CABxMtgcGod=FvgHagua07bzPjc7cy_+v0hkbTvwH_7GggOh9Ow@mail.gmail.com>

--CNLOir1TAj8Dk0FjebjhqCEwseKe3BPf0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/24/17 5:02 AM, Denis Kirjanov wrote:
> Hi guys,
>=20
> Looks like that current code does GFP_KERNEL allocation inside
> __link_block_group.
> the function invokes kobject_add and internally creates sysfs files
> with the GFP_KERNEL flag set.

Yep, that's a bug.

> But since do_chunk_alloc executes insides the btrfs transaction it's
> not allowed to sleep.

It's allowed to sleep but isn't allowed to do reclaim that involves file
system writeback.  Michal Hocko's allocation context idea would fix
this, but it's not there yet, so we'll need to defer the kobject_add
until we can use GFP_KERNEL.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--CNLOir1TAj8Dk0FjebjhqCEwseKe3BPf0--

--RuNodO2Vv8cH59h1pckIvnnRFIm22DKvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWNWoJR57S2MheeWyAQjEWg/6Axaml/nxITHGbfhBXwUf70B1PwnONzwg
H+OPYXrnZkSOUhbMyYE3ppyNFPEXdKZI/b1337Yl5cgBqst/82cJG+Ub8g7hJV91
F+dlh2e8/FIPgEuRev7DRtmT5oUv6+m49uja40uBjORLeOJDddWXpDfxPCxvQ4uP
4Fk1SOFBCgP71GBASVbkxNmqYsB665bbhC8/LnuMGu8PlgQj0K54zOnzgvCAchoh
z5r05DPWx9DGedwZ/YVb/k/+vC2+1EPq/7eP/b4X6ndaOxd2jd9ZhvgcKRtmmf8A
A7783EfPSbvTQhxfr22uBDzXTd3khVcogAgqhTEJyJLpjbuH/8Dq07qekLgyk84H
w+DZKjxdrYB8lecFwNiTehdSMzb+FlEC3LGPok+gBIGjV2adRBoIYxBznKz/a7JR
ZxeIt5VZ1YYjGOzojEVpWMyDVC+3PK0RbIX6v970+eAgy0AafH4eN5zssse7wVaR
bkNjQWWB5Xa0RXO4YatkNDrGzZ8kkpSiO7Ian7Un6T60Xi1djBD1co2Dr08hHYCj
1K2uTl39bSgCgaQvVqJOqg8rrPh0bFuPpaQqE5fdr/raJglirL2cXt+2k0NTkmnn
l281sZ67ZmSoMkYrzmlcOJxK5iHoCHi4hqdR+VMakSQR3alyRw9mb12FEkQVRtaM
Y+mh2mPYVRY=
=Sjcx
-----END PGP SIGNATURE-----

--RuNodO2Vv8cH59h1pckIvnnRFIm22DKvU--
