Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60675 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbeHURrf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:47:35 -0400
Subject: Re: Are the btrfs mount options inconsistent?
To: dsterba@suse.cz, David Howells <dhowells@redhat.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, wqu@suse.de
References: <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
 <20180816130515.GR24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <32208.1534767847@warthog.procyon.org.uk>
 <341.1534859015@warthog.procyon.org.uk>
 <20180821142432.GD24025@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ef48fc22-494e-d1c4-1eab-747f2ac1b41c@gmx.com>
Date: Tue, 21 Aug 2018 22:26:54 +0800
MIME-Version: 1.0
In-Reply-To: <20180821142432.GD24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ToCBxsxmg6C7OuyN3UIeCwa8VlZBD7LWH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ToCBxsxmg6C7OuyN3UIeCwa8VlZBD7LWH
Content-Type: multipart/mixed; boundary="OSUinnpFot7Nyk3kAqyZ4EmQTRtWJniXR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, David Howells <dhowells@redhat.com>, clm@fb.com,
 linux-btrfs@vger.kernel.org, wqu@suse.de
Message-ID: <ef48fc22-494e-d1c4-1eab-747f2ac1b41c@gmx.com>
Subject: Re: Are the btrfs mount options inconsistent?
References: <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
 <20180816130515.GR24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <32208.1534767847@warthog.procyon.org.uk>
 <341.1534859015@warthog.procyon.org.uk>
 <20180821142432.GD24025@twin.jikos.cz>
In-Reply-To: <20180821142432.GD24025@twin.jikos.cz>

--OSUinnpFot7Nyk3kAqyZ4EmQTRtWJniXR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/21 =E4=B8=8B=E5=8D=8810:24, David Sterba wrote:
> On Tue, Aug 21, 2018 at 02:43:35PM +0100, David Howells wrote:
>> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>> But to be more clear, NOSSD shouldn't be a special case.
>>> In fact currently NOSSD only affects whether we will output the messa=
ge
>>> "enabling ssd optimization", no real effect if I didn't miss anything=
=2E
>=20
> There is a real effect.
>=20
>> That's not quite true.  In:
>>
>> 	if (!btrfs_test_opt(fs_info, NOSSD) &&
>> 	    !fs_info->fs_devices->rotating) {
>> 		btrfs_set_and_info(fs_info, SSD, "enabling ssd optimizations");
>> 	}
>>
>> the call to btrfs_set_and_info() will turn on SSD.

Oh, I just missed the btrfs_set part. (even it's myself introduced that
function).

What a shame...

Thanks,
Qu

>>
>> What this seems to me is that, normally, SSD will be turned on automat=
ically
>> unless at least one of the devices is a rotating medium - but this app=
ears to
>> be explicitly suppressed by the NOSSD option.
>=20
> Right. So expected behaviour:
>=20
> - nothing: auto-detect non-rotating devices, enable SSD mount option in=
 turn
> - nossd: disable auto-detection of non-rotating devices
> - ssd: enable SSD optimizations uconditionally
> - ssd_spread: implies SSD and affects some allocator decisions regardin=
g
>               new extent alignments
>=20


--OSUinnpFot7Nyk3kAqyZ4EmQTRtWJniXR--

--ToCBxsxmg6C7OuyN3UIeCwa8VlZBD7LWH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt8IS8ACgkQwj2R86El
/qj8Ugf8D5056hjF+RfpKDnZKByh6vtEY2fimTbiLlczATPRo+uVEwNwhuzlGUYh
sJTjXMYHX/+qGd/O8A68oArnlNxI+OADw9yvGmD8QTNHqBByBosIH5wj479O6dMA
ZM09lkHcM7xbjBkz0KcUTPN3IXwVbd2PalrBEpb2VUAjEBX+FB3J8sVEIc4eSaaD
6AMo2MOgCtHxZEhpXqeLWOY5NiHEZH7811tr8/xVqU51u5QIYL4gohaART7nXHZM
rmte/Oc3QsZZpomSdSVOGLvEMgG9H5jjYncKSHHNFDHvqyDGV7q/aOX6nKnesald
DbS/0WvAZpXuHRspneMzS4iJrwHIsg==
=EbQs
-----END PGP SIGNATURE-----

--ToCBxsxmg6C7OuyN3UIeCwa8VlZBD7LWH--
