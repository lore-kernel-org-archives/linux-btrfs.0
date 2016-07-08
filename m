Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:37728 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbcGHMba (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 08:31:30 -0400
Received: from tux.wizards.de (pD953E552.dip0.t-ipconnect.de [217.83.229.82])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 7EC1E4160380
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jul 2016 14:31:28 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.wizards.de [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 2693F11C007F
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jul 2016 14:31:28 +0200 (CEST)
Subject: Re: kdave/for-next commit 26112f7f472
References: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
 <577F8C2E.3@applied-asynchrony.com>
 <fd43645d-fac7-faf9-565f-dfbc6a84ecf5@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <577F9D1F.8050400@applied-asynchrony.com>
Date: Fri, 8 Jul 2016 14:31:27 +0200
MIME-Version: 1.0
In-Reply-To: <fd43645d-fac7-faf9-565f-dfbc6a84ecf5@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="lGxFV9APgU22xK9Lwjs43gJ8LDkM4UuFM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lGxFV9APgU22xK9Lwjs43gJ8LDkM4UuFM
Content-Type: multipart/mixed; boundary="BQda3brwmlasLBPS9KmNHunkkwRKWrCNL"
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <577F9D1F.8050400@applied-asynchrony.com>
Subject: Re: kdave/for-next commit 26112f7f472
References: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
 <577F8C2E.3@applied-asynchrony.com>
 <fd43645d-fac7-faf9-565f-dfbc6a84ecf5@suse.com>
In-Reply-To: <fd43645d-fac7-faf9-565f-dfbc6a84ecf5@suse.com>

--BQda3brwmlasLBPS9KmNHunkkwRKWrCNL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/08/16 13:55, Jeff Mahoney wrote:
> On 7/8/16 7:19 AM, Holger Hoffst=C3=A4tte wrote:
>> On 07/08/16 06:24, Jeff Mahoney wrote:
>>> Hi Dave -
>>>
>>> This commit introduces a bug.  I ran across it when running xfstests
>>> against my own integrated branch.
>>
>> I can't find that commit id anywhere...?
>=20
> Hi Holger -
>=20
> This is the for-next branch.  It's not in any mainline branch yet.

Yes, I understand that. I searched in the github/kdave tree, which only
has the for-next-xyz branches. Found it in the one on kernel.org.

-h



--BQda3brwmlasLBPS9KmNHunkkwRKWrCNL--

--lGxFV9APgU22xK9Lwjs43gJ8LDkM4UuFM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iGUEARECACUFAld/nSAeHGhvbGdlckBhcHBsaWVkLWFzeW5jaHJvbnkuY29tAAoJ
EA+BNAnY3O7N1kgAni/fCoTHYYkkLheALeDD/iVhhDXIAJ9YPt+EK+G7z/muferE
BKUj8GLgrw==
=ETHv
-----END PGP SIGNATURE-----

--lGxFV9APgU22xK9Lwjs43gJ8LDkM4UuFM--
