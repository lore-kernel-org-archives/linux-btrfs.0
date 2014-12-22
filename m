Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39477 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVUdn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 15:33:43 -0500
Received: by mail-ie0-f177.google.com with SMTP id rd18so4953720iec.36
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:33:42 -0800 (PST)
Message-ID: <54988021.8010408@gmail.com>
Date: Mon, 22 Dec 2014 15:33:37 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Richard Sharpe <realrichardsharpe@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>	<54982A79.1090102@gmail.com>	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>	<54985E4C.40003@gmail.com> <CACyXjPwstBv92VL_Q5w=NqNfAO-WUU1-7vf30Rt7NjwKeTQfeA@mail.gmail.com>
In-Reply-To: <CACyXjPwstBv92VL_Q5w=NqNfAO-WUU1-7vf30Rt7NjwKeTQfeA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030402010701000802010905"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030402010701000802010905
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-22 15:04, Richard Sharpe wrote:
> On Mon, Dec 22, 2014 at 10:09 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2014-12-22 12:27, Richard Sharpe wrote:
>>>
>>> On Mon, Dec 22, 2014 at 6:28 AM, Austin S Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>>
>>>> On 2014-12-19 21:07, Richard Sharpe wrote:
>>>>>
>>>>>
>>>>> Hi folks,
>>>>>
>>>>> I need a Linux file system that supports XATTRs up to 64K.
>>>>>
>>>>> Can BTRFS support that or is XFS the only Linux file system with su=
ch
>>>>> support?
>>>>>
>>>> At the moment, BTRFS is limited to xattrs that fit inline in the met=
adata
>>>> nodes (so ~3900 bytes for a 4k leafsize).
>>>>
>>>> XFS, however, isn't the only Linux filesystem that supports xattrs t=
hat
>>>> size.  Assuming that you are using a recent kernel, you can also use=
 such
>>>> xattrs on at least:
>>>>    * XFS
>>>>    * JFS
>>>>    * ext4
>>>>    * reiserfs (I think, not 100% certain about this one though)
>>>>    * OCFS2 (even though it is technically a cluster fs, it can be ru=
n
>>>> single
>>>> node without the clustering)
>>>>    * ZFS (IIRC, ZFS supports unlimited xattr size)
>>>>    * NTFS (no limit on xattr size, though you should use NTFS-3G ins=
tead
>>>> of
>>>> the in-kernel driver)
>>>>    * SquashFS (read-only)
>>>>    * HFS+ (Also no limit on xattr size)
>>>> Of these, I'd personally suggest using XFS unless you need to be abl=
e to
>>>> shrink the filesystem, in which case I'd suggest ext4.
>>>
>>>
>>> Thanks for the info. I hadn't realized that ext4 had lifted the
>>> restriction.
>>>
>> Yeah, it would be nice if there was more clarity in the documentation.=

>>
>> Personally, I'd love to see unlimited length xattr's like NTFS and HFS=
+ do,
>> as that would greatly improve interoperability (both Windows and OS X =
use
>> xattrs, although they call them 'alternative data streams' and 'forks'=

>> respectively), and provide a higher likelihood that xattrs would start=

>> getting used more.
>
> Well, there is a big difference in the semantics of Alternate Data
> Streams (ADSs) and XATTRs.
>
> For example, you can seek on an ADS and read at any offset. You cannot
> do that on an XATTR (at least, not with the semantics provided by the
> UNIX interface.)
>
I'm not trying to say the semantics are identical, just that the=20
functionality is pretty similar.  A better way to put it would be that=20
xattrs are an extremely limited form of ADS/Forks.


--------------ms030402010701000802010905
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjIyMjAzMzM3
WjAjBgkqhkiG9w0BCQQxFgQUMz1MKtjFugSxtoaDRwaO0Qmg8AgwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEA0hVrMGtbvwI7mMpVgQB/ryGrrvuI
3XuTZ1uqFTCSVoHt1QLa7vSu+Qbx7jUWBIQPpQG8kyVyH5ElE8/R01isF/zYqm7vbyl3AhHX
tGjyC4jra5bhmvHL2c4vnKXJQI7RHVXIOaXjnb3ocCmJMyBO5R3Mp6P0XBOc/xfPv/wzbhcP
7lBkz/YjXwZODucF85hRTxTnv0gCqlhlfo/SpBdYxNi6IopRyMwnVXx1BaXuuagpd12vZzzs
r55mYt9kDEtifesI4yYCy7EICOGj5aeMybBIyK7eFcNMRH8DascOQ8dNY2TBce21BKo+WaD2
VC//Sfjt+/bVP7UGkv6inXMVRAAAAAAAAA==
--------------ms030402010701000802010905--
