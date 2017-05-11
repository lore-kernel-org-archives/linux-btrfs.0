Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrechner.de ([89.146.220.106]:55653 "EHLO mailrechner.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754872AbdEKRrj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 13:47:39 -0400
Received: from p4fd21f2a.dip0.t-ipconnect.de ([79.210.31.42] helo=[192.168.2.190])
        by mailrechner.de with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.69)
        (envelope-from <robert.mader@liqd.de>)
        id 1d8qmm-0007ao-3Y
        for linux-btrfs@vger.kernel.org; Thu, 11 May 2017 18:17:58 +0200
To: linux-btrfs@vger.kernel.org
From: Robert Mader <robert.mader@liqd.de>
Subject: Qgroup reserved space like in ZFS?
Message-ID: <cf95a201-a8c5-ad94-3a98-81e55bf63a6c@liqd.de>
Date: Thu, 11 May 2017 18:17:46 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qUgwnIGVg4l55chDkFWBD0fcbQLcLleAs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qUgwnIGVg4l55chDkFWBD0fcbQLcLleAs
Content-Type: multipart/mixed; boundary="UUq17k4RLbiAB8KLSwlioUfbOKoqUSqoq";
 protected-headers="v1"
From: Robert Mader <robert.mader@liqd.de>
To: linux-btrfs@vger.kernel.org
Message-ID: <cf95a201-a8c5-ad94-3a98-81e55bf63a6c@liqd.de>
Subject: Qgroup reserved space like in ZFS?

--UUq17k4RLbiAB8KLSwlioUfbOKoqUSqoq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hello everyone,

I just wanted to ask a short question as I couldn't find a clear answer
anywhere on the net, yet:

Is it currently possible to reserve space for a BTRFS subvolume?



Following example: I have two subvolumes, one for root and one for home

I'd like to reserve 2GB of space for my root volume so even if my home
volume fills up, it can never starve my root subvolume.
But I don't want to set a fixed limit on my home partition, I want both
subvolumes to be able to grow and shrink dynamically.

I use that functionality a lot on ZFS-based systems like FreeNAS. In the
the web-interface of FreeNAS one can easily configure things like that.


If I get it right, qgroups actually already create things like a global
reserve. Therefor the functionality seems to be there. Is there a way to
use it, just like the limit functionality? Or is it planed?

Thanks in advance and regards,
Robert


--UUq17k4RLbiAB8KLSwlioUfbOKoqUSqoq--

--qUgwnIGVg4l55chDkFWBD0fcbQLcLleAs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIyBAEBCAAcBQJZFI6qFRxyb2JlcnQubWFkZXJAbGlxZC5kZQAKCRDMSS+pk0gg
dbeUD/sEOFuD7/9CQ+qW+Gm1QJlYwNFykCpVgI9DkjX5UbUaWqnrVlmqRr2dYpFL
XKNgxq+kSkQ0IOnE+jf+QiMzgjNpxy2DkAcNE6D6UR1grYtXzUoylUn2Z0sACuiT
YIR1qSUU966BiaN0/aVDcPUS76uKfEYoqjX7t4RsNekPTlDMkPxG7ZWrBiT1U9HX
HxJhJ6EAix1+Sfd0Qms6nliZSs8aLaJRrAKI4MxNd1y308zjYIbR+D06rMBZAXEO
6hFoVuMQznU9P18vz8kgEbe2z7++/yvM+yFhgLj3s3UMZAeWLe0fYbQ9Dx+8d+4c
tptzKgcs91LeodAuT4bNL9hmQP60biLXjChHFaChSkIxPg4wHc1jyCbqaxFI1s7y
MeP+kQdxYXMCWDxtQYOKC7jzr638747TSbFBNbRjyK1PKrvYxm4yqjHFB+dXCm55
irgzxENfzCsjlZgt7BDOyZcGphfFHsv86zi82obDw3bNHsaf24dl1oewpmjz4E/v
sXSVxjLsvQh3AMAdIy11GfKFbFFdmyOtZLzlHu4YgQ1+68Y8jeR60wXVV3PGDEqB
27vjOxYWMhZ2R3M+lkJJ3DEqzdWRjO87Jjqk+6pN2QbrZxcP5iEgapzVh1y0fUiM
IE/wlRQVS0c5RmJ3ASzZ7CIbt4tOSTqfyw+KlwY5qt5lur74Mw==
=BP9H
-----END PGP SIGNATURE-----

--qUgwnIGVg4l55chDkFWBD0fcbQLcLleAs--
