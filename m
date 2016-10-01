Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48399 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751076AbcJAAi0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 20:38:26 -0400
Subject: Re: unable to handle kernel paging request - btrfs
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com>
 <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
 <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com>
 <CAGfcS_=2x-CqGwXXeWejiUoDTgy9HxAtPdy2Nur2CAMYT3d26A@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <6bf85d64-2792-85db-0169-c6288e95a775@suse.com>
Date: Fri, 30 Sep 2016 20:38:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfcS_=2x-CqGwXXeWejiUoDTgy9HxAtPdy2Nur2CAMYT3d26A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pkwXJglNW1w5kVEalNoqEU4llM2jacjXM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pkwXJglNW1w5kVEalNoqEU4llM2jacjXM
Content-Type: multipart/mixed; boundary="08s9HrchnWSh4cffGAmFMdEe3jRxaHxsA";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <6bf85d64-2792-85db-0169-c6288e95a775@suse.com>
Subject: Re: unable to handle kernel paging request - btrfs
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com>
 <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
 <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com>
 <CAGfcS_=2x-CqGwXXeWejiUoDTgy9HxAtPdy2Nur2CAMYT3d26A@mail.gmail.com>
In-Reply-To: <CAGfcS_=2x-CqGwXXeWejiUoDTgy9HxAtPdy2Nur2CAMYT3d26A@mail.gmail.com>

--08s9HrchnWSh4cffGAmFMdEe3jRxaHxsA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/30/16 5:07 PM, Rich Freeman wrote:
> On Fri, Sep 30, 2016 at 4:55 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> This looks like a use-after-free on one of the pages used for
>> compression.  Can you post the output of objdump -Dr
>> /lib/modules/$(uname -r)/kernel/fs/btrfs/btrfs.ko somewhere?
>>
>=20
> Sure:
> https://drive.google.com/open?id=3D0BwUDImviY_gcR3JfT0Z1cUlRVEk
>=20
> I was impressed by just how large it was.
>=20
> I take it you're going to try to use the offsets in the oops to figure
> out where it went wrong?  I really need to get kernel core dumping
> working on this box...

Yep.  What I think is happening is that we have workspace getting freed
while it's in use.  The faulting address is in vmalloc space and it's
also the first argument to memcpy, which makes it the destination.  In
lzo_decompress_biovec, that means it's the workspace->cbuf.  Beyond that
I'll have to dig a bit more.

It's the same fault that your first photo showed as a secondary Oops,
but that's not always the case.


--=20
Jeff Mahoney
SUSE Labs


--08s9HrchnWSh4cffGAmFMdEe3jRxaHxsA--

--pkwXJglNW1w5kVEalNoqEU4llM2jacjXM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX7wV8AAoJEB57S2MheeWyW8oQAIqULU1LV9mWvUXpzWVnIaW2
b6FdI306+qJ8KtqNU9vWsWAosrJNrNRiqRZrAQvWVRyKgtIs/CbeyWQXVvECbUpS
kcFmCw3Ww/0mnYA9qsgbhvCpbrNC2kQ4EgJ0MEUVpPzN63DI12cnrM7yA8iceqle
1Oi6Thn5h8IxTsUF3eHxmxEQjD2yUhluyVpTu9FTVcvY/sOqOpiHU5ZaNKTiRlmG
BywMvKUTtkfMxL7z/qm1xSyRscQHoqkXu3Kf7aM3RytaGtOXiQgu03fHW50tS3Xr
CfVoutrLnsf7RRLRTVWb58G8dtWwJXrdIB84NJ2x65PtvihX0tHssSIMcvDmw/Zz
6LuAn1WMipn6jIoi4hp2v0NM+GWmieXDvhxgUr1bQIBxt1Ief+qH/VBIAZR7ws3t
6GkKtfHl6w27Z3eq1PXX+NaPAmagYUw2FcOhfAj2NVAk5amGW1g4jYJejZPxiWrm
duIikO2jgVz1Q3GSbTLGg3prtcG5KFG0wgrPimaWLp0La7u1VBSkzUvOBaQhSFvs
I/xQW85glFCIwlouB8kDqCV8sfudESZWd4/dr6SPMBfRjxfofjj6vqhHUDKeksCW
Tkyb+PTKKV38aVpxoqzg0qzFKz1pvzFtQV285qG/0n2xxq68FeBTgiqR+aJUeFiD
HH0bmMfrTpHtMIQMvJSQ
=r1vk
-----END PGP SIGNATURE-----

--pkwXJglNW1w5kVEalNoqEU4llM2jacjXM--
