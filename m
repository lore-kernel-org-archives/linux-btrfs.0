Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35728 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbdHBJRJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 05:17:09 -0400
Received: by mail-wm0-f52.google.com with SMTP id m85so35999520wma.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 02:17:08 -0700 (PDT)
From: Thomas Wurfbaum <thomas@wurfbaum.net>
To: linux-btrfs@vger.kernel.org
Reply-To: thomas@wurfbaum.net
Subject: Re: Crashed filesystem, nothing helps
Date: Wed, 02 Aug 2017 11:17:04 +0200
Message-ID: <3415313.AO7fCVCIcW@nimrod.thomas.wurfbaum.net>
In-Reply-To: <20170802090709.GA7140@carfax.org.uk>
References: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net> <20170802090709.GA7140@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2166221.ScdlDXhye1"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2166221.ScdlDXhye1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Maybe you are right, but i just followed the Suse guide:
https://en.opensuse.org/SDB:BTRFS
How to repair a broken/unmountable btrfs filesystem

I already tried the commands 
mount with the
-o usebackuproot option. (And -o usebackuproot,ro as well)
But they just produce this in dmesg:
[61054.470771] BTRFS info (device sdb1): trying to use backup root at mount 
time
[61054.470778] BTRFS info (device sdb1): disk space caching is enabled
[61054.470782] BTRFS info (device sdb1): has skinny extents
[61054.560876] BTRFS error (device sdb1): parent transid verify failed on 
29392896 wanted 1486833 found 1486836
[61054.563423] BTRFS error (device sdb1): parent transid verify failed on 
29392896 wanted 1486833 found 1486836
[61054.604057] BTRFS error (device sdb1): open_ctree failed
[61079.137435] BTRFS info (device sdb1): trying to use backup root at mount 
time
[61079.137443] BTRFS info (device sdb1): disk space caching is enabled
[61079.137445] BTRFS info (device sdb1): has skinny extents
[61079.227242] BTRFS error (device sdb1): parent transid verify failed on 
29392896 wanted 1486833 found 1486836
[61079.230087] BTRFS error (device sdb1): parent transid verify failed on 
29392896 wanted 1486833 found 1486836
[61079.260062] BTRFS error (device sdb1): open_ctree failed

And on the cli i get the following:
mainframe:~ # mount -o usebackuproot,ro /dev/sdb1 /data
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

A restore does also not help:
mainframe:~ # btrfs restore /dev/sdb1 /mnt
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
Ignoring transid failure
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
Ignoring transid failure
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
Ignoring transid failure






-- 
Thomas Wurfbaum
Starkertshofen 15
85084 Reichertshofen

Tel.: +49-160-3696336
Mail: thomas@wurfbaum.net

Google+:http://google.com/+ThomasWurfbaum
Facebook: https://www.facebook.com/profile.php?id=100006061335414
Xing: https://www.xing.com/profile/Thomas_Wurfbaum
--nextPart2166221.ScdlDXhye1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEib0Z9ILinUsMTE1rXgeiU5j4BKYFAlmBmJAACgkQXgeiU5j4
BKagcg/+JMwijehXy/IXl4QOZ9OMHllp9mz4F6KduaZt3VGBtYR8MesVIZqk5D4C
Wy6p/BpVPTXQS/geMqHm6cJIs83axaRSELh24PldiwQsssStULKlCGQHIatXDNcw
DjPzCqGa+p+CfIEQ51tfjsL2RGEF5P5e2ZJC7BdgdV6IHBy9oboeopzUFo/nay3Q
wNluZvvpX/LU6umxHdAyL68IbGoIg5Pd0EEgL01FPoG7nTajl1cMHImdZ23I4nV6
mBblmkhTIAJv/rbOMSPP5fQNMvwUADuYIdMJBG8m2ei4ILYcg+0oN0v+H37tJ85P
cWjvFv+9NvQo5jH6sE7AplV5c33OiZqwTOSBZyzFcEJpJMcMDyrYrKDQ9mmFLq+Z
i0/4cJ4NGST246tV5C0Pu8gN5mmZWbQq52/n0cyZgt8Rmb2Dj/82EwGGIB0G4AAK
PJN1KT9armjcondbydUASfTbnApGIdtfwyr4CcZnFOPIU9MMDR7U1EVtuA1CUHF6
TNFiMNmaLGlemNQVan5/5YHcgTIFuIOJtiuM7H4grEeVkcOyJ3FDwtGTR88DiNqq
F7lnpAhOouQmTu0CiuKbe/Qm4JfU2M47W9nSBzUzU+DToLP3bACBcv9lUB5E9svX
rxIJghToR2tsMfiexfNrkNhxpMtGt4gkBgeLVij/AMF3Q8AUT8Q=
=hkls
-----END PGP SIGNATURE-----

--nextPart2166221.ScdlDXhye1--

