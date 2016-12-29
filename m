Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpo76.poczta.onet.pl ([141.105.16.26]:43276 "EHLO
        smtpo76.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752734AbcL2Rxb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 12:53:31 -0500
Subject: Re: problems with btrfs filesystem loading
To: Roman Mamedov <rm@romanrm.net>
References: <05893a24-2bf7-d485-1f9c-b10650419955@poczta.onet.pl>
 <a971405b-d8c3-6af0-95bd-1ac5085ca349@poczta.onet.pl>
 <20161229215350.76a455b4@natsu>
Cc: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat_200@poczta.onet.pl>
Message-ID: <07982be9-4d1a-71b5-8b70-b9fcbc12b891@poczta.onet.pl>
Date: Thu, 29 Dec 2016 18:44:35 +0100
MIME-Version: 1.0
In-Reply-To: <20161229215350.76a455b4@natsu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NMK9IFmI2jN8OMTvkif7gbx2cQcpKMqxf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NMK9IFmI2jN8OMTvkif7gbx2cQcpKMqxf
Content-Type: multipart/mixed; boundary="M6CjQAqtTQBTLDHEtaiUocCW0i884QrAu";
 protected-headers="v1"
From: =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat_200@poczta.onet.pl>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <07982be9-4d1a-71b5-8b70-b9fcbc12b891@poczta.onet.pl>
Subject: Re: problems with btrfs filesystem loading
References: <05893a24-2bf7-d485-1f9c-b10650419955@poczta.onet.pl>
 <a971405b-d8c3-6af0-95bd-1ac5085ca349@poczta.onet.pl>
 <20161229215350.76a455b4@natsu>
In-Reply-To: <20161229215350.76a455b4@natsu>

--M6CjQAqtTQBTLDHEtaiUocCW0i884QrAu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

That seems to do the trick, thanks

W dniu 29.12.2016 o 17:53, Roman Mamedov pisze:
> On Thu, 29 Dec 2016 16:42:09 +0100
> Micha=C5=82 Zegan <webczat_200@poczta.onet.pl> wrote:
>=20
>> I have odroid c2, processor architecture aarch64, linux kernel from
>> master as of today from http://github.com/torwalds/linux.git.
>> It seems that the btrfs module cannot be loaded. The only thing that
>> happens is that after modprobe i see:
>> modprobe: can't load module btrfs (kernel/fs/btrfs/btrfs.ko.gz): unkno=
wn
>> symbol in module, or unknown parameter
>> No errors in dmesg, like I have ignore_loglevel in kernel cmdline and =
no
>> logs in console appear except logs for loading dependencies like xor
>> module, but that is probably not important.
>> The kernel has been recompiled few minutes ago from scratch, the only
>> thing left was .config file. What is that? other modules load correctl=
y
>> from what I can see.
>=20
> In the past there's been some trouble with crc32 dependencies:
> https://www.spinics.net/lists/linux-btrfs/msg32104.html
> Not sure if that's relevant anymore, but in any case, check if you have=

> crc32-related stuff either built-in or compiled as modules, if latter, =
try
> loading those before btrfs (/lib/modules/*/kernel/crypto/crc32*)
>=20


--M6CjQAqtTQBTLDHEtaiUocCW0i884QrAu--

--NMK9IFmI2jN8OMTvkif7gbx2cQcpKMqxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFPBAEBCAA5FiEE8PeJXyv9t1Bfiq63mRxoPZnIFPkFAlhlS4QbHHdlYmN6YXRf
MjAwQHBvY3p0YS5vbmV0LnBsAAoJEJkcaD2ZyBT5QJ4H/3TGYoA+jjoGVGQIuy7X
0qYWx1UMvy0wRHC6xJWPNXIHm1ElIGMI3DcBxdylMlr4Fl30+liNXhPT42AQKDte
5q1ZMT9gsI/YB2E6QbQCA+qx9VZyQzPw2+XE64hZ2cwiaEJg3fFojWI76g6QN9MP
MTLGQKDxo9FjLLPaVPOqy/eMJjpdZqWumsDNmgD7iD3u5aYlsXOnOCzMuZhlWuVe
7pN6INz6B7T0kpfJuJprXoWX1fr+GPe0O94TOtBN4jDy20OxZUGcw9h3TPqEBN7J
uwWS4Ouddu7foOeJhEMggjxEKGgm3E8TS1+Q+88oUYGJI6VpUDxEZ1t12hPeUvMb
PyA=
=DLHH
-----END PGP SIGNATURE-----

--NMK9IFmI2jN8OMTvkif7gbx2cQcpKMqxf--
