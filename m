Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59555 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbeFSXSg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 19:18:36 -0400
Subject: Re: About more loose parameter sequence requirement
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
 <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
 <20180619144758.GR24375@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <81f3b209-e11a-17b0-8e4f-a7e8df02f448@gmx.com>
Date: Wed, 20 Jun 2018 07:18:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180619144758.GR24375@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OIkDRNjX5a4e3QGruzgmOz5ERUujVfbLA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OIkDRNjX5a4e3QGruzgmOz5ERUujVfbLA
Content-Type: multipart/mixed; boundary="YKhZO6FxWE3zMUBP0BKVYO7I1I8S1vEEe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>
Message-ID: <81f3b209-e11a-17b0-8e4f-a7e8df02f448@gmx.com>
Subject: Re: About more loose parameter sequence requirement
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
 <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
 <20180619144758.GR24375@twin.jikos.cz>
In-Reply-To: <20180619144758.GR24375@twin.jikos.cz>

--YKhZO6FxWE3zMUBP0BKVYO7I1I8S1vEEe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8819=E6=97=A5 22:47, David Sterba wrote:
> On Mon, Jun 18, 2018 at 09:05:59PM +0800, Qu Wenruo wrote:
>>> New code needs to be tested, documented and maintained, that's the co=
st
>>> I find too high for something that's convenience for people who are u=
sed
>>> to some shell builtins.
>>
>> The biggest problem is, the behavior isn't even consistent across
>> btrfs-progs.
>> mkfs.btrfs accept such out-of-order parameters while btrfs not.
>>
>> And most common tools, like commands provided by coretutil, they don't=

>> care about the order.
>> The only daily exception is 'scp', which I found it pretty unhandy.
>>
>> And just as Paul and Hugo, I think there are quite some users preferri=
ng
>> out-of-order parameter/options.
>=20
> Because of the feedback and interest of the relaxed mixed
> option/argument syntax, I don't object anymore.

And in fact, the behavior of btrfs is caused by @optind wrongly initializ=
ed.
The fix is just one line (along some comments).

https://patchwork.kernel.org/patch/10473173/

So no or little pressure on maintenance.

Thanks,
Qu


--YKhZO6FxWE3zMUBP0BKVYO7I1I8S1vEEe--

--OIkDRNjX5a4e3QGruzgmOz5ERUujVfbLA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlspjz4ACgkQwj2R86El
/qiVIwf9GYQeZbZZcRtjCu6R9P0IlvqhJwPVmWGZQzfFQsAQvOw7iVM+84GwGjRT
Lvd68Gpj/vwkq4lSrJW60Faa7xSNPjBLTZspAxypKg/PWMs08k2RQbnTnBVImXRP
Z/sDhTmq9Dga9B79tUO4sEMOxIl8FPdl6eD/+zW5zFnCn7er5VYSOYEJmCNG24bc
YxL5OvcOKcBtLYWpGj/SAMSFWxX9NhS9BA9SoRJCgm+KSDw5oMQwDETK8mpGun+y
HqvGD1+kQGJkxVUVMkEE266xxtZwXkNTu/RevqiQhQ38w77QxV1HfVjpaeXtORGA
YtlFkz6KsAZWHIFEz42fxXj4N2SuBA==
=kRzo
-----END PGP SIGNATURE-----

--OIkDRNjX5a4e3QGruzgmOz5ERUujVfbLA--
