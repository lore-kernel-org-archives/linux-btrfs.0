Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726138AbeILFBV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 01:01:21 -0400
Subject: Re: [PATCH 0/6] btrfs-progs: Variant fixes for fuzz-tests
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180803055022.9816-1-wqu@suse.com>
 <d844475b-f06a-4149-4259-999b08e3dd09@gmx.com>
 <20180911163851.GG2154@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <ef65752f-c68a-778e-0334-9dc65d1f840c@suse.de>
Date: Wed, 12 Sep 2018 07:59:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180911163851.GG2154@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YTZQcch5bh5juyzz7NZjS9q6jzu1LT41R"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YTZQcch5bh5juyzz7NZjS9q6jzu1LT41R
Content-Type: multipart/mixed; boundary="xqGuYV4DD5Pg9gQWgnupo4jYoE2JbrqOZ";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ef65752f-c68a-778e-0334-9dc65d1f840c@suse.de>
Subject: Re: [PATCH 0/6] btrfs-progs: Variant fixes for fuzz-tests
References: <20180803055022.9816-1-wqu@suse.com>
 <d844475b-f06a-4149-4259-999b08e3dd09@gmx.com>
 <20180911163851.GG2154@twin.jikos.cz>
In-Reply-To: <20180911163851.GG2154@twin.jikos.cz>

--xqGuYV4DD5Pg9gQWgnupo4jYoE2JbrqOZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/12 =E4=B8=8A=E5=8D=8812:38, David Sterba wrote:
> On Wed, Aug 29, 2018 at 01:27:39PM +0800, Qu Wenruo wrote:
>> Gentle ping.
>>
>> These fixes are pretty small, I'd like to see them merged before I nee=
d
>> to rebase them again and again.
>=20
> I've merged them now, thanks. I had to edit all changelogs and remove
> the ----- lines, shortened the paths in the test logs and fixed typos.

Thanks for the editing.

I'll keep the log format as default for all later patches.

BTW, is there any difference between 2 spaces indent and 1 space indent
for log?

Thanks,
Qu

> Please have a look at the committed patches and compare to what you
> sent.
>=20


--xqGuYV4DD5Pg9gQWgnupo4jYoE2JbrqOZ--

--YTZQcch5bh5juyzz7NZjS9q6jzu1LT41R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluYVuYACgkQwj2R86El
/qi9YQf/W6hValjaagyrzHjFQJdKd7xIMqQaRAtppIkxS2/uxSNGxbgguoKxt6jY
sfH3NueATAesYnAGI9JujNZjOb1kkSh20Y/7e7Myb+u421/rXq1twj1ldLrDFTGd
lJAElBqYISlWIb4AhT8j9SAAyiAdtVHcVku1LXI9UfSIG4+hkSSkBVVIRbiI+hGR
s355iDFhM7iU0FA1DdCXMGC2HVmc+HDP3CWDBfk22iiYiBSmYFmwsvpoafofq7j1
XxrSM+mVBua2AJCZm7WmBRDgWPhW3kHBX1e8ytFDLj48OllbF/cwmJEuL4/vudsC
qC8bDOXt6vPYFMboTaMumlaNwoOsqw==
=FIzR
-----END PGP SIGNATURE-----

--YTZQcch5bh5juyzz7NZjS9q6jzu1LT41R--
