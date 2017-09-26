Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:60872 "EHLO pim.lukas-pirl.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965307AbdIZHj3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 03:39:29 -0400
Subject: Re: Wrong device?
To: linux-btrfs@oh3mqu.pp.hyper.fi
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
 <20170925075250.GC25529@carfax.org.uk>
 <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
 <20170925141951.GD25529@carfax.org.uk>
 <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com>
 <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>
 <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>
Cc: linux-btrfs@vger.kernel.org
From: Lukas Pirl <mail@lukas-pirl.de>
Message-ID: <b07d7c1e-5337-c098-7aeb-eb2ec989e93f@lukas-pirl.de>
Date: Tue, 26 Sep 2017 09:31:17 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qHQjNcFiva268ElRtCpFbOWwMVNRN5N17"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qHQjNcFiva268ElRtCpFbOWwMVNRN5N17
Content-Type: multipart/mixed; boundary="qjMGimcT8pkEJjLia0OiVShW3PwMhOU1h";
 protected-headers="v1"
From: Lukas Pirl <mail@lukas-pirl.de>
To: linux-btrfs@oh3mqu.pp.hyper.fi
Cc: linux-btrfs@vger.kernel.org
Message-ID: <b07d7c1e-5337-c098-7aeb-eb2ec989e93f@lukas-pirl.de>
Subject: Re: Wrong device?
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
 <20170925075250.GC25529@carfax.org.uk>
 <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
 <20170925141951.GD25529@carfax.org.uk>
 <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com>
 <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>
 <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>
In-Reply-To: <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>

--qjMGimcT8pkEJjLia0OiVShW3PwMhOU1h
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 09/25/2017 06:11 PM, linux-btrfs@oh3mqu.pp.hyper.fi wrote as excerpted=
:
> After a long googling (about more complex situations) I suddenly
> noticed "device sdb" WTF???=C2=A0 Filesystem is mounted from /dev/md3 (=
sdb
> is part of that mdraid) so btrfs should not even know anything about
> that /dev/sdb.

I would be interested in explanations regarding this too. It happened
to me as well, that I was confused by /dev/sd* device paths being
printed by btrfs in the logs, even though it runs on /dev/md-*
(/dev/mapper/*) devices exclusively.

> PS. I have noticed another bug too, but I haven't tested it with
> lastest kernels after I noticed that it happens only with
> compression=3Dlzo.=C2=A0 So maybe it is already fixed.=C2=A0 With gzip =
or none
> compression probem does not happens.=C2=A0 I have email server with abo=
ut
> 0.5 TB volume. It is using Maildir so it contains huge amount of
> files.=C2=A0 Sometimes some files goes unreadable.=C2=A0 After server r=
eset
> problematic file could be readable again (but not always)...
>=20
> But weird thing is that unreadable file always seems to be
> dovecot.index.log.

Confirm this (non-reproducible) behavior on a VPS running Debian
4.5.4-1~bpo8+1.

Lukas

--=20
+49 174 940 74 71
GPG key available via key servers


--qjMGimcT8pkEJjLia0OiVShW3PwMhOU1h--

--qHQjNcFiva268ElRtCpFbOWwMVNRN5N17
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEXBtOJuD0P2ffuc2mcFnJnVaBh58FAlnKAkUACgkQcFnJnVaB
h5+JEhAAsHSJRwxXDX3Aop4KYuQnvUuMcsfAAFcS1OqNxtcWcbexL37jpBzowZBK
662rrPdSB2BO4HHNjpXMbOduyG71lVdPueX3uRQCan6HySv65kDDdiV5RpqWnR3F
aUOWmG27x6+7g57+6WM6N8N9tx7yzr64FY5bETPYOQWIylyB3Bi+UNxSI87mQEho
XBhi8TX5sT8ZC7hsRJs5uqS2NKMlAqRv628PSnZkqdm89bPyBCoNQcZOqk8Rzv+B
oAc2eLmoLb2SU0i29JxVOrkqUCH4C2xAso6JtxLAtyilv0MW5TWNRfYcLsl8jDta
f+/acMp9hxdHK5j1r/SVtdjIomk+sFJj3tHhQ1g+wwj0IqwQsXaTwiln05HAzasZ
3ezWp0rAwdD8J3UR2rZHaO+kcnEjZ0oexNCZHGwgFQTqMP9MJjWrJoToeTQZQB02
sbDnlc+JcRlwphXw7Lye//HidQEQsKrP0YBVqdyOUgEgVSjyDZWxvnsLlAaZyLIy
wuMIFQIm/TOhtkKyutiodsvT37cx6bS+Yzme2xtwjkwIYzZjLlX50ssth/VWgfX5
6WyP2cAwoiyXv3a6oDjn3LmiklRxi/wxqDKs514c+PIAkbFZ1l5gxJGLlfh6tkHu
IVToLGdfxGgJoo5H/siqO1Cmamz+nkJwS81Gb4z7bmHHOKpieB4=
=mr6r
-----END PGP SIGNATURE-----

--qHQjNcFiva268ElRtCpFbOWwMVNRN5N17--
