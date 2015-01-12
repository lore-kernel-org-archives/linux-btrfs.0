Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:63436 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbbALQnp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 11:43:45 -0500
Received: by mail-ig0-f175.google.com with SMTP id h15so12331179igd.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 08:43:45 -0800 (PST)
Message-ID: <54B3F9BA.3060503@gmail.com>
Date: Mon, 12 Jan 2015 11:43:38 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "P. Remek" <p.remek1@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs performance - ssd array
References: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>	<54B3E03E.80606@gmail.com> <CABdHLQ6b_PpaMK7n+NhU5qV9UvtanqJcpn8y1vpM84h9RGSXDQ@mail.gmail.com>
In-Reply-To: <CABdHLQ6b_PpaMK7n+NhU5qV9UvtanqJcpn8y1vpM84h9RGSXDQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030707090005080103050105"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030707090005080103050105
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-01-12 10:35, P. Remek wrote:
>> Another thing to consider is that the kernel's default I/O scheduler a=
nd the default parameters for that I/O scheduler are almost always subopt=
imal for SSD's, and this tends to show far more with BTRFS than anything =
else.  Personally >I've found that using the CFQ I/O scheduler with the f=
ollowing parameters works best for a majority of SSD's:
>> 1. slice_idle=3D0
>> 2. back_seek_penalty=3D1
>> 3. back_seek_max set equal to the size in sectors of the device
>> 4. nr_requests and quantum set to the hardware command queue depth
>
> I will give these suggestions a try but I don't expect any big gain.
> Notice that the difference between EXT4 and BTRFS random write is
> massive - its 200 000 IOPs vs. 15 000 IOPs and the device and kernel
> parameters are exactly the same (it is same machine) for both test
> scenarios. It suggests that something is taking down write performance
> in the Btrfs implementation.
>
> Notice also that we did some performance tuning ( queue scheduling set
> to noop, irq affinity distribution and pinning to specific numa nodes
> and cores etc.)
>
The stuff about the I/O scheduler is more general advice for dealing=20
with SSD's than anything BTRFS specific.  I've found though that on SATA =

(I don't have anywhere near the kind of budget needed for SAS disks, and =

even less so for SAS SSD's) connected SSD's at least, using the no-op=20
I/O scheduler get's better small burst performance, but it causes=20
horrible latency spikes whenever trying to do something that requires=20
bulk throughput with random writes (rsync being an excellent example of=20
this).

Something else I thought of after my initial reply, due to the COW=20
nature of BTRFS, you will generally get better performance of metadata=20
operations with shallower directory structures (largely because mtime=20
updates propagate up the directory tree to the root of the filesystem).


--------------ms030707090005080103050105
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTEyMTY0MzM4
WjAjBgkqhkiG9w0BCQQxFgQU+KeNppOk2J75/3XBPnhrgy3vxWwwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAnYhkhKoxHzCXKRxa24yVTT/b8Lma
sL/L3lB5Baw4/ihWkzAoaXbuuW89BweUqTPQwEtiHaBEAm2li61Zthb44HEIg/vPUH6g+H2Z
NOyIxVfenVch3MtxCbMqHmhFmSAKLb9wTE6gno+hLlopPDFOmSOHc94ZxQJQpl4Q37Etya83
Qlev72uf+XX5xIpe2RJQ2YqoPhELQBd/jKsy9Fsp/kU9vNCJPGG+r3heeHEFw39mXUwcPsWo
ZTTDZ6k0J2kpIj0qEYPbGEF6Pkn9CpmVXwTZXnSRWHWjmCJLY9OO6jbfOz2y+kDV8xrqrtPp
gmsuA2BX0RuW3qbkfaw4AYFPLwAAAAAAAA==
--------------ms030707090005080103050105--
