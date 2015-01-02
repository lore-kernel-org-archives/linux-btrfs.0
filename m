Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:32892 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbABTlO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 14:41:14 -0500
Received: by mail-ie0-f169.google.com with SMTP id y20so17140481ier.14
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Jan 2015 11:41:14 -0800 (PST)
Message-ID: <54A6F456.6090701@gmail.com>
Date: Fri, 02 Jan 2015 14:41:10 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>, ashford@whisperpc.com,
        Phillip Susi <psusi@ubuntu.com>
CC: Jose Manuel Perez Bethencourt <jmperezbeth@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        "sys.syphus" <syssyphus@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: I need to P. are we almost there yet?
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>    <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>    <54A31CAE.4020606@ubuntu.com>    <40b56c60ddd4801295a92c4b11d5c08e.squirrel@webmail.wanet.net>    <54A3633C.3040609@ubuntu.com> <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net> <54A6A05D.6000200@gmail.com> <54A6D951.9080706@swiftspirit.co.za>
In-Reply-To: <54A6D951.9080706@swiftspirit.co.za>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030807070603030002030107"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030807070603030002030107
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-01-02 12:45, Brendan Hide wrote:
> On 2015/01/02 15:42, Austin S Hemmelgarn wrote:
>> On 2014-12-31 12:27, ashford@whisperpc.com wrote:
>>> I see this as a CRITICAL design flaw.  The reason for calling it
>>> CRITICAL
>>> is that System Administrators have been trained for >20 years that
>>> RAID-10
>>> can usually handle a dual-disk failure, but the BTRFS implementation =
has
>>> effectively ZERO chance of doing so.
>> No, some rather simple math
> That's the problem. The math isn't as simple as you'd expect:
>
> The example below is probably a pathological case - but here goes. Let'=
s
> say in this 4-disk example that chunks are striped as d1,d2,d1,d2 where=

> d1 is the first bit of data and d2 is the second:
> Chunk 1 might be striped across disks A,B,C,D d1,d2,d1,d2
> Chunk 2 might be striped across disks B,C,A,D d3,d4,d3,d4
> Chunk 3 might be striped across disks D,A,C,B d5,d6,d5,d6
> Chunk 4 might be striped across disks A,C,B,D d7,d8,d7,d8
> Chunk 5 might be striped across disks A,C,D,B d9,d10,d9,d10
>
> Lose any two disks and you have a 50% chance on *each* chunk to have
> lost that chunk. With traditional RAID10 you have a 50% chance of losin=
g
> the array entirely. With btrfs, the more data you have stored, the
> chances get closer to 100% of losing *some* data in a 2-disk failure.
>
> In the above example, losing A and B means you lose d3, d6, and d7
> (which ends up being 60% of all chunks).
> Losing A and C means you lose d1 (20% of all chunks).OK
> Losing A and D means you lose d9 (20% of all chunks).
> Losing B and C means you lose d10 (20% of all chunks).
> Losing B and D means you lose d2 (20% of all chunks).
> Losing C and D means you lose d4,d5, AND d8 (60% of all chunks)
>
> The above skewed example has an average of 40% of all chunks failed. As=

> you add more data and randomise the allocation, this will approach 50% =
-
> BUT, the chances of losing *some* data is already clearly shown to be
> very close to 100%.
>
OK, I forgot about the randomization effect that the chunk allocation=20
and freeing has.  We really should slap a *BIG* warning label on that=20
(and ideally find some better way to do it so it's more reliable).

As an aside, I've found that a BTRFS raid1 set on top of 2 LVM/MD RAID0=20
sets is actually faster than using a BTRFS raid10 set with the same=20
number of disks (how much faster is workload dependent), and provides=20
better guarantees than a BTRFS raid10 set.


--------------ms030807070603030002030107
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTAyMTk0MTEw
WjAjBgkqhkiG9w0BCQQxFgQU57TLzwS4+cKUcBOv/kZHqWYXJNMwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAI+9bNX+fmAWIDXwv5zSbq2Ezv1U3
f3TJyOgSFEim+ldEEQZhKFokJCIK+vJiT8shdPUxO5DLYBIlqhvwb+Bic4sBLFTb8qxRF8PZ
wWImY01mXzv2zAg9kczGpdkOek5EP6t4t3RrJ1oxAyjJ20+I8yrSbgvyYGUrJ+Sus+6NlJKn
pHK+kic+iDTA5dFxr6khNc0jdw1QeyMQRO9+FV8zoEMZeZy07uUH9k8VWFD3pwWQbgEXSgZk
PcUCe/Xr/5gf9alF87u4IfSocW6zNuDD0/uG+x+mpGQ9kerAghIo8Eiivzvz7l/Go1PLbRzX
kWwbKBPHBWMuCI637hOQkVc7zwAAAAAAAA==
--------------ms030807070603030002030107--
