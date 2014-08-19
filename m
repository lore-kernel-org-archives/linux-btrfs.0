Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64010 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaHSTFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 15:05:19 -0400
Received: by mail-ie0-f175.google.com with SMTP id x19so1697357ier.34
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 12:05:18 -0700 (PDT)
Message-ID: <53F39FE9.6000108@gmail.com>
Date: Tue, 19 Aug 2014 15:05:13 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: M G Berberich <btrfs@oss.m-berberich.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions on using BtrFS for fileserver
References: <20140819162151.GA15166@forwiss.uni-passau.de>
In-Reply-To: <20140819162151.GA15166@forwiss.uni-passau.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030209020801020202000904"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030209020801020202000904
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-19 12:21, M G Berberich wrote:
> Hello,
>=20
> we are thinking about using BtrFS on standard hardware for a
> fileserver with about 50T (100T raw) of storage (25=C3=974TByte).
>=20
> This is what I understood so far. Is this right?
>=20
> =C2=B7 incremental send/receive works.
>=20
> =C2=B7 There is no support for hotspares (spare disks that automaticall=
y
>   replaces faulty disk).
>=20
> =C2=B7 BtrFS with RAID1 is fairly stable.
>=20
> =C2=B7 RAID 5/6 spreads all data over all devices, leading to performan=
ce
>   problems on large diskarrays, and there is no option to limit the
>   numbers of disk per stripe so far.
>=20
> Some questions:
>=20
> =C2=B7 There where reports, that bcache with btrfs leads to corruption.=
 Is
>   this still so?
Based on some testing I did last month, bcache with anything has the
potential to cause data corruption.
>=20
> =C2=B7 If a disk failes, does BtrFS rebalance automatically? (This woul=
d
>   give a a kind o hotspare behavior)
No, but it wouldn't be hard to write a simple monitoring program to do
this from userspace.  IIRC, the big issue is that you need to add a
device in-place of the failed one for the re-balance to work.
>=20
> =C2=B7 Besides using bcache, are there any possibilities to boost
>   performance by adding (dedicated) cache-SSDs to a BtrFS?
Like mentioned in one of the other responses, I would suggest looking
into dm-cache.  BTRFS itself does not have any functionality for this,
although there has been talk of implementing device priorities for
reads, which could provide a similar performance boost.
>=20
> =C2=B7 Are there any reports/papers/web-pages about BtrFS-systems this =
size
>   in use? Praises, complains, performance-reviews, whatever=E2=80=A6
While it doesn't quite fit the description, I have had very good success
with a very active 2TB BTRFS RAID10 filesystem consisting of BTRFS on
four unpartitioned 1TB SATA III hard drives.  The filesystem gets in
excess of 100GB of data written to it each day (almost all rewrites
however), and is what I use for /home, /var/log, and /var/lib, and I've
had no issues with it that were caused by BTRFS, and in-fact, the very
fact that it uses BTRFS helped me recover data when the storage
controller they are connected to went bad.  On average, I get about 125%
of raw disk performance on writes, and about 110% on reads.

If you are using a very large number of disks, then I would not suggest
that you use BTRFS RAID10, but instead BTRFS RAID1, as RAID10 will try
to stripe things across ALL of the devices in the filesystem, and unless
you have no more than about four times as many disks as storage
controllers (that is, each controller has no more than four disks
attached to it), the overhead outweighs the benefit of striping the data.=


Also, just to make sure it's clear, in BTRFS RAID1, each block gets
written EXACTLY twice.  On the plus side though, this means that if you
do set-up a caching mechanism, you may be able to keep most of the array
spun down a majority of the time.


--------------ms030209020801020202000904
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwODE5MTkwNTEz
WjAjBgkqhkiG9w0BCQQxFgQUDpOTW8c380e21rBCucaDc+gZrLQwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAF0NhXvaVfez7J8a6zMx48Qp6pSIn
sM9aVrCOqJ2MQ9IsEi7/Cf4cRcXSiZDzIBPlL+6TBRZSZsxo817HGQ8fx1RWVbfyr9aaixLz
VNu158tHA+GlH+qxewsH4hJpAyM5HKp649wVLcfqYChUf7Y5LzJG8232Ij6N6i8M8XLTyg+m
LSAU27B5f6M5Yb553STdUrzTwCEGHbXM/H+3IuaK1hf40xnYnjZX2JrEV/VLW9OXDhjWayx+
x8RK/4qz2VuOLyzTS5zIBrLj9qiSOVvpf7KRW1O2OVrMv6EdhtboESHeTHoVMCaFjcv6pmzn
34sBUllpUKpKDQ3VtESLFaiXWQAAAAAAAA==
--------------ms030209020801020202000904--
