Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727666AbeHWQzf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 12:55:35 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F3F7AEA5
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 13:25:51 +0000 (UTC)
Subject: Re: [PATCH v2.1] btrfs: Handle owner mismatch gracefully when walking
 up tree
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180821014203.5443-1-wqu@suse.com>
 <20180823132402.GN24025@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <53417ed6-7e31-bc61-0915-cd62359c7b24@suse.de>
Date: Thu, 23 Aug 2018 21:25:44 +0800
MIME-Version: 1.0
In-Reply-To: <20180823132402.GN24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CmwPvzOTYdG3lnxUjIOIojxAUa70t03Kq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CmwPvzOTYdG3lnxUjIOIojxAUa70t03Kq
Content-Type: multipart/mixed; boundary="D9g4Ys7HOapnK6bMyw5VQE4P1eMSJrdim";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <53417ed6-7e31-bc61-0915-cd62359c7b24@suse.de>
Subject: Re: [PATCH v2.1] btrfs: Handle owner mismatch gracefully when walking
 up tree
References: <20180821014203.5443-1-wqu@suse.com>
 <20180823132402.GN24025@twin.jikos.cz>
In-Reply-To: <20180823132402.GN24025@twin.jikos.cz>

--D9g4Ys7HOapnK6bMyw5VQE4P1eMSJrdim
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/23 =E4=B8=8B=E5=8D=889:24, David Sterba wrote:
> On Tue, Aug 21, 2018 at 09:42:03AM +0800, Qu Wenruo wrote:
>> [BUG]
>> When mounting certain crafted image, btrfs will trigger kernel BUG_ON(=
)
>> when try to recover balance:
>> ------
>> ------------[ cut here ]------------
>=20
> Please don't use lines starting with ---,

I though "------" won't trigger the "---" of git thus OK to use.

> an empty line is fine, or you
> can also indent the trace dump by a few spaces for clarity. I'll update=

> the patches that have been merged so you don't need to resend.

I'll go an empty line from now on.

Thanks,
Qu


--D9g4Ys7HOapnK6bMyw5VQE4P1eMSJrdim--

--CmwPvzOTYdG3lnxUjIOIojxAUa70t03Kq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt+tdgACgkQwj2R86El
/qg9lQf3Zag37YM1KNL9+BjQogAigaYkck1rWAp3lFaiq+r4GoSVHp5Iz1c8PZFP
2tRvimaHFEPU0dmsRi/b4+P7fzRaOPvD8JS+0s6dWFSDzIV23Z2vK+R+x7kJW+pF
b4qtpwSUOTVvBRoPD/6vPyodRNqfsO7HTML078OKvhHGQGmKVngDUfzk1JaIt2qU
+x1011k+M0fb44U1Yypz847W+jgXjrURDo744TPkmEfpTBtE8gSbbYqaVXYAM9JO
li2VQAOtDm80kLwqtpiRF6ncQZMsiXC0kvMI03VKoEGcwA6rEhjeXbOfHQcWEz/O
gMEe9OZDOV7oU4BndcTHDlgPbZ26
=bQye
-----END PGP SIGNATURE-----

--CmwPvzOTYdG3lnxUjIOIojxAUa70t03Kq--
