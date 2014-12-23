Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61948 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbaLWMhj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 07:37:39 -0500
Received: by mail-ie0-f173.google.com with SMTP id y20so5888489ier.18
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 04:37:38 -0800 (PST)
Message-ID: <5499620D.8090909@gmail.com>
Date: Tue, 23 Dec 2014 07:37:33 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>	<54982A79.1090102@gmail.com>	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>	<54985E4C.40003@gmail.com>	<CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>	<CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>	<5498829E.3060608@gmail.com>	<5498A0BD.3000300@pobox.com> <CACyXjPyVNGQLc6g4jGnDo=FM20qoyAfsk96zrkQfCYrjhOvMFg@mail.gmail.com> <5498B26C.5010908@pobox.com>
In-Reply-To: <5498B26C.5010908@pobox.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080202000807080805060108"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080202000807080805060108
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-22 19:08, Robert White wrote:
> On 12/22/2014 02:55 PM, Richard Sharpe wrote:
>> On Mon, Dec 22, 2014 at 2:52 PM, Robert White <rwhite@pobox.com> wrote=
:
>>> So skipping the full ADS, what's the current demand/payoff for large
>>> XATTR space?
>>
>> Windows Security Descriptors (sometimes incorrectly called ACLs)
>> stored by Samba.
>
> Ah.
>
> I know that Linux ACLs are fairly small per entry, I take it Windows'
> can be much bigger?
>
> Having just gone off an read a lot about the many ADS possible in
> windows, they've sort of treated ever file as if it were the name of a
> phantom directory limited depth... That is you seem to be able to creat=
e
> any name as a stream name but you can't create any pathname as same.
>
> The system-level API -- that is the complete retooling of SYS_open et a=
l
> -- and the requsite departure from POSIX -- seems unlikely.
>
> On the antipode, it seems like being able to put an inode reference key=

> type (e.g. a name,inode pair as one of the metadata entries) could
> relieve the space constraint for a limited number of entires. The
> contents of that inode's data region would become the value of the
> single attribute.
>
> Does that relieve Security Descriptor burden? Is each descriptor a
> separate attribute or are all the descriptors held in one attribute as =
a
> list-of?
>
> Going full "phantom directory" to match Windows just seems like we get
> into the business of replacing whole kernel tidbits a la the
> inner-system effect.
>

Personally, I'm thinking something more like the OS X Forks API than the =

Windows ADS API.  Forks are actually the original reason that windows=20
added ADS to NTFS, and their API is much cleaner than the windows one.=20
The standard there is that forks are accessible as=20
'<filename>/..namedfork/<forkname>'  ..namedfork doesn't get listed by=20
ls -a, but you can explicitly list '<filename>/..namedfork/' to get a=20
list of forks other than the data fork.  Such an API needs almost zero=20
modification to existing programs (just enough to get tar and friends to =

check if there are any named forks for each file).

The significant advantages I see to having forks are:
  1. Windows Security Descriptors
  2. Macintosh Resource Forks
  3. BeOS (and others) style associated metadata (ie, associated file=20
icons/thumbnails, per-file program associations, in other words, the=20
same sort of stuff that OSX uses resource forks for)
  4. Better flexibility for stuff like IMA and EVM



--------------ms080202000807080805060108
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjIzMTIzNzMz
WjAjBgkqhkiG9w0BCQQxFgQUQD7OSHRXfr5ylGKyubQRvBCLLFswbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAGU5asjFIN+bIdtMA8EaUmng0oVSI
v8Ne2SLVwmGqB/IwrLnYzbJHCDivFIqd56uttL8Wvh4b+5+bWX9HYJFjBbZcDURQspnsU/f2
QJLzhmips+HslVb+qXXi/ieMGSLbjFAMwW1W0BJqcyIV2q8Xw2uOoIRQibJSSESaGvOLVDBm
8FTZ76v6R7z1d4se+I7p5zSUglQmoSQ/16Z/UEa0+1haa6+4/9Fa6aQCK8FUsC5wYjQ6fsX7
OLKr+UlXrJZwevXdrNB+/yAk77+g8Rfr4/boCa8P1YsRhfeHA9z5txRuxRVp1W7a0YX+oRaD
I1rvWU5xX92qtVwOzSknSJW/4AAAAAAAAA==
--------------ms080202000807080805060108--
