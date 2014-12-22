Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35376 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaLVUoT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 15:44:19 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so5049537ieb.35
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:44:19 -0800 (PST)
Message-ID: <5498829E.3060608@gmail.com>
Date: Mon, 22 Dec 2014 15:44:14 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Richard Sharpe <realrichardsharpe@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>	<54982A79.1090102@gmail.com>	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>	<54985E4C.40003@gmail.com>	<CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com> <CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>
In-Reply-To: <CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000102010903060203010504"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000102010903060203010504
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-22 15:06, Richard Sharpe wrote:
> On Mon, Dec 22, 2014 at 10:43 AM, Chris Murphy <lists@colorremedies.com=
> wrote:
>> On Mon, Dec 22, 2014 at 11:09 AM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>
>>> Personally, I'd love to see unlimited length xattr's like NTFS and HF=
S+ do,
>>> as that would greatly improve interoperability (both Windows and OS X=
 use
>>> xattrs, although they call them 'alternative data streams' and 'forks=
'
>>> respectively), and provide a higher likelihood that xattrs would star=
t
>>> getting used more.
>>
>> This is two years old, but it looks like NFS will not support xattr.
>> http://comments.gmane.org/gmane.linux.nfs/53259
>>
>> It looks like SMB does support xattr (and sometimes requires it) but I=

>> have no idea to what degree, including the host/client preservation on=

>> different filesystems. [1] It would still be helpful for cp and rsync
>> to be able to preserve xattr, however Apple has moved to a new on-disk=

>> format that makes the future of reading OS X volumes on Linux an open
>> question. [2]
>
> Those are the old OS 2 XATTRs, better known as EAs, and NTFS says that
> you can support EAs or you can have Reparse Points, but not both
> (basically, they re-used the EA Length field as the reparse tag).
> Also, Windows (of any flavor) does not make it easy to access EAs.
>
But OS/2 style XATTRS are not the same as NTFS Alternative Data Streams, =

which technically (because of Windows backward compatibility interfaces) =

don't need a huge amount of support from SMB.  They were originally=20
added to support SFM in NT3.1, so that windows could store resource=20
forks.  The two primary uses on windows today are the file history=20
interface in Win8/8.1 and the 'zone_identifier' saved with downloads by=20
most modern browsers.  They're actually pretty easy to get to, you just=20
append the ADS name to the end of the filename with a : separating them, =

and you can access it like a regular file (which is part of why : isn't=20
a legal character in a windows filename).  Most people don't know about=20
them because they don't get listed in windows explorer, even with hidden =

files and protected OS file visible.  The actual on-disk format for them =

is actually kind of interesting, the file data itself (what in the Apple =

world is called the Data Fork) is actually stored as an unnamed ADS=20
associated with the filename.


--------------ms000102010903060203010504
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjIyMjA0NDE0
WjAjBgkqhkiG9w0BCQQxFgQUctZVJ6wyR5FBvel0NfrCUgkLOtwwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAKYeEOVLx6aUOYBWzqV9NzRM2pJ3x
WaNTOTgBnnFeZHiQz/UrXw0b5An17yjJZMP8XZsKtK3q+23voX9l+V/pmRNRYBckyZRWO1o9
dVORejvrMZUGhwHR2Xp2QpBs+Fde85rCQZc+G0xLririO0QwAYhMPsJqxQHq99aJrWiZniyl
T/+Px4Jx3CAxYKuBqtUMqoFOzeowBxufA3hwJEf9Hi/V/Idi5nX41KcDoO9jQ/TEBiHoH3yK
x3SN57T9FpoL1lERF5OSwjf5t/dAXdhWboPqe+Pqww7ZHD8oY4zvhvaFEz+vqzr6s3Ddps0C
HAiF03ogdDQjyl66P2H90VsGtQAAAAAAAA==
--------------ms000102010903060203010504--
