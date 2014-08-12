Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:46968 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaHLReS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 13:34:18 -0400
Received: by mail-yk0-f181.google.com with SMTP id q200so7310062ykb.26
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 10:34:17 -0700 (PDT)
Message-ID: <53EA5015.4060200@gmail.com>
Date: Tue, 12 Aug 2014 13:34:13 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: David Pottage <david@chrestomanci.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas for a feature implementation
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E83035.8010603@gmail.com> <53EA3852.2000607@chrestomanci.org>
In-Reply-To: <53EA3852.2000607@chrestomanci.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070309060407020509080000"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070309060407020509080000
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-12 11:52, David Pottage wrote:
>=20
> On 11/08/14 03:53, Austin S Hemmelgarn wrote:
>=20
>> Another thing that isn't listed there, that I would personally love to=

>> see is support for secure file deletion.  To be truly secure though,
>> this would need to hook into the COW logic so that files marked for
>> secure deletion can't be reflinked (maybe make the automatically NOCOW=

>> instead, and don't allow snapshots?), and when they get written to, th=
e
>> blocks that get COW'ed have the old block overwritten.
> How would secure deletion interact with file de-duplication?
>=20
> For example suppose you and I are both users on a multi user system. We=

> both obtain copies of the same file independently, and save that file t=
o
> our home directories.
>=20
> A background process notices that both files are the same and
> de-duplicates them. This means that both your file and mine point to th=
e
> same blocks on disc. This is exactly the same as would happen if you
> made a COW copy of your file, transferred ownership to me, and I moved
> it into my home dir.
>=20
> You then decide to secure delete your copy of the file. What happens to=

> mine? If it gets removed, then you have just deleted a file you don't
> own, if it does not then the file-system has broken the contract to
> secure delete a file when you asked it to.
>=20
> Also, what happens if the two files have similar portions, but they are=

> not identical. For example, if you download and ISO image for ubuntu,
> and I download the ISO for kubuntu (at the same version). There will be=

> a lot of sections that are the same, because they will contain a lot of=

> packages in common, so there will be large gains in de-duplicating the
> similar parts, but most people would consider the files to be different=
=2E
>=20
> Could this mean that if you secure delete your ubuntu iso, then portion=
s
> of my kubuntu iso might become corrupt?
>=20
You could work around this by marking the extent, instead of the file
(marking a file would mark all of it's extents), and then checking for
that marking when the extent is freed (ie, nobody refers to it anymore).
While this approach might not seem useful to most people, there are
practical use cases for it (even without whole disk encryption).
It would be pretty easy actually to integrate this globally for a
file-system as a mount option.
> Even if we limit secure delete to root, then we still leave the risk of=

> unintentonaly breaking user files, because non-one realised that all or=

> part of the file appears in other files via de-duplication. In any case=

> if secure delete is limited to root, then most people would not find it=

> useful. (or they would use sudo to do it, which brings us back to the
> same problems).
>=20
> Basically, I think that file secure deletion as a concept is not
> compatible with a 5th generation file system. If you relay want to
> securely remove a file, then copy the stuff you need elsewhere, and put=

> the disc in the crusher. Alternatively put the filesystem in an encypte=
d
> container, and then reformat the disc with a different encryption key.
>=20
While I agree that the traditional notion of secure deletion doesn't fit
in the current generation of file systems, there is still a need for COW
filesystems to be able to prevent sensitive data from being exposed
during run-time.  On any current BTRFS filesystem, it is still possible
to find blocks that have been COW'ed (assuming discard is turned off)
and have no referents, possibly long after the block itself is freed,
and especially if the volume is much larger than the stored data set
(like a large majority of desktop users these days) or the workload is
not write intensive.


--------------ms070309060407020509080000
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwODEyMTczNDEz
WjAjBgkqhkiG9w0BCQQxFgQUo8kWed2HW6JVpwgoTfSVmxZ6r7wwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEASFPB/t9OU9isaL7fHHhi6GeGmZMn
ToXFZCcp15bOjFLjICNo78yWAkIbyO2Er1jZjppbODWnfQVV5Y6njIITUFQm+a7HOIYBkSaT
smJxeiERPgstQJzjfyyaBRqcjP6Iip4LmLm/HqZ77MjnYC3bEgg6uaPsmX6SBvadTkcaZ9b5
hC3MBCdQVozRL6oocBlNMgMs9iUjO/dhFkN6gPEmoZ4wSvRQJbMKsYQN4Z4vPqlGWKfHzTE3
op/YCHSzfbWQ0TIiW92wIWR9dZaymV3IjrSQfol/M48rpTE42XgB5gAfzPrIBZMRHs7UhaTl
e0MtUpcdjhue9c/nqWvmeYfcWwAAAAAAAA==
--------------ms070309060407020509080000--
