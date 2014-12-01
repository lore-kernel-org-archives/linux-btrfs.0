Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:53735 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbaLAUgA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 15:36:00 -0500
Received: by mail-ig0-f178.google.com with SMTP id hl2so9592789igb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 12:36:00 -0800 (PST)
Message-ID: <547CD129.2030007@gmail.com>
Date: Mon, 01 Dec 2014 15:35:53 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Brendan Hide <brendan@swiftspirit.co.za>,
        Chris Mason <clm@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <1416859665.3019.6@mail.thefacebook.com> <20141125164717.GK26471@twin.jikos.cz> <5475D7F3.4040408@swiftspirit.co.za> <5475DC9A.3060003@gmail.com> <20141201183729.GM12140@twin.jikos.cz>
In-Reply-To: <20141201183729.GM12140@twin.jikos.cz>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090401030703090909090001"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090401030703090909090001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-01 13:37, David Sterba wrote:
> On Wed, Nov 26, 2014 at 08:58:50AM -0500, Austin S Hemmelgarn wrote:
>> On 2014-11-26 08:38, Brendan Hide wrote:
>>> On 2014/11/25 18:47, David Sterba wrote:
>>>> We could provide an interface for external applications that would m=
ake
>>>> use of the strong checksums. Eg. external dedup, integrity db. The
>>>> benefit here is that the checksum is always up to date, so there's n=
o
>>>> need to compute the checksums again. At the obvious cost.
>>>
>>> I can imagine some use-cases where you might even want more than one
>>> algorithm to be used and stored. Not sure if that makes me a madman,
>>> though. ;)
>>>
>> Not crazy at all, I would love to have the ability to store multiple
>> different weak but fast hash values.  For example, on my laptop, it is=

>> actually faster to compute crc32c, adler32, and md5 hashes together th=
an
>> it is to compute pretty much any 256-bit hash I've tried.
>
> Well, this is doable :) there's space for 256 bits in general, the orde=
r of
> checksum bytes in one "checksum word" would be given by fixed order the=

> algorighms are defined. The code complexity would increase, but not tha=
t
> much I think.
>
>> This then brings up the issue of what to do when we try to mount such =
a
>> fs on a system that doesn't support some or all of the hashes used.
>
> I see two modes: first fail if all not present, or relaxed by a mount
> option to accept at least one.
>
> But let's keep this open, I'm not yet convinced that combining more wea=
k
> algos makes sense from the crypto POV. If this should protect against
> random bitflips, would one fast-but-weak be comparable to a combination=
?
> Or other expectations.
>
My only reasoning is that with this set of hashes (crc32c, adler32, and=20
md5), the statistical likely-hood of running into a hash collision with=20
more than one of them at a time is infinitesimally small compared to the =

likely-hood of any one of them having a collision (or even compared to=20
something ridiculous like the probability of being killed by a meteor=20
strike), and the combination is faster on most systems that I have tried =

than many 256-bit crypto hashes.

It's still a tradeoff though, I also think that the idea mentioned=20
elsewhere in this thread of having separate hashes stored for=20
subsections of the same block is also worth looking at.


--------------ms090401030703090909090001
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjAxMjAzNTUz
WjAjBgkqhkiG9w0BCQQxFgQUn8pXS4NzpXm1yOOvsZnToingQswwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAJSjrZJpmZMIMFuArKUi8QZeybEpH
FlIG5NgldXXfLppEqkYsz/ZHEYn3MlMRXBYyy5uAg5GdGJbS++hE0wrXqYg9LoL5f15QChh0
jJtTWYxpURkjIx5ygoihffI+f+4n7mbhAgWsUZeQtXSo3D9HACkKVKjRoSygpt5LyjmZYuEF
0L+woRUO2MfNDlbGFrAXu8oICxiP0yDzJRAEX544+PdReAHefENxWYod6fPvYX++NyIbuVuB
wYqlvxo1ptbQyCiq8Qg6ljFGH5iXBX9hao8xmkBSvEiujSMACE4t4hqvIVo+oUCmeqlxVK/w
l5HCcSrbZY5BV1xaTqLSsjvsmwAAAAAAAA==
--------------ms090401030703090909090001--
