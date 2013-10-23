Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39671 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3JWD6n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 23:58:43 -0400
Received: by mail-ie0-f171.google.com with SMTP id tp5so416609ieb.30
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 20:58:42 -0700 (PDT)
Received: from noether.localnet (d67-193-117-53.home3.cgocable.net. [67.193.117.53])
        by mx.google.com with ESMTPSA id m1sm6018544igj.10.2013.10.22.20.58.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2013 20:58:41 -0700 (PDT)
From: Henry de Valence <hdevalence@hdevalence.ca>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Itermittent data corruption and dmesg spam
Date: Tue, 22 Oct 2013 23:58:33 -0400
Message-ID: <6844836.rMEZUtNbVg@noether>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1886859.SiLcH2Xdz2"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1886859.SiLcH2Xdz2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi all,

Two questions:

First, I have a ton of lines in dmesg like

[  123.664465] incomplete page read in btrfs with offset 2048 and lengt=
h 2048
[  123.835761] incomplete page read in btrfs with offset 512 and length=
 3584

What does this mean? I tried searching on Google but all I got was the =
commit=20
that added the code that prints these messages. Should I be worried?

Second, I=E2=80=99m having some intermittent data corruption issues, an=
d I=E2=80=99m not=20
really sure how to pin down the cause. Sometimes, I=E2=80=99ll get erro=
rs trying to=20
read a file due to a failed checksum, but when I run btrfs scrub, it re=
ports=20
that everything is OK. For instance, this time I booted, I get a line i=
n dmesg=20
saying

btrfs: bdev /dev/bcache0 errs: wr 0, rd 0, flush 0, corrupt 16, gen 0

but when I run btrfs scrub I get:

scrub status for 56118d27-c9a8-483c-afaa-e429d59884e9
     scrub started at Tue Oct 22 22:46:17 2013 and finished after 2802 =
seconds
     total bytes scrubbed: 426.03GB with 0 errors

My setup is a btrfs partition on a bcache device, which has a new-ish h=
ard=20
drive as the backing store and a partition on an older SSD as the cache=
. The=20
bcache documentation suggests that sequential reads bypass the cache de=
vice.=20
Is it possible that I have some bad blocks on my SSD, which cause the e=
rrors=20
and data corruption, but the data corruption doesn=E2=80=99t show up wi=
th btrfs scrub=20
because the disk accesses in the scrub are bypassing the cache?

Does anyone know how I could test this theory, or otherwise try to dete=
rmine=20
the source of the problems?

For what it=E2=80=99s worth, I ran smartctl on both my hard drive and m=
y SSD, and it=20
didn=E2=80=99t detect anything.

My btrfs version is Btrfs v0.20-rc1-358-g194aa4a on Linux 3.11.3 (Arch)=
.

Thanks,
Henry de Valence
--nextPart1886859.SiLcH2Xdz2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJSZ0lwAAoJENEmVP03fJpAhVkP+gIpxvFcBwVBIVK6O8mfCs8s
16+Qq8hMD8DjSydRKkOflCq3/5oJIFQdoF9uSmv4DWfIrtHm5Cf3iTEAfkVxEpXw
wZcsuyl4HgQBrUoZh8h0hkC/dMMdFY3hTLkVSknXeknhxl01g0CkpaoijCPcqFxY
uN/cj1fV4b1qkaLjYZENe2suH1chUDavfMjI7HKLUB48vJyCFZUlPjz2wt9wP/oG
mgkF5au2EtMtrd235cnbaOWgwBFveR/9/YxU6MFOqrm5NIGmJFiEBVDBv8qjVIic
enkp8GWrJumOIJc1owL3BZfOkqom7DJb2hYoQqFNGhuT79iACTlP/o1YWBUHPTBF
bHvNwNgYdk0Vsaeawyeu0nzXoF8aL62J+3Ptm+nnveqrhT4SstDRBcO7mqdXrRi4
6GpLPdKdITd+Q9xm9cqeclWkKRqnitXoaQBTHtDNCRp5Bd0SuTRYqEfJQVNMTfpk
wBXJydMFJpmHFiJb3vywUTtFupth/TkJ4G2yNwKL3s0eekL4KIX2EQmpb0tEoIjn
VuOi2X5N4CFb/H1IHaRE+hlVArurR4GlInh/fO4Vqh50aESWqKYZmu+hvrsfl2t1
91u1NRIqWe5sg/ZIwS2ED3DUaVxFebW6ZkWXXNPgP2KzH/rRsTYf3PGPYZSHYjTj
qLtehUvlWfF5KWL/rXvA
=pcw0
-----END PGP SIGNATURE-----

--nextPart1886859.SiLcH2Xdz2--

