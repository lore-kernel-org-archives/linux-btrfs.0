Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpo46.poczta.onet.pl ([213.180.142.177]:38916 "EHLO
        smtpo46.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752789AbcL2Pup (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 10:50:45 -0500
Received: from [192.168.0.108] (unknown [193.200.46.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: webczat_200@poczta.onet.pl)
        by smtp.poczta.onet.pl (Onet) with ESMTPSA id 3tqDPH4sZ3zSvNcd9
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Dec 2016 16:42:11 +0100 (CET)
Subject: Fwd: problems with btrfs filesystem loading
References: <05893a24-2bf7-d485-1f9c-b10650419955@poczta.onet.pl>
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat_200@poczta.onet.pl>
Message-ID: <a971405b-d8c3-6af0-95bd-1ac5085ca349@poczta.onet.pl>
Date: Thu, 29 Dec 2016 16:42:09 +0100
MIME-Version: 1.0
In-Reply-To: <05893a24-2bf7-d485-1f9c-b10650419955@poczta.onet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L7uJ2NWvXlmguANKB5W7QHO7NhNRP4bF3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L7uJ2NWvXlmguANKB5W7QHO7NhNRP4bF3
Content-Type: multipart/mixed; boundary="E0UsSh7kxrVl5gwso7PMgrh6a9UX4tKha";
 protected-headers="v1"
From: =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat_200@poczta.onet.pl>
To: linux-btrfs@vger.kernel.org
Message-ID: <a971405b-d8c3-6af0-95bd-1ac5085ca349@poczta.onet.pl>
Subject: Fwd: problems with btrfs filesystem loading
References: <05893a24-2bf7-d485-1f9c-b10650419955@poczta.onet.pl>
In-Reply-To: <05893a24-2bf7-d485-1f9c-b10650419955@poczta.onet.pl>

--E0UsSh7kxrVl5gwso7PMgrh6a9UX4tKha
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Resending to btrfs list



--- Tre=C5=9B=C4=87 przekazanej wiadomo=C5=9Bci ---
To: linux-fsdevel@vger.kernel.org
From: Micha=C5=82 Zegan <webczat_200@poczta.onet.pl>
Subject: problems with btrfs filesystem loading
Message-ID: <05893a24-2bf7-d485-1f9c-b10650419955@poczta.onet.pl>
Date: Thu, 29 Dec 2016 16:24:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
Thunderbird/45.5.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=3Dpgp-sha256;
protocol=3D"application/pgp-signature";
boundary=3D"mQjxlXhkhghUxUDee2dbaL9BkEvBHD9kN"
X-ONET_PL-MDA-Received: ppn20v.m5r2.onet 23374

Hello.

I have odroid c2, processor architecture aarch64, linux kernel from
master as of today from http://github.com/torwalds/linux.git.
It seems that the btrfs module cannot be loaded. The only thing that
happens is that after modprobe i see:
modprobe: can't load module btrfs (kernel/fs/btrfs/btrfs.ko.gz): unknown
symbol in module, or unknown parameter
No errors in dmesg, like I have ignore_loglevel in kernel cmdline and no
logs in console appear except logs for loading dependencies like xor
module, but that is probably not important.
The kernel has been recompiled few minutes ago from scratch, the only
thing left was .config file. What is that? other modules load correctly
from what I can see.




--E0UsSh7kxrVl5gwso7PMgrh6a9UX4tKha--

--L7uJ2NWvXlmguANKB5W7QHO7NhNRP4bF3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFPBAEBCAA5FiEE8PeJXyv9t1Bfiq63mRxoPZnIFPkFAlhlLtIbHHdlYmN6YXRf
MjAwQHBvY3p0YS5vbmV0LnBsAAoJEJkcaD2ZyBT5S8kH/2Ts3s1FBVbouJF1TAUo
ZtyE6c3nvs/Q1AsjMgycIJpNAz6KamOjpEJESCF/rjQPaJh4S+HC6zDU9Z5XsUo7
H/7QNkEqZEWb6M8Vf8KPICzz5OiiwghpnImktY6INocRHnTicez+64XlsDYQokR/
w9mHVH/pZzRc700gmfXw1OezBPdJCbDfms/+ttoPU1Tj4b2qVLARZJV6H+3zwEZk
pK8yCg6SeZLGVDB1VJNgcZc4jzWfThMwrnIhr5QKjwPNTP/0KeJY4Dn75DxjI34g
wmfeKyeVjQNHmD5wCdjxKhMQvZeVXfWHc2O2y0qZr0qh2j9F7HNxo2VpzLP+dJrJ
SZ0=
=f7g3
-----END PGP SIGNATURE-----

--L7uJ2NWvXlmguANKB5W7QHO7NhNRP4bF3--
