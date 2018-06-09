Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38952 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753444AbeFIXHb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jun 2018 19:07:31 -0400
Received: by mail-wm0-f48.google.com with SMTP id p11-v6so9860657wmc.4
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jun 2018 16:07:31 -0700 (PDT)
Received: from [192.168.178.81] (dyndsl-089-166-134-072.ewe-ip-backbone.de. [89.166.134.72])
        by smtp.gmail.com with ESMTPSA id s38-v6sm11361910edd.2.2018.06.09.16.07.27
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Jun 2018 16:07:29 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: jackwolf2454 <jackwolf2454@gmail.com>
Subject: Direct cached reads slow - nvme
Message-ID: <8171531b-5ecb-36b0-216c-d26d33da0f37@gmail.com>
Date: Sun, 10 Jun 2018 01:07:17 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------95F8BCAA5DC85B56BF62A269"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------95F8BCAA5DC85B56BF62A269
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

linux 4.17.0
btrfs-progs v4.16.1

Label: none  uuid:
        Total devices 1 FS bytes used 128.00KiB
        devid    1 size 465.63GiB used 20.00MiB path /dev/nvme0n1p3


before mkfs.brtfs


/dev/nvme0n1p3:
 Timing O_DIRECT cached reads:   6112 MB in  2.00 seconds =3D 3056.19 MB/=
sec
 Timing O_DIRECT disk reads: 9138 MB in  3.00 seconds =3D 3045.73 MB/sec



after creating mkfs.btrfs /dev/nvme0n1p3

/dev/nvme0n1p3:
 Timing O_DIRECT cached reads:   2558 MB in  2.00 seconds =3D 1278.52 MB/=
sec
 Timing O_DIRECT disk reads: 9148 MB in  3.00 seconds =3D 3049.05 MB/sec



after creating mkfs.ext4 /dev/nvme0n1p3

/dev/nvme0n1p3:
 Timing O_DIRECT cached reads:   2102 MB in  2.00 seconds =3D 1050.20 MB/=
sec
 Timing O_DIRECT disk reads: 9194 MB in  3.00 seconds =3D 3064.60 MB/sec



Is this behaviour normal?

--------------95F8BCAA5DC85B56BF62A269
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

mQENBFsTDdUBCACgApA4Kc2CjrAeJG1VXt9fA8gY+Rlov9U0ijMm1CMjOfxlgcha
c9i6qiQ0nZUfh8koNXRUGNMTo3iszEwpETFG6rmfllZvRsbUZihSptLawKSF3jOb
K6+CRJO6fOX3vInH787PsxxE6b1uYmMsLLhKXP45d0LS3ZcoHOPf/buijx7l4oTB
+qUC+V7n3rAAZ4aK/ZEFwGppaKoNS2CvJkRDWNwRbvdPJPU3kZu7IHFjEypvZb//
KMuAHHup94o7h9z+wawuWgxA7+FQ03FqVyeNSGrif9GoBz1w+EuHqoHLpYSGDOfP
/PtYkPa9dUAkgQHIwINzuBzK6mxt0nOz66VJABEBAAG0JWphY2t3b2xmMjQ1NCA8
amFja3dvbGYyNDU0QGdtYWlsLmNvbT6JAVQEEwEIAD4WIQTA1h082woujMd41uUF
u6ctlIg0JQUCWxMN1gIbAwUJAeEzgAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAK
CRAFu6ctlIg0JdwoB/0cBNJGwsVftBW8vwEsmtleTmJo/jSDjIffhkPbTpT9fOnu
y62jVnhc/EMWJAv4Ie1uN99rZ8YFAz1MpqbOs6A1ERsYyP00D5XTKAfJWfEdt1Xr
2gKA13W8YpXVSdeTvx3NiSFQnJEHTDi9X2IOAgNrslgIVyPWRJwK1ZtViSEfK2Kh
KT1T8iE6huu9d3KO0Ut7DnO3Lzn29AEWHs10hCINxWybLr4ib11e+HA5O05TfP7N
15XvJzbztJLj72zDBqn8ZibrvSS3GSyWC4uLRAVMZ48+6ujK1hKqWo+OYhmOKc7t
crGi6klOlKGl1uF0QxzawT5YLnIgxQ+U4kmpTUwwuQENBFsTDdYBCADtoZh4Aooj
XhUHRILtGQiSTGu9AeK/lRwVKFIue9te75DPQ9zgqSkVsN9wgQ/7bRY4uyfKkc0H
gktmbgscb+PCOU7BKWk8sI34mGNTctPdieIKF3fr4IOGECe6OYckRwgVtJeBnGJb
dAFP+tQ8LjRytWVA+pdRb55EA9bSAweBpw8HjBj80i5wzLU/hfL7B4HKZT/7f/5q
i0fTNmpXuQKN+om0SxYLpPYDPgem26cCK/Tm/JXLwlL4ddGRAyJ9cE2omO66v8gk
OgukTy9QSi8m6i0pulzbICCkENUc6U6jJclLkFhsT0mH4anLL/no94KFRQ/QegFp
kJ0wc2pGDyj7ABEBAAGJATwEGAEIACYWIQTA1h082woujMd41uUFu6ctlIg0JQUC
WxMN1gIbDAUJAeEzgAAKCRAFu6ctlIg0JTTyB/9Oc+eTjzMAaF0qmGcfhQJ9j++v
YHiZs53VUzlZxEjrPU3XMnnb74bIlkb49SNZ9MnrzR5Wi0fViTGu5DXb+lpfgTHs
wGr6kzwHQBXcsZaUi+14SD4jqLZPpQhnUJY1QMjuugTXrzjVGXJvDngslD3XHXpU
PeqwgaP72Y2ZjFxGzUkcEd0WRYe74+Cz3gxEz9PnEMFm7u/jEK8RfR4fC90xZk+4
5H4XYQYMG+uQKbg98Jsou2IusvWKsKyJ9pl0Wnpqdf0MO52TFCDl4Tx0n1QIfFng
i09ig1F0Ln8LONLZsEr5bgmNSElberQa7P/nrayT0FfQzsbtLH4OM1ZNnyWg
=3DMwxD
-----END PGP PUBLIC KEY BLOCK-----

--------------95F8BCAA5DC85B56BF62A269--
