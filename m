Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:40561 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751459AbeCUCBq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 22:01:46 -0400
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>, Liu Bo <obuil.liubo@gmail.com>,
        "waxhead@dirtcellar.net" <waxhead@dirtcellar.net>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        David Sterba <dsterba@suse.cz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
 <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
 <93b4d10e04d34ecfa97f705d939ab671@MOXDE7.na.bayer.cnb>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f2113adc-776c-856c-4047-3281afe6e079@gmx.com>
Date: Wed, 21 Mar 2018 10:01:30 +0800
MIME-Version: 1.0
In-Reply-To: <93b4d10e04d34ecfa97f705d939ab671@MOXDE7.na.bayer.cnb>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1RYHKuFnzEGzx9uVd52oe6oS56E35DLOD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1RYHKuFnzEGzx9uVd52oe6oS56E35DLOD
Content-Type: multipart/mixed; boundary="KiC3M35V4Qh4Z2E9pmnjj0KcaHro2PuVo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mike Stevens <michael.stevens@bayer.com>, Liu Bo <obuil.liubo@gmail.com>,
 "waxhead@dirtcellar.net" <waxhead@dirtcellar.net>,
 "kreijack@inwind.it" <kreijack@inwind.it>, David Sterba <dsterba@suse.cz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <f2113adc-776c-856c-4047-3281afe6e079@gmx.com>
Subject: Re: Crashes running btrfs scrub
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
 <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
 <93b4d10e04d34ecfa97f705d939ab671@MOXDE7.na.bayer.cnb>
In-Reply-To: <93b4d10e04d34ecfa97f705d939ab671@MOXDE7.na.bayer.cnb>

--KiC3M35V4Qh4Z2E9pmnjj0KcaHro2PuVo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8821=E6=97=A5 01:44, Mike Stevens wrote:
>=20
>>> 30 devices is really not that much, heck you get 90 disks top load JB=
OD
>>> storage chassis these days and BTRFS does sound like an attractive ch=
oice
>>> for things like that.
>=20
>> So Mike's case is, that both metadata and data are configured as
>> raid6, and the operations, balance and scrub, that he tried, need to
>> set the existing block group as readonly (in order to avoid any
>> further changes being applied during operations are running), then we
>> got into the place where another system chunk is needed.
>=20
>> However, I think it'd be better to have some warnings about this when
>> doing a) mkfs.btrfs -mraid6, b) btrfs device add.
>=20
>> David, any idea?
>=20
> I'll certainly vote for a warning, I would have set this up differently=
 had I been aware. =20
>=20
> My filesystem check seems to have returned successfully:
>=20
> [root@auswscs9903] ~ # btrfs check --readonly /dev/sdb
> Checking filesystem on /dev/sdb
> UUID: 77afc2bb-f7a8-4ce9-9047-c031f7571150
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 97926270238720 bytes used err is 0
> total csum bytes: 95395030288
> total tree bytes: 201223503872
> total fs tree bytes: 84484636672
> total extent tree bytes: 7195869184
> btree space waste bytes: 29627784154
> file data blocks allocated: 97756261568512
>=20
> I've remounted the filesystem and I can at least touch a file.  I'm res=
tarting the rsync that was running when it originally went read only.
> What is the next step if it drops back to r/o?

As already mentioned, if you're using tons of disks and RAID0/10/5/6 as
metadata profile, you can just convert your metadata (or just system) to
RAID1/DUP.

Then there will be more than enough space for system chunk array.

Thanks,
Qu

>=20
> _______________________________________________________________________=
_
> The information contained in this e-mail is for the exclusive use of th=
e=20
> intended recipient(s) and may be confidential, proprietary, and/or=20
> legally privileged.  Inadvertent disclosure of this message does not=20
> constitute a waiver of any privilege.  If you receive this message in=20
> error, please do not directly or indirectly use, print, copy, forward,
> or disclose any part of this message.  Please also delete this e-mail=20
> and all copies and notify the sender.  Thank you.=20
> _______________________________________________________________________=
_
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=BF=
=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=BF=
=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BDn=EF=
=BF=BD=DF=B2)=EF=BF=BD=EF=BF=BD=EF=BF=BDw*=1Fjg=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=1E=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j/=EF=BF=BD=EF=BF=BD=
=EF=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=BD2=EF=BF=BD=DE=99=EF=BF=BD=EF=BF=
=BD=EF=BF=BD&=EF=BF=BD)=DF=A1=EF=BF=BDa=EF=BF=BD=EF=BF=BD=7F=EF=BF=BD=EF=BF=
=BD=1E=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=0F=EF=BF=BDj:+v=EF=BF=
=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BD=D9=A5
>=20


--KiC3M35V4Qh4Z2E9pmnjj0KcaHro2PuVo--

--1RYHKuFnzEGzx9uVd52oe6oS56E35DLOD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqxvPoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhQDAgAgj+9+MBxjxNNEN4lPVueR6G6
ZIjdZ7kmOLPr9NJ2ZO49XsnNXcs0xt6wOF9K42i6qWMi+CaiNWpbD/yO6HPNcIX3
rx4eYPiQfNncFNtTvRBslfLTVO5YguJIs/sTmASZAcDD0jMa4fZ4pAIhoCEvVwRA
5QlJXsmOpWIrT5v0azEMjHJdcbgEKyooK4Hnj/4mkSjklE0F+fojfMv2zce2ZRNC
ysNMEaCYLlu+uyq9u5sGs5ReHbuTBaZrq8p3h8Xduz6k17HbACgCK6HsyULMbK6w
GrMyjKxHAmquEnAmnL11zkjG1FR3O7TVsSSbhAyRExSmnbuuGNb4FDUn3g0Cmw==
=rdeU
-----END PGP SIGNATURE-----

--1RYHKuFnzEGzx9uVd52oe6oS56E35DLOD--
